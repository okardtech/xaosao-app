import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/constants/app_routes.dart';
import 'package:xaosao/models/conversation_model.dart';
import 'package:xaosao/pages/chat/getx/chat_logic.dart';
import 'package:xaosao/widgets/confirm_sheet.dart';
import 'package:xaosao/widgets/notif_badge.dart';

// ═══════════════════════════════════════════════════════════════
//  ChatListPage — ໜ້າລາຍຊື່ chat
// ═══════════════════════════════════════════════════════════════
class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final _logic = Get.find<ChatLogic>();
  final _searchCtrl = TextEditingController();
  String _query = '';
  String _filter = 'all'; // all | unread | online

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() => setState(() => _query = _searchCtrl.text));
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<ConversationModel> _filtered(List<ConversationModel> convs) {
    final role = _logic.myRole;
    var list = convs;
    if (_query.isNotEmpty) {
      list = list.where((c) {
        final other = c.otherParticipant(role);
        final name = other?.displayName.toLowerCase() ?? '';
        final msg = (c.lastMessageText ?? '').toLowerCase();
        final q = _query.toLowerCase();
        return name.contains(q) || msg.contains(q);
      }).toList();
    }
    switch (_filter) {
      case 'unread':
        list = list.where((c) => c.unreadCountFor(role) > 0).toList();
      case 'online':
        list = list.where((c) {
          return c.otherParticipant(role)?.isOnline ?? false;
        }).toList();
    }
    return list;
  }

  // ══════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(children: [
          _buildHeader(),
          _buildSearch(),
          Expanded(child: _buildList()),
        ]),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────
  Widget _buildHeader() {
    return Obx(() {
      final total = _logic.totalUnread;
      return Padding(
        padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 12.h),
        child: Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('ສົນທະນາ', style: TextStyle(
                fontSize: 24.sp, fontWeight: FontWeight.w900,
                color: AppColors.textPrimary, letterSpacing: -0.5,
              )),
              if (total > 0)
                Text('$total ຂໍ້ຄວາມໃໝ່', style: TextStyle(
                    fontSize: 11.sp, color: AppColors.textHint)),
            ]),
          ),
          NotifBadge(
            child: GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.notifications),
              child: Container(
                width: 40.r, height: 40.r,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                      color: Colors.black.withValues(alpha: 0.07), width: 0.5),
                ),
                child: Icon(Icons.notifications_outlined,
                    size: 18.r, color: AppColors.textPrimary),
              ),
            ),
          ),
        ]),
      );
    });
  }

  // ── Search bar ─────────────────────────────────────────────
  Widget _buildSearch() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
              color: Colors.black.withValues(alpha: 0.08), width: 0.5),
        ),
        child: Row(children: [
          Icon(Icons.search_rounded, size: 16.r, color: AppColors.textDisabled),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              controller: _searchCtrl,
              style: TextStyle(fontSize: 12.sp, color: AppColors.textPrimary),
              decoration: InputDecoration(
                isDense: true, border: InputBorder.none,
                hintText: 'ຄົ້ນຫາ...',
                hintStyle:
                    TextStyle(fontSize: 12.sp, color: AppColors.textDisabled),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (_query.isNotEmpty)
            GestureDetector(
              onTap: () => _searchCtrl.clear(),
              child: Icon(Icons.close_rounded,
                  size: 15.r, color: AppColors.textDisabled),
            ),
        ]),
      ),
    );
  }


  // ── Chat list ───────────────────────────────────────────────
  Widget _buildList() {
    return Obx(() {
      final s = _logic.state;

      if (s.status.name == 'loading' && s.conversations.isEmpty) {
        return const Center(
            child: CircularProgressIndicator(strokeWidth: 2));
      }

      if (s.status.name == 'failure' && s.conversations.isEmpty) {
        return _buildError();
      }

      final list = _filtered(s.conversations);
      if (list.isEmpty) return _buildEmpty();

      return RefreshIndicator(
        onRefresh: _logic.fetchConversations,
        color: AppColors.primary,
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(top: 10.h, bottom: 24.h),
          itemCount: list.length,
          separatorBuilder: (_, __) => Divider(
            height: 0, thickness: 0.5,
            indent: 18.w + 50.r + 12.w,
            color: Colors.black.withValues(alpha: 0.05),
          ),
          itemBuilder: (_, i) {
            final conv = list[i];
            final other = conv.otherParticipant(_logic.myRole);
            final name = other?.displayName ?? 'ການສົນທະນານີ້';
            return Dismissible(
              key: ValueKey(conv.id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 20.w),
                color: const Color(0xFFDC2626),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.delete_outline_rounded,
                        color: Colors.white, size: 22.r),
                    SizedBox(height: 4.h),
                    Text('ລຶບ',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        )),
                  ],
                ),
              ),
              confirmDismiss: (_) => ConfirmSheet.show(
                context,
                title: 'ລຶບການສົນທະນາ',
                message:
                    'ລຶບການສົນທະນາກັບ $name?\nຂໍ້ຄວາມຍັງສາມາດເຫັນໄດ້ຈາກອີກຝ່າຍ',
                confirmLabel: 'ລຶບ',
                icon: Icons.delete_outline_rounded,
                isDanger: true,
              ),
              onDismissed: (_) => _logic.deleteConversation(conv.id),
              child: _ChatRow(
                conv: conv,
                myRole: _logic.myRole,
                onTap: () {
                  if (conv.isBlocked) {
                    Get.snackbar(
                      'ບໍ່ສາມາດເຂົ້າໄດ້',
                      conv.iBlockedThis(_logic.myRole)
                          ? 'ທ່ານໄດ້ບລັອກການສົນທະນານີ້'
                          : 'ການສົນທະນານີ້ຖືກບລັອກ',
                      snackPosition: SnackPosition.TOP,
                      duration: const Duration(seconds: 2),
                      backgroundColor: const Color(0xFF1A1A2E),
                      colorText: Colors.white,
                      margin: EdgeInsets.all(14.r),
                      borderRadius: 12.r,
                    );
                    return;
                  }
                  Get.toNamed(
                    AppRoutes.chatDetail,
                    arguments: {'conversationId': conv.id, 'conv': conv},
                  );
                },
                onLongPress: () async {
                  final iBlocked = conv.iBlockedThis(_logic.myRole);
                  final confirmed = await ConfirmSheet.show(
                    context,
                    title: iBlocked ? 'ຍົກເລີກການບລັອກ $name' : 'ບລັອກ $name',
                    message: iBlocked
                        ? 'ຍົກເລີກການບລັອກ ແລະ ສືບຕໍ່ສົນທະນາ?'
                        : 'ທ່ານ ແລະ $name ຈະບໍ່ສາມາດສົ່ງຂໍ້ຄວາມຫາກັນໄດ້',
                    confirmLabel: iBlocked ? 'ຍົກເລີກການບລັອກ' : 'ບລັອກ',
                    icon: iBlocked
                        ? Icons.lock_open_rounded
                        : Icons.block_rounded,
                    iconColor: const Color(0xFFF59E0B),
                    isDanger: !iBlocked,
                  );
                  if (confirmed != true) return;
                  if (iBlocked) {
                    await _logic.unblockConversation(conv.id);
                  } else {
                    await _logic.blockConversation(conv.id);
                  }
                },
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.chat_bubble_outline_rounded,
            size: 48.r, color: AppColors.textDisabled),
        SizedBox(height: 12.h),
        Text('ບໍ່ພົບການສົນທະນາ', style: TextStyle(
            fontSize: 14.sp, fontWeight: FontWeight.w700,
            color: AppColors.textHint)),
      ]),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.wifi_off_rounded, size: 40.r, color: AppColors.textDisabled),
        SizedBox(height: 12.h),
        Text('ໂຫຼດບໍ່ສຳເລັດ', style: TextStyle(
            fontSize: 14.sp, fontWeight: FontWeight.w700,
            color: AppColors.textHint)),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: _logic.fetchConversations,
          child: Text('ລອງໃໝ່', style: TextStyle(
              fontSize: 12.sp, color: AppColors.primary,
              fontWeight: FontWeight.w700)),
        ),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _ChatRow — single conversation row
