import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/l10n/app_localizations.dart';
import 'package:xaosao/models/profile_model.dart';
import 'package:xaosao/constants/app_routes.dart';
import 'package:xaosao/pages/login/getx/login_logic.dart';
import 'package:xaosao/widgets/app_image_preview.dart';
import 'package:xaosao/widgets/app_network_image.dart';
import 'package:xaosao/widgets/gradient_app_bar.dart';

import '../../utils/service_helper.dart';

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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: GradientAppBar(
        title: l10n.profileTitle,
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.edit_outlined, size: 13.r, color: Colors.white),
                    SizedBox(width: 4.w),
                    Text(
                      l10n.commonEdit,
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
                  _SectionLabel(l10n.profileSectionGeneralInfo),
                  SizedBox(height: 6.h),
                  _InfoCard(children: _generalInfoRows(profile, l10n)),
                  SizedBox(height: 14.h),
                  if (widget.isClient) ...[
                    _SectionLabel(l10n.profileSectionAccountInfo),
                    SizedBox(height: 6.h),
                    _InfoCard(
                        children:
                            _accountInfoRows(profile as CustomerProfileModel, l10n)),
                  ] else ...[
                    _SectionLabel(l10n.profileSectionServices),
                    SizedBox(height: 6.h),
                    _InfoCard(
                        children:
                            _servicesRows(profile as ModelProfileModel, l10n)),
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

  List<Widget> _generalInfoRows(BaseProfileModel p, AppLocalizations l10n) {
    final phone = p.whatsapp != null ? '+856 ${p.whatsapp}' : '—';
    final age = _calcAge(p.dob);
    final dob = p.dob != null
        ? '${p.dob!.day.toString().padLeft(2, '0')} / '
            '${p.dob!.month.toString().padLeft(2, '0')} / '
            '${p.dob!.year}'
            '${age != null ? ' · ${l10n.commonAgeYears(age)}' : ''}'
        : '—';

    final rows = <Widget>[
      _InfoRow(
        icon: Icons.person_outline_rounded,
        label: l10n.profileFullName,
        value: p.fullName.isEmpty ? '—' : p.fullName,
      ),
      const _RowDivider(),
      _InfoRow(
        icon: Icons.phone_outlined,
        label: l10n.profilePhone,
        value: phone,
      ),
      const _RowDivider(),
      _InfoRow(
        icon: Icons.people_outline_rounded,
        label: l10n.profileGender,
        value: _genderLabel(p.gender, l10n),
      ),
      const _RowDivider(),
      _InfoRow(
        icon: Icons.calendar_month_outlined,
        label: l10n.registerDob,
        value: dob,
      ),
    ];

    if (p is ModelProfileModel && (p.address?.isNotEmpty ?? false)) {
      rows.addAll([
        const _RowDivider(),
        _InfoRow(
          icon: Icons.location_on_outlined,
          label: l10n.registerAddress,
          value: p.address!,
        ),
      ]);
    }

    return rows;
  }

  List<Widget> _accountInfoRows(CustomerProfileModel p, AppLocalizations l10n) {
    final created = p.createdAt != null
        ? '${p.createdAt!.day.toString().padLeft(2, '0')} '
            '${_monthName(p.createdAt!.month, l10n)} '
            '${p.createdAt!.year}'
        : '—';
    return [
      _InfoRow(
        icon: Icons.lock_outline_rounded,
        label: l10n.registerPassword,
        value: '••••••••',
      ),
      const _RowDivider(),
      _InfoRow(
        icon: Icons.access_time_rounded,
        label: l10n.profileAccountCreated,
        value: created,
      ),
    ];
  }

  List<Widget> _servicesRows(ModelProfileModel p, AppLocalizations l10n) {
    if (p.services.isEmpty) {
      return [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Center(
            child: Text(
              l10n.profileNoServices,
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

  String _genderLabel(String? g, AppLocalizations l10n) {
    switch (g) {
      case 'male':
        return l10n.genderMaleShort;
      case 'female':
        return l10n.genderFemaleShort;
      case 'other':
        return l10n.genderOther;
      default:
        return '—';
    }
  }

  String _monthName(int m, AppLocalizations l10n) {
    final months = [
      l10n.monthLongJan, l10n.monthLongFeb, l10n.monthLongMar, l10n.monthLongApr,
      l10n.monthLongMay, l10n.monthLongJun, l10n.monthLongJul, l10n.monthLongAug,
      l10n.monthLongSep, l10n.monthLongOct, l10n.monthLongNov, l10n.monthLongDec,
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
      return GestureDetector(
        onTap: () => AppImagePreview.show(context, [url]),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(35.r),
          child: AppNetworkImage(
            imageUrl: url,
            width: 70.r,
            height: 70.r,
            accentColor: AppColors.primary,
          ),
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
    final l10n = AppLocalizations.of(context)!;
    final label = isClient ? l10n.profileVerifiedCustomer : l10n.profileVerifiedCompanion;
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
        child: Text(
              ServiceHelper.serviceOriginalName(name),
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.primary,
              ),
            ),
      );
}
