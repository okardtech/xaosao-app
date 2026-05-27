import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xaosao/pages/booking/booking_args.dart';
import 'package:xaosao/pages/booking/booking_success_page.dart';
import 'package:xaosao/pages/booking/getx/booking_state.dart';
import 'package:xaosao/repository/booking_repo.dart';
import 'package:xaosao/utils/picker_date.dart' as pickers;
import 'package:xaosao/widgets/show_loading_alert.dart';

class BookingLogic extends GetxController {
  final BookingArgs args;
  BookingLogic({required this.args});

  final _state = const BookingState().obs;
  BookingState get state => _state.value;
  Rx<BookingState> get rxState => _state;

  // ── Per-hour setters ─────────────────────────────────────────
  void setDate(DateTime d) => _state.value = state.copyWith(date: d);
  void setTime(TimeOfDay t) => _state.value = state.copyWith(time: t);
  void setHours(int h) => _state.value = state.copyWith(hours: h);

  // ── Per-day setters ──────────────────────────────────────────
  void setStartDate(DateTime d) {
    final shouldClear = state.endDate != null && !state.endDate!.isAfter(d);
    _state.value = state.copyWith(startDate: d, clearEnd: shouldClear);
  }

  void setEndDate(DateTime d) => _state.value = state.copyWith(endDate: d);

  // ── Common setters ───────────────────────────────────────────
  void setLocation(String v) => _state.value = state.copyWith(location: v);
  void setNote(String v) => _state.value = state.copyWith(note: v);
  void toggleTip() => _state.value = state.copyWith(hasTip: !state.hasTip);

  // ── Pickers ──────────────────────────────────────────────────
  Future<void> pickDate(BuildContext context) async {
    final d = await pickers.pickDate(context, firstDate: DateTime.now());
    if (d != null) setDate(d);
  }

  Future<void> pickTime(BuildContext context) async {
    final t = await pickers.pickTime(context);
    if (t != null) setTime(t);
  }

  Future<void> pickStartDate(BuildContext context) async {
    final d = await pickers.pickDate(context, firstDate: DateTime.now());
    if (d != null) setStartDate(d);
  }

  Future<void> pickEndDate(BuildContext context) async {
    final first = state.startDate;
    final d = await pickers.pickDate(
      context,
      firstDate: first,
      initialDate: first,
    );
    if (d != null) setEndDate(d);
  }

  // ── Computed ─────────────────────────────────────────────────
  double get rate {
    final svc = args.service;
    switch (svc.billingType) {
      case 'per_hour':
        return svc.customRate ?? (svc.customHourlyRate ?? 0.0);
      case 'per_night':
        return svc.customOneNightPrice ?? svc.customRate ?? 0;
      default:
        return svc.customRate ?? 0;
    }
  }

  int get days {
    final s = state.startDate;
    final e = state.endDate;
    if (s == null || e == null) return 1;
    final diff = e.difference(s).inDays;
    return diff < 1 ? 1 : diff;
  }

  double get totalHour => rate * state.hours;
  double get totalDay => rate * days;

  bool get canBookHour =>
      state.date != null &&
      state.time != null &&
      state.location.trim().isNotEmpty;

  bool get canBookDay =>
      state.startDate != null &&
      state.endDate != null &&
      state.location.trim().isNotEmpty;

  // ── Submit ───────────────────────────────────────────────────
  Future<void> submit() async {
    showLoadingDialog();

    final billingType = args.service.billingType;
    final isDay =
        billingType == 'per_day' || billingType == 'per_night';

    final res = isDay
        ? await BookingRepo().bookingPerDay(
            modelServiceId: args.service.id ?? '',
            startDate: state.startDate!.toUtc().toIso8601String(),
            endDate: state.endDate!.toUtc().toIso8601String(),
            location: state.location,
            preferredAttire: state.note.isNotEmpty ? state.note : null,
            hasTip: state.hasTip,
          )
        : await BookingRepo().bookingPerHour(
            modelServiceId: args.service.id ?? '',
            startDate: _combinedDateTime().toUtc().toIso8601String(),
            hours: state.hours,
            location: state.location,
            preferredAttire: state.note.isNotEmpty ? state.note : null,
            hasTip: state.hasTip,
          );

    hideLoadingDialog();

    if (res.success && res.data != null) {
      _state.value = state.copyWith(booking: res.data);
      Get.offAll(
        () => BookingSuccessPage(booking: res.data!, args: args),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 400),
      );
    } else {
      Get.snackbar(
        'ການຈອງລົ້ມເຫຼວ',
        res.message ?? 'ກະລຸນາລອງໃໝ່ອີກຄັ້ງ',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFFF1F1),
        colorText: const Color(0xFFB91C1C),
        margin: const EdgeInsets.all(16),
        borderRadius: 14,
      );
    }
  }

  DateTime _combinedDateTime() {
    final d = state.date!;
    final t = state.time!;
    return DateTime(d.year, d.month, d.day, t.hour, t.minute);
  }
}
