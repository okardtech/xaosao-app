import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/l10n/app_localizations.dart';
import 'package:xaosao/models/customer_public_profile.dart';
import 'package:xaosao/repository/review_repo.dart';
import 'package:xaosao/services/storage_service.dart';
import 'package:xaosao/utils/deep_link_share.dart';
import 'package:xaosao/widgets/app_image_preview.dart';
import 'package:xaosao/widgets/app_like_button.dart';
import 'package:xaosao/widgets/app_network_image.dart';
import '../../constants/app_icons.dart';
import '../../widgets/app_svg_icon.dart';
import 'getx/customer_detail_logic.dart';
import 'getx/customer_detail_state.dart';

class ModelDetailPage extends StatefulWidget {
  final String customerId;
  const ModelDetailPage({super.key, required this.customerId});

  @override
  State<ModelDetailPage> createState() => _ModelDetailPageState();
}

class _ModelDetailPageState extends State<ModelDetailPage> {
  late final CustomerDetailLogic _logic;
  late final ScrollController _scrollCtrl;

  static const double _photoHeight = 420;
  static const double _titleThreshold = 280;

  @override
  void initState() {
    super.initState();
    _logic = Get.put(
      CustomerDetailLogic(customerId: widget.customerId),
      tag: widget.customerId,
    );
    _scrollCtrl = ScrollController()..addListener(_onScroll);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    _scrollCtrl
      ..removeListener(_onScroll)
      ..dispose();
    Get.delete<CustomerDetailLogic>(tag: widget.customerId);
    super.dispose();
  }

