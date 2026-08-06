import 'package:get/get.dart';
import 'package:xaosao/pages/dashboard/getx/dashboard_logic.dart';
import 'package:xaosao/repository/booking_repo.dart';
import 'package:xaosao/utils/app_snackbar.dart';
import 'package:xaosao/utils/l10n.dart';
import 'package:xaosao/widgets/show_loading_alert.dart';
import 'meet_ups_details_state.dart';

class MeetUpsDetailsLogic extends GetxController {
  final String bookingId;
  final bool isCustomer;

  MeetUpsDetailsLogic({required this.bookingId, required this.isCustomer});

  final _repo = BookingRepo();
  final Rx<MeetUpsDetailsState> _state = const MeetUpsDetailsState().obs;
  MeetUpsDetailsState get state => _state.value;

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    _state.value = const MeetUpsDetailsState(status: MeetUpsDetailsStatus.loading);
    final res = await _repo.myBookingById(isClient: isCustomer, bookingId: bookingId);
    if (res.data != null) {
      _state.value = MeetUpsDetailsState(
        status: MeetUpsDetailsStatus.success,
        booking: res.data,
      );
    } else {
      _state.value = MeetUpsDetailsState(
        status: MeetUpsDetailsStatus.failure,
        error: res.message ?? l10n.meetupsCantLoadData,
      );
    }
  }

  Future<bool> cancel() =>
      _do(() => _repo.bookingConfirmCancel(isClient: true, bookingId: bookingId));

  Future<bool> confirm() =>
      _do(() => _repo.bookingConfirmCancel(isClient: false, bookingId: bookingId));

  Future<bool> reject(String reason) => _do(
        () => _repo.bookingRejectDispute(
            isClient: false, bookingId: bookingId, reason: reason),
      );

  Future<bool> dispute(String reason) => _do(
        () => _repo.bookingRejectDispute(
            isClient: true, bookingId: bookingId, reason: reason),
      );

  Future<bool> releasePayment() => _do(
        () => _repo.bookingReceiveRelesePayment(
            isClient: true, bookingId: bookingId),
      );

  Future<bool> receiveMoney() => _do(
        () => _repo.bookingReceiveRelesePayment(
            isClient: false, bookingId: bookingId),
      );

  // delete does NOT refetch — page pops on success
  Future<bool> delete() => _do(
        () => _repo.bookingDelete(
            isClient: isCustomer, bookingId: bookingId, reason: ''),
        refetch: false,
      );

  Future<bool> _do(Future<dynamic> Function() call,
      {bool refetch = true}) async {
    showLoadingDialog();
    try {
      final res = await call();
      hideLoadingDialog();
      if (res.data != null) {
        if (refetch) await fetch();
        try { Get.find<DashboardLogic>().refreshBadges(); } catch (_) {}
        return true;
      }
      AppSnackbar.error(
          (res.message as String?) ?? l10n.meetupsCantPerform);
      return false;
    } catch (_) {
      hideLoadingDialog();
      AppSnackbar.error(l10n.meetupsCantPerform);
      return false;
    }
  }
}
