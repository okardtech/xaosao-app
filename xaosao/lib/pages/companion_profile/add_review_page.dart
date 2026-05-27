import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/utils/app_snackbar.dart';
import 'package:xaosao/widgets/gradient_app_bar.dart';
import 'getx/companion_logic.dart';

class AddReviewPage extends StatefulWidget {
  final String modelId;
  final String companionName;
  final String tag;

  const AddReviewPage({
    super.key,
    required this.modelId,
    required this.companionName,
    required this.tag,
  });

  @override
  State<AddReviewPage> createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  int _rating = 0;
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_rating == 0) {
      AppSnackbar.error('ກະລຸນາໃຫ້ຄະແນນ');
      return;
    }
    final desc = _descCtrl.text.trim();
    if (desc.isEmpty) {
      AppSnackbar.error('ກະລຸນາຂຽນລີວິວ');
      return;
    }

    setState(() => _submitting = true);
    try {
      final logic = Get.find<CompanionLogic>(tag: widget.tag);
      final ok = await logic.submitReview(
        rating: _rating.toDouble(),
        title: _titleCtrl.text.trim(),
        desc: desc,
      );
      if (ok) {
        Get.back();
        AppSnackbar.success('ສົ່ງລີວິວສຳເລັດ');
      } else {
        AppSnackbar.error('ສົ່ງລີວິວບໍ່ສຳເລັດ');
      }
    } catch (_) {
      AppSnackbar.error('ເກີດຂໍ້ຜິດພາດ ກະລຸນາລອງໃໝ່');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      appBar: GradientAppBar(
        title: 'ຂຽນລີວິວ',
        subtitle: widget.companionName.isNotEmpty
            ? 'ສຳລັບ ${widget.companionName}'
            : null,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Star rating
            _SectionLabel('ໃຫ້ຄະແນນ'),
            SizedBox(height: 10.h),
            _StarSelector(
              rating: _rating,
              onChanged: (r) => setState(() => _rating = r),
            ),
            SizedBox(height: 24.h),

            // Title input
            _SectionLabel('ຫົວຂໍ້ (ທາງເລືອກ)'),
            SizedBox(height: 8.h),
            _InputField(
              controller: _titleCtrl,
              hint: 'ໃສ່ຫົວຂໍ້ລີວິວ...',
              maxLines: 1,
            ),
            SizedBox(height: 20.h),

            // Description input
            _SectionLabel('ລີວິວຂອງທ່ານ'),
            SizedBox(height: 8.h),
            _InputField(
              controller: _descCtrl,
              hint: 'ແບ່ງປັນປະສົບການຂອງທ່ານ...',
              maxLines: 5,
            ),
            SizedBox(height: 32.h),

            // Submit button
            GestureDetector(
              onTap: _submitting ? null : _submit,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                height: 52.h,
                decoration: BoxDecoration(
                  gradient: _submitting
                      ? null
                      : const LinearGradient(
                          colors: AppColors.pinkGradient,
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                  color: _submitting ? const Color(0xFFE0E0E0) : null,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: _submitting
                      ? null
                      : [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.30),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                ),
                child: Center(
                  child: _submitting
                      ? SizedBox(
                          width: 22.r,
                          height: 22.r,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.send_rounded,
                              size: 16.r,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'ສົ່ງລີວິວ',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Star selector ─────────────────────────────────────────────────────────────
class _StarSelector extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onChanged;

  const _StarSelector({required this.rating, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.black.withValues(alpha: 0.07), width: 0.5),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final filled = i < rating;
              return GestureDetector(
                onTap: () => onChanged(i + 1),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 150),
                    child: Icon(
                      filled ? Icons.star_rounded : Icons.star_border_rounded,
                      key: ValueKey(filled),
                      size: 40.r,
                      color: filled
                          ? AppColors.vipGold
                          : const Color(0xFFD1D1DC),
                    ),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 8.h),
          Text(
            _label(rating),
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: rating > 0 ? AppColors.primary : AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }

  String _label(int r) {
    switch (r) {
      case 1:
        return 'ບໍ່ດີ';
      case 2:
        return 'ພໍໃຊ້ໄດ້';
      case 3:
        return 'ດີ';
      case 4:
        return 'ດີຫຼາຍ';
      case 5:
        return 'ດີເລີດ!';
      default:
        return 'ເລືອກຄະແນນ';
    }
  }
}

// ── Section label ─────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }
}

// ── Input field ───────────────────────────────────────────────────────────────
class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(fontSize: 13.sp, color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 13.sp, color: AppColors.textHint),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.07), width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.07), width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: AppColors.primary, width: 1.2),
        ),
      ),
    );
  }
}
