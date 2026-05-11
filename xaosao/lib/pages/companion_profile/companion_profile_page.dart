import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/pages/companion_profile/components/info_card.dart';
import 'package:xaosao/pages/companion_profile/components/profile_model.dart';
import 'package:xaosao/pages/companion_profile/components/profile_widget.dart';
import '../../widgets/gift_sheet.dart';
import '../home/components/companion_card.dart';
import '../topup/topup_amount.dart';

// ═══════════════════════════════════════════════════════════════
//  CompanionProfilePage
//
//  ໂຄງສ້າງ:
//    CustomScrollView
//      └─ SliverAppBar (expandedHeight: photoHeight)
//            flexibleSpace → ProfilePhotoSlider (scroll ຮ່ວມ)
//            pinned: true   → AppBar ຕິດ top ເວລາ scroll
//      └─ SliverToBoxAdapter → body sections
//
//  Sticky bottom bar (StickyBookingBar) ຢູ່ນອກ CustomScrollView
//  ເພື່ອໃຫ້ Fix ຕາຍຢູ່ລຸ່ມ
// ═══════════════════════════════════════════════════════════════
class CompanionProfilePage extends StatefulWidget {
  final CompanionProfile profile;

  const CompanionProfilePage({super.key, required this.profile});

  @override
  State<CompanionProfilePage> createState() => _CompanionProfilePageState();
}

class _CompanionProfilePageState extends State<CompanionProfilePage> {
  // Selected services
  final Set<ServiceType> _selected = {};

  // Track scroll to fade AppBar title
  late final ScrollController _scrollCtrl;
  bool _showTitle = false;

  static const double _photoHeight = 420;
  // AppBar collapses when scroll > this threshold
  static const double _titleThreshold = 280;

  @override
  void initState() {
    super.initState();
    _scrollCtrl = ScrollController();
    _scrollCtrl.addListener(_onScroll);
    _setStatusBar(transparent: true);
  }

  @override
  void dispose() {
    _scrollCtrl.removeListener(_onScroll);
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    final show = _scrollCtrl.offset > _titleThreshold;
    if (show != _showTitle) setState(() => _showTitle = show);
  }

