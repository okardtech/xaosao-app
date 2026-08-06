import 'package:get/get.dart';
import 'package:xaosao/pages/posts/post_detail/getx/post_detail_state.dart';
import 'package:xaosao/repository/post_repo.dart';
import 'package:xaosao/utils/l10n.dart';

class PostDetailLogic extends GetxController {
  final String postId;
  PostDetailLogic({required this.postId});

  final _repo = MyPost();

  final Rx<PostDetailState> _state = const PostDetailState().obs;
  PostDetailState get state => _state.value;
  Rx<PostDetailState> get getXController => _state;

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    _state.value = const PostDetailState(status: PostDetailStatus.loading);
    try {
      final res = await _repo.getPostDetail(postId: postId);
      if (res.success && res.data != null) {
        _state.value = PostDetailState(
          status: PostDetailStatus.success,
          data: res.data,
        );
      } else {
        _state.value = PostDetailState(
          status: PostDetailStatus.failure,
          error: l10n.commonCantLoadData,
        );
      }
    } catch (_) {
      _state.value = PostDetailState(
        status: PostDetailStatus.failure,
        error: l10n.commonErrorOccurred,
      );
    }
  }
}
