import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xaosao/constants/app_color.dart';

class ImagePickerUtil {
  ImagePickerUtil._();

  static final _picker = ImagePicker();

  /// Pick from device gallery.
  static Future<File?> fromGallery({int quality = 85}) async {
    final xFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: quality,
    );
    return xFile != null ? File(xFile.path) : null;
  }

  /// Pick using the device camera.
  static Future<File?> fromCamera({int quality = 85}) async {
    final xFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: quality,
    );
    return xFile != null ? File(xFile.path) : null;
  }

  /// Shows a modal bottom sheet to choose gallery or camera, then returns the file.
  static Future<File?> pick({int quality = 85}) async {
    final ctx = Get.context;
    if (ctx == null) return null;
    final source = await showModalBottomSheet<ImageSource>(
      context: ctx,
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
      builder: (_) => const _SourceSheet(),
    );
    if (source == null) return null;
    final xFile = await _picker.pickImage(
      source: source,
      imageQuality: quality,
    );
    return xFile != null ? File(xFile.path) : null;
  }
}

// ── Source selection bottom sheet ─────────────────────────────────────────────

class _SourceSheet extends StatelessWidget {
  const _SourceSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 18),
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0EE),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
      
            // Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'ເລືອກຮູບໂປຣໄຟ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 18),
      
            // Gallery + Camera tiles
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _OptionTile(
                      icon: Icons.photo_library_outlined,
                      label: 'ຄັງຮູບ',
                      onTap: () => Navigator.pop(context, ImageSource.gallery),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _OptionTile(
                      icon: Icons.camera_alt_outlined,
                      label: 'ກ້ອງຖ່າຍຮູບ',
                      onTap: () => Navigator.pop(context, ImageSource.camera),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

// ── Single option tile ────────────────────────────────────────────────────────

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 86,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: AppColors.primary),
            const SizedBox(height: 7),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
