import 'package:get/get.dart';
import 'package:xaosao/models/profile_model.dart';
import 'package:xaosao/pages/login/getx/login_logic.dart';
import 'package:xaosao/pages/services_manage/getx/service_state.dart';
import 'package:xaosao/repository/setting_repo.dart';
import 'package:xaosao/utils/app_snackbar.dart';
import 'package:xaosao/widgets/show_loading_alert.dart';

class ServiceLogic extends GetxController {
  final _repo = SettingRepo();

  final Rx<ServiceState> _state = const ServiceState().obs;
  ServiceState get state => _state.value;
  Rx<ServiceState> get getXController => _state;

  void _updateState(ServiceState s) => _state.value = s;

  bool _busy = false;

  @override
  void onInit() {
    super.onInit();
    fetchAvailable();
  }

  List<ModelService> get profileServices =>
      Get.find<LoginLogic>().state.modelProfile?.services ?? [];

  ModelService? getProfileService(String serviceId) {
    try {
      return profileServices.firstWhere((s) => s.serviceId == serviceId);
    } catch (_) {
      return null;
    }
  }

  Future<void> fetchAvailable() async {
    _updateState(state.copyWith(status: ServiceStatus.loading));
    try {
      final res = await _repo.getServiceAvailable();
      if (res.success && res.data != null) {
        _updateState(state.copyWith(
          status: ServiceStatus.success,
          available: res.data!,
        ));
      } else {
        _updateState(state.copyWith(status: ServiceStatus.failure));
        AppSnackbar.error(res.message ?? 'ໂຫຼດຂໍ້ມູນບໍ່ສຳເລັດ');
      }
    } catch (_) {
      _updateState(state.copyWith(status: ServiceStatus.failure));
      AppSnackbar.error('ໂຫຼດຂໍ້ມູນບໍ່ສຳເລັດ');
    }
  }

  Future<bool> addService({
    required String serviceId,
    required double customHourlyRate,
  }) async {
    if (_busy) return false;
    _busy = true;
    showLoadingDialog();
    try {
      final res = await _repo.addService(
        serviceId: serviceId,
        customHourlyRate: customHourlyRate,
      );
      hideLoadingDialog();
      if (res.success) {
        await _refreshProfile();
        return true;
      }
      AppSnackbar.error(res.message ?? 'ເພີ່ມບໍ່ສຳເລັດ');
      return false;
    } catch (_) {
      hideLoadingDialog();
      AppSnackbar.error('ເພີ່ມບໍ່ສຳເລັດ');
      return false;
    } finally {
      _busy = false;
    }
  }

  Future<bool> updateService({
    required String modelServiceId,
    required double customHourlyRate,
  }) async {
    if (_busy) return false;
    _busy = true;
    showLoadingDialog();
    try {
      final res = await _repo.updateService(
        serviceId: modelServiceId,
        customHourlyRate: customHourlyRate,
      );
      hideLoadingDialog();
      if (res.success) {
        await _refreshProfile();
        return true;
      }
      AppSnackbar.error(res.message ?? 'ອັບເດດບໍ່ສຳເລັດ');
      return false;
    } catch (_) {
      hideLoadingDialog();
      AppSnackbar.error('ອັບເດດບໍ່ສຳເລັດ');
      return false;
    } finally {
      _busy = false;
    }
  }

  Future<bool> deleteService({required String modelServiceId}) async {
    if (_busy) return false;
    _busy = true;
    showLoadingDialog();
    try {
      final res = await _repo.deleteService(serviceId: modelServiceId);
      hideLoadingDialog();
      if (res.success) {
        await _refreshProfile();
        return true;
      }
      AppSnackbar.error(res.message ?? 'ລຶບບໍ່ສຳເລັດ');
      return false;
    } catch (_) {
      hideLoadingDialog();
      AppSnackbar.error('ລຶບບໍ່ສຳເລັດ');
      return false;
    } finally {
      _busy = false;
    }
  }

  Future<void> _refreshProfile() =>
      Get.find<LoginLogic>().fetchProfile(isCustomer: false);
}
