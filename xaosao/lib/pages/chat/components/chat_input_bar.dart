import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/constants/app_icons.dart';
import 'package:xaosao/l10n/app_localizations.dart';
import 'package:xaosao/pages/chat/getx/chat_detail_controller.dart';
import 'package:xaosao/pages/package/components/subscription_banner.dart';
import 'package:xaosao/pages/permissions/permission_sheets.dart';
import 'package:xaosao/repository/package_repo.dart';
import 'package:xaosao/services/storage_service.dart';
import 'package:xaosao/utils/l10n.dart' as g;
import 'package:xaosao/widgets/app_svg_icon.dart';
import 'package:xaosao/widgets/confirm_sheet.dart';

class ChatInputBar extends StatelessWidget {
  final ChatDetailController ctrl;
  const ChatInputBar({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final canAct = ctrl.canSend.value && !ctrl.isSending.value;
      final image = ctrl.pendingImage.value;

      return Container(
        padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 14.h),
        color: AppColors.surface,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (image != null) _PendingImagePreview(ctrl: ctrl, image: image),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _EmojiButton(ctrl: ctrl),
                _ImagePickerButton(ctrl: ctrl),
                _LocationButton(ctrl: ctrl),
                _TextField(ctrl: ctrl),
                SizedBox(width: 8.w),
                _SendButton(ctrl: ctrl, canAct: canAct),
              ],
            ),
          ],
        ),
      );
    });
  }
}

// ── Pending image preview ──────────────────────────────────────
class _PendingImagePreview extends StatelessWidget {
  final ChatDetailController ctrl;
  final Object image;
  const _PendingImagePreview({required this.ctrl, required this.image});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Image.file(
                  ctrl.pendingImage.value!,
                  width: 64.r,
                  height: 64.r,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 2,
                right: 2,
                child: GestureDetector(
                  onTap: ctrl.removePendingImage,
                  child: Container(
                    width: 18.r,
                    height: 18.r,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: 11.r,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 8.w),
          Text(
            l10n.chatSelectedImage,
            style: TextStyle(fontSize: 11.sp, color: AppColors.textHint),
          ),
        ],
      ),
    );
  }
}

// ── Emoji toggle button ────────────────────────────────────────
class _EmojiButton extends StatelessWidget {
  final ChatDetailController ctrl;
  const _EmojiButton({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ctrl.toggleEmoji,
      child: Obx(
        () => Padding(
          padding: EdgeInsets.only(bottom: 8.h, right: 4.w),
          child: Icon(
            ctrl.showEmoji.value
                ? Icons.keyboard_rounded
                : Icons.emoji_emotions_outlined,
            size: 24.r,
            color: ctrl.showEmoji.value
                ? AppColors.primary
                : AppColors.textDisabled,
          ),
        ),
      ),
    );
  }
}

// ── Image picker button ────────────────────────────────────────
class _ImagePickerButton extends StatelessWidget {
  final ChatDetailController ctrl;
  const _ImagePickerButton({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ctrl.isSending.value ? null : ctrl.pickImage,
      child: Obx(
        () => Padding(
          padding: EdgeInsets.only(bottom: 8.h, right: 6.w),
          child: Icon(
            Icons.image_outlined,
            size: 24.r,
            color: ctrl.pendingImage.value != null
                ? AppColors.primary
                : AppColors.textDisabled,
          ),
        ),
      ),
    );
  }
}

