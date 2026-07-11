import 'package:xaosao/models/post_detail_model.dart';

enum PostDetailStatus { initial, loading, success, failure }

class PostDetailState {
  final PostDetailStatus status;
  final PostDetailModel? data;
  final String? error;

  const PostDetailState({
    this.status = PostDetailStatus.initial,
    this.data,
    this.error,
  });

  PostDetailState copyWith({
    PostDetailStatus? status,
    PostDetailModel? data,
    String? error,
  }) => PostDetailState(
    status: status ?? this.status,
    data: data ?? this.data,
    error: error ?? this.error,
  );
}
