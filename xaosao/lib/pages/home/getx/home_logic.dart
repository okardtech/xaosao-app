import 'package:get/get.dart';
import 'package:xaosao/pages/home/getx/home_state.dart';
import 'package:xaosao/repository/discover_repo.dart';
import 'package:xaosao/services/storage_service.dart';
import 'package:xaosao/utils/app_snackbar.dart';

class HomeLogic extends GetxController {
  final _repo = DiscoverRepo();

  final Rx<HomeState> _state = HomeState().obs;
  HomeState get state => _state.value;
  Rx<HomeState> get getXController => _state;

  void _updateState(HomeState newState) => _state.value = newState;

  static const int _pageSize = 20;
  int _recommendedSkip = 0;
  int _onlineSkip = 0;

  @override
  void onInit() {
    super.onInit();
    final userGender =
        Get.find<StorageService>().read<String>('user_gender') ?? '';
    final defaultGender = userGender == 'male'
        ? 'female'
        : userGender == 'female'
            ? 'male'
            : 'all';
    _updateState(state.copyWith(gender: defaultGender));
    fetchRecommended();
    fetchOnline();
  }

  // ── Recommended ────────────────────────────────────────────────────────────

  Future<void> fetchRecommended({bool refresh = false}) async {
    if (refresh) {
      _recommendedSkip = 0;
      _updateState(state.copyWith(
        recommendedStatus: HomeStatus.loading,
        recommended: [],
        recommendedHasMore: true,
      ));
    } else if (state.recommendedStatus == HomeStatus.loading ||
        state.recommendedStatus == HomeStatus.loadingMore) {
      return;
    } else {
      _updateState(state.copyWith(recommendedStatus: HomeStatus.loading));
    }

    try {
      final res = await _repo.getRecommended(
        skip: _recommendedSkip,
        limit: _pageSize,
        maxDistanceKm: state.maxDistanceKm,
        genderType: state.gender == 'all' ? null : state.gender,
      );
      if (res.success && res.data != null) {
        final newItems = res.data!;
        _recommendedSkip += newItems.length;
        _updateState(state.copyWith(
          recommendedStatus: HomeStatus.success,
          recommended: [...state.recommended, ...newItems],
          recommendedHasMore: newItems.length >= _pageSize,
        ));
      } else {
        _updateState(state.copyWith(recommendedStatus: HomeStatus.failure));
        AppSnackbar.error(res.message ?? 'ໂຫຼດຂໍ້ມູນແນະນຳບໍ່ສຳເລັດ');
      }
    } catch (e) {
      _updateState(state.copyWith(recommendedStatus: HomeStatus.failure));
      AppSnackbar.error('ໂຫຼດຂໍ້ມູນແນະນຳບໍ່ສຳເລັດ');
    }
  }

  Future<void> loadMoreRecommended() async {
    if (!state.recommendedHasMore ||
        state.recommendedStatus == HomeStatus.loading ||
        state.recommendedStatus == HomeStatus.loadingMore) return;

    _updateState(state.copyWith(recommendedStatus: HomeStatus.loadingMore));
    try {
      final res = await _repo.getRecommended(
        skip: _recommendedSkip,
        limit: _pageSize,
        maxDistanceKm: state.maxDistanceKm,
        genderType: state.gender == 'all' ? null : state.gender,
      );
      if (res.success && res.data != null) {
        final newItems = res.data!;
        _recommendedSkip += newItems.length;
        _updateState(state.copyWith(
          recommendedStatus: HomeStatus.success,
          recommended: [...state.recommended, ...newItems],
          recommendedHasMore: newItems.length >= _pageSize,
        ));
      } else {
        _updateState(state.copyWith(recommendedStatus: HomeStatus.success));
      }
    } catch (e) {
      _updateState(state.copyWith(recommendedStatus: HomeStatus.success));
    }
  }

  // ── Online ─────────────────────────────────────────────────────────────────

  Future<void> fetchOnline({bool refresh = false}) async {
    if (refresh) {
      _onlineSkip = 0;
      _updateState(state.copyWith(
        onlineStatus: HomeStatus.loading,
        online: [],
        onlineHasMore: true,
      ));
    } else if (state.onlineStatus == HomeStatus.loading ||
        state.onlineStatus == HomeStatus.loadingMore) {
      return;
    } else {
      _updateState(state.copyWith(onlineStatus: HomeStatus.loading));
    }

    try {
      final res = await _repo.getOnline(
        skip: _onlineSkip,
        limit: _pageSize,
        maxDistanceKm: state.maxDistanceKm,
        genderType: state.gender == 'all' ? null : state.gender,
      );
      if (res.success && res.data != null) {
        final newItems = res.data!;
        _onlineSkip += newItems.length;
        _updateState(state.copyWith(
          onlineStatus: HomeStatus.success,
          online: [...state.online, ...newItems],
          onlineHasMore: newItems.length >= _pageSize,
        ));
      } else {
        _updateState(state.copyWith(onlineStatus: HomeStatus.failure));
        AppSnackbar.error(res.message ?? 'ໂຫຼດຂໍ້ມູນອອນລາຍບໍ່ສຳເລັດ');
      }
    } catch (e) {
      _updateState(state.copyWith(onlineStatus: HomeStatus.failure));
      AppSnackbar.error('ໂຫຼດຂໍ້ມູນອອນລາຍບໍ່ສຳເລັດ');
    }
  }

  Future<void> loadMoreOnline() async {
    if (!state.onlineHasMore ||
        state.onlineStatus == HomeStatus.loading ||
        state.onlineStatus == HomeStatus.loadingMore) return;

    _updateState(state.copyWith(onlineStatus: HomeStatus.loadingMore));
    try {
      final res = await _repo.getOnline(
        skip: _onlineSkip,
        limit: _pageSize,
        maxDistanceKm: state.maxDistanceKm,
        genderType: state.gender == 'all' ? null : state.gender,
      );
      if (res.success && res.data != null) {
        final newItems = res.data!;
        _onlineSkip += newItems.length;
        _updateState(state.copyWith(
          onlineStatus: HomeStatus.success,
          online: [...state.online, ...newItems],
          onlineHasMore: newItems.length >= _pageSize,
        ));
      } else {
        _updateState(state.copyWith(onlineStatus: HomeStatus.success));
      }
    } catch (e) {
      _updateState(state.copyWith(onlineStatus: HomeStatus.success));
    }
  }

  // ── Filters ────────────────────────────────────────────────────────────────

  void setGender(String gender) {
    if (state.gender == gender) return;
    _updateState(state.copyWith(gender: gender));
    fetchRecommended(refresh: true);
    fetchOnline(refresh: true);
  }

  void setMaxDistance(double km) {
    if (state.maxDistanceKm == km) return;
    _updateState(state.copyWith(maxDistanceKm: km));
    fetchRecommended(refresh: true);
    fetchOnline(refresh: true);
  }
}
