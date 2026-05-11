import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/pages/chat/components/chat_detail_page.dart';
import 'package:xaosao/pages/chat/components/chat_model.dart';

// ═══════════════════════════════════════════════════════════════
//  ChatListPage — ໜ້າລາຍຊື່ chat
//  Features: search · filter chips · unread badge · read status
// ═══════════════════════════════════════════════════════════════
class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final _searchCtrl = TextEditingController();
  String _query      = '';
  String _filter     = 'all'; // all | unread | booking | online

  static const _filters = [
    {'id': 'all',     'label': 'ທັງໝົດ'},
    {'id': 'unread',  'label': 'ຍັງບໍ່ໄດ້ອ່ານ'},
    {'id': 'booking', 'label': 'ຈອງ'},
    {'id': 'online',  'label': 'ອອນລາຍ'},
  ];

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

  List<ChatPreview> get _filtered {
    var list = mockChatPreviews;
    if (_query.isNotEmpty) {
      list = list.where((c) =>
          c.name.toLowerCase().contains(_query.toLowerCase()) ||
          c.lastMessage.toLowerCase().contains(_query.toLowerCase())).toList();
    }
    switch (_filter) {
      case 'unread':  list = list.where((c) => c.unreadCount > 0).toList();
      case 'booking': list = list.where((c) => c.lastMessage.contains('📅')).toList();
      case 'online':  list = list.where((c) => c.isOnline).toList();
    }
    return list;
  }

  int get _totalUnread =>
      mockChatPreviews.fold(0, (sum, c) => sum + c.unreadCount);

  // ══════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      body: SafeArea(
        child: Column(children: [
          _buildHeader(),
          _buildSearch(),
          _buildFilterChips(),
          Expanded(child: _buildList()),
        ]),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 12.h),
      child: Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('ສົນທະນາ', style: TextStyle(
              fontSize: 24.sp, fontWeight: FontWeight.w900,
              color: const Color(0xFF1A1A2E), letterSpacing: -0.5,
            )),
            if (_totalUnread > 0)
              Text('$_totalUnread ຂໍ້ຄວາມໃໝ່', style: TextStyle(
                fontSize: 11.sp, color: const Color(0xFF9B9BAD))),
          ]),
        ),
      ]),
    );
  }

  // ── Search bar ─────────────────────────────────────────────
  Widget _buildSearch() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: Colors.black.withOpacity(0.08), width: 0.5),
        ),
        child: Row(children: [
          Icon(Icons.search_rounded, size: 16.r, color: const Color(0xFFC4C4D0)),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              controller: _searchCtrl,
              style: TextStyle(fontSize: 12.sp, color: const Color(0xFF1A1A2E)),
              decoration: InputDecoration(
                isDense: true, border: InputBorder.none,
                hintText: 'ຄົ້ນຫາຊື່ ຫຼື ຂໍ້ຄວາມ...',
                hintStyle: TextStyle(fontSize: 12.sp, color: const Color(0xFFC4C4D0)),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (_query.isNotEmpty)
            GestureDetector(
              onTap: () => _searchCtrl.clear(),
              child: Icon(Icons.close_rounded, size: 15.r, color: const Color(0xFFC4C4D0)),
            ),
        ]),
      ),
    );
  }

  // ── Filter chips ────────────────────────────────────────────
  Widget _buildFilterChips() {
    return SizedBox(
      height: 36.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(18.w, 10.h, 18.w, 0),
        children: _filters.map((f) {
          final isOn = _filter == f['id'];
          return Padding(
            padding: EdgeInsets.only(right: 6.w),
            child: GestureDetector(
              onTap: () => setState(() => _filter = f['id']!),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isOn ? const Color(0xFF1A1A2E) : Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isOn
                        ? const Color(0xFF1A1A2E)
                        : Colors.black.withOpacity(0.09),
                    width: 0.5,
                  ),
                ),
                child: Text(f['label']!, style: TextStyle(
                  fontSize: 11.sp, fontWeight: FontWeight.w700,
                  color: isOn ? Colors.white : const Color(0xFF9B9BAD),
                )),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Chat list ───────────────────────────────────────────────
  Widget _buildList() {
    final list = _filtered;
    if (list.isEmpty) return _buildEmpty();

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(top: 10.h, bottom: 24.h),
      itemCount: list.length,
      separatorBuilder: (_, __) => Divider(
        height: 0, thickness: 0.5,
        indent: 18.w + 50.r + 12.w,
        color: Colors.black.withOpacity(0.05),
      ),
      itemBuilder: (_, i) => _ChatRow(
        chat: list[i],
        onTap: () => Navigator.push(context, MaterialPageRoute(
          builder: (_) => ChatDetailPage(chat: list[i]),
        )),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.chat_bubble_outline_rounded,
            size: 48.r, color: const Color(0xFFD1D1E0)),
        SizedBox(height: 12.h),
        Text('ບໍ່ພົບການສົນທະນາ', style: TextStyle(
            fontSize: 14.sp, fontWeight: FontWeight.w700,
            color: const Color(0xFF9B9BAD))),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _ChatRow — single row in list
// ═══════════════════════════════════════════════════════════════
class _ChatRow extends StatelessWidget {
  final ChatPreview chat;
  final VoidCallback onTap;

  const _ChatRow({required this.chat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasUnread = chat.unreadCount > 0;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
        child: Row(children: [
          // Avatar + online dot
          _ChatAvatar(chat: chat),
          SizedBox(width: 12.w),

          // Name + message
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(
                  child: Text(
                    '${chat.name}, ${chat.age}',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                ),
                Text(chat.timeLabel, style: TextStyle(
                    fontSize: 10.sp, color: const Color(0xFFC4C4D0))),
              ]),
              SizedBox(height: 3.h),
              Row(children: [
                Expanded(
                  child: Text(
                    chat.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: hasUnread
                          ? const Color(0xFF1A1A2E)
                          : const Color(0xFF9B9BAD),
                      fontWeight: hasUnread
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(width: 6.w),
                // Trailing: unread count OR tick status
                if (hasUnread)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF06292),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text('${chat.unreadCount}', style: TextStyle(
                        fontSize: 9.sp, fontWeight: FontWeight.w800,
                        color: Colors.white)),
                  )
                else if (chat.lastIsMe)
                  _TickIcon(status: chat.lastStatus),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }
}

// ── Avatar ─────────────────────────────────────────────────────
class _ChatAvatar extends StatelessWidget {
  final ChatPreview chat;
  const _ChatAvatar({required this.chat});

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
            colors: chat.gradient,
          ),
        ),
        child: chat.imageUrl != null && chat.imageUrl!.isNotEmpty
            ? ClipOval(child: Image.network(
                chat.imageUrl!, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox()))
            : null,
      ),
      Positioned(
        bottom: 1, right: 1,
        child: Container(
          width: 13.r, height: 13.r,
          decoration: BoxDecoration(
            color: chat.isOnline
                ? const Color(0xFF22C55E)
                : const Color(0xFFD1D1E0),
            shape: BoxShape.circle,
            border: Border.all(
                color: const Color(0xFFF8F8FC), width: 2),
          ),
        ),
      ),
    ]);
  }
}

// ── Tick icon ──────────────────────────────────────────────────
class _TickIcon extends StatelessWidget {
  final MessageStatus status;
  const _TickIcon({required this.status});

  @override
  Widget build(BuildContext context) {
    if (status == MessageStatus.sending) {
      return Icon(Icons.access_time_rounded,
          size: 12.r, color: const Color(0xFFC4C4D0));
    }
    final isRead  = status == MessageStatus.read;
    final color   = isRead ? const Color(0xFF42A5F5) : const Color(0xFFC4C4D0);
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.done_rounded, size: 13.r, color: color),
      if (isRead)
        Transform.translate(
          offset: Offset(-5.w, 0),
          child: Icon(Icons.done_rounded, size: 13.r, color: color),
        ),
    ]);
  }
}