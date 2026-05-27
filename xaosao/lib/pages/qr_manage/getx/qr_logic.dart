import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:xaosao/repository/bank_repo.dart';
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
    } else {
      Get.snackbar(
        'ຜິດພາດ',
        res.message ?? 'ເພີ່ມ QR ບໍ່ສຳເລັດ',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> updateAccount(String id, String filePath) async {
    showLoadingDialog();
    final res = await _repo.updateBankAccount(id: id, filePath: filePath);
    hideLoadingDialog();
    if (res.success) {
      await loadAccounts();
    } else {
      Get.snackbar(
        'ຜິດພາດ',
        res.message ?? 'ອັບເດດ QR ບໍ່ສຳເລັດ',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> deleteAccount(String id) async {
    showLoadingDialog();
    final res = await _repo.deleteBankAccount(id);
    hideLoadingDialog();
    if (res.success) {
      await loadAccounts();
    } else {
      Get.snackbar(
        'ຜິດພາດ',
        res.message ?? 'ລຶບ QR ບໍ່ສຳເລັດ',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> setDefault(String id) async {
    HapticFeedback.lightImpact();
    // optimistic update
    final updated = state.accounts
        .map((a) => a.copyWith(isDefault: a.id == id))
        .toList();
    _update(state.copyWith(accounts: updated));

    final res = await _repo.defaultBankAccount(id);
    if (!res.success) {
      await loadAccounts();
      Get.snackbar(
        'ຜິດພາດ',
        res.message ?? 'ຕັ້ງ QR ຫຼັກບໍ່ສຳເລັດ',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _update(QrState s) => _state.value = s;
}
