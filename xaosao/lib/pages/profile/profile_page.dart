import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/pages/feedback/getx/feedback_logic.dart';
import 'package:xaosao/pages/home/getx/home_logic.dart';
import 'package:xaosao/pages/login/getx/login_logic.dart';
import 'package:xaosao/pages/notification/getx/notification_setting_logic.dart';
import 'package:xaosao/pages/package/getx/package_logic.dart';
import 'package:xaosao/pages/services_manage/getx/service_logic.dart';
import 'package:xaosao/pages/profile/components/amberwarning.dart';
import 'package:xaosao/widgets/confirm_sheet.dart';
import 'package:xaosao/pages/profile/components/photo_grid.dart';
import 'package:xaosao/pages/profile/components/qr_row.dart';
import 'package:xaosao/pages/profile/components/services_section.dart';
import 'package:xaosao/pages/profile/components/state_cell.dart';
import 'package:xaosao/pages/profile/getx/profile_logic.dart';
import '../../constants/app_color.dart';
import '../../constants/app_routes.dart';
import '../../models/profile_model.dart';
import '../../services/storage_service.dart';
import '../package/package_page.dart';
import '../qr_manage/qr_mange_page.dart';
import '../services_manage/services_mange_page.dart';
import '../model_wallet/getx/model_wallet_logic.dart';
import 'components/profile_constant.dart';

