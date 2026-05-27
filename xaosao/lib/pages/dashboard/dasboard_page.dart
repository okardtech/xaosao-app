import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/services/storage_service.dart';
import '../../constants/app_color.dart';
import '../chat/chat_page.dart';
import '../home/home_page.dart';
import '../meet_ups/meet_ups_page.dart';
import '../model_discover/model_discover_page.dart';
import '../package/getx/package_logic.dart';
import '../posts/posts_page.dart';
import '../profile/components/customer_profile.dart';
import '../profile/profile_page.dart';
import 'getx/dashboard_logic.dart';

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
    }
  }

  @override
  void dispose() {
    Get.delete<DashboardLogic>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final index = _logic.state.currentIndex;
      return Scaffold(
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
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_rounded),
              label: 'ຄົ້ນຫາ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article_outlined),
              label: 'ຄູ່ເເຊັດ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline_rounded),
              label: 'ນັດພົບ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.post_add_outlined),
              label: 'ໂພສຫາຄູ່',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              label: 'ໂປຮໄຟລ໌',
            ),
          ],
        ),
      );
    });
  }
}
