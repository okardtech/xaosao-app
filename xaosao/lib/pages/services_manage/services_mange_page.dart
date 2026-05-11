import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../login/getx/login_state.dart';
import '../register/components/register_app_bar.dart';

// ═══════════════════════════════════════════════════════════════
//  service_management_page.dart
//  ໜ້າຈັດການບໍລິການ — Companion ເປີດ/ປິດ ແຕ່ລະບໍລິການ
//
//  Usage:
//    Navigator.push(context, MaterialPageRoute(
//      builder: (_) => const ServiceManagementPage()))
// ═══════════════════════════════════════════════════════════════

// ── Service model ──────────────────────────────────────────────
class CompanionService {
  final String id;
  final String name;
  final String priceLabel;
  final Color iconBg;
  final Color iconColor;
  final IconData icon;
  bool enabled;

  CompanionService({
    required this.id,
    required this.name,
    required this.priceLabel,
    required this.iconBg,
    required this.iconColor,
    required this.icon,
    this.enabled = false,
  });
}

// ── Mock services (replace with API data) ─────────────────────
List<CompanionService> _defaultServices() => [
  CompanionService(
    id: 'social',
    name: 'ເພື່ອນສັງຄົມ',
    priceLabel: '500 ກີບ/ຊ.ມ · 2 ຊ.ມ ຂຶ້ນໄປ',
    iconBg: const Color(0xFFFFF0F6),
    iconColor: const Color(0xFFF06292),
    icon: Icons.people_outline_rounded,
    enabled: true,
  ),
  CompanionService(
    id: 'travel',
    name: 'ທ່ອງທ່ຽວ',
    priceLabel: '800 ກີບ/ຊ.ມ · ທັງມື້',
    iconBg: const Color(0xFFF0F7FF),
    iconColor: const Color(0xFF42A5F5),
    icon: Icons.explore_outlined,
    enabled: true,
  ),
  CompanionService(
    id: 'massage',
    name: 'ນວດ',
    priceLabel: '1,200 ກີບ/ຊ.ມ',
    iconBg: const Color(0xFFF3F0FF),
    iconColor: const Color(0xFFAB47BC),
    icon: Icons.spa_outlined,
    enabled: false,
  ),
];

// ═══════════════════════════════════════════════════════════════
//  ServiceManagementPage
// ═══════════════════════════════════════════════════════════════
class ServiceManagementPage extends StatefulWidget {
  const ServiceManagementPage({super.key});

  @override
  State<ServiceManagementPage> createState() => _ServiceManagementPageState();
}

class _ServiceManagementPageState extends State<ServiceManagementPage> {
  final _services = _defaultServices();

  // ── Derived ─────────────────────────────────────────────────
  int get _activeCount => _services.where((s) => s.enabled).length;

  // ── Toggle with haptic ───────────────────────────────────────
  void _toggle(CompanionService svc) {
    HapticFeedback.lightImpact();
    setState(() => svc.enabled = !svc.enabled);
  }

