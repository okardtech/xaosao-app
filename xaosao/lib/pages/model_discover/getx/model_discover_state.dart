import 'package:xaosao/models/Recommended_model.dart';

enum DiscoverStatus { initial, loading, loadingMore, success, failure }

class ModelDiscoverState {
  final List<RecommendedModel> models;
  final DiscoverStatus status;
  final bool hasMore;
  final int skip;
  final String? filter; // null=all, 'for-you', 'who-like-me', 'i-liked'
  final String? search;

  const ModelDiscoverState({
    this.models = const [],
    this.status = DiscoverStatus.initial,
    this.hasMore = true,
    this.skip = 0,
    this.filter,
    this.search,
  });

  ModelDiscoverState copyWith({
    List<RecommendedModel>? models,
    DiscoverStatus? status,
    bool? hasMore,
    int? skip,
    String? filter,
    bool clearFilter = false,
    String? search,
    bool clearSearch = false,
  }) =>
      ModelDiscoverState(
        models: models ?? this.models,
        status: status ?? this.status,
        hasMore: hasMore ?? this.hasMore,
        skip: skip ?? this.skip,
        filter: clearFilter ? null : (filter ?? this.filter),
        search: clearSearch ? null : (search ?? this.search),
      );
}
