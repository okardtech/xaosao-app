import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/models/chat_message_model.dart';
import 'package:xaosao/models/conversation_model.dart';
import 'package:xaosao/pages/chat/getx/chat_logic.dart';
import 'package:xaosao/pages/chat/getx/chat_state.dart';
import 'package:xaosao/widgets/confirm_sheet.dart';
import 'package:xaosao/widgets/gradient_app_bar.dart';

// ═══════════════════════════════════════════════════════════════
//  ChatDetailPage — real-time conversation
// ═══════════════════════════════════════════════════════════════
class ChatDetailPage extends StatefulWidget {
  final String conversationId;
  final ConversationModel conv;

  const ChatDetailPage({
    super.key,
    required this.conversationId,
    required this.conv,
  });

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final _inputCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  final _focusNode = FocusNode();
  final _logic = Get.find<ChatLogic>();

  bool _canSend = false;
  bool _showEmoji = false;
  bool _isSending = false;
  File? _pendingImage;

  static const _gradients = [
    [Color(0xFF5C6BC0), Color(0xFF1A1A2E)],
    [Color(0xFFf093fb), Color(0xFFc2185b)],
    [Color(0xFF43e97b), Color(0xFF1A5276)],
    [Color(0xFFfa709a), Color(0xFF7B1FA2)],
    [Color(0xFF4facfe), Color(0xFF1A237E)],
  ];

  List<Color> get _gradient {
    final idx = widget.conversationId.codeUnits
            .fold(0, (a, b) => a + b) %
        _gradients.length;
    return _gradients[idx].cast<Color>();
  }

  ConversationParticipant? get _other =>
      widget.conv.otherParticipant(_logic.myRole);

  String get _partnerName => _other?.displayName ?? 'Unknown';
  String? get _partnerImage => _other?.profileImage;
  bool get _isOnline => _other?.isOnline ?? false;

