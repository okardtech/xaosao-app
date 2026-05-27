import '../../../models/my_booking_model.dart';

enum MeetUpStatus { initial, loading, success, failure }

class MeetUpState {
  final MeetUpStatus status;
  final List<MyBookingModel> myBooking;
  final String? error;
  final bool hasMore;
  final int page;
  final String? selectedStatus; // null=all, 'pending', 'completed', 'cancelled', etc.

  const MeetUpState({
    this.status = MeetUpStatus.initial,
    this.myBooking = const [],
    this.error,
    this.hasMore = true,
    this.page = 1,
    this.selectedStatus,
  });

  MeetUpState copyWith({
    MeetUpStatus? status,
    List<MyBookingModel>? myBooking,
    String? error,
    bool? hasMore,
    int? page,
  }) {
    return MeetUpState(
      status: status ?? this.status,
      myBooking: myBooking ?? this.myBooking,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      selectedStatus: selectedStatus, // always preserved via filterBy
    );
  }
}
