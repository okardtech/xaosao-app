import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/pages/booking/booking_page.dart';
import 'package:xaosao/pages/booking/getx/booking_logic.dart';
import 'package:xaosao/utils/currency_formatter.dart';
import 'package:xaosao/widgets/app_text_field.dart';

class PerDayForm extends StatefulWidget {
  final BookingLogic logic;
  final String modelName;
  const PerDayForm({super.key, required this.logic, required this.modelName});

  @override
  State<PerDayForm> createState() => _PerDayFormState();
}

class _PerDayFormState extends State<PerDayForm> {
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

  String _fmt(DateTime? d) =>
      d != null ? DateFormat('dd MMM yyyy').format(d) : '';

  @override
  Widget build(BuildContext context) {
    final isNight = _logic.args.service.billingType == 'per_night';
    final unit = isNight ? 'ຄືນ' : 'ວັນ';

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: bookingAppBar(_logic),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: SafeArea(
          child: Obx(() {
          final st = _logic.state;
          final days = _logic.days;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Single white card ──────────────────────
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
                            // ── Date range ────────────────────────
                            Padding(
                              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'ວັນທີອອກເດີນທາງ',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        SizedBox(height: 6.h),
                                        BookingPickerBox(
                                          showInternalLabel: false,
                                          icon:
                                              Icons.play_circle_outline_rounded,
                                          label: '',
                                          value: _fmt(st.startDate),
                                          placeholder: 'ວັນ/ເດືອນ/ປີ',
                                          onTap: () =>
                                              _logic.pickStartDate(context),
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
                                          'ວັນທີກັບມາ',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        SizedBox(height: 6.h),
                                        BookingPickerBox(
                                          showInternalLabel: false,
                                          icon: Icons.flag_rounded,
                                          label: '',
                                          value: _fmt(st.endDate),
                                          placeholder: 'ວັນ/ເດືອນ/ປີ',
                                          onTap: () =>
                                              _logic.pickEndDate(context),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16.h),
                            // ── Location ─────────────────────────
                            Padding(
                              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
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
                              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
                              child: BookingSectionLabel('ການເເຕ່ງກາຍ'),
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
                              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 14.h),
                              child: Row(
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 38.r,
                                    height: 38.r,
                                    decoration: BoxDecoration(
                                      color: st.hasTip
                                          ? AppColors.primary.withValues(
                                              alpha: 0.1,
                                            )
                                          : AppColors.bg,
                                      borderRadius: BorderRadius.circular(11.r),
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
                                            fontSize: 14.sp,
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
                            // ── Summary ───────────────────────────
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                16.w,
                                14.h,
                                16.w,
                                18.h,
                              ),
                              child: BookingSummary(
                                rateLabel:
                                    _logic.args.service.name ?? "noservice",
                                rateValue:
                                    '${CurrFormatter.format(_logic.rate)} ກີບ / $unit',
                                countLabel: 'ຈຳນວນ$unit',
                                countValue: '$days $unit',
                                total: _logic.totalDay,
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
                canBook: _logic.canBookDay,
                onBook: _logic.submit,
              ),
            ],
          );
        }),
        ),
      ),
    );
  }
}