  void _onScroll() {
    final show = _scrollCtrl.offset > _titleThreshold;
    if (show != _logic.showTitle.value) _logic.showTitle.value = show;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      body: Obx(() {
        final st = _logic.state;
        if (st.status == CustomerDetailStatus.initial ||
            st.status == CustomerDetailStatus.loading) {
          return _buildLoading();
        }
        if (st.status == CustomerDetailStatus.failure || st.profile == null) {
          return _buildError(st.error);
        }
        return _buildBody(st.profile!);
      }),
    );
  }

  // ── Loading ───────────────────────────────────────────────
  Widget _buildLoading() {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.r),
            child: Align(
              alignment: Alignment.centerLeft,
              child: _AppBarIconDark(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: () => Navigator.pop(context),
              ),
            ),
          ),
          const Expanded(
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  // ── Error ─────────────────────────────────────────────────
  Widget _buildError(String? msg) {
    final l10n = AppLocalizations.of(context)!;
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.r),
            child: Align(
              alignment: Alignment.centerLeft,
              child: _AppBarIconDark(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: () => Navigator.pop(context),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 48.r,
                    color: AppColors.textHint,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    msg ?? l10n.commonLoadDataFailed,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textHint,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  TextButton(
                    onPressed: _logic.fetch,
                    child: Text(l10n.commonRetry),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Main content ──────────────────────────────────────────
  Widget _buildBody(CustomerPublicProfile profile) {
    final l10n = AppLocalizations.of(context)!;
    return CustomScrollView(
      controller: _scrollCtrl,
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          expandedHeight: _photoHeight,
          pinned: true,
          stretch: true,
          backgroundColor: AppColors.primary,
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            background: _PhotoSlider(
              photos: profile.allPhotos,
              height: _photoHeight,
              profile: profile,
            ),
          ),
          leading: _AppBarIcon(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Navigator.pop(context),
          ),
          title: Obx(
            () => AnimatedOpacity(
              opacity: _logic.showTitle.value ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Text(
                profile.age > 0
                    ? '${profile.displayName}, ${profile.age}'
                    : profile.displayName,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          actions: [
            AppLikeButton(
              initialLiked: false,
              size: 34,
              iconSize: 16,
              unlikedBg: Colors.black.withValues(alpha: 0.25),
              border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
              margin: EdgeInsets.symmetric(vertical: 8.h),
              onToggle: () async {
                final isClient =
                    Get.find<StorageService>().read<String>('role') ==
                    'customer';
                final res = await ReviewRepo().addLike(
                  isClient: isClient,
                  id: profile.id,
                );
                return res.success;
              },
            ),
            SizedBox(width: 6.w),
            _AppBarIcon(
              icon: Icons.share_outlined,
              onTap: () => DeepLinkShare.shareModel(
                modelId: profile.id,
                displayName: profile.displayName,
              ),
            ),
            SizedBox(width: 12.w),
          ],
        ),

        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildActionRow(profile),
              _Section(
                title: l10n.detailPersonalInfo,
                child: _buildInfoGrid(profile),
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ],
    );
  }

  // ── Action row: chat + friend ─────────────────────────────
  Widget _buildActionRow(CustomerPublicProfile profile) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
      child: Row(
        children: [
          // Chat button
          Expanded(
            child: Obx(() {
              final loading = _logic.chatLoading.value;
              return GestureDetector(
                onTap: loading ? null : () => _logic.startChat(profile),
                child: Container(
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(13.r),
                    border: Border.all(
                      color: Colors.black.withValues(alpha: 0.08),
                      width: 0.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.10),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: loading
                      ? Center(
                          child: SizedBox(
                            width: 16.r,
                            height: 16.r,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppSvgIcon(
                              assetName: AppIcons.chatFill,
                              width: 12.w,
                              height: 12.h,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              l10n.bookingActionChat,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                ),
              );
            }),
          ),
          SizedBox(width: 8.w),
          // Friend toggle button
          Obx(() {
            final loading = _logic.friendLoading.value;
            final isFriend = _logic.isFriend.value;
            return GestureDetector(
              onTap: loading ? null : _logic.toggleFriend,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 44.h,
                width: 44.h,
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: isFriend
                      ? AppColors.primary.withValues(alpha: 0.08)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(13.r),
                  border: Border.all(
                    color: isFriend
                        ? AppColors.primary.withValues(alpha: 0.30)
                        : Colors.black.withValues(alpha: 0.08),
                    width: isFriend ? 1.0 : 0.5,
                  ),
                ),
                child: loading
                    ? Center(
                        child: SizedBox(
                          width: 16.r,
                          height: 16.r,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary,
                          ),
                        ),
                      )
                    : AppSvgIcon(
                        assetName: isFriend
                            ? AppIcons.userCheck
                            : AppIcons.userAdd,
                        width: 18.w,
                        height: 18.h,
                        color: isFriend
                            ? AppColors.primary
                            : AppColors.textPrimary,
                      ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ── Info grid ─────────────────────────────────────────────
  Widget _buildInfoGrid(CustomerPublicProfile profile) {
    final l10n = AppLocalizations.of(context)!;
    final age = profile.age;
    final memberSince = profile.createdAt != null
        ? DateFormat('MMM yyyy').format(profile.createdAt!)
        : '—';
    final tier = profile.tier ?? '—';
    final tierColor = profile.isVip ? AppColors.vipGold : AppColors.textPrimary;
    final location = profile.country != null ? '${profile.country}' : '—';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.10),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── 3-stat strip ──────────────────────────────────
          IntrinsicHeight(
            child: Row(
              children: [
                _StatStrip(
                  label: l10n.detailStatAge,
                  value: age > 0 ? l10n.commonAgeYears(age) : '—',
                ),
                _StatStripDivider(),
                _StatStrip(
                  label: l10n.detailStatMemberSince,
                  value: memberSince,
                ),
                _StatStripDivider(),
                _StatStrip(
                  label: l10n.detailStatTier,
                  value: tier,
                  valueColor: tierColor,
                ),
              ],
            ),
          ),
          // ── Location row ──────────────────────────────────
          Divider(
            height: 1,
            thickness: 0.5,
            color: Colors.black.withValues(alpha: 0.06),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 13.r,
                  color: AppColors.textHint,
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.registerAddress,
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: AppColors.textHint,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        location,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
}

// ═══════════════════════════════════════════════════════════════
//  _PhotoSlider
// ═══════════════════════════════════════════════════════════════
class _PhotoSlider extends StatefulWidget {
  final List<String> photos;
  final double height;
  final CustomerPublicProfile profile;

  const _PhotoSlider({
    required this.photos,
    required this.height,
    required this.profile,
  });

  @override
  State<_PhotoSlider> createState() => _PhotoSliderState();
}

class _PhotoSliderState extends State<_PhotoSlider>
    with TickerProviderStateMixin {
  final _pageCtrl = PageController();
  int _current = 0;

  // One-time "tap to expand" hint
  bool _showHint = true;

  // Press-feedback scale for the tapped photo
  late final AnimationController _pressCtrl;
  late final Animation<double> _pressScale;

  // Pulse animation for the expand affordance chip
  late final AnimationController _pulseCtrl;

  int get _count => widget.photos.isEmpty ? 1 : widget.photos.length;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 180),
    );
    _pressScale = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _pressCtrl, curve: Curves.easeOut),
    );
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    Future.delayed(const Duration(milliseconds: 3200), () {
      if (mounted) setState(() => _showHint = false);
    });

    // Warm the cache for neighboring photos so swipe-then-tap is instant.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || widget.photos.isEmpty) return;
      for (final i in [1, 2]) {
        if (i >= widget.photos.length) break;
        precacheImage(NetworkImage(widget.photos[i]), context);
      }
    });
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _pressCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _openPreview(int i) {
    if (widget.photos.isEmpty) return;
    AppImagePreview.show(context, widget.photos, initialIndex: i);
    if (_showHint) setState(() => _showHint = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      height: widget.height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _pageCtrl,
            itemCount: _count,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (context, i) {
              if (widget.photos.isEmpty) return _gradientFallback();
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (_) => _pressCtrl.forward(),
                onTapCancel: () => _pressCtrl.reverse(),
                onTapUp: (_) => _pressCtrl.reverse(),
                onTap: () => _openPreview(i),
                child: ScaleTransition(
                  scale: _pressScale,
                  child: Hero(
                    tag: 'preview_${widget.photos[i]}_$i',
                    child: AppNetworkImage(
                      imageUrl: widget.photos[i],
                      fit: BoxFit.cover,
                      errorWidget: _gradientFallback(),
                    ),
                  ),
                ),
              );
            },
          ),

          // Gradient overlay — IgnorePointer so taps reach the photo.
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Container(
                height: widget.height * 0.62,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color(0xFA050512),
                      Color(0xB2050512),
                      Color(0x1A050512),
                      Colors.transparent,
                    ],
                    stops: [0.0, 0.45, 0.75, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // Page indicator dots
          if (_count > 1)
            Positioned(
              top: 14.h,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_count, (i) {
                    final isOn = i == _current;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      width: isOn ? 16.w : 5.r,
                      height: 5.r,
                      decoration: BoxDecoration(
                        color: isOn
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.40),
                        borderRadius: BorderRadius.circular(3.r),
                      ),
                    );
                  }),
                ),
              ),
            ),

          // Expand affordance — combines counter + zoom hint, with pulse.
          if (widget.photos.isNotEmpty)
            Positioned(
              bottom: 150.h,
              right: 14.w,
              child: GestureDetector(
                onTap: () => _openPreview(_current),
                child: _ExpandAffordance(
                  pulse: _pulseCtrl,
                  label: _count > 1
                      ? '${_current + 1} / $_count'
                      : l10n.detailViewPhotos,
                ),
              ),
            ),

          // One-time floating hint near the top.
          if (widget.photos.isNotEmpty)
            Positioned(
              top: 70.h,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: AnimatedSlide(
                  offset: _showHint ? Offset.zero : const Offset(0, -0.4),
                  duration: const Duration(milliseconds: 320),
                  curve: Curves.easeOutCubic,
                  child: AnimatedOpacity(
                    opacity: _showHint ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 320),
                    child: Center(child: _TapHintChip()),
                  ),
                ),
              ),
            ),

          // Name / stats overlay at bottom — IgnorePointer so taps reach the photo.
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: _InfoOverlay(profile: widget.profile),
            ),
          ),
        ],
      ),
    );
  }

  Widget _gradientFallback() => Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: AppColors.pinkGradient,
      ),
    ),
  );
}

