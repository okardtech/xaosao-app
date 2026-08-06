import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/l10n/app_localizations.dart';
import 'package:xaosao/models/bank_account_model.dart';
import 'package:xaosao/utils/image_picker_util.dart';
import 'package:xaosao/widgets/app_network_image.dart';
import 'package:xaosao/widgets/app_button.dart';
import 'package:xaosao/widgets/confirm_sheet.dart';
import 'package:xaosao/widgets/gradient_app_bar.dart';
import '../../constants/app_icons.dart';
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
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await ConfirmSheet.show(
      context,
      title: l10n.qrDeleteTitle,
      message: l10n.qrDeleteMessage,
      confirmLabel: l10n.commonDelete,
      icon: AppIcons.delete,
      isDanger: true,
    );
    if (confirmed == true) _logic.deleteAccount(id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: GradientAppBar(
        title: l10n.qrTitle,
        subtitle: l10n.qrSubtitle,
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
//  QrCard — content-first redesign
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
    final l10n = AppLocalizations.of(context)!;
    final isDefault = account.isDefault == true;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: isDefault
              ? AppColors.primary.withValues(alpha: 0.20)
              : Colors.black.withValues(alpha: 0.06),
          width: isDefault ? 1.2 : 0.6,
        ),
        boxShadow: [
          BoxShadow(
            color: isDefault
                ? AppColors.primary.withValues(alpha: 0.10)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.r),
        child: Column(
          children: [
            // ── Gradient accent line (default only) ───────────
            if (isDefault)
              Container(
                height: 3,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: AppColors.pinkGradient),
                ),
              ),
            // ── Header: name + action icons ────────────────────
            _buildHeader(isDefault, l10n),
            // ── QR image hero ──────────────────────────────────
            _buildQrContent(l10n),
            // ── Set-primary footer ─────────────────────────────
            if (onSetPrimary != null) ...[
              Container(
                height: 0.5,
                color: Colors.black.withValues(alpha: 0.05),
              ),
              _SetPrimaryRow(onTap: onSetPrimary!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDefault, AppLocalizations l10n) {
    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 10.w, 14.h),
      child: Row(
        children: [
          // Bank icon
          Container(
            width: 38.r,
            height: 38.r,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(11.r),
            ),
            child: Icon(
              Icons.account_balance_outlined,
              size: 17.r,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: 10.w),
          // Bank name + default label
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.bankAccountName ?? l10n.commonBank,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (isDefault) ...[
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: 10.r,
                        color: AppColors.star,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        l10n.qrDefaultLabel,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.star,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          // ── Action icon buttons ──────────────────────────────
          Row(
            children: [
              _ActionIconButton(
                icon: Icons.edit_outlined,
                iconColor: AppColors.primary,
                bgColor: AppColors.primary.withValues(alpha: 0.08),
                tooltip: l10n.commonEdit,
                onTap: onEdit,
              ),
              if (onDelete != null) ...[
                SizedBox(width: 6.w),
                _ActionIconButton(
                  icon: Icons.delete_outline_rounded,
                  iconColor: const Color(0xFFEF4444),
                  bgColor: const Color(0xFFFEF2F2),
                  tooltip: l10n.commonDelete,
                  onTap: onDelete!,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQrContent(AppLocalizations l10n) {
    final url = account.qrCode;
    final isDefault = account.isDefault == true;
    final imageSize = isDefault ? 200.w : 170.w;
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 18.h),
      child: Column(
        children: [
          Container(
            width: imageSize,
            height: imageSize,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: Colors.black.withValues(alpha: 0.07),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: url != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15.r),
                    child: AppNetworkImage(
                      imageUrl: url,
                      width: imageSize,
                      height: imageSize,
                      fit: BoxFit.cover,
                      errorWidget: _qrPlaceholder(imageSize, l10n),
                    ),
                  )
                : _qrPlaceholder(imageSize, l10n),
          ),
          SizedBox(height: 10.h),
          Text(
            l10n.qrScanHint,
            style: TextStyle(fontSize: 11.sp, color: AppColors.textHint),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _qrPlaceholder(double size, AppLocalizations l10n) {
    return SizedBox(
      width: size,
      height: size,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.qr_code_2_rounded, size: 48.r, color: AppColors.textDisabled),
          SizedBox(height: 8.h),
          Text(
            l10n.qrEmptyTitle,
            style: TextStyle(fontSize: 11.sp, color: AppColors.textHint),
          ),
        ],
      ),
    );
  }
}

// ── Small icon-only action button ─────────────────────────────────
class _ActionIconButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String tooltip;
  final VoidCallback onTap;

  const _ActionIconButton({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 34.r,
          height: 34.r,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, size: 16.r, color: iconColor),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Set primary row — subtle tap-to-promote strip
// ═══════════════════════════════════════════════════════════════
class _SetPrimaryRow extends StatelessWidget {
  final VoidCallback onTap;
  const _SetPrimaryRow({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: AppColors.star.withValues(alpha: 0.08),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
        child: Row(
          children: [
            Container(
              width: 22.r,
              height: 22.r,
              decoration: BoxDecoration(
                color: AppColors.star.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(7.r),
              ),
              child: Icon(
                Icons.star_outline_rounded,
                size: 12.r,
                color: AppColors.star,
              ),
            ),
            SizedBox(width: 9.w),
            Text(
              AppLocalizations.of(context)!.qrSetPrimary,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right_rounded,
              size: 16.r,
              color: AppColors.textDisabled,
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
    final l10n = AppLocalizations.of(context)!;
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
              border: Border.all(
                color: AppColors.textDisabled.withAlpha(50),
                width: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
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
                  l10n.qrEmptyTitle,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  l10n.qrEmptySubtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textHint,
                    height: 1.6,
                  ),
                ),
                SizedBox(height: 22.h),
                AppPrimaryButton(
                  label: l10n.qrEmptyAddFirst,
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
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_off_rounded, size: 48.r, color: AppColors.textDisabled),
          SizedBox(height: 12.h),
          Text(
            l10n.commonLoadDataFailed,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            l10n.commonConnectionRetry,
            style: TextStyle(fontSize: 12.sp, color: AppColors.textHint),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            width: 140.w,
            child: AppPrimaryButton(label: l10n.commonRetry, height: 42, onTap: onRetry),
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
              AppLocalizations.of(context)!.qrInfoBanner,
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
//  Add QR button — subtle dashed-feel secondary action
// ═══════════════════════════════════════════════════════════════
class _AddQrButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddQrButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.18),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 26.r,
              height: 26.r,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(Icons.add_rounded, size: 14.r, color: AppColors.primary),
            ),
            SizedBox(width: 8.w),
            Text(
              AppLocalizations.of(context)!.qrAddNew,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
