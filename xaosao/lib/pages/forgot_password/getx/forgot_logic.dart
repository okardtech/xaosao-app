import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_routes.dart';
import 'package:xaosao/pages/forgot_password/getx/forgot_state.dart';
import '../../../repository/forgot_pass_repo.dart';
import '../../../utils/app_snackbar.dart';
import '../../../widgets/show_loading_alert.dart';

class ForgotLogic extends GetxController {
  final _repo = ForgotPassRepo();

  final Rx<ForgotState> _state = ForgotState().obs;
  ForgotState get state => _state.value;
  Rx<ForgotState> get getXController => _state;

  void _updateState(ForgotState newState) => _state.value = newState;

  Future<void> forgotPhone(
    BuildContext context, {
    required String phone,
    required bool isCustomer,
  }) async {
    showLoadingDialog();
    try {
      final res = await _repo.forgotPassPhone(
        isCustomer: isCustomer,
        phone: phone,
      );
      hideLoadingDialog();
      if (!res.success || res.data == null) {
        AppSnackbar.error(res.message ?? 'ເກີດຂໍ້ຜິດພາດ! ກະລຸນາລອງໃໝ່ອີກຄັ້ງ');
        return;
      }
      _updateState(state.copyWith(forgotPhone: res.data, isCustomer: isCustomer));
      Get.toNamed(AppRoutes.forgotOtp, arguments: phone);
    } catch (e) {
      hideLoadingDialog();
      AppSnackbar.error('ເກີດຂໍ້ຜິດພາດ! ກະລຸນາລອງໃໝ່ອີກຄັ້ງ');
    }
  }

  Future<void> forgotResend(
    BuildContext context, {
    required String phone,
    required bool isCustomer,
  }) async {
    showLoadingDialog();
    try {
      final res = await _repo.forgotPassResnd(
        isCustomer: isCustomer,
        phone: phone,
      );
      hideLoadingDialog();
      if (!res.success || res.data == null) {
        AppSnackbar.error(res.message ?? 'ເກີດຂໍ້ຜິດພາດ! ກະລຸນາລອງໃໝ່ອີກຄັ້ງ');
        return;
      }
      _updateState(state.copyWith(forgotPhone: res.data));
    } catch (e) {
      hideLoadingDialog();
      AppSnackbar.error('ເກີດຂໍ້ຜິດພາດ! ກະລຸນາລອງໃໝ່ອີກຄັ້ງ');
    }
  }

  Future<bool> forgotVerify(
    BuildContext context, {
    required String phone,
    required String otp,
    required bool isCustomer,
  }) async {
    showLoadingDialog();
    try {
      final res = await _repo.forgotPassVerify(
        isCustomer: isCustomer,
        phone: phone,
        otp: otp,
      );
      hideLoadingDialog();
      if (!res.success) {
        AppSnackbar.error(res.message ?? 'ເກີດຂໍ້ຜິດພາດ! ກະລຸນາລອງໃໝ່ອີກຄັ້ງ');
        return false;
      }
      Get.toNamed(AppRoutes.forgotNewPassword, arguments: phone);
      return true;
    } catch (e) {
      hideLoadingDialog();
      AppSnackbar.error('ເກີດຂໍ້ຜິດພາດ! ກະລຸນາລອງໃໝ່ອີກຄັ້ງ');
      return false;
    }
  }

  Future<void> newPassword(
    BuildContext context, {
    required String phone,
    required String newPass,
    required bool isCustomer,
  }) async {
    showLoadingDialog();
    try {
      final res = await _repo.newPassword(
        isCustomer: isCustomer,
        phone: phone,
        newPass: newPass,
      );
      hideLoadingDialog();
      if (!res.success || res.data == null) {
        AppSnackbar.error(res.message ?? 'ເກີດຂໍ້ຜິດພາດ! ກະລຸນາລອງໃໝ່ອີກຄັ້ງ');
        return;
      }
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      hideLoadingDialog();
      AppSnackbar.error('ເກີດຂໍ້ຜິດພາດ! ກະລຸນາລອງໃໝ່ອີກຄັ້ງ');
    }
  }
}
