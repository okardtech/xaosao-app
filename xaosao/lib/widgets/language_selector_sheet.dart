import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/constants/app_image.dart';
import 'package:xaosao/l10n/app_localizations.dart';
import 'package:xaosao/services/language_service.dart';

// ═══════════════════════════════════════════════════════════════
//  language_selector_sheet.dart
//  Bottom sheet for switching app language between Lao, English,
//  and Thai. Uses flag images from [AppImage] and always shows the
//  language name in its NATIVE script (never localized) so users
//  can find their own language regardless of the current UI locale.
//
//  Usage:
//    LanguageSelectorSheet.show(context);
// ═══════════════════════════════════════════════════════════════
class LanguageSelectorSheet {
  LanguageSelectorSheet._();

  static Future<void> show(BuildContext context) {
    HapticFeedback.lightImpact();
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      isDismissible: true,
      enableDrag: true,
      builder: (_) => const _LanguageSheetBody(),
    );
  }
}

// ── Sheet body ────────────────────────────────────────────────
class _LanguageSheetBody extends StatelessWidget {
  const _LanguageSheetBody();

  static const _options = <_LanguageOption>[
    _LanguageOption(
      code: 'lo',
      nativeName: 'ພາສາລາວ',
      flag: AppImage.laFlag,
    ),
    _LanguageOption(
      code: 'en',
      nativeName: 'English',
      flag: AppImage.enFlag,
    ),
    _LanguageOption(
      code: 'th',
      nativeName: 'ภาษาไทย',
      flag: AppImage.thFlag,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final langService = Get.find<LanguageService>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 18.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
              SizedBox(height: 22.h),

              // Title (localized)
              Text(
                l10n.languageTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                l10n.languageSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 20.h),

              // Options
              Obx(() {
                final active = langService.locale.languageCode;
                return Column(
                  children: [
                    for (var i = 0; i < _options.length; i++) ...[
                      _LanguageRow(
                        option: _options[i],
                        isActive: _options[i].code == active,
                        onTap: () async {
                          if (_options[i].code != active) {
                            await langService.changeLanguage(_options[i].code);
                          }
                          if (context.mounted) Navigator.pop(context);
                        },
                      ),
                      if (i != _options.length - 1) SizedBox(height: 10.h),
                    ],
                  ],
                );
              }),
              SizedBox(height: 6.h),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Single language row ───────────────────────────────────────
class _LanguageRow extends StatelessWidget {
  final _LanguageOption option;
  final bool isActive;
  final VoidCallback onTap;

  const _LanguageRow({
    required this.option,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withValues(alpha: 0.06)
              : const Color(0xFFF8F8FC),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isActive
                ? AppColors.primary
                : Colors.black.withValues(alpha: 0.06),
            width: isActive ? 1.5 : 0.5,
          ),
        ),
        child: Row(
          children: [
            // Flag — clipped to rounded rectangle for a premium look
            ClipRRect(
              borderRadius: BorderRadius.circular(6.r),
              child: Image.asset(
                option.flag,
                width: 34.w,
                height: 24.h,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  width: 34.w,
                  height: 24.h,
                  color: Colors.grey.shade200,
                  child: Icon(
                    Icons.flag_outlined,
                    size: 14.r,
                    color: AppColors.textHint,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),

            // Native language name (never translated)
            Expanded(
              child: Text(
                option.nativeName,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
            ),

            // Selection indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 22.r,
              height: 22.r,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isActive
                      ? AppColors.primary
                      : Colors.black.withValues(alpha: 0.15),
                  width: 1.5,
                ),
              ),
              child: isActive
                  ? Icon(
                      Icons.check_rounded,
                      size: 13.r,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageOption {
  final String code;
  final String nativeName;
  final String flag;
  const _LanguageOption({
    required this.code,
    required this.nativeName,
    required this.flag,
  });
}
