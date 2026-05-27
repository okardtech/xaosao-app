import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_routes.dart';
import 'package:xaosao/pages/login/getx/login_logic.dart';
import 'package:xaosao/pages/profile/components/amberwarning.dart';
import 'package:xaosao/widgets/confirm_sheet.dart';
import 'package:xaosao/pages/profile/components/photo_grid.dart';
import 'package:xaosao/pages/profile/components/profile_constant.dart';
import 'package:xaosao/pages/feedback/getx/feedback_logic.dart';
import 'package:xaosao/pages/home/getx/home_logic.dart';
import 'package:xaosao/pages/notification/getx/notification_setting_logic.dart';
import 'package:xaosao/pages/profile/getx/profile_logic.dart';
import 'package:xaosao/pages/services_manage/getx/service_logic.dart';
import 'package:xaosao/services/storage_service.dart';
import 'package:intl/intl.dart';
import '../../../constants/app_color.dart';
import '../../../widgets/gradient_app_bar.dart';
import '../../package/getx/package_logic.dart';
import '../../wallet/getx/wallet_logic.dart';

class CustomerProfilePage extends StatefulWidget {
  const CustomerProfilePage({super.key});
  @override
  State<CustomerProfilePage> createState() => _CustomerProfilePageState();
}

class _CustomerProfilePageState extends State<CustomerProfilePage> {
  static const _maxPhotos = 6;
  bool _showAmt = true;
  late final ProfileLogic _profileLogic;

