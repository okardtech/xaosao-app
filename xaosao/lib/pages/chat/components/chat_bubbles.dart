import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/models/chat_message_model.dart';

// ── Initials avatar ────────────────────────────────────────────
class ChatInitials extends StatelessWidget {
  final String name;
  final double size;
  const ChatInitials({super.key, required this.name, this.size = 16});

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return Center(
      child: Text(
        initial,
        style: TextStyle(
          fontSize: size,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }
}

// ── Date divider ───────────────────────────────────────────────
class ChatDateDivider extends StatelessWidget {
  final String label;
  const ChatDateDivider({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: AppColors.textDisabled,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ── Read-receipt double-tick ───────────────────────────────────
class ChatTickWidget extends StatelessWidget {
  final bool isRead;
  const ChatTickWidget({super.key, required this.isRead});

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

// ── Text / image message bubble ────────────────────────────────
class ChatTextBubble extends StatelessWidget {
  final ChatMessageModel msg;
  final bool isMe;
  final List<Color> gradient;
  final String? partnerImage;
  final VoidCallback? onLongPress;

  const ChatTextBubble({
    super.key,
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
          if (!isMe) _PartnerAvatar(gradient: gradient, imageUrl: partnerImage),
          Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              _BubbleBody(msg: msg, isMe: isMe),
              SizedBox(height: 3.h),
              _BubbleFooter(msg: msg, isMe: isMe),
            ],
          ),
        ],
      ),
    );
  }
}

class _PartnerAvatar extends StatelessWidget {
  final List<Color> gradient;
  final String? imageUrl;
  const _PartnerAvatar({required this.gradient, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26.r,
      height: 26.r,
      margin: EdgeInsets.only(right: 6.w),
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
              child: Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox(),
              ),
            )
          : null,
    );
  }
}

class _BubbleBody extends StatelessWidget {
  final ChatMessageModel msg;
  final bool isMe;
  const _BubbleBody({required this.msg, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 220.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: isMe ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18.r),
          topRight: Radius.circular(18.r),
          bottomLeft: Radius.circular(isMe ? 18.r : 5.r),
          bottomRight: Radius.circular(isMe ? 5.r : 18.r),
        ),
        border: isMe
            ? null
            : Border.all(
                color: Colors.black.withValues(alpha: 0.08), width: 0.5),
      ),
      child: msg.messageType == 'image' && msg.fileUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Image.network(
                msg.fileUrl!,
                width: 180.w,
                fit: BoxFit.cover,
              ),
            )
          : Text(
              msg.messageText ?? '',
              style: TextStyle(
                fontSize: 12.5.sp,
                height: 1.55,
                color: isMe ? Colors.white : AppColors.textPrimary,
              ),
            ),
    );
  }
}

class _BubbleFooter extends StatelessWidget {
  final ChatMessageModel msg;
  final bool isMe;
  const _BubbleFooter({required this.msg, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(
        msg.timeString,
        style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
      ),
      if (isMe) ...[
        SizedBox(width: 3.w),
        ChatTickWidget(isRead: msg.isRead),
      ],
    ]);
  }
}

// ── Typing bubble (animated dots) ─────────────────────────────
class ChatTypingBubble extends StatelessWidget {
  final List<Color> gradient;
  const ChatTypingBubble({super.key, required this.gradient});

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
              colors: gradient,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18.r),
              topRight: Radius.circular(18.r),
              bottomRight: Radius.circular(18.r),
              bottomLeft: Radius.circular(5.r),
            ),
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.08),
              width: 0.5,
            ),
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
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