// ═══════════════════════════════════════════════════════════════
//  ProfilePage — ໜ້າ Profile ຜູ້ໃຊ້
//
//  CustomScrollView layout (scroll ທັງໝົດ):
//    SliverToBoxAdapter → hero (avatar + wallet card)
//    SliverToBoxAdapter → menu groups
//    SliverToBoxAdapter → logout + version
// ═══════════════════════════════════════════════════════════════
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const _maxPhotos = 6;
  late final ProfileLogic _profileLogic;

  @override
  void initState() {
    super.initState();
    _profileLogic = Get.find<ProfileLogic>();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final logic = Get.find<LoginLogic>();
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Obx(() {
                final model = logic.state.modelProfile;
                return _buildHero(model);
              }),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 0),
                child: Column(
                  children: [
                    _MenuSection(
                      label: 'ຂໍ້ມູນ',
                      items: [
                        _MenuItem(
                          iconBg: AppColors.surfaceSecondary,
                          icon: Icons.person_outline_rounded,
                          iconColor: AppColors.textPrimary,
                          label: 'ຂໍ້ມູນສ່ວນຕົວ',
                          subtitle: 'ຊື່, ນາມສະກຸນ, ວັນເດືອນປີເກີດ',
                          onTap: () => Get.toNamed(
                            AppRoutes.profileDetail,
                            arguments: false,
                          ),
                        ),
                        _MenuItem(
                          iconBg: AppColors.surfaceSecondary,
                          icon: Icons.payment_outlined,
                          iconColor: AppColors.textPrimary,
                          label: 'ຂໍ້ມູນທາງການເງິນ',
                          subtitle: 'ບັນຊີເງິນ, ບັດເຄຣດິດ, ການໂອນເງິນ',
                          onTap: () => Get.toNamed(AppRoutes.modelWallet),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),

                    _MenuSection(
                      label: 'ຄວາມປອດໄພ',
                      items: [
                        _MenuItem(
                          iconBg: const Color(0xFFEDFAF3),
                          icon: Icons.lock_outline_rounded,
                          iconColor: AppColors.online,
                          label: 'ປ່ຽນລະຫັດຜ່ານ',
                          onTap: () => Get.toNamed(AppRoutes.changePassword),
                        ),
                        _MenuItem(
                          iconBg: const Color(0xFFEFF6FF),
                          icon: Icons.phone_outlined,
                          iconColor: const Color(0xFF3B82F6),
                          label: 'ຢືນຢັນເບີໂທ',
                          subtitle: '+856 20 1234 5678',
                          badge: 'ຢືນຢັນແລ້ວ',
                          badgeBg: const Color(0xFFEDFAF3),
                          badgeFg: const Color(0xFF15803D),
                          onTap: () {},
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),

                    _MenuSection(
                      label: 'ຕັ້ງຄ່າ',
                      items: [
                        _MenuItem(
                          iconBg: AppColors.surfaceSecondary,
                          icon: Icons.language_rounded,
                          iconColor: AppColors.textPrimary,
                          label: 'ພາສາ',
                          subtitle: 'ລາວ (ພາສາຫຼັກ)',
                          onTap: () {},
                        ),
                        _MenuItem(
                          iconBg: const Color(0xFFFFFBEB),
                          icon: Icons.notifications_outlined,
                          iconColor: const Color(0xFFF59E0B),
                          label: 'ການແຈ້ງເຕືອນ',
                          subtitle: 'Push, ອີເມລ, SMS, WhatsApp',
                          onTap: () =>
                              Get.toNamed(AppRoutes.notificationSettings),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),

                    _MenuSection(
                      label: 'ຊ່ວຍເຫຼືອ',
                      items: [
                        _MenuItem(
                          iconBg: AppColors.surfaceSecondary,
                          icon: Icons.help_outline_rounded,
                          iconColor: AppColors.textPrimary,
                          label: 'ຊ່ວຍເຫຼືອ / FAQ',
                          onTap: () {},
                        ),
                        _MenuItem(
                          iconBg: AppColors.primary.withValues(alpha: 0.10),
                          icon: Icons.forum_outlined,
                          iconColor: AppColors.primary,
                          label: 'ຄຳຕິຊົມ',
                          subtitle: 'ລາຍງານບັນຫາ ຫຼື ສົ່ງຄຳຄິດເຫັນ',
                          onTap: () => Get.toNamed(AppRoutes.feedback),
                        ),
                        _MenuItem(
                          iconBg: AppColors.surfaceSecondary,
                          icon: Icons.description_outlined,
                          iconColor: AppColors.textPrimary,
                          label: 'ຂໍ້ກຳນົດ ແລະ ນະໂຍບາຍ',
                          onTap: () {},
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),

                    // Danger zone
                    _MenuSection(
                      items: [
                        _MenuItem(
                          iconBg: const Color(0xFFFEF2F2),
                          icon: Icons.delete_outline_rounded,
                          iconColor: const Color(0xFFDC2626),
                          label: 'ລຶບບັນຊີ',
                          subtitle: 'ການດຳເນີນການນີ້ບໍ່ສາມາດຍ້ອນໄດ້',
                          subtitleColor: const Color(0xFFFCA5A5),
                          labelColor: const Color(0xFFDC2626),
                          onTap: () => _confirmDelete(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Logout + version ──────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 32.h),
                child: Column(
                  children: [
                    _LogoutButton(onTap: () => _confirmLogout(context)),
                    SizedBox(height: 14.h),
                    Text(
                      'XAOSAO v1.0.0',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDisabled,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
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
    Get.delete<PackageLogic>(force: true);
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await ConfirmSheet.show(
      context,
      title: 'ລຶບບັນຊີ',
      message:
          'ທ່ານແນ່ໃຈບໍ່ທີ່ຕ້ອງການລຶບບັນຊີ?\nຂໍ້ມູນທັງໝົດຈະຖືກລຶບຖາວອນ ແລະ ບໍ່ສາມາດຍ້ອນໄດ້.',
      confirmLabel: 'ລຶບ',
      icon: Icons.delete_outline_rounded,
      isDanger: true,
    );
    if (confirmed != true) return;
    _profileLogic.deleteAccount();
  }

  // ── Hero section ────────────────────────────────────────────
  Widget _buildHero(ModelProfileModel? model) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 0),
      child: Column(
        children: [
          // ── Profile card ──────────────────────────────────
          Obx(() {
            final uploading = _profileLogic.state.profileImageUploading;
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: AppColors.border, width: 0.5),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Avatar + edit button
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 76.r,
                            height: 76.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image:
                                  model?.profile != null &&
                                      model!.profile!.isNotEmpty
                                  ? DecorationImage(
                                      image: NetworkImage(model.profile!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                              gradient:
                                  model?.profile == null ||
                                      model!.profile!.isEmpty
                                  ? const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFF5C6BC0),
                                        Color(0xFF1A1A2E),
                                      ],
                                    )
                                  : null,
                              border: Border.all(
                                color: AppColors.bg,
                                width: 2.5,
                              ),
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
                                  child: Icon(
                                    Icons.edit_rounded,
                                    size: 10.r,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(width: 14.w),
                      // Name + phone + verify
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              model?.fullName.isNotEmpty == true
                                  ? model!.fullName
                                  : '—',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.3,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              model?.whatsapp != null
                                  ? '+856 ${model!.whatsapp}'
                                  : '—',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.textHint,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            if (model?.isPhoneVerified == true)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.online.withValues(
                                    alpha: 0.08,
                                  ),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.verified_rounded,
                                      size: 11.r,
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
                  // ── Divider ─────────────────────────────────
                  // Padding(
                  //   padding: EdgeInsets.symmetric(vertical: 12.h),
                  //   child: Divider(
                  //     height: 0,
                  //     thickness: 0.5,
                  //     color: Colors.black.withValues(alpha: 0.06),
                  //   ),
                  // ),
                  // ── Stats row ────────────────────────────────
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      StatCell(
                        value: '${model?.counts?.totalLikes}',
                        label: 'ຖືກໃຈ',
                        isBorder: false,
                      ),
                      StatCell(
                        value: '${model?.counts?.totalFriends}',
                        label: 'ໝູ່',
                      ),
                      StatCell(
                        value: '${model?.totalReferredCustomers}★',
                        label: 'ຄໍາລິຊົມ',
                      ),
                      StatCell(
                        value: '${model?.counts?.totalBookings}',
                        label: 'ຈອງ',
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
          SizedBox(height: 16.h),
          Obx(() {
            final st = _profileLogic.state;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShareEnableCard(
                  enabled: st.hidden,
                  onShareTap: () {},
                  onToggle: _profileLogic.toggleHidden,
                  enableDesc:
                      'ເຊື່ອງໂປຣໄຟຂອງທ່ານບໍ່ໃຫ້ລູກຄ້າເຫັນ. '
                      'ທ່ານສາມາດເປີດ-ປີດໄດ້ຕະຫຼອດເວລາ.',
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'ຮູບພາບ (${st.photos.length}/$_maxPhotos)',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textHint,
                        letterSpacing: 0.8,
                      ),
                    ),
                    if (st.photos.length < _maxPhotos) ...[
                      AmberWarning(
                        text:
                            'ຕ້ອງເພີ່ມຄົບ $_maxPhotos ຮູບ '
                            '— ຍັງຂາດ ${_maxPhotos - st.photos.length} ຮູບ',
                      ),
                    ],
                  ],
                ),
                PhotoGrid(
                  photos: st.photos,
                  maxPhotos: _maxPhotos,
                  onAdd: _profileLogic.pickAndUpload,
                  onRemove: _profileLogic.removePhoto,
                  uploadingIndex: st.uploadingIndex,
                  deletingIndex: st.deletingIndex,
                ),
              ],
            );
          }),
          SizedBox(height: 20.h),
          Row(
            children: [
              Text(
                'ບໍລິການຂອງຂ້ອຍ',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textHint,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ServicesSection(
            services: model?.services ?? [],
            onEdit: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ServiceManagementPage(),
                ),
              );
            },
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Text(
                'QR ຂອງຂ້ອຍ',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textHint,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ProfileGroup(
            children: [
              QrRow(
                bank: 'BCEL — 030 1234 5678',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const QrManagementPage()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _MenuSection — group of menu rows with optional label
// ═══════════════════════════════════════════════════════════════
class _MenuSection extends StatelessWidget {
  final String? label;
  final List<_MenuItem> items;

  const _MenuSection({this.label, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textHint,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: 6.h),
        ],
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(color: AppColors.border, width: 0.5),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.r),
            child: Column(
              children: items.asMap().entries.map((e) {
                final isFirst = e.key == 0;
                return Column(
                  children: [
                    if (!isFirst)
                      Divider(
                        height: 0,
                        thickness: 0.5,
                        color: Colors.black.withOpacity(0.05),
                      ),
                    e.value,
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _MenuItem — single menu row
// ═══════════════════════════════════════════════════════════════
class _MenuItem extends StatelessWidget {
  final Color iconBg;
  final IconData icon;
  final Color iconColor;
  final String label;
  final Color? labelColor;
  final String? subtitle;
  final Color? subtitleColor;
  final String? badge;
  final Color? badgeBg;
  final Color? badgeFg;
  final VoidCallback onTap;

  const _MenuItem({
    required this.iconBg,
    required this.icon,
    required this.iconColor,
    required this.label,
    this.labelColor,
    this.subtitle,
    this.subtitleColor,
    this.badge,
    this.badgeBg,
    this.badgeFg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 12.h),
        child: Row(
          children: [
            // Icon box
            Container(
              width: 30.r,
              height: 30.r,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(9.r),
              ),
              child: Icon(icon, size: 14.r, color: iconColor),
            ),
            SizedBox(width: 10.w),

            // Label + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: labelColor ?? AppColors.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 1.h),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: subtitleColor ?? AppColors.textHint,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Badge + chevron
            if (badge != null) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  badge!,
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w800,
                    color: badgeFg,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
            ],
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
//  _LogoutButton
// ═══════════════════════════════════════════════════════════════
class _LogoutButton extends StatelessWidget {
  final VoidCallback onTap;
  const _LogoutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 13.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout_rounded,
              size: 15.r,
              color: const Color(0xFFDC2626),
            ),
            SizedBox(width: 7.w),
            Text(
              'ອອກຈາກລະບົບ',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFDC2626),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _ConfirmDialog — reusable confirm dialog
