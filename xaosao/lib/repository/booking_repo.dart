import '../constants/api_constants.dart';
import '../models/api_response.dart';
import '../models/booking_success_model.dart';
import '../models/my_booking_action_model.dart';
import '../models/my_booking_model.dart';
import '../services/base_repo.dart';

class BookingRepo extends BaseRepository {
  Future<ApiResponse<BookingSuccessModel>> bookingPerDay({
    required String modelServiceId,
    required String startDate,
    required String endDate,
    required String location,
    String? preferredAttire,
    bool hasTip = false,
  }) {
    return safeCall(
      () => api.post(
        ApiConstants.booking,
        data: {
          'modelServiceId': modelServiceId,
          'startDate': startDate,
          'endDate': endDate,
          'location': location,
          if (preferredAttire != null && preferredAttire.isNotEmpty)
            'preferredAttire': preferredAttire,
          'hasTip': hasTip,
        },
      ),
      fromJson: (json) => BookingSuccessModel.fromJson(json),
    );
  }

  Future<ApiResponse<BookingSuccessModel>> bookingPerHour({
    required String modelServiceId,
    required String startDate,
    required int hours,
    required String location,
    String? preferredAttire,
    bool hasTip = false,
  }) {
    return safeCall(
      () => api.post(
        ApiConstants.booking,
        data: {
          'modelServiceId': modelServiceId,
          'startDate': startDate,
          'hours': hours,
          'location': location,
          if (preferredAttire != null && preferredAttire.isNotEmpty)
            'preferredAttire': preferredAttire,
          'hasTip': hasTip,
        },
      ),
      fromJson: (json) => BookingSuccessModel.fromJson(json),
    );
  }

  Future<ApiResponse<List<MyBookingModel>>> myBooking({
    required bool isClient,
    required int limit,
    required int page,
    String?
    status, //all(null), pending, confirmed, in_progress, awaiting_confirmation, completed, cancelled, rejected, disputed
  }) {
    String url =
        '${isClient ? ApiConstants.booking : ApiConstants.modelBooking}?page=$page&limit=$limit';
    if (status != null) url += '&status=$status';
    print('==>${url}');
    return safeCall(
      () => api.get(url),
      fromJson: (json) => (json as List)
          .map((item) => MyBookingModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<ApiResponse<MyBookingActionModel>> bookingConfirmCancel({
    required bool isClient,
    required String bookingId,
  }) {
    String url = isClient
        ? "${ApiConstants.booking}/$bookingId/cancel"
        : "${ApiConstants.modelBooking}/$bookingId/confirm";
    return safeCall(
      () => api.post(url),
      fromJson: (json) => MyBookingActionModel.fromJson(json),
    );
  }

  Future<ApiResponse<MyBookingActionModel>> bookingReceiveRelesePayment({
    required bool isClient,
    required String bookingId,
  }) {
    String url = isClient
        ? "${ApiConstants.booking}/$bookingId/release-payment"
        : "${ApiConstants.modelBooking}/$bookingId/receive-money";
    return safeCall(
      () => api.post(url),
      fromJson: (json) => MyBookingActionModel.fromJson(json),
    );
  }

  Future<ApiResponse<MyBookingActionModel>> bookingRejectDispute({
    required bool isClient,
    required String bookingId,
    required String reason,
  }) {
    String url = isClient
        ? "${ApiConstants.booking}/$bookingId/dispute"
        : "${ApiConstants.modelBooking}/$bookingId/reject";
    return safeCall(
      () => api.post(url, data: {"reason": reason}),
      fromJson: (json) => MyBookingActionModel.fromJson(json),
    );
  }

  Future<ApiResponse<bool>> bookingDelete({
    required bool isClient,
    required String bookingId,
    required String reason,
  }) {
    String url = isClient
        ? "${ApiConstants.booking}/$bookingId"
        : "${ApiConstants.modelBooking}/$bookingId";
    return safeCall(() => api.delete(url), fromJson: (json) => true);
  }
}
