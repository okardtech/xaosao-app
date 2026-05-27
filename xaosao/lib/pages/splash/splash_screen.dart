import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_image.dart';
import 'package:xaosao/constants/app_routes.dart';
import 'package:xaosao/pages/login/getx/login_logic.dart';
import 'package:xaosao/services/storage_service.dart';

// ═══════════════════════════════════════════════════════════════
//  SplashPage — Variant C · Full Gradient
//
//  Background  : linear gradient #F43F5E → #E11D48 → #BE123C
//  Logo        : glass circle (frosted white border)
//  Name        : XAOSAO bold white
//  Tagline     : muted white
//  Decorations : 2 filled blobs + 2 ring circles
//  Bottom      : animated loading dots + version
//
//  ໃຊ້ງານ:
//    home: SplashPage(
//      onFinished: () => Navigator.pushReplacement(context,
//        MaterialPageRoute(builder: (_) => const LoginPage())),
//    ),
// ═══════════════════════════════════════════════════════════════
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
    Future.delayed(const Duration(seconds: 2), _checkAuthAndNavigate);
  }

  // ── Auth check: token → dashboard | no token → onboarding ────
  Future<void> _checkAuthAndNavigate() async {
    if (!mounted) return;

    final storage = Get.find<StorageService>();
    final token = storage.read<String>('token');

    // No token → show onboarding
    if (token == null || token.isEmpty) {
      _goTo(AppRoutes.xaosaoHome);
      return;
    }

    // Token found → verify it by fetching profile
    final isClient = (storage.read<String>('role') ?? 'customer') != 'model';
    await Get.find<LoginLogic>().fetchProfile(isCustomer: isClient);

    // If 401 occurred: AuthInterceptor already cleared the token
    // and called Get.offAllNamed('/login'), so this widget is likely
    // unmounted. The mounted check below handles that safely.
    if (!mounted) return;

    final state = Get.find<LoginLogic>().state;
    final profileLoaded = isClient
        ? state.customerProfile != null
        : state.modelProfile != null;

    // Profile loaded → go to dashboard; otherwise → login
    _goTo(profileLoaded ? AppRoutes.dashboard : AppRoutes.login);
  }

  void _goTo(String route) {
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, route, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // ── Gradient background ─────────────────────────────
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF43F5E), // AppColors.primary
                    Color(0xFFE11D48), // AppColors.secondary
                    Color(0xFFBE123C), // deeper shade
                  ],
                  stops: [0.0, 0.55, 1.0],
                ),
              ),
            ),
          ),

          // ── Blob top-right ────────────────────────────────────
          Positioned(
            top: -60.h,
            right: -60.w,
            child: Container(
              width: 220.r,
              height: 220.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),

          // ── Blob bottom-left ──────────────────────────────────
          Positioned(
            bottom: -50.h,
            left: -40.w,
            child: Container(
              width: 180.r,
              height: 180.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),

          // ── Outer ring ────────────────────────────────────────
          Positioned(
            top: size.height / 2 - 160.r,
            left: size.width / 2 - 160.r,
            child: Container(
              width: 320.r,
              height: 320.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.09),
                  width: 1,
                ),
              ),
            ),
          ),

          // ── Middle ring ───────────────────────────────────────
          Positioned(
            top: size.height / 2 - 110.r,
            left: size.width / 2 - 110.r,
            child: Container(
              width: 220.r,
              height: 220.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.07),
                  width: 1,
                ),
              ),
            ),
          ),

          // ── Center content ────────────────────────────────────
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo circle
                Container(
                  width: 100.r,
                  height: 100.r,
                  child: Image.asset(AppImage.xaosaoNoBack, fit: BoxFit.cover),
                ),
                SizedBox(height: 24.h),
                // App name
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50.w),
                  child: Image.asset(AppImage.logoWhite),
                ),
                SizedBox(height: 9.h),

                // Tagline
                Text(
                  'ເພື່ອນຄູ່ໃຈ ທຸກທີ່ ທຸກເວລາ',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.white.withOpacity(0.55),
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),

          // ── Bottom: dots + version ────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 44.h,
            child: Column(
              children: [
                const _LoadingDots(),
                SizedBox(height: 10.h),
                Text(
                  'v1.0.0',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.white.withOpacity(0.28),
                    fontWeight: FontWeight.w500,
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
//  _LoadingDots — 3 pulsing white dots
// ═══════════════════════════════════════════════════════════════
class _LoadingDots extends StatefulWidget {
  const _LoadingDots();

  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) {
            final delay = i * 0.28;
            final raw = (_anim.value - delay).clamp(0.0, 1.0);
            final opacity = (0.25 + raw * 0.75).clamp(0.25, 1.0);
            return Container(
              width: 7.r,
              height: 7.r,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(opacity),
              ),
            );
          }),
        );
      },
    );
  }
}
