import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/models/profile_model.dart';
import 'package:xaosao/constants/app_routes.dart';
import 'package:xaosao/pages/login/getx/login_logic.dart';
import 'package:xaosao/widgets/app_network_image.dart';
import 'package:xaosao/widgets/gradient_app_bar.dart';

class ProfileDetailPage extends StatefulWidget {
  final bool isClient;
  const ProfileDetailPage({super.key, required this.isClient});

  @override
  State<ProfileDetailPage> createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> {
  void _goToEdit(BaseProfileModel profile) {
    Get.toNamed(
      AppRoutes.updateInfo,
      arguments: {'isClient': widget.isClient, 'profile': profile},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: GradientAppBar(
        title: 'ໂປຣໄຟລ໌',
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: GestureDetector(
              onTap: () {
                final state = Get.find<LoginLogic>().state;
                final p = widget.isClient
                    ? state.customerProfile
                    : state.modelProfile;
                if (p != null) _goToEdit(p);
              },
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                      color: Colors.white.withValues(alpha: 0.7), width: 0.8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.edit_outlined, size: 13.r, color: Colors.white),
                    SizedBox(width: 4.w),
                    Text(
                      'ແກ້ໄຂ',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: GetX<LoginLogic>(
        builder: (logic) {
          final BaseProfileModel? profile = widget.isClient
              ? logic.state.customerProfile
              : logic.state.modelProfile;

          if (profile == null) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 2,
              ),
            );
          }

          return SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 32.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ProfileHeader(profile: profile, isClient: widget.isClient),
                  SizedBox(height: 16.h),
                  _SectionLabel('ຂໍ້ມູນທົ່ວໄປ'),
                  SizedBox(height: 6.h),
                  _InfoCard(children: _generalInfoRows(profile)),
                  SizedBox(height: 14.h),
                  if (widget.isClient) ...[
                    _SectionLabel('ຂໍ້ມູນບັນຊີ'),
                    SizedBox(height: 6.h),
                    _InfoCard(
                        children:
                            _accountInfoRows(profile as CustomerProfileModel)),
                  ] else ...[
                    _SectionLabel('ບໍລິການ'),
                    SizedBox(height: 6.h),
                    _InfoCard(
                        children:
                            _servicesRows(profile as ModelProfileModel)),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  int? _calcAge(DateTime? dob) {
    if (dob == null) return null;
    final now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) age--;
    return age;
  }

  List<Widget> _generalInfoRows(BaseProfileModel p) {
    final phone = p.whatsapp != null ? '+856 ${p.whatsapp}' : '—';
    final age = _calcAge(p.dob);
    final dob = p.dob != null
        ? '${p.dob!.day.toString().padLeft(2, '0')} / '
            '${p.dob!.month.toString().padLeft(2, '0')} / '
            '${p.dob!.year}'
            '${age != null ? ' · $age ປີ' : ''}'
        : '—';

    final rows = <Widget>[
      _InfoRow(
        icon: Icons.person_outline_rounded,
        label: 'ຊື່-ນາມສະກຸນ',
        value: p.fullName.isEmpty ? '—' : p.fullName,
      ),
      const _RowDivider(),
      _InfoRow(
        icon: Icons.phone_outlined,
        label: 'ເບີໂທ',
        value: phone,
      ),
      const _RowDivider(),
      _InfoRow(
        icon: Icons.people_outline_rounded,
        label: 'ເພດ',
        value: _genderLabel(p.gender),
      ),
      const _RowDivider(),
      _InfoRow(
        icon: Icons.calendar_month_outlined,
        label: 'ວັນເດືອນປີເກີດ',
        value: dob,
      ),
    ];

    if (p is ModelProfileModel && (p.address?.isNotEmpty ?? false)) {
      rows.addAll([
        const _RowDivider(),
        _InfoRow(
          icon: Icons.location_on_outlined,
          label: 'ທີ່ຢູ່',
          value: p.address!,
        ),
      ]);
    }

    return rows;
  }

  List<Widget> _accountInfoRows(CustomerProfileModel p) {
    final created = p.createdAt != null
        ? '${p.createdAt!.day.toString().padLeft(2, '0')} '
            '${_monthName(p.createdAt!.month)} '
            '${p.createdAt!.year}'
        : '—';
    return [
      _InfoRow(
        icon: Icons.lock_outline_rounded,
        label: 'ລະຫັດຜ່ານ',
        value: '••••••••',
      ),
      const _RowDivider(),
      _InfoRow(
        icon: Icons.access_time_rounded,
        label: 'ສ້າງບັນຊີ',
        value: created,
      ),
    ];
  }

  List<Widget> _servicesRows(ModelProfileModel p) {
    if (p.services.isEmpty) {
      return [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Center(
            child: Text(
              'ຍັງບໍ່ມີບໍລິການ',
              style:
                  TextStyle(fontSize: 13.sp, color: AppColors.textHint),
            ),
          ),
        ),
      ];
    }
    return [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: p.services
              .map((s) => _ServiceChip(name: s.serviceName ?? ''))
              .toList(),
        ),
      ),
    ];
  }

  String _genderLabel(String? g) {
    switch (g) {
      case 'male':
        return 'ຊາຍ';
      case 'female':
        return 'ຍິງ';
      case 'other':
        return 'ອື່ນໆ';
      default:
        return '—';
    }
  }

  String _monthName(int m) {
    const months = [
      'ມັງກອນ', 'ກຸມພາ', 'ມີນາ', 'ເມສາ',
      'ພຶດສະພາ', 'ມິຖຸນາ', 'ກໍລະກົດ', 'ສິງຫາ',
      'ກັນຍາ', 'ຕຸລາ', 'ພະຈິກ', 'ທັນວາ',
    ];
    return months[m - 1];
  }
}

// ── Profile header card ───────────────────────────────────────────────

class _ProfileHeader extends StatelessWidget {
  final BaseProfileModel profile;
  final bool isClient;
  const _ProfileHeader({required this.profile, required this.isClient});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          _AvatarCircle(profile: profile, isClient: isClient),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.fullName.isEmpty ? '—' : profile.fullName,
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 3.h),
                if (isClient) ...[
                  if ((profile as CustomerProfileModel).number != null)
                    Text(
                      (profile as CustomerProfileModel).number!,
                      style: TextStyle(
                          fontSize: 12.sp, color: AppColors.textSecondary),
                    ),
                ] else ...[
                  if (profile.whatsapp != null)
                    Text(
                      '+856 ${profile.whatsapp}',
                      style: TextStyle(
                          fontSize: 12.sp, color: AppColors.textSecondary),
                    ),
                ],
                SizedBox(height: 6.h),
                _VerifiedBadge(
                    isClient: isClient, isVerified: profile.isVerified),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  final BaseProfileModel profile;
  final bool isClient;
  const _AvatarCircle({required this.profile, required this.isClient});

