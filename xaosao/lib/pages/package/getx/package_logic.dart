import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xaosao/pages/package/getx/package_state.dart';
import 'package:xaosao/pages/package/components/subscription_banner.dart';
import 'package:xaosao/repository/package_repo.dart';
import 'package:xaosao/services/storage_service.dart';
import 'package:xaosao/utils/app_snackbar.dart';
import 'package:xaosao/widgets/show_loading_alert.dart';

class PackageLogic extends GetxController {
  final _repo = PackageRepo();
  final Rx<PackageState> _state = const PackageState().obs;
  PackageState get state => _state.value;

  @override
  void onInit() {
    super.onInit();
    fetchPackages();
  }

  Future<void> fetchPackages() async {
    _state.value = const PackageState(status: PackageStatus.loading);
    final res = await _repo.getPackage();
    if (res.data != null) {
      _state.value = PackageState(
        status: PackageStatus.success,
        packages: res.data!.data ?? [],
        currentPlan: res.data!.currentSubscriptionPlan,
      );
    } else {
      _state.value = PackageState(
        status: PackageStatus.failure,
        error: res.message ?? 'ໂຫຼດຂໍ້ມູນບໍ່ສຳເລັດ',
      );
      AppSnackbar.error(res.message ?? 'ໂຫຼດຂໍ້ມູນບໍ່ສຳເລັດ');
    }
  }

  Future<void> fetchHistory({bool reset = false}) async {
    final st = state;
    if (!reset && (!st.hasMoreHistory || st.loadingHistory)) return;
    final page = reset ? 1 : st.historyPage;
    _state.value = st.copyWith(loadingHistory: true);
    final res = await _repo.getPackageHistory(
      limit: '20',
      page: page.toString(),
    );
    final data = res.data ?? [];
    _state.value = state.copyWith(
      history: reset ? data : [...st.history, ...data],
      loadingHistory: false,
      hasMoreHistory: data.length >= 20,
      historyPage: page + 1,
    );
  }

  Future<void> checkSubscription(BuildContext context) async {
    final role = Get.find<StorageService>().read<String>('role');
    if (role != 'customer') return;
    final activeRes = await _repo.packageActive();
    if (activeRes.data?.hasActiveSubscription != false ||
        activeRes.data?.hasPendingSubscription == true)
      return;
    final hourRes = await _repo.packageHour();
    if (hourRes.data?.plan == null) return; 
    _state.value = state.copyWith(packageHour: hourRes.data);
    if (context.mounted) showSubscriptionBanner(context, hourRes.data!);
  }


  Future<bool> subscribeFromBanner(String planId) async {
    _state.value = state.copyWith(subscribing: true);
    final res = await _repo.subcriptionPaid(planId: planId);
    _state.value = state.copyWith(subscribing: false);
    if (res.data == true) {
      fetchPackages();
      return true;
    }
    AppSnackbar.error(res.message ?? 'ການຊື້ບໍ່ສຳເລັດ');
    return false;
  }

  Future<bool> subscribeWithSlip({
    required String planId,
    required int amount,
    required String filePath,
  }) async {
    showLoadingDialog();
    final res = await _repo.subcriptionNoBalance(
      planId: planId,
      amount: amount,
      filePath: filePath,
    );
    hideLoadingDialog();
    if (res.data == true) {
      fetchPackages();
      return true;
    }
    AppSnackbar.error(res.message ?? 'ການຊື້ບໍ່ສຳເລັດ');
    return false;
  }
}
