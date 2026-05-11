import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'chat_model.dart';

// ═══════════════════════════════════════════════════════════════
//  ChatDetailPage — ໜ້າ chat ລາຍລະອຽດ
// ═══════════════════════════════════════════════════════════════
class ChatDetailPage extends StatefulWidget {
  final ChatPreview chat;
  const ChatDetailPage({super.key, required this.chat});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final _inputCtrl   = TextEditingController();
  final _scrollCtrl  = ScrollController();
  late final List<ChatMessage> _messages;
  bool _canSend      = false;
  bool _isTyping     = false; // simulate other side typing

  @override
  void initState() {
    super.initState();
    _messages = List.of(mockMessages);
    _inputCtrl.addListener(() {
      setState(() => _canSend = _inputCtrl.text.trim().isNotEmpty);
    });
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    // Scroll to bottom after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollCtrl.hasClients) {
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final text = _inputCtrl.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        id:        DateTime.now().millisecondsSinceEpoch.toString(),
        isMe:      true,
        type:      MessageType.text,
        text:      text,
        timestamp: DateTime.now(),
        status:    MessageStatus.sent,
      ));
    });
    _inputCtrl.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _handleBooking(int msgIndex, bool accept) {
    setState(() {
      final msg = _messages[msgIndex];
      _messages[msgIndex] = msg.copyWith(
        booking: msg.booking!.copyWith(accepted: accept),
      );
    });
  }

  // ══════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      body: SafeArea(
        child: Column(children: [
          _buildHeader(),
          Expanded(child: _buildMessageList()),
          _buildInput(),
        ]),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────
  Widget _buildHeader() {
    final c = widget.chat;
    return Container(
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
      color: Colors.white,
      child: Row(children: [
        // Back
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: Icon(Icons.arrow_back_ios_new_rounded,
                size: 16.r, color: const Color(0xFF1A1A2E)),
          ),
        ),

        // Avatar
        Stack(children: [
          Container(
            width: 38.r, height: 38.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: c.gradient,
              ),
            ),
          ),
          Positioned(
            bottom: 1, right: 1,
            child: Container(
              width: 11.r, height: 11.r,
              decoration: BoxDecoration(
                color: c.isOnline
                    ? const Color(0xFF22C55E)
                    : const Color(0xFFD1D1E0),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
        ]),
        SizedBox(width: 10.w),

        // Name + status
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${c.name}, ${c.age}', style: TextStyle(
              fontSize: 14.sp, fontWeight: FontWeight.w800,
              color: const Color(0xFF1A1A2E), letterSpacing: -0.2,
            )),
            SizedBox(height: 1.h),
            Row(children: [
              Container(
                width: 5.r, height: 5.r,
                decoration: BoxDecoration(
                  color: c.isOnline
                      ? const Color(0xFF22C55E)
                      : const Color(0xFFC4C4D0),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 4.w),
              Text(c.isOnline ? 'ອອນລາຍ' : 'ອອຟລາຍ', style: TextStyle(
                fontSize: 10.sp, fontWeight: FontWeight.w600,
                color: c.isOnline
                    ? const Color(0xFF22C55E)
                    : const Color(0xFFC4C4D0),
              )),
            ]),
          ]),
        ),

        // Action buttons
        _HeaderIconBtn(
          icon: Icons.phone_outlined,
          onTap: () {},
        ),
        SizedBox(width: 6.w),
        _HeaderIconBtn(
          icon: Icons.more_vert_rounded,
          onTap: () => _showMoreSheet(),
        ),
      ]),
    );
  }

  // ── Message list ────────────────────────────────────────────
  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollCtrl,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      itemCount: _messages.length + (_isTyping ? 1 : 0) + 1, // +1 date divider
      itemBuilder: (_, i) {
        if (i == 0) return _DateDivider(label: 'ມື້ນີ້');

        final msgIndex = i - 1;
        if (_isTyping && msgIndex == _messages.length) {
          return _TypingBubble(gradient: widget.chat.gradient);
        }

        final msg = _messages[msgIndex];
        return Padding(
          padding: EdgeInsets.only(bottom: 4.h),
          child: msg.type == MessageType.booking
              ? _BookingBubble(
                  msg: msg,
                  onAccept: () => _handleBooking(msgIndex, true),
                  onDecline: () => _handleBooking(msgIndex, false),
                )
              : _TextBubble(
                  msg: msg,
                  gradient: widget.chat.gradient,
                ),
        );
      },
    );
  }

  // ── Input bar ───────────────────────────────────────────────
  Widget _buildInput() {
    return Container(
      padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 14.h),
      color: Colors.white,
      child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        // Attach
        GestureDetector(
          onTap: () {},
          child: Container(
            width: 34.r, height: 34.r,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8FC),
              borderRadius: BorderRadius.circular(11.r),
              border: Border.all(
                  color: Colors.black.withOpacity(0.07), width: 0.5),
            ),
            child: Icon(Icons.attach_file_rounded,
                size: 16.r, color: const Color(0xFF9B9BAD)),
          ),
        ),
        SizedBox(width: 8.w),

        // Text field
        Expanded(
          child: Container(
            constraints: BoxConstraints(minHeight: 36.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8FC),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                  color: Colors.black.withOpacity(0.08), width: 0.5),
            ),
            child: TextField(
              controller: _inputCtrl,
              maxLines: 4,
              minLines: 1,
              style: TextStyle(
                  fontSize: 12.5.sp, color: const Color(0xFF1A1A2E)),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: 'ພິມຂໍ້ຄວາມ...',
                hintStyle: TextStyle(
                    fontSize: 12.5.sp, color: const Color(0xFFC4C4D0)),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 13.w, vertical: 9.h),
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),

        // Send button
        GestureDetector(
          onTap: _canSend ? _sendMessage : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 36.r, height: 36.r,
            decoration: BoxDecoration(
              color: _canSend
                  ? const Color(0xFF1A1A2E)
                  : const Color(0xFFE0E0E0),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.send_rounded,
                size: 16.r,
                color: _canSend
                    ? Colors.white
                    : const Color(0xFFC4C4D0)),
          ),
        ),
      ]),
    );
  }

  // ── More bottom sheet ───────────────────────────────────────
  void _showMoreSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))),
      builder: (_) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 36.w, height: 4.h,
              decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2.r)),
            ),
            SizedBox(height: 20.h),
            _SheetRow(icon: Icons.block_outlined, label: 'ແບ໋ນຜູ້ໃຊ້',
                onTap: () => Navigator.pop(context)),
            _SheetRow(icon: Icons.delete_outline_rounded, label: 'ລຶບການສົນທະນາ',
                isRed: true, onTap: () => Navigator.pop(context)),
          ]),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Sub-widgets
