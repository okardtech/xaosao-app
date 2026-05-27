import 'package:flutter/material.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/models/customer_wallet_model.dart';
import 'package:xaosao/models/transactions_model.dart';

// ── Status enum — maps API strings to UI ──────────────────────
enum TxStatus { completed, pending, processing, cancelled }

extension TxStatusX on TxStatus {
  static TxStatus from(String? s) => switch (s) {
        'approved' || 'completed' => TxStatus.completed,
        'pending' => TxStatus.pending,
        'processing' => TxStatus.processing,
        _ => TxStatus.cancelled,
      };

  String get label => switch (this) {
        TxStatus.completed => 'ສຳເລັດ',
        TxStatus.pending => 'ລໍຖ້າ',
        TxStatus.processing => 'ກຳລັງດຳເນີນ',
        TxStatus.cancelled => 'ຍົກເລີກ',
      };

  Color get iconBg => switch (this) {
        TxStatus.completed => const Color(0xFFDCFCE7),
        TxStatus.pending => const Color(0xFFFEF3C7),
        TxStatus.processing => const Color(0xFFDBEAFE),
        TxStatus.cancelled => AppColors.bg,
      };

  Color get iconColor => switch (this) {
        TxStatus.completed => AppColors.online,
        TxStatus.pending => const Color(0xFFD97706),
        TxStatus.processing => const Color(0xFF2563EB),
        TxStatus.cancelled => AppColors.textHint,
      };

  Color get badgeBg => iconBg;
  Color get badgeFg => iconColor;

  IconData get icon => switch (this) {
        TxStatus.completed => Icons.check_rounded,
        TxStatus.pending => Icons.access_time_rounded,
        TxStatus.processing => Icons.sync_rounded,
        TxStatus.cancelled => Icons.close_rounded,
      };

  double get opacity => this == TxStatus.cancelled ? 0.55 : 1.0;
}

// ── WalletState ───────────────────────────────────────────────
class WalletState {
  final CustomerWalletModel? wallet;
  final List<TransactionsModel> transactions;
  final String? filter;
  final bool loadingWallet;
  final bool loadingTx;
  final bool hasMore;
  final int page;

  const WalletState({
    this.wallet,
    this.transactions = const [],
    this.filter,
    this.loadingWallet = false,
    this.loadingTx = false,
    this.hasMore = true,
    this.page = 1,
  });

  WalletState copyWith({
    CustomerWalletModel? wallet,
    List<TransactionsModel>? transactions,
    String? filter,
    bool? loadingWallet,
    bool? loadingTx,
    bool? hasMore,
    int? page,
  }) => WalletState(
    wallet: wallet ?? this.wallet,
    transactions: transactions ?? this.transactions,
    filter: filter ?? this.filter,
    loadingWallet: loadingWallet ?? this.loadingWallet,
    loadingTx: loadingTx ?? this.loadingTx,
    hasMore: hasMore ?? this.hasMore,
    page: page ?? this.page,
  );
}
