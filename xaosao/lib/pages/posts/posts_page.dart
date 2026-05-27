import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/pages/posts/components/comment_sheet.dart';
import 'package:xaosao/pages/posts/components/post_card.dart';
import 'package:xaosao/models/service_model.dart';
import 'package:xaosao/pages/login/getx/login_logic.dart';
import 'package:xaosao/pages/posts/getx/post_logic.dart';
import 'package:xaosao/pages/posts/getx/post_state.dart';
import 'package:xaosao/repository/register_repo.dart';
import 'package:xaosao/utils/image_picker_util.dart';
import 'package:xaosao/widgets/app_button.dart';
import 'package:xaosao/widgets/app_text_field.dart';
import 'package:xaosao/widgets/confirm_sheet.dart';
import 'package:xaosao/widgets/empty_state.dart';

import '../topup/topup_amount.dart';
import '../../widgets/gift_sheet.dart';

// Colors not in AppColors
const _dangerColor = Color(0xFFDC2626);
const _inactiveGrey = Color(0xFFE0E0E0);

// ═══════════════════════════════════════════════════════════════
//  PostsPage
// ═══════════════════════════════════════════════════════════════
class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  late final PostLogic _logic;

  @override
  void initState() {
    super.initState();
    _logic = Get.isRegistered<PostLogic>()
        ? Get.find<PostLogic>()
        : Get.put(PostLogic());

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSegment(),
            Expanded(
              child: Obx(() => IndexedStack(
                index: _logic.state.tabIndex,
                children: [_buildFeedTab(), _buildMyPostsTab()],
              )),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 16.w, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ໂພສ',
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.8,
                    height: 1,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'ຄົ້ນຫາ Companion ທີ່ໃຊ່ຂອງທ່ານ',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textHint,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          _WriteBtn(onTap: _showCreatePostSheet),
        ],
      ),
    );
  }

  // ── Segment control ────────────────────────────────────────
  Widget _buildSegment() {
    return Obx(() => Padding(
      padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 10.h),
      child: _PillSwitcher(
        index: _logic.state.tabIndex,
        onChanged: _logic.setTab,
      ),
    ));
  }

  // ── Tab 0: ທັງໝົດ (feed) ───────────────────────────────────
  Widget _buildFeedTab() {
    return Obx(() {
      final state = _logic.state;
      final feed = state.feed;
      final isLoading =
          state.feedStatus == PostStatus.loading && feed.isEmpty;

      if (isLoading) {
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 90.h),
          itemCount: 4,
          itemBuilder: (_, i) => Padding(
            padding: EdgeInsets.only(bottom: 14.h),
            child: PostCardShimmer(withImage: i % 2 == 0),
          ),
        );
      }

      if (state.feedStatus == PostStatus.failure && feed.isEmpty) {
        return AppEmptyState(
          icon: Icons.wifi_off_rounded,
          title: 'ບໍ່ສາມາດໂຫຼດຂໍ້ມູນ',
          subtitle: 'ກະລຸນາລອງໃໝ່ອີກຄັ້ງ',
          iconColor: AppColors.primary,
          actionLabel: 'ລອງໃໝ່',
          onAction: () => _logic.fetchFeed(refresh: true),
        );
      }

      if (state.feedStatus == PostStatus.success && feed.isEmpty) {
        return AppEmptyState(
          icon: Icons.article_outlined,
          title: 'ຍັງບໍ່ມີໂພສ',
          subtitle: 'ໂພສຈາກ Companion ຈະສະແດງທີ່ນີ້',
          iconColor: AppColors.primary,
        );
      }

      return RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: Colors.white,
        strokeWidth: 2.5,
        onRefresh: () => _logic.fetchFeed(refresh: true),
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 90.h),
          itemCount: feed.length + 1,
          itemBuilder: (_, i) {
            if (i < feed.length) {
              final post = feed[i];
              return Padding(
                padding: EdgeInsets.only(bottom: 14.h),
                child: PostCard(
                  post: post,
                  onInterest: () => _logic.toggleInterest(post.id ?? ''),
                  onGift: () {
                    final name = [
                      post.author?.firstName,
                      post.author?.lastName,
                    ].where((s) => s != null).join(' ');
                    GiftSheet.show(
                      context,
                      postId: post.id ?? '',
                      companionName: name.isEmpty ? 'Companion' : name,
                      balanceKip: 0,
                      onSent: (gift) => GiftSentSnackbar.show(context, gift: gift),
                      onTopUp: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TopUpAmountPage()),
                      ),
                    );
                  },
                  onMessage: () => CommentSheet.show(
                    context,
                    postId: post.id ?? '',
                    commentCount: post.commentCount ?? 0,
                    onCommentAdded: () {
                      // optimistic count bump handled inside sheet
                    },
                  ),
                  onBook: () {},
                  onMore: () => _showMoreSheet(isMyPost: false),
                  onTap: () {},
                ),
              );
            }
            // Load more row
            return _LoadMoreRow(
              hasMore: state.feedHasMore,
              isLoadingMore: state.feedStatus == PostStatus.loadingMore,
              onLoadMore: _logic.loadMoreFeed,
            );
          },
        ),
      );
    });
  }

  // ── Tab 1: ຂອງຂ້ອຍ ─────────────────────────────────────────
  Widget _buildMyPostsTab() {
    return Obx(() {
      final state = _logic.state;
      final posts = state.myPosts;
      final isLoading =
          state.myStatus == PostStatus.loading && posts.isEmpty;

      if (isLoading) {
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 90.h),
          itemCount: 3,
          itemBuilder: (_, __) => Padding(
            padding: EdgeInsets.only(bottom: 14.h),
            child: const PostCardShimmer(withImage: true),
          ),
        );
      }

      if (state.myStatus == PostStatus.failure && posts.isEmpty) {
        return AppEmptyState(
          icon: Icons.wifi_off_rounded,
          title: 'ບໍ່ສາມາດໂຫຼດຂໍ້ມູນ',
          subtitle: 'ກະລຸນາລອງໃໝ່ອີກຄັ້ງ',
          iconColor: AppColors.primary,
          actionLabel: 'ລອງໃໝ່',
          onAction: () => _logic.fetchMyPosts(refresh: true),
        );
      }

      if (state.myStatus == PostStatus.success && posts.isEmpty) {
        return AppEmptyState(
          icon: Icons.edit_note_rounded,
          title: 'ຍັງບໍ່ມີໂພສ',
          subtitle: 'ກົດ "ສ້າງໂພສ" ເພື່ອເລີ່ມໂພສ',
          iconColor: AppColors.primary,
        );
      }

      return RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: Colors.white,
        strokeWidth: 2.5,
        onRefresh: () => _logic.fetchMyPosts(refresh: true),
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 90.h),
          itemCount: posts.length + 1,
          itemBuilder: (_, i) {
            if (i < posts.length) {
              final post = posts[i];
              return Padding(
                padding: EdgeInsets.only(bottom: 14.h),
                child: MyPostCard(
                  post: post,
                  onDelete: () => _confirmDelete(post.id ?? ''),
                  onHide: () {},
                  onTap: () {},
                ),
              );
            }
            return _LoadMoreRow(
              hasMore: state.myHasMore,
              isLoadingMore: state.myStatus == PostStatus.loadingMore,
              onLoadMore: _logic.loadMoreMyPosts,
            );
          },
        ),
      );
    });
  }

  // ── Create post sheet ───────────────────────────────────────
  void _showCreatePostSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => _CreatePostSheet(logic: _logic),
    );
  }

  // ── More sheet ──────────────────────────────────────────────
  void _showMoreSheet({required bool isMyPost}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 12.h, bottom: 4.h),
                child: Center(child: _DragHandle()),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 12.h),
                child: Column(
                  children: [
                    _SheetItem(
                      icon: Icons.share_outlined,
                      label: 'ແຊຣ໌ໂພສ',
                      onTap: () => Navigator.pop(context),
                    ),
                    Container(
                      height: 1,
                      color: Colors.black.withValues(alpha: 0.05),
                    ),
                    _SheetItem(
                      icon: Icons.flag_outlined,
                      label: 'ລາຍງານ',
                      onTap: () => Navigator.pop(context),
                      isRed: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Confirm delete ──────────────────────────────────────────
  Future<void> _confirmDelete(String postId) async {
    final confirmed = await ConfirmSheet.show(
      context,
      title: 'ລຶບໂພສ',
      message: 'ທ່ານແນ່ໃຈທີ່ຈະລຶບໂພສນີ້ບໍ?\nການດຳເນີນການນີ້ບໍ່ສາມາດຍ້ອນຄືນໄດ້',
      confirmLabel: 'ລຶບ',
      icon: Icons.delete_outline_rounded,
      isDanger: true,
    );
    if (confirmed == true) _logic.deleteMyPost(postId);
  }
}

// ═══════════════════════════════════════════════════════════════
//  _LoadMoreRow
// ═══════════════════════════════════════════════════════════════
class _LoadMoreRow extends StatelessWidget {
  final bool hasMore;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;

  const _LoadMoreRow({
    required this.hasMore,
    required this.isLoadingMore,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    if (!hasMore && !isLoadingMore) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 22.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 22.w,
              height: 1,
              color: Colors.black.withValues(alpha: 0.1),
            ),
            SizedBox(width: 8.w),
            Text(
              'ສິ້ນສຸດ',
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.textHint,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              width: 22.w,
              height: 1,
              color: Colors.black.withValues(alpha: 0.1),
            ),
          ],
        ),
      );
    }

    if (isLoadingMore) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Center(
          child: SizedBox(
            width: 22.r,
            height: 22.r,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Center(
        child: GestureDetector(
          onTap: onLoadMore,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 9.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.expand_more_rounded,
                    size: 15.r, color: AppColors.primary),
                SizedBox(width: 4.w),
                Text(
                  'ໂຫຼດເພີ່ມ',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _WriteBtn
// ═══════════════════════════════════════════════════════════════
class _WriteBtn extends StatelessWidget {
  final VoidCallback onTap;
  const _WriteBtn({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, const Color(0xFFFF6B85)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.32),
              blurRadius: 14,
              spreadRadius: 0,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_rounded, size: 14.r, color: Colors.white),
            SizedBox(width: 5.w),
            Text(
              'ສ້າງໂພສ',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _PillSwitcher  (full-width gradient pill tab selector)
// ═══════════════════════════════════════════════════════════════
class _PillSwitcher extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;

  const _PillSwitcher({required this.index, required this.onChanged});

  static const _labels = ['ທັງໝົດ', 'ຂອງຂ້ອຍ'];
  static const _pillGrad = [AppColors.primary, Color(0xFFFF6B85)];
  static const _dur = Duration(milliseconds: 250);
  static const _curve = Curves.easeInOut;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, cst) {
        const pad = 4.0;
        final pillW = (cst.maxWidth - pad * 2) / _labels.length;
        final pillLeft = pad + index * pillW;

        return Container(
          height: 46.h,
          decoration: BoxDecoration(
            // Warm rose tint track — matches primary brand colour
            color: AppColors.primary.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Stack(
            children: [
              // ── sliding gradient pill ───────────────────────
              AnimatedPositioned(
                duration: _dur,
                curve: _curve,
                left: pillLeft,
                top: pad,
                bottom: pad,
                width: pillW,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: _pillGrad,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(11.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.38),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.18),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
              // ── tap targets + labels ────────────────────────
              Row(
                children: List.generate(_labels.length, (i) {
                  final active = index == i;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onChanged(i),
                      behavior: HitTestBehavior.opaque,
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: _dur,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight:
                                active ? FontWeight.w800 : FontWeight.w600,
                            color: active
                                ? Colors.white
                                : AppColors.textSecondary,
                            letterSpacing: active ? 0.1 : 0,
                          ),
                          child: Text(_labels[i]),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _CreatePostSheet
// ═══════════════════════════════════════════════════════════════
class _CreatePostSheet extends StatefulWidget {
  final PostLogic logic;
  const _CreatePostSheet({required this.logic});

  @override
  State<_CreatePostSheet> createState() => _CreatePostSheetState();
}

class _CreatePostSheetState extends State<_CreatePostSheet> {
  final _contentCtrl = TextEditingController();
  final _contentFocus = FocusNode();
  final _locationCtrl = TextEditingController();
  final _locationFocus = FocusNode();

  File? _image;
  String? _targetGender; // null = any, 'male', 'female'
  bool _hasTip = false;

  List<ServiceModel> _services = [];
  bool _loadingServices = false;
  ServiceModel? _selectedService;

  PostLogic get _logic => widget.logic;
  bool get _isModel => !_logic.isClient;

  bool get _canPost => _contentCtrl.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    if (!_isModel) _loadServices();
  }

  Future<void> _loadServices() async {
    setState(() => _loadingServices = true);
    final res = await RegisterRepo().servicePublic();
    if (!mounted) return;
    setState(() {
      _services = res.data ?? [];
      _loadingServices = false;
    });
  }

  @override
  void dispose() {
    _contentCtrl.dispose();
    _contentFocus.dispose();
    _locationCtrl.dispose();
    _locationFocus.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final file = await ImagePickerUtil.pick();
    if (file != null && mounted) setState(() => _image = file);
  }

  Future<void> _submit() async {
    if (!_canPost) return;
    final ok = await _logic.createPost(
      content: _contentCtrl.text.trim(),
      filePath: _image?.path,
      serviceId: _selectedService?.id,
      targetGender: _targetGender,
      location: _locationCtrl.text.trim(),
      hasTip: _hasTip,
    );
    if (ok && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final loginState = Get.find<LoginLogic>().state;
    final displayName = loginState.displayName.isEmpty ? 'ທ່ານ' : loginState.displayName;
    final profileUrl = loginState.profileImageUrl ?? '';
    final keyboardH = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── drag handle ──────────────────────────────────────
          Padding(
            padding: EdgeInsets.only(top: 12.h, bottom: 6.h),
            child: Center(child: _DragHandle()),
          ),

          // ── title bar ────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 0, 8.w, 12.h),
            child: Row(
              children: [
                Text(
                  'ສ້າງໂພສ',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.4,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 32.r,
                    height: 32.r,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.06),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: 16.r,
                      color: AppColors.textHint,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, thickness: 1,
              color: Colors.black.withValues(alpha: 0.06)),

          // ── scrollable body ──────────────────────────────────
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── author card ────────────────────────────
                  Row(
                    children: [
                      ClipOval(
                        child: profileUrl.isNotEmpty
                            ? Image.network(
                                profileUrl,
                                width: 44.r,
                                height: 44.r,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    _AvatarPlaceholder(size: 44.r),
                              )
                            : _AvatarPlaceholder(size: 44.r),
                      ),
                      SizedBox(width: 11.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.w, vertical: 3.h),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.07),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.public_rounded,
                                      size: 9.r, color: AppColors.primary),
                                  SizedBox(width: 3.w),
                                  Text(
                                    'ໂພສສາທາລະນະ',
                                    style: TextStyle(
                                      fontSize: 9.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // ── content textarea ───────────────────────
                  Container(
                    padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 10.h),
                    decoration: BoxDecoration(
                      color: AppColors.flexBg,
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: Colors.black.withValues(alpha: 0.07),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _contentCtrl,
                          focusNode: _contentFocus,
                          maxLines: null,
                          minLines: 4,
                          maxLength: 500,
                          decoration: InputDecoration(
                            hintText: _isModel
                                ? 'ແຊຣ໌ຄວາມຮູ້ສຶກ ຫຼື ອັບເດດ... #hashtag'
                                : 'ຊອກຫາ Companion ຢ່າງໃດ? ລົມລາຍລະອຽດ... #hashtag',
                            hintStyle: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textHint,
                              height: 1.5,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            counterText: '',
                          ),
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.textPrimary,
                            height: 1.55,
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${_contentCtrl.text.trim().length}/500',
                            style: TextStyle(
                              fontSize: 9.sp,
                              color: AppColors.textHint,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),

                  if (_isModel) ...[
                    // ── image picker (model only) ──────────────
                    _image == null
                        ? GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              width: double.infinity,
                              height: 155.h,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.04),
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: AppColors.primary.withValues(alpha: 0.22),
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 50.r,
                                    height: 50.r,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary
                                          .withValues(alpha: 0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.add_photo_alternate_outlined,
                                      size: 24.r,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Text(
                                    'ເພີ່ມຮູບພາບ',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                  Text(
                                    'ກ້ອງຖ່າຍ ຫຼື ຄັງຮູບ · ທາງເລືອກ',
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      color: AppColors.textHint,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16.r),
                                child: Image.file(
                                  _image!,
                                  width: double.infinity,
                                  height: 205.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // gradient scrim for bottom buttons
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(16.r),
                                  ),
                                  child: Container(
                                    height: 64.h,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Colors.black.withValues(alpha: 0.55),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // remove (top-right)
                              Positioned(
                                top: 8.h,
                                right: 8.w,
                                child: GestureDetector(
                                  onTap: () => setState(() => _image = null),
                                  child: Container(
                                    width: 28.r,
                                    height: 28.r,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(alpha: 0.55),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.close_rounded,
                                        size: 14.r, color: Colors.white),
                                  ),
                                ),
                              ),
                              // replace (bottom-right)
                              Positioned(
                                bottom: 10.h,
                                right: 10.w,
                                child: GestureDetector(
                                  onTap: _pickImage,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 5.h),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.white.withValues(alpha: 0.15),
                                      borderRadius:
                                          BorderRadius.circular(20.r),
                                      border: Border.all(
                                        color: Colors.white
                                            .withValues(alpha: 0.4),
                                        width: 0.8,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.refresh_rounded,
                                            size: 11.r, color: Colors.white),
                                        SizedBox(width: 4.w),
                                        Text(
                                          'ປ່ຽນຮູບ',
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                    SizedBox(height: 8.h),
                  ] else ...[
                    // ── gender (customer) ──────────────────────
                    _SheetSectionLabel('ເພດທີ່ຊອກຫາ'),
                    SizedBox(height: 10.h),
                    _GenderSelector(
                      selected: _targetGender,
                      onChanged: (v) => setState(() => _targetGender = v),
                    ),
                    SizedBox(height: 16.h),

                    // ── service (customer) ────────────────────
                    _SheetSectionLabel('ປະເພດບໍລິການ'),
                    SizedBox(height: 10.h),
                    _ServicePicker(
                      services: _services,
                      selected: _selectedService,
                      isLoading: _loadingServices,
                      onChanged: (svc) =>
                          setState(() => _selectedService = svc),
                    ),
                    SizedBox(height: 16.h),

                    // ── location (customer) ────────────────────
                    _SheetSectionLabel('ສະຖານທີ'),
                    SizedBox(height: 8.h),
                    AppTextField(
                      controller: _locationCtrl,
                      focusNode: _locationFocus,
                      hint: 'ຕ.ຢ.: ວຽງຈັນ, ດາວໂອຍຈາລ',
                      accent: AppColors.primary,
                      prefixIcon: Icons.location_on_outlined,
                      action: TextInputAction.done,
                    ),
                    SizedBox(height: 16.h),

                    // ── hasTip toggle (customer) ───────────────
                    GestureDetector(
                      onTap: () => setState(() => _hasTip = !_hasTip),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(
                            horizontal: 14.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          color: _hasTip
                              ? const Color(0xFFFFF7ED)
                              : AppColors.surfaceSecondary,
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(
                            color: _hasTip
                                ? const Color(0xFFF59E0B).withValues(alpha: 0.35)
                                : Colors.black.withValues(alpha: 0.07),
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36.r,
                              height: 36.r,
                              decoration: BoxDecoration(
                                color: _hasTip
                                    ? const Color(0xFFFFF0D6)
                                    : Colors.black.withValues(alpha: 0.04),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.volunteer_activism_outlined,
                                size: 17.r,
                                color: _hasTip
                                    ? const Color(0xFFD97706)
                                    : AppColors.textHint,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ຂ້ອຍຈະໃຫ້ທິບ',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w700,
                                      color: _hasTip
                                          ? const Color(0xFFD97706)
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    'ເພື່ອໃຫ້ຮູ້ວ່າຈະໃຫ້ທິບ, ຈຶ່ງມີຄົນສົນໃຈຫຼາຍຂຶ້ນ',
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      color: AppColors.textHint,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 4.w),
                            IgnorePointer(
                              child: CupertinoSwitch(
                                value: _hasTip,
                                onChanged: (_) {},
                                activeTrackColor: const Color(0xFFD97706),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                  ],
                ],
              ),
            ),
          ),

          // ── fixed bottom bar ─────────────────────────────────
          Container(
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, keyboardH + 24.h),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.black.withValues(alpha: 0.06),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: AppOutlineButton(
                    label: 'ຍົກເລີກ',
                    height: 44,
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: AppPrimaryButton(
                    label: 'ໂພສ ແລ້ວ ແຈ້ງໂຕອນ',
                    leadingIcon: Icons.send_rounded,
                    height: 44,
                    enabled: _canPost,
                    onTap: _submit,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Small shared widgets
// ═══════════════════════════════════════════════════════════════

class _AvatarPlaceholder extends StatelessWidget {
  final double size;
  const _AvatarPlaceholder({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.surfaceSecondary,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.person_rounded, size: size * 0.55, color: AppColors.textHint),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _ServicePicker  (horizontal scrollable chips, optional)
// ═══════════════════════════════════════════════════════════════
class _ServicePicker extends StatelessWidget {
  final List<ServiceModel> services;
  final ServiceModel? selected;
  final bool isLoading;
  final ValueChanged<ServiceModel?> onChanged;

  const _ServicePicker({
    required this.services,
    required this.selected,
    required this.isLoading,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: 36.h,
        child: Center(
          child: SizedBox(
            width: 18.r,
            height: 18.r,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          ),
        ),
      );
    }

    if (services.isEmpty) return const SizedBox.shrink();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: services.map((svc) {
          final isActive = selected?.id == svc.id;
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: GestureDetector(
              onTap: () => onChanged(isActive ? null : svc),
              child: AnimatedContainer(
                alignment: Alignment.center,
                duration: const Duration(milliseconds: 180),
                height: 40.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  gradient: isActive
                      ? const LinearGradient(
                          colors: [AppColors.primary, Color(0xFFFF6B85)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isActive
                      ? null
                      : Colors.black.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.28),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  svc.name,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight:
                        isActive ? FontWeight.w700 : FontWeight.w500,
                    color:
                        isActive ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Gender selector ────────────────────────────────────────────
class _GenderSelector extends StatelessWidget {
  final String? selected;
  final ValueChanged<String?> onChanged;
  const _GenderSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _GenderOption(
          label: 'ທຸກເພດ',
          value: null,
          selected: selected,
          onTap: () => onChanged(null),
        ),
        SizedBox(width: 8.w),
        _GenderOption(
          label: 'ຊາຍ',
          value: 'male',
          selected: selected,
          onTap: () => onChanged('male'),
        ),
        SizedBox(width: 8.w),
        _GenderOption(
          label: 'ຍິງ',
          value: 'female',
          selected: selected,
          onTap: () => onChanged('female'),
        ),
      ],
    );
  }
}

class _GenderOption extends StatelessWidget {
  final String label;
  final String? value;
  final String? selected;
  final VoidCallback onTap;

  const _GenderOption({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = selected == value;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 40.h,
          decoration: BoxDecoration(
            gradient: isActive
                ? const LinearGradient(
                    colors: [AppColors.primary, Color(0xFFFF6B85)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isActive ? null : Colors.black.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.30),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
                color: isActive ? Colors.white : AppColors.textSecondary,
              ),
              child: Text(label),
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetSectionLabel extends StatelessWidget {
  final String text;
  const _SheetSectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3.w,
          height: 13.h,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, Color(0xFFFF6B85)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }
}

class _DragHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36.w,
      height: 4.h,
      decoration: BoxDecoration(
        color: _inactiveGrey,
        borderRadius: BorderRadius.circular(2.r),
      ),
    );
  }
}

class _SheetItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isRed;
  final VoidCallback onTap;

  const _SheetItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isRed = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isRed ? _dangerColor : AppColors.textPrimary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        child: Row(
          children: [
            Icon(icon, size: 18.r, color: color),
            SizedBox(width: 14.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
