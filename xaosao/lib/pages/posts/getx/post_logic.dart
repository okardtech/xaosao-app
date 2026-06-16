import 'package:get/get.dart';
import 'package:xaosao/models/fee_model.dart';
import 'package:xaosao/models/my_post_model.dart';
import 'package:xaosao/pages/posts/getx/post_state.dart';
import 'package:xaosao/repository/post_repo.dart';
import 'package:xaosao/services/storage_service.dart';
import 'package:xaosao/utils/app_snackbar.dart';
import 'package:xaosao/widgets/show_loading_alert.dart';

class PostLogic extends GetxController {
  final _repo = MyPost();

  final Rx<PostState> _state = PostState().obs;
  PostState get state => _state.value;
  Rx<PostState> get rx => _state;
  void _update(PostState s) => _state.value = s;

  static const int _limit = 10;

  bool _loadingFeed = false;
  bool _loadingMy = false;

  bool get isClient =>
      Get.find<StorageService>().read<String>('role') == 'customer';

  @override
  void onInit() {
    super.onInit();
    fetchFeed(refresh: true);
    fetchMyPosts(refresh: true);
  }

  // ── Feed ──────────────────────────────────────────────────

  Future<void> fetchFeed({bool refresh = false}) async {
    if (_loadingFeed) return;
    if (!refresh && !state.feedHasMore) return;

    _loadingFeed = true;
    final page = refresh ? 1 : state.feedPage;
    final isFirst = refresh || page == 1;

    _update(
      state.copyWith(
        feedStatus: isFirst ? PostStatus.loading : PostStatus.loadingMore,
        feed: refresh ? [] : null,
        feedHasMore: refresh ? true : null,
        feedPage: refresh ? 1 : null,
      ),
    );

    try {
      final res = await _repo.getFee(
        isClient: isClient,
        page: page,
        limit: _limit,
      );
      if (res.success && res.data != null) {
        final items = res.data!;
        _update(
          state.copyWith(
            feedStatus: PostStatus.success,
            feed: [...(refresh ? <FeeModel>[] : state.feed), ...items],
            feedHasMore: items.length >= _limit,
            feedPage: page + 1,
          ),
        );
      } else {
        _update(
          state.copyWith(
            feedStatus: isFirst ? PostStatus.failure : PostStatus.success,
          ),
        );
        if (isFirst) AppSnackbar.error(res.laMessage ?? 'ໂຫຼດຟີດບໍ່ສຳເລັດ');
      }
    } catch (_) {
      _update(
        state.copyWith(
          feedStatus: isFirst ? PostStatus.failure : PostStatus.success,
        ),
      );
      if (isFirst) AppSnackbar.error('ໂຫຼດຟີດບໍ່ສຳເລັດ');
    } finally {
      _loadingFeed = false;
    }
  }

  Future<void> loadMoreFeed() => fetchFeed();

  // ── My Posts ─────────────────────────────────────────────

  Future<void> fetchMyPosts({bool refresh = false}) async {
    if (_loadingMy) return;
    if (!refresh && !state.myHasMore) return;

    _loadingMy = true;
    final page = refresh ? 1 : state.myPage;
    final isFirst = refresh || page == 1;

    _update(
      state.copyWith(
        myStatus: isFirst ? PostStatus.loading : PostStatus.loadingMore,
        myPosts: refresh ? [] : null,
        myHasMore: refresh ? true : null,
        myPage: refresh ? 1 : null,
      ),
    );

    try {
      final res = await _repo.getMyPost(page: page, limit: _limit);
      if (res.success && res.data != null) {
        final items = res.data!;
        _update(
          state.copyWith(
            myStatus: PostStatus.success,
            myPosts: [...(refresh ? [] : state.myPosts), ...items],
            myHasMore: items.length >= _limit,
            myPage: page + 1,
          ),
        );
      } else {
        _update(
          state.copyWith(
            myStatus: isFirst ? PostStatus.failure : PostStatus.success,
          ),
        );
        if (isFirst) AppSnackbar.error(res.laMessage ?? 'ໂຫຼດໂພສຂ້ອຍບໍ່ສຳເລັດ');
      }
    } catch (_) {
      _update(
        state.copyWith(
          myStatus: isFirst ? PostStatus.failure : PostStatus.success,
        ),
      );
      if (isFirst) AppSnackbar.error('ໂຫຼດໂພສຂ້ອຍບໍ່ສຳເລັດ');
    } finally {
      _loadingMy = false;
    }
  }

