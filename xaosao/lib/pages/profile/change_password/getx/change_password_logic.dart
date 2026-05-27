import 'package:get/get.dart';
import 'package:xaosao/repository/register_repo.dart';
import 'package:xaosao/services/storage_service.dart';
import 'package:xaosao/utils/app_snackbar.dart';
import 'package:xaosao/widgets/show_loading_alert.dart';

enum ChangePasswordStatus { initial, loading, success, failure }

class ChangePasswordLogic extends GetxController {
  final _repo = RegisterRepo();
  final Rx<ChangePasswordStatus> status = ChangePasswordStatus.initial.obs;

  Future<void> changePassword({
    required String currentPass,
    required String newPass,
  }) async {
    final isClient =
        Get.find<StorageService>().read<String>('role') == 'customer';
    status.value = ChangePasswordStatus.loading;
    showLoadingDialog();
    try {
      final res = await _repo.changePassword(
        isCustomer: isClient,
        currentPass: currentPass,
        newPass: newPass,
      );
      hideLoadingDialog();
      if (res.success) {
        status.value = ChangePasswordStatus.success;
        AppSnackbar.success('ປ່ຽນລະຫັດຜ່ານສຳເລັດ');
        Get.back();
      } else {
        status.value = ChangePasswordStatus.failure;
        AppSnackbar.error(res.message ?? 'ປ່ຽນລະຫັດຜ່ານບໍ່ສຳເລັດ');
      }
    } catch (e) {
      hideLoadingDialog();
      status.value = ChangePasswordStatus.failure;
      AppSnackbar.error('ເກີດຂໍ້ຜິດພາດ, ກະລຸນາລອງໃໝ່');
    }
  }
}
