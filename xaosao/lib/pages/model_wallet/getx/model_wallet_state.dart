import 'package:xaosao/models/bank_account_model.dart';
import 'package:xaosao/models/model_wallet_model.dart';
import 'package:xaosao/models/transactions_model.dart';

class ModelWalletState {
  final ModelWalletModel? wallet;
  final List<TransactionsModel> transactions;
  final List<BankAccountModel> bankAccounts;
  final String? filter;
  final bool loadingWallet;
  final bool loadingTx;
  final bool loadingBanks;
  final bool hasMore;
  final int page;

  const ModelWalletState({
    this.wallet,
    this.transactions = const [],
    this.bankAccounts = const [],
    this.filter,
    this.loadingWallet = false,
    this.loadingTx = false,
    this.loadingBanks = false,
    this.hasMore = true,
    this.page = 1,
  });

  ModelWalletState copyWith({
    ModelWalletModel? wallet,
    List<TransactionsModel>? transactions,
    List<BankAccountModel>? bankAccounts,
    String? filter,
    bool? loadingWallet,
    bool? loadingTx,
    bool? loadingBanks,
    bool? hasMore,
    int? page,
  }) =>
      ModelWalletState(
        wallet: wallet ?? this.wallet,
        transactions: transactions ?? this.transactions,
        bankAccounts: bankAccounts ?? this.bankAccounts,
        filter: filter ?? this.filter,
        loadingWallet: loadingWallet ?? this.loadingWallet,
        loadingTx: loadingTx ?? this.loadingTx,
        loadingBanks: loadingBanks ?? this.loadingBanks,
        hasMore: hasMore ?? this.hasMore,
        page: page ?? this.page,
      );
}
