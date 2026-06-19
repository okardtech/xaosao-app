import 'package:get/get.dart';
import 'package:xaosao/pages/dashboard/getx/dashboard_logic.dart';
import 'package:xaosao/pages/meet_ups/getx/meet_ups_state.dart';
import 'package:xaosao/repository/booking_repo.dart';
import 'package:xaosao/services/storage_service.dart';
import 'package:xaosao/utils/app_snackbar.dart';
import 'package:xaosao/widgets/show_loading_alert.dart';

class MeetUpLogic extends GetxController {
  final BookingRepo _repo = BookingRepo();
  final Rx<MeetUpState> _state = MeetUpState().obs;
  MeetUpState get state => _state.value;

  Rx<MeetUpState> get getXController => _state;

  bool get isClient =>
      Get.find<StorageService>().read<String>('role') == 'customer';

  static const _limit = 20;

  // ── List loading ──────────────────────────────────────────────

  Future<void> filterBy(String? status) async {
    // Preserve current detail so the detail page doesn't flash on list refresh.
    final d = _state.value.bookingDetail;
    final dl = _state.value.bookingDetailLoading;
    final de = _state.value.bookingDetailError;

    _state.value = MeetUpState(
      status: MeetUpStatus.loading,
      selectedStatus: status,
      bookingDetail: d,
      bookingDetailLoading: dl,
      bookingDetailError: de,
    );
    try {
      final result = await _repo.myBooking(
        isClient: isClient,
        limit: _limit,
        page: 1,
        status: status,
      );
      if (result.data != null) {
        _state.value = MeetUpState(
          status: MeetUpStatus.success,
          myBooking: result.data!,
          selectedStatus: status,
          hasMore: result.data!.length >= _limit,
          page: 2,
          bookingDetail: _state.value.bookingDetail,
          bookingDetailLoading: _state.value.bookingDetailLoading,
          bookingDetailError: _state.value.bookingDetailError,
        );
      } else {
        _state.value = MeetUpState(
          status: MeetUpStatus.failure,
          error: result.message,
          selectedStatus: status,
          bookingDetail: _state.value.bookingDetail,
          bookingDetailLoading: _state.value.bookingDetailLoading,
          bookingDetailError: _state.value.bookingDetailError,
        );
      }
    } catch (e) {
      _state.value = MeetUpState(
        status: MeetUpStatus.failure,
        error: 'ມີຂໍ້ຜິດພາດ: $e',
        selectedStatus: status,
        bookingDetail: _state.value.bookingDetail,
        bookingDetailLoading: _state.value.bookingDetailLoading,
        bookingDetailError: _state.value.bookingDetailError,
      );
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.status == MeetUpStatus.loading) return;
    _state.value = state.copyWith(status: MeetUpStatus.loading);
    try {
      final result = await _repo.myBooking(
        isClient: isClient,
        limit: _limit,
        page: state.page,
        status: state.selectedStatus,
      );
      if (result.data != null) {
        _state.value = MeetUpState(
          status: MeetUpStatus.success,
          myBooking: [...state.myBooking, ...result.data!],
          selectedStatus: state.selectedStatus,
          hasMore: result.data!.length >= _limit,
          page: state.page + 1,
          bookingDetail: _state.value.bookingDetail,
          bookingDetailLoading: _state.value.bookingDetailLoading,
          bookingDetailError: _state.value.bookingDetailError,
        );
      } else {
        _state.value = state.copyWith(
          status: MeetUpStatus.failure,
          error: result.message,
        );
      }
    } catch (e) {
      _state.value = state.copyWith(
        status: MeetUpStatus.failure,
        error: 'ມີຂໍ້ຜິດພາດ: $e',
      );
    }
  }

  // ── Booking detail loading ─────────────────────────────────────

  Future<void> loadBookingDetail(
    String bookingId, {
    bool silent = false,
  }) async {
    if (!silent) {
      // Clear stale detail and show loading screen.
      _state.value = _state.value.withDetail(bookingDetailLoading: true);
    }
    try {
      final res = await _repo.myBookingById(
        isClient: isClient,
        bookingId: bookingId,
      );
      if (res.success && res.data != null) {
        _state.value = _state.value.withDetail(
          bookingDetail: res.data,
          bookingDetailLoading: false,
        );
      } else if (!silent) {
        _state.value = _state.value.withDetail(
          bookingDetailLoading: false,
          bookingDetailError: res.message ?? 'ບໍ່ສາມາດໂຫຼດຂໍ້ມູນ',
        );
      }
    } catch (e) {
      if (!silent) {
        _state.value = _state.value.withDetail(
          bookingDetailLoading: false,
          bookingDetailError: 'ມີຂໍ້ຜິດພາດ: $e',
        );
      }
    }
  }

