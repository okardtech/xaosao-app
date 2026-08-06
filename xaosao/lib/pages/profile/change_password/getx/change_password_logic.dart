import 'package:get/get.dart';
import 'package:xaosao/repository/register_repo.dart';
import 'package:xaosao/services/storage_service.dart';
import 'package:xaosao/utils/app_snackbar.dart';
import 'package:xaosao/utils/l10n.dart';
import 'package:xaosao/widgets/show_loading_alert.dart';

enum ChangePasswordStatus { initial, loading, success, failure }

class ChangePasswordLogic extends GetxController {
  final _repo = RegisterRepo();
  final Rx<ChangePasswordStatus> status = ChangePasswordStatus.initial.obs;

  Future<void> changePassword({
    required String currentPass,
    required String newPass,
  }) async {
    showLoadingDialog();
    final isClient =
        Get.find<StorageService>().read<String>('role') == 'customer';
    status.value = ChangePasswordStatus.loading;

    try {
      final res = await _repo.changePassword(
        isCustomer: isClient,
        currentPass: currentPass,
        newPass: newPass,
      );
      hideLoadingDialog();
      if (res.success) {
        status.value = ChangePasswordStatus.success;
        AppSnackbar.success(l10n.changePasswordSuccess);
      } else {
        status.value = ChangePasswordStatus.failure;
        AppSnackbar.error(res.laMessage ?? l10n.changePasswordFailed);
      }
    } catch (e) {
      hideLoadingDialog();
      status.value = ChangePasswordStatus.failure;
      AppSnackbar.error(l10n.commonError);
    }
  }
}