  void _setStatusBar({required bool transparent}) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: transparent
            ? Brightness.light
            : Brightness.dark,
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      // Scaffold body = CustomScrollView + sticky booking bar
      body: Column(
        children: [
          Expanded(child: _buildScrollView()),
          // Sticky bottom: always visible
          StickyBookingBar(
            profile: widget.profile,
            enabled: _selected.isNotEmpty,
            onBook: _onBook,
          ),
        ],
      ),
    );
  }

  // ── CustomScrollView ────────────────────────────────────────
  Widget _buildScrollView() {
    return CustomScrollView(
      controller: _scrollCtrl,
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ── SliverAppBar with photo ────────────────────────────
        SliverAppBar(
          expandedHeight: _photoHeight,
          pinned: true, // AppBar pin ເວລາ scroll
          stretch: true,
          backgroundColor: AppColors.primary,
          elevation: 0,
          automaticallyImplyLeading: false,
          // ── Fixed AppBar content (always visible when pinned) ──
          flexibleSpace: FlexibleSpaceBar(
            // collapseMode: pin keeps AppBar on top
            collapseMode: CollapseMode.pin,
            // Photo slider scrolls with content until collapsed
            background: ProfilePhotoSlider(
              profile: widget.profile,
              height: _photoHeight,
            ),
          ),

          // ── Actions in AppBar ──────────────────────────────────
          leading: _AppBarIcon(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Navigator.pop(context),
          ),
          title: AnimatedOpacity(
            opacity: _showTitle ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Text(
              widget.profile.nameAge,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
          actions: [
            _LikeButton(profile: widget.profile),
            SizedBox(width: 6.w),
            _AppBarIcon(icon: Icons.share_outlined, onTap: () {}),
            SizedBox(width: 12.w),
          ],
        ),

        // ── All body sections as single SliverToBoxAdapter ──────
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Action row
              _buildActionRow(),

              // About
              _Section(title: 'ຄວາມມັກສ່ວນຕົວ', child: _buildAbout()),

              // Info grid
              _Section(
                title: 'ຂໍ້ມູນສ່ວນຕົວ',
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: InfoCard(
                            label: "ອາຍຸ",
                            value: widget.profile.age.toString(),
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: InfoCard(
                            label: "ຄວາມສູງ",
                            value: widget.profile.heightCm.toString(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Expanded(
                          child: InfoCard(
                            label: "ທີ່ຢູ່",
                            value: "ເເຂວງຫົວພັນ, ເມືອງຊຳໃຕ້",
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: InfoCard(label: "ສະຖານະ", value: "ໃຊ້ງານຢູ່"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Service selector
              _Section(title: 'ເລືອກບໍລິການ', child: _buildServices()),
              // Rating + reviews
              _Section(
                title: 'ຄະແນນ ແລະ ລີວິວ',
                child: RatingSection(profile: widget.profile),
              ),
              // Posts grid
              _Section(
                title: 'ໂພສຫາຄູ່',
                isLast: true,
                child: PostsGrid(posts: widget.profile.posts),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Action row ─────────────────────────────────────────────
  Widget _buildActionRow() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
      child: Row(
        children: [
          // Message
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                height: 42.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(13.r),
                  border: Border.all(
                    color: Colors.black.withOpacity(0.08),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 15.r,
                      color: const Color(0xFF1A1A2E),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'ສົ່ງຂໍ້ຄວາມ',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A2E),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          // Gift
          GestureDetector(
            onTap: () {
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
            child: Container(
              width: 42.r,
              height: 42.r,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13.r),
                border: Border.all(
                  color: Colors.black.withOpacity(0.08),
                  width: 0.5,
                ),
              ),
              child: Icon(
                Icons.card_giftcard_rounded,
                size: 18.r,
                color: const Color(0xFFD97706),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          // Gift
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 42.r,
              height: 42.r,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13.r),
                border: Border.all(
                  color: Colors.black.withOpacity(0.08),
                  width: 0.5,
                ),
              ),
              child: Icon(
                Icons.person_add_alt_1_rounded,
                size: 18.r,
                color: const Color(0xFF1A1A2E),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── About ──────────────────────────────────────────────────
  Widget _buildAbout() {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Text(
        widget.profile.bio,
        style: TextStyle(
          fontSize: 12.sp,
          color: const Color(0xFF6B6B80),
          height: 1.7,
        ),
      ),
    );
  }

  // ── Services ───────────────────────────────────────────────
  Widget _buildServices() {
    return Column(
      children: widget.profile.services.map((svc) {
        final isSelected = _selected.contains(svc);
        return Padding(
          padding: EdgeInsets.only(bottom: 7.h),
          child: ServiceCard(
            service: svc,
            isSelected: isSelected,
            onTap: () => setState(() {
              if (isSelected) {
                _selected.remove(svc);
              } else {
                _selected.add(svc);
              }
            }),
          ),
        );
      }).toList(),
    );
  }

  // ── Book action ─────────────────────────────────────────────
  void _onBook() {
    if (_selected.isEmpty) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('ຈອງ: ${_selected.map((s) => s.label).join(', ')}'),
        backgroundColor: const Color(0xFF1A1A2E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _Section — titled section wrapper
// ═══════════════════════════════════════════════════════════════
class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  final bool isLast;

  const _Section({
    required this.title,
    required this.child,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, isLast ? 16.h : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
              letterSpacing: -0.2,
            ),
          ),
          SizedBox(height: 6.h),
          child,
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _AppBarIcon — glass circle button in AppBar
// ═══════════════════════════════════════════════════════════════
class _AppBarIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _AppBarIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(8.r),
        width: 34.r,
        height: 34.r,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.25),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.15)),
        ),
        child: Icon(icon, size: 15.r, color: Colors.white),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _LikeButton — toggle heart in AppBar
// ═══════════════════════════════════════════════════════════════
class _LikeButton extends StatefulWidget {
  final CompanionProfile profile;
  const _LikeButton({required this.profile});

  @override
  State<_LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<_LikeButton>
    with SingleTickerProviderStateMixin {
  bool _liked = false;
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scale = Tween(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() async {
    setState(() => _liked = !_liked);
    await _ctrl.forward();
    await _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8.h),
          width: 34.r,
          height: 34.r,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.25),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: Icon(
            _liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            size: 16.r,
            color: _liked ? const Color(0xFFF06292) : Colors.white,
          ),
        ),
      ),
    );
  }
}