  Future<void> loadMoreMyPosts() => fetchMyPosts();

  // ── Reset to tab 0 + refresh ─────────────────────────────

  void resetToFirst() {
    _update(state.copyWith(tabIndex: 0));
    fetchFeed(refresh: true);
  }

  void setTab(int index) {
    _update(state.copyWith(tabIndex: index));
    if (index == 0)
      fetchFeed(refresh: true);
    else
      fetchMyPosts(refresh: true);
  }

  // ── Toggle Interest (optimistic + server sync) ───────────

  Future<void> toggleInterest(String postId) async {
    final idx = state.feed.indexWhere((p) => p.id == postId);
    if (idx == -1) return;
    final o = state.feed[idx];
    final nowOn = !(o.isInterested ?? false);

    // Optimistic update
    _patchFeedInterest(idx, o, isInterested: nowOn,
        interestedCount: ((o.interestedCount ?? 0) + (nowOn ? 1 : -1)).clamp(0, 999999));

    final res = await _repo.toggleInterest(postId: postId);

    // Sync with server values on success; revert on failure
    final currentIdx = state.feed.indexWhere((p) => p.id == postId);
    if (currentIdx == -1) return;
    final current = state.feed[currentIdx];
    if (res.success && res.data != null) {
      _patchFeedInterest(currentIdx, current,
          isInterested: res.data!.isInterested,
          interestedCount: res.data!.interestedCount);
    } else {
      // Revert to original values
      _patchFeedInterest(currentIdx, current,
          isInterested: o.isInterested ?? false,
          interestedCount: o.interestedCount ?? 0);
    }
  }

  void _patchFeedInterest(int idx, FeeModel o,
      {required bool isInterested, required int interestedCount}) {
    final patched = List<FeeModel>.of(state.feed);
    patched[idx] = FeeModel(
      id: o.id, authorType: o.authorType, content: o.content,
      images: o.images, hasTip: o.hasTip, status: o.status,
      expiresAt: o.expiresAt, interestedCount: interestedCount,
      totalCommentCount: o.totalCommentCount, totalGiftCount: o.totalGiftCount,
      isInterested: isInterested, createdAt: o.createdAt, updatedAt: o.updatedAt,
      author: o.author, service: o.service,
      location: o.location, targetGender: o.targetGender,
    );
    _update(state.copyWith(feed: patched));
  }

  // ── Optimistic count bumps (comment / gift) ──────────────────

  void bumpCommentCount(String postId) {
    final fi = state.feed.indexWhere((p) => p.id == postId);
    if (fi != -1) {
      final o = state.feed[fi];
      final patched = List<FeeModel>.of(state.feed);
      patched[fi] = FeeModel(
        id: o.id, authorType: o.authorType, content: o.content,
        images: o.images, hasTip: o.hasTip, status: o.status,
        expiresAt: o.expiresAt, interestedCount: o.interestedCount,
        totalCommentCount: (o.totalCommentCount ?? 0) + 1,
        totalGiftCount: o.totalGiftCount, isInterested: o.isInterested,
        createdAt: o.createdAt, updatedAt: o.updatedAt,
        author: o.author, service: o.service,
        location: o.location, targetGender: o.targetGender,
      );
      _update(state.copyWith(feed: patched));
    }
    final mi = state.myPosts.indexWhere((p) => p.id == postId);
    if (mi != -1) {
      final o = state.myPosts[mi];
      final c = o.counts;
      final patched = List<MyPostModel>.of(state.myPosts);
      patched[mi] = MyPostModel(
        id: o.id, authorType: o.authorType, content: o.content,
        images: o.images, hasTip: o.hasTip, status: o.status,
        expiresAt: o.expiresAt, interestedCount: o.interestedCount,
        createdAt: o.createdAt, updatedAt: o.updatedAt, location: o.location,
        counts: Counts(
          interests: c?.interests,
          comments: (c?.comments ?? 0) + 1,
          gifts: c?.gifts,
        ),
      );
      _update(state.copyWith(myPosts: patched));
    }
  }

