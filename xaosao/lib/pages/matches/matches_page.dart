import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/pages/matches/components/match_card.dart';
import '../home/components/companion_card.dart';

// ═══════════════════════════════════════════════════════════════
//  MatchesPage  — ຄູ່ທີ່ເຫມາະສົມ
//  Tab 0: ເຮົາສົນໃຈ    Tab 1: ສົນໃຈເຮົາ
// ═══════════════════════════════════════════════════════════════
class MatchesPage extends StatefulWidget {
  const MatchesPage({super.key});

  @override
  State<MatchesPage> createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabCtrl;

  // ── ເຮົາສົນໃຈ ──────────────────────────────────────────────
  static final _iLike = <CompanionModel>[
    CompanionModel(
      id: 'a1',
      name: 'Alex',
      age: 25,
      district: 'ໄຊທານີ',
      distanceKm: 3.1,
      rating: 4.9,
      reviewCount: 67,
      likeCount: 1100,
      services: [ServiceType.social],
      imageUrl:
          'https://imgix.ranker.com/user_node_img/50149/1002963945/original/1002963945-photo-u747646681?auto=format&q=60&fit=crop&fm=pjpg&dpr=2&w=355',
      isOnline: true,
      isVipElite: true,
      gender: 'male',
      gradientColors: [const Color(0xFFFFCC80), const Color(0xFFE65100)],
    ),
    CompanionModel(
      id: 'a2',
      name: 'Ryan',
      age: 29,
      district: 'ຫາດຊາຍຟອງ',
      imageUrl:
          'https://i.ytimg.com/vi/OYmoVr9Jd8Y/oar2.jpg?sqp=-oaymwEiCJwEENAFSFqQAgHyq4qpAxEIARUAAAAAJQAAyEI9AICiQw==&rs=AOn4CLA10G128riSMj_qRcr2FJZi5Vj4GA&usqp=CCk',
      distanceKm: 6.8,
      rating: 4.8,
      reviewCount: 88,
      likeCount: 1300,
      services: [ServiceType.massage, ServiceType.social],
      isOnline: false,
      gender: 'male',
      gradientColors: [const Color(0xFF4facfe), const Color(0xFF1A237E)],
    ),
    CompanionModel(
      id: 'a3',
      name: 'Tom',
      age: 22,
      district: 'ນາຊາຍທອງ',
      distanceKm: 7.1,
      rating: 4.3,
      reviewCount: 15,
      likeCount: 95,
      imageUrl:
          'https://i.ytimg.com/vi/5RkVjomNgWg/oar2.jpg?sqp=-oaymwEbCJUDEOAESFqQAgHyq4qpAwoIARUAAIhCyAEB&rs=AOn4CLBH5ojPUDdWAlv-v-ycLKM0AxgS-w&usqp=CCk',
      services: [ServiceType.travel, ServiceType.social],
      isOnline: true,
      isNew: true,
      gender: 'male',
      gradientColors: [const Color(0xFF43e97b), const Color(0xFF1A5276)],
    ),
  ];

