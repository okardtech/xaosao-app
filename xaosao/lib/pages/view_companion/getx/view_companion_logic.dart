import 'dart:async';

import 'package:get/get.dart';
import 'package:xaosao/pages/view_companion/getx/view_companion_state.dart';
import 'package:xaosao/repository/discover_repo.dart';
import 'package:xaosao/repository/review_repo.dart';
import 'package:xaosao/services/storage_service.dart';

class ViewCompanionLogic extends GetxController {
  final DiscoverRepo _repo = DiscoverRepo();
  final Rx<ViewCompanionState> _state = const ViewCompanionState().obs;

  ViewCompanionState get state => _state.value;

  Timer? _debounce;
  static const _limit = 20;

  @override
  void onInit() {
    super.onInit();
    _fetchFirst();
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }

  Future<void> filterBy(String? filter) {
    _state.value = ViewCompanionState(
      status: ViewCompanionStatus.loading,
      filter: filter,
      search: state.search,
    );
    return _fetch(skip: 0, isRefresh: true);
  }

  void onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 450), () {
      _state.value = ViewCompanionState(
        status: ViewCompanionStatus.loading,
        filter: state.filter,
        search: query.isEmpty ? null : query,
      );
      _fetch(skip: 0, isRefresh: true);
    });
  }

  Future<void> loadMore() {
    if (!state.hasMore || state.status == ViewCompanionStatus.loading) {
      return Future.value();
    }
    _state.value = ViewCompanionState(
      status: ViewCompanionStatus.loading,
      companions: state.companions,
      filter: state.filter,
      search: state.search,
      hasMore: state.hasMore,
      skip: state.skip,
    );
    return _fetch(skip: state.skip, isRefresh: false);
  }

  void retry() => _fetchFirst();

  Future<bool> toggleLike(String modelId) async {
    final idx = state.companions.indexWhere((m) => m.id == modelId);
    if (idx == -1) return false;

    final original = state.companions[idx];
    final patched = [...state.companions];
    patched[idx] = original.copyWith(isLikedByMe: !original.isLiked);
    _state.value = ViewCompanionState(
      status: state.status,
      companions: patched,
      filter: state.filter,
      search: state.search,
      hasMore: state.hasMore,
      skip: state.skip,
    );

    final isClient =
        Get.find<StorageService>().read<String>('role') == 'customer';
    final res = await ReviewRepo().addLike(isClient: isClient, id: modelId);
    if (!res.success) {
      final reverted = [...state.companions];
      reverted[idx] = original;
      _state.value = ViewCompanionState(
        status: state.status,
        companions: reverted,
        filter: state.filter,
        search: state.search,
        hasMore: state.hasMore,
        skip: state.skip,
      );
      return false;
    }
    return true;
  }

  void _fetchFirst() {
    _state.value = ViewCompanionState(
      status: ViewCompanionStatus.loading,
      filter: state.filter ?? 'all',
      search: state.search,
    );
    _fetch(skip: 0, isRefresh: true);
  }

  Future<void> _fetch({required int skip, required bool isRefresh}) async {
    final s = state;
    try {
      final result = await _repo.getdiscover(
        skip: skip,
        limit: _limit,
        filter: s.filter,
        search: s.search,
      );
      if (result.data != null) {
        final merged = isRefresh
            ? result.data!
            : [...s.companions, ...result.data!];
        _state.value = ViewCompanionState(
          status: ViewCompanionStatus.success,
          companions: merged,
          filter: s.filter,
          search: s.search,
          hasMore: result.data!.length >= _limit,
          skip: skip + result.data!.length,
        );
      } else {
        _state.value = ViewCompanionState(
          status: ViewCompanionStatus.failure,
          companions: isRefresh ? [] : s.companions,
          filter: s.filter,
          search: s.search,
          error: result.message,
        );
      }
    } catch (e) {
      _state.value = ViewCompanionState(
        status: ViewCompanionStatus.failure,
        companions: isRefresh ? [] : s.companions,
        filter: s.filter,
        search: s.search,
        error: 'ມີຂໍ້ຜິດພາດ: $e',
      );
    }
  }
}
