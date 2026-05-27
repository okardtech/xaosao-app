import 'package:xaosao/models/fee_model.dart';
import 'package:xaosao/models/my_post_model.dart';

enum PostStatus { initial, loading, loadingMore, success, failure }

class PostState {
  final PostStatus feedStatus;
  final List<FeeModel> feed;
  final bool feedHasMore;
  final int feedPage;

  final PostStatus myStatus;
  final List<MyPostModel> myPosts;
  final bool myHasMore;
  final int myPage;

  final int tabIndex;
  final bool isPosting;

  const PostState({
    this.feedStatus = PostStatus.initial,
    this.feed = const [],
    this.feedHasMore = true,
    this.feedPage = 1,
    this.myStatus = PostStatus.initial,
    this.myPosts = const [],
    this.myHasMore = true,
    this.myPage = 1,
    this.tabIndex = 0,
    this.isPosting = false,
  });

  PostState copyWith({
    PostStatus? feedStatus,
    List<FeeModel>? feed,
    bool? feedHasMore,
    int? feedPage,
    PostStatus? myStatus,
    List<MyPostModel>? myPosts,
    bool? myHasMore,
    int? myPage,
    int? tabIndex,
    bool? isPosting,
  }) {
    return PostState(
      feedStatus: feedStatus ?? this.feedStatus,
      feed: feed ?? this.feed,
      feedHasMore: feedHasMore ?? this.feedHasMore,
      feedPage: feedPage ?? this.feedPage,
      myStatus: myStatus ?? this.myStatus,
      myPosts: myPosts ?? this.myPosts,
      myHasMore: myHasMore ?? this.myHasMore,
      myPage: myPage ?? this.myPage,
      tabIndex: tabIndex ?? this.tabIndex,
      isPosting: isPosting ?? this.isPosting,
    );
  }
}
