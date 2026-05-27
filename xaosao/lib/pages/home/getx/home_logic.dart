import 'dart:async';

import 'package:get/get.dart';
import 'package:xaosao/models/Recommended_model.dart';
import 'package:xaosao/pages/home/getx/home_state.dart';
import 'package:xaosao/repository/discover_repo.dart';
import 'package:xaosao/repository/review_repo.dart';
import 'package:xaosao/services/storage_service.dart';
import 'package:xaosao/utils/app_snackbar.dart';

class HomeLogic extends GetxController {
  final _repo = DiscoverRepo();
  final _likeRepo = ReviewRepo();

  final Rx<HomeState> _state = HomeState().obs;
  HomeState get state => _state.value;
  Rx<HomeState> get getXController => _state;

  void _updateState(HomeState newState) => _state.value = newState;

  final RxBool searchOpen = false.obs;
  Timer? _searchTimer;

  static const int _pageSize = 20;

  int _recommendedSkip = 0;
  int _onlineSkip = 0;

  // Bool flags are the real concurrency locks — status is UI-only.
  bool _loadingRecommended = false;
  bool _loadingOnline = false;

  @override
  void onInit() {
    super.onInit();
    final storage = Get.find<StorageService>();
    if (storage.read<String>('role') != 'customer') return;
    final userGender = storage.read<String>('user_gender') ?? '';
    final defaultGender = userGender == 'male'
        ? 'female'
        : userGender == 'female'
            ? 'male'
            : 'all';
    _updateState(state.copyWith(gender: defaultGender));
    fetchRecommended();
    fetchOnline();
  }

  @override
  void onClose() {
    _searchTimer?.cancel();
    super.onClose();
  }

  void toggleSearch() {
    searchOpen.value = !searchOpen.value;
    if (!searchOpen.value) onSearchChanged('');
  }

  void onSearchChanged(String query) {
    _searchTimer?.cancel();
    final q = query.trim();
    _searchTimer = Timer(const Duration(milliseconds: 600), () {
      final newSearch = q.isEmpty ? null : q;
      if (state.search == newSearch) return;
      if (newSearch == null) {
        _updateState(state.copyWith(clearSearch: true));
      } else {
        _updateState(state.copyWith(search: newSearch));
      }
      fetchRecommended(refresh: true);
      fetchOnline(refresh: true);
    });
  }

  // ── Recommended ────────────────────────────────────────────────────────────

  Future<void> fetchRecommended({bool refresh = false}) async {
    if (_loadingRecommended) return;
    if (!refresh && !state.recommendedHasMore) return;

    _loadingRecommended = true;
    final isFirstPage = refresh || _recommendedSkip == 0;

    if (refresh) {
      _recommendedSkip = 0;
      _updateState(state.copyWith(
        recommendedStatus: HomeStatus.loading,
        recommended: [],
        recommendedHasMore: true,
      ));
    } else {
      _updateState(state.copyWith(
        recommendedStatus:
            isFirstPage ? HomeStatus.loading : HomeStatus.loadingMore,
      ));
    }

    try {
      final res = await _repo.getRecommended(
        skip: _recommendedSkip,
        limit: _pageSize,
        maxDistanceKm: state.maxDistanceKm,
        genderType: state.gender == 'all' ? null : state.gender,
        search: state.search,
        status: state.sort,
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
        _updateState(state.copyWith(
          recommendedStatus:
              isFirstPage ? HomeStatus.failure : HomeStatus.success,
        ));
        if (isFirstPage) {
          AppSnackbar.error(res.message ?? 'ໂຫຼດຂໍ້ມູນແນະນຳບໍ່ສຳເລັດ');
        }
      }
    } catch (_) {
      _updateState(state.copyWith(
        recommendedStatus:
            isFirstPage ? HomeStatus.failure : HomeStatus.success,
      ));
      if (isFirstPage) AppSnackbar.error('ໂຫຼດຂໍ້ມູນແນະນຳບໍ່ສຳເລັດ');
    } finally {
      _loadingRecommended = false;
    }
  }

