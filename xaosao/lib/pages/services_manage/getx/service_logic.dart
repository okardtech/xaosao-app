import 'package:get/get.dart';
import 'package:xaosao/models/profile_model.dart';
import 'package:xaosao/pages/login/getx/login_logic.dart';
import 'package:xaosao/pages/services_manage/getx/service_state.dart';
import 'package:xaosao/repository/setting_repo.dart';
import 'package:xaosao/utils/app_snackbar.dart';
import 'package:xaosao/utils/l10n.dart';
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
        AppSnackbar.error(res.laMessage ?? l10n.commonLoadDataFailed);
      }
    } catch (_) {
      _updateState(state.copyWith(status: ServiceStatus.failure));
      AppSnackbar.error(l10n.commonLoadDataFailed);
    }
  }

  Future<bool> addService({
    required String serviceId,
    required double customHourlyRate,
    String? serviceLocation,
  }) async {
    if (_busy) return false;
    _busy = true;
    showLoadingDialog();
    try {
      final res = await _repo.addService(
        serviceId: serviceId,
        customHourlyRate: customHourlyRate,
        serviceLocation: serviceLocation,
      );
      hideLoadingDialog();
      if (res.success) {
        await _refreshProfile();
        return true;
      }
      AppSnackbar.error(res.laMessage ?? l10n.commonAddFailed);
      return false;
    } catch (_) {
      hideLoadingDialog();
      AppSnackbar.error(l10n.commonAddFailed);
      return false;
    } finally {
      _busy = false;
    }
  }

  Future<bool> updateService({
    required String modelServiceId,
    required double customHourlyRate,
    String? serviceLocation,
  }) async {
    if (_busy) return false;
    _busy = true;
    showLoadingDialog();
    try {
      final res = await _repo.updateService(
        serviceId: modelServiceId,
        customHourlyRate: customHourlyRate,
        serviceLocation: serviceLocation,
      );
      hideLoadingDialog();
      if (res.success) {
        await _refreshProfile();
        return true;
      }
      AppSnackbar.error(res.laMessage ?? l10n.commonUpdateFailed);
      return false;
    } catch (_) {
      hideLoadingDialog();
      AppSnackbar.error(l10n.commonUpdateFailed);
      return false;
    } finally {
      _busy = false;
    }
  }

  Future<bool> addMassageService({
    required String serviceId,
    required List<Map<String, dynamic>> massageVariants,
    String? serviceLocation,
  }) async {
    if (_busy) return false;
    _busy = true;
    showLoadingDialog();
    try {
      final res = await _repo.addMassageService(
        serviceId: serviceId,
        massageVariants: massageVariants,
        serviceLocation: serviceLocation,
      );
      hideLoadingDialog();
      if (res.success) {
        await _refreshProfile();
        return true;
      }
      AppSnackbar.error(res.laMessage ?? l10n.commonAddFailed);
      return false;
    } catch (_) {
      hideLoadingDialog();
      AppSnackbar.error(l10n.commonAddFailed);
      return false;
    } finally {
      _busy = false;
    }
  }

  Future<bool> updateMassageService({
    required String modelServiceId,
    required List<Map<String, dynamic>> massageVariants,
    String? serviceLocation,
  }) async {
    if (_busy) return false;
    _busy = true;
    showLoadingDialog();
    try {
      final res = await _repo.updateMassageService(
        modelServiceId: modelServiceId,
        massageVariants: massageVariants,
        serviceLocation: serviceLocation,
      );
      hideLoadingDialog();
      if (res.success) {
        await _refreshProfile();
        return true;
      }
      AppSnackbar.error(res.laMessage ?? l10n.commonUpdateFailed);
      return false;
    } catch (_) {
      hideLoadingDialog();
      AppSnackbar.error(l10n.commonUpdateFailed);
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
      AppSnackbar.error(res.laMessage ?? l10n.commonDeleteFailed);
      return false;
    } catch (_) {
      hideLoadingDialog();
      AppSnackbar.error(l10n.commonDeleteFailed);
      return false;
    } finally {
      _busy = false;
    }
  }

  Future<void> _refreshProfile() =>
      Get.find<LoginLogic>().fetchProfile(isCustomer: false);
}