// ── Text input field ───────────────────────────────────────────
class _TextField extends StatelessWidget {
  final ChatDetailController ctrl;
  const _TextField({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Expanded(
      child: Container(
        constraints: BoxConstraints(minHeight: 36.h),
        decoration: BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.08),
            width: 0.5,
          ),
        ),
        child: TextField(
          controller: ctrl.inputCtrl,
          focusNode: ctrl.focusNode,
          maxLines: 4,
          minLines: 1,
          style: TextStyle(fontSize: 12.5.sp, color: AppColors.textPrimary),
          onChanged: (_) => ctrl.onTyping(),
          decoration: InputDecoration(
            isDense: true,
            border: InputBorder.none,
            hintText: l10n.chatInputHint,
            hintStyle: TextStyle(
              fontSize: 12.5.sp,
              color: AppColors.textDisabled,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 13.w,
              vertical: 9.h,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Subscription gate ─────────────────────────────────────────
//
// Customers need an active subscription to send ANYTHING, so every send
// path has to pass through here. Extracted out of _SendButton when the
// location button arrived: a second copy of this would have been a
// paywall bypass the moment one of the two drifted.
//
// Returns true when sending may proceed. On false it has already shown the
// relevant banner to the user.
Future<bool> _ensureCanSend(BuildContext context) async {
  final role = Get.find<StorageService>().read<String>('role');
  if (role != 'customer') return true;

  final active = (await PackageRepo().packageActive()).data;
  if (active?.neverSubscribed == true) {
    final hourRes = await PackageRepo().packageHour();
    if (hourRes.data == null) return false;
    if (!context.mounted) return false;
    showSubscriptionBanner(context, hourRes.data!);
    return false;
  }
  if (active?.hasPendingSubscription == true) {
    if (context.mounted) showPendingSubscriptionBanner(context);
    return false;
  }
  if (active?.hasActiveSubscription != true) {
    if (context.mounted) showNoSubscriptionBanner(context);
    return false;
  }
  return true;
}

void _toast(String title, String message, {bool danger = true}) {
  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: danger ? Colors.red.shade50 : Colors.green.shade50,
    colorText: danger ? Colors.red.shade700 : Colors.green.shade800,
    margin: EdgeInsets.all(12.r),
    borderRadius: 12.r,
    duration: const Duration(seconds: 2),
  );
}

// ── Share-location button ─────────────────────────────────────
class _LocationButton extends StatelessWidget {
  final ChatDetailController ctrl;
  const _LocationButton({required this.ctrl});

  Future<void> _onTap(BuildContext context) async {
    if (ctrl.isSendingLocation.value) return;
    if (!await _ensureCanSend(context)) return;
    if (!context.mounted) return;

    final l10n = AppLocalizations.of(context)!;

    // Confirm first: a precise location is privacy-sensitive and a sent
    // message cannot be unsent. One tap away from broadcasting where you
    // live is the wrong default.
    final confirmed = await ConfirmSheet.show(
      context,
      title: l10n.chatSendLocationTitle,
      message: l10n.chatSendLocationBody(ctrl.partnerName),
      confirmLabel: l10n.chatSendLocationConfirm,
      icon: AppIcons.location,
    );
    if (confirmed != true || !context.mounted) return;

    final outcome = await ctrl.sendCurrentLocation();
    if (!context.mounted) return;

    switch (outcome) {
      case LocationSendOutcome.ok:
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => ctrl.scrollToBottom(),
        );
      case LocationSendOutcome.busy:
        break;
      case LocationSendOutcome.serviceDisabled:
        // GPS toggle is OS-level; only the system settings screen fixes it.
        final go = await SettingsReminderSheet.show(
          context,
          icon: Icons.location_off_rounded,
          title: l10n.chatLocationGpsOffTitle,
          message: l10n.chatLocationGpsOffBody,
        );
        if (go) await Geolocator.openLocationSettings();
      case LocationSendOutcome.permissionDeniedForever:
        final go = await SettingsReminderSheet.show(
          context,
          icon: Icons.location_off_rounded,
          title: l10n.chatLocationPermTitle,
          message: l10n.chatLocationPermBody,
        );
        if (go) await ph.openAppSettings();
      case LocationSendOutcome.permissionDenied:
        // Declined just now — the OS will ask again, so no settings detour.
        _toast(l10n.chatLocationPermTitle, l10n.chatLocationPermBody);
      case LocationSendOutcome.fixFailed:
        _toast(l10n.chatLocationFixFailed, g.l10n.chatSendPleaseRetry);
      case LocationSendOutcome.sendFailed:
        _toast(g.l10n.chatSendFailed, g.l10n.chatSendPleaseRetry);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final busy = ctrl.isSendingLocation.value;
      return GestureDetector(
        onTap: busy ? null : () => _onTap(context),
        child: Padding(
          padding: EdgeInsets.only(bottom: 8.h, right: 6.w),
          child: busy
              ? SizedBox(
                  width: 24.r,
                  height: 24.r,
                  child: Padding(
                    padding: EdgeInsets.all(3.r),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  ),
                )
              // SVG, not a Material glyph: the icon font is tree-shaken and
              // Shorebird cannot patch assets, so a glyph the installed
              // release never used would render as empty space - which is
              // exactly how this button went missing the first time.
              : AppSvgIcon(
                  assetName: AppIcons.location,
                  width: 23.r,
                  height: 23.r,
                  color: AppColors.textDisabled,
                ),
        ),
      );
    });
  }
}

// ── Send button ────────────────────────────────────────────────
class _SendButton extends StatelessWidget {
  final ChatDetailController ctrl;
  final bool canAct;
  const _SendButton({required this.ctrl, required this.canAct});

  Future<void> _onTap(BuildContext context) async {
    if (!await _ensureCanSend(context)) return;

    final ok = await ctrl.sendMessage();
    if (ok) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => ctrl.scrollToBottom(),
      );
    } else {
      _toast(g.l10n.chatSendFailed, g.l10n.chatSendPleaseRetry);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: canAct ? () => _onTap(context) : null,
      child: Obx(() {
        final sending = ctrl.isSending.value;
        return AnimatedContainer(
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
          child: sending
              ? Padding(
                  padding: EdgeInsets.all(9.r),
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Icon(
                  Icons.send_rounded,
                  size: 16.r,
                  color: canAct ? Colors.white : AppColors.textDisabled,
                ),
        );
      }),
    );
  }
}