  // Delegates to fetchRecommended — kept for UI API contract.
  Future<void> loadMoreRecommended() => fetchRecommended();

  // ── Online ─────────────────────────────────────────────────────────────────

  Future<void> fetchOnline({bool refresh = false}) async {
    if (_loadingOnline) return;
    if (!refresh && !state.onlineHasMore) return;

    _loadingOnline = true;
    final isFirstPage = refresh || _onlineSkip == 0;

    if (refresh) {
      _onlineSkip = 0;
      _updateState(state.copyWith(
        onlineStatus: HomeStatus.loading,
        online: [],
        onlineHasMore: true,
      ));
    } else {
      _updateState(state.copyWith(
        onlineStatus:
            isFirstPage ? HomeStatus.loading : HomeStatus.loadingMore,
      ));
    }

    try {
      final res = await _repo.getOnline(
        skip: _onlineSkip,
        limit: _pageSize,
        maxDistanceKm: state.maxDistanceKm,
        genderType: state.gender == 'all' ? null : state.gender,
        search: state.search,
        status: state.sort,
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
        _updateState(state.copyWith(
          onlineStatus: isFirstPage ? HomeStatus.failure : HomeStatus.success,
        ));
        if (isFirstPage) {
          AppSnackbar.error(res.message ?? 'ໂຫຼດຂໍ້ມູນອອນລາຍບໍ່ສຳເລັດ');
        }
      }
    } catch (_) {
      _updateState(state.copyWith(
        onlineStatus: isFirstPage ? HomeStatus.failure : HomeStatus.success,
      ));
      if (isFirstPage) AppSnackbar.error('ໂຫຼດຂໍ້ມູນອອນລາຍບໍ່ສຳເລັດ');
    } finally {
      _loadingOnline = false;
    }
  }

  Future<void> loadMoreOnline() => fetchOnline();

  // ── Filters ────────────────────────────────────────────────────────────────

  void setGender(String gender) {
    if (state.gender == gender) return;
    _updateState(state.copyWith(gender: gender));
    fetchRecommended(refresh: true);
    fetchOnline(refresh: true);
  }

  void setSort(String sort) {
    if (state.sort == sort) return;
    _updateState(state.copyWith(sort: sort));
    fetchRecommended(refresh: true);
    fetchOnline(refresh: true);
  }

  void setMaxDistance(double km) {
    if (state.maxDistanceKm == km) return;
    _updateState(state.copyWith(maxDistanceKm: km));
    fetchRecommended(refresh: true);
    fetchOnline(refresh: true);
  }

  Future<void> toggleLike(String modelId) async {
    final rIdx = state.recommended.indexWhere((m) => m.id == modelId);
    final oIdx = state.online.indexWhere((m) => m.id == modelId);
    if (rIdx == -1 && oIdx == -1) return;

    final original = rIdx != -1 ? state.recommended[rIdx] : state.online[oIdx];
    final newLiked = !original.isLiked;

    List<RecommendedModel> patchedRec = state.recommended;
    List<RecommendedModel> patchedOnl = state.online;

    if (rIdx != -1) {
      patchedRec = [...state.recommended];
      patchedRec[rIdx] = original.copyWith(isLikedByMe: newLiked);
    }
    if (oIdx != -1) {
      patchedOnl = [...state.online];
      patchedOnl[oIdx] = original.copyWith(isLikedByMe: newLiked);
    }
    _updateState(state.copyWith(recommended: patchedRec, online: patchedOnl));

    final isClient =
        Get.find<StorageService>().read<String>('role') == 'customer';
    final res = await _likeRepo.addLike(isClient: isClient, id: modelId);
    if (!res.success) {
      List<RecommendedModel> revertRec = state.recommended;
      List<RecommendedModel> revertOnl = state.online;
      if (rIdx != -1) {
        revertRec = [...state.recommended];
        revertRec[rIdx] = original;
      }
      if (oIdx != -1) {
        revertOnl = [...state.online];
        revertOnl[oIdx] = original;
      }
      _updateState(state.copyWith(recommended: revertRec, online: revertOnl));
    }
  }
}
