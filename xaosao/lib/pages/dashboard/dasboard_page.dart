import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/constants/app_icons.dart';
import 'package:xaosao/services/notification_service.dart';
import 'package:xaosao/services/permission_coordinator.dart';
import 'package:xaosao/services/storage_service.dart';
import 'package:xaosao/widgets/app_svg_icon.dart';
import '../login/getx/login_logic.dart';
import '../chat/chat_page.dart';
import '../home/home_page.dart';
import '../meet_ups/meet_ups_page.dart';
import '../model_discover/model_discover_page.dart';
import '../package/getx/package_logic.dart';
import '../posts/posts_page.dart';
import '../profile/components/customer_profile.dart';
import '../profile/components/hidden_profile_banner.dart';
import '../profile/profile_page.dart';
import 'getx/dashboard_logic.dart';

class _NavBadgeIcon extends StatelessWidget {
  final Widget child;
  final RxInt rxCount;
  const _NavBadgeIcon({required this.child, required this.rxCount});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final count = rxCount.value;
      if (count == 0) return child;
      return Stack(
        clipBehavior: Clip.none,
        children: [
          child,
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              constraints: BoxConstraints(minWidth: 14.r, minHeight: 14.r),
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(7.r),
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: Center(
                child: Text(
                  count > 99 ? '99+' : '$count',
                  style: TextStyle(
                    fontSize: 7.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

class DashboardPage extends StatefulWidget {
  final int initialIndex;
  const DashboardPage({super.key, this.initialIndex = 0});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with WidgetsBindingObserver {
  late final DashboardLogic _logic;
  late final bool _isCustomer;
  late final List<Widget> _pages;

  // Tracks the last time the app went to background. Used to decide
  // whether a resume should re-run PermissionCoordinator (catches
  // grants made in Settings while the app was paused).
  DateTime? _pausedAt;
  static const _resumeRecheckThreshold = Duration(seconds: 10);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final role = Get.find<StorageService>().read<String>('role');
    _isCustomer = role == 'customer';

    _logic = Get.put(DashboardLogic(isCustomer: _isCustomer));

    final profilePage =
        role == 'model' ? const ProfilePage() : const CustomerProfilePage();
    final homePage =
        role == 'model' ? const ModelDiscoverPage() : const ExplorePage();

    _pages = [
      homePage,
      const ChatListPage(),
      const MeetUpsPage(),
      const PostsPage(),
      profilePage,
    ];

    if (widget.initialIndex != 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _logic.jumpTo(widget.initialIndex);
      });
    }

    if (_isCustomer) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Get.find<PackageLogic>().checkSubscription(context);
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final isHidden =
            Get.find<LoginLogic>().state.modelProfile?.isProfileHidden ?? false;
        if (isHidden) showHiddenProfileBanner(context);
      });
    }

    // Runtime permissions — notifications then location, both with
    // contextual primer sheets. Re-asks are throttled by a 7-day cooldown.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) PermissionCoordinator.checkAndPrime(context);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    Get.delete<DashboardLogic>();
    super.dispose();
  }

  // Re-check permissions when the app resumes from a long-enough
  // background. Catches the case where the user enables a permission
  // in OS Settings while we were paused. Short backgrounds (e.g. brief
  // overlay) are ignored to avoid churn. Side effects inside the
  // coordinator are themselves rate-limited (5 min), so this is safe
  // even if `resumed` fires more often than expected.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _pausedAt ??= DateTime.now();
      return;
    }
    if (state == AppLifecycleState.resumed) {
      final paused = _pausedAt;
      _pausedAt = null;
      if (paused == null) return;
      if (DateTime.now().difference(paused) < _resumeRecheckThreshold) return;
      if (!mounted) return;
      PermissionCoordinator.checkAndPrime(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Obx(() {
      final index = _logic.state.currentIndex;
      return Scaffold(
        backgroundColor: const Color(0xFFF8F8FC),
        body: IndexedStack(index: index, children: _pages),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: index,
          onTap: _logic.jumpTo,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.primaryVariant,
          selectedFontSize: 12.sp,
          unselectedFontSize: 12.sp,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
          elevation: 12,
          items: [
            BottomNavigationBarItem(
              icon: AppSvgIcon(assetName: AppIcons.exploreFill, color: AppColors.primaryVariant),
              activeIcon: AppSvgIcon(assetName: AppIcons.exploreFill, color: AppColors.primary),
              label: 'ຄົ້ນຫາ',
            ),
            BottomNavigationBarItem(
              icon: _NavBadgeIcon(
                child: AppSvgIcon(assetName: AppIcons.chatFill, color: AppColors.primaryVariant),
                rxCount: NotificationService.chatUnreadCount,
              ),
              activeIcon: _NavBadgeIcon(
                child: AppSvgIcon(assetName: AppIcons.chatFill, color: AppColors.primary),
                rxCount: NotificationService.chatUnreadCount,
              ),
              label: 'ຄູ່ເເຊັດ',
            ),
            BottomNavigationBarItem(
              icon: _NavBadgeIcon(
                child: AppSvgIcon(assetName: AppIcons.calendar, color: AppColors.primaryVariant),
                rxCount: NotificationService.bookingUnreadCount,
              ),
              activeIcon: _NavBadgeIcon(
                child: AppSvgIcon(assetName: AppIcons.calendar, color: AppColors.primary),
                rxCount: NotificationService.bookingUnreadCount,
              ),
              label: 'ນັດພົບ',
            ),
            BottomNavigationBarItem(
              icon: _NavBadgeIcon(
                child: AppSvgIcon(assetName: AppIcons.comment, color: AppColors.primaryVariant),
                rxCount: NotificationService.postUnreadCount,
              ),
              activeIcon: _NavBadgeIcon(
                child: AppSvgIcon(assetName: AppIcons.comment, color: AppColors.primary),
                rxCount: NotificationService.postUnreadCount,
              ),
              label: 'ໂພສຫາຄູ່',
            ),
            BottomNavigationBarItem(
              icon: AppSvgIcon(assetName: AppIcons.user, color: AppColors.primaryVariant),
              activeIcon: AppSvgIcon(assetName: AppIcons.user, color: AppColors.primary),
              label: 'ໂປຮໄຟລ໌',
            ),
          ],
        ),
      );
    }),
    );
  }
}
