import 'package:flutter/material.dart';

import '../../../models/booking_slots_model.dart';
import '../../../models/booking_success_model.dart';

class BookingState {
  final DateTime? date;
  final TimeOfDay? time;
  final int hours;
  final DateTime? startDate;
  final DateTime? endDate;
  final String location;
  final String note;
  final bool hasTip;
  final bool submitting;
  final BookingSuccessModel? booking;
  final String? selectedVariantId;
  final String? selectedVariantName;
  final double? selectedVariantPrice;
  final List<BookedSlotsModel> bookedSlots;
  final bool slotsLoading;

  const BookingState({
    this.date,
    this.time,
    this.hours = 2,
    this.startDate,
    this.endDate,
    this.location = '',
    this.note = '',
    this.hasTip = false,
    this.submitting = false,
    this.booking,
    this.selectedVariantId,
    this.selectedVariantName,
    this.selectedVariantPrice,
    this.bookedSlots = const [],
    this.slotsLoading = false,
  });

  BookingState copyWith({
    DateTime? date,
    TimeOfDay? time,
    bool clearTime = false,
    int? hours,
    DateTime? startDate,
    DateTime? endDate,
    bool clearEnd = false,
    String? location,
    String? note,
    bool? hasTip,
    bool? submitting,
    BookingSuccessModel? booking,
    String? selectedVariantId,
    String? selectedVariantName,
    double? selectedVariantPrice,
    List<BookedSlotsModel>? bookedSlots,
    bool? slotsLoading,
  }) => BookingState(
    date: date ?? this.date,
    time: clearTime ? null : (time ?? this.time),
    hours: hours ?? this.hours,
    startDate: startDate ?? this.startDate,
    endDate: clearEnd ? null : (endDate ?? this.endDate),
    location: location ?? this.location,
    note: note ?? this.note,
    hasTip: hasTip ?? this.hasTip,
    submitting: submitting ?? this.submitting,
    booking: booking ?? this.booking,
    selectedVariantId: selectedVariantId ?? this.selectedVariantId,
    selectedVariantName: selectedVariantName ?? this.selectedVariantName,
    selectedVariantPrice: selectedVariantPrice ?? this.selectedVariantPrice,
    bookedSlots: bookedSlots ?? this.bookedSlots,
    slotsLoading: slotsLoading ?? this.slotsLoading,
  );
}
