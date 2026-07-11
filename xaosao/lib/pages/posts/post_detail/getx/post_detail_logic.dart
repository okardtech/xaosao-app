import 'package:get/get.dart';
import 'package:xaosao/pages/posts/post_detail/getx/post_detail_state.dart';
import 'package:xaosao/repository/post_repo.dart';

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
        _state.value = const PostDetailState(
          status: PostDetailStatus.failure,
          error: 'ບໍ່ສາມາດໂຫຼດຂໍ້ມູນໄດ້',
        );
      }
    } catch (_) {
      _state.value = const PostDetailState(
        status: PostDetailStatus.failure,
        error: 'ມີຂໍ້ຜິດພາດເກີດຂຶ້ນ',
      );
    }
  }
}