  // ── Actions — return true on success, false on failure ────────

  Future<bool> cancelBooking(String bookingId) async {
    showLoadingDialog();
    try {
      final res = await _repo.bookingConfirmCancel(
          isClient: isClient, bookingId: bookingId);
      hideLoadingDialog();
      if (res.data != null) {
        await filterBy(state.selectedStatus);
        _refreshDashboardBadges();
        AppSnackbar.success('ຍົກເລີກການຈອງສຳເລັດ');
        return true;
      }
      _showError(res.message);
      return false;
    } catch (e) {
      hideLoadingDialog();
      _showError(null);
      return false;
    }
  }

  Future<bool> releasePayment(String bookingId) async {
    showLoadingDialog();
    try {
      final res = await _repo.bookingReceiveRelesePayment(
          isClient: isClient, bookingId: bookingId);
      hideLoadingDialog();
      if (res.data != null) {
        await filterBy(state.selectedStatus);
        _refreshDashboardBadges();
        AppSnackbar.success('ປ່ອຍເງີນສຳເລັດ');
        return true;
      }
      _showError(res.message);
      return false;
    } catch (e) {
      hideLoadingDialog();
      _showError(null);
      return false;
    }
  }

  Future<bool> disputeBooking(String bookingId, String reason) async {
    showLoadingDialog();
    try {
      final res = await _repo.bookingRejectDispute(
          isClient: isClient, bookingId: bookingId, reason: reason);
      hideLoadingDialog();
      if (res.data != null) {
        await filterBy(state.selectedStatus);
        _refreshDashboardBadges();
        AppSnackbar.success('ສົ່ງຄຳຮ້ອງຂໍສຳເລັດ');
        return true;
      }
      _showError(res.message);
      return false;
    } catch (e) {
      hideLoadingDialog();
      _showError(null);
      return false;
    }
  }

  Future<bool> confirmBooking(String bookingId) async {
    showLoadingDialog();
    try {
      final res = await _repo.bookingConfirmCancel(
          isClient: isClient, bookingId: bookingId);
      hideLoadingDialog();
      if (res.data != null) {
        await filterBy(state.selectedStatus);
        _refreshDashboardBadges();
        AppSnackbar.success('ຢືນຢັນການຈອງສຳເລັດ');
        return true;
      }
      _showError(res.message);
      return false;
    } catch (e) {
      hideLoadingDialog();
      _showError(null);
      return false;
    }
  }

  Future<bool> rejectBooking(String bookingId, String reason) async {
    showLoadingDialog();
    try {
      final res = await _repo.bookingRejectDispute(
          isClient: isClient, bookingId: bookingId, reason: reason);
      hideLoadingDialog();
      if (res.data != null) {
        await filterBy(state.selectedStatus);
        _refreshDashboardBadges();
        AppSnackbar.success('ປະຕິເສດການຈອງສຳເລັດ');
        return true;
      }
      _showError(res.message);
      return false;
    } catch (e) {
      hideLoadingDialog();
      _showError(null);
      return false;
    }
  }

  Future<bool> receiveMoney(String bookingId) async {
    showLoadingDialog();
    try {
      final res = await _repo.bookingReceiveRelesePayment(
          isClient: isClient, bookingId: bookingId);
      hideLoadingDialog();
      if (res.data != null) {
        await filterBy(state.selectedStatus);
        _refreshDashboardBadges();
        AppSnackbar.success('ຮັບເງີນສຳເລັດ');
        return true;
      }
      _showError(res.message);
      return false;
    } catch (e) {
      hideLoadingDialog();
      _showError(null);
      return false;
    }
  }

  Future<bool> deleteBooking(String bookingId) async {
    showLoadingDialog();
    try {
      final res = await _repo.bookingDelete(
          isClient: isClient, bookingId: bookingId, reason: '');
      hideLoadingDialog();
      if (res.data != null) {
        await filterBy(state.selectedStatus);
        _refreshDashboardBadges();
        AppSnackbar.success('ລຶບລາຍການສຳເລັດ');
        return true;
      }
      _showError(res.message);
      return false;
    } catch (e) {
      hideLoadingDialog();
      _showError(null);
      return false;
    }
  }

  void _refreshDashboardBadges() {
    try { Get.find<DashboardLogic>().refreshBadges(); } catch (_) {}
  }

  void _showError(String? msg) {
    AppSnackbar.error(msg ?? 'ບໍ່ສາມາດດຳເນີນການໄດ້');
  }
}
