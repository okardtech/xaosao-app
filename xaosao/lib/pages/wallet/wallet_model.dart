import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════════
//  TransactionStatus
// ═══════════════════════════════════════════════════════════════
enum TransactionStatus { completed, pending, processing, cancelled }

extension TransactionStatusExt on TransactionStatus {
  String get label => switch (this) {
        TransactionStatus.completed  => 'ສຳເລັດ',
        TransactionStatus.pending    => 'ລໍຖ້າ',
        TransactionStatus.processing => 'ກຳລັງດຳເນີນ',
        TransactionStatus.cancelled  => 'ຍົກເລີກ',
      };

  Color get iconBg => switch (this) {
        TransactionStatus.completed  => const Color(0xFFDCFCE7),
        TransactionStatus.pending    => const Color(0xFFFEF3C7),
        TransactionStatus.processing => const Color(0xFFDBEAFE),
        TransactionStatus.cancelled  => const Color(0xFFF1EFE8),
      };

  Color get iconColor => switch (this) {
        TransactionStatus.completed  => const Color(0xFF16A34A),
        TransactionStatus.pending    => const Color(0xFFD97706),
        TransactionStatus.processing => const Color(0xFF2563EB),
        TransactionStatus.cancelled  => const Color(0xFF888780),
      };

  Color get badgeBg => switch (this) {
        TransactionStatus.completed  => const Color(0xFFDCFCE7),
        TransactionStatus.pending    => const Color(0xFFFEF3C7),
        TransactionStatus.processing => const Color(0xFFDBEAFE),
        TransactionStatus.cancelled  => const Color(0xFFF1EFE8),
      };

  Color get badgeFg => switch (this) {
        TransactionStatus.completed  => const Color(0xFF15803D),
        TransactionStatus.pending    => const Color(0xFFB45309),
        TransactionStatus.processing => const Color(0xFF1D4ED8),
        TransactionStatus.cancelled  => const Color(0xFF5F5E5A),
      };

  IconData get icon => switch (this) {
        TransactionStatus.completed  => Icons.check_rounded,
        TransactionStatus.pending    => Icons.access_time_rounded,
        TransactionStatus.processing => Icons.sync_rounded,
        TransactionStatus.cancelled  => Icons.close_rounded,
      };

  double get cardOpacity =>
      this == TransactionStatus.cancelled ? 0.55 : 1.0;
}

// ═══════════════════════════════════════════════════════════════
//  TransactionModel
// ═══════════════════════════════════════════════════════════════
class TransactionModel {
  final String id;
  final String title;
  final DateTime dateTime;
  final int amountKip;
  final TransactionStatus status;

  const TransactionModel({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.amountKip,
    required this.status,
  });

  String get formattedAmount {
    final s = amountKip.abs().toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return '+${buf.toString()} ກີບ';
  }

  String get formattedDate {
    const months = [
      '', 'ມ.ກ', 'ກ.ພ', 'ມ.ນ', 'ມ.ສ', 'ພ.ພ', 'ມ.ຖ',
      'ກ.ລ', 'ສ.ຫ', 'ກ.ຍ', 'ຕ.ລ', 'ພ.ຈ', 'ທ.ວ',
    ];
    final h = dateTime.hour.toString().padLeft(2, '0');
    final m = dateTime.minute.toString().padLeft(2, '0');
    return '${dateTime.day} ${months[dateTime.month]} ${dateTime.year} · $h:$m';
  }
}

// ═══════════════════════════════════════════════════════════════
//  WalletModel
// ═══════════════════════════════════════════════════════════════
class WalletModel {
  final int balanceKip;
  final int totalTopUpKip;
  final int totalUsedKip;
  final DateTime lastUpdated;

  const WalletModel({
    required this.balanceKip,
    required this.totalTopUpKip,
    required this.totalUsedKip,
    required this.lastUpdated,
  });

  String _fmt(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  String get formattedBalance   => '${_fmt(balanceKip)} ກີບ';
  String get formattedTotalTopUp => '${_fmt(totalTopUpKip)} ກີບ';
  String get formattedTotalUsed  => '${_fmt(totalUsedKip)} ກີບ';
}

// ── Mock data ──────────────────────────────────────────────────
final mockWallet = WalletModel(
  balanceKip:    125000,
  totalTopUpKip: 425000,
  totalUsedKip:  300000,
  lastUpdated:   DateTime(2026, 2, 4, 14, 32),
);

final mockTransactions = <TransactionModel>[
  TransactionModel(
    id: 't1', title: 'ເຕີມເງິນ',
    dateTime: DateTime(2026, 2, 4, 9, 14),
    amountKip: 200000,
    status: TransactionStatus.completed,
  ),
  TransactionModel(
    id: 't2', title: 'ເຕີມເງິນ',
    dateTime: DateTime(2026, 2, 3, 18, 45),
    amountKip: 100000,
    status: TransactionStatus.pending,
  ),
  TransactionModel(
    id: 't3', title: 'ເຕີມເງິນ',
    dateTime: DateTime(2026, 2, 2, 11, 30),
    amountKip: 125000,
    status: TransactionStatus.processing,
  ),
  TransactionModel(
    id: 't4', title: 'ເຕີມເງິນ',
    dateTime: DateTime(2026, 1, 28, 20, 10),
    amountKip: 50000,
    status: TransactionStatus.cancelled,
  ),
];