  @override
  void initState() {
    super.initState();
    _inputCtrl.addListener(() => setState(
        () => _canSend = _inputCtrl.text.trim().isNotEmpty || _pendingImage != null));

    // When keyboard appears, close emoji picker
    _focusNode.addListener(() {
      if (_focusNode.hasFocus && _showEmoji) {
        setState(() => _showEmoji = false);
      }
    });

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _logic.enterConversation(widget.conversationId);
      _scrollToBottom(animate: false);
    });
  }

  @override
  void dispose() {
    _logic.leaveConversation(widget.conversationId);
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // ── Emoji toggle ────────────────────────────────────────────
  void _toggleEmoji() {
    if (_showEmoji) {
      setState(() => _showEmoji = false);
      _focusNode.requestFocus();
    } else {
      FocusScope.of(context).unfocus();
      Future.delayed(const Duration(milliseconds: 80), () {
        if (mounted) setState(() => _showEmoji = true);
      });
    }
  }

  void _scrollToBottom({bool animate = true}) {
    if (!_scrollCtrl.hasClients) return;
    if (animate) {
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _scrollCtrl.jumpTo(_scrollCtrl.position.maxScrollExtent);
    }
  }

  Future<void> _pickImage() async {
    final xFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1920,
    );
    if (xFile == null || !mounted) return;
    setState(() {
      _pendingImage = File(xFile.path);
      _canSend = true;
    });
  }

  Future<void> _sendMessage() async {
    if (_isSending) return;
    final text = _inputCtrl.text.trim();
    if (text.isEmpty && _pendingImage == null) return;

    final imageToSend = _pendingImage;
    setState(() {
      _isSending = true;
      _pendingImage = null;
      _canSend = false;
    });
    _inputCtrl.clear();

    final ok = await _logic.sendMessage(
      widget.conversationId,
      text,
      imageFile: imageToSend,
    );

    if (!mounted) return;
    setState(() => _isSending = false);
    if (ok) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    } else {
      Get.snackbar(
        'ສົ່ງບໍ່ສຳເລັດ', 'ກະລຸນາລອງໃໝ່',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade700,
        margin: EdgeInsets.all(12.r),
        borderRadius: 12.r,
        duration: const Duration(seconds: 2),
      );
    }
  }

  // ══════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    
    return PopScope(
      canPop: !_showEmoji,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _showEmoji) setState(() => _showEmoji = false);
      },
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: GradientAppBar(
          title: _partnerName,
          titleWidget: _buildAppBarTitle(),
          expandedHeight: 62,
        ),
        body: Column(children: [
          Expanded(child: _buildMessageList()),
          SafeArea(top: false, child: _buildInput()),
          // Emoji picker panel — shown/hidden without remounting
          Offstage(
            offstage: !_showEmoji,
            child: _buildEmojiPicker(),
          ),
        ]),
      ),
    );
  }

  // ── AppBar title widget (avatar + name + typing) ────────────
  Widget _buildAppBarTitle() {
    return Row(children: [
      Stack(children: [
        Container(
          width: 36.r,
          height: 36.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _gradient,
            ),
          ),
          child: _partnerImage != null && _partnerImage!.isNotEmpty
              ? ClipOval(
                  child: Image.network(
                    _partnerImage!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        _Initials(name: _partnerName, size: 13.sp),
                  ),
                )
              : _Initials(name: _partnerName, size: 13.sp),
        ),
        Positioned(
          bottom: 1,
          right: 1,
          child: Container(
            width: 10.r,
            height: 10.r,
            decoration: BoxDecoration(
              color: _isOnline ? AppColors.online : Colors.white38,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.5),
            ),
          ),
        ),
      ]),
      SizedBox(width: 10.w),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _partnerName,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1.2,
              ),
            ),
            Obx(() {
              final ms = _logic.msgStateOf(widget.conversationId);
              final label = ms.isPartnerTyping
                  ? 'ກຳລັງພິມ...'
                  : (_isOnline ? 'ອອນລາຍ' : 'ອອຟລາຍ');
              return Text(
                label,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              );
            }),
          ],
        ),
      ),
    ]);
  }

  // ── Message list ────────────────────────────────────────────
  Widget _buildMessageList() {
    return Obx(() {
      final ms = _logic.msgStateOf(widget.conversationId);

      if (ms.status == MsgLoadStatus.loading && ms.messages.isEmpty) {
        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
      }

      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

      return ListView.builder(
        controller: _scrollCtrl,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        itemCount: ms.messages.length + (ms.isPartnerTyping ? 1 : 0) + 1,
        itemBuilder: (_, i) {
          if (i == 0) return _DateDivider(label: 'ມື້ນີ້');

          final msgIndex = i - 1;
          if (ms.isPartnerTyping && msgIndex == ms.messages.length) {
            return _TypingBubble(gradient: _gradient);
          }

          final msg = ms.messages[msgIndex];
          final isMe = _logic.isMe(msg.senderType);

          return Padding(
            padding: EdgeInsets.only(bottom: 4.h),
            child: _TextBubble(
              msg: msg,
              isMe: isMe,
              gradient: _gradient,
              partnerImage: _partnerImage,
              onLongPress: () => _showMessageOptionsSheet(msg),
            ),
          );
        },
      );
    });
  }

  // ── Input bar ───────────────────────────────────────────────
  Widget _buildInput() {
    final canAct = _canSend && !_isSending;
    return Container(
      padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 14.h),
      color: AppColors.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Pending image preview ──────────────────────────
          if (_pendingImage != null)
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(children: [
                Stack(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Image.file(
                      _pendingImage!,
                      width: 64.r,
                      height: 64.r,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _pendingImage = null;
                        _canSend = _inputCtrl.text.trim().isNotEmpty;
                      }),
                      child: Container(
                        width: 18.r,
                        height: 18.r,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.close_rounded,
                            size: 11.r, color: Colors.white),
                      ),
                    ),
                  ),
                ]),
                SizedBox(width: 8.w),
                Text('ຮູບພາບທີ່ເລືອກ',
                    style: TextStyle(
                        fontSize: 11.sp, color: AppColors.textHint)),
              ]),
            ),

          // ── Input row ──────────────────────────────────────
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            // Emoji toggle
            GestureDetector(
              onTap: _toggleEmoji,
              child: Padding(
                padding: EdgeInsets.only(bottom: 8.h, right: 4.w),
                child: Icon(
                  _showEmoji
                      ? Icons.keyboard_rounded
                      : Icons.emoji_emotions_outlined,
                  size: 24.r,
                  color:
                      _showEmoji ? AppColors.primary : AppColors.textDisabled,
                ),
              ),
            ),

            // Image picker button
            GestureDetector(
              onTap: _isSending ? null : _pickImage,
              child: Padding(
                padding: EdgeInsets.only(bottom: 8.h, right: 6.w),
                child: Icon(
                  Icons.image_outlined,
                  size: 24.r,
                  color: _pendingImage != null
                      ? AppColors.primary
                      : AppColors.textDisabled,
                ),
              ),
            ),

            // Text field
            Expanded(
              child: Container(
                constraints: BoxConstraints(minHeight: 36.h),
                decoration: BoxDecoration(
                  color: AppColors.bg,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                      color: Colors.black.withValues(alpha: 0.08),
                      width: 0.5),
                ),
                child: TextField(
                  controller: _inputCtrl,
                  focusNode: _focusNode,
                  maxLines: 4,
                  minLines: 1,
                  style: TextStyle(
                      fontSize: 12.5.sp, color: AppColors.textPrimary),
                  onChanged: (_) => _logic.onTyping(widget.conversationId),
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: 'ພິມຂໍ້ຄວາມ...',
                    hintStyle: TextStyle(
                        fontSize: 12.5.sp, color: AppColors.textDisabled),
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 13.w, vertical: 9.h),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),

            // Send button
            GestureDetector(
              onTap: canAct ? _sendMessage : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  gradient: canAct
                      ? const LinearGradient(
                          colors: AppColors.pinkGradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: canAct
                      ? null
                      : AppColors.textDisabled.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: _isSending
                    ? Padding(
                        padding: EdgeInsets.all(9.r),
                        child: const CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : Icon(Icons.send_rounded,
                        size: 16.r,
                        color:
                            canAct ? Colors.white : AppColors.textDisabled),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  // ── Emoji picker panel ──────────────────────────────────────
  Widget _buildEmojiPicker() {
    return SizedBox(
      height: 256.h,
      child: EmojiPicker(
        textEditingController: _inputCtrl,
        onEmojiSelected: (_, __) {
          setState(() => _canSend = _inputCtrl.text.trim().isNotEmpty);
          WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
        },
        config: Config(
          height: 256.h,
          checkPlatformCompatibility: true,
          emojiViewConfig: EmojiViewConfig(
            emojiSizeMax: 28 * (Platform.isIOS ? 1.2 : 1.0),
            backgroundColor: AppColors.surface,
          ),
          categoryViewConfig: CategoryViewConfig(
            backgroundColor: AppColors.surface,
            indicatorColor: AppColors.primary,
            iconColorSelected: AppColors.primary,
            iconColor: AppColors.textDisabled,
          ),
          bottomActionBarConfig: BottomActionBarConfig(
            backgroundColor: AppColors.surface,
            buttonColor: AppColors.primary,
          ),
          searchViewConfig: SearchViewConfig(
            backgroundColor: AppColors.surface,
          ),
        ),
      ),
    );
  }

  // ── Message delete (long-press) ────────────────────────────
  Future<void> _showMessageOptionsSheet(ChatMessageModel msg) async {
    final confirmed = await ConfirmSheet.show(
      context,
      title: 'ລຶບຂໍ້ຄວາມ',
      message: 'ຂໍ້ຄວາມຈະຖືກລຶບອອກຈາກຝ່າຍຂອງທ່ານເທົ່ານັ້ນ\nອີກຝ່າຍຍັງສາມາດເຫັນຂໍ້ຄວາມໄດ້',
      confirmLabel: 'ລຶບ',
      icon: Icons.delete_outline_rounded,
      isDanger: true,
    );
    if (confirmed == true && mounted) {
      _logic.deleteMessage(widget.conversationId, msg.id);
    }
  }
}

// ═══════════════════════════════════════════════════════════════
//  Sub-widgets
// ═══════════════════════════════════════════════════════════════

class _Initials extends StatelessWidget {
  final String name;
  final double size;
  const _Initials({required this.name, this.size = 16});

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return Center(
      child: Text(initial,
          style: TextStyle(
              fontSize: size,
              fontWeight: FontWeight.w800,
              color: Colors.white)),
    );
  }
}

class _DateDivider extends StatelessWidget {
  final String label;
  const _DateDivider({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Center(
        child: Text(label,
            style: TextStyle(
                fontSize: 10.sp,
                color: AppColors.textDisabled,
                fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _TextBubble extends StatelessWidget {
  final ChatMessageModel msg;
  final bool isMe;
  final List<Color> gradient;
  final String? partnerImage;
  final VoidCallback? onLongPress;

  const _TextBubble({
    required this.msg,
    required this.isMe,
    required this.gradient,
    this.partnerImage,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Row(
      mainAxisAlignment:
          isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!isMe)
          Container(
            width: 26.r,
            height: 26.r,
            margin: EdgeInsets.only(right: 6.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradient),
            ),
            child: partnerImage != null && partnerImage!.isNotEmpty
                ? ClipOval(
                    child: Image.network(partnerImage!, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const SizedBox()))
                : null,
          ),
        Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: 220.w),
              padding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
              decoration: BoxDecoration(
                color: isMe ? AppColors.textPrimary : AppColors.surface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.r),
                  topRight: Radius.circular(18.r),
                  bottomLeft: Radius.circular(isMe ? 18.r : 5.r),
                  bottomRight: Radius.circular(isMe ? 5.r : 18.r),
                ),
                border: isMe
                    ? null
                    : Border.all(
                        color: Colors.black.withValues(alpha: 0.08),
                        width: 0.5),
              ),
              child: msg.messageType == 'image' && msg.fileUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: Image.network(msg.fileUrl!,
                          width: 180.w, fit: BoxFit.cover))
                  : Text(
                      msg.messageText ?? '',
                      style: TextStyle(
                        fontSize: 12.5.sp,
                        height: 1.55,
                        color:
                            isMe ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
            ),
            SizedBox(height: 3.h),
            Row(children: [
              Text(msg.timeString,
                  style: TextStyle(
                      fontSize: 9.sp, color: AppColors.textHint)),
              if (isMe) ...[
                SizedBox(width: 3.w),
                _TickWidget(isRead: msg.isRead),
              ],
            ]),
          ],
        ),
      ],
    ),
    );
  }
}

