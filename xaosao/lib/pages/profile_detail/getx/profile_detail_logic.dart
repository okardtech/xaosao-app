import 'package:get/get.dart';
import 'package:xaosao/pages/login/getx/login_logic.dart';
import 'package:xaosao/repository/login_repo.dart';
import 'package:xaosao/utils/app_snackbar.dart';
import 'package:xaosao/widgets/show_loading_alert.dart';

enum ProfileUpdateStatus { initial, loading, success, failure }

class ProfileDetailLogic extends GetxController {
  final _repo = LoginRepo();
  final Rx<ProfileUpdateStatus> status = ProfileUpdateStatus.initial.obs;

  Future<void> updateInfo({
    required bool isClient,
    required String firstName,
    required String lastName,
    required String gender,
    required DateTime dob,
    String? address,
  }) async {
    status.value = ProfileUpdateStatus.loading;
    showLoadingDialog();
    try {
      final res = await _repo.updateInfo(
        isClient: isClient,
        firstName: firstName,
        lastName: lastName,
        gener: gender,
        dob: dob,
        addresss: address,
      );
      hideLoadingDialog();
      if (res.success) {
        status.value = ProfileUpdateStatus.success;
        await Get.find<LoginLogic>().fetchProfile(isCustomer: isClient);
        Get.back();
        AppSnackbar.success('ອັບເດດຂໍ້ມູນສຳເລັດ');
      } else {
        status.value = ProfileUpdateStatus.failure;
        AppSnackbar.error(res.message ?? 'ອັບເດດຂໍ້ມູນບໍ່ສຳເລັດ');
      }
    } catch (e) {
      hideLoadingDialog();
      status.value = ProfileUpdateStatus.failure;
      AppSnackbar.error('ອັບເດດຂໍ້ມູນບໍ່ສຳເລັດ');
    }
  }
}
