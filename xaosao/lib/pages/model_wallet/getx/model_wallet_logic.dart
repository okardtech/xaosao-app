import 'package:get/get.dart';
import 'package:xaosao/pages/model_wallet/getx/model_wallet_state.dart';
import 'package:xaosao/repository/bank_repo.dart';
import 'package:xaosao/repository/wallet_repo.dart';
import 'package:xaosao/services/storage_service.dart';
import 'package:xaosao/utils/app_snackbar.dart';
import 'package:xaosao/widgets/show_loading_alert.dart';

class ModelWalletLogic extends GetxController {
  final _repo = PackageRepo();
  final _bankRepo = BankRepo();

  final Rx<ModelWalletState> _state = const ModelWalletState().obs;
  ModelWalletState get state => _state.value;

  bool get isModel =>
      Get.find<StorageService>().read<String>('role') == 'model';

  @override
  void onInit() {
    super.onInit();
    if (isModel) refresh();
  }

  Future<void> refresh() async {
    await Future.wait([_fetchWallet(), _fetchTransactions(reset: true)]);
  }

  void setFilter(String? filter) {
    _state.value = ModelWalletState(
      wallet: state.wallet,
      filter: filter,
      bankAccounts: state.bankAccounts,
    );
    _fetchTransactions(reset: true);
  }

  void loadMore() => _fetchTransactions();

  Future<void> fetchBankAccounts() async {
    _state.value = state.copyWith(loadingBanks: true);
    final res = await _bankRepo.getBankAccount();
    _state.value = state.copyWith(
      loadingBanks: false,
      bankAccounts: res.data ?? [],
    );
  }

  Future<bool> withdraw(int amount, String bankAccountId) async {
    showLoadingDialog();
    final res = await _repo.modelWithdraw(
      amount: amount,
      bankAccount: bankAccountId,
    );
    hideLoadingDialog();
    if (res.data != null) {
      refresh();
      return true;
    }
    AppSnackbar.error(res.message ?? 'ບໍ່ສາມາດຖອນເງິນໄດ້');
    return false;
  }

  Future<void> _fetchWallet() async {
    _state.value = state.copyWith(loadingWallet: true);
    final res = await _repo.modelWallet();
    _state.value = state.copyWith(
      loadingWallet: false,
      wallet: res.data ?? state.wallet,
    );
  }

  Future<void> _fetchTransactions({bool reset = false}) async {
    if (!reset && (!state.hasMore || state.loadingTx)) return;
    final page = reset ? 1 : state.page;
    _state.value = state.copyWith(loadingTx: true);
    final res = await _repo.getTransactions(
      isCustomer: false,
      page: page.toString(),
      limit: '20',
      status: state.filter,
    );
    final data = res.data ?? [];
    _state.value = state.copyWith(
      transactions: reset ? data : [...state.transactions, ...data],
      loadingTx: false,
      hasMore: data.length >= 20,
      page: page + 1,
    );
  }
}
