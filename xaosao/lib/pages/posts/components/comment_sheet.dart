import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/models/comment_model.dart';
import 'package:xaosao/pages/login/getx/login_logic.dart';
import 'package:xaosao/pages/posts/getx/comment_logic.dart';
import 'package:xaosao/pages/posts/getx/comment_state.dart';
import 'package:xaosao/widgets/app_network_image.dart';

// ─── Local constants ─────────────────────────────────────────────
const _divider = Color(0x0D000000);
const _shimmerBase = Color(0xFFEEEEEE);
const _shimmerHigh = Color(0xFFF8F8FC);
const _replyLine = Color(0xFFE0E0E0);

// ─── Time helper ─────────────────────────────────────────────────
String _ago(DateTime? dt) {
  if (dt == null) return '';
  final d = DateTime.now().difference(dt);
  if (d.inSeconds < 60) return 'ໃໝ່ໆ';
  if (d.inMinutes < 60) return '${d.inMinutes}ນາທີ';
  if (d.inHours < 24) return '${d.inHours}ຊົ່ວໂມງ';
  if (d.inDays < 7) return '${d.inDays}ວັນ';
  return '${(d.inDays / 7).floor()}ອາທິດ';
}

// ═══════════════════════════════════════════════════════════════
//  CommentSheet — static entry point
// ═══════════════════════════════════════════════════════════════
class CommentSheet {
  CommentSheet._();

  static Future<void> show(
    BuildContext context, {
    required String postId,
    int commentCount = 0,
    VoidCallback? onCommentAdded,
  }) {
    final tag = 'comment_$postId';

    // Create and register the logic before opening the sheet
    final logic = Get.put(
      CommentLogic(postId, initialCommentCount: commentCount),
      tag: tag,
    );

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) =>
          _CommentSheetBody(logic: logic, onCommentAdded: onCommentAdded),
    ).whenComplete(() {
      // Clean up controller when the sheet is closed
      if (Get.isRegistered<CommentLogic>(tag: tag)) {
        Get.delete<CommentLogic>(tag: tag);
      }
    });
  }
}

// ═══════════════════════════════════════════════════════════════
//  _CommentSheetBody
//  StatefulWidget only for UI controllers (TextEditingController,
//  FocusNode, ScrollController). All data state lives in CommentLogic.
// ═══════════════════════════════════════════════════════════════
class _CommentSheetBody extends StatefulWidget {
  final CommentLogic logic;
  final VoidCallback? onCommentAdded;

  const _CommentSheetBody({required this.logic, this.onCommentAdded});

  @override
  State<_CommentSheetBody> createState() => _CommentSheetBodyState();
}

class _CommentSheetBodyState extends State<_CommentSheetBody> {
  final _inputCtrl = TextEditingController();
  final _inputFocus = FocusNode();
  final _scrollCtrl = ScrollController();

  // Worker that watches replyToCommentId to auto-focus the input
  late final Worker _replyWorker;

