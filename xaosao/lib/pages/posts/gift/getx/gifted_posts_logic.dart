import 'package:get/get.dart';
import 'package:xaosao/pages/posts/gift/getx/gifted_posts_state.dart';
import 'package:xaosao/repository/chat_repo.dart';

class GiftedPostsLogic extends GetxController {
  final String postId;
  GiftedPostsLogic({required this.postId});

  final _repo = ChatRepo();

  final Rx<GiftedPostsState> _state = const GiftedPostsState().obs;
  GiftedPostsState get state => _state.value;
  Rx<GiftedPostsState> get getXController => _state;

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    _state.value = const GiftedPostsState(status: GiftedPostsStatus.loading);
    try {
      final res = await _repo.getGiftPost(postId: postId);
      if (res.success && res.data != null) {
        _state.value = GiftedPostsState(
          status: GiftedPostsStatus.success,
          data: res.data,
        );
      } else {
        _state.value = const GiftedPostsState(
          status: GiftedPostsStatus.failure,
          error: 'ບໍ່ສາມາດໂຫຼດຂໍ້ມູນໄດ້',
        );
      }
    } catch (_) {
      _state.value = const GiftedPostsState(
        status: GiftedPostsStatus.failure,
        error: 'ມີຂໍ້ຜິດພາດເກີດຂຶ້ນ',
      );
    }
  }
}
