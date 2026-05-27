import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/constants/app_routes.dart';
import 'package:xaosao/pages/topup/components/topup_constant.dart';
import 'package:xaosao/pages/topup/getx/topup_logic.dart';
import 'package:xaosao/widgets/app_button.dart';
import 'package:xaosao/widgets/gradient_app_bar.dart';

class TopUpUploadSlipPage extends StatefulWidget {
  const TopUpUploadSlipPage({super.key});

  @override
  State<TopUpUploadSlipPage> createState() => _UploadState();
}

class _UploadState extends State<TopUpUploadSlipPage> {
  final _picker = ImagePicker();
  late final TopupLogic _logic;
  static const _maxSlips = 3;

  @override
  void initState() {
    super.initState();
    _logic = Get.find<TopupLogic>();
  }

  Future<void> _pickImage() async {
    if (_logic.state.slips.length >= _maxSlips) return;
    final x = await _picker.pickImage(source: ImageSource.gallery);
    if (x != null) _logic.addSlip(File(x.path));
  }

  Future<void> _submit() async {
    final ok = await _logic.submitTopUp();
    if (!ok || !mounted) return;
    Get.toNamed(AppRoutes.topupSuccess);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: GradientAppBar(
        title: 'ອັບໂຫຼດ Slip',
        subtitle: 'ຢືນຢັນການຊຳລະ',
        actions: [const TopUpStepBadge('3')],
      ),
      body: SafeArea(
        child: Obx(() {
          final st = _logic.state;
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 28.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Upload zone ─────────────────────────────────
                GestureDetector(
                  onTap: _pickImage,
                  child: _UploadZone(
                    slipCount: st.slips.length,
                    maxSlips: _maxSlips,
                  ),
                ),
                SizedBox(height: 8.h),

                // ── Thumbnails ───────────────────────────────────
                if (st.slips.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  SizedBox(
                    height: 70.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: st.slips.length,
                      separatorBuilder: (_, __) => SizedBox(width: 8.w),
                      itemBuilder: (_, i) => _Thumbnail(
                        file: st.slips[i],
                        onRemove: () => _logic.removeSlip(i),
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                ],

                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 13.r,
                      color: AppColors.textHint,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'ຮອງຮັບຮູບແບບ: JPG, PNG, PDF (ຂຸງສຸດ 10MB)',
                      style: TextStyle(fontSize: 12.sp, color: AppColors.textHint),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                // _GuideCard(),
                // SizedBox(height: 12.h),
                _AmberNote(),
                SizedBox(height: 20.h),

                // ── Submit ────────────────────────────────────────
                AppPrimaryButton(
                  label: 'ສົ່ງ ແລະ ຢືນຢັນ',
                  trailingIcon: Icons.check_rounded,
                  enabled: st.slips.isNotEmpty,
                  onTap: _submit,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ── Upload zone ────────────────────────────────────────────────
class _UploadZone extends StatelessWidget {
  final int slipCount;
  final int maxSlips;
  const _UploadZone({required this.slipCount, required this.maxSlips});

  bool get _hasSlips => slipCount > 0;
  bool get _isFull => slipCount >= maxSlips;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 26.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: _hasSlips ? const Color(0xFFF0FDF4) : Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: _hasSlips
              ? AppColors.online
              : Colors.black.withValues(alpha: 0.12),
          width: _hasSlips ? 1.2 :0,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              color: _hasSlips ? const Color(0xFFDCFCE7) : AppColors.bg,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              _hasSlips
                  ? Icons.check_circle_outline_rounded
                  : Icons.upload_outlined,
              size: 22.r,
              color: _hasSlips ? AppColors.online : AppColors.textHint,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'ອັບໂຫຼດໃບຍືນຢັນທາງດ່ວນ',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'ສາມາດອັບໃບຍືນຢັນໄດ້ທີ່ນີ້',
            style: TextStyle(fontSize: 12.sp, color: AppColors.textHint),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(
                maxSlips,
                (i) => Container(
                  width: 8.r,
                  height: 8.r,
                  margin: EdgeInsets.only(right: 4.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i < slipCount
                        ? AppColors.primary
                        : Colors.black.withValues(alpha: 0.12),
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                '$slipCount/$maxSlips slips uploaded',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            height: 36.h,
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            decoration: BoxDecoration(
              color: _isFull ? const Color(0xFFE0E0E0) : AppColors.primary,
              borderRadius: BorderRadius.circular(11.r),
            ),
            child: Center(
              child: Text(
                slipCount == 0 ? 'ເລືອກໄຟລ໌' : 'ເພີ່ມ slip ອີກ',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: _isFull ? AppColors.textHint : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Thumbnail with remove button ───────────────────────────────
class _Thumbnail extends StatelessWidget {
  final File file;
  final VoidCallback onRemove;
  const _Thumbnail({required this.file, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: Image.file(file, width: 70.r, height: 70.r, fit: BoxFit.cover),
        ),
        Positioned(
          top: 3,
          right: 3,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              width: 18.r,
              height: 18.r,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black54,
              ),
              child: Icon(Icons.close_rounded, size: 11.r, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Guide card ─────────────────────────────────────────────────
class _GuideCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13.r),
        border: Border.all(color: AppColors.borderMedium, width: 0.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(13.r),
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 11.h),
            child: Row(
              children: [
                Container(
                  width: 32.r,
                  height: 32.r,
                  decoration: BoxDecoration(
                    color: AppColors.socialBg,
                    borderRadius: BorderRadius.circular(9.r),
                  ),
                  child: Icon(
                    Icons.monitor_outlined,
                    size: 15.r,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: 11.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ຕົວຢ່າງໃບຮັບເງິນທາງດ່ວນ',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'ກົດເພື່ອເບິ່ງຕົວຢ່າງ',
                        style: TextStyle(fontSize: 10.sp, color: AppColors.textHint),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 18.r,
                  color: Colors.black.withValues(alpha: 0.2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Amber info note ────────────────────────────────────────────
class _AmberNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(13.r),
        // border: Border.all(
        //   color: const Color(0xFFF59E0B).withValues(alpha: 0.22),
        //   width: 0.5,
        // ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22.r,
            height: 22.r,
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(7.r),
            ),
            child: Icon(
              Icons.info_outline_rounded,
              size: 12.r,
              color: const Color(0xFFD97706),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'ຂອບໃຈສຳລັບຄວາມໄວ້ວາງໃຈ: ທີມງານຈະກວດສອບ ແລະ ເຕີມເງິນໃຫ້ທ່ານ ພາຍໃນ 1–2 ຊ.ມ. ຫຼັງຈາກໄດ້ຮັບໃບຍືນຢັນແລ້ວ.',
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF78350F),
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

