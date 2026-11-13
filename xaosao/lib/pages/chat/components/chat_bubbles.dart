import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/constants/app_icons.dart';
import 'package:xaosao/l10n/app_localizations.dart';
import 'package:xaosao/models/chat_location.dart';
import 'package:xaosao/models/chat_message_model.dart';
import 'package:xaosao/utils/emoji_text.dart';
import 'package:xaosao/utils/l10n.dart' as g;
import 'package:xaosao/utils/url_launcher_helper.dart';
import 'package:xaosao/widgets/app_svg_icon.dart';

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

  /// Called with a ready-to-show message when the maps app refuses to open.
  /// The bubble has no opinion on how to surface it (snackbar, toast, ...).
  final void Function(String message)? onOpenMapFailed;

  /// Opens the full-screen image preview. Supplied by the list, which is the
  /// only place that knows every image in the conversation and can therefore
  /// hand the gallery something to swipe through.
  final VoidCallback? onImageTap;

  const ChatTextBubble({
    super.key,
    required this.msg,
    required this.isMe,
    required this.gradient,
    this.partnerImage,
    this.onLongPress,
    this.onOpenMapFailed,
    this.onImageTap,
  });

  bool get _isImage => msg.messageType == 'image' && msg.fileUrl != null;

  @override
  Widget build(BuildContext context) {
    // Resolved once here so the tap handler and the body agree on whether
    // this message is a location.
    final location = _isImage ? null : ChatLocation.fromMessage(msg);
    final emojiCount = _isImage || location != null
        ? 0
        : EmojiText.emojiOnlyCount(msg.messageText);
    final emojiSize = EmojiText.largeFontSize(emojiCount);

    return GestureDetector(
      onLongPress: onLongPress,
      onTap: _isImage
          ? onImageTap
          : (location == null ? null : () => _openMap(location)),
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
              _BubbleBody(
                msg: msg,
                isMe: isMe,
                location: location,
                emojiSize: emojiSize,
              ),
              SizedBox(height: 3.h),
              _BubbleFooter(msg: msg, isMe: isMe),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _openMap(ChatLocation location) async {
    final opened = await UrlLauncherHelper.openLocation(
      location.latitude,
      location.longitude,
    );
    if (!opened) onOpenMapFailed?.call(g.l10n.chatLocationOpenFailed);
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
  final ChatLocation? location;

  /// Non-null when the message is nothing but one to three emoji.
  final double? emojiSize;

  const _BubbleBody({
    required this.msg,
    required this.isMe,
    this.location,
    this.emojiSize,
  });

  bool get _isImage => msg.messageType == 'image' && msg.fileUrl != null;

  /// 1-3 emoji drop the bubble entirely, as in WhatsApp and Messenger: a
  /// coloured pill around a 46pt glyph looks like a mistake.
  bool get _isBareEmoji => emojiSize != null;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.only(
      topLeft: Radius.circular(18.r),
      topRight: Radius.circular(18.r),
      bottomLeft: Radius.circular(isMe ? 18.r : 5.r),
      bottomRight: Radius.circular(isMe ? 5.r : 18.r),
    );

    if (_isBareEmoji) {
      return Padding(
        // Only enough inset to keep the glyph off the screen edge.
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        child: _content(),
      );
    }

    return Container(
      constraints: BoxConstraints(maxWidth: 220.w),
      // Images get a hairline frame instead of the text bubble's 12x9 inset,
      // so the photo reads as the content rather than as a thumbnail floating
      // in a coloured card.
      padding: _isImage
          ? EdgeInsets.all(2.r)
          : EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: isMe ? AppColors.primary : AppColors.surface,
        borderRadius: radius,
        border: isMe
            ? null
            : Border.all(
                color: Colors.black.withValues(alpha: 0.08), width: 0.5),
      ),
      child: _isImage ? _ImageContent(url: msg.fileUrl!, radius: radius) : _content(),
    );
  }

  Widget _content() {
    final size = emojiSize;
    if (size != null) {
      return Text(
        msg.messageText ?? '',
        style: TextStyle(fontSize: size.sp, height: 1.15),
      );
    }
    final loc = location;
    if (loc != null) return _LocationCard(location: loc, isMe: isMe);
    return Text(
      msg.messageText ?? '',
      style: TextStyle(
        fontSize: 12.5.sp,
        height: 1.55,
        color: isMe ? Colors.white : AppColors.textPrimary,
      ),
    );
  }
}

