import 'package:get/get.dart';
import 'package:xaosao/repository/referral_repo.dart';

import 'commissions_state.dart';

/// Paginated commission history feeding [ShareLinkedPage].
///
/// The API returns 20-per-page; we treat a partial page as end-of-list.
class CommissionsLogic extends GetxController {
  final _repo = ReferralRepo();
  static const _pageSize = 20;

  final Rx<CommissionsState> _state = const CommissionsState().obs;
  CommissionsState get state => _state.value;
  void _update(CommissionsState s) => _state.value = s;

  @override
  void onInit() {
    super.onInit();
    refresh();
  }

  @override
  Future<void> refresh() async {
    _update(const CommissionsState(status: CommissionsStatus.loading));
    final res = await _repo.referralCommissions(limit: _pageSize, page: 1);
    if (res.success && res.data != null) {
      final data = res.data!;
      _update(state.copyWith(
        status: CommissionsStatus.success,
        items: data,
        hasMore: data.length >= _pageSize,
        page: 2,
        error: null,
      ));
    } else {
      _update(state.copyWith(
        status: CommissionsStatus.failure,
        items: const [],
        hasMore: false,
        page: 1,
        error: res.message,
      ));
    }
  }

  Future<void> loadMore() async {
    final st = state;
    if (st.loadingMore || !st.hasMore ||
        st.status != CommissionsStatus.success) {
      return;
    }
    _update(st.copyWith(loadingMore: true));
    final res =
        await _repo.referralCommissions(limit: _pageSize, page: st.page);
    if (res.success && res.data != null) {
      final data = res.data!;
      _update(state.copyWith(
        items: [...state.items, ...data],
        loadingMore: false,
        hasMore: data.length >= _pageSize,
        page: st.page + 1,
      ));
    } else {
      _update(state.copyWith(loadingMore: false));
    }
  }
}
