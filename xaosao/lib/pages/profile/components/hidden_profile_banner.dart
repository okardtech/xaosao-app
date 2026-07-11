import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/pages/login/getx/login_logic.dart';
import 'package:xaosao/pages/profile/getx/profile_logic.dart';
import 'package:xaosao/repository/gallery_repo.dart';
import 'package:xaosao/utils/app_snackbar.dart';

Future<void> showHiddenProfileBanner(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    builder: (_) => const _HiddenProfileDialog(),
  );
}

class _HiddenProfileDialog extends StatefulWidget {
  const _HiddenProfileDialog();

  @override
  State<_HiddenProfileDialog> createState() => _HiddenProfileDialogState();
}

class _HiddenProfileDialogState extends State<_HiddenProfileDialog> {
  final _repo = GalleryRepo();
  bool _loading = false;

  Future<void> _unhide() async {
    if (_loading) return;
    setState(() => _loading = true);
    try {
      final res = await _repo.visibility(hidden: false);
      if (!mounted) return;
      if (res.success) {
        Get.find<LoginLogic>().updateModelProfileHidden(false);
        try {
          Get.find<ProfileLogic>().syncHidden(false);
        } catch (_) {}
        AppSnackbar.success('ສະແດງໂປຣໄຟສຳເລັດ');
        Navigator.of(context).pop();
      } else {
        setState(() => _loading = false);
        AppSnackbar.error(res.laMessage ?? 'ເກີດຂໍ້ຜິດພາດ, ກະລຸນາລອງໃໝ່');
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
      AppSnackbar.error('ເກີດຂໍ້ຜິດພາດ, ກະລຸນາລອງໃໝ່');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _HiddenProfileHeader(onClose: () => Navigator.of(context).pop()),
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ລູກຄ້າບໍ່ສາມາດເຫັນໂປຣໄຟຂອງທ່ານໃນຕອນນີ້. '
                      'ເມື່ອທ່ານພ້ອມຮັບການຈອງອີກຄັ້ງ, ກົດສະແດງໂປຣໄຟຂອງທ່ານ.',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textHint,
                        height: 1.55,
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Action buttons
                    Row(
                      children: [
                        // Close
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              height: 46.h,
                              decoration: BoxDecoration(
                                color: AppColors.bg,
                                borderRadius: BorderRadius.circular(14.r),
                                border: Border.all(
                                  color: AppColors.borderMedium,
                                  width: 0.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'ປິດ',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textHint,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),

                        // CTA
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: _unhide,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: 46.h,
                              decoration: BoxDecoration(
                                gradient: _loading
                                    ? null
                                    : const LinearGradient(
                                        colors: [
                                          Color(0xFFFFB300),
                                          Color(0xFFE65100),
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                color: _loading
                                    ? const Color(0xFFE0E0E0)
                                    : null,
                                borderRadius: BorderRadius.circular(14.r),
                                boxShadow: _loading
                                    ? null
                                    : [
                                        BoxShadow(
                                          color: const Color(
                                            0xFFE65100,
                                          ).withValues(alpha: 0.30),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                              ),
                              child: Center(
                                child: _loading
                                    ? SizedBox(
                                        width: 20.r,
                                        height: 20.r,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        'ສະແດງໂປຣໄຟ',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 28.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Gradient header ───────────────────────────────────────────────
class _HiddenProfileHeader extends StatelessWidget {
  final VoidCallback onClose;
  const _HiddenProfileHeader({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFB300), Color(0xFFE65100)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Decorative orbs
          Positioned(
            top: -20,
            right: -10,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -14,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.07),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Close button
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: onClose,
              child: Container(
                width: 28.r,
                height: 28.r,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.22),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close_rounded,
                  size: 14.r,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 44.w, 18.h),
            child: Row(
              children: [
                Container(
                  width: 44.r,
                  height: 44.r,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.20),
                    borderRadius: BorderRadius.circular(14.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.visibility_off_rounded,
                    size: 24.r,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ໂປຣໄຟຂອງທ່ານຖືກຊ່ອນຢູ່',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        'ທ່ານຈະບໍ່ສະແດງໃນຜົນຄົ້ນຫາ',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.white.withValues(alpha: 0.75),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
