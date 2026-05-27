import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/app_color.dart';

// ═══════════════════════════════════════════════════════════════
//  profile_constants.dart
//  Shared colors, enums, and small tokens for Profile pages.
// ═══════════════════════════════════════════════════════════════

// ── Colors (aligned with ApAppColorss) ───────────────────────────
// abstract class AppColors {
//   static const navy = Color(0xFF1A1A2E);
//   static const pink = Color(0xFFF06292);
//   static const pinkL = Color(0xFFFF8A80);
//   static const bg = Color(0xFFF8F8FC);
//   static const hint = Color(0xFF9B9BAD);
//   static const border = Color(0x12000000);
//   static const surface = Colors.white;
//   static const green = Color(0xFF22C55E);
//   static const red = Color(0xFFDC2626);
// }

// ── Shared menu row ────────────────────────────────────────────
class ProfileMenuRow extends StatelessWidget {
  final Color iconBg;
  final Color iconColor;
  final IconData icon;
  final String label;
  final String? sub;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isDanger;

  const ProfileMenuRow({
    super.key,
    required this.iconBg,
    required this.iconColor,
    required this.icon,
    required this.label,
    this.sub,
    this.trailing,
    this.onTap,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(
                icon,
                size: 14,
                color: isDanger ? AppColors.primary : iconColor,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: isDanger
                          ? AppColors.primary
                          : AppColors.primaryVariant,
                    ),
                  ),
                  if (sub != null) ...[
                    const SizedBox(height: 1),
                    Text(
                      sub!,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[trailing!, const SizedBox(width: 4)],
            const Icon(
              Icons.chevron_right_rounded,
              size: 17,
              color: Color(0xFFC4C4D0),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared group card container ────────────────────────────────
class ProfileGroup extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets? margin;

  const ProfileGroup({super.key, required this.children, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          children: [
            for (int i = 0; i < children.length; i++) ...[
              if (i > 0)
                Container(height: 0.5, color: Colors.black.withOpacity(0.05)),
              children[i],
            ],
          ],
        ),
      ),
    );
  }
}

// ── Section label ──────────────────────────────────────────────
class ProfileSectionLabel extends StatelessWidget {
  final String text;
  const ProfileSectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h, top: 12.h),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

// ── Small badge chip ───────────────────────────────────────────
class PBadge extends StatelessWidget {
  final String text;
  final Color fg;
  final Color bg;

  const PBadge(this.text, {super.key, required this.fg, required this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: fg),
      ),
    );
  }
}

// ── Share + Enable card ────────────────────────────────────────
class ShareEnableCard extends StatelessWidget {
  final bool enabled;
  final VoidCallback onShareTap;
  final VoidCallback onToggle;
  final String enableDesc;

  const ShareEnableCard({
    super.key,
    required this.enabled,
    required this.onShareTap,
    required this.onToggle,
    required this.enableDesc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Column(
          children: [
            // Share row
            InkWell(
              onTap: onShareTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 11,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0F6),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: const Icon(
                        Icons.share_outlined,
                        size: 13,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 9),
                    const Expanded(
                      child: Text(
                        'ແຊຣ໌ Profile Link',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryVariant,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 17,
                      color: Color(0xFFC4C4D0),
                    ),
                  ],
                ),
              ),
            ),
            // Divider
            Container(height: 0.5, color: Colors.black.withOpacity(0.05)),
            // Enable toggle row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ເຊື່ອງໂປຣໄຟຂອງທ່ານ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryVariant,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          enableDesc,
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textHint,
                            height: 1.55,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: onToggle,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 38,
                      height: 22,
                      decoration: BoxDecoration(
                        color: enabled
                            ? AppColors.online
                            : const Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: AnimatedAlign(
                        duration: const Duration(milliseconds: 200),
                        alignment: enabled
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.all(2),
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(9),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 3,
                              ),
                            ],
                          ),
                        ),
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

// ── Logout button ──────────────────────────────────────────────
class LogoutButton extends StatelessWidget {
  final VoidCallback onTap;
  const LogoutButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, size: 14, color: AppColors.primary),
            SizedBox(width: 7),
            Text(
              'ອອກຈາກລະບົບ',
              style: TextStyle(
                fontSize: 13,
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
