import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/models/booking_success_model.dart';
import 'package:xaosao/pages/booking/booking_args.dart';
import 'package:xaosao/pages/dashboard/dasboard_page.dart';
import 'package:xaosao/utils/currency_formatter.dart';
import 'package:xaosao/widgets/app_button.dart';
import 'package:xaosao/widgets/app_network_image.dart';

class BookingSuccessPage extends StatefulWidget {
  final BookingSuccessModel booking;
  final BookingArgs args;
  const BookingSuccessPage({
    super.key,
    required this.booking,
    required this.args,
  });

  @override
  State<BookingSuccessPage> createState() => _BookingSuccessPageState();
}

class _BookingSuccessPageState extends State<BookingSuccessPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _goToMeetups() {
    Get.offAll(
      () => const DashboardPage(initialIndex: 2),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 350),
    );
  }

  String _fmtDate(DateTime? d) =>
      d != null ? DateFormat('dd MMM yyyy, HH:mm').format(d.toLocal()) : '—';

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;
    final args = widget.args;
    final price = booking.price;
    final modelName = booking.model?.firstName ?? args.companionName;
    final modelPhoto = booking.model?.profile ?? args.companionPhoto;
    final serviceName =
        booking.modelService?.service?.name ?? args.service.name ?? '—';

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ── Hero ────────────────────────────────────────
            _Hero(scale: _scale, fade: _fade),
            SizedBox(height: 14.h),
      
            // ── Model chip ──────────────────────────────────
            _ModelChip(
              name: modelName,
              photoUrl: modelPhoto,
            ),
            SizedBox(height: 14.h),
      
            // ── Detail card (includes status) ───────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: _DetailCard(
                status: booking.status,
                rows: [
                  _DetailRow(
                    icon: Icons.design_services_outlined,
                    label: 'ບໍລິການ',
                    value: serviceName,
                  ),
                  _DetailRow(
                    icon: Icons.calendar_today_rounded,
                    label: 'ວັນທີ',
                    value: _fmtDate(booking.startDate),
                  ),
                  if (booking.location != null &&
                      booking.location!.isNotEmpty)
                    _DetailRow(
                      icon: Icons.location_on_outlined,
                      label: 'ສະຖານທີ່',
                      value: booking.location!,
                    ),
                  if (booking.hours != null)
                    _DetailRow(
                      icon: Icons.timer_outlined,
                      label: 'ຈຳນວນຊົ່ວໂມງ',
                      value: '${booking.hours} ຊົ່ວໂມງ',
                    ),
                  if (price != null)
                    _DetailRow(
                      icon: Icons.payments_outlined,
                      label: 'ລາຄາລວມ',
                      value: CurrFormatter.kip(price.toDouble()),
                      valueColor: AppColors.primary,
                      valueBold: true,
                    ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: AppPrimaryButton(
                label: 'ໄປໜ້າການນັດພົບ',
                trailingIcon: Icons.calendar_month_rounded,
                onTap: _goToMeetups,
              ),
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}

// ── Hero section ───────────────────────────────────────────────────────────
class _Hero extends StatelessWidget {
  final Animation<double> scale;
  final Animation<double> fade;
  const _Hero({required this.scale, required this.fade});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(0, 48.h, 0, 30.h),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.pinkGradient,
        ),
      ),
      child: FadeTransition(
        opacity: fade,
        child: Column(
          children: [
            ScaleTransition(
              scale: scale,
              child: Container(
                width: 80.r,
                height: 80.r,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.20),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_rounded,
                  size: 42.r,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'ຈອງສຳເລັດ!',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: -0.3,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'ການຈອງຂອງທ່ານໄດ້ຖືກຮັບແລ້ວ',
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.white.withValues(alpha: 0.75),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Model chip ─────────────────────────────────────────────────────────────
class _ModelChip extends StatelessWidget {
  final String name;
  final String? photoUrl;
  const _ModelChip({required this.name, this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.10),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: photoUrl != null
                ? AppNetworkImage(
                    imageUrl: photoUrl!,
                    width: 36.r,
                    height: 36.r,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 36.r,
                    height: 36.r,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: AppColors.pinkGradient,
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Icon(
                      Icons.person_rounded,
                      size: 18.r,
                      color: Colors.white,
                    ),
                  ),
          ),
          SizedBox(width: 10.w),
          Text(
            name,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(width: 6.w),
          Icon(Icons.verified_rounded, size: 15.r, color: AppColors.primary),
        ],
      ),
    );
  }
}

// ── Detail card ────────────────────────────────────────────────────────────
class _DetailCard extends StatelessWidget {
  final List<_DetailRow> rows;
  final String? status;
  const _DetailCard({required this.rows, this.status});

  @override
  Widget build(BuildContext context) {
    final isPending = status == null || status == 'pending';
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < rows.length; i++) ...[
            rows[i],
            Divider(
              height: 1,
              thickness: 0.5,
              indent: 16.w,
              endIndent: 16.w,
              color: Colors.black.withValues(alpha: 0.05),
            ),
          ],
          // ── Status footer ──────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 6.r,
                  height: 6.r,
                  decoration: BoxDecoration(
                    color: isPending
                        ? const Color(0xFFF59E0B)
                        : const Color(0xFF22C55E),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  isPending ? 'ລໍຖ້າການຢືນຢັນ' : 'ຢືນຢັນແລ້ວ',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: isPending
                        ? const Color(0xFFB45309)
                        : const Color(0xFF15803D),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final bool valueBold;
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.valueBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
      child: Row(
        children: [
          Container(
            width: 32.r,
            height: 32.r,
            decoration: BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, size: 14.r, color: AppColors.textHint),
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
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight:
                        valueBold ? FontWeight.w800 : FontWeight.w600,
                    color: valueColor ?? AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

