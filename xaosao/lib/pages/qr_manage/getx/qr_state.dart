import 'package:xaosao/models/bank_account_model.dart';

enum QrStatus { initial, loading, success, failure }

class QrState {
  final List<BankAccountModel> accounts;
  final QrStatus status;
  final String? error;

  const QrState({
    this.accounts = const [],
    this.status = QrStatus.initial,
    this.error,
  });

  QrState copyWith({
    List<BankAccountModel>? accounts,
    QrStatus? status,
    String? error,
  }) => QrState(
    accounts: accounts ?? this.accounts,
    status: status ?? this.status,
    error: error,
  );
}
