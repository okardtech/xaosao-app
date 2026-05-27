import 'package:get/get.dart';
import 'package:xaosao/repository/feedback_repo.dart';
import 'package:xaosao/utils/app_snackbar.dart';
import 'package:xaosao/widgets/show_loading_alert.dart';
import 'feedback_state.dart';

class FeedbackLogic extends GetxController {
  final _repo = FeedbackRepo();
  final Rx<FeedbackState> _state = const FeedbackState().obs;
  bool _busy = false;

  FeedbackState get state => _state.value;

  @override
  void onInit() {
    super.onInit();
    loadFeedbacks();
  }

  Future<void> loadFeedbacks() async {
    _state.value = state.copyWith(status: FeedbackStatus.loading);
    final res = await _repo.getMyFeedback();
    if (res.success && res.data != null) {
      _state.value = state.copyWith(
        status: FeedbackStatus.success,
        feedbacks: res.data!,
      );
    } else {
      _state.value = state.copyWith(status: FeedbackStatus.failure);
    }
  }

  Future<bool> submitFeedback({
    required String subject,
    required String desc,
  }) async {
    if (_busy) return false;
    _busy = true;
    showLoadingDialog();
    try {
      final res = await _repo.addFeedback(subject: subject, desc: desc);
      hideLoadingDialog();
      if (res.success) {
        await loadFeedbacks();
        return true;
      }
      AppSnackbar.error(res.message ?? 'ສົ່ງຄຳຕິຊົມບໍ່ສຳເລັດ');
      return false;
    } catch (_) {
      hideLoadingDialog();
      AppSnackbar.error('ສົ່ງຄຳຕິຊົມບໍ່ສຳເລັດ');
      return false;
    } finally {
      _busy = false;
    }
  }
}
