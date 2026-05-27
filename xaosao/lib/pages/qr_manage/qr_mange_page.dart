import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/models/bank_account_model.dart';
import 'package:xaosao/utils/image_picker_util.dart';
import 'package:xaosao/widgets/app_network_image.dart';
import 'package:xaosao/widgets/app_button.dart';
import 'package:xaosao/widgets/confirm_sheet.dart';
import 'package:xaosao/widgets/gradient_app_bar.dart';
import 'getx/qr_logic.dart';
import 'getx/qr_state.dart';

// ═══════════════════════════════════════════════════════════════
//  QrManagementPage
// ═══════════════════════════════════════════════════════════════
class QrManagementPage extends StatefulWidget {
  const QrManagementPage({super.key});

  @override
  State<QrManagementPage> createState() => _QrManagementPageState();
}

class _QrManagementPageState extends State<QrManagementPage> {
  late final QrLogic _logic;

  @override
  void initState() {
    super.initState();
    _logic = Get.find<QrLogic>();
  }

  Future<void> _addQr() async {
    final file = await ImagePickerUtil.pick();
    if (file == null) return;
    await _logic.addAccount(file.path);
  }

  Future<void> _editQr(String id) async {
    final file = await ImagePickerUtil.pick();
    if (file == null) return;
    await _logic.updateAccount(id, file.path);
  }

  Future<void> _confirmDelete(String id) async {
    final confirmed = await ConfirmSheet.show(
      context,
      title: 'ລຶບ QR Code',
      message: 'ທ່ານແນ່ໃຈບໍ່ວ່າຕ້ອງການລຶບ QR Code ນີ້?',
      confirmLabel: 'ລຶບ',
      icon: Icons.delete_outline_rounded,
      isDanger: true,
    );
    if (confirmed == true) _logic.deleteAccount(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: GradientAppBar(
        title: 'QR ໂອນເງິນ',
        subtitle: 'ຈັດການ QR Code ຂອງຂ້ອຍ',
      ),
      body: Obx(() => _buildBody(_logic.state)),
    );
  }

