import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/widgets/app_button.dart';

// ═══════════════════════════════════════════════════════════════
//  update_available_sheet.dart
//  Bottom sheet shown by VersionChecker when a new app version is
//  available on the App Store / Play Store.
//
//  Returns Future<bool>:
//    true  → user tapped "ອັບເດດດຽວນີ້" (caller should launch store)
//    false → user tapped "ພາຍຫຼັງ" or dismissed
//
//  In `forceUpdate` mode the sheet is non-dismissible: back button is
//  swallowed, no secondary button is shown, and the barrier is opaque.
// ═══════════════════════════════════════════════════════════════
class UpdateAvailableSheet {
  UpdateAvailableSheet._();

  static Future<bool> show(
    BuildContext context, {
    required String localVersion,
    required String storeVersion,
    String? releaseNotes,
    bool forceUpdate = false,
  }) async {
    HapticFeedback.lightImpact();
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: forceUpdate ? 0.70 : 0.45),
      isDismissible: !forceUpdate,
      enableDrag: !forceUpdate,
      builder: (_) => PopScope(
        canPop: !forceUpdate,
        child: _UpdateCard(
          localVersion: localVersion,
          storeVersion: storeVersion,
          releaseNotes: releaseNotes,
          forceUpdate: forceUpdate,
        ),
      ),
    );
    return result ?? false;
  }
}

// ═══════════════════════════════════════════════════════════════
//  Internal — the card
// ═══════════════════════════════════════════════════════════════
class _UpdateCard extends StatelessWidget {
  final String localVersion;
  final String storeVersion;
  final String? releaseNotes;
  final bool forceUpdate;

  const _UpdateCard({
    required this.localVersion,
    required this.storeVersion,
    required this.releaseNotes,
    required this.forceUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final notes = releaseNotes?.trim();
    final hasNotes = notes != null && notes.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 18.h),
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle (hidden in force mode — no drag anyway)
              if (!forceUpdate)
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
              SizedBox(height: forceUpdate ? 8.h : 24.h),

              // Icon disc — solid brand primary
              Container(
                width: 78.r,
                height: 78.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.30),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.system_update_alt_rounded,
                  size: 40.r,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20.h),

              // Title
              Text(
                forceUpdate ? 'ຈຳເປັນຕ້ອງອັບເດດແອັບ' : 'ອັບເດດແອັບໃໝ່ພ້ອມແລ້ວ!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.4,
                  height: 1.3,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                forceUpdate
                    ? 'ກະລຸນາອັບເດດເປັນເວີຊັນຫຼ້າສຸດ ເພື່ອສືບຕໍ່ໃຊ້ Xaosao'
                    : 'ພວກເຮົາໄດ້ປັບປຸງແອັບໃຫ້ດີຂຶ້ນ — ອັບເດດເລີຍເພື່ອປະສົບການທີ່ດີທີ່ສຸດ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.textSecondary,
                  height: 1.55,
                ),
              ),
              SizedBox(height: 20.h),

              // Version comparison card
              _VersionChip(
                localVersion: localVersion,
                storeVersion: storeVersion,
              ),

              // Release notes (optional)
              if (hasNotes) ...[
                SizedBox(height: 20.h),
                _ReleaseNotes(notes: notes),
              ],
              SizedBox(height: 24.h),

              // Primary CTA
              AppPrimaryButton(
                label: 'ອັບເດດດຽວນີ້',
                onTap: () => Navigator.pop(context, true),
                gradient: const [AppColors.primary, AppColors.primary],
              ),

              // Secondary — only when update is optional
              if (!forceUpdate) ...[
                SizedBox(height: 6.h),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: TextButton.styleFrom(
                      minimumSize: Size(double.infinity, 44.h),
                    ),
                    child: Text(
                      'ພາຍຫຼັງ',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textHint,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── Current → New version chip ────────────────────────────────
class _VersionChip extends StatelessWidget {
  final String localVersion;
  final String storeVersion;

  const _VersionChip({required this.localVersion, required this.storeVersion});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          _versionCol(
            label: 'ເວີຊັ່ນປັດຈຸບັນ',
            version: localVersion,
            color: AppColors.textHint,
            weight: FontWeight.w700,
          ),
          SizedBox(width: 10.w),
          Icon(
            Icons.arrow_forward_rounded,
            size: 18.r,
            color: AppColors.primary,
          ),
          SizedBox(width: 10.w),
          _versionCol(
            label: 'ເວີຊັ່ນໃໝ່',
            version: storeVersion,
            color: AppColors.primary,
            weight: FontWeight.w900,
          ),
        ],
      ),
    );
  }

  Widget _versionCol({
    required String label,
    required String version,
    required Color color,
    required FontWeight weight,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              color: AppColors.textHint,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          Text(
            'v$version',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: weight,
              color: color,
              letterSpacing: -0.3,
              height: 1.1,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ── Release notes list ────────────────────────────────────────
class _ReleaseNotes extends StatelessWidget {
  final String notes;
  const _ReleaseNotes({required this.notes});

  static const _maxCollapsedChars = 220;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8FC),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.06),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                size: 14.r,
                color: AppColors.primary,
              ),
              SizedBox(width: 6.w),
              Text(
                'ມີຫຍັງໃໝ່',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            notes.length > _maxCollapsedChars
                ? '${notes.substring(0, _maxCollapsedChars).trim()}…'
                : notes,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
