import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/pages/login/getx/login_logic.dart';
import 'package:xaosao/pages/login/login_page.dart';
import 'package:xaosao/pages/profile/components/amberwarning.dart';
import 'package:xaosao/pages/profile/components/photo_grid.dart';
import 'package:xaosao/pages/profile/components/qr_row.dart';
import 'package:xaosao/pages/profile/components/services_section.dart';
import 'package:xaosao/pages/profile/components/state_cell.dart';
import 'package:xaosao/pages/profile/getx/profile_logic.dart';
import '../../constants/app_color.dart';
import '../../models/profile_model.dart';
import '../../services/storage_service.dart';
import '../onboarding/onboarding_page.dart';
import '../package/package_page.dart';
import '../qr_manage/qr_mange_page.dart';
import '../services_manage/services_mange_page.dart';
import '../wallet/wallet_page.dart';
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
                          onTap: () {},
                        ),
                        _MenuItem(
                          iconBg: AppColors.surfaceSecondary,
                          icon: Icons.payment_outlined,
                          iconColor: AppColors.textPrimary,
                          label: 'ຂໍ້ມູນທາງການເງິນ',
                          subtitle: 'ບັນຊີເງິນ, ບັດເຄຣດິດ, ການໂອນເງິນ',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const WalletPage(),
                              ),
                            );
                          },
                        ),
                        _MenuItem(
                          iconBg: AppColors.socialBg,
                          icon: Icons.desktop_mac_outlined,
                          iconColor: AppColors.primary,
                          label: 'ການຊື້ແພັກເກດ',
                          subtitle: 'ໝົດ 30 ມ.ນ. 2027 23:59 ໂມງ',
                          badge: '24 ຊົ່ວໂມງ',
                          badgeBg: const Color(0xFFFFFBEB),
                          badgeFg: const Color(0xFF92400E),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PackagePage(),
                              ),
                            );
                          },
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
                          onTap: () {},
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
                          subtitle: 'Push, ອີເມລ, SMS',
                          onTap: () {},
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
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (_) => CompanionProfilePage(),
                            //   ),
                            // );
                          },
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
                          onTap: () {
                            _profileLogic.deleteAccount();
                          },
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
                    _LogoutButton(
                      onTap: () async {
                        final storage = Get.find<StorageService>();
                        await storage.clear();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => LoginPage()),
                          (route) => false,
                        );
                      },
                    ),
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

  // ── Hero section ────────────────────────────────────────────
  Widget _buildHero(ModelProfileModel? model) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 0),
      child: Column(
        children: [
          // Avatar
          Obx(() {
            final uploading = _profileLogic.state.profileImageUploading;
            return Stack(
              children: [
                Container(
                  width: 86.r,
                  height: 86.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: model?.profile != null && model!.profile!.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(model.profile!),
                            fit: BoxFit.cover,
                          )
                        : null,
                    color: AppColors.surfaceSecondary,
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
                        width: 24.r,
                        height: 24.r,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.bg, width: 2),
                        ),
                        child: Icon(
                          Icons.edit_rounded,
                          size: 11.r,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }),
          SizedBox(height: 12.h),

          // Name
          Text(
            model?.fullName ?? "no username",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          SizedBox(height: 3.h),

          // Phone
          Text(
            '+856${model?.whatsapp ?? "-"}',
            style: TextStyle(fontSize: 12.sp, color: AppColors.textHint),
          ),
          SizedBox(height: 9.h),

          // Verified badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
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
                  color: AppColors.safetyFg,
                ),
                SizedBox(width: 4.w),
                Text(
                  'ຢືນຢັນຕົວຕົນແລ້ວ',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.safetyFg,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              StatCell(value: '${model?.counts?.totalLikes}', label: 'ຖືກໃຈ'),
              StatCell(value: '${model?.counts?.totalFriends}', label: 'ໝູ່'),
              StatCell(
                value: '${model?.totalReferredCustomers}★',
                label: 'ຄໍາລິຊົມ',
              ),
              StatCell(value: '${model?.counts?.totalBookings}', label: 'ຈອງ'),
            ],
          ),
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
          // Wallet card
          // _WalletCard(),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _WalletCard — pink gradient card
// ═══════════════════════════════════════════════════════════════
class _WalletCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.pinkGradient, // [#F06292, #FF8A80]
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -22,
            right: -10,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -32,
            left: -12,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.07),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ກະເປົ໋າເງິນ',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withOpacity(0.55),
                        letterSpacing: 0.5,
                      ),
                    ),
                    Container(
                      width: 26.r,
                      height: 26.r,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.account_balance_wallet_outlined,
                        size: 14.r,
                        color: Colors.white.withOpacity(0.80),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),

                // Amount
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '125,000',
                        style: TextStyle(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -0.8,
                          height: 1,
                        ),
                      ),
                      TextSpan(
                        text: ' ກີບ',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'ຍອດເງິນທັງໝົດ',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white.withOpacity(0.40),
                  ),
                ),

                SizedBox(height: 14.h),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: _WalletBtn(
                        icon: Icons.add_rounded,
                        label: 'ເຕີມເງິນ',
                        bg: Colors.white.withOpacity(0.22),
                        border: Colors.white.withOpacity(0.20),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const WalletPage(),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: _WalletBtn(
                        icon: Icons.access_time_rounded,
                        label: 'ປະຫວັດ',
                        bg: Colors.white.withOpacity(0.10),
                        border: Colors.white.withOpacity(0.12),
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WalletBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color bg;
  final Color border;
  final VoidCallback onTap;

  const _WalletBtn({
    required this.icon,
    required this.label,
    required this.bg,
    required this.border,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 34.h,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: border, width: 0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 13.r, color: Colors.white),
            SizedBox(width: 5.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ],
        ),
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
// ═══════════════════════════════════════════════════════════════
class _ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmLabel;
  final bool isDanger;
  final VoidCallback onConfirm;

  const _ConfirmDialog({
    required this.title,
    required this.content,
    required this.confirmLabel,
    this.isDanger = false,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      title: Text(
        title,
        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800),
      ),
      content: Text(
        content,
        style: TextStyle(
          fontSize: 13.sp,
          color: AppColors.textHint,
          height: 1.5,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'ຍົກເລີກ',
            style: TextStyle(fontSize: 13.sp, color: AppColors.textHint),
          ),
        ),
        TextButton(
          onPressed: onConfirm,
          child: Text(
            confirmLabel,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w800,
              color: isDanger ? const Color(0xFFDC2626) : AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
