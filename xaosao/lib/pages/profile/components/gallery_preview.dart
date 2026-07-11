import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/models/gallerys_model.dart';
import '../gallery_page.dart';

class GalleryPreview extends StatelessWidget {
  final List<GallerysModel> photos;
  final bool isOwner;
  final int maxPhotos;
  final int uploadingIndex;

  static const _maxVisible = 3;

  const GalleryPreview({
    super.key,
    required this.photos,
    required this.isOwner,
    required this.maxPhotos,
    this.uploadingIndex = -1,
  });

  void _openGallery({int initialIndex = 0}) {
    Get.to(
      () => GalleryPage(isOwner: isOwner, maxPhotos: maxPhotos),
      arguments: initialIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (photos.isEmpty && !isOwner) {
      return Container(
        height: 88.h,
        decoration: BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
              color: AppColors.textDisabled.withAlpha(40), width: 0.5),
        ),
        child: Center(
          child: Text(
            'ຍັງບໍ່ມີຮູບ',
            style: TextStyle(fontSize: 13.sp, color: AppColors.textHint),
          ),
        ),
      );
    }

    return _buildRow();
  }

  Widget _buildRow() {
    final overflow =
        photos.length > _maxVisible ? photos.length - _maxVisible : 0;
    final tiles = <Widget>[];

    for (int i = 0; i < _maxVisible; i++) {
      if (i > 0) tiles.add(SizedBox(width: 8.w));

      Widget content;
      if (i == uploadingIndex) {
        content = _spinnerContent();
      } else if (i < photos.length) {
        final isOverflow = i == _maxVisible - 1 && overflow > 0;
        content = _photoContent(i, isOverflow ? '+$overflow' : null);
      } else if (i == photos.length && isOwner && photos.length < maxPhotos) {
        content = _addContent();
      } else {
        content = _emptyContent();
      }

      tiles.add(
        Expanded(
          child: AspectRatio(
            aspectRatio: 1.0,
            child: content,
          ),
        ),
      );
    }

    return Row(children: tiles);
  }

  Widget _photoContent(int index, String? overlayText) {
    return GestureDetector(
      onTap: () => _openGallery(initialIndex: index),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              photos[index].url ?? '',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.bg,
                child: Icon(Icons.broken_image_outlined,
                    color: AppColors.textHint, size: 20.r),
              ),
              loadingBuilder: (_, child, p) =>
                  p == null ? child : Container(color: AppColors.bg),
            ),
            if (overlayText != null)
              Container(
                color: Colors.black.withValues(alpha: 0.55),
                child: Center(
                  child: Text(
                    overlayText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                    color: Colors.black.withValues(alpha: 0.07), width: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _spinnerContent() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
            color: AppColors.textDisabled.withAlpha(50), width: 0.5),
      ),
      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }

  Widget _addContent() {
    return GestureDetector(
      onTap: _openGallery,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
              color: AppColors.textDisabled.withAlpha(80), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate_outlined,
                size: 24.r, color: AppColors.textHint),
            SizedBox(height: 6.h),
            Text('ເພີ່ມ',
                style: TextStyle(fontSize: 11.sp, color: AppColors.textHint)),
          ],
        ),
      ),
    );
  }

  Widget _emptyContent() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
            color: AppColors.textDisabled.withAlpha(30), width: 0.5),
      ),
    );
  }
}
