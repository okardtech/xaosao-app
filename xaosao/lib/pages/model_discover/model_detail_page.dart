import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/models/Recommended_model.dart';
import 'package:xaosao/repository/review_repo.dart';
import 'package:xaosao/services/storage_service.dart';
import 'package:xaosao/widgets/app_like_button.dart';
import 'package:xaosao/widgets/app_network_image.dart';
import 'package:xaosao/widgets/gift_sheet.dart';
import '../topup/topup_amount.dart';

class ModelDetailPage extends StatefulWidget {
  final RecommendedModel model;
  const ModelDetailPage({super.key, required this.model});

  @override
  State<ModelDetailPage> createState() => _ModelDetailPageState();
}

class _ModelDetailPageState extends State<ModelDetailPage> {
  late final ScrollController _scrollCtrl;
  bool _showTitle = false;

  static const double _photoHeight = 420;
  static const double _titleThreshold = 280;

  int get _age {
    final dob = widget.model.dob;
    if (dob == null) return 0;
    final now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age;
  }

  List<String> get _photos {
    final imgs = widget.model.images ?? [];
    if (imgs.isNotEmpty) return imgs;
    if (widget.model.profile != null) return [widget.model.profile!];
    return [];
  }

  @override
  void initState() {
    super.initState();
    _scrollCtrl = ScrollController()..addListener(_onScroll);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  void dispose() {
    _scrollCtrl
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    final show = _scrollCtrl.offset > _titleThreshold;
    if (show != _showTitle) setState(() => _showTitle = show);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      body: CustomScrollView(
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
                photos: _photos,
                height: _photoHeight,
                model: widget.model,
                age: _age,
              ),
            ),
            leading: _AppBarIcon(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: () => Navigator.pop(context),
            ),
            title: AnimatedOpacity(
              opacity: _showTitle ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Text(
                '${widget.model.firstName ?? ''}, $_age',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            actions: [
              AppLikeButton(
                initialLiked: widget.model.isLiked,
                size: 34,
                iconSize: 16,
                unlikedBg: Colors.black.withValues(alpha: 0.25),
                border:
                    Border.all(color: Colors.white.withValues(alpha: 0.15)),
                margin: EdgeInsets.symmetric(vertical: 8.h),
                onToggle: () async {
                  final isClient =
                      Get.find<StorageService>().read<String>('role') ==
                          'customer';
                  final res = await ReviewRepo()
                      .addLike(isClient: isClient, id: widget.model.id ?? '');
                  return res.success;
                },
              ),
              SizedBox(width: 6.w),
              _AppBarIcon(icon: Icons.share_outlined, onTap: () {}),
              SizedBox(width: 12.w),
            ],
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildActionRow(),
                _Section(
                  title: 'ຂໍ້ມູນສ່ວນຕົວ',
                  child: _buildInfoGrid(),
                ),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoGrid() {
    final age = _age;
    final memberSince = widget.model.createdAt != null
        ? DateFormat('MMM yyyy').format(widget.model.createdAt!)
        : '—';
    final isAvailable = widget.model.status == 'active';
    final statusLabel = isAvailable ? 'ໃຊ້ງານຢູ່' : 'ບໍ່ໄດ້ໃຊ້ງານ';
    final statusColor = isAvailable ? AppColors.online : AppColors.primary;
    final address =
        widget.model.address != null ? '${widget.model.address}' : '—';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          // ── 3-stat strip ────────────────────────────────────────
          IntrinsicHeight(
            child: Row(
              children: [
                _StatStrip(label: 'ອາຍຸ', value: age > 0 ? '$age ປີ' : '—'),
                _StatStripDivider(),
                _StatStrip(label: 'ສະມາຊິກຕັ້ງແຕ່', value: memberSince),
                _StatStripDivider(),
                _StatStrip(
                  label: 'ສະຖານະ',
                  value: statusLabel,
                  valueColor: statusColor,
                ),
              ],
            ),
          ),
          // ── address ─────────────────────────────────────────────
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
                        'ທີ່ຢູ່',
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: AppColors.textHint,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        address,
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

  Widget _buildActionRow() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                height: 44.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(13.r),
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.08),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 15.r,
                      color: AppColors.textPrimary,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'ສົ່ງຂໍ້ຄວາມ',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          // _ActionBtn(
          //   icon: Icons.card_giftcard_rounded,
          //   color: const Color(0xFFD97706),
          //   onTap: () => GiftSheet.show(
          //     context,
          //     companionName: widget.model.firstName ?? 'ຄູ່ຮ່ວມທາງ',
          //     balanceKip: 125000,
          //     onSent: (gift) => GiftSentSnackbar.show(context, gift: gift),
          //     onTopUp: () => Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (_) => const TopUpAmountPage()),
          //     ),
          //   ),
          // ),
          SizedBox(width: 8.w),
          _ActionBtn(
            icon: Icons.person_add_alt_1_rounded,
            color: AppColors.textPrimary,
            onTap: () {},
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
  final RecommendedModel model;
  final int age;

  const _PhotoSlider({
    required this.photos,
    required this.height,
    required this.model,
    required this.age,
  });

  @override
  State<_PhotoSlider> createState() => _PhotoSliderState();
}

class _PhotoSliderState extends State<_PhotoSlider> {
  final _pageCtrl = PageController();
  int _current = 0;

  int get _count => widget.photos.isEmpty ? 1 : widget.photos.length;

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            itemBuilder: (_, i) {
              if (widget.photos.isNotEmpty) {
                return AppNetworkImage(
                  imageUrl: widget.photos[i],
                  fit: BoxFit.cover,
                  errorWidget: _gradientFallback(),
                );
              }
              return _gradientFallback();
            },
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
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

          if (_count > 1)
            Positioned(
              top: 14.h,
              left: 0,
              right: 0,
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

          if (_count > 1)
            Positioned(
              bottom: 150.h,
              right: 14.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  '${_current + 1} / $_count',
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withValues(alpha: 0.80),
                  ),
                ),
              ),
            ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _InfoOverlay(model: widget.model, age: widget.age),
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

// ═══════════════════════════════════════════════════════════════
//  _InfoOverlay — name, age, address, badges, stats
// ═══════════════════════════════════════════════════════════════
class _InfoOverlay extends StatelessWidget {
  final RecommendedModel model;
  final int age;
  const _InfoOverlay({required this.model, required this.age});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (model.online)
                _Badge(
                  label: 'ອອນລາຍ',
                  bg: const Color(0xE022C55E),
                  fg: Colors.white,
                  dot: true,
                ),
              if (model.online) SizedBox(width: 6.w),
              if (model.isVip)
                _Badge(
                  label: '★ VIP',
                  bg: const Color(0xBF1A1A2E),
                  fg: AppColors.vipGold,
                  border: AppColors.vipGold.withValues(alpha: 0.30),
                ),
            ],
          ),
          SizedBox(height: 8.h),

          // Name + age
          Text(
            '${model.firstName ?? ''} ${model.lastName ?? ''}'.trim() +
                (age > 0 ? ', $age' : ''),
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.5,
              height: 1.15,
            ),
          ),

          // Address below name
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
                'ໃກ້ທ່ານ',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.white60,
                ),
              ),
            ],
          ),

          if (model.bio != null && model.bio!.isNotEmpty) ...[
            SizedBox(height: 6.h),
            Text(
              model.bio!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.white.withValues(alpha: 0.60),
              ),
            ),
          ],
          SizedBox(height: 12.h),

          _StatsStrip(model: model),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;
  final Color? border;
  final bool dot;

  const _Badge({
    required this.label,
    required this.bg,
    required this.fg,
    this.border,
    this.dot = false,
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot) ...[
            Container(
              width: 4.r,
              height: 4.r,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 3.w),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 8.sp,
              fontWeight: FontWeight.w800,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsStrip extends StatelessWidget {
  final RecommendedModel model;
  const _StatsStrip({required this.model});

  String _fmt(int n) =>
      n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}k' : '$n';

  @override
  Widget build(BuildContext context) {
    final rating = model.rating ?? 0.0;
    final likes = model.likeCount ?? 0;
    final friends = model.friendsCount ?? 0;
    final reviews = model.totalReview ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          _StatCell(
            icon: Icons.star_rounded,
            iconColor: AppColors.vipGold,
            value: rating.toStringAsFixed(1),
            label: 'ຄະແນນ',
          ),
          _vDivider(),
          _StatCell(
            icon: Icons.rate_review_outlined,
            iconColor: Colors.white.withValues(alpha: 0.70),
            value: _fmt(reviews),
            label: 'ລີວິວ',
          ),
          _vDivider(),
          _StatCell(
            icon: Icons.favorite_rounded,
            iconColor: AppColors.primary,
            value: _fmt(likes),
            label: 'ຖືກໃຈ',
          ),
          _vDivider(),
          _StatCell(
            icon: Icons.people_outline_rounded,
            iconColor: Colors.white.withValues(alpha: 0.70),
            value: _fmt(friends),
            label: 'ຕິດຕາມ',
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
//  _Section — titled content wrapper
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
//  _AppBarIcon
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

// ═══════════════════════════════════════════════════════════════
//  _ActionBtn
// ═══════════════════════════════════════════════════════════════
class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44.r,
        height: 44.r,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13.r),
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.08),
            width: 0.5,
          ),
        ),
        child: Icon(icon, size: 18.r, color: color),
      ),
    );
  }
}
