import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/utils/url_launcher_helper.dart';
import 'package:xaosao/widgets/gradient_app_bar.dart';

class CenterHelperPage extends StatelessWidget {
  const CenterHelperPage({super.key});

  static const _phone = '2091082600';
  static const _email = 'xaosao95@gmail.com';
  static const _website = 'https://xaosao.com';
  static const _tiktok = 'https://www.tiktok.com/@xaosao';
  static const _facebook = 'https://www.facebook.com/xaosao';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: GradientAppBar(
        title: 'ສູນຊ່ວຍເຫຼືອ',
        subtitle: 'ຕິດຕໍ່ທີມງານ Xaosao',
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionLabel('ຕິດຕໍ່ໂດຍກົງ'),
                    SizedBox(height: 10.h),
                    _ContactCard(
                      icon: Icons.phone_rounded,
                      iconBg: const Color(0xFFEDFAF3),
                      iconColor: const Color(0xFF16A34A),
                      label: 'ໂທລະສັບ',
                      value: '+856 $_phone',
                      onTap: () => UrlLauncherHelper.makePhoneCall(_phone),
                    ),
                    SizedBox(height: 8.h),
                    _ContactCard(
                      icon: Icons.message_rounded,
                      iconBg: const Color(0xFFECFDF5),
                      iconColor: const Color(0xFF059669),
                      label: 'WhatsApp',
                      value: '+856 $_phone',
                      onTap: () => UrlLauncherHelper.openWhatsApp(_phone),
                    ),
                    SizedBox(height: 8.h),
                    _ContactCard(
                      icon: Icons.email_outlined,
                      iconBg: const Color(0xFFEFF6FF),
                      iconColor: const Color(0xFF2563EB),
                      label: 'ອີເມວ',
                      value: _email,
                      onTap: () => UrlLauncherHelper.sendEmail(
                        _email,
                        subject: 'ຕິດຕໍ່ Xaosao',
                      ),
                    ),
                    SizedBox(height: 20.h),
                    _SectionLabel('ສື່ສັງຄົມ ແລະ ເວັບໄຊ້'),
                    SizedBox(height: 10.h),
                    _SocialRow(
                      children: [
                        _SocialCard(
                          iconAsset: null,
                          iconData: Icons.language_rounded,
                          iconBg: AppColors.primary.withValues(alpha: 0.10),
                          iconColor: AppColors.primary,
                          label: 'ເວັບໄຊ້',
                          handle: 'xaosao.com',
                          onTap: () => UrlLauncherHelper.launchURL(_website),
                        ),
                        _SocialCard(
                          iconAsset: null,
                          iconData: Icons.facebook_rounded,
                          iconBg: const Color(0xFFEFF6FF),
                          iconColor: const Color(0xFF1877F2),
                          label: 'Facebook',
                          handle: 'xaosao-ເຊົ່າສາວ',
                          onTap: () => UrlLauncherHelper.launchURL(_facebook),
                        ),
                        _SocialCard(
                          iconAsset: null,
                          iconData: Icons.play_circle_fill_rounded,
                          iconBg: const Color(0xFFFFF0F6),
                          iconColor: Colors.black87,
                          label: 'TikTok',
                          handle: 'xaosao-ເຊົ່າສາວ',
                          onTap: () => UrlLauncherHelper.launchURL(_tiktok),
                        ),
                      ],
                    ),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textHint,
        letterSpacing: 0.6,
      ),
    );
  }
}

// ── Contact card ──────────────────────────────────────────────
class _ContactCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String value;
  final String? badge;
  final Color? badgeBg;
  final Color? badgeFg;
  final VoidCallback onTap;

  const _ContactCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.value,
    this.badge,
    this.badgeBg,
    this.badgeFg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.06),
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.07),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, size: 18.r, color: iconColor),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textHint,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (badge != null) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  badge!,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: badgeFg,
                  ),
                ),
              ),
              SizedBox(width: 6.w),
            ],
            Icon(
              Icons.chevron_right_rounded,
              size: 18.r,
              color: AppColors.textDisabled,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Social row (3 equal cards) ────────────────────────────────
class _SocialRow extends StatelessWidget {
  final List<_SocialCard> children;
  const _SocialRow({required this.children});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: children
          .asMap()
          .entries
          .map(
            (e) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: e.key < children.length - 1 ? 8.w : 0,
                ),
                child: e.value,
              ),
            ),
          )
          .toList(),
    );
  }
}

class _SocialCard extends StatelessWidget {
  final String? iconAsset;
  final IconData? iconData;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String handle;
  final VoidCallback onTap;

  const _SocialCard({
    required this.iconAsset,
    required this.iconData,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.handle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 10.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.06),
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.07),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 42.r,
              height: 42.r,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(iconData, size: 20.r, color: iconColor),
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryVariant,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              handle,
              style: TextStyle(fontSize: 9.5.sp, color: AppColors.textHint),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
