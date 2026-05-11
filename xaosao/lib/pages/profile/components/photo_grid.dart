import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/models/gallerys_model.dart';
import 'package:xaosao/pages/profile/components/profile_constant.dart';

class PhotoGrid extends StatelessWidget {
  final List<GallerysModel> photos;
  final int maxPhotos;
  final void Function(int slotIndex) onAdd;
  final void Function(int index) onRemove;
  final int uploadingIndex;
  final int deletingIndex;

  const PhotoGrid({
    super.key,
    required this.photos,
    required this.maxPhotos,
    required this.onAdd,
    required this.onRemove,
    this.uploadingIndex = -1,
    this.deletingIndex = -1,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: maxPhotos,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 6.h,
        crossAxisSpacing: 6.w,
        childAspectRatio: 1,
      ),
      itemBuilder: (_, i) {
        if (i == uploadingIndex || i == deletingIndex) {
          return _buildSpinnerSlot();
        }
        if (i < photos.length) {
          return _buildPhotoSlot(photos[i], i);
        }
        return _buildAddSlot(i);
      },
    );
  }

  Widget _buildSpinnerSlot() {
    return Container(
      height: 40.h,
      width: 40.w,
      decoration: BoxDecoration(
        color: PColor.bg,
        borderRadius: BorderRadius.circular(11.r),
        border: Border.all(
            color: AppColors.textDisabled.withAlpha(50), width: 0.5),
      ),
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  Widget _buildPhotoSlot(GallerysModel photo, int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(11.r),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            photo.url ?? '',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: PColor.bg,
              child: const Icon(Icons.broken_image_outlined,
                  color: PColor.hint),
            ),
            loadingBuilder: (_, child, progress) {
              if (progress == null) return child;
              return Container(color: PColor.bg);
            },
          ),
          Positioned(
            top: 5,
            right: 5,
            child: GestureDetector(
              onTap: () => onRemove(index),
              child: Container(
                width: 18.r,
                height: 18.r,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black54,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  size: 11,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddSlot(int index) {
    final canAdd = photos.length < maxPhotos;
    return GestureDetector(
      onTap: canAdd ? () => onAdd(index) : null,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(11.r),
          border: Border.all(
              color: AppColors.textDisabled.withAlpha(50), width: 0.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 24.r,
              height: 24.r,
              decoration: BoxDecoration(
                color: PColor.bg,
                borderRadius: BorderRadius.circular(7.r),
              ),
              child: Icon(
                Icons.add_rounded,
                size: 14.r,
                color: PColor.hint,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'ເພີ່ມ',
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFFC4C4D0),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
