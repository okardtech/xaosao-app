import 'package:get/get.dart';
import 'package:xaosao/models/interest_model.dart';
import 'package:xaosao/pages/posts/getx/interest_state.dart';
import 'package:xaosao/repository/post_repo.dart';

class InterestLogic extends GetxController {
  final String postId;
  InterestLogic({required this.postId});

  static const int _limit = 20;

  final _repo = MyPost();

  final Rx<InterestState> _state = const InterestState().obs;
  InterestState get state => _state.value;
  Rx<InterestState> get rx => _state;

  bool _fetching = false;

  @override
  void onInit() {
    super.onInit();
    fetch(refresh: true);
  }

  Future<void> fetch({bool refresh = false}) async {
    if (_fetching) return;
    if (!refresh && !state.hasMore) return;

    _fetching = true;
    final page = refresh ? 1 : state.page;
    final isFirst = refresh || page == 1;

    _state.value = state.copyWith(
      status: isFirst ? InterestStatus.loading : InterestStatus.loadingMore,
      items: refresh ? [] : null,
      hasMore: refresh ? true : null,
      page: refresh ? 1 : null,
    );

    try {
      final res = await _repo.getInterests(
        postId: postId,
        page: page,
        limit: _limit,
      );
      if (res.success && res.data != null) {
        final incoming = res.data!;
        _state.value = state.copyWith(
          status: InterestStatus.success,
          items: [
            ...(refresh ? <InterestModel>[] : state.items),
            ...incoming,
          ],
          hasMore: incoming.length >= _limit,
          page: page + 1,
        );
      } else {
        _state.value = state.copyWith(
          status: isFirst ? InterestStatus.failure : InterestStatus.success,
        );
      }
    } catch (_) {
      _state.value = state.copyWith(
        status: isFirst ? InterestStatus.failure : InterestStatus.success,
      );
    } finally {
      _fetching = false;
    }
  }

  void loadMore() => fetch();
}
