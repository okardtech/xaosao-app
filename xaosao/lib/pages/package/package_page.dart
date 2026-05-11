import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/pages/package/components/package_history.dart';
import 'package_model.dart';

// ═══════════════════════════════════════════════════════════════
//  PackagePage — ໜ້າເລືອກແຜນ package
//
//  Layout:
//    Header (back + history)
//    Hero text
//    PageView (horizontal snap, card ກ້ວາງເຕັມ padding)
//    Dots indicator
//    Bottom note
// ═══════════════════════════════════════════════════════════════
class PackagePage extends StatefulWidget {
  const PackagePage({super.key});

  @override
  State<PackagePage> createState() => _PackagePageState();
}

class _PackagePageState extends State<PackagePage> {
  late final PageController _pageCtrl;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    // Start at popular card (index 0)
    _pageCtrl = PageController(viewportFraction: 0.88);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  // ══════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildHero(),
            SizedBox(height: 20.h),

            // PageView — horizontal snap scroll
            Expanded(
              child: PageView.builder(
                controller: _pageCtrl,
                physics: const BouncingScrollPhysics(),
                itemCount: allPackages.length,
                onPageChanged: (i) => setState(() => _current = i),
                itemBuilder: (_, i) => _PackageCard(
                  package: allPackages[i],
                  isActive: i == _current,
                  onSelect: () => _onSelect(allPackages[i]),
                ),
              ),
            ),

            SizedBox(height: 14.h),

            // Dots
            _buildDots(),

            SizedBox(height: 12.h),

            // Bottom note
            Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: Text(
                'ຍົກເລີກໄດ້ທຸກເວລາ · ໂອນຄືນຕາມນະໂຍບາຍ',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: const Color(0xFFC4C4D0),
                ),
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
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(11.r),
                border: Border.all(
                  color: Colors.black.withOpacity(0.08),
                  width: 0.5,
                ),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 14.r,
                color: const Color(0xFF1A1A2E),
              ),
            ),
          ),
          const Spacer(),

          // History button
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PackageHistoryPage()),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: Colors.black.withOpacity(0.08),
                  width: 0.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 13.r,
                    color: const Color(0xFF9B9BAD),
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    'ປະຫວັດ',
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
        ],
      ),
    );
  }

  // ── Hero text ───────────────────────────────────────────────
  Widget _buildHero() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 0),
      child: Column(
        children: [
          // Badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0F6),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: const Color(0xFFF06292).withOpacity(0.22),
                width: 0.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.favorite_rounded,
                  size: 12.r,
                  color: const Color(0xFFF06292),
                ),
                SizedBox(width: 5.w),
                Text(
                  'ເລືອກແຜນຂອງທ່ານ',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFF06292),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),

          Text(
            'ຍົກລະດັບປະສົບການ',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF1A1A2E),
              letterSpacing: -0.4,
            ),
          ),
          SizedBox(height: 5.h),

          Text(
            'ເລືອກແຜນທີ່ເໝາະສົມ ແລ້ວຊອກຫາຄູ່ໄດ້ທຸກເວລາ',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF9B9BAD),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ── Dots indicator ──────────────────────────────────────────
  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(allPackages.length, (i) {
        final isOn = i == _current;
        final color = isOn
            ? allPackages[i].accentColor
            : const Color(0xFFD1D1E0);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          width: isOn ? 18.w : 6.r,
          height: 6.r,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3.r),
          ),
        );
      }),
    );
  }

  // ── Select action ───────────────────────────────────────────
  void _onSelect(PackageModel pkg) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
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
              SizedBox(height: 20.h),
              Text(
                'ຢືນຢັນການຊື້ ${pkg.duration}',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 8.h),
              Text(
                pkg.formattedPrice,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w900,
                  color: pkg.accentColor,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  // TODO: handle purchase
                },
                child: Container(
                  width: double.infinity,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: pkg.accentColor,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Center(
                    child: Text(
                      'ດຳເນີນການຊຳລະ',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text(
                  'ຍົກເລີກ',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF9B9BAD),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _PackageCard — single package card in PageView
// ═══════════════════════════════════════════════════════════════
class _PackageCard extends StatelessWidget {
  final PackageModel package;
  final bool isActive;
  final VoidCallback onSelect;

  const _PackageCard({
    required this.package,
    required this.isActive,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isActive ? 1.0 : 0.94,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: package.isPopular && isActive
                  ? package.accentColor
                  : Colors.black.withOpacity(0.08),
              width: package.isPopular && isActive ? 1.5 : 0.5,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: package.accentColor.withOpacity(0.12),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildCardTop(),
                Divider(
                  height: 0,
                  thickness: 0.5,
                  color: Colors.black.withOpacity(0.06),
                ),
                Expanded(child: _buildCardBody()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Gradient top section ─────────────────────────────────────
  Widget _buildCardTop() {
    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: package.gradientColors,
        ),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -24,
            right: -10,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -36,
            left: -16,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.07),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.fromLTRB(18.w, 20.h, 18.w, 18.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Popular badge
                if (package.isPopular)
                  Container(
                    margin: EdgeInsets.only(bottom: 10.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.20),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 11.r,
                          color: const Color(0xFFFFD700),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'ນິຍົມທີ່ສຸດ',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Duration
                Text(
                  package.duration,
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.7,
                    height: 1,
                  ),
                ),

                SizedBox(height: 8.h),

                // Description
                Text(
                  package.description,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.white.withOpacity(0.70),
                    height: 1.55,
                  ),
                ),

                SizedBox(height: 14.h),

                // Price row
                Row(
                  children: [
                    Text(
                      package.formattedPrice,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    if (package.discountPercent > 0)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.22),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          'ປະຢັດ ${package.discountPercent}%',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Feature list + CTA ───────────────────────────────────────
  Widget _buildCardBody() {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.w, 14.h, 18.w, 16.h),
      child: Column(
        children: [
          // Feature list
          Expanded(
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: package.features.length,
              separatorBuilder: (_, __) => SizedBox(height: 8.h),
              itemBuilder: (_, i) => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 18.r,
                    height: 18.r,
                    decoration: BoxDecoration(
                      color: package.featureCheckBg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      size: 10.r,
                      color: package.featureCheckColor,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      package.features[i],
                      style: TextStyle(
                        fontSize: 11.5.sp,
                        color: const Color(0xFF555570),
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 14.h),

          // CTA button
          GestureDetector(
            onTap: onSelect,
            child: Container(
              width: double.infinity,
              height: 46.h,
              decoration: BoxDecoration(
                color: package.isPopular
                    ? package.accentColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(14.r),
                border: package.isPopular
                    ? null
                    : Border.all(
                        color: Colors.black.withOpacity(0.10),
                        width: 0.5,
                      ),
              ),
              child: Center(
                child: Text(
                  'ເລືອກແຜນນີ້',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                    color: package.isPopular
                        ? Colors.white
                        : const Color(0xFF1A1A2E),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