  // ═══════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      appBar: RegisterAppBar(
        role: RegisterRole.companion,
        currentStep: 2,
        title: "ບໍລິການຂອງຂ້ອຍ",
        subtitle: 'ເປີດ-ປິດ ບໍລິການທີ່ຕ້ອງການ',
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 32.h),
          child: Column(
            children: [
              // ── Info banner ──────────────────────────────
              _InfoBanner(),
              SizedBox(height: 14.h),

              // ── Active status pill ───────────────────────
              _ActiveStatusRow(
                activeCount: _activeCount,
                total: _services.length,
              ),
              SizedBox(height: 12.h),

              // ── Service list ─────────────────────────────
              _ServiceList(services: _services, onToggle: _toggle),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _InfoBanner — blue info note
// ═══════════════════════════════════════════════════════════════
class _InfoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 16.r,
            color: const Color(0xFF3B82F6),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              'ເປີດສະເພາະບໍລິການທີ່ທ່ານສາມາດໃຫ້ໄດ້. '
              'ລູກຄ້າຈະເຫັນພຽງລາຍການທີ່ ເປີດ ເທົ່ານັ້ນ.',
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF1D4ED8),
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _ActiveStatusRow — "2 ເປີດ ຈາກ 4 ລາຍການ"
// ═══════════════════════════════════════════════════════════════
class _ActiveStatusRow extends StatelessWidget {
  final int activeCount;
  final int total;
  const _ActiveStatusRow({required this.activeCount, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Active pill
        Container(
          padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: const Color(0xFFEDFAF3),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: const Color(0xFF22C55E).withOpacity(0.25),
              width: 0.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7.r,
                height: 7.r,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF22C55E),
                ),
              ),
              SizedBox(width: 5.w),
              Text(
                '$activeCount ກຳລັງເປີດ',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF15803D),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          'ຈາກ $total ລາຍການ',
          style: TextStyle(fontSize: 12.sp, color: const Color(0xFF9B9BAD)),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _ServiceList — list of service rows with toggle
// ═══════════════════════════════════════════════════════════════
class _ServiceList extends StatelessWidget {
  final List<CompanionService> services;
  final void Function(CompanionService) onToggle;

  const _ServiceList({required this.services, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.black.withOpacity(0.07), width: 0.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Column(
          children: [
            for (int i = 0; i < services.length; i++) ...[
              if (i > 0)
                Container(height: 0.5, color: Colors.black.withOpacity(0.05)),
              _ServiceRow(
                svc: services[i],
                onToggle: () => onToggle(services[i]),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _ServiceRow — single service with icon, info, toggle
// ═══════════════════════════════════════════════════════════════
class _ServiceRow extends StatelessWidget {
  final CompanionService svc;
  final VoidCallback onToggle;

  const _ServiceRow({required this.svc, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      color: svc.enabled ? Colors.white : const Color(0xFFFAFAFD),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 13.h),
        child: Row(
          children: [
            // ── Icon ──────────────────────────────────────────
            AnimatedOpacity(
              opacity: svc.enabled ? 1.0 : 0.45,
              duration: const Duration(milliseconds: 220),
              child: Container(
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(
                  color: svc.iconBg,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(svc.icon, size: 18.r, color: svc.iconColor),
              ),
            ),
            SizedBox(width: 12.w),

            // ── Info ──────────────────────────────────────────
            Expanded(
              child: AnimatedOpacity(
                opacity: svc.enabled ? 1.0 : 0.50,
                duration: const Duration(milliseconds: 220),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          svc.name,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),
                        SizedBox(width: 6.w),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: svc.enabled
                              ? _Badge(
                                  key: const ValueKey('on'),
                                  text: 'ເປີດຢູ່',
                                  fg: const Color(0xFF15803D),
                                  bg: const Color(0xFFEDFAF3),
                                )
                              : _Badge(
                                  key: const ValueKey('off'),
                                  text: 'ປິດ',
                                  fg: const Color(0xFF9B9BAD),
                                  bg: const Color(0xFFF8F8FC),
                                ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      svc.priceLabel,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF9B9BAD),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10.w),

            // ── Toggle ────────────────────────────────────────
            GestureDetector(
              onTap: onToggle,
              child: _ToggleSwitch(enabled: svc.enabled),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Animated toggle switch ─────────────────────────────────────
class _ToggleSwitch extends StatelessWidget {
  final bool enabled;
  const _ToggleSwitch({required this.enabled});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: 44.w,
      height: 24.h,
      decoration: BoxDecoration(
        color: enabled ? const Color(0xFF22C55E) : const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        alignment: enabled ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.all(2.r),
          width: 20.r,
          height: 20.r,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Icon(
            enabled ? Icons.check_rounded : Icons.close_rounded,
            size: 12.r,
            color: enabled ? const Color(0xFF22C55E) : const Color(0xFFBBBBCC),
          ),
        ),
      ),
    );
  }
}

// ── Status badge ───────────────────────────────────────────────
class _Badge extends StatelessWidget {
  final String text;
  final Color fg;
  final Color bg;
  const _Badge({
    super.key,
    required this.text,
    required this.fg,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}