// ── Expand affordance chip ─────────────────────────────────────
class _ExpandAffordance extends StatelessWidget {
  final Animation<double> pulse;
  final String label;
  const _ExpandAffordance({required this.pulse, required this.label});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulse,
      builder: (_, child) {
        final t = pulse.value;
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.10 + 0.18 * t),
                blurRadius: 10 + 6 * t,
                spreadRadius: 0.4 * t,
              ),
            ],
          ),
          child: child,
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.18),
            width: 0.8,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.zoom_out_map_rounded,
              size: 12.r,
              color: Colors.white.withValues(alpha: 0.95),
            ),
            SizedBox(width: 5.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── One-time "tap to zoom" hint chip ───────────────────────────
class _TapHintChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.18),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.touch_app_rounded, size: 13.r, color: Colors.white),
          SizedBox(width: 6.w),
          Text(
            l10n.detailTapPhotoToExpand,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _InfoOverlay — name, age, location, bio, stats
// ═══════════════════════════════════════════════════════════════
class _InfoOverlay extends StatelessWidget {
  final CustomerPublicProfile profile;
  const _InfoOverlay({required this.profile});

  @override
  Widget build(BuildContext context) {
    final age = profile.age;
    final distanceText = profile.distanceKm != null
        ? '${profile.distanceKm!.toStringAsFixed(1)} km'
        : profile.country ?? '—';

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (profile.isVip)
            _Badge(
              label: '★ VIP',
              bg: const Color(0xBF1A1A2E),
              fg: AppColors.vipGold,
              border: AppColors.vipGold.withValues(alpha: 0.30),
            ),
          SizedBox(height: 8.h),

          // Name + age
          Text(
            profile.displayName + (age > 0 ? ', $age' : ''),
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.5,
              height: 1.15,
            ),
          ),

          // Distance / country
          SizedBox(height: 5.h),
          Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                size: 12.r,
                color: Colors.white60,
              ),
              SizedBox(width: 3.w),
              Text(
                distanceText,
                style: TextStyle(fontSize: 11.sp, color: Colors.white60),
              ),
            ],
          ),

          // Bio
          if (profile.bio != null && profile.bio!.isNotEmpty) ...[
            SizedBox(height: 6.h),
            Text(
              profile.bio!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.white.withValues(alpha: 0.60),
              ),
            ),
          ],
          SizedBox(height: 12.h),

          _StatsStrip(profile: profile),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _Badge
