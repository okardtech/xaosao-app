import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ═══════════════════════════════════════════════════════════════
//  CancellationPolicyBanner
//  Collapsible banner ສະແດງນະໂຍບາຍຍົກເລີກ 3 ຂັ້ນ:
//    ✅ ກ່ອນ 30 ນາທີ → ຄືນ 100%
//    ⚠️ ຫຼັງ 30 ນາທີ → ຄືນ 50%
//    ❌ ຫຼັງເລີ່ມນັດ → ຄືນ 0%
// ═══════════════════════════════════════════════════════════════
class CancellationPolicyBanner extends StatefulWidget {
  /// ເລີ່ມ expand ຫຼື collapse
  final bool initiallyExpanded;

  const CancellationPolicyBanner({
    super.key,
    this.initiallyExpanded = true,
  });

  @override
  State<CancellationPolicyBanner> createState() =>
      _CancellationPolicyBannerState();
}

class _CancellationPolicyBannerState extends State<CancellationPolicyBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _expand;
  late final Animation<double> _rotate;
  bool _isExpanded = true;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      value: _isExpanded ? 1.0 : 0.0,
    );
    _expand = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
    _rotate = Tween(begin: 0.0, end: 0.5)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _isExpanded = !_isExpanded);
    if (_isExpanded) {
      _ctrl.forward();
    } else {
      _ctrl.reverse();
    }
  }

  // ══════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: Colors.black.withOpacity(0.08),
          width: 0.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            SizeTransition(
              sizeFactor: _expand,
              axisAlignment: -1,
              child: _buildBody(),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header row (always visible) ─────────────────────────────
  Widget _buildHeader() {
    return GestureDetector(
      onTap: _toggle,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
        child: Row(children: [
          // Shield icon
          Container(
            width: 26.r, height: 26.r,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0F6),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.shield_outlined,
              size: 13.r,
              color: const Color(0xFFF06292),
            ),
          ),
          SizedBox(width: 8.w),

          // Title
          Expanded(
            child: Text(
              'ນະໂຍບາຍຍົກເລີກ & ຄືນເງິນ',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1A1A2E),
              ),
            ),
          ),

          // Toggle label + chevron
          Text(
            _isExpanded ? 'ຫຍໍ້' : 'ດູເພີ່ມ',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFC4C4D0),
            ),
          ),
          SizedBox(width: 3.w),
          RotationTransition(
            turns: _rotate,
            child: Icon(
              Icons.keyboard_arrow_up_rounded,
              size: 16.r,
              color: const Color(0xFFC4C4D0),
            ),
          ),
        ]),
      ),
    );
  }

  // ── Body: rules + note ─────────────────────────────────────
  Widget _buildBody() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Divider
        Divider(
          height: 0, thickness: 0.5,
          color: Colors.black.withOpacity(0.06),
        ),

        // Rule 1 ✅
        _PolicyRule(
          iconBg: const Color(0xFFEDFAF3),
          icon: Icons.check_rounded,
          iconColor: const Color(0xFF22C55E),
          title: 'ຍົກເລີກກ່ອນ 30 ນາທີ',
          subtitle: 'ຄືນເງິນທັນທີ ພາຍໃນ 24 ຊ.ມ.',
          badge: '100%',
          badgeBg: const Color(0xFFEDFAF3),
          badgeFg: const Color(0xFF15803D),
          isLast: false,
        ),

        // Rule 2 ⚠️
        _PolicyRule(
          iconBg: const Color(0xFFFFFBEB),
          icon: Icons.warning_amber_rounded,
          iconColor: const Color(0xFFF59E0B),
          title: 'ຍົກເລີກຫຼັງ 30 ນາທີ',
          subtitle: 'ຄືນເງິນພາຍໃນ 24 ຊ.ມ.',
          badge: '50%',
          badgeBg: const Color(0xFFFFFBEB),
          badgeFg: const Color(0xFF92400E),
          isLast: false,
        ),

        // Rule 3 ❌
        _PolicyRule(
          iconBg: const Color(0xFFFEF2F2),
          icon: Icons.close_rounded,
          iconColor: const Color(0xFFB91C1C),
          title: 'ຍົກເລີກຫຼັງເລີ່ມນັດ',
          subtitle: 'ບໍ່ສາມາດຄືນເງິນໄດ້',
          badge: '0%',
          badgeBg: const Color(0xFFFEF2F2),
          badgeFg: const Color(0xFFB91C1C),
          isLast: true,
        ),

        // Bottom note
        _buildNote(),
      ],
    );
  }

  Widget _buildNote() {
    return Container(
      margin: EdgeInsets.fromLTRB(12.w, 0, 12.w, 10.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8FC),
        borderRadius: BorderRadius.circular(9.r),
        border: Border.all(color: Colors.black.withOpacity(0.06), width: 0.5),
      ),
      child: Row(children: [
        Icon(
          Icons.info_outline_rounded,
          size: 11.r,
          color: const Color(0xFF9B9BAD),
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            'ເງິນຈະຖືກໂອນຄືນໄປຍັງຊ່ອງທາງທີ່ທ່ານຊຳລະ ພາຍໃນ 24 ຊ.ມ.',
            style: TextStyle(
              fontSize: 10.sp,
              color: const Color(0xFF6B6B80),
              height: 1.45,
            ),
          ),
        ),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _PolicyRule — single rule row
// ═══════════════════════════════════════════════════════════════
class _PolicyRule extends StatelessWidget {
  final Color iconBg;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String badge;
  final Color badgeBg;
  final Color badgeFg;
  final bool isLast;

  const _PolicyRule({
    required this.iconBg,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.badgeBg,
    required this.badgeFg,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
          child: Row(children: [
            // Icon box
            Container(
              width: 26.r, height: 26.r,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, size: 13.r, color: iconColor),
            ),
            SizedBox(width: 9.w),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1A1A2E),
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF9B9BAD),
                    ),
                  ),
                ],
              ),
            ),

            // Refund badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: badgeBg,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                badge,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w900,
                  color: badgeFg,
                ),
              ),
            ),
          ]),
        ),
        if (!isLast)
          Divider(
            height: 0, thickness: 0.5,
            indent: 12.w + 26.r + 9.w,
            color: Colors.black.withOpacity(0.05),
          ),
      ],
    );
  }
}