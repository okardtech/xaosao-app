import 'package:get/get.dart';
import 'package:xaosao/repository/referral_repo.dart';
import 'referral_analytics_state.dart';

class ReferralAnalyticsLogic extends GetxController {
  final _repo = ReferralRepo();
  final Rx<ReferralAnalyticsState> _state = const ReferralAnalyticsState().obs;
  ReferralAnalyticsState get state => _state.value;
  void _update(ReferralAnalyticsState s) => _state.value = s;

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    _update(state.copyWith(status: ReferralStatus.loading));
    try {
      final res = await _repo.getReferral();
      if (res.success && res.data != null) {
        _update(state.copyWith(status: ReferralStatus.success, data: res.data));
      } else {
        _update(state.copyWith(status: ReferralStatus.failure));
      }
    } catch (e) {
      _update(state.copyWith(status: ReferralStatus.failure));
    }
  }
}
