import 'package:get/get.dart';
import 'package:xaosao/pages/wallet/getx/wallet_state.dart';
import 'package:xaosao/repository/wallet_repo.dart';
import 'package:xaosao/services/storage_service.dart';

class WalletLogic extends GetxController {
  final _repo = PackageRepo();

  final Rx<WalletState> _state = const WalletState().obs;
  WalletState get state => _state.value;
  Rx<WalletState> get rx => _state;

  bool get isCustomer =>
      Get.find<StorageService>().read<String>('role') == 'customer';

  @override
  void onInit() {
    super.onInit();
    if (isCustomer) refresh();
  }

  Future<void> refresh() async {
    if (!isCustomer) return;
    await Future.wait([_fetchWallet(), _fetchTransactions(reset: true)]);
  }

  Future<void> _fetchWallet() async {
    _state.value = state.copyWith(loadingWallet: true);
    final res = await _repo.customerWallet();
    _state.value = state.copyWith(
      wallet: res.data ?? state.wallet,
      loadingWallet: false,
    );
  }

  Future<void> _fetchTransactions({bool reset = false}) async {
    if (!reset && (!state.hasMore || state.loadingTx)) return;
    final page = reset ? 1 : state.page;
    _state.value = state.copyWith(loadingTx: true);

    final res = await _repo.getTransactions(
      isCustomer: true,
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

  void setFilter(String? filter) {
    _state.value = WalletState(wallet: state.wallet, filter: filter);
    _fetchTransactions(reset: true);
  }

  void loadMore() => _fetchTransactions();
}