  @override
  void initState() {
    super.initState();
    _profileLogic = Get.find<ProfileLogic>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: GradientAppBar(
        title: 'ໂປຣໄຟລ໌',
        subtitle: 'ຈັດການໂປຣໄຟລ໌',
        showBack: false,
        centerTitle: false,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Hero ─────────────────────────────────────────
          SliverToBoxAdapter(child: _buildHero()),

          // ── Body ─────────────────────────────────────────
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 40.h),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── ຮູບພາບ section ──────────────────────────
                Obx(() {
                  final st = _profileLogic.state;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'ຮູບພາບ (${st.photos.length}/$_maxPhotos)',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              letterSpacing: 0.8,
                            ),
                          ),
                          if (st.photos.length < _maxPhotos)
                            AmberWarning(
                              text:
                                  'ຕ້ອງເພີ່ມຄົບ $_maxPhotos ຮູບ '
                                  '— ຍັງຂາດ ${_maxPhotos - st.photos.length} ຮູບ',
                            ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      PhotoGrid(
                        photos: st.photos,
                        maxPhotos: _maxPhotos,
                        onAdd: _profileLogic.pickAndUpload,
                        onRemove: _profileLogic.removePhoto,
                        uploadingIndex: st.uploadingIndex,
                        deletingIndex: st.deletingIndex,
                      ),
                      SizedBox(height: 14.h),
                    ],
                  );
                }),

                // ──────────────────────────────────────────
                const ProfileSectionLabel('ຂໍ້ມູນ'),
                ProfileGroup(
                  children: [
                    ProfileMenuRow(
                      iconBg: AppColors.bg,
                      iconColor: AppColors.primaryVariant,
                      icon: Icons.person_outline_rounded,
                      label: 'ຂໍ້ມູນສ່ວນຕົວ',
                      sub: 'ຊື່, ນາມສະກຸນ, ວັນເດືອນປີ',
                      onTap: () =>
                          Get.toNamed(AppRoutes.profileDetail, arguments: true),
                    ),
                    ProfileMenuRow(
                      iconBg: const Color(0xFFFFF0F6),
                      iconColor: AppColors.primary,
                      icon: Icons.monitor_outlined,
                      label: 'ການຊື້ແພັກເກດ',
                      sub: 'ຊ່ວງໂມງ, ຊ່ວງວັນ ແລະ ຊ່ວງເດືອນ',
                      onTap: () => Get.toNamed(AppRoutes.package),
                    ),
                    ProfileMenuRow(
                      iconBg: AppColors.bg,
                      iconColor: AppColors.primaryVariant,
                      icon: Icons.credit_card_outlined,
                      label: 'ປະຫວັດເຕີມເງິນ',
                      onTap: () => Get.toNamed(AppRoutes.wallet),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // ──────────────────────────────────────────
                const ProfileSectionLabel('ຄວາມປອດໄພ'),
                Obx(() {
                  final customer = Get.find<LoginLogic>().state.customerProfile;
                  return ProfileGroup(
                    children: [
                      ProfileMenuRow(
                        iconBg: const Color(0xFFEDFAF3),
                        iconColor: AppColors.online,
                        icon: Icons.lock_outline_rounded,
                        label: 'ປ່ຽນລະຫັດຜ່ານ',
                        onTap: () => Get.toNamed(AppRoutes.changePassword),
                      ),
                      ProfileMenuRow(
                        iconBg: const Color(0xFFEFF6FF),
                        iconColor: const Color(0xFF3B82F6),
                        icon: Icons.phone_outlined,
                        label: 'ຢືນຢັນເບີໂທ',
                        sub: customer?.whatsapp != null
                            ? '+856 ${customer!.whatsapp}'
                            : null,
                        trailing: customer?.isPhoneVerified == true
                            ? const PBadge(
                                '✓',
                                fg: Color(0xFF15803D),
                                bg: Color(0xFFEDFAF3),
                              )
                            : null,
                        onTap: () {},
                      ),
                    ],
                  );
                }),
                SizedBox(height: 12.h),

                // ──────────────────────────────────────────
                const ProfileSectionLabel('ຕັ້ງຄ່າ'),
                ProfileGroup(
                  children: [
                    ProfileMenuRow(
                      iconBg: AppColors.bg,
                      iconColor: AppColors.primaryVariant,
                      icon: Icons.notifications_none_rounded,
                      label: 'ການແຈ້ງເຕືອນ',
                      sub: 'Push, ອີເມລ, SMS, WhatsApp',
                      onTap: () => Get.toNamed(AppRoutes.notificationSettings),
                    ),
                    ProfileMenuRow(
                      iconBg: AppColors.bg,
                      iconColor: AppColors.primary,
                      icon: Icons.language_rounded,
                      label: 'ພາສາ',
                      sub: 'ລາວ (ພາສາຫຼັກ)',
                      onTap: () {},
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // ──────────────────────────────────────────
                const ProfileSectionLabel('ຊ່ວຍເຫຼືອ'),
                ProfileGroup(
                  children: [
                    ProfileMenuRow(
                      iconBg: AppColors.bg,
                      iconColor: AppColors.primaryVariant,
                      icon: Icons.help_outline_rounded,
                      label: 'ຊ່ວຍເຫຼືອ / FAQ',
                      onTap: () {},
                    ),
                    ProfileMenuRow(
                      iconBg: const Color(0xFFFFF0F6),
                      iconColor: AppColors.primary,
                      icon: Icons.forum_outlined,
                      label: 'ຄຳຕິຊົມ',
                      sub: 'ລາຍງານບັນຫາ ຫຼື ສົ່ງຄຳຄິດເຫັນ',
                      onTap: () => Get.toNamed(AppRoutes.feedback),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // ──────────────────────────────────────────
                ProfileGroup(
                  children: [
                    ProfileMenuRow(
                      iconBg: const Color(0xFFFEF2F2),
                      iconColor: AppColors.primary,
                      icon: Icons.delete_outline_rounded,
                      label: 'ລຶບບັນຊີ',
                      sub: 'ບໍ່ສາມາດຍ້ອນໄດ້',
                      isDanger: true,
                      onTap: () => _confirmDelete(context),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                LogoutButton(onTap: () => _logout(context)),
                SizedBox(height: 12.h),

                const Center(
                  child: Text(
                    'XAOSAO v1.0.0',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFFC4C4D0),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // ── Hero section ────────────────────────────────────────────
  Widget _buildHero() {
    return Obx(() {
      final customer = Get.find<LoginLogic>().state.customerProfile;
      final uploading = _profileLogic.state.profileImageUploading;
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        margin: EdgeInsets.only(right: 16.w, left: 16.w, top: 16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: Colors.white,
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 76.r,
                        height: 76.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image:
                              customer?.profile != null &&
                                  customer!.profile!.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(customer.profile!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                          gradient:
                              customer?.profile == null ||
                                  customer!.profile!.isEmpty
                              ? const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF5C6BC0),
                                    Color(0xFF1A1A2E),
                                  ],
                                )
                              : null,
                          border: Border.all(color: AppColors.bg, width: 2.5),
                        ),
                        child: uploading
                            ? Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black26,
                                ),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      if (!uploading)
                        Positioned(
                          bottom: 1,
                          right: 1,
                          child: GestureDetector(
                            onTap: _profileLogic.updateProfileImage,
                            child: Container(
                              width: 22.r,
                              height: 22.r,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.edit_rounded,
                                size: 10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customer?.fullName.isNotEmpty == true
                              ? customer!.fullName
                              : '—',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primaryVariant,
                            letterSpacing: -0.3,
                          ),
                        ),
                        Text(
                          customer?.whatsapp != null
                              ? '+856 ${customer!.whatsapp}'
                              : '—',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textHint,
                          ),
                        ),
                        // Verified badge
                        if (customer?.isPhoneVerified == true)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 5.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.safetyFg.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.verified_rounded,
                                  size: 12.r,
                                  color: AppColors.online,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  'ຢືນຢັນຕົວຕົນແລ້ວ',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.online,
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
              _WalletCard(
                showAmounts: _showAmt,
                onToggle: () => setState(() => _showAmt = !_showAmt),
                onTopUp: () => Get.toNamed(AppRoutes.wallet),
              ),
            ],
          ),
        ),
      );
    });
  }

  // ── Delete account confirmation ──────────────────────────────
  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await ConfirmSheet.show(
      context,
      title: 'ລຶບບັນຊີ',
      message:
          'ທ່ານແນ່ໃຈບໍ່ທີ່ຕ້ອງການລຶບບັນຊີ?\n'
          'ຂໍ້ມູນທັງໝົດຈະຖືກລຶບຖາວອນ ແລະ ບໍ່ສາມາດຍ້ອນໄດ້.',
      confirmLabel: 'ລຶບ',
      icon: Icons.delete_outline_rounded,
      isDanger: true,
    );
    if (confirmed != true) return;
    _profileLogic.deleteAccount();
  }

  // ── Logout ───────────────────────────────────────────────────
  Future<void> _logout(BuildContext context) async {
    final confirmed = await ConfirmSheet.show(
      context,
      title: 'ອອກຈາກລະບົບ',
      message: 'ທ່ານຕ້ອງການອອກຈາກລະບົບແທ້ບໍ່?',
      confirmLabel: 'ອອກ',
      icon: Icons.logout_rounded,
      isDanger: true,
    );
    if (confirmed != true || !mounted) return;
    Get.find<LoginLogic>().clearState();
    _deleteUserControllers();
    await Get.find<StorageService>().clear();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
  }

  void _deleteUserControllers() {
    Get.delete<HomeLogic>(force: true);
    Get.delete<ProfileLogic>(force: true);
    Get.delete<ServiceLogic>(force: true);
    Get.delete<FeedbackLogic>(force: true);
    Get.delete<NotifSettingLogic>(force: true);
    Get.delete<WalletLogic>(force: true);
    Get.delete<PackageLogic>(force: true);
  }
}

// ═══════════════════════════════════════════════════════════════
//  _WalletCard — pink gradient wallet (customer only)
// ═══════════════════════════════════════════════════════════════
class _WalletCard extends StatelessWidget {
  final bool showAmounts;
  final VoidCallback onToggle;
  final VoidCallback onTopUp;

  const _WalletCard({
    required this.showAmounts,
    required this.onToggle,
    required this.onTopUp,
  });

  String _mask(String v) => '••••••';

  String _fmt(int? n) => '${NumberFormat.decimalPattern().format(n ?? 0)} ກີບ';

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final wallet = Get.find<WalletLogic>().state.wallet;
      final bal = _fmt(wallet?.availableBalance);
      return _buildCard(bal);
    });
  }

  Widget _buildCard(String bal) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.r),
        child: Stack(
          children: [
            Positioned(
              top: -20,
              right: -10,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.bg.withAlpha(100),
                ),
              ),
            ),
            Positioned(
              bottom: -28,
              left: -10,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.bg.withAlpha(100),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 14.w, right: 14.w, top: 6.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'ກະເປົ໋າເງິນ ຍອດຄົງເຫຼືອ',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textHint,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: onToggle,
                        child: Container(
                          width: 26.r,
                          height: 26.r,
                          decoration: BoxDecoration(
                            color: AppColors.border,
                            borderRadius: BorderRadius.circular(7.r),
                          ),
                          child: Icon(
                            showAmounts
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 16.r,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      showAmounts ? bal : _mask(bal),
                      key: ValueKey(showAmounts),
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                        letterSpacing: -0.6,
                      ),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      spacing: 12.w,
                      children: List.generate(2, (index) {
                        return Expanded(
                          child: GestureDetector(
                            onTap: onTopUp,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              decoration: BoxDecoration(
                                color: AppColors.bg,
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.18),
                                  width: 0.5,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    index == 0
                                        ? Icons.arrow_outward_rounded
                                        : Icons.trending_up_rounded,
                                    size: 14.r,
                                    color: AppColors.primary,
                                  ),
                                  SizedBox(width: 5.w),
                                  Text(
                                    index == 0 ? 'ເຕີມເງິນ' : 'ປະຫວັດ',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
