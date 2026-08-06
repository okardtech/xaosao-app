import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/l10n/app_localizations.dart';
import 'package:xaosao/pages/meet_ups/getx/meet_ups_logic.dart';
import 'package:xaosao/widgets/gradient_app_bar.dart';
import 'booking_detail_page.dart';

class BookingDetailLoaderPage extends StatefulWidget {
  final String bookingId;
  final bool isCustomer;

  const BookingDetailLoaderPage({
    super.key,
    required this.bookingId,
    required this.isCustomer,
  });

  @override
  State<BookingDetailLoaderPage> createState() =>
      _BookingDetailLoaderPageState();
}

class _BookingDetailLoaderPageState extends State<BookingDetailLoaderPage> {
  late final MeetUpLogic _logic;

  @override
  void initState() {
    super.initState();
    _logic = Get.find<MeetUpLogic>();
    // Defer until after the first frame so the synchronous state update inside
    // loadBookingDetail doesn't trigger Obx listeners (e.g. MeetUpsPage) while
    // the framework is still building the navigation stack.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _logic.loadBookingDetail(widget.bookingId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = _logic.state;
      final isLoading =
          state.bookingDetailLoading ||
          (state.bookingDetail == null && state.bookingDetailError == null);

      if (isLoading) {
        return const _BookingDetailShimmer();
      }

      if (state.bookingDetailError != null) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8F8FC),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: const BackButton(color: Color(0xFF1A1A2E)),
          ),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.wifi_off_rounded,
                  size: 48.r,
                  color: AppColors.primary,
                ),
                SizedBox(height: 16.h),
                Text(
                  state.bookingDetailError!,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF9B9BAD),
                  ),
                ),
                SizedBox(height: 20.h),
                TextButton(
                  onPressed: () => _logic.loadBookingDetail(widget.bookingId),
                  child: Text(
                    AppLocalizations.of(context)!.commonRetry,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return BookingDetailPage(
        booking: state.bookingDetail!,
        isCustomer: widget.isCustomer,
        onRefresh: () =>
            _logic.loadBookingDetail(widget.bookingId, silent: true),
      );
    });
  }
}

class _BookingDetailShimmer extends StatelessWidget {
  const _BookingDetailShimmer();

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      appBar: GradientAppBar(title: AppLocalizations.of(context)!.bookingDetailTitle),
      body: Padding(
        padding:  EdgeInsets.only(top: 20.h),
        child: Shimmer.fromColors(
          baseColor: const Color(0xFFE0E0EA),
          highlightColor: const Color(0xFFF0F0F7),
          child: ListView(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              // ── Detail card ───────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22.r),
                  ),
                  padding: EdgeInsets.all(20.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile header row
                      Row(
                        children: [
                          Container(
                            width: 52.r,
                            height: 52.r,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _line(140.w, 14.h),
                                SizedBox(height: 6.h),
                                _line(90.w, 11.h),
                              ],
                            ),
                          ),
                          SizedBox(width: 10.w),
                          _line(64.w, 26.h, radius: 20.r),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      // Service type + note lines
                      _line(double.infinity, 13.h),
                      SizedBox(height: 8.h),
                      _line(180.w, 13.h),
                      SizedBox(height: 20.h),
                      // Appointment hero block
                      Container(
                        height: 80.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      // Location lines
                      _line(double.infinity, 13.h),
                      SizedBox(height: 8.h),
                      _line(210.w, 13.h),
                      SizedBox(height: 20.h),
                      // Divider placeholder
                      _line(double.infinity, 1.h),
                      SizedBox(height: 16.h),
                      // Payment rows
                      _line(80.w, 12.h),
                      SizedBox(height: 12.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [_line(100.w, 13.h), _line(80.w, 13.h)],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [_line(80.w, 13.h), _line(60.w, 13.h)],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [_line(110.w, 13.h), _line(70.w, 13.h)],
                      ),
                      SizedBox(height: 16.h),
                      // Created at row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [_line(60.w, 11.h), _line(130.w, 11.h)],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32.h + bottomPad),
            ],
          ),
        ),
      ),
      // Bottom action bar shimmer
      bottomNavigationBar: Container(
        height: 80.h + bottomPad,
        color: Colors.white,
        child: Shimmer.fromColors(
          baseColor: const Color(0xFFE0E0EA),
          highlightColor: const Color(0xFFF0F0F7),
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h + bottomPad),
            child: _line(double.infinity, 48.h, radius: 14.r),
          ),
        ),
      ),
    );
  }

  Widget _line(double width, double height, {double? radius}) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius ?? 6.r),
    ),
  );
}