class _TickWidget extends StatelessWidget {
  final bool isRead;
  const _TickWidget({required this.isRead});

  @override
  Widget build(BuildContext context) {
    final color = isRead ? const Color(0xFF42A5F5) : AppColors.textDisabled;
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.done_rounded, size: 12.r, color: color),
      if (isRead)
        Transform.translate(
          offset: Offset(-5.w, 0),
          child: Icon(Icons.done_rounded, size: 12.r, color: color),
        ),
    ]);
  }
}

class _TypingBubble extends StatelessWidget {
  final List<Color> gradient;
  const _TypingBubble({required this.gradient});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: 26.r,
          height: 26.r,
          margin: EdgeInsets.only(right: 6.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradient),
          ),
        ),
        Container(
          padding:
              EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18.r),
              topRight: Radius.circular(18.r),
              bottomRight: Radius.circular(18.r),
              bottomLeft: Radius.circular(5.r),
            ),
            border: Border.all(
                color: Colors.black.withValues(alpha: 0.08), width: 0.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              3,
              (i) => Container(
                width: 6.r,
                height: 6.r,
                margin: EdgeInsets.only(right: i < 2 ? 4.w : 0),
                decoration: BoxDecoration(
                    color: AppColors.textDisabled,
                    shape: BoxShape.circle),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