  CommentLogic get _logic => widget.logic;

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);

    // Auto-focus input whenever a reply target is set
    _replyWorker = ever<String?>(_logic.replyToCommentId, (id) {
      if (id != null && mounted) {
        Future.delayed(const Duration(milliseconds: 80), () {
          if (mounted) _inputFocus.requestFocus();
        });
      }
    });
  }

  @override
  void dispose() {
    _replyWorker.dispose();
    _inputCtrl.dispose();
    _inputFocus.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  // ─── Pagination trigger ───────────────────────────────────
  void _onScroll() {
    final pos = _scrollCtrl.position;
    if (pos.pixels >= pos.maxScrollExtent - 120) {
      _logic.loadMoreComments();
    }
  }

  // ─── Submit ───────────────────────────────────────────────
  void _submit() {
    final text = _inputCtrl.text.trim();
    if (text.isEmpty) return;
    _inputCtrl.clear();
    _inputFocus.unfocus();
    _logic.submit(text, onCommentAdded: widget.onCommentAdded);
  }

  // ═══════════════════════════════════════════════════════════
  //  Build — no setState anywhere
  // ═══════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    // MediaQuery triggers normal InheritedWidget rebuild (not setState)
    final kbH = MediaQuery.of(context).viewInsets.bottom;
    final screenH = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(bottom: kbH),
      child: Container(
        height: screenH * 0.88,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          children: [
            _buildDragHandle(),
            _buildHeader(),
            Divider(height: 1, thickness: 1, color: _divider),
            Expanded(child: _buildBody()),
            // Reply banner — only visible when replying
            Obx(() {
              if (_logic.replyToCommentId.value == null) {
                return const SizedBox.shrink();
              }
              return const SizedBox.shrink();
            }),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  // ── Drag handle ───────────────────────────────────────────
  Widget _buildDragHandle() => Padding(
    padding: EdgeInsets.only(top: 10.h, bottom: 4.h),
    child: Center(
      child: Container(
        width: 36.w,
        height: 4.h,
        decoration: BoxDecoration(
          color: const Color(0xFFE0E0E0),
          borderRadius: BorderRadius.circular(2.r),
        ),
      ),
    ),
  );

  // ── Header ────────────────────────────────────────────────
  Widget _buildHeader() => Obx(() {
    final count = _logic.commentCount.value;
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 6.h, 12.w, 12.h),
      child: Row(
        children: [
          Text(
            'ຄໍາເຫັນ',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          if (count > 0) ...[
            SizedBox(width: 8.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 30.r,
              height: 30.r,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.06),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close_rounded,
                size: 15.r,
                color: AppColors.textHint,
              ),
            ),
          ),
        ],
      ),
    );
  });

  // ── Body ──────────────────────────────────────────────────
  Widget _buildBody() => Obx(() {
    final s = _logic.state;

    if (s.status == CommentStatus.loading) return _CommentShimmer();
    if (s.status == CommentStatus.success && s.comments.isEmpty) {
      return _buildEmpty();
    }

    // Read reactive maps/sets here (inside Obx) so Obx subscribes to their
    // changes. Pass them explicitly to itemBuilder — ListView.builder's
    // itemBuilder callback runs outside the Obx tracking frame.
    final repliesMap = Map<String, List<CommentModel>>.from(_logic.repliesMap);
    final expandedIds = Set<String>.from(_logic.expandedIds);
    final loadingRepliesIds = Set<String>.from(_logic.loadingRepliesIds);

    return ListView.builder(
      controller: _scrollCtrl,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(0, 6.h, 0, 12.h),
      itemCount: s.comments.length + 1,
      itemBuilder: (_, i) {
        if (i < s.comments.length) {
          return _buildCommentItem(
            s.comments[i],
            repliesMap: repliesMap,
            expandedIds: expandedIds,
            loadingRepliesIds: loadingRepliesIds,
          );
        }
        return _buildListFooter(s);
      },
    );
  });

  // ── List footer ───────────────────────────────────────────
  Widget _buildListFooter(CommentState s) {
    if (s.status == CommentStatus.loadingMore) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Center(
          child: SizedBox(
            width: 20.r,
            height: 20.r,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  // ── Empty state ───────────────────────────────────────────
  Widget _buildEmpty() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 64.r,
          height: 64.r,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.07),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.chat_bubble_outline_rounded,
            size: 28.r,
            color: AppColors.primary.withValues(alpha: 0.5),
          ),
        ),
        SizedBox(height: 14.h),
        Text(
          'ຍັງບໍ່ມີຄໍາເຫັນ',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'ເປັນຄົນທໍາອິດທີ່ຄອມເມັນ!',
          style: TextStyle(fontSize: 12.sp, color: AppColors.textHint),
        ),
      ],
    ),
  );

  // ── Comment item ──────────────────────────────────────────
  Widget _buildCommentItem(
    CommentModel comment, {
    required Map<String, List<CommentModel>> repliesMap,
    required Set<String> expandedIds,
    required Set<String> loadingRepliesIds,
  }) {
    final isExpanded = expandedIds.contains(comment.id);
    final replies = repliesMap[comment.id] ?? [];
    final isLoadingReplies = loadingRepliesIds.contains(comment.id);
    final hasReplies = comment.replyCount > 0 || replies.isNotEmpty;
    final authorName = comment.author?.displayName ?? 'ຜູ້ໃຊ້';

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 14.h),
          // ── Author + content ────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CommentAvatar(url: comment.author?.profile, size: 36.r),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name + time
                    Row(
                      children: [
                        Text(
                          authorName,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            _ago(comment.createdAt),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    // Content
                    Text(
                      comment.content ?? '',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textPrimary,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // Action row: ຕອບ · ເບິ່ງ X ຄໍາຕອບ
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () =>
                              _logic.setReplyTo(comment.id, authorName),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.reply_rounded,
                                size: 14.r,
                                color: AppColors.textHint,
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                'ຕອບກັບ',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textHint,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (hasReplies) ...[
                          SizedBox(width: 16.w),
                          GestureDetector(
                            onTap: () => _logic.toggleReplies(comment.id),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isLoadingReplies)
                                  SizedBox(
                                    width: 10.r,
                                    height: 10.r,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1.5,
                                      color: AppColors.primary,
                                    ),
                                  )
                                else
                                  Icon(
                                    isExpanded
                                        ? Icons.keyboard_arrow_up_rounded
                                        : Icons.keyboard_arrow_down_rounded,
                                    size: 14.r,
                                    color: AppColors.primary,
                                  ),
                                SizedBox(width: 3.w),
                                Text(
                                  isExpanded
                                      ? 'ຫຍໍ້ຄໍາຕອບ'
                                      : 'ເບິ່ງ ${comment.replyCount > 0 ? comment.replyCount : replies.length} ຄໍາຕອບ',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          // ── Replies (expanded) ────────────────────────────
          if (isExpanded && replies.isNotEmpty) ...[
            SizedBox(height: 10.h),
            ...replies.map((r) => _buildReplyItem(r, comment.id)),
          ],
          // SizedBox(height: 4.h),
          // Divider(height: 1, thickness: 0.5, color: _divider),
        ],
      ),
    );
  }

  // ── Reply item ────────────────────────────────────────────
  Widget _buildReplyItem(CommentModel reply, String parentCommentId) {
    final authorName = reply.author?.displayName ?? 'ຜູ້ໃຊ້';
    return Padding(
      padding: EdgeInsets.only(left: 46.w, bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vertical connector line
          Padding(
            padding: EdgeInsets.only(top: 4.h, right: 10.w),
            child: Container(
              width: 1.5,
              height: 36.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_replyLine, _replyLine.withValues(alpha: 0.2)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          _CommentAvatar(url: reply.author?.profile, size: 28.r),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      authorName,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        _ago(reply.createdAt),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                Text(
                  reply.content ?? '',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textPrimary,
                    height: 1.45,
                  ),
                ),
                SizedBox(height: 5.h),
                // Reply to the parent comment (not to the reply itself — API forbids nesting)
                GestureDetector(
                  onTap: () => _logic.setReplyTo(parentCommentId, authorName),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.reply_rounded,
                        size: 13.r,
                        color: AppColors.textHint,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'ຕອບກັບ',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textHint,
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
    );
  }

  // ── Input bar ─────────────────────────────────────────────
  Widget _buildInputBar() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: _divider, width: 0.8)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Current user avatar (stable, no Obx needed)
            _CurrentUserAvatar(),
            SizedBox(width: 10.w),
            // Input field
            Expanded(
              child: Obx(() {
                final hint = _logic.replyToCommentId.value != null
                    ? 'ຕອບ ${_logic.replyToName.value ?? ''}...'
                    : 'ຂຽນຄໍາເຫັນ...';
                return Container(
                  constraints: BoxConstraints(maxHeight: 60.h),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSecondary,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: Colors.black.withValues(alpha: 0.08),
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: _inputCtrl,
                    focusNode: _inputFocus,

                    maxLines: null,
                    minLines: 1,
                    maxLength: 500,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _submit(),
                    decoration: InputDecoration(
                      constraints: BoxConstraints(maxHeight: 44.h),
                      hintText: hint,
                      hintStyle: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textHint,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.fromLTRB(14.w, 9.h, 8.w, 9.h),
                      counterText: '',
                    ),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                );
              }),
            ),
            SizedBox(width: 8.w),
            // Send button
            Obx(() {
              final busy = _logic.isSubmitting.value;
              return GestureDetector(
                onTap: busy ? null : _submit,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 38.r,
                  height: 38.r,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: busy
                          ? [
                              AppColors.primary.withValues(alpha: 0.4),
                              const Color(0xFFFF6B85).withValues(alpha: 0.4),
                            ]
                          : [AppColors.primary, const Color(0xFFFF6B85)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: busy
                        ? []
                        : [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                  ),
                  child: busy
                      ? Padding(
                          padding: EdgeInsets.all(10.r),
                          child: CircularProgressIndicator(
                            strokeWidth: 1.8,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        )
                      : Icon(
                          Icons.send_rounded,
                          size: 16.r,
                          color: Colors.white,
                        ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _CurrentUserAvatar — reads LoginLogic once (stable data)
// ═══════════════════════════════════════════════════════════════
class _CurrentUserAvatar extends StatelessWidget {
  const _CurrentUserAvatar();

  @override
  Widget build(BuildContext context) {
    final profileUrl = Get.find<LoginLogic>().state.profileImageUrl ?? '';

    return ClipOval(
      child: AppNetworkImage(
        imageUrl: profileUrl,
        width: 34.r,
        height: 34.r,
        fit: BoxFit.cover,
        accentColor: AppColors.primary,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _CommentAvatar
// ═══════════════════════════════════════════════════════════════
class _CommentAvatar extends StatelessWidget {
  final String? url;
  final double size;

  const _CommentAvatar({required this.size, this.url});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: url != null && url!.isNotEmpty
          ? AppNetworkImage(
              imageUrl: url!,
              width: size,
              height: size,
              fit: BoxFit.cover,
              accentColor: AppColors.primary,
            )
          : Container(
              width: size,
              height: size,
              color: AppColors.surfaceSecondary,
              child: Icon(
                Icons.person_rounded,
                size: size * 0.55,
                color: AppColors.textDisabled,
              ),
            ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _CommentShimmer
// ═══════════════════════════════════════════════════════════════
class _CommentShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0),
      itemCount: 6,
      itemBuilder: (_, i) => _ShimmerItem(showReply: i == 1),
    );
  }
}

class _ShimmerItem extends StatelessWidget {
  final bool showReply;
  const _ShimmerItem({this.showReply = false});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _shimmerBase,
      highlightColor: _shimmerHigh,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 14.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36.r,
                height: 36.r,
                decoration: const BoxDecoration(
                  color: _shimmerBase,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 11.h, width: 100.w, color: _shimmerBase),
                    SizedBox(height: 6.h),
                    Container(
                      height: 11.h,
                      width: double.infinity,
                      color: _shimmerBase,
                    ),
                    SizedBox(height: 4.h),
                    Container(height: 11.h, width: 180.w, color: _shimmerBase),
                    SizedBox(height: 8.h),
                    Container(height: 9.h, width: 50.w, color: _shimmerBase),
                  ],
                ),
              ),
            ],
          ),
          if (showReply) ...[
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.only(left: 46.w),
              child: Row(
                children: [
                  Container(
                    width: 28.r,
                    height: 28.r,
                    decoration: const BoxDecoration(
                      color: _shimmerBase,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(height: 9.h, width: 140.w, color: _shimmerBase),
                ],
              ),
            ),
          ],
          SizedBox(height: 10.h),
          Divider(height: 1, thickness: 0.5, color: _divider),
        ],
      ),
    );
  }
}