// ═══════════════════════════════════════════════════════════════
class _Badge extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;
  final Color? border;
  const _Badge({
    required this.label,
    required this.bg,
    required this.fg,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20.r),
        border: border != null ? Border.all(color: border!) : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 8.sp,
          fontWeight: FontWeight.w800,
          color: fg,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _StatsStrip — 4-cell stat bar on the photo overlay
// ═══════════════════════════════════════════════════════════════
class _StatsStrip extends StatelessWidget {
  final CustomerPublicProfile profile;
  const _StatsStrip({required this.profile});

  String _fmt(int n) => n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}k' : '$n';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.10),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _StatCell(
            icon: Icons.calendar_today_rounded,
            iconColor: AppColors.vipGold,
            value: _fmt(profile.bookingCount),
            label: l10n.detailStatRating,
          ),
          _vDivider(),
          _StatCell(
            icon: Icons.grid_view_rounded,
            iconColor: Colors.white.withValues(alpha: 0.70),
            value: _fmt(profile.postCount),
            label: l10n.detailStatPosts,
          ),
          _vDivider(),
          _StatCell(
            icon: Icons.card_giftcard_rounded,
            iconColor: AppColors.primary,
            value: _fmt(profile.giftCount),
            label: l10n.detailStatGifts,
          ),
          _vDivider(),
          _StatCell(
            icon: Icons.monetization_on_rounded,
            iconColor: Colors.white.withValues(alpha: 0.70),
            value: _fmt(profile.giftAmount),
            label: l10n.detailStatCount,
          ),
        ],
      ),
    );
  }

  Widget _vDivider() => Container(
    width: 0.5,
    height: 44.h,
    color: Colors.white.withValues(alpha: 0.08),
  );
}

// ═══════════════════════════════════════════════════════════════
//  _StatCell
// ═══════════════════════════════════════════════════════════════
class _StatCell extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _StatCell({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Column(
          children: [
            Icon(icon, size: 16.r, color: iconColor),
            SizedBox(height: 3.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                height: 1,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 8.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white.withValues(alpha: 0.40),
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _Section
// ═══════════════════════════════════════════════════════════════
class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.2,
            ),
          ),
          SizedBox(height: 8.h),
          child,
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _AppBarIcon — frosted circle on photo
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
          color: Colors.black.withValues(alpha: 0.25),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        ),
        child: Icon(icon, size: 15.r, color: Colors.white),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _AppBarIconDark — white circle for loading/error screens
// ═══════════════════════════════════════════════════════════════
class _AppBarIconDark extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _AppBarIconDark({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(8.r),
        width: 34.r,
        height: 34.r,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 15.r, color: AppColors.textPrimary),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _StatStrip / _StatStripDivider — info card stat columns
// ═══════════════════════════════════════════════════════════════
class _StatStrip extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _StatStrip({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 4.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w800,
                color: valueColor ?? AppColors.textPrimary,
                height: 1,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 9.sp,
                color: AppColors.textHint,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatStripDivider extends StatelessWidget {
  const _StatStripDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.5,
      margin: EdgeInsets.symmetric(vertical: 10.h),
      color: Colors.black.withValues(alpha: 0.07),
    );
  }
}
