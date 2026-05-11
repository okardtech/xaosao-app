import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/models/profile_model.dart';
import 'package:xaosao/pages/login/getx/login_logic.dart';
import 'package:xaosao/pages/profile/components/photo_grid.dart';
import 'package:xaosao/pages/profile/components/profile_constant.dart';
import 'package:xaosao/pages/profile/getx/profile_logic.dart';
import 'package:xaosao/pages/profile/getx/profile_state.dart';

// ═══════════════════════════════════════════════════════════════
//  CompanionProfilePage
// ═══════════════════════════════════════════════════════════════
class CompanionProfilePage extends StatelessWidget {
  const CompanionProfilePage({super.key});

  static const _maxPhotos = 6;

  @override
  Widget build(BuildContext context) {
    final profileLogic = Get.find<ProfileLogic>();
    final loginLogic = Get.find<LoginLogic>();

    return Scaffold(
      backgroundColor: PColor.bg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Obx(() => _buildHero(loginLogic.state.modelProfile)),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 40.h),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Obx(() => _buildPhotoSection(profileLogic, profileLogic.state)),
                SizedBox(height: 20.h),

                // ── ບໍລິການ ──────────────────────────────────
                const ProfileSectionLabel('ບໍລິການຂອງຂ້ອຍ'),
                _ServicesSection(onEdit: () {}),
                SizedBox(height: 20.h),

                // ── QR ───────────────────────────────────────
                const ProfileSectionLabel('QR ໂອນເງິນ'),
                ProfileGroup(children: [
                  _QrRow(bank: 'BCEL — 030 1234 5678', onTap: () {}),
                ]),
                SizedBox(height: 20.h),

                // ── ຂໍ້ມູນ ──────────────────────────────────
                const ProfileSectionLabel('ຂໍ້ມູນ'),
                ProfileGroup(children: [
                  ProfileMenuRow(
                    iconBg: PColor.bg,
                    iconColor: PColor.navy,
                    icon: Icons.person_outline_rounded,
                    label: 'ຂໍ້ມູນສ່ວນຕົວ',
                    sub: 'ຊື່, ທີ່ຢູ່, ຄວາມສູງ',
                    onTap: () {},
                  ),
                  ProfileMenuRow(
                    iconBg: const Color(0xFFFFF0F6),
                    iconColor: PColor.pink,
                    icon: Icons.monitor_outlined,
                    label: 'ແພັກເກດ Companion',
                    sub: 'VIP Elite · ໝົດ 30 ມ.ນ.',
                    trailing: const PBadge('VIP',
                        fg: Color(0xFF92400E), bg: Color(0xFFFFFBEB)),
                    onTap: () {},
                  ),
                ]),
                SizedBox(height: 12.h),

                // ── ຄວາມປອດໄພ ───────────────────────────────
                const ProfileSectionLabel('ຄວາມປອດໄພ'),
                ProfileGroup(children: [
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
                    trailing: const PBadge('✓',
                        fg: Color(0xFF15803D), bg: Color(0xFFEDFAF3)),
                    onTap: () {},
                  ),
                ]),
                SizedBox(height: 12.h),

                ProfileGroup(children: [
                  ProfileMenuRow(
                    iconBg: const Color(0xFFFEF2F2),
                    iconColor: PColor.red,
                    icon: Icons.delete_outline_rounded,
                    label: 'ລຶບບັນຊີ',
                    sub: 'ບໍ່ສາມາດຍ້ອນໄດ້',
                    isDanger: true,
                    onTap: () {},
                  ),
                ]),
                SizedBox(height: 20.h),

                LogoutButton(onTap: () {}),
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

  Widget _buildPhotoSection(ProfileLogic logic, ProfileState st) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShareEnableCard(
          enabled: st.hidden,
          onShareTap: () {},
          onToggle: logic.toggleHidden,
          enableDesc: 'ເຊື່ອງໂປຣໄຟຂອງທ່ານບໍ່ໃຫ້ລູກຄ້າເຫັນ. '
              'ທ່ານສາມາດເປີດ-ປີດໄດ້ຕະຫຼອດເວລາ.',
        ),
        SizedBox(height: 20.h),
        ProfileSectionLabel('ຮູບພາບ (${st.photos.length}/$_maxPhotos)'),
        PhotoGrid(
          photos: st.photos,
          maxPhotos: _maxPhotos,
          onAdd: logic.pickAndUpload,
          onRemove: logic.removePhoto,
          uploadingIndex: st.uploadingIndex,
          deletingIndex: st.deletingIndex,
        ),
        if (st.photos.length < _maxPhotos) ...[
          SizedBox(height: 6.h),
          _AmberWarning(
            text: 'ຕ້ອງເພີ່ມຄົບ $_maxPhotos ຮູບ '
                '— ຍັງຂາດ ${_maxPhotos - st.photos.length} ຮູບ',
          ),
        ],
      ],
    );
  }

  Widget _buildHero(ModelProfileModel? model) {
    final profileLogic = Get.find<ProfileLogic>();
    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Column(children: [
          SizedBox(height: 24.h),
          Obx(() {
            final uploading = profileLogic.state.profileImageUploading;
            return Stack(clipBehavior: Clip.none, children: [
              Container(
                width: 76.r,
                height: 76.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [PColor.pink, PColor.pinkL],
                  ),
                  border: Border.all(color: PColor.bg, width: 2.5),
                  image: model?.profile != null && model!.profile!.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(model.profile!),
                          fit: BoxFit.cover,
                        )
                      : null,
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
                    onTap: profileLogic.updateProfileImage,
                    child: Container(
                      width: 22.r,
                      height: 22.r,
                      decoration: BoxDecoration(
                        color: PColor.pink,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.edit_rounded,
                          size: 10, color: Colors.white),
                    ),
                  ),
                ),
            ]);
          }),
          SizedBox(height: 10.h),
          Text(
            model?.fullName.isNotEmpty == true
                ? model!.fullName
                : 'ຜູ້ໃຊ້',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
              color: PColor.navy,
              letterSpacing: -0.3,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            model?.address?.isNotEmpty == true ? model!.address! : '—',
            style: TextStyle(fontSize: 12.sp, color: PColor.hint),
          ),
          SizedBox(height: 9.h),
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: 11.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                  color: const Color(0xFF42A5F5).withValues(alpha: 0.22),
                  width: 0.5),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.verified_rounded,
                  size: 11, color: Color(0xFF42A5F5)),
              SizedBox(width: 4.w),
              Text(
                'Companion ຢືນຢັນແລ້ວ',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF42A5F5),
                ),
              ),
            ]),
          ),
          SizedBox(height: 14.h),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                    color: Colors.black.withValues(alpha: 0.06), width: 0.5),
              ),
            ),
            child: Row(children: [
              _StatCell(
                  value: '${model?.counts?.totalLikes ?? 0}',
                  label: 'ຖືກໃຈ'),
              _StatCell(
                  value: '${model?.counts?.totalFriends ?? 0}',
                  label: 'ໝູ່'),
              _StatCell(
                  value:
                      '${model?.totalReferredCustomers ?? 0}★',
                  label: 'ຄໍາລິຊົມ'),
              _StatCell(
                  value: '${model?.counts?.totalBookings ?? 0}',
                  label: 'ຈອງ'),
            ]),
          ),
        ]),
      ),
    );
  }
}

