import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/pages/login/getx/login_logic.dart';
import 'package:xaosao/pages/login/login_page.dart';
import 'package:xaosao/pages/profile/components/amberwarning.dart';
import 'package:xaosao/pages/profile/components/photo_grid.dart';
import 'package:xaosao/pages/profile/components/profile_constant.dart';
import 'package:xaosao/pages/profile/getx/profile_logic.dart';
import 'package:xaosao/services/storage_service.dart';

// ═══════════════════════════════════════════════════════════════
//  CustomerProfilePage
//  Layout:
//    · Hero (white): avatar, name, verified badge, WalletCard
//    · Body (CustomScrollView):
//      - ຮູບພາບ header + PhotoGrid
//      - ຂໍ້ມູນ group (ຂໍ້ມູນສ່ວນຕົວ, ແພັກ, ປະຫວັດ)
//      - ຄວາມປອດໄພ group
//      - ຕັ້ງຄ່າ group
//      - ລຶບບັນຊີ
//      - LogoutButton + version
// ═══════════════════════════════════════════════════════════════
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
      backgroundColor: PColor.bg,
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
                              color: PColor.hint,
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
                      iconBg: PColor.bg,
                      iconColor: PColor.navy,
                      icon: Icons.person_outline_rounded,
                      label: 'ຂໍ້ມູນສ່ວນຕົວ',
                      sub: 'ຊື່, ນາມສະກຸນ, ວັນເດືອນປີ',
                      onTap: () {},
                    ),
                    ProfileMenuRow(
                      iconBg: const Color(0xFFFFF0F6),
                      iconColor: PColor.pink,
                      icon: Icons.monitor_outlined,
                      label: 'ການຊື້ແພັກເກດ',
                      sub: 'VIP Elite · ໝົດ 30 ມ.ນ.',
                      trailing: const PBadge(
                        'VIP',
                        fg: Color(0xFF92400E),
                        bg: Color(0xFFFFFBEB),
                      ),
                      onTap: () {},
                    ),
                    ProfileMenuRow(
                      iconBg: PColor.bg,
                      iconColor: PColor.navy,
                      icon: Icons.credit_card_outlined,
                      label: 'ປະຫວັດເຕີມເງິນ',
                      onTap: () {},
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // ──────────────────────────────────────────
                const ProfileSectionLabel('ຄວາມປອດໄພ'),
                Obx(() {
                  final customer =
                      Get.find<LoginLogic>().state.customerProfile;
                  return ProfileGroup(
                    children: [
                      ProfileMenuRow(
                        iconBg: const Color(0xFFEDFAF3),
                        iconColor: PColor.green,
                        icon: Icons.lock_outline_rounded,
                        label: 'ປ່ຽນລະຫັດຜ່ານ',
                        onTap: () {},
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
                      iconBg: PColor.bg,
                      iconColor: PColor.navy,
                      icon: Icons.notifications_none_rounded,
                      label: 'ການແຈ້ງເຕືອນ',
                      onTap: () {},
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // ──────────────────────────────────────────
                ProfileGroup(
                  children: [
                    ProfileMenuRow(
                      iconBg: const Color(0xFFFEF2F2),
                      iconColor: PColor.red,
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
        color: Colors.white,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              SizedBox(height: 24.h),
              // Avatar
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 76.r,
                    height: 76.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: customer?.profile != null &&
                              customer!.profile!.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(customer.profile!),
                              fit: BoxFit.cover,
                            )
                          : null,
                      gradient: customer?.profile == null ||
                              customer!.profile!.isEmpty
                          ? const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF5C6BC0), Color(0xFF1A1A2E)],
                            )
                          : null,
                      border: Border.all(color: PColor.bg, width: 2.5),
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
                            color: PColor.pink,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
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
              SizedBox(height: 10.h),
              Text(
                customer?.fullName.isNotEmpty == true
                    ? customer!.fullName
                    : '—',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                  color: PColor.navy,
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                customer?.whatsapp != null
                    ? '+856 ${customer!.whatsapp}'
                    : '—',
                style: TextStyle(fontSize: 12.sp, color: PColor.hint),
              ),
              SizedBox(height: 9.h),
              // Verified badge
              if (customer?.isPhoneVerified == true)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 11.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: const Color(0xFF42A5F5).withValues(alpha: 0.22),
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.verified_rounded,
                        size: 11,
                        color: Color(0xFF42A5F5),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'ຢືນຢັນຕົວຕົນແລ້ວ',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF42A5F5),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 16.h),

              // Wallet card
              Padding(
                padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 8.h),
                child: _WalletCard(
                  showAmounts: _showAmt,
                  onToggle: () => setState(() => _showAmt = !_showAmt),
                  onTopUp: () {},
                ),
              ),
              Container(
                height: 0.5,
                color: Colors.black.withValues(alpha: 0.06),
              ),
            ],
          ),
        ),
      );
    });
  }

  // ── Delete account confirmation ──────────────────────────────
  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => _ConfirmDialog(
        title: 'ລຶບບັນຊີ',
        content:
            'ທ່ານແນ່ໃຈບໍ່ທີ່ຕ້ອງການລຶບບັນຊີ?\n'
            'ຂໍ້ມູນທັງໝົດຈະຖືກລຶບຖາວອນ ແລະ ບໍ່ສາມາດຍ້ອນໄດ້.',
        confirmLabel: 'ລຶບ',
        isDanger: true,
        onConfirm: () {
          Navigator.pop(context);
          _profileLogic.deleteAccount();
        },
      ),
    );
  }

  // ── Logout ───────────────────────────────────────────────────
  Future<void> _logout(BuildContext context) async {
    await Get.find<StorageService>().clear();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
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

  @override
  Widget build(BuildContext context) {
    const bal = '125,000 ກີບ';

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [PColor.pink, PColor.pinkL],
        ),
        boxShadow: [
          BoxShadow(
            color: PColor.pink.withValues(alpha: 0.30),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
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
                  color: Colors.white.withValues(alpha: 0.10),
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
                  color: Colors.white.withValues(alpha: 0.07),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'ກະເປົ໋າເງິນ ຍອດຄົງເຫຼືອ',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.white.withValues(alpha: 0.55),
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
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(7.r),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.20),
                              width: 0.5,
                            ),
                          ),
                          child: Icon(
                            showAmounts
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 12.r,
                            color: Colors.white.withValues(alpha: 0.9),
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
                        color: Colors.white,
                        letterSpacing: -0.6,
                      ),
                    ),
                  ),
                  SizedBox(height: 11.h),
                  GestureDetector(
                    onTap: onTopUp,
                    child: Container(
                      width: double.infinity,
                      height: 36.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.18),
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_rounded, size: 14.r, color: Colors.white),
                          SizedBox(width: 5.w),
                          Text(
                            'ເຕີມເງິນ',
                            style: TextStyle(
                              fontSize: 12.sp,
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
      ),
    );
  }
}


// ═══════════════════════════════════════════════════════════════
//  _ConfirmDialog
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
          color: PColor.hint,
          height: 1.5,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'ຍົກເລີກ',
            style: TextStyle(fontSize: 13.sp, color: PColor.hint),
          ),
        ),
        TextButton(
          onPressed: onConfirm,
          child: Text(
            confirmLabel,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w800,
              color: isDanger ? PColor.red : PColor.pink,
            ),
          ),
        ),
      ],
    );
  }
}
