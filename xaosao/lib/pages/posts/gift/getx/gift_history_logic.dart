import 'package:get/get.dart';
import 'package:xaosao/pages/posts/gift/getx/gift_history_state.dart';
import 'package:xaosao/repository/gift_repo.dart';

class GiftHistoryLogic extends GetxController {
  final _repo = GiftRepo();

  final Rx<GiftHistoryState> _state = const GiftHistoryState().obs;
  GiftHistoryState get state => _state.value;
  Rx<GiftHistoryState> get rx => _state;

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    _state.value = const GiftHistoryState(status: GiftHistoryStatus.loading);
    try {
      final res = await _repo.myGiftHistory();
      if (res.success && res.data != null) {
        _state.value = GiftHistoryState(
          status: GiftHistoryStatus.success,
          items: res.data!,
        );
      } else {
        _state.value = GiftHistoryState(
          status: GiftHistoryStatus.failure,
          error: res.laMessage ?? 'ໂຫຼດຂໍ້ມູນບໍ່ສຳເລັດ',
        );
      }
    } catch (_) {
      _state.value = const GiftHistoryState(
        status: GiftHistoryStatus.failure,
        error: 'ມີຂໍ້ຜິດພາດເກີດຂຶ້ນ',
      );
    }
  }
}
