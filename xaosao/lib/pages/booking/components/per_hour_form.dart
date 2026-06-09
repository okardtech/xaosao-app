import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/pages/booking/booking_page.dart';
import 'package:xaosao/utils/service_helper.dart';
import 'package:xaosao/pages/booking/getx/booking_logic.dart';
import 'package:xaosao/pages/package/components/subscription_banner.dart';
import 'package:xaosao/pages/wallet/getx/wallet_logic.dart';
import 'package:xaosao/utils/currency_formatter.dart';
import 'package:xaosao/widgets/app_text_field.dart';

class PerHourForm extends StatefulWidget {
  final BookingLogic logic;
  final String modelName;
  const PerHourForm({super.key, required this.logic, required this.modelName});

  @override
  State<PerHourForm> createState() => _PerHourFormState();
}

class _PerHourFormState extends State<PerHourForm> {
  final _locationCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  final _locationFocus = FocusNode();
  final _noteFocus = FocusNode();

  BookingLogic get _logic => widget.logic;

  @override
  void dispose() {
    _locationCtrl.dispose();
    _noteCtrl.dispose();
    _locationFocus.dispose();
    _noteFocus.dispose();
    super.dispose();
  }

  String _fmtDate(DateTime? d) =>
      d != null ? DateFormat('dd MMM yyyy').format(d) : '';

  String _fmtTime(TimeOfDay? t, BuildContext ctx) =>
      t != null ? t.format(ctx) : '';

