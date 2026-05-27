import 'package:xaosao/models/Recommended_model.dart';

enum ViewCompanionStatus { initial, loading, success, failure }

class ViewCompanionState {
  final ViewCompanionStatus status;
  final List<RecommendedModel> companions;
  final String? filter;
  final String? search;
  final bool hasMore;
  final int skip;
  final String? error;

  const ViewCompanionState({
    this.status = ViewCompanionStatus.initial,
    this.companions = const [],
    this.filter,
    this.search,
    this.hasMore = false,
    this.skip = 0,
    this.error,
  });
}
