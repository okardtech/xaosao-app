import 'package:flutter/material.dart';

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
  });

  BookingState copyWith({
    DateTime? date,
    TimeOfDay? time,
    int? hours,
    DateTime? startDate,
    DateTime? endDate,
    bool clearEnd = false,
    String? location,
    String? note,
    bool? hasTip,
    bool? submitting,
    BookingSuccessModel? booking,
  }) => BookingState(
    date: date ?? this.date,
    time: time ?? this.time,
    hours: hours ?? this.hours,
    startDate: startDate ?? this.startDate,
    endDate: clearEnd ? null : (endDate ?? this.endDate),
    location: location ?? this.location,
    note: note ?? this.note,
    hasTip: hasTip ?? this.hasTip,
    submitting: submitting ?? this.submitting,
    booking: booking ?? this.booking,
  );
}
