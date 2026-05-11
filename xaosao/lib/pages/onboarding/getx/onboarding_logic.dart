import 'package:get/get.dart';
import 'package:xaosao/pages/onboarding/getx/onboarding_state.dart';
import 'package:xaosao/repository/discover_repo.dart';

class OnboardingLogic extends GetxController {
  final DiscoverRepo _repo = DiscoverRepo();
  final Rx<OnboardingState> _state = OnboardingState().obs;
  OnboardingState get state => _state.value;

  Rx<OnboardingState> get getXController => _state;

  void _updateState(OnboardingState newState) {
    _state.value = newState;
  }

  @override
  void onInit() {
    super.onInit();
    getModelsHot();
  }

  Future<void> getModelsHot() async {
    _updateState(state.copyWith(status: OnboardingStatus.loading));
    try {
      final result = await _repo.getModelsHot();
      print('booking status =>${result.statusCode}, ${result.message}');
      if (result.success) {
        _updateState(
          state.copyWith(
            status: OnboardingStatus.success,
            modelsHot: result.data,
          ),
        );
      } else {
        _updateState(state.copyWith(status: OnboardingStatus.failure));
      }
    } catch (e) {
      print('check tracking: $e');
      _updateState(state.copyWith(status: OnboardingStatus.failure));
    }
  }
}