// ── Image content ─────────────────────────────────────────────
//
// CachedNetworkImage rather than Image.network so scrolling back through a
// conversation does not re-download every photo, and so there is somewhere to
// put a placeholder and an error state instead of a silent blank box.
class _ImageContent extends StatelessWidget {
  final String url;
  final BorderRadius radius;

  const _ImageContent({required this.url, required this.radius});

  @override
  Widget build(BuildContext context) {
    // Inner radius tracks the outer one minus the 2px frame, so the corners
    // stay concentric instead of showing a sliver of bubble colour.
    final inner = BorderRadius.only(
      topLeft: Radius.circular(16.r),
      topRight: Radius.circular(16.r),
      bottomLeft: radius.bottomLeft.x > 10 ? Radius.circular(16.r) : Radius.circular(4.r),
      bottomRight:
          radius.bottomRight.x > 10 ? Radius.circular(16.r) : Radius.circular(4.r),
    );

    return ClipRRect(
      borderRadius: inner,
      child: ConstrainedBox(
        // Tall screenshots are cropped here and shown whole in the preview,
        // so one photo cannot take over the entire scroll view.
        constraints: BoxConstraints(maxHeight: 280.h),
        child: CachedNetworkImage(
          imageUrl: url,
          width: 216.w,
          fit: BoxFit.cover,
          placeholder: (_, __) => Container(
            width: 216.w,
            height: 160.h,
            color: Colors.black.withValues(alpha: 0.04),
            alignment: Alignment.center,
            child: SizedBox(
              width: 18.r,
              height: 18.r,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            ),
          ),
          errorWidget: (_, __, ___) => Container(
            width: 216.w,
            height: 120.h,
            color: Colors.black.withValues(alpha: 0.04),
            alignment: Alignment.center,
            child: Icon(
              Icons.broken_image_outlined,
              size: 26.r,
              color: AppColors.textDisabled,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Shared-location card ──────────────────────────────────────
//
// Drawn rather than rendered from a static-map image on purpose: a Static
// Maps API call would need the Maps key, which is restricted to specific
// signing certificates, so a key/SHA mismatch would turn every location
// bubble into a broken image. This always renders, offline included.
class _LocationCard extends StatelessWidget {
  final ChatLocation location;
  final bool isMe;

  const _LocationCard({required this.location, required this.isMe});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final fg = isMe ? Colors.white : AppColors.textPrimary;
    final dim =
        isMe ? Colors.white.withValues(alpha: 0.78) : AppColors.textHint;
    final chipBg = isMe
        ? Colors.white.withValues(alpha: 0.20)
        : AppColors.primary.withValues(alpha: 0.10);
    final divider = isMe
        ? Colors.white.withValues(alpha: 0.24)
        : Colors.black.withValues(alpha: 0.07);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // A pasted "meet me here <link>" keeps its words instead of having
        // them swallowed by the card.
        if (location.caption != null) ...[
          Text(
            location.caption!,
            style: TextStyle(fontSize: 12.5.sp, height: 1.55, color: fg),
          ),
          SizedBox(height: 8.h),
        ],
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 34.r,
              height: 34.r,
              decoration: BoxDecoration(
                color: chipBg,
                borderRadius: BorderRadius.circular(10.r),
              ),
              alignment: Alignment.center,
              child: AppSvgIcon(
                assetName: AppIcons.location,
                width: 18.r,
                height: 18.r,
                color: isMe ? Colors.white : AppColors.primary,
              ),
            ),
            SizedBox(width: 10.w),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.chatLocationTitle,
                    style: TextStyle(
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w700,
                      color: fg,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    location.prettyCoords,
                    style: TextStyle(fontSize: 10.5.sp, color: dim),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Divider(height: 1, thickness: 1, color: divider),
        SizedBox(height: 7.h),
        Text(
          l10n.chatLocationOpenHint,
          style: TextStyle(
            fontSize: 10.5.sp,
            fontWeight: FontWeight.w600,
            color: dim,
          ),
        ),
      ],
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
