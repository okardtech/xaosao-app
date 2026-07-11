import '../../../models/my_booking_model.dart';

enum MeetUpStatus { initial, loading, success, failure }

class MeetUpState {
  final MeetUpStatus status;
  final List<MyBookingModel> myBooking;
  final String? error;
  final bool hasMore;
  final int page;
  final String? selectedStatus;

  final MyBookingModel? bookingDetail;
  final bool bookingDetailLoading;
  final String? bookingDetailError;

  const MeetUpState({
    this.status = MeetUpStatus.initial,
    this.myBooking = const [],
    this.error,
    this.hasMore = true,
    this.page = 1,
    this.selectedStatus,
    this.bookingDetail,
    this.bookingDetailLoading = false,
    this.bookingDetailError,
  });

  // Updates list fields only — detail fields always carried through unchanged.
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
      selectedStatus: selectedStatus,
      bookingDetail: bookingDetail,
      bookingDetailLoading: bookingDetailLoading,
      bookingDetailError: bookingDetailError,
    );
  }

  // Updates detail fields only — list fields always carried through unchanged.
  MeetUpState withDetail({
    MyBookingModel? bookingDetail,
    bool bookingDetailLoading = false,
    String? bookingDetailError,
  }) {
    return MeetUpState(
      status: status,
      myBooking: myBooking,
      error: error,
      hasMore: hasMore,
      page: page,
      selectedStatus: selectedStatus,
      bookingDetail: bookingDetail,
      bookingDetailLoading: bookingDetailLoading,
      bookingDetailError: bookingDetailError,
    );
  }
}
