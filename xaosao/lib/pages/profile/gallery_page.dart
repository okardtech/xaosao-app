import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/models/gallerys_model.dart';
import 'package:xaosao/pages/profile/getx/profile_logic.dart';
import 'package:xaosao/widgets/app_image_preview.dart';
import 'package:xaosao/widgets/confirm_sheet.dart';
import 'package:xaosao/widgets/gradient_app_bar.dart';

class GalleryPage extends StatelessWidget {
  final bool isOwner;
  final int maxPhotos;

  const GalleryPage({
    super.key,
    required this.isOwner,
    required this.maxPhotos,
  });

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<ProfileLogic>();

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: GradientAppBar(
        title: 'ຮູບພາບທັງໝົດ',
        titleWidget: Obx(() {
          final count = logic.state.photos.length;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'ຮູບພາບທັງໝົດ',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              Text(
                '$count / $maxPhotos ຮູບ',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
            ],
          );
        }),
      ),
      body: Obx(() {
        final st = logic.state;
        final photos = st.photos;

        if (photos.isEmpty && !isOwner) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.photo_library_outlined,
                    size: 48.r, color: AppColors.textDisabled),
                SizedBox(height: 12.h),
                Text(
                  'ຍັງບໍ່ມີຮູບ',
                  style: TextStyle(fontSize: 14.sp, color: AppColors.textHint),
                ),
              ],
            ),
          );
        }

        final allUrls = photos
            .map((p) => p.url ?? '')
            .where((u) => u.isNotEmpty)
            .toList();

        return GridView.builder(
          padding: EdgeInsets.all(16.r),
          physics: const BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12.h,
            crossAxisSpacing: 12.w,
            childAspectRatio: 0.85,
          ),
          itemCount: maxPhotos,
          itemBuilder: (ctx, i) {
            if (i == st.uploadingIndex || i == st.deletingIndex) {
              return _buildSpinnerSlot();
            }
            if (i < photos.length) {
              return _buildPhotoSlot(ctx, photos[i], i, allUrls, logic);
            }
            if (isOwner) {
              return _buildAddSlot(ctx, logic, i);
            }
            return _buildEmptySlot();
          },
        );
      }),
    );
  }

  Widget _buildPhotoSlot(
    BuildContext context,
    GallerysModel photo,
    int index,
    List<String> allUrls,
    ProfileLogic logic,
  ) {
    return GestureDetector(
      onTap: () => AppImagePreview.show(context, allUrls, initialIndex: index),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
              color: Colors.black.withValues(alpha: 0.07), width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                photo.url ?? '',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.bg,
                  child: Icon(Icons.broken_image_outlined,
                      color: AppColors.textHint, size: 24.r),
                ),
                loadingBuilder: (_, child, p) => p == null
                    ? child
                    : Container(
                        color: AppColors.bg,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
              ),
              if (isOwner)
                Positioned(
                  top: 7,
                  right: 7,
                  child: GestureDetector(
                    onTap: () async {
                      final confirmed = await ConfirmSheet.show(
                        context,
                        title: 'ລຶບຮູບ',
                        message: 'ທ່ານຕ້ອງການລຶບຮູບນີ້ແທ້ບໍ່?',
                        confirmLabel: 'ລຶບ',
                        icon: Icons.delete_outline_rounded,
                        isDanger: true,
                      );
                      if (confirmed == true) logic.removePhoto(index);
                    },
                    child: Container(
                      width: 26.r,
                      height: 26.r,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.55),
                        shape: BoxShape.circle,
                      ),
                      child:
                          Icon(Icons.close_rounded, size: 13.r, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddSlot(BuildContext context, ProfileLogic logic, int slotIndex) {
    return GestureDetector(
      onTap: () => logic.pickAndUpload(slotIndex),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
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
            Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add_photo_alternate_outlined,
                  size: 22.r, color: AppColors.primary),
            ),
            SizedBox(height: 8.h),
            Text(
              'ເພີ່ມຮູບ',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptySlot() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
            color: AppColors.textDisabled.withAlpha(30), width: 0.5),
      ),
    );
  }

  Widget _buildSpinnerSlot() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
            color: AppColors.textDisabled.withAlpha(50), width: 0.5),
      ),
      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}
