import '../constants/api_constants.dart';
import '../models/api_response.dart';
import '../models/booking_slots_model.dart';
import '../models/booking_success_model.dart';
import '../models/my_booking_action_model.dart';
import '../models/my_booking_model.dart';
import '../services/base_repo.dart';

// on booking page please check and change to new logic and support with massage , please check if name == massage please add dropdown to user choose price ,
// because massage we using price from the variants, not using customRate or customHourlyRate , please redesiging the best UI to me with user experience , your can design with Row on ຈຳນວນຊົ່ວໂມງ or your can design with Column belong ຈຳນວນຊົ່ວໂມງ, please check and design the best to me , and check my logic on the booking_logic.dart

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
    String? modelServiceVariantId,
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
          if (modelServiceVariantId != null && modelServiceVariantId.isNotEmpty)
            'modelServiceVariantId': modelServiceVariantId,
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

  Future<ApiResponse<List<BookedSlotsModel>>> bookedSlots({
    required String modelId,
    String? date,
  }) {
    String url = '${ApiConstants.booking}/model/$modelId/booked-slots';
    if (date != null) url += '?date=$date';
    return safeCall(
      () => api.get(url),
      fromJson: (json) => (json as List)
          .map(
            (item) => BookedSlotsModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
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

  Future<ApiResponse<MyBookingModel>> myBookingById({
    required bool isClient,
    required String bookingId,
  }) {
    String url =
        '${isClient ? ApiConstants.booking : ApiConstants.modelBooking}/$bookingId';
    return safeCall(
      () => api.get(url),
      fromJson: (json) => MyBookingModel.fromJson(json as Map<String, dynamic>),
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
