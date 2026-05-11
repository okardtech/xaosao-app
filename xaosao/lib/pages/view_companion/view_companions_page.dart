import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/pages/view_companion/components/companion_grid.dart';
import 'package:xaosao/pages/view_companion/components/companion_model.dart';


class ViewAllCompanionsPage extends StatefulWidget {
  final String title;
  const ViewAllCompanionsPage({super.key, this.title = 'ໃກ້ເຄິ່ງ · ອອນລາຍ'});

  @override
  State<ViewAllCompanionsPage> createState() => _ViewAllCompanionsPageState();
}

class _ViewAllCompanionsPageState extends State<ViewAllCompanionsPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();

  // ── Filter state ───────────────────────────────────────
  final Set<ServiceType> _selectedServices = {};
  bool _onlyOnline  = false;
  bool _onlyVip     = false;
  String _searchQuery = '';

  // ── Derived list ───────────────────────────────────────
  List<Companion> get _filtered {
    return mockCompanions.where((c) {
      if (_onlyOnline && !c.isOnline) return false;
      if (_onlyVip && !c.isVip) return false;
      if (_selectedServices.isNotEmpty &&
          !c.services.any(_selectedServices.contains)) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        if (!c.name.toLowerCase().contains(q) &&
            !c.district.toLowerCase().contains(q)) return false;
      }
      return true;
    }).toList()
      ..sort((a, b) {
        // Online first → VIP first → distance
        if (a.isOnline != b.isOnline) return a.isOnline ? -1 : 1;
        if (a.isVip != b.isVip) return a.isVip ? -1 : 1;
        return a.distanceKm.compareTo(b.distanceKm);
      });
  }

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() =>
        setState(() => _searchQuery = _searchCtrl.text));
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  // ══════════════════════════════════════════════════════
  //  BUILD
  // ══════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    final list = _filtered;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildSearchBar(),
            _buildFilterChips(),
            _buildResultMeta(list.length),
            Expanded(child: _buildGrid(list)),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────
  //  APP BAR
  // ──────────────────────────────────────────────────────
  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 8.h),
      child: Row(
        children: [
          // Back
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36.r, height: 36.r,
              decoration: BoxDecoration(
                color: Colors.white, shape: BoxShape.circle,
                border: Border.all(color: Colors.black.withOpacity(0.08), width: 0.5),
              ),
              child: Icon(Icons.arrow_back_ios_new_rounded,
                  size: 15.r, color: const Color(0xFF1A1A2E)),
            ),
          ),

          SizedBox(width: 12.w),

          Expanded(
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: 17.sp, fontWeight: FontWeight.w800,
                color: const Color(0xFF1A1A2E), letterSpacing: -0.3,
              ),
            ),
          ),

          // Filter toggle
          GestureDetector(
            onTap: _showFilterSheet,
            child: Container(
              width: 36.r, height: 36.r,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E), shape: BoxShape.circle,
              ),
              child: Icon(Icons.tune_rounded, size: 17.r, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────
  //  SEARCH BAR
  // ──────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 10.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: Colors.black.withOpacity(0.08), width: 0.5),
        ),
        child: Row(
          children: [
            Icon(Icons.search_rounded, size: 16.r, color: const Color(0xFF9B9BAD)),
            SizedBox(width: 8.w),
            Expanded(
              child: TextField(
                controller: _searchCtrl,
                style: TextStyle(fontSize: 13.sp, color: const Color(0xFF1A1A2E)),
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: 'ຄົ້ນຫາຊື່, ສະຖານທີ່...',
                  hintStyle: TextStyle(
                      fontSize: 13.sp, color: const Color(0xFFC4C4D0)),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            if (_searchQuery.isNotEmpty)
              GestureDetector(
                onTap: () => _searchCtrl.clear(),
                child: Icon(Icons.close_rounded,
                    size: 16.r, color: const Color(0xFF9B9BAD)),
              ),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────
  //  FILTER CHIPS
  // ──────────────────────────────────────────────────────
  Widget _buildFilterChips() {
    return SizedBox(
      height: 34.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        children: [
          _chip('ທັງໝົດ',
              selected: _selectedServices.isEmpty && !_onlyOnline && !_onlyVip,
              onTap: () => setState(() {
                _selectedServices.clear();
                _onlyOnline = false;
                _onlyVip = false;
              })),
          SizedBox(width: 7.w),
          ...ServiceType.values.map((s) => Padding(
            padding: EdgeInsets.only(right: 7.w),
            child: _chip(s.label,
                selected: _selectedServices.contains(s),
                color: s.color, bgColor: s.bgColor,
                onTap: () => setState(() {
                  _selectedServices.contains(s)
                      ? _selectedServices.remove(s)
                      : _selectedServices.add(s);
                })),
          )),
          _chip('★ VIP', selected: _onlyVip,
              onTap: () => setState(() => _onlyVip = !_onlyVip)),
          SizedBox(width: 7.w),
          _chip('● ອອນລາຍ', selected: _onlyOnline,
              onTap: () => setState(() => _onlyOnline = !_onlyOnline)),
        ],
      ),
    );
  }

  Widget _chip(String label, {
    required bool selected,
    Color? color,
    Color? bgColor,
    required VoidCallback onTap,
  }) {
    final activeColor = color ?? const Color(0xFF1A1A2E);
    final activeBg = bgColor ?? const Color(0xFF1A1A2E);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: selected
              ? (bgColor != null ? activeBg : const Color(0xFF1A1A2E))
              : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: selected
                ? (color ?? const Color(0xFF1A1A2E))
                : Colors.black.withOpacity(0.09),
            width: 0.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.sp, fontWeight: FontWeight.w700,
            color: selected
                ? (bgColor != null ? activeColor : Colors.white)
                : const Color(0xFF6B6B80),
          ),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────
  //  RESULT META
  // ──────────────────────────────────────────────────────
  Widget _buildResultMeta(int count) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 8.h),
      child: Row(
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 11.sp, color: const Color(0xFF9B9BAD)),
              children: [
                TextSpan(
                  text: '$count ',
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1A1A2E)),
                ),
                const TextSpan(text: 'ຄົນຢູ່ໃກ້ທ່ານ'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────
  //  GRID
  // ──────────────────────────────────────────────────────
  Widget _buildGrid(List<Companion> list) {
    if (list.isEmpty) return _buildEmpty();

    return GridView.builder(
      controller: _scrollCtrl,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
        childAspectRatio: 0.52,
      ),
      itemCount: list.length,
      itemBuilder: (_, i) => CompanionGridCard(
        companion: list[i],
        index: i,
        onTap: () {
          // TODO: navigate to companion detail page
        },
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded,
              size: 48.r, color: const Color(0xFFC4C4D0)),
          SizedBox(height: 12.h),
          Text('ບໍ່ພົບຂໍ້ມູນ',
              style: TextStyle(
                  fontSize: 15.sp, fontWeight: FontWeight.w700,
                  color: const Color(0xFF9B9BAD))),
          SizedBox(height: 6.h),
          Text('ລອງປ່ຽນ filter ຫຼືຄົ້ນຫາໃໝ່',
              style: TextStyle(
                  fontSize: 12.sp, color: const Color(0xFFC4C4D0))),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────
  //  FILTER BOTTOM SHEET
  // ──────────────────────────────────────────────────────
  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setModal) => Padding(
          padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 32.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36.w, height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text('ຕົວກອງ', style: TextStyle(
                  fontSize: 17.sp, fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A1A2E))),
              SizedBox(height: 16.h),
              Text('ບໍລິການ', style: TextStyle(
                  fontSize: 12.sp, color: const Color(0xFF9B9BAD),
                  fontWeight: FontWeight.w600)),
              SizedBox(height: 10.h),
              Row(
                children: ServiceType.values.map((s) => Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: GestureDetector(
                    onTap: () => setModal(() {
                      _selectedServices.contains(s)
                          ? _selectedServices.remove(s)
                          : _selectedServices.add(s);
                    }),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 14.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: _selectedServices.contains(s)
                            ? s.bgColor : Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: _selectedServices.contains(s)
                              ? s.color : Colors.black.withOpacity(0.09),
                          width: 0.5,
                        ),
                      ),
                      child: Text(s.label,
                          style: TextStyle(
                              fontSize: 12.sp, fontWeight: FontWeight.w700,
                              color: _selectedServices.contains(s)
                                  ? s.color : const Color(0xFF6B6B80))),
                    ),
                  ),
                )).toList(),
              ),
              SizedBox(height: 16.h),
              _sheetToggle('VIP ເທົ່ານັ້ນ', _onlyVip,
                  (v) => setModal(() => _onlyVip = v)),
              SizedBox(height: 10.h),
              _sheetToggle('ອອນລາຍ ເທົ່ານັ້ນ', _onlyOnline,
                  (v) => setModal(() => _onlyOnline = v)),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {});
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A1A2E),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r)),
                    elevation: 0,
                  ),
                  child: Text('ນຳໃຊ້ຕົວກອງ',
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sheetToggle(String label, bool value, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(
            fontSize: 13.sp, fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1A2E))),
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFFF06292),
        ),
      ],
    );
  }
}