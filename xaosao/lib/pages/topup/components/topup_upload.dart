import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xaosao/pages/topup/components/topup_constant.dart';
import 'package:xaosao/pages/topup/components/topup_success.dart';

// ═══════════════════════════════════════════════════════════════
//  topup_upload_page.dart — Page 3: ອັບໂຫຼດ Slip
//  Supports up to 3 slip images.
//  Thumbnail strip shown after upload.
// ═══════════════════════════════════════════════════════════════
class TopUpUploadSlipPage extends StatefulWidget {
  final int amountKip;
  const TopUpUploadSlipPage({super.key, required this.amountKip});

  @override
  State<TopUpUploadSlipPage> createState() => _UploadState();
}

class _UploadState extends State<TopUpUploadSlipPage> {
  final _picker = ImagePicker();
  final _slips = <File>[];
  static const _maxSlips = 3;

  Future<void> _pickImage() async {
    if (_slips.length >= _maxSlips) return;
    final x = await _picker.pickImage(source: ImageSource.gallery);
    if (x != null && mounted) {
      setState(() => _slips.add(File(x.path)));
    }
  }

  void _removeSlip(int i) => setState(() => _slips.removeAt(i));

  void _submit() {
    if (_slips.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TopUpSuccessPage(amountKip: widget.amountKip),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: TopUpGradientAppBar(
        title: 'ອັບໂຫຼດ Slip',
        sub: 'ຢືນຢັນການຊຳລະ',
        step: '3',
        onBack: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 28.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Upload zone ─────────────────────────
              GestureDetector(
                onTap: _pickImage,
                child: _UploadZone(
                  slipCount: _slips.length,
                  maxSlips: _maxSlips,
                ),
              ),
              SizedBox(height: 8.h),
                
              // ── Thumbnails ──────────────────────────
              if (_slips.isNotEmpty) ...[
                SizedBox(height: 4.h),
                SizedBox(
                  height: 70.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _slips.length,
                    separatorBuilder: (_, __) => SizedBox(width: 8.w),
                    itemBuilder: (_, i) => _Thumbnail(
                      file: _slips[i],
                      onRemove: () => _removeSlip(i),
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
              ],
                
              // ── Format note ─────────────────────────
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 13.r,
                    color: kHint,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'ຮອງຮັບຮູບແບບ: JPG, PNG, PDF (ຂຸງສຸດ 10MB)',
                    style: TextStyle(fontSize: 12.sp, color: kHint),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
                
              // ── Guide card ──────────────────────────
              _GuideCard(),
              SizedBox(height: 12.h),
                
              // ── Info note ───────────────────────────
              _AmberNote(),
              SizedBox(height: 20.h),
                
              // ── Submit ──────────────────────────────
              TopUpPinkBtn(
                label: 'ສົ່ງ ແລະ ຢືນຢັນ',
                icon: Icons.check_rounded,
                enabled: _slips.isNotEmpty,
                onTap: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Upload zone widget ─────────────────────────────────────────
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
              ? const Color(0xFF22C55E)
              : Colors.black.withOpacity(0.12),
          width: _hasSlips ? 1.2 : 1.5,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: Column(
        children: [
          // Icon
          Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              color: _hasSlips
                  ? const Color(0xFFDCFCE7)
                  : const Color(0xFFF8F8FC),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              _hasSlips
                  ? Icons.check_circle_outline_rounded
                  : Icons.upload_outlined,
              size: 22.r,
              color: _hasSlips ? const Color(0xFF16A34A) : kHint,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'ອັບໂຫຼດໃບຍືນຢັນທາງດ່ວນ',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: kNavy,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'ສາມາດອັບໃບຍືນຢັນໄດ້ທີ່ນີ້',
            style: TextStyle(fontSize: 12.sp, color: kHint),
          ),
          SizedBox(height: 12.h),
          // Counter dots
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
                        ? kPink
                        : Colors.black.withOpacity(0.12),
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                '$slipCount/$maxSlips slips uploaded',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: kHint,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Button inside zone
          Container(
            height: 36.h,
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            decoration: BoxDecoration(
              color: _isFull ? const Color(0xFFE0E0E0) : kPink,
              borderRadius: BorderRadius.circular(11.r),
            ),
            child: Center(
              child: Text(
                slipCount == 0 ? 'ເລືອກໄຟລ໌' : 'ເພີ່ມ slip ອີກ',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: _isFull ? kHint : Colors.white,
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
        border: Border.all(color: kBorder, width: 0.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(13.r),
          onTap: () {}, // TODO: show guide
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 11.h),
            child: Row(
              children: [
                Container(
                  width: 32.r,
                  height: 32.r,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0F6),
                    borderRadius: BorderRadius.circular(9.r),
                  ),
                  child: Icon(Icons.monitor_outlined, size: 15.r, color: kPink),
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
                          color: kNavy,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'ກົດເພື່ອເບິ່ງຕົວຢ່າງ',
                        style: TextStyle(fontSize: 10.sp, color: kHint),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 18.r,
                  color: Colors.black.withOpacity(0.2),
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
        border: Border.all(
          color: const Color(0xFFF59E0B).withOpacity(0.22),
          width: 0.5,
        ),
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
                fontSize: 11.sp,
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
