import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/pages/matches/matches_page.dart';
import 'package:xaosao/services/storage_service.dart';

import '../chat/chat_page.dart';
import '../home/home_page.dart';
import '../meet_ups/meet_ups_page.dart';
import '../posts/posts_page.dart';
import '../profile/components/companion_profile.dart';
import '../profile/components/customer_profile.dart';
import '../profile/profile_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    final role = Get.find<StorageService>().read<String>('role');
    final profilePage = role == 'model'
        // ? const CompanionProfilePage()
        ? const ProfilePage()
        : const CustomerProfilePage();
    _pages = [
      const ExplorePage(),
      const ChatListPage(),
      const MeetUpsPage(),
      const PostsPage(),
      profilePage,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFF06292),
        unselectedItemColor: const Color(0xFFBBBBCC),
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
  }
}
