import 'package:xaosao/models/comment_model.dart';

enum CommentStatus { initial, loading, loadingMore, success, failure }

class CommentState {
  final CommentStatus status;
  final List<CommentModel> comments;
  final bool hasMore;
  final int page;

  const CommentState({
    this.status = CommentStatus.initial,
    this.comments = const [],
    this.hasMore = true,
    this.page = 1,
  });

  CommentState copyWith({
    CommentStatus? status,
    List<CommentModel>? comments,
    bool? hasMore,
    int? page,
  }) {
    return CommentState(
      status: status ?? this.status,
      comments: comments ?? this.comments,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
    );
  }
}
