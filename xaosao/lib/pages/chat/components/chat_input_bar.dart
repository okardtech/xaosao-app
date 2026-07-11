import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/pages/chat/getx/chat_detail_controller.dart';
import 'package:xaosao/pages/package/components/subscription_banner.dart';
import 'package:xaosao/repository/package_repo.dart';
import 'package:xaosao/services/storage_service.dart';

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
            'ຮູບພາບທີ່ເລືອກ',
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
            hintText: 'ພິມຂໍ້ຄວາມ...',
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

// ── Send button ────────────────────────────────────────────────
class _SendButton extends StatelessWidget {
  final ChatDetailController ctrl;
  final bool canAct;
  const _SendButton({required this.ctrl, required this.canAct});

  Future<void> _onTap(BuildContext context) async {
    final role = Get.find<StorageService>().read<String>('role');
    if (role == 'customer') {
      final activeRes = await PackageRepo().packageActive();
      final active = activeRes.data;
      if (active?.neverSubscribed == true) {
        final hourRes = await PackageRepo().packageHour();
        if (hourRes.data == null) {
          return;
        }
        showSubscriptionBanner(context, hourRes.data!);
        return;
      }
      if (active?.hasPendingSubscription == true) {
        showPendingSubscriptionBanner(context);
        return;
      }
      if (active?.hasActiveSubscription != true) {
        showNoSubscriptionBanner(context);
        return;
      }
    }

    final ok = await ctrl.sendMessage();
    if (ok) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => ctrl.scrollToBottom(),
      );
    } else {
      Get.snackbar(
        'ສົ່ງບໍ່ສຳເລັດ',
        'ກະລຸນາລອງໃໝ່',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade700,
        margin: EdgeInsets.all(12.r),
        borderRadius: 12.r,
        duration: const Duration(seconds: 2),
      );
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
