import 'package:xaosao/models/gift_post_model.dart';

enum GiftedPostsStatus { initial, loading, success, failure }

class GiftedPostsState {
  final GiftedPostsStatus status;
  final GiftPostModel? data;
  final String? error;

  const GiftedPostsState({
    this.status = GiftedPostsStatus.initial,
    this.data,
    this.error,
  });

  GiftedPostsState copyWith({
    GiftedPostsStatus? status,
    GiftPostModel? data,
    String? error,
  }) => GiftedPostsState(
    status: status ?? this.status,
    data: data ?? this.data,
    error: error ?? this.error,
  );
}
