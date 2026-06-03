import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class AppImagePreview extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const AppImagePreview({
    super.key,
    required this.images,
    this.initialIndex = 0,
  });

  /// Open the full-screen preview from any widget context.
  static void show(
    BuildContext context,
    List<String> images, {
    int initialIndex = 0,
  }) {
    if (images.isEmpty) return;
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black,
        pageBuilder: (_, __, ___) => AppImagePreview(
          images: images,
          initialIndex: initialIndex,
        ),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 220),
      ),
    );
  }

  @override
  State<AppImagePreview> createState() => _AppImagePreviewState();
}

class _AppImagePreviewState extends State<AppImagePreview> {
  late final PageController _ctrl;
  late int _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initialIndex.clamp(0, widget.images.length - 1);
    _ctrl = PageController(initialPage: _current);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  int get _count => widget.images.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.45),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.close_rounded, color: Colors.white, size: 18.r),
          ),
        ),
        actions: [
          if (_count > 1)
            Container(
              margin: EdgeInsets.fromLTRB(0, 10.h, 14.w, 10.h),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                '${_current + 1} / $_count',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          // ── Gallery ──────────────────────────────────────────────
          PhotoViewGallery.builder(
            pageController: _ctrl,
            itemCount: _count,
            scrollPhysics: const BouncingScrollPhysics(),
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            onPageChanged: (i) => setState(() => _current = i),
            builder: (_, i) => PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(widget.images[i]),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 3.5,
              heroAttributes: PhotoViewHeroAttributes(
                tag: 'preview_${widget.images[i]}_$i',
              ),
              errorBuilder: (_, __, ___) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.broken_image_outlined,
                      color: Colors.white30,
                      size: 48.r,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'ໂຫຼດຮູບບໍ່ໄດ້',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white38,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            loadingBuilder: (_, __) => Center(
              child: SizedBox(
                width: 24.r,
                height: 24.r,
                child: const CircularProgressIndicator(
                  color: Colors.white54,
                  strokeWidth: 2,
                ),
              ),
            ),
          ),

          // ── Bottom dot indicators ──────────────────────────────────
          if (_count > 1)
            Positioned(
              bottom: 32.h,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_count, (i) {
                  final isOn = i == _current;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    margin: EdgeInsets.symmetric(horizontal: 3.w),
                    width: isOn ? 18.w : 6.r,
                    height: 6.r,
                    decoration: BoxDecoration(
                      color: isOn
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}