// ═══════════════════════════════════════════════════════════════

class _DateDivider extends StatelessWidget {
  final String label;
  const _DateDivider({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Center(
        child: Text(label, style: TextStyle(
            fontSize: 10.sp, color: const Color(0xFFC4C4D0),
            fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _TextBubble extends StatelessWidget {
  final ChatMessage msg;
  final List<Color> gradient;
  const _TextBubble({required this.msg, required this.gradient});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          msg.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!msg.isMe)
          Container(
            width: 26.r, height: 26.r,
            margin: EdgeInsets.only(right: 6.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradient),
            ),
          ),
        Column(
          crossAxisAlignment: msg.isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: 220.w),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
              decoration: BoxDecoration(
                color: msg.isMe ? const Color(0xFF1A1A2E) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft:     Radius.circular(18.r),
                  topRight:    Radius.circular(18.r),
                  bottomLeft:  Radius.circular(msg.isMe ? 18.r : 5.r),
                  bottomRight: Radius.circular(msg.isMe ? 5.r : 18.r),
                ),
                border: msg.isMe ? null : Border.all(
                    color: Colors.black.withOpacity(0.08), width: 0.5),
              ),
              child: Text(
                msg.text ?? '',
                style: TextStyle(
                  fontSize: 12.5.sp, height: 1.55,
                  color: msg.isMe
                      ? Colors.white
                      : const Color(0xFF1A1A2E),
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Row(children: [
              Text(msg.timeString, style: TextStyle(
                  fontSize: 9.sp, color: const Color(0xFF9B9BAD))),
              if (msg.isMe) ...[
                SizedBox(width: 3.w),
                _TickWidget(status: msg.status),
              ],
            ]),
          ],
        ),
      ],
    );
  }
}

class _TickWidget extends StatelessWidget {
  final MessageStatus status;
  const _TickWidget({required this.status});

