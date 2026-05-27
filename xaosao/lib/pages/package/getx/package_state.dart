import 'package:xaosao/models/package_history_model.dart';
import 'package:xaosao/models/package_model.dart';

import '../../../models/package_hour_model.dart';

enum PackageStatus { initial, loading, success, failure }

class PackageState {
  final PackageStatus status;
  final List<PackageData> packages;
  final CurrentSubscriptionPlan? currentPlan;
  final List<PackageHistoryModel> history;
  final bool loadingHistory;
  final bool hasMoreHistory;
  final int historyPage;
  final String? error;
  final PackageHourModel? packageHour;
  final bool subscribing;

  const PackageState({
    this.status = PackageStatus.initial,
    this.packages = const [],
    this.currentPlan,
    this.history = const [],
    this.loadingHistory = false,
    this.hasMoreHistory = true,
    this.historyPage = 1,
    this.error,
    this.packageHour,
    this.subscribing = false,
  });

  PackageState copyWith({
    PackageStatus? status,
    List<PackageData>? packages,
    CurrentSubscriptionPlan? currentPlan,
    List<PackageHistoryModel>? history,
    bool? loadingHistory,
    bool? hasMoreHistory,
    int? historyPage,
    String? error,
    PackageHourModel? packageHour,
    bool? subscribing,
  }) => PackageState(
    status: status ?? this.status,
    packages: packages ?? this.packages,
    currentPlan: currentPlan ?? this.currentPlan,
    history: history ?? this.history,
    loadingHistory: loadingHistory ?? this.loadingHistory,
    hasMoreHistory: hasMoreHistory ?? this.hasMoreHistory,
    historyPage: historyPage ?? this.historyPage,
    error: error ?? this.error,
    packageHour: packageHour ?? this.packageHour,
    subscribing: subscribing ?? this.subscribing,
  );
}
