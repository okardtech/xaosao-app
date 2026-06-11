import 'package:xaosao/models/my_booking_model.dart';

enum MeetUpsDetailsStatus { initial, loading, success, failure }

class MeetUpsDetailsState {
  final MeetUpsDetailsStatus status;
  final MyBookingModel? booking;
  final String? error;

  const MeetUpsDetailsState({
    this.status = MeetUpsDetailsStatus.initial,
    this.booking,
    this.error,
  });

  MeetUpsDetailsState copyWith({
    MeetUpsDetailsStatus? status,
    MyBookingModel? booking,
    String? error,
  }) =>
      MeetUpsDetailsState(
        status: status ?? this.status,
        booking: booking ?? this.booking,
        error: error ?? this.error,
      );
}
