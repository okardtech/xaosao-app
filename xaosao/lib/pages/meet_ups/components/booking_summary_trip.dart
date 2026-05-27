import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/models/my_booking_model.dart';

// ═══════════════════════════════════════════════════════════════
//  BookingSummaryStrip — compact stat cards
//  Filter string values: null=all, 'active', 'completed', 'cancelled'
// ═══════════════════════════════════════════════════════════════
class BookingSummaryStrip extends StatelessWidget {
  final List<MyBookingModel> bookings;
  final ValueChanged<String?>? onFilterTap;

  const BookingSummaryStrip({
    super.key,
    required this.bookings,
    this.onFilterTap,
  });

  static bool _isActive(String? s) => const {
        'pending', 'confirmed', 'in_progress', 'awaiting_confirmation'
      }.contains(s);
  static bool _isCompleted(String? s) => s == 'completed';
  static bool _isCancelledGroup(String? s) =>
      s == 'cancelled' || s == 'rejected' || s == 'disputed';

  @override
  Widget build(BuildContext context) {
    final total     = bookings.length;
    final active    = bookings.where((b) => _isActive(b.status)).length;
    final completed = bookings.where((b) => _isCompleted(b.status)).length;
    final cancelled = bookings.where((b) => _isCancelledGroup(b.status)).length;

    return Row(children: [
      _SCard(
        count: total, label: 'ທັງໝົດ',
        icon: Icons.calendar_month_outlined,
        accent: const Color(0xFF1A1A2E),
        iconBg: const Color(0xFFF0F0F5),
        iconColor: const Color(0xFF1A1A2E),
        numColor: const Color(0xFF1A1A2E),
        onTap: () => onFilterTap?.call(null),
      ),
      SizedBox(width: 7.w),
      _SCard(
        count: active, label: 'ກຳລັງມາ',
        icon: Icons.access_time_rounded,
        accent: const Color(0xFF3B82F6),
        iconBg: const Color(0xFFEFF6FF),
        iconColor: const Color(0xFF3B82F6),
        numColor: const Color(0xFF3B82F6),
        onTap: () => onFilterTap?.call('active'),
      ),
      SizedBox(width: 7.w),
      _SCard(
        count: completed, label: 'ສຳເລັດ',
        icon: Icons.check_circle_outline_rounded,
        accent: const Color(0xFF22C55E),
        iconBg: const Color(0xFFEDFAF3),
        iconColor: const Color(0xFF22C55E),
        numColor: const Color(0xFF22C55E),
        onTap: () => onFilterTap?.call('completed'),
      ),
      SizedBox(width: 7.w),
      _SCard(
        count: cancelled, label: 'ຍົກເລີກ',
        icon: Icons.cancel_outlined,
        accent: const Color(0xFF9B9BAD),
        iconBg: const Color(0xFFF0F0F5),
        iconColor: const Color(0xFF9B9BAD),
        numColor: const Color(0xFF9B9BAD),
        onTap: () => onFilterTap?.call('cancelled'),
      ),
    ]);
  }
}

class _SCard extends StatelessWidget {
  final int count;
  final String label;
  final IconData icon;
  final Color accent;
  final Color iconBg;
  final Color iconColor;
  final Color numColor;
  final VoidCallback? onTap;

  const _SCard({
    required this.count,
    required this.label,
    required this.icon,
    required this.accent,
    required this.iconBg,
    required this.iconColor,
    required this.numColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: Colors.black.withOpacity(0.07),
              width: 0.5,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(height: 3.h, color: accent),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                  child: Row(
                    children: [
                      Container(
                        width: 26.r, height: 26.r,
                        decoration: BoxDecoration(
                          color: iconBg,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(icon, size: 13.r, color: iconColor),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$count',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w900,
                                color: numColor,
                                height: 1,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              label,
                              style: TextStyle(
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF9B9BAD),
                                letterSpacing: 0.2,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
