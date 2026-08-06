import 'package:get/get.dart';
import 'package:xaosao/models/my_booking_model.dart';
import 'package:xaosao/pages/dashboard/getx/dashboard_logic.dart';
import 'package:xaosao/pages/meet_ups/getx/meet_ups_state.dart';
import 'package:xaosao/repository/booking_repo.dart';
import 'package:xaosao/services/notification_service.dart';
import 'package:xaosao/services/storage_service.dart';
import 'package:xaosao/utils/app_snackbar.dart';
import 'package:xaosao/utils/l10n.dart';
import 'package:xaosao/widgets/show_loading_alert.dart';

class MeetUpLogic extends GetxController {
  final BookingRepo _repo = BookingRepo();
  final Rx<MeetUpState> _state = MeetUpState().obs;
  MeetUpState get state => _state.value;

  Rx<MeetUpState> get getXController => _state;

  bool get isClient =>
      Get.find<StorageService>().read<String>('role') == 'customer';

  static const _limit = 20;

  // Push types this controller reacts to.
  static const _bookingPushTypes = <String>{
    'booking_created',
    'booking_accepted',
    'booking_rejected',
    'booking_cancelled',
    'booking_completed',
    'booking_payout_released',
  };

  // ── Lifecycle ─────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    NotificationService.addForegroundListener(_onForegroundPush);
  }

  @override
  void onClose() {
    NotificationService.removeForegroundListener(_onForegroundPush);
    super.onClose();
  }

  // ── Foreground push handler ───────────────────────────────────
  //
  // Strategy: optimistic, then reconcile.
  //   1. If the push carries a `status`, update the matching booking
  //      in-place (list item + detail) so the UI flips instantly.
  //   2. Always trigger a silent list refresh so newly-created bookings
  //      (no prior list entry) appear, and so the server remains the
  //      authoritative source of truth.
  //   3. If the detail page is open on the affected booking, also
  //      silent-refresh the detail to pick up sub-field changes
  //      (paymentStatus, updatedAt, etc.).
  void _onForegroundPush(String type, Map<String, dynamic> data) {
    if (!_bookingPushTypes.contains(type)) return;

    final bookingId = (data['bookingId'] as String?) ?? '';
    if (bookingId.isEmpty) {
      // Type matched but no id — still safe to refresh the list silently.
      _silentRefreshList();
      return;
    }

    final pushStatus = (data['status'] as String?) ?? '';
    if (pushStatus.isNotEmpty) {
      _applyStatusInPlace(bookingId: bookingId, newStatus: pushStatus);
    }

    _silentRefreshList();
    if (state.bookingDetail?.id == bookingId) {
      // Reconcile sub-fields on the open detail page.
      loadBookingDetail(bookingId, silent: true);
    }
  }

  // ── In-place status mutation (list + detail) ──────────────────
  void _applyStatusInPlace({
    required String bookingId,
    required String newStatus,
  }) {
    final current = state;

    // List: rebuild only the rows that change so Obx sees a new list
    // reference (otherwise Rx would not emit).
    var listChanged = false;
    final List<MyBookingModel> newList = current.myBooking.map((b) {
      if (b.id == bookingId && b.status != newStatus) {
        listChanged = true;
        return b.copyWith(status: newStatus);
      }
      return b;
    }).toList(growable: false);

    // Detail: copy with new status if it's the open booking.
    MyBookingModel? newDetail = current.bookingDetail;
    final detailChanged =
        newDetail != null &&
        newDetail.id == bookingId &&
        newDetail.status != newStatus;
    if (detailChanged) {
      newDetail = newDetail.copyWith(status: newStatus);
    }

    if (!listChanged && !detailChanged) return;

    _state.value = MeetUpState(
      status: current.status,
      myBooking: listChanged ? newList : current.myBooking,
      error: current.error,
      hasMore: current.hasMore,
      page: current.page,
      selectedStatus: current.selectedStatus,
      bookingDetail: newDetail,
      bookingDetailLoading: current.bookingDetailLoading,
      bookingDetailError: current.bookingDetailError,
    );
  }

  // ── Silent list refresh — no loading flicker ──────────────────
  Future<void> _silentRefreshList() async {
    try {
      final result = await _repo.myBooking(
        isClient: isClient,
        limit: _limit,
        page: 1,
        status: state.selectedStatus,
      );
      if (result.data == null) return;
      _state.value = MeetUpState(
        status: MeetUpStatus.success,
        myBooking: result.data!,
        selectedStatus: state.selectedStatus,
        hasMore: result.data!.length >= _limit,
        page: 2,
        bookingDetail: state.bookingDetail,
        bookingDetailLoading: state.bookingDetailLoading,
        bookingDetailError: state.bookingDetailError,
      );
    } catch (_) {
      // Reconciliation failed — keep the optimistic state we already showed.
    }
  }

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
        error: l10n.commonErrorDetail(e.toString()),
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
        error: l10n.commonErrorDetail(e.toString()),
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
          bookingDetailError: res.message ?? l10n.commonLoadDataFailed,
        );
      }
    } catch (e) {
      if (!silent) {
        _state.value = _state.value.withDetail(
          bookingDetailLoading: false,
          bookingDetailError: l10n.commonErrorDetail(e.toString()),
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
        AppSnackbar.success(l10n.meetUpsCancelSuccess);
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
        AppSnackbar.success(l10n.meetUpsReleasePaymentSuccess);
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
        AppSnackbar.success(l10n.meetUpsDisputeSuccess);
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
        AppSnackbar.success(l10n.meetUpsConfirmSuccess);
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
        AppSnackbar.success(l10n.meetUpsRejectSuccess);
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
        AppSnackbar.success(l10n.meetUpsReceiveMoneySuccess);
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
        AppSnackbar.success(l10n.meetUpsDeleteSuccess);
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
    AppSnackbar.error(msg ?? l10n.commonActionFailed);
  }
}
