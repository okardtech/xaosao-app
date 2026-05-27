import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:xaosao/models/comment_model.dart';
import 'package:xaosao/pages/login/getx/login_logic.dart';
import 'package:xaosao/pages/posts/getx/comment_state.dart';
import 'package:xaosao/repository/post_repo.dart';

class CommentLogic extends GetxController {
  final String postId;
  final int initialCommentCount;

  CommentLogic(this.postId, {this.initialCommentCount = 0});

  final _repo = MyPost();
  static const int _limit = 15;
  bool _loadingComments = false;

  // ── Primary list state (pagination + comments) ────────────
  final Rx<CommentState> _state = CommentState().obs;
  CommentState get state => _state.value;
  void _update(CommentState s) => _state.value = s;

  // ── Separate reactive fields ──────────────────────────────
  late final RxInt commentCount;
  final RxBool isSubmitting = false.obs;
  final Rx<String?> replyToCommentId = Rx<String?>(null);
  final Rx<String?> replyToName = Rx<String?>(null);

  /// Map from commentId → its loaded replies
  final RxMap<String, List<CommentModel>> repliesMap =
      <String, List<CommentModel>>{}.obs;

  /// Comment IDs whose replies are currently being fetched
  final RxList<String> loadingRepliesIds = <String>[].obs;

  /// Comment IDs that are expanded (showing replies)
  final RxList<String> expandedIds = <String>[].obs;

