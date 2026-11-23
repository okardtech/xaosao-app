import 'dart:async';

import 'package:get/get.dart';
import 'package:xaosao/repository/rewards_repo.dart';
import 'package:xaosao/services/storage_service.dart';

import 'checkin_state.dart';

/// Daily check-in.
///
/// Holds no rules of its own. The server decides whether today can be
/// claimed and for how much; this only asks, draws the answer, and asks
/// again when the answer could have changed.
class CheckinLogic extends GetxController {
  final _repo = RewardsRepo();
  final Rx<CheckinPageState> _state = const CheckinPageState().obs;
  CheckinPageState get state => _state.value;
  void _update(CheckinPageState s) => _state.value = s;

  /// Fires when the Lao day rolls over while the app is open.
  Timer? _rollover;

  /// Only models have check-in; the endpoint 403s for a customer.
  bool get isModel =>
      Get.find<StorageService>().read<String>('role') == 'model';

  @override
  void onInit() {
    super.onInit();
    if (isModel) load();
  }

  @override
  void onClose() {
    _rollover?.cancel();
    super.onClose();
  }

  Future<void> load() async {
    if (!isModel) return;
    _update(state.copyWith(status: CheckinStatus.loading));
    try {
      final res = await _repo.getCheckin();
      if (res.success && res.data != null) {
        _update(
          state.copyWith(status: CheckinStatus.success, info: res.data),
        );
        _scheduleRollover(res.data!.nextAtMs);
      } else {
        _update(state.copyWith(status: CheckinStatus.failure));
      }
    } catch (_) {
      _update(state.copyWith(status: CheckinStatus.failure));
    }
  }

  /// Midnight arrives while the app is open: reload rather than leave
  /// yesterday's "you already checked in" on screen until someone
  /// restarts the app.
  void _scheduleRollover(int nextAtMs) {
    _rollover?.cancel();
    if (nextAtMs <= 0) return;
    final wait = nextAtMs - DateTime.now().millisecondsSinceEpoch;
    if (wait <= 0) return;
    // A second of slack, so the server has crossed the boundary too.
    _rollover = Timer(Duration(milliseconds: wait + 1000), load);
  }

  Future<void> claim() async {
    if (state.claiming) return;
    _update(state.copyWith(claiming: true, clearError: true));
    try {
      final res = await _repo.claimCheckin();
      if (res.success && res.data != null) {
        _update(state.copyWith(claiming: false, justClaimed: res.data));
        // Re-read rather than patch the card by hand: the streak, the
        // strip and tomorrow's amount all move together, and the
        // server is the only thing that knows how.
        await load();
      } else {
        _update(
          state.copyWith(
            claiming: false,
            // The server answers in the user's language already.
            error: res.laMessage ?? res.message,
          ),
        );
      }
    } catch (e) {
      _update(state.copyWith(claiming: false, error: e.toString()));
    }
  }
}
