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
    // Clear stale wallet + transactions before re-fetching
    _state.value = WalletState(filter: state.filter);
    await Future.wait([fetchWallet(), _fetchTransactions(reset: true)]);
  }

  Future<void> fetchWallet() async {
    // Clear stale wallet so UI reflects loading instead of old balance
    _state.value = WalletState(
      wallet: null,
      transactions: state.transactions,
      filter: state.filter,
      loadingWallet: true,
      loadingTx: state.loadingTx,
      hasMore: state.hasMore,
      page: state.page,
    );
    final res = await _repo.customerWallet();
    // Use res.data directly — don't fall back to stale wallet on failure
    _state.value = state.copyWith(
      wallet: res.data,
      loadingWallet: false,
    );
  }

  Future<void> _fetchTransactions({bool reset = false}) async {
    if (!reset && (!state.hasMore || state.loadingTx)) return;
    final page = reset ? 1 : state.page;
    // When resetting, clear old transactions immediately
    _state.value = reset
        ? WalletState(
            wallet: state.wallet,
            filter: state.filter,
            loadingWallet: state.loadingWallet,
            loadingTx: true,
          )
        : state.copyWith(loadingTx: true);

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