  // ─────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    commentCount = initialCommentCount.obs;
    fetchComments(refresh: true);
  }

  // ── Fetch comments ────────────────────────────────────────

  Future<void> fetchComments({bool refresh = false}) async {
    if (_loadingComments) return;
    if (!refresh && !state.hasMore) return;

    _loadingComments = true;
    final page = refresh ? 1 : state.page;
    final isFirst = refresh || page == 1;

    _update(state.copyWith(
      status: isFirst ? CommentStatus.loading : CommentStatus.loadingMore,
      comments: refresh ? [] : null,
      hasMore: refresh ? true : null,
      page: refresh ? 1 : null,
    ));

    try {
      final res = await _repo.getComments(
        postId: postId,
        page: page,
        limit: _limit,
      );
      if (res.success && res.data != null) {
        final items = res.data!;
        _update(state.copyWith(
          status: CommentStatus.success,
          comments: [
            ...(refresh ? <CommentModel>[] : state.comments),
            ...items,
          ],
          hasMore: items.length >= _limit,
          page: page + 1,
        ));
      } else {
        _update(state.copyWith(
          status: isFirst ? CommentStatus.failure : CommentStatus.success,
        ));
      }
    } catch (_) {
      _update(state.copyWith(
        status: isFirst ? CommentStatus.failure : CommentStatus.success,
      ));
    } finally {
      _loadingComments = false;
    }
  }

  Future<void> loadMoreComments() => fetchComments();

  // ── Fetch replies for a comment ───────────────────────────

  Future<void> fetchReplies(String commentId) async {
    if (loadingRepliesIds.contains(commentId)) return;
    loadingRepliesIds.add(commentId);

    try {
      final res = await _repo.getReplies(
        postId: postId,
        commentId: commentId,
        page: 1,
        limit: 20,
      );
      if (res.success && res.data != null) {
        repliesMap[commentId] = res.data!;
        repliesMap.refresh();
        if (!expandedIds.contains(commentId)) {
          expandedIds.add(commentId);
        }
      }
    } catch (_) {
    } finally {
      loadingRepliesIds.remove(commentId);
    }
  }

  // ── Toggle reply expansion ────────────────────────────────

  void toggleReplies(String commentId) {
    if (expandedIds.contains(commentId)) {
      expandedIds.remove(commentId);
    } else if (repliesMap.containsKey(commentId)) {
      expandedIds.add(commentId);
    } else {
      fetchReplies(commentId);
    }
  }

  // ── Reply target ──────────────────────────────────────────

  void setReplyTo(String commentId, String authorName) {
    replyToCommentId.value = commentId;
    replyToName.value = authorName;
  }

  void clearReplyTo() {
    replyToCommentId.value = null;
    replyToName.value = null;
  }

  // ── Submit (top-level comment or reply) ───────────────────

  Future<void> submit(String text, {VoidCallback? onCommentAdded}) async {
    if (text.isEmpty || isSubmitting.value) return;
    isSubmitting.value = true;

    final loginLogic = Get.find<LoginLogic>();
    final ls = loginLogic.state;
    final replyTo = replyToCommentId.value;

    final optAuthor = CommentAuthor(
      id: '',
      firstName: ls.displayName,
      profile: ls.profileImageUrl,
    );

    if (replyTo != null) {
      // ── Reply: optimistic insert ──────────────────────────
      final optId = 'opt_${DateTime.now().millisecondsSinceEpoch}';
      final optReply = CommentModel(
        id: optId,
        postId: postId,
        parentId: replyTo,
        content: text,
        createdAt: DateTime.now(),
        author: optAuthor,
      );

      final current = List<CommentModel>.from(repliesMap[replyTo] ?? []);
      current.add(optReply);
      repliesMap[replyTo] = current;
      repliesMap.refresh();

      if (!expandedIds.contains(replyTo)) expandedIds.add(replyTo);

      // Increment replyCount on the parent comment
      final parentIdx = state.comments.indexWhere((c) => c.id == replyTo);
      if (parentIdx != -1) {
        final updated = List<CommentModel>.from(state.comments);
        updated[parentIdx] = updated[parentIdx]
            .copyWith(replyCount: updated[parentIdx].replyCount + 1);
        _update(state.copyWith(comments: updated));
      }

      clearReplyTo();

      try {
        final res = await _repo.createComment(
          postId: postId,
          content: text,
          parentId: replyTo,
        );
        // Replace opt item with real server data (no reload needed)
        if (res.success && res.data != null) {
          final real = res.data!.copyWith(author: optAuthor);
          final list = List<CommentModel>.from(repliesMap[replyTo] ?? []);
          final i = list.indexWhere((r) => r.id == optId);
          if (i != -1) {
            list[i] = real;
            repliesMap[replyTo] = list;
            repliesMap.refresh();
          }
        }
      } catch (_) {
        // Rollback: remove optimistic reply
        final list = List<CommentModel>.from(repliesMap[replyTo] ?? []);
        list.removeWhere((r) => r.id == optId);
        repliesMap[replyTo] = list;
        repliesMap.refresh();
        // Rollback replyCount
        final idx = state.comments.indexWhere((c) => c.id == replyTo);
        if (idx != -1) {
          final updated = List<CommentModel>.from(state.comments);
          updated[idx] = updated[idx]
              .copyWith(replyCount: (updated[idx].replyCount - 1).clamp(0, 99999));
          _update(state.copyWith(comments: updated));
        }
      }
    } else {
      // ── Top-level comment: optimistic insert at top ───────
      final optId = 'opt_${DateTime.now().millisecondsSinceEpoch}';
      final optComment = CommentModel(
        id: optId,
        postId: postId,
        content: text,
        createdAt: DateTime.now(),
        author: optAuthor,
        replyCount: 0,
      );

      _update(state.copyWith(
        comments: [optComment, ...state.comments],
      ));
      commentCount.value++;
      onCommentAdded?.call();

      try {
        final res = await _repo.createComment(postId: postId, content: text);
        // Replace opt item with real server data (no reload needed)
        if (res.success && res.data != null) {
          final real = res.data!.copyWith(author: optAuthor);
          final idx = state.comments.indexWhere((c) => c.id == optId);
          if (idx != -1) {
            final updated = List<CommentModel>.from(state.comments);
            updated[idx] = real;
            _update(state.copyWith(comments: updated));
          }
        }
      } catch (_) {
        // Rollback: remove optimistic comment and revert count
        _update(state.copyWith(
          comments: state.comments.where((c) => c.id != optId).toList(),
        ));
        commentCount.value--;
      }
    }

    isSubmitting.value = false;
  }
}