  Widget _buildBody(QrState st) {
    if (st.status == QrStatus.initial || st.status == QrStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (st.status == QrStatus.failure && st.accounts.isEmpty) {
      return _ErrorState(onRetry: _logic.loadAccounts);
    }

    if (st.accounts.isEmpty) {
      return _EmptyState(onAdd: _addQr);
    }

    return _buildContent(st.accounts);
  }

  Widget _buildContent(List<BankAccountModel> accounts) {
    final primary = accounts.where((a) => a.isDefault == true).toList();
    final others = accounts.where((a) => a.isDefault != true).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _InfoBanner(),
          SizedBox(height: 16.h),
          if (primary.isNotEmpty)
            QrCard(
              account: primary.first,
              onEdit: () => _editQr(primary.first.id ?? ''),
              onDelete: accounts.length > 1
                  ? () => _confirmDelete(primary.first.id ?? '')
                  : null,
              onSetPrimary: null,
            ),
          ...others.map(
            (a) => Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: QrCard(
                account: a,
                onEdit: () => _editQr(a.id ?? ''),
                onDelete: () => _confirmDelete(a.id ?? ''),
                onSetPrimary: () => _logic.setDefault(a.id ?? ''),
              ),
            ),
          ),
          SizedBox(height: 6.h),
          _AddQrButton(onTap: _addQr),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  QrCard — single QR card
// ═══════════════════════════════════════════════════════════════
class QrCard extends StatelessWidget {
  final BankAccountModel account;
  final VoidCallback onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onSetPrimary;

  const QrCard({
    super.key,
    required this.account,
    required this.onEdit,
    this.onDelete,
    this.onSetPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Column(
          children: [
            _buildHeader(),
            Container(height: 0.5, color: Colors.black.withValues(alpha: 0.05)),
            Padding(
              padding: EdgeInsets.all(14.r),
              child: Column(
                children: [
                  _buildQrImage(),
                  SizedBox(height: 10.h),
                  Text(
                    'ລູກຄ້າສະແກນ QR ນີ້ເພື່ອໂອນເງິນໃຫ້ທ່ານ',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textHint,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      if (onDelete != null) ...[
                        Expanded(
                          child: AppOutlineButton(
                            label: 'ລຶບ',
                            leadingIcon: Icons.delete_outline_rounded,
                            borderColor: const Color(0xFFEF4444).withValues(alpha: 0.5),
                            textColor: const Color(0xFFEF4444),
                            height: 42,
                            onTap: onDelete!,
                          ),
                        ),
                        SizedBox(width: 10.w),
                      ],
                      Expanded(
                        child: AppPrimaryButton(
                          label: 'ແກ້ໄຂ QR',
                          leadingIcon: Icons.edit_outlined,
                          height: 42,
                          onTap: onEdit,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (onSetPrimary != null) ...[
              Container(height: 0.5, color: Colors.black.withValues(alpha: 0.05)),
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
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.account_balance_outlined,
              size: 16.r,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              account.bankAccountName ?? 'ທະນາຄານ',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          if (account.isDefault == true)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: AppColors.star.withValues(alpha: 0.12),
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
    final url = account.qrCode;
    final size = (account.isDefault == true) ? 160.w : 130.w;

    return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.08),
            width: 0.5,
          ),
        ),
        child: url != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: AppNetworkImage(
                  imageUrl: url,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                  errorWidget: _qrPlaceholder(size),
                ),
              )
            : _qrPlaceholder(size),
    );
  }

  Widget _qrPlaceholder(double size) {
    return SizedBox(
      width: size,
      height: size,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.qr_code_2_rounded, size: 48.r, color: AppColors.textDisabled),
          SizedBox(height: 8.h),
          Text(
            'ກົດເພື່ອເພີ່ມ QR',
            style: TextStyle(fontSize: 11.sp, color: AppColors.textHint),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Set primary row
// ═══════════════════════════════════════════════════════════════
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
            Icon(Icons.star_outline_rounded, size: 13.r, color: AppColors.textHint),
            SizedBox(width: 6.w),
            Text(
              'ຕັ້ງເປັນ QR ຫຼັກ',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Empty state — no QR codes yet
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
          const _InfoBanner(),
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
                    color: AppColors.bg,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: Colors.black.withValues(alpha: 0.07),
                      width: 0.5,
                    ),
                  ),
                  child: Icon(
                    Icons.qr_code_2_rounded,
                    size: 34.r,
                    color: AppColors.textDisabled,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'ຍັງບໍ່ມີ QR Code',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'ເພີ່ມ QR Code ທະນາຄານຂອງທ່ານ\nເພື່ອຮັບເງິນຈາກລູກຄ້າ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textHint,
                    height: 1.6,
                  ),
                ),
                SizedBox(height: 22.h),
                AppPrimaryButton(
                  label: 'ເພີ່ມ QR Code ທຳອິດ',
                  leadingIcon: Icons.add_rounded,
                  height: 48,
                  onTap: onAdd,
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
//  Error state
// ═══════════════════════════════════════════════════════════════
class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_off_rounded, size: 48.r, color: AppColors.textDisabled),
          SizedBox(height: 12.h),
          Text(
            'ໂຫຼດຂໍ້ມູນບໍ່ໄດ້',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'ກວດສອບການເຊື່ອມຕໍ່ແລ້ວລອງໃໝ່',
            style: TextStyle(fontSize: 12.sp, color: AppColors.textHint),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            width: 140.w,
            child: AppPrimaryButton(label: 'ລອງໃໝ່', height: 42, onTap: onRetry),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Info banner
// ═══════════════════════════════════════════════════════════════
class _InfoBanner extends StatelessWidget {
  const _InfoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.12),
          width: 0.6,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, size: 15.r, color: AppColors.primary),
          SizedBox(width: 9.w),
          Expanded(
            child: Text(
              'QR ທີ່ຕັ້ງເປັນ ຫຼັກ ຈະໂຊໃນໜ້າ Profile ຂອງທ່ານ '
              'ເພື່ອໃຫ້ລູກຄ້າສາມາດສະແກນໂອນເງິນໄດ້ທັນທີ.',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.primary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Add QR button
// ═══════════════════════════════════════════════════════════════
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
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30.r,
              height: 30.r,
              decoration: BoxDecoration(
                color: AppColors.socialBg,
                borderRadius: BorderRadius.circular(9.r),
              ),
              child: Icon(Icons.add_rounded, size: 15.r, color: AppColors.primary),
            ),
            SizedBox(width: 9.w),
            Text(
              'ເພີ່ມ QR ໃໝ່',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
