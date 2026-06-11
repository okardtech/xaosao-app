import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/services/notification_service.dart';
import 'package:xaosao/services/storage_service.dart';
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
  final IconData icon;
  final RxInt rxCount;
  const _NavBadgeIcon({required this.icon, required this.rxCount});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final count = rxCount.value;
      if (count == 0) return Icon(icon);
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(icon),
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

class _DashboardPageState extends State<DashboardPage> {
  late final DashboardLogic _logic;
  late final bool _isCustomer;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
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
  }

  @override
  void dispose() {
    Get.delete<DashboardLogic>();
    super.dispose();
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
            const BottomNavigationBarItem(
              icon: Icon(Icons.explore_rounded),
              label: 'ຄົ້ນຫາ',
            ),
            BottomNavigationBarItem(
              icon: _NavBadgeIcon(
                icon: Icons.article_outlined,
                rxCount: NotificationService.chatUnreadCount,
              ),
              label: 'ຄູ່ເເຊັດ',
            ),
            BottomNavigationBarItem(
              icon: _NavBadgeIcon(
                icon: Icons.chat_bubble_outline_rounded,
                rxCount: NotificationService.bookingUnreadCount,
              ),
              label: 'ນັດພົບ',
            ),
            BottomNavigationBarItem(
              icon: _NavBadgeIcon(
                icon: Icons.post_add_outlined,
                rxCount: NotificationService.postUnreadCount,
              ),
              label: 'ໂພສຫາຄູ່',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              label: 'ໂປຮໄຟລ໌',
            ),
          ],
        ),
      );
    }),
    );
  }
}
