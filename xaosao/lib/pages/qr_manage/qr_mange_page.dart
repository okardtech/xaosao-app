import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xaosao/constants/app_color.dart';

// ═══════════════════════════════════════════════════════════════
//  qr_management_page.dart
//  ໜ້າຈັດການ QR Code — Companion ເພີ່ມ/ປ່ຽນ/ລຶບ QR
//
//  Usage:
//    Navigator.push(context, MaterialPageRoute(
//      builder: (_) => const QrManagementPage()))
// ═══════════════════════════════════════════════════════════════

// ── QR item model ──────────────────────────────────────────────
class QrItem {
  final String id;
  final String bankName;
  final String accountNumber;
  final Color bankColor;
  final Color bankBg;
  File? imageFile; // local file (after upload)
  String? imageUrl; // remote URL (from API)
  bool isPrimary;

  QrItem({
    required this.id,
    required this.bankName,
    required this.accountNumber,
    required this.bankColor,
    required this.bankBg,
    this.imageFile,
    this.imageUrl,
    this.isPrimary = false,
  });
}

// ── Mock data (replace with API) ───────────────────────────────
List<QrItem> _mockQrItems() => [
  QrItem(
    id: 'bcel',
    bankName: 'BCEL',
    accountNumber: '030 1234 5678',
    bankColor: const Color(0xFF0057AF),
    bankBg: const Color(0xFFE6F0FF),
    isPrimary: true,
  ),
  QrItem(
    id: 'jdb',
    bankName: 'JDB',
    accountNumber: '012 9876 5432',
    bankColor: const Color(0xFFE30613),
    bankBg: const Color(0xFFFEF2F2),
    isPrimary: false,
  ),
];

// ═══════════════════════════════════════════════════════════════
//  QrManagementPage
// ═══════════════════════════════════════════════════════════════
class QrManagementPage extends StatefulWidget {
  const QrManagementPage({super.key});

  @override
  State<QrManagementPage> createState() => _QrManagementPageState();
}

class _QrManagementPageState extends State<QrManagementPage> {
  final _picker = ImagePicker();
  final _items = _mockQrItems();

  // ── pick image → attach to item ─────────────────────────────
  Future<void> _pickQrImage(ImageSource source, {QrItem? item}) async {
    Navigator.pop(context); // close bottom sheet
    final x = await _picker.pickImage(source: source, imageQuality: 95);
    if (x == null || !mounted) return;
    final file = File(x.path);
    setState(() {
      if (item != null) {
        item.imageFile = file;
      } else {
        // new QR
        _items.add(
          QrItem(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            bankName: 'QR ໃໝ່',
            accountNumber: '',
            bankColor: const Color(0xFF1A1A2E),
            bankBg: const Color(0xFFF8F8FC),
            imageFile: file,
            isPrimary: _items.isEmpty,
          ),
        );
      }
    });
    // TODO: upload file to API
  }

  // ── set primary ─────────────────────────────────────────────
  void _setPrimary(QrItem target) {
    HapticFeedback.lightImpact();
    setState(() {
      for (final q in _items) q.isPrimary = false;
      target.isPrimary = true;
    });
    // TODO: PATCH /qr/{target.id}/primary
  }

  // ── delete ──────────────────────────────────────────────────
  void _delete(QrItem item) {
    HapticFeedback.mediumImpact();
    setState(() => _items.remove(item));
    // TODO: DELETE /qr/{item.id}
  }