  @override
  Widget build(BuildContext context) {
    if (status == MessageStatus.sending) {
      return Icon(Icons.access_time_rounded,
          size: 11.r, color: const Color(0xFFC4C4D0));
    }
    final isRead = status == MessageStatus.read;
    final color  = isRead ? const Color(0xFF42A5F5) : const Color(0xFFC4C4D0);
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

class _BookingBubble extends StatelessWidget {
  final ChatMessage msg;
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  const _BookingBubble({
    required this.msg,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    final b = msg.booking!;
    final isPending  = b.accepted == null;
    final isAccepted = b.accepted == true;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(width: 32.r),
        Container(
          constraints: BoxConstraints(maxWidth: 240.w),
          padding: EdgeInsets.all(13.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
                color: Colors.black.withOpacity(0.08), width: 0.5),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('📅 ຄຳຂໍຈອງ', style: TextStyle(
                fontSize: 9.sp, fontWeight: FontWeight.w700,
                color: const Color(0xFF9B9BAD), letterSpacing: 0.5)),
            SizedBox(height: 8.h),

            // Card
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8FC),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                    color: Colors.black.withOpacity(0.07), width: 0.5),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(b.serviceName, style: TextStyle(
                    fontSize: 12.sp, fontWeight: FontWeight.w800,
                    color: const Color(0xFF1A1A2E))),
                SizedBox(height: 6.h),
                Row(children: [
                  _BookMeta(icon: Icons.calendar_month_outlined, text: b.formattedDate),
                  SizedBox(width: 10.w),
                  _BookMeta(icon: Icons.access_time_rounded,
                      text: '${b.durationHours} ຊ.ມ.'),
                ]),
                SizedBox(height: 6.h),
                Text(b.formattedPrice, style: TextStyle(
                    fontSize: 13.sp, fontWeight: FontWeight.w900,
                    color: const Color(0xFFF06292), letterSpacing: -0.3)),
              ]),
            ),

            SizedBox(height: 10.h),

            // Buttons
            if (isPending)
              Row(children: [
                Expanded(
                  child: _BookBtn(
                    label: 'ຍອມຮັບ', isDark: true, onTap: onAccept),
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: _BookBtn(
                    label: 'ປະຕິເສດ', isDark: false, onTap: onDecline),
                ),
              ])
            else
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  color: isAccepted
                      ? const Color(0xFFEDFAF3)
                      : const Color(0xFFF8F8FC),
                  borderRadius: BorderRadius.circular(9.r),
                ),
                child: Center(
                  child: Text(
                    isAccepted ? '✓ ຍອມຮັບແລ້ວ' : '✕ ປະຕິເສດແລ້ວ',
                    style: TextStyle(
                      fontSize: 11.sp, fontWeight: FontWeight.w700,
                      color: isAccepted
                          ? const Color(0xFF15803D)
                          : const Color(0xFF9B9BAD),
                    ),
                  ),
                ),
              ),
          ]),
        ),
      ],
    );
  }
}

class _BookMeta extends StatelessWidget {
  final IconData icon;
  final String text;
  const _BookMeta({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 11.r, color: const Color(0xFF9B9BAD)),
      SizedBox(width: 4.w),
      Text(text, style: TextStyle(
          fontSize: 10.sp, color: const Color(0xFF9B9BAD))),
    ]);
  }
}

class _BookBtn extends StatelessWidget {
  final String label;
  final bool isDark;
  final VoidCallback onTap;
  const _BookBtn({required this.label, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32.h,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A2E) : const Color(0xFFF8F8FC),
          borderRadius: BorderRadius.circular(9.r),
          border: isDark ? null : Border.all(
              color: Colors.black.withOpacity(0.08), width: 0.5),
        ),
        child: Center(
          child: Text(label, style: TextStyle(
            fontSize: 11.sp, fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : const Color(0xFF9B9BAD),
          )),
        ),
      ),
    );
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
          width: 26.r, height: 26.r,
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
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18.r),
              topRight: Radius.circular(18.r),
              bottomRight: Radius.circular(18.r),
              bottomLeft: Radius.circular(5.r),
            ),
            border: Border.all(
                color: Colors.black.withOpacity(0.08), width: 0.5),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: List.generate(3, (i) =>
            Container(
              width: 6.r, height: 6.r,
              margin: EdgeInsets.only(right: i < 2 ? 4.w : 0),
              decoration: const BoxDecoration(
                  color: Color(0xFFC4C4D0), shape: BoxShape.circle),
            ),
          )),
        ),
      ],
    );
  }
}

class _HeaderIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _HeaderIconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34.r, height: 34.r,
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8FC),
          borderRadius: BorderRadius.circular(11.r),
          border: Border.all(
              color: Colors.black.withOpacity(0.07), width: 0.5),
        ),
        child: Icon(icon, size: 16.r, color: const Color(0xFF1A1A2E)),
      ),
    );
  }
}

class _SheetRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isRed;
  final VoidCallback onTap;

  const _SheetRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isRed = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isRed ? const Color(0xFFDC2626) : const Color(0xFF1A1A2E);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 13.h),
        child: Row(children: [
          Icon(icon, size: 18.r, color: color),
          SizedBox(width: 14.w),
          Text(label, style: TextStyle(
              fontSize: 14.sp, fontWeight: FontWeight.w600, color: color)),
        ]),
      ),
    );
  }
}