  @override
  Widget build(BuildContext context) {
    final url = profile.profile;
    if (url != null && url.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(35.r),
        child: AppNetworkImage(
          imageUrl: url,
          width: 70.r,
          height: 70.r,
          accentColor: AppColors.primary,
        ),
      );
    }
    return Container(
      width: 70.r,
      height: 70.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: isClient
              ? [const Color(0xFF3730A3), AppColors.primaryVariant]
              : [AppColors.secondary, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          profile.firstName?.isNotEmpty == true
              ? profile.firstName![0].toUpperCase()
              : '?',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _VerifiedBadge extends StatelessWidget {
  final bool isClient;
  final bool isVerified;
  const _VerifiedBadge({required this.isClient, required this.isVerified});

  @override
  Widget build(BuildContext context) {
    final label = isClient ? 'ຢືນຢັງແລ້ວ' : 'Companion ຢືນຢັງ';
    final color =
        isVerified ? const Color(0xFF0EA5E9) : AppColors.textHint;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withOpacity(0.35), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isVerified
                ? Icons.verified_rounded
                : Icons.cancel_outlined,
            size: 11.r,
            color: color,
          ),
          SizedBox(width: 3.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(left: 2.w),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
            letterSpacing: 0.3,
          ),
        ),
      );
}

// ── Info card ─────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 14,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      );
}

// ── Info row ─────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(vertical: 11.h),
        child: Row(
          children: [
            Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, size: 18.r, color: AppColors.primary),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

// ── Row divider ────────────────────────────────────────────────────────

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) => Divider(
        height: 0,
        thickness: 0.6,
        color: Colors.black.withOpacity(0.06),
      );
}

// ── Service chip ──────────────────────────────────────────────────────

class _ServiceChip extends StatelessWidget {
  final String name;
  const _ServiceChip({required this.name});

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
              color: AppColors.primary.withOpacity(0.28), width: 0.8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.stars_rounded, size: 12.r, color: AppColors.primary),
            SizedBox(width: 4.w),
            Text(
              name,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      );
}