  // ── show picker sheet ────────────────────────────────────────
  void _showPickerSheet({QrItem? editItem}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.40),
      builder: (_) => _PickerSheet(
        onGallery: () => _pickQrImage(ImageSource.gallery, item: editItem),
        onCamera: () => _pickQrImage(ImageSource.camera, item: editItem),
      ),
    );
  }

  // ── copy to clipboard ────────────────────────────────────────
  void _copy(QrItem item) {
    Clipboard.setData(ClipboardData(text: item.accountNumber));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'ສຳເນົາ ${item.accountNumber} ແລ້ວ',
          style: const TextStyle(fontSize: 13),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
        margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      // appBar: RegGradientAppBar(
      //   title: "QR ໂອນເງິນ",
      //   subtitle: "ຈັດການ QR Code ຂອງຂ້ອຍ",
      //   onBack: () => Navigator.pop(context),
      // ),
      body: SafeArea(
        child: _items.isEmpty
            ? _EmptyState(onAdd: () => _showPickerSheet())
            : _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Info banner ────────────────────────────────────
          _InfoBanner(),
          SizedBox(height: 16.h),

          // ── Primary QR ────────────────────────────────────
          ?_buildPrimarySection(),
          SizedBox(height: 16.h),

          // // ── Other QRs ─────────────────────────────────────
          // ?_buildOtherSection(),

          // ── Add button ────────────────────────────────────
          SizedBox(height: 6.h),
          _AddQrButton(onTap: () => _showPickerSheet()),
        ],
      ),
    );
  }

  Widget? _buildPrimarySection() {
    final primary = _items.where((q) => q.isPrimary).toList();
    if (primary.isEmpty) return null;
    return QrCard(
      item: primary.first,
      onEdit: () => _showPickerSheet(editItem: primary.first),
      onCopy: () => _copy(primary.first),
      onDelete: primary.isNotEmpty && _items.length > 1
          ? () => _delete(primary.first)
          : null,
      onSetPrimary: null, // already primary
    );
  }

  Widget? _buildOtherSection() {
    final others = _items.where((q) => !q.isPrimary).toList();
    if (others.isEmpty) return null;
    return Column(
      children: [
        ...others.map(
          (q) => Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: QrCard(
              item: q,
              onEdit: () => _showPickerSheet(editItem: q),
              onCopy: () => _copy(q),
              onDelete: () => _delete(q),
              onSetPrimary: () => _setPrimary(q),
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _QrCard — single QR card
// ═══════════════════════════════════════════════════════════════
class QrCard extends StatelessWidget {
  final QrItem item;
  final VoidCallback onEdit;
  final VoidCallback onCopy;
  final VoidCallback? onDelete;
  final VoidCallback? onSetPrimary;

  const QrCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onCopy,
    this.onDelete,
    this.onSetPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        // border: Border.all(color: Colors.black.withOpacity(0.07), width: 0.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Column(
          children: [
            // ── Header ────────────────────────────────────────
            _buildHeader(),
            Container(height: 0.5, color: Colors.black.withOpacity(0.05)),
            // ── QR Image ──────────────────────────────────────
            Padding(
              padding: EdgeInsets.all(14.r),
              child: Column(
                children: [
                  _buildQrImage(),
                  SizedBox(height: 10.h),
                  Text(
                    'ລູກຄ້າສະແກນ QR ນີ້ເພື່ອໂອນເງິນໃຫ້ທ່ານ',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: const Color(0xFF9B9BAD),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _ActionBtn(
                    icon: Icons.delete_outline_rounded,
                    label: 'ລຶບບັນຊີອອກ',
                    isDanger: true,
                    onTap: onDelete!,
                  ),
                ],
              ),
            ),
            // ── Set primary row ────────────────────────────────
            if (onSetPrimary != null) ...[
              Container(height: 0.5, color: Colors.black.withOpacity(0.05)),
              _SetPrimaryRow(onTap: onSetPrimary!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 11.h),
      child: Row(
        children: [
          Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              color: item.bankBg,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.account_balance_outlined,
              size: 16.r,
              color: item.bankColor,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.bankName,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                if (item.accountNumber.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Text(
                    item.accountNumber,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: const Color(0xFF9B9BAD),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (item.isPrimary)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: AppColors.star.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                '★ ບັນຊີຫຼັກ',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.star,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQrImage() {
    final hasImage = item.imageFile != null || item.imageUrl != null;
    final size = item.isPrimary ? 160.w : 130.w;

    return GestureDetector(
      onTap: onEdit,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8FC),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: Colors.black.withOpacity(0.08), width: 0.5),
        ),
        child: hasImage
            ? ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: item.imageFile != null
                    ? Image.file(
                        item.imageFile!,
                        width: size,
                        height: size,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        item.imageUrl!,
                        width: size,
                        height: size,
                        fit: BoxFit.cover,
                      ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.qr_code_2_rounded,
                    size: 48.r,
                    color: const Color(0xFFD0D0E0),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'ກົດເພື່ອເພີ່ມ QR',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: const Color(0xFF9B9BAD),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ── Action button ──────────────────────────────────────────────
class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isPrimary;
  final bool isDanger;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isPrimary = false,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    Color fg = const Color(0xFF6B6B80);
    Color bg = const Color(0xFFF8F8FC);
    Color bd = Colors.black.withOpacity(0.09);

    if (isPrimary) {
      fg = Colors.white;
      bg = const Color(0xFF1A1A2E);
      bd = const Color(0xFF1A1A2E);
    } else if (isDanger) {
      fg = const Color(0xFFDC2626);
      bg = Colors.white;
      bd = const Color(0xFFDC2626).withOpacity(0.2);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 36.h,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: bd, width: 0.5),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            color: fg,
          ),
        ),
      ),
    );
  }
}

// ── Set primary row ────────────────────────────────────────────
class _SetPrimaryRow extends StatelessWidget {
  final VoidCallback onTap;
  const _SetPrimaryRow({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 10.h),
        child: Row(
          children: [
            Icon(
              Icons.star_outline_rounded,
              size: 13.r,
              color: const Color(0xFF9B9BAD),
            ),
            SizedBox(width: 6.w),
            Text(
              'ຕັ້ງເປັນ QR ຫຼັກ',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF9B9BAD),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _PickerSheet — bottom sheet: gallery / camera
// ═══════════════════════════════════════════════════════════════
class _PickerSheet extends StatelessWidget {
  final VoidCallback onGallery;
  final VoidCallback onCamera;

  const _PickerSheet({required this.onGallery, required this.onCamera});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.12),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 14.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ເລືອກ QR Code',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'ໃຊ້ຮູບ QR ຈາກ app ທະນາຄານຂອງທ່ານ',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: const Color(0xFF9B9BAD),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),

          // Options
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: Colors.black.withOpacity(0.07),
                  width: 0.5,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: Column(
                  children: [
                    _PickerOption(
                      iconBg: const Color(0xFFFFF0F6),
                      iconColor: const Color(0xFFF06292),
                      icon: Icons.photo_library_outlined,
                      label: 'ເລືອກຈາກຄຄັງຮູບ',
                      sub: 'ຮູບ QR ທີ່ save ໄວ້ໃນໂທລະສັບ',
                      onTap: onGallery,
                    ),
                    Container(
                      height: 0.5,
                      color: Colors.black.withOpacity(0.05),
                    ),
                    _PickerOption(
                      iconBg: const Color(0xFFF0F7FF),
                      iconColor: const Color(0xFF42A5F5),
                      icon: Icons.camera_alt_outlined,
                      label: 'ຖ່າຍຮູບ QR',
                      sub: 'ໃຊ້ກ້ອງຖ່າຍ QR ໂດຍກົງ',
                      onTap: onCamera,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),

          // Cancel
          Padding(
            padding: EdgeInsets.only(
              left: 16.w,
              right: 16.w,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
            ),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: double.infinity,
                height: 44.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8FC),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Colors.black.withOpacity(0.08),
                    width: 0.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    'ຍົກເລີກ',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF9B9BAD),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PickerOption extends StatelessWidget {
  final Color iconBg;
  final Color iconColor;
  final IconData icon;
  final String label;
  final String sub;
  final VoidCallback onTap;

  const _PickerOption({
    required this.iconBg,
    required this.iconColor,
    required this.icon,
    required this.label,
    required this.sub,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 12.h),
        child: Row(
          children: [
            Container(
              width: 38.r,
              height: 38.r,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(11.r),
              ),
              child: Icon(icon, size: 17.r, color: iconColor),
            ),
            SizedBox(width: 11.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    sub,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: const Color(0xFF9B9BAD),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 17.r,
              color: const Color(0xFFC4C4D0),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _EmptyState — ສະແດງເມື່ອຍັງບໍ່ມີ QR
// ═══════════════════════════════════════════════════════════════
class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          _InfoBanner(),
          SizedBox(height: 14.h),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18.r),
            ),
            padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
            child: Column(
              children: [
                Container(
                  width: 68.r,
                  height: 68.r,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F8FC),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: Colors.black.withOpacity(0.07),
                      width: 0.5,
                    ),
                  ),
                  child: Icon(
                    Icons.qr_code_2_rounded,
                    size: 34.r,
                    color: const Color(0xFFD0D0E0),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'ຍັງບໍ່ມີ QR Code',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'ເພີ່ມ QR Code ທະນາຄານຂອງທ່ານ\nເພື່ອຮັບເງິນຈາກລູກຄ້າ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF9B9BAD),
                    height: 1.6,
                  ),
                ),
                SizedBox(height: 22.h),
                GestureDetector(
                  onTap: onAdd,
                  child: Container(
                    width: double.infinity,
                    height: 48.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.r),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFF06292), Color(0xFFFF8A80)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFF06292).withOpacity(0.28),
                          blurRadius: 14,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_rounded,
                          size: 16.r,
                          color: Colors.white,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'ເພີ່ມ QR Code ທຳອິດ',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
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

// ═══════════════════════════════════════════════════════════════
//  Shared helper widgets
// ═══════════════════════════════════════════════════════════════
class _InfoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 16.r,
            color: const Color(0xFF3B82F6),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              'QR ທີ່ຕັ້ງເປັນ ຫຼັກ ຈະໂຊໃນໜ້າ Profile ຂອງທ່ານ '
              'ເພື່ອໃຫ້ລູກຄ້າສາມາດສະແກນໂອນເງິນໄດ້ທັນທີ.',
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF1D4ED8),
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddQrButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddQrButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          // border: Border.all(
          //   color: Colors.black.withOpacity(0.12),
          //   width: 1.5,
          //   style: BorderStyle.solid,
          // ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30.r,
              height: 30.r,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0F6),
                borderRadius: BorderRadius.circular(9.r),
              ),
              child: Icon(
                Icons.add_rounded,
                size: 15.r,
                color: const Color(0xFFF06292),
              ),
            ),
            SizedBox(width: 9.w),
            Text(
              'ເພີ່ມ QR ໃໝ່',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFF06292),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
