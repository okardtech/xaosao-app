import 'dart:io';
import 'package:get/get.dart';
import 'package:xaosao/pages/topup/getx/topup_state.dart';
import 'package:xaosao/pages/wallet/getx/wallet_logic.dart';
import 'package:xaosao/repository/wallet_repo.dart';
import 'package:xaosao/repository/package_repo.dart' as sub_repo;
import 'package:xaosao/utils/app_snackbar.dart';
import 'package:xaosao/widgets/show_loading_alert.dart';

class TopupLogic extends GetxController {
  final _repo = PackageRepo();
  final _subRepo = sub_repo.PackageRepo();
  final Rx<TopupState> _state = const TopupState().obs;
  TopupState get state => _state.value;

  void setAmount(int amount) => _state.value = state.copyWith(amount: amount);

  void setPaymentType(TopupPaymentType type) =>
      _state.value = state.copyWith(paymentType: type);

  void setSubscriptionContext({required String planId, required int amount}) {
    _state.value = state.copyWith(
      subscriptionPlanId: planId,
      paymentType: TopupPaymentType.subscription,
      amount: amount,
    );
  }

  void resetFlow() => _state.value = const TopupState();

  void addSlip(File file) {
    if (state.slips.length >= 3) return;
    _state.value = state.copyWith(slips: [...state.slips, file]);
  }

  void removeSlip(int index) {
    final updated = [...state.slips]..removeAt(index);
    _state.value = state.copyWith(slips: updated);
  }

  Future<void> fetchQr() async {
    _state.value = state.copyWith(loadingQr: true, qrUrl: null);
    try {
      final res = await _repo.systemQR();
      if (res.data != null) {
        _state.value = state.copyWith(loadingQr: false, qrUrl: res.data);
      } else {
        _state.value = state.copyWith(loadingQr: false);
        AppSnackbar.error(res.message ?? 'ບໍ່ສາມາດໂຫຼດ QR ໄດ້');
      }
    } catch (e) {
      _state.value = state.copyWith(loadingQr: false);
      AppSnackbar.error('ເກີດຂໍ້ຜິດພາດ: $e');
    }
  }

  Future<bool> submitTopUp() async {
    if (state.slips.isEmpty) return false;

    showLoadingDialog();
    try {
      if (state.isSubscription) {
        final res = await _subRepo.subcriptionNoBalance(
          planId: state.subscriptionPlanId ?? '',
          amount: state.amount,
          filePath: state.slips.first.path,
        );
        hideLoadingDialog();
        if (res.data == true) return true;
        AppSnackbar.error(res.message ?? 'ການຊື້ Package ບໍ່ສຳເລັດ');
        return false;
      }

      final res = await _repo.customerTopUp(
        amount: state.amount,
        filePath: state.slips.first.path,
      );
      hideLoadingDialog();
      if (res.data != null) {
        if (Get.isRegistered<WalletLogic>()) Get.find<WalletLogic>().refresh();
        return true;
      }
      AppSnackbar.error(res.message ?? 'ບໍ່ສາມາດສົ່ງໃບຈ່າຍໄດ້');
      return false;
    } catch (e) {
      hideLoadingDialog();
      AppSnackbar.error('ເກີດຂໍ້ຜິດພາດ: $e');
      return false;
    }
  }
}