// ── Stat cell ──────────────────────────────────────────────────
class _StatCell extends StatelessWidget {
  final String value;
  final String label;
  const _StatCell({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          border: Border(
              left: BorderSide(
                  color: Colors.black.withValues(alpha: 0.06), width: 0.5)),
        ),
        child: Column(children: [
          Text(value,
              style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w900,
                  color: PColor.navy,
                  letterSpacing: -0.3)),
          SizedBox(height: 2.h),
          Text(label,
              style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w600,
                  color: PColor.hint)),
        ]),
      ),
    );
  }
}

// ── Amber warning ──────────────────────────────────────────────
class _AmberWarning extends StatelessWidget {
  final String text;
  const _AmberWarning({required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
            color: const Color(0xFFF59E0B).withValues(alpha: 0.22),
            width: 0.5),
      ),
      child: Row(children: [
        const Icon(Icons.info_outline_rounded,
            size: 13, color: Color(0xFFD97706)),
        SizedBox(width: 7.w),
        Expanded(
            child: Text(text,
                style: const TextStyle(
                    fontSize: 10, color: Color(0xFF78350F), height: 1.5))),
      ]),
    );
  }
}

// ── Services section ───────────────────────────────────────────
class _ServicesSection extends StatelessWidget {
  final VoidCallback onEdit;
  const _ServicesSection({required this.onEdit});
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Wrap(spacing: 6.w, runSpacing: 6.h, children: const [
        _SvcChip('ເພື່ອນສັງຄົມ', PColor.pink, Color(0xFFFFF0F6),
            Color(0x33F06292)),
        _SvcChip('ທ່ອງທ່ຽວ', Color(0xFF42A5F5), Color(0xFFF0F7FF),
            Color(0x3342A5F5)),
        _SvcChip('ນວດ', Color(0xFFAB47BC), Color(0xFFF3F0FF),
            Color(0x33AB47BC)),
      ]),
      SizedBox(height: 8.h),
      ProfileGroup(children: [
        ProfileMenuRow(
          iconBg: const Color(0xFFFFF0F6),
          iconColor: PColor.pink,
          icon: Icons.add_rounded,
          label: 'ແກ້ໄຂ / ເພີ່ມ ບໍລິການ',
          sub: 'ຕັ້ງລາຄາ ແລະ ຄຳອະທິບາຍ',
          onTap: onEdit,
        ),
      ]),
    ]);
  }
}

class _SvcChip extends StatelessWidget {
  final String label;
  final Color fg;
  final Color bg;
  final Color bd;
  const _SvcChip(this.label, this.fg, this.bg, this.bd);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: bd, width: 0.5),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 11.sp, fontWeight: FontWeight.w700, color: fg)),
    );
  }
}

// ── QR compact row ─────────────────────────────────────────────
class _QrRow extends StatelessWidget {
  final String bank;
  final VoidCallback onTap;
  const _QrRow({required this.bank, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 12.h),
        child: Row(children: [
          Container(
            width: 46.r,
            height: 46.r,
            decoration: BoxDecoration(
              color: PColor.bg,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: PColor.border, width: 0.5),
            ),
            child: const Icon(Icons.qr_code_2_rounded,
                size: 26, color: PColor.navy),
          ),
          SizedBox(width: 12.w),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ສະແກນເພື່ອໂອນເງິນ',
                  style: TextStyle(fontSize: 10.sp, color: PColor.hint)),
              SizedBox(height: 2.h),
              Text(bank,
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: PColor.navy)),
            ],
          )),
          const Icon(Icons.chevron_right_rounded,
              size: 17, color: Color(0xFFC4C4D0)),
        ]),
      ),
    );
  }
}
