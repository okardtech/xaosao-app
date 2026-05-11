import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/pages/posts/components/post_card.dart';
import 'package:xaosao/pages/posts/components/post_model.dart';

import '../../widgets/gift_sheet.dart';
import '../companion_profile/companion_profile_page.dart';
import '../companion_profile/components/profile_model.dart';
import '../topup/topup_amount.dart';

// ═══════════════════════════════════════════════════════════════
//  PostsPage — ໂພສ
//  Tab 0: ທັງໝົດ   → PostCard
//  Tab 1: ຂອງຂ້ອຍ  → MyPostCard
// ═══════════════════════════════════════════════════════════════
class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabCtrl;

  // Local mutable list (like toggle)
  late final List<PostModel> _allPosts;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _tabCtrl.addListener(() => setState(() {}));
    _allPosts = List.of(mockAllPosts);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  // ── Like toggle ────────────────────────────────────────────
  void _toggleLike(int index) {
    setState(() {
      final p = _allPosts[index];
      _allPosts[index] = p.copyWith(
        isLikedByMe: !p.isLikedByMe,
        likeCount: p.isLikedByMe ? p.likeCount - 1 : p.likeCount + 1,
      );
    });
  }

  // ═════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSegment(),
            Expanded(
              child: TabBarView(
                controller: _tabCtrl,
                physics: const NeverScrollableScrollPhysics(),
                children: [_buildAllPostsTab(), _buildMyPostsTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'ໂພສ',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF1A1A2E),
                letterSpacing: -0.5,
              ),
            ),
          ),
          // Show "ສ້າງໂພສ" only on "ທັງໝົດ" tab
          if (_tabCtrl.index == 0) _buildWriteBtn(),
        ],
      ),
    );
  }

  Widget _buildWriteBtn() {
    return GestureDetector(
      onTap: _showCreatePostSheet,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_rounded, size: 13.r, color: Colors.white),
            SizedBox(width: 5.w),
            Text(
              'ສ້າງໂພສ',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Segment control ────────────────────────────────────────
  Widget _buildSegment() {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.w, 14.h, 18.w, 14.h),
      child: Container(
        padding: EdgeInsets.all(3.r),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.055),
          borderRadius: BorderRadius.circular(13.r),
        ),
        child: Row(
          children: [
            _SegBtn(
              label: 'ທັງໝົດ',
              isActive: _tabCtrl.index == 0,
              onTap: () => _tabCtrl.animateTo(0),
            ),
            _SegBtn(
              label: 'ຂອງຂ້ອຍ',
              isActive: _tabCtrl.index == 1,
              onTap: () => _tabCtrl.animateTo(1),
            ),
          ],
        ),
      ),
    );
  }

  // ── Tab 0: ທັງໝົດ ──────────────────────────────────────────
  Widget _buildAllPostsTab() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(18.w, 0, 18.w, 80.h),
      itemCount: _allPosts.length,
      itemBuilder: (_, i) => Padding(
        padding: EdgeInsets.only(bottom: 14.h),
        child: PostCard(
          post: _allPosts[i],
          onLike: () => _toggleLike(i),
          onGift: () {
            GiftSheet.show(
              context,
              companionName: 'ນາລີ',
              balanceKip: 125000,
              onSent: (gift) {
                GiftSentSnackbar.show(context, gift: gift);
              },
              onTopUp: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TopUpAmountPage()),
                );
              },
            );
          },
          onComment: () {},
          onBook: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CompanionProfilePage(profile: mockKaiProfile),
              ),
            );
          },
          onMore: () => _showMoreSheet(isMyPost: false),
          onTap: () {},
        ),
      ),
    );
  }

  // ── Tab 1: ຂອງຂ້ອຍ ────────────────────────────────────────
  Widget _buildMyPostsTab() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(18.w, 0, 18.w, 80.h),
      itemCount: mockMyPosts.length,
      itemBuilder: (_, i) => Padding(
        padding: EdgeInsets.only(bottom: 14.h),
        child: MyPostCard(
          post: mockMyPosts[i],
          onDelete: () => _confirmDelete(i),
          onHide: () {},
          onTap: () {},
        ),
      ),
    );
  }

  // ── Create post bottom sheet ────────────────────────────────
  void _showCreatePostSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: _CreatePostSheet(
          onPost: (text) {
            Navigator.pop(context);
            // TODO: add to list / API call
          },
        ),
      ),
    );
  }

  // ── More sheet (report / share) ────────────────────────────
  void _showMoreSheet({required bool isMyPost}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 20.h),
              _SheetItem(
                icon: Icons.share_outlined,
                label: 'ແຊຣ໌ໂພສ',
                onTap: () => Navigator.pop(context),
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
      ),
    );
  }

  // ── Confirm delete dialog ───────────────────────────────────
  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          'ລຶບໂພສ',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800),
        ),
        content: Text(
          'ທ່ານແນ່ໃຈທີ່ຈະລຶບໂພສນີ້ບໍ?',
          style: TextStyle(fontSize: 13.sp, color: const Color(0xFF9B9BAD)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'ຍົກເລີກ',
              style: TextStyle(fontSize: 13.sp, color: const Color(0xFF9B9BAD)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: delete API call
            },
            child: Text(
              'ລຶບ',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFFDC2626),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _ScrollWithPeek
// ═══════════════════════════════════════════════════════════════
class _ScrollWithPeek extends StatelessWidget {
  final Widget child;
  const _ScrollWithPeek({required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: IgnorePointer(
            child: Container(
              height: 72.h,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0xFFF8F8FC), Colors.transparent],
                  stops: [0.35, 1.0],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _SegBtn
// ═══════════════════════════════════════════════════════════════
class _SegBtn extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _SegBtn({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 9.h),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: isActive
                  ? const Color(0xFF1A1A2E)
                  : const Color(0xFF9B9BAD),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _CreatePostSheet
// ═══════════════════════════════════════════════════════════════
class _CreatePostSheet extends StatefulWidget {
  final ValueChanged<String> onPost;
  const _CreatePostSheet({required this.onPost});

  @override
  State<_CreatePostSheet> createState() => _CreatePostSheetState();
}

class _CreatePostSheetState extends State<_CreatePostSheet> {
  final _ctrl = TextEditingController();
  bool get _canPost => _ctrl.text.trim().isNotEmpty;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 18.h),
          Text(
            'ສ້າງໂພສໃໝ່',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1A1A2E),
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8FC),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: Colors.black.withOpacity(0.08),
                width: 0.5,
              ),
            ),
            padding: EdgeInsets.all(14.r),
            child: TextField(
              controller: _ctrl,
              maxLines: 4,
              minLines: 3,
              onChanged: (_) => setState(() {}),
              style: TextStyle(fontSize: 13.sp, color: const Color(0xFF1A1A2E)),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'ຂຽນໂພສຂອງທ່ານ... #hashtag',
                hintStyle: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFFC4C4D0),
                ),
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              // Image attach btn
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: 40.h,
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F8FC),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: Colors.black.withOpacity(0.08),
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.image_outlined,
                        size: 15.r,
                        color: const Color(0xFF9B9BAD),
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        'ຮູບ',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF9B9BAD),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              // Post button
              GestureDetector(
                onTap: _canPost ? () => widget.onPost(_ctrl.text.trim()) : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  height: 40.h,
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  decoration: BoxDecoration(
                    color: _canPost
                        ? const Color(0xFF1A1A2E)
                        : const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: Text(
                      'ໂພສ',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w800,
                        color: _canPost
                            ? Colors.white
                            : const Color(0xFF9B9BAD),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _SheetItem / _SheetDivider
// ═══════════════════════════════════════════════════════════════
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
    final color = isRed ? const Color(0xFFDC2626) : const Color(0xFF1A1A2E);
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
