import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:xaosao/models/service_model.dart';
import 'package:xaosao/pages/booking/booking_args.dart';
import 'package:xaosao/pages/booking/booking_success_page.dart';
import 'package:xaosao/pages/booking/getx/booking_state.dart';
import 'package:xaosao/pages/wallet/getx/wallet_logic.dart';
import 'package:xaosao/repository/booking_repo.dart';
import 'package:xaosao/utils/picker_date.dart' as pickers;
import 'package:xaosao/utils/app_snackbar.dart';
import 'package:xaosao/utils/l10n.dart';
import 'package:xaosao/widgets/show_loading_alert.dart';

class BookingLogic extends GetxController {
  final BookingArgs args;
  BookingLogic({required this.args});

  final _state = const BookingState().obs;
  BookingState get state => _state.value;
  Rx<BookingState> get rxState => _state;

  // ── Massage detection ────────────────────────────────────────
  bool get isMassage =>
      args.service.name?.toLowerCase().contains('massage') ?? false;

  double? get _variantMinPrice {
    final vs = args.service.variants;
    if (vs == null || vs.isEmpty) return null;
    final prices = vs.map((v) => v.pricePerHour).whereType<double>().toList();
    if (prices.isEmpty) return null;
    return prices.reduce((a, b) => a < b ? a : b);
  }

  // ── Per-hour setters ─────────────────────────────────────────
  @override
  void onReady() {
    super.onReady();
    final bt = args.service.billingType;
    if (bt == 'per_day' || bt == 'per_night') fetchBookedSlots();
  }

  void setDate(DateTime d) {
    _state.value = state.copyWith(date: d, clearTime: true, bookedSlots: []);
    fetchBookedSlots(d);
  }

  void setTime(TimeOfDay t) => _state.value = state.copyWith(time: t);
  void setHours(int h) => _state.value = state.copyWith(hours: h);
  void setVariant(MassageVariant v) => _state.value = state.copyWith(
    selectedVariantId: v.id,
    selectedVariantName: v.name,
    selectedVariantPrice: v.pricePerHour,
  );

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

  // ── Booked slots ─────────────────────────────────────────────
  Future<void> fetchBookedSlots([DateTime? date]) async {
    _state.value = state.copyWith(slotsLoading: true);
    final dateStr = date != null ? DateFormat('yyyy-MM-dd').format(date) : null;
    final res = await BookingRepo().bookedSlots(
      modelId: args.companionId,
      date: dateStr,
    );
    _state.value = state.copyWith(
      slotsLoading: false,
      bookedSlots: res.data ?? [],
    );
  }

  bool isDateBooked(DateTime d) {
    final check = DateTime(d.year, d.month, d.day);
    for (final slot in state.bookedSlots) {
      final start = slot.startDate?.toLocal();
      final end = slot.endDate?.toLocal();
      if (start == null || end == null) continue;
      final s = DateTime(start.year, start.month, start.day);
      final e = DateTime(end.year, end.month, end.day);
      if (!check.isBefore(s) && check.isBefore(e)) return true;
    }
    return false;
  }

  bool isTimeBlocked(TimeOfDay t) {
    final date = state.date;
    if (date == null) return true;

    final now = DateTime.now();
    final isToday = date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;

    if (isToday) {
      final slot = DateTime(now.year, now.month, now.day, t.hour, t.minute);
      if (!slot.isAfter(now)) return true;
    }

    return isTimeBookedBySlot(t);
  }

  bool isTimeBookedBySlot(TimeOfDay t) {
    final date = state.date;
    if (date == null) return false;
    final candidate = DateTime(date.year, date.month, date.day, t.hour, t.minute);
    for (final slot in state.bookedSlots) {
      final start = slot.startDate?.toLocal();
      final end = slot.endDate?.toLocal();
      if (start == null || end == null) continue;
      if (!candidate.isBefore(start) && candidate.isBefore(end)) return true;
    }
    return false;
  }

  // ── Pickers ──────────────────────────────────────────────────
  Future<void> pickDate(BuildContext context) async {
    final d = await pickers.pickDate(context, firstDate: DateTime.now());
    if (d != null) setDate(d);
  }

  Future<void> pickStartDate(BuildContext context) async {
    final d = await pickers.pickDate(
      context,
      firstDate: DateTime.now(),
      selectableDayPredicate: (d) => !isDateBooked(d),
    );
    if (d != null) setStartDate(d);
  }

  Future<void> pickEndDate(BuildContext context) async {
    final first = state.startDate;
    final d = await pickers.pickDate(
      context,
      firstDate: first,
      initialDate: first,
      selectableDayPredicate: (d) => !isDateBooked(d),
    );
    if (d != null) setEndDate(d);
  }

  // ── Computed ─────────────────────────────────────────────────
  double get rate {
    if (isMassage) {
      return state.selectedVariantPrice ?? _variantMinPrice ?? 0;
    }
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
      state.location.trim().isNotEmpty &&
      (!isMassage || state.selectedVariantId != null);

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
            modelServiceVariantId: isMassage ? state.selectedVariantId : null,
            startDate: _combinedDateTime().toUtc().toIso8601String(),
            hours: state.hours,
            location: state.location,
            preferredAttire: state.note.isNotEmpty ? state.note : null,
            hasTip: state.hasTip,
          );

    hideLoadingDialog();

    if (res.success && res.data != null) {
      _state.value = state.copyWith(booking: res.data);
      Get.find<WalletLogic>().fetchWallet();
      Get.offAll(
        () => BookingSuccessPage(booking: res.data!, args: args),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 400),
      );
    } else {
      AppSnackbar.error(res.laMessage ?? l10n.postsPleaseRetry, title: l10n.bookingCreationFailed);
    }
  }

  DateTime _combinedDateTime() {
    final d = state.date!;
    final t = state.time!;
    return DateTime(d.year, d.month, d.day, t.hour, t.minute);
  }
}
