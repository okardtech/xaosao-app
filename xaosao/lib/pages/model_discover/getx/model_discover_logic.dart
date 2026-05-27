import 'dart:async';

import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:xaosao/repository/discover_repo.dart';
import 'package:xaosao/repository/review_repo.dart';
import 'package:xaosao/services/storage_service.dart';
import 'model_discover_state.dart';

class ModelDiscoverLogic extends GetxController {
  final _repo = DiscoverRepo();
  final _likeRepo = ReviewRepo();
  final Rx<ModelDiscoverState> _state = const ModelDiscoverState().obs;

  ModelDiscoverState get state => _state.value;
  Rx<ModelDiscoverState> get rxState => _state;

  final RxBool searchOpen = false.obs;
  final RxInt tabIndex = 0.obs;

  static const _limit = 12;
  bool _loading = false;
  Timer? _searchTimer;

  @override
  void onInit() {
    super.onInit();
    SchedulerBinding.instance
        .addPostFrameCallback((_) => loadModels(refresh: true));
  }

  @override
  void onClose() {
    _searchTimer?.cancel();
    super.onClose();
  }

  void toggleSearch() {
    searchOpen.value = !searchOpen.value;
    if (!searchOpen.value) {
      onSearchChanged('');
    }
  }

  void selectTab(int i, String? filter) {
    if (tabIndex.value == i) return;
    tabIndex.value = i;
    _applyFilter(filter);
  }

  Future<void> loadModels({bool refresh = false}) async {
    if (_loading) return;
    if (!refresh && !state.hasMore) return;

    _loading = true;
    final isFirst = refresh;
    final skip = isFirst ? 0 : state.skip + _limit;

    _update(state.copyWith(
      status: isFirst ? DiscoverStatus.loading : DiscoverStatus.loadingMore,
      skip: skip,
    ));

    try {
      final res = await _repo.getModelDiscover(
        skip: skip,
        limit: _limit,
        filter: state.filter,
        search: state.search,
      );

      if (res.success && res.data != null) {
        final merged =
            isFirst ? res.data! : [...state.models, ...res.data!];
        _update(state.copyWith(
          models: merged,
          hasMore: (res.data?.length ?? 0) >= _limit,
          status: DiscoverStatus.success,
        ));
      } else {
        _update(state.copyWith(status: DiscoverStatus.failure));
      }
    } catch (_) {
      _update(state.copyWith(status: DiscoverStatus.failure));
    } finally {
      _loading = false;
    }
  }

  void _applyFilter(String? filter) {
    if (state.filter == filter) return;
    if (filter == null) {
      _update(state.copyWith(clearFilter: true));
    } else {
      _update(state.copyWith(filter: filter));
    }
    loadModels(refresh: true);
  }

  void onSearchChanged(String query) {
    _searchTimer?.cancel();
    final q = query.trim();
    _searchTimer = Timer(const Duration(milliseconds: 600), () {
      final newSearch = q.isEmpty ? null : q;
      if (state.search == newSearch) return;
      if (newSearch == null) {
        _update(state.copyWith(clearSearch: true));
      } else {
        _update(state.copyWith(search: newSearch));
      }
      loadModels(refresh: true);
    });
  }

  Future<void> toggleLike(String modelId) async {
    final idx = state.models.indexWhere((m) => m.id == modelId);
    if (idx == -1) return;
    final m = state.models[idx];
    final newLiked = !m.isLiked;
    final updated = [...state.models];
    updated[idx] = m.copyWith(isLikedByMe: newLiked);
    _update(state.copyWith(models: updated));

    final isClient =
        Get.find<StorageService>().read<String>('role') == 'customer';
    final res = await _likeRepo.addLike(isClient: isClient, id: modelId);
    if (!res.success) {
      final reverted = [...state.models];
      reverted[idx] = m;
      _update(state.copyWith(models: reverted));
    }
  }

  void _update(ModelDiscoverState s) => _state.value = s;
}
