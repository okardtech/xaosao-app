import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/l10n/app_localizations.dart';
import 'package:xaosao/models/gallerys_model.dart';
import 'package:xaosao/widgets/app_image_preview.dart';

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
      itemBuilder: (context, i) {
        if (i == uploadingIndex || i == deletingIndex) {
          return _buildSpinnerSlot();
        }
        if (i < photos.length) {
          return _buildPhotoSlot(context, photos[i], i);
        }
        return _buildAddSlot(context, i);
      },
    );
  }

  Widget _buildSpinnerSlot() {
    return Container(
      height: 40.h,
      width: 40.w,
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(11.r),
        border: Border.all(
          color: AppColors.textDisabled.withAlpha(50),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.10),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }

  Widget _buildPhotoSlot(BuildContext context, GallerysModel photo, int index) {
    final allUrls =
        photos.map((p) => p.url ?? '').where((u) => u.isNotEmpty).toList();
    return GestureDetector(
      onTap: () => AppImagePreview.show(context, allUrls, initialIndex: index),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(11.r),
          border: Border.all(
            color: AppColors.textDisabled.withAlpha(50),
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.10),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(11.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                photo.url ?? '',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.bg,
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: AppColors.textHint,
                  ),
                ),
                loadingBuilder: (_, child, progress) {
                  if (progress == null) return child;
                  return Container(color: AppColors.bg);
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
        ),
      ),
    );
  }

  Widget _buildAddSlot(BuildContext context, int index) {
    final canAdd = photos.length < maxPhotos;
    return GestureDetector(
      onTap: canAdd ? () => onAdd(index) : null,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(11.r),
          border: Border.all(
            color: AppColors.textDisabled.withAlpha(50),
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.10),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 24.r,
              height: 24.r,
              decoration: BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.circular(7.r),
              ),
              child: Icon(
                Icons.add_rounded,
                size: 14.r,
                color: AppColors.textHint,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              AppLocalizations.of(context)!.commonAdd,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