  // ── ສົນໃຈເຮົາ ──────────────────────────────────────────────
  static final _likesMe = <CompanionModel>[
    CompanionModel(
      id: 'b1',
      name: 'Kai',
      age: 26,
      district: 'ອານຸວົງ',
      distanceKm: 1.2,
      rating: 4.9,
      reviewCount: 86,
      likeCount: 1400,
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR6pcF7uRPd0edzj0YFgjVMbfO9Ia6XhZB13g&s',
      services: [ServiceType.social, ServiceType.travel],
      isOnline: true,
      isVipElite: true,
      gender: 'male',
      gradientColors: [const Color(0xFF5C6BC0), const Color(0xFF1A1A2E)],
    ),
    CompanionModel(
      id: 'b2',
      name: 'Leo',
      age: 28,
      district: 'ໄຊເສດຖາ',
      distanceKm: 0.8,
      rating: 4.8,
      reviewCount: 54,
      likeCount: 870,
      imageUrl:
          'https://i.pinimg.com/736x/b5/d0/42/b5d0429c78e63582d398843203b24787.jpg',
      services: [ServiceType.massage, ServiceType.travel],
      isOnline: false,
      isNew: true,
      gender: 'male',
      gradientColors: [const Color(0xFFfa709a), const Color(0xFF7B1FA2)],
    ),
    CompanionModel(
      id: 'b3',
      name: 'Mark',
      age: 24,
      district: 'ວຽງຈັນ',
      distanceKm: 2.8,
      rating: 4.7,
      reviewCount: 12,
      likeCount: 320,
      services: [ServiceType.social, ServiceType.massage],
      imageUrl: '',
      isOnline: true,
      gender: 'male',
      gradientColors: [const Color(0xFFCE93D8), const Color(0xFF4A148C)],
    ),
    CompanionModel(
      id: 'b4',
      name: 'Jin',
      age: 27,
      district: 'ໄຊໂຄດຕະບອງ',
      distanceKm: 4.2,
      rating: 4.6,
      reviewCount: 23,
      likeCount: 390,
      imageUrl: '',
      services: [ServiceType.social, ServiceType.travel],
      isOnline: true,
      gender: 'male',
      gradientColors: [const Color(0xFF43e97b), const Color(0xFF38f9d7)],
    ),
    CompanionModel(
      id: 'b5',
      name: 'Sam',
      age: 23,
      district: 'ຈັນທະບູລີ',
      distanceKm: 5.2,
      rating: 5.0,
      reviewCount: 41,
      likeCount: 780,
      services: [ServiceType.travel, ServiceType.massage],
      isOnline: true,
      gender: 'male',
      gradientColors: [const Color(0xFF667eea), const Color(0xFF764ba2)],
    ),
    CompanionModel(
      id: 'b6',
      name: 'Alex',
      age: 25,
      district: 'ໄຊທານີ',
      distanceKm: 3.1,
      rating: 4.9,
      reviewCount: 67,
      likeCount: 1100,
      services: [ServiceType.social],
      isOnline: false,
      isVipElite: true,
      gender: 'male',
      gradientColors: [const Color(0xFFFFCC80), const Color(0xFFBF360C)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _tabCtrl.addListener(() => setState(() {}));
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

  // ══════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 4.h),
            _buildSegmentControl(),
            SizedBox(height: 4.h),
            Expanded(
              child: TabBarView(
                controller: _tabCtrl,
                physics: const NeverScrollableScrollPhysics(),
                children: [_buildILikeTab(), _buildLikesMeTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Header ───────────────────────────────────────────────────
  Widget _buildHeader() {
    final isILike = _tabCtrl.index == 0;
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ຄູ່ທີ່ເຫມາະສົມ',
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1A1A2E),
                    letterSpacing: -0.6,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Container(
                      width: 8.r,
                      height: 8.r,
                      decoration: BoxDecoration(
                        color: isILike
                            ? const Color(0xFFF06292)
                            : const Color(0xFF42A5F5),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      isILike
                          ? 'ທ່ານສົນໃຈ ${_iLike.length} ຄົນ'
                          : '${_likesMe.length} ຄົນສົນໃຈທ່ານ',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF9B9BAD),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          // Notification button
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 42.r,
                height: 42.r,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(13.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.notifications_outlined,
                  size: 20.r,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              if (_tabCtrl.index == 1)
                Positioned(
                  top: -2.h,
                  right: -2.w,
                  child: Container(
                    width: 14.r,
                    height: 14.r,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF06292),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFF8F8FC),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${_likesMe.length}',
                        style: TextStyle(
                          fontSize: 7.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Segment Control ──────────────────────────────────────────
  Widget _buildSegmentControl() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Container(
        padding: EdgeInsets.all(4.r),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            _segBtn(
              index: 0,
              label: 'ເຮົາສົນໃຈ',
              icon: Icons.favorite_outline_rounded,
            ),
            _segBtn(
              index: 1,
              label: 'ສົນໃຈເຮົາ',
              icon: Icons.people_alt_outlined,
              badge: _likesMe.length.toString(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _segBtn({
    required int index,
    required String label,
    required IconData icon,
    String? badge,
  }) {
    final isActive = _tabCtrl.index == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => _tabCtrl.animateTo(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 14.r,
                color: isActive
                    ? const Color(0xFFF06292)
                    : const Color(0xFF9B9BAD),
              ),
              SizedBox(width: 5.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: isActive
                      ? const Color(0xFF1A1A2E)
                      : const Color(0xFF9B9BAD),
                ),
              ),
              if (badge != null) ...[
                SizedBox(width: 5.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF06292),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ─── Tab 0: ເຮົາສົນໃຈ ─────────────────────────────────────────
  Widget _buildILikeTab() {
    if (_iLike.isEmpty) {
      return _buildEmpty(
        icon: Icons.favorite_border_rounded,
        title: 'ຍັງບໍ່ມີຜູ້ທີ່ທ່ານສົນໃຈ',
        subtitle: 'ໄປຄົ້ນຫາ ແລະ ກົດ ❤ ຄົນທີ່ທ່ານຊື່ນຊອບ',
      );
    }
    return _FeedList(
      items: _iLike,
      headerText: '${_iLike.length} ລາຍການ',
      buildCard: (c, i) => MatchCard(
        companion: c,
        onMessage: () {},
        onBook: () {},
        onTap: () {},
      ),
    );
  }

  // ─── Tab 1: ສົນໃຈເຮົາ ─────────────────────────────────────────
  Widget _buildLikesMeTab() {
    if (_likesMe.isEmpty) {
      return _buildEmpty(
        icon: Icons.people_alt_outlined,
        title: 'ຍັງບໍ່ມີໃຜສົນໃຈທ່ານ',
        subtitle: 'ສ້າງໂປຣໄຟລ໌ຂອງທ່ານໃຫ້ສົມບູນ\nເພື່ອດຶງດູດຄວາມສົນໃຈ',
      );
    }
    return _FeedList(
      items: _likesMe,
      headerText: '${_likesMe.length} ຄົນສົນໃຈທ່ານ',
      buildCard: (c, i) => MatchCard(
        companion: c,
        counter: i + 1,
        total: _likesMe.length,
        onMessage: () {},
        onBook: () {},
        onTap: () {},
      ),
    );
  }

  // ─── Empty State ──────────────────────────────────────────────
  Widget _buildEmpty({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80.r,
              height: 80.r,
              decoration: BoxDecoration(
                color: const Color(0xFFF06292).withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 38.r,
                color: const Color(0xFFF06292).withOpacity(0.50),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1A1A2E),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF9B9BAD),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _FeedList  — scrollable list with fade peek + header label
// ═══════════════════════════════════════════════════════════════
class _FeedList extends StatelessWidget {
  final List<CompanionModel> items;
  final String headerText;
  final Widget Function(CompanionModel c, int index) buildCard;

  const _FeedList({
    required this.items,
    required this.headerText,
    required this.buildCard,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 100.h),
      itemCount: items.length + 1,
      itemBuilder: (_, i) {
        if (i == 0) return _buildHeader();
        final c = items[i - 1];
        return Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: buildCard(c, i - 1),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Row(
        children: [
          Text(
            headerText.split(' ').first,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF1A1A2E),
            ),
          ),
          Text(
            ' ${headerText.split(' ').skip(1).join(' ')}',
            style: TextStyle(fontSize: 13.sp, color: const Color(0xFF9B9BAD)),
          ),
        ],
      ),
    );
  }
}