// ═══════════════════════════════════════════════════════════════
class _ChatRow extends StatelessWidget {
  final ConversationModel conv;
  final String myRole;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const _ChatRow({
    required this.conv,
    required this.myRole,
    required this.onTap,
    this.onLongPress,
  });

  static const _gradients = [
    [Color(0xFF5C6BC0), Color(0xFF1A1A2E)],
    [Color(0xFFf093fb), Color(0xFFc2185b)],
    [Color(0xFF43e97b), Color(0xFF1A5276)],
    [Color(0xFFfa709a), Color(0xFF7B1FA2)],
    [Color(0xFF4facfe), Color(0xFF1A237E)],
  ];

  List<Color> get _gradient {
    final idx = conv.id.codeUnits.fold(0, (a, b) => a + b) % _gradients.length;
    return _gradients[idx].cast<Color>();
  }

  String get _timeLabel {
    final t = conv.lastMessageAt;
    if (t == null) return '';
    final now = DateTime.now();
    final diff = now.difference(t);
    if (diff.inMinutes < 60) {
      final h = t.hour.toString().padLeft(2, '0');
      final m = t.minute.toString().padLeft(2, '0');
      return '$h:$m';
    }
    if (diff.inDays == 0) return 'ມື້ນີ້';
    if (diff.inDays == 1) return 'ມື້ວານ';
    if (diff.inDays < 7) return '${diff.inDays} ວັນ';
    const days = ['ອາ', 'ຈ', 'ອ', 'ພ', 'ພຫ', 'ສຸ', 'ສ'];
    return '${days[t.weekday % 7]}. ${t.day}';
  }

