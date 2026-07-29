import 'package:xaosao/models/comission_model.dart';

enum CommissionsStatus { initial, loading, success, failure }

class CommissionsState {
  final CommissionsStatus status;
  final List<ComissionModel> items;
  final bool loadingMore;
  final bool hasMore;
  final int page;
  final String? error;

  const CommissionsState({
    this.status = CommissionsStatus.initial,
    this.items = const [],
    this.loadingMore = false,
    this.hasMore = true,
    this.page = 1,
    this.error,
  });

  CommissionsState copyWith({
    CommissionsStatus? status,
    List<ComissionModel>? items,
    bool? loadingMore,
    bool? hasMore,
    int? page,
    String? error,
  }) =>
      CommissionsState(
        status: status ?? this.status,
        items: items ?? this.items,
        loadingMore: loadingMore ?? this.loadingMore,
        hasMore: hasMore ?? this.hasMore,
        page: page ?? this.page,
        error: error,
      );
}