  void _showTimeSheet() {
    if (_logic.state.date == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => Obx(() {
        final st = _logic.state;

        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 12.h),
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    children: [
                      Container(
                        width: 3.w,
                        height: 16.h,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: AppColors.pinkGradient,
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'ເລືອກເວລາ',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (st.slotsLoading) ...[
                        SizedBox(width: 8.w),
                        SizedBox(
                          width: 14.r,
                          height: 14.r,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          width: 28.r,
                          height: 28.r,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.06),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            size: 15.r,
                            color: AppColors.textHint,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 14.h),
                Flexible(
                  child: GridView.builder(
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 28.h),
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 10.h,
                      crossAxisSpacing: 10.w,
                      childAspectRatio: 1.6,
                    ),
                    itemCount: 48,
                    itemBuilder: (_, i) {
                      final hour = i ~/ 2;
                      final minute = (i % 2) * 30;
                      final t = TimeOfDay(hour: hour, minute: minute);
                      final label =
                          '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
                      final blocked = _logic.isTimeBlocked(t);
                      final booked = blocked && _logic.isTimeBookedBySlot(t);
                      final sel = st.time?.hour == hour && st.time?.minute == minute;
                      return GestureDetector(
                        onTap: blocked
                            ? null
                            : () {
                                _logic.setTime(t);
                                Get.back();
                              },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          decoration: BoxDecoration(
                            gradient: sel
                                ? const LinearGradient(
                                    colors: AppColors.pinkGradient,
                                  )
                                : null,
                            color: booked
                                ? AppColors.commissionBg
                                : blocked
                                    ? Colors.black.withValues(alpha: 0.04)
                                    : sel
                                        ? null
                                        : AppColors.bg,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: booked
                                  ? AppColors.commissionFg.withValues(alpha: 0.25)
                                  : blocked || sel
                                      ? Colors.transparent
                                      : Colors.black.withValues(alpha: 0.08),
                            ),
                            boxShadow: sel
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.2,
                                      ),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: booked
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      label,
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.commissionFg,
                                      ),
                                    ),
                                    SizedBox(height: 1.h),
                                    Text(
                                      'ຈອງແລ້ວ',
                                      style: TextStyle(
                                        fontSize: 9.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.commissionFg
                                            .withValues(alpha: 0.8),
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  label,
                                  style: TextStyle(
                                    fontSize: blocked ? 11.sp : 13.sp,
                                    fontWeight: blocked
                                        ? FontWeight.w500
                                        : FontWeight.w700,
                                    color: blocked
                                        ? Colors.black.withValues(alpha: 0.2)
                                        : sel
                                            ? Colors.white
                                            : AppColors.textSecondary,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  void _showHourSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => Obx(() {
        final selected = _logic.state.hours;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 12.h),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'ຈຳນວນຊົ່ວໂມງ',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            SizedBox(height: 14.h),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 28.h),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10.h,
                  crossAxisSpacing: 10.w,
                  childAspectRatio: 2.2,
                ),
                itemCount: 12,
                itemBuilder: (_, i) {
                  final h = i + 1;
                  final sel = h == selected;
                  return GestureDetector(
                    onTap: () {
                      _logic.setHours(h);
                      Get.back();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      decoration: BoxDecoration(
                        gradient: sel
                            ? const LinearGradient(
                                colors: AppColors.pinkGradient,
                              )
                            : null,
                         color: sel ? null : AppColors.bg,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: sel
                              ? Colors.transparent
                              : Colors.black.withValues(alpha: 0.08),
                        ),
                        boxShadow: sel
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.2,
                                  ),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$h ຊົ່ວໂມງ',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: sel ? Colors.white : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  void _checkWalletAndBook() {
    final wallet = (Get.find<WalletLogic>().state.wallet?.availableBalance ?? 0).toDouble();
    final total = _logic.totalHour;
    if (total > wallet) {
      showInsufficientWalletBanner(
        context,
        walletBalance: wallet,
        serviceRate: total,
      );
      return;
    }
    _logic.submit();
  }

  void _showVariantSheet() {
    final variants = _logic.args.service.variants ?? [];
    if (variants.isEmpty) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => Obx(() {
        final selectedId = _logic.state.selectedVariantId;
        return Padding(
          padding: EdgeInsets.fromLTRB(0, 12.h, 0, 28.h + MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    Container(
                      width: 3.w,
                      height: 16.h,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: AppColors.pinkGradient,
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'ເລືອກປະເພດນວດ',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${variants.length} ປະເພດ',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: variants.asMap().entries.map((entry) {
                    final i = entry.key;
                    final v = entry.value;
                    final sel = v.id != null && v.id == selectedId;
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: i < variants.length - 1 ? 8.h : 0,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          _logic.setVariant(v);
                          Get.back();
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 13.h,
                          ),
                          decoration: BoxDecoration(
                            gradient: sel
                                ? const LinearGradient(
                                    colors: AppColors.pinkGradient,
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  )
                                : null,
                            color: sel ? null : Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: sel
                                  ? Colors.transparent
                                  : Colors.black.withValues(alpha: 0.07),
                            ),
                            boxShadow: sel
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(alpha: 0.28),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Row(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 40.r,
                                height: 40.r,
                                decoration: BoxDecoration(
                                  color: sel
                                      ? Colors.white.withValues(alpha: 0.18)
                                      : AppColors.massageBg,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Icon(
                                  Icons.spa_outlined,
                                  size: 18.r,
                                  color: sel ? Colors.white : AppColors.massageFg,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      v.name ?? '',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w700,
                                        color: sel ? Colors.white : AppColors.textPrimary,
                                      ),
                                    ),
                                    SizedBox(height: 3.h),
                                    Text(
                                      v.pricePerHour != null
                                          ? '${CurrFormatter.format(v.pricePerHour!)} ກີບ / ຊົ່ວໂມງ'
                                          : '—',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: sel
                                            ? Colors.white.withValues(alpha: 0.80)
                                            : AppColors.textHint,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 22.r,
                                height: 22.r,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: sel
                                      ? Colors.white.withValues(alpha: 0.22)
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: sel
                                        ? Colors.white.withValues(alpha: 0.60)
                                        : Colors.black.withValues(alpha: 0.13),
                                    width: 1.5,
                                  ),
                                ),
                                child: sel
                                    ? Icon(Icons.check_rounded, size: 12.r, color: Colors.white)
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: bookingAppBar(_logic),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: SafeArea(
          child: Obx(() {
            final st = _logic.state;

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ── Date & Time ──────────────────────
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                  16.w,
                                  16.h,
                                  16.w,
                                  0,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'ວັນທີນັດໝາຍ',
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                          SizedBox(height: 6.h),
                                          BookingPickerBox(
                                            showInternalLabel: false,
                                            icon: Icons.calendar_today_rounded,
                                            label: '',
                                            value: _fmtDate(st.date),
                                            placeholder: 'ວັນ/ເດືອນ/ປີ',
                                            onTap: () =>
                                                _logic.pickDate(context),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'ເວລາພົບກັນ',
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                          SizedBox(height: 6.h),
                                          BookingPickerBox(
                                            showInternalLabel: false,
                                            icon: Icons.schedule_rounded,
                                            label: '',
                                            value: _fmtTime(st.time, context),
                                            placeholder: 'ຊົ່ວໂມງ:ນາທີ',
                                            onTap: _showTimeSheet,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16.h),
                              // ── Hours (+ Variant if massage) ─────
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'ຈຳນວນຊົ່ວໂມງ',
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                          SizedBox(height: 6.h),
                                          BookingPickerBox(
                                            showInternalLabel: false,
                                            icon: Icons.timer_outlined,
                                            label: '',
                                            value: '${st.hours} ຊົ່ວໂມງ',
                                            placeholder: 'ເລືອກ',
                                            onTap: _showHourSheet,
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (_logic.isMassage) ...[
                                      SizedBox(width: 10.w),
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'ປະເພດນວດ',
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                            SizedBox(height: 6.h),
                                            BookingPickerBox(
                                              showInternalLabel: false,
                                              icon: Icons.spa_outlined,
                                              label: '',
                                              value: st.selectedVariantName ?? '',
                                              placeholder: 'ເລືອກປະເພດ',
                                              onTap: _showVariantSheet,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              SizedBox(height: 16.h),
                              // ── Location ─────────────────────────
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                  16.w,
                                  0,
                                  16.w,
                                  8.h,
                                ),
                                child: BookingSectionLabel('ສະຖານທີ່ນັດພົບ'),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: AppTextField(
                                  controller: _locationCtrl,
                                  focusNode: _locationFocus,
                                  nextFocusNode: _noteFocus,
                                  hint: 'ໃສ່ທີ່ຢູ່ ຫຼື ສະຖານທີ່...',
                                  prefixIcon: Icons.location_on_outlined,
                                  accent: AppColors.primary,
                                  action: TextInputAction.next,
                                  onChanged: _logic.setLocation,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              // ── Note ─────────────────────────────
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                  16.w,
                                  0,
                                  16.w,
                                  8.h,
                                ),
                                child: BookingSectionLabel('ໝາຍເຫດ'),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: AppTextField(
                                  controller: _noteCtrl,
                                  focusNode: _noteFocus,
                                  hint: 'ໃສ່ຄຳແນະນຳ (ທາງເລືອກ)',
                                  prefixIcon: Icons.notes_rounded,
                                  accent: AppColors.primary,
                                  action: TextInputAction.done,
                                  maxLines: 3,
                                  onChanged: _logic.setNote,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              // ── Tip toggle ────────────────────────
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                  16.w,
                                  0,
                                  16.w,
                                  14.h,
                                ),
                                child: Row(
                                  children: [
                                    AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      width: 38.r,
                                      height: 38.r,
                                      decoration: BoxDecoration(
                                        color: st.hasTip
                                            ? AppColors.primary.withValues(
                                                alpha: 0.1,
                                              )
                                            : AppColors.bg,
                                        borderRadius: BorderRadius.circular(
                                          11.r,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.volunteer_activism_rounded,
                                        size: 18.r,
                                        color: st.hasTip
                                            ? AppColors.primary
                                            : AppColors.textHint,
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'ທິບ / ບໍລິການ',
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          SizedBox(height: 2.h),
                                          Text(
                                            'ເພີ່ມທິບໃຫ້ ${widget.modelName}',
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: AppColors.textHint,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Transform.scale(
                                      scale: 0.8,
                                      alignment: Alignment.centerRight,
                                      child: CupertinoSwitch(
                                        value: st.hasTip,
                                        onChanged: (_) => _logic.toggleTip(),
                                        activeTrackColor: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const BookingDivider(),
                              // ── Summary ──────────────────────────
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                  16.w,
                                  14.h,
                                  16.w,
                                  18.h,
                                ),
                                child: BookingSummary(
                                  rateLabel: _logic.isMassage
                                      ? (st.selectedVariantName ??
                                          ServiceHelper.serviceOriginalName(
                                            _logic.args.service.name,
                                          ))
                                      : ServiceHelper.serviceOriginalName(
                                          _logic.args.service.name,
                                        ),
                                  rateValue:
                                      '${CurrFormatter.format(_logic.rate)} ກີບ / ຊມ',
                                  countLabel: 'ຈຳນວນຊົ່ວໂມງ',
                                  countValue: '${st.hours} ຊມ',
                                  total: _logic.totalHour,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                BookingBottomBar(
                  canBook: _logic.canBookHour,
                  onBook: _checkWalletAndBook,
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