  @override
  Widget build(BuildContext context) {
    final other = conv.otherParticipant(myRole);
    final name = other?.displayName ?? 'Unknown';
    final imageUrl = other?.profileImage;
    final isOnline = other?.isOnline ?? false;
    final isBlocked = conv.isBlocked;
    final hasUnread = !isBlocked && conv.unreadCountFor(myRole) > 0;
    final lastMsg = conv.lastMessageText ?? '';

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      behavior: HitTestBehavior.opaque,
      child: Opacity(
        opacity: isBlocked ? 0.55 : 1.0,
        child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
        child: Row(children: [
          // Avatar + online dot
          _ConvAvatar(
              name: name, imageUrl: imageUrl,
              gradient: _gradient, isOnline: isOnline && !isBlocked),
          SizedBox(width: 12.w),

          // Name + message
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(
                  child: Row(children: [
                    Flexible(
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isBlocked) ...[
                      SizedBox(width: 6.w),
                      Icon(Icons.block_rounded,
                          size: 12.r, color: const Color(0xFFF59E0B)),
                    ],
                  ]),
                ),
                Text(_timeLabel, style: TextStyle(
                    fontSize: 10.sp, color: AppColors.textSecondary)),
              ]),
              SizedBox(height: 3.h),
              Row(children: [
                Expanded(
                  child: Text(
                    isBlocked ? 'ການສົນທະນາຖືກບລັອກ' : lastMsg,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isBlocked
                          ? const Color(0xFFF59E0B)
                          : hasUnread
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                      fontWeight: hasUnread
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(width: 6.w),
                if (hasUnread)
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text('${conv.unreadCountFor(myRole)}', style: TextStyle(
                        fontSize: 9.sp, fontWeight: FontWeight.w800,
                        color: Colors.white)),
                  ),
              ]),
            ]),
          ),
        ]),
      ),
    ),
  );
  }
}

// ── Avatar ─────────────────────────────────────────────────────
class _ConvAvatar extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final List<Color> gradient;
  final bool isOnline;

  const _ConvAvatar({
    required this.name,
    this.imageUrl,
    required this.gradient,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        width: 50.r, height: 50.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
        ),
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? ClipOval(
                child: Image.network(imageUrl!, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _Initials(name: name)))
            : _Initials(name: name),
      ),
      Positioned(
        bottom: 1, right: 1,
        child: Container(
          width: 13.r, height: 13.r,
          decoration: BoxDecoration(
            color: isOnline ? AppColors.online : AppColors.textDisabled,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.bg, width: 2),
          ),
        ),
      ),
    ]);
  }
}

class _Initials extends StatelessWidget {
  final String name;
  const _Initials({required this.name});

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return Center(
      child: Text(initial, style: TextStyle(
          fontSize: 18.sp, fontWeight: FontWeight.w800, color: Colors.white)),
    );
  }
}
