import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:xaosao/pages/model_wallet/getx/model_wallet_logic.dart';
import 'package:xaosao/repository/bank_repo.dart';
import 'package:xaosao/utils/app_snackbar.dart';
import 'package:xaosao/widgets/show_loading_alert.dart';
import 'qr_state.dart';

class QrLogic extends GetxController {
  final _repo = BankRepo();
  final _state = const QrState().obs;

  QrState get state => _state.value;

  @override
  void onInit() {
    super.onInit();
    loadAccounts();
  }

  Future<void> loadAccounts() async {
    _update(state.copyWith(status: QrStatus.loading));
    final res = await _repo.getBankAccount();
    if (res.success) {
      _update(state.copyWith(
        status: QrStatus.success,
        accounts: res.data ?? [],
      ));
    } else {
      _update(state.copyWith(status: QrStatus.failure, error: res.message));
    }
  }

  Future<void> addAccount(String filePath) async {
    showLoadingDialog();
    final res = await _repo.createBankAccount(filePath: filePath);
    hideLoadingDialog();
    if (res.success) {
      await loadAccounts();
      _syncWithdrawBanks();
    } else {
      AppSnackbar.error(res.laMessage ?? 'ເພີ່ມ QR ບໍ່ສຳເລັດ');
    }
  }

  Future<void> updateAccount(String id, String filePath) async {
    showLoadingDialog();
    final res = await _repo.updateBankAccount(id: id, filePath: filePath);
    hideLoadingDialog();
    if (res.success) {
      await loadAccounts();
      _syncWithdrawBanks();
    } else {
      AppSnackbar.error(res.laMessage ?? 'ອັບເດດ QR ບໍ່ສຳເລັດ');
    }
  }

  Future<void> deleteAccount(String id) async {
    showLoadingDialog();
    final res = await _repo.deleteBankAccount(id);
    hideLoadingDialog();
    if (res.success) {
      await loadAccounts();
      _syncWithdrawBanks();
    } else {
      AppSnackbar.error(res.laMessage ?? 'ລຶບ QR ບໍ່ສຳເລັດ');
    }
  }

  Future<void> setDefault(String id) async {
    HapticFeedback.lightImpact();
    final updated = state.accounts
        .map((a) => a.copyWith(isDefault: a.id == id))
        .toList();
    _update(state.copyWith(accounts: updated));

    final res = await _repo.defaultBankAccount(id);
    if (res.success) {
      _syncWithdrawBanks();
    } else {
      await loadAccounts();
      AppSnackbar.error(res.laMessage ?? 'ຕັ້ງ QR ຫຼັກບໍ່ສຳເລັດ');
    }
  }

  void _update(QrState s) => _state.value = s;

  // Sync withdraw page bank list whenever a mutation succeeds.
  // Guarded: ModelWalletLogic may not be registered if wallet was never opened.
  void _syncWithdrawBanks() {
    try {
      Get.find<ModelWalletLogic>().fetchBankAccounts();
    } catch (_) {}
  }
}