  void bumpGiftCount(String postId) {
    final fi = state.feed.indexWhere((p) => p.id == postId);
    if (fi == -1) return;
    final o = state.feed[fi];
    final patched = List<FeeModel>.of(state.feed);
    patched[fi] = FeeModel(
      id: o.id, authorType: o.authorType, content: o.content,
      images: o.images, hasTip: o.hasTip, status: o.status,
      expiresAt: o.expiresAt, interestedCount: o.interestedCount,
      totalCommentCount: o.totalCommentCount,
      totalGiftCount: (o.totalGiftCount ?? 0) + 1, isInterested: o.isInterested,
      createdAt: o.createdAt, updatedAt: o.updatedAt,
      author: o.author, service: o.service,
      location: o.location, targetGender: o.targetGender,
    );
    _update(state.copyWith(feed: patched));
  }

  // ── Create post ─────────────────────────────────────────────

  Future<bool> createPost({
    required String content,
    String? filePath,
    String? serviceId,
    String? targetGender,
    String? location,
    bool hasTip = false,
  }) async {
    if (state.isPosting) return false;
    _update(state.copyWith(isPosting: true));
    showLoadingDialog();
    try {
      final loc = location?.trim().isEmpty == true ? null : location?.trim();
      final res = isClient
          ? await _repo.createCustomerPost(
              content: content,
              serviceId: serviceId,
              targetGender: targetGender,
              location: loc,
              hasTip: hasTip,
            )
          : await _repo.createModelPost(content: content, filePath: filePath);
      if (res.success) {
        AppSnackbar.info(res.laMessage ?? 'ສ້າງໂພສສຳເລັດ');
        fetchMyPosts(refresh: true);
        fetchFeed(refresh: true);
        return true;
      } else {
        AppSnackbar.error(res.laMessage ?? 'ສ້າງໂພສບໍ່ສຳເລັດ');
        return false;
      }
    } catch (_) {
      AppSnackbar.error('ສ້າງໂພສບໍ່ສຳເລັດ');
      return false;
    } finally {
      hideLoadingDialog();
      _update(state.copyWith(isPosting: false));
    }
  }

  // ── Hide my post ─────────────────────────────────────────

  Future<void> hideMyPost(String postId) async {
    showLoadingDialog();
    try {
      final res = await _repo.hidePost(postId: postId);
      if (res.success) {
        final mi = state.myPosts.indexWhere((p) => p.id == postId);
        if (mi != -1) {
          final o = state.myPosts[mi];
          final patched = List<MyPostModel>.of(state.myPosts);
          patched[mi] = MyPostModel(
            id: o.id, authorType: o.authorType, content: o.content,
            images: o.images, hasTip: o.hasTip, status: 'fulfilled',
            expiresAt: o.expiresAt, interestedCount: o.interestedCount,
            createdAt: o.createdAt, updatedAt: o.updatedAt,
            counts: o.counts, location: o.location,
          );
          _update(state.copyWith(myPosts: patched));
        }
        AppSnackbar.info(res.laMessage ?? 'ປິດໃຊ້ງານໂພສສຳເລັດ');
      } else {
        AppSnackbar.error(res.laMessage ?? 'ປິດໃຊ້ງານໂພສບໍ່ສຳເລັດ');
      }
    } catch (_) {
      AppSnackbar.error('ປິດໃຊ້ງານໂພສບໍ່ສຳເລັດ');
    } finally {
      hideLoadingDialog();
    }
  }

  // ── Delete my post ───────────────────────────────────────

  Future<void> deleteMyPost(String postId) async {
    showLoadingDialog();
    try {
      final res = await _repo.deletePost(postId: postId);
      if (res.success) {
        // Remove from both lists so feed stays in sync
        _update(
          state.copyWith(
            myPosts: state.myPosts.where((p) => p.id != postId).toList(),
            feed: state.feed.where((p) => p.id != postId).toList(),
          ),
        );
        AppSnackbar.info(res.laMessage ?? "ລຶບໂພສສຳເລັດ");
      } else {
        AppSnackbar.error(res.laMessage ?? 'ລຶບໂພສບໍ່ສຳເລັດ');
      }
    } catch (_) {
      AppSnackbar.error('ລຶບໂພສບໍ່ສຳເລັດ');
    } finally {
      hideLoadingDialog();
    }
  }
}
