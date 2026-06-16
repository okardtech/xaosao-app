import 'package:xaosao/models/interest_model.dart';

enum InterestStatus { initial, loading, loadingMore, success, failure }

class InterestState {
  final InterestStatus status;
  final List<InterestModel> items;
  final bool hasMore;
  final int page;

  const InterestState({
    this.status = InterestStatus.initial,
    this.items = const [],
    this.hasMore = true,
    this.page = 1,
  });

  InterestState copyWith({
    InterestStatus? status,
    List<InterestModel>? items,
    bool? hasMore,
    int? page,
  }) =>
      InterestState(
        status: status ?? this.status,
        items: items ?? this.items,
        hasMore: hasMore ?? this.hasMore,
        page: page ?? this.page,
      );
}
