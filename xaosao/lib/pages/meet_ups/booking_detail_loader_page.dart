import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/models/my_booking_model.dart';
import 'package:xaosao/repository/booking_repo.dart';
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
  final _repo = BookingRepo();
  MyBookingModel? _booking;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final res = await _repo.myBookingById(
      isClient: widget.isCustomer,
      bookingId: widget.bookingId,
    );
    if (!mounted) return;
    if (res.success && res.data != null) {
      setState(() {
        _booking = res.data;
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
        _error = res.message ?? 'ບໍ່ສາມາດໂຫຼດຂໍ້ມູນ';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F8FC),
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }
    if (_error != null) {
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
              Icon(Icons.wifi_off_rounded, size: 48.r, color: AppColors.primary),
              SizedBox(height: 16.h),
              Text(
                _error!,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF9B9BAD),
                ),
              ),
              SizedBox(height: 20.h),
              TextButton(
                onPressed: _load,
                child: Text(
                  'ລອງໃໝ່',
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
      booking: _booking!,
      isCustomer: widget.isCustomer,
    );
  }
}
