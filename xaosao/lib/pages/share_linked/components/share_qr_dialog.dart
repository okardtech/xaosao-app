import 'dart:io';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/l10n/app_localizations.dart';
import 'package:xaosao/utils/app_snackbar.dart';
import 'package:xaosao/utils/l10n.dart' as g;

class ShareQrDialog extends StatefulWidget {
  final String modelName;
  final String? profileUrl;
  final String link;

  const ShareQrDialog({
    super.key,
    required this.modelName,
    required this.profileUrl,
    required this.link,
  });

  static void show(
    BuildContext context, {
    required String modelName,
    String? profileUrl,
    required String link,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => ShareQrDialog(
        modelName: modelName,
        profileUrl: profileUrl,
        link: link,
      ),
    );
  }

  @override
  State<ShareQrDialog> createState() => _ShareQrDialogState();
}

class _ShareQrDialogState extends State<ShareQrDialog> {
  final _qrKey = GlobalKey();
  bool _saving = false;

  Future<void> _downloadQr() async {
    setState(() => _saving = true);
    try {
      // iOS requires explicit photo library permission
      if (Platform.isIOS) {
        final status = await Permission.photosAddOnly.request();
        if (!status.isGranted) {
          AppSnackbar.error(g.l10n.shareQrPermissionDenied);
          return;
        }
      }

      final boundary =
          _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();

      final result = await SaverGallery.saveImage(
        bytes,
        quality: 100,
        fileName: 'xaosao_qr_${DateTime.now().millisecondsSinceEpoch}',
        androidRelativePath: 'Pictures/Xaosao',
        skipIfExists: false,
      );
      if (result.isSuccess) {
        AppSnackbar.success(g.l10n.shareQrSaved);
      } else {
        AppSnackbar.error(g.l10n.shareQrSaveFailed);
      }
    } catch (_) {
      AppSnackbar.error(g.l10n.shareQrErrorGeneric);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const headerHeight = 100.0;
    const avatarRadius = 36.0;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── Card ──────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 32,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Gradient header ────────────────────────────
                Container(
                  height: headerHeight.h,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: AppColors.pinkGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.r),
                      topRight: Radius.circular(24.r),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: -20,
                        right: -14,
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -30,
                        left: -10,
                        child: Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.06),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Body ────────────────────────────────────────
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    20.w,
                    avatarRadius.r + 10.h,
                    20.w,
                    20.h,
                  ),
                  child: Column(
                    children: [
                      // Name
                      Text(
                        widget.modelName.toUpperCase(),
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // ── QR Code (captured for save) ────────────
                      RepaintBoundary(
                        key: _qrKey,
                        child: Container(
                          padding: EdgeInsets.all(14.r),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.18),
                            ),
                          ),
                          child: QrImageView(
                            data: widget.link,
                            version: QrVersions.auto,
                            size: 180.r,
                            eyeStyle: const QrEyeStyle(
                              eyeShape: QrEyeShape.square,
                              color: Colors.black,
                            ),
                            dataModuleStyle: const QrDataModuleStyle(
                              dataModuleShape: QrDataModuleShape.square,
                              color: Colors.black,
                            ),
                            embeddedImage: const AssetImage(
                              'assets/images/xaosao.png',
                            ),
                            embeddedImageStyle: QrEmbeddedImageStyle(
                              size: Size(38.r, 38.r),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 14.h),

                      // ── App branding ───────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/logo-pink.png',
                            height: 18.h,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.star_rounded,
                              size: 18.r,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            l10n.shareQrBrandName,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        l10n.shareQrBrandTagline,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textHint,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20.h),

                      // ── Save to gallery button ─────────────────
                      SizedBox(
                        width: double.infinity,
                        height: 44.h,
                        child: ElevatedButton.icon(
                          onPressed: _saving ? null : _downloadQr,
                          icon: _saving
                              ? SizedBox(
                                  width: 16.r,
                                  height: 16.r,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Icon(Icons.download_rounded, size: 18.r),
                          label: Text(
                            l10n.shareQrDownload,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor:
                                AppColors.primary.withValues(alpha: 0.6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Avatar overlapping header / body ────────────────
          Positioned(
            top: headerHeight.h - avatarRadius.r,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: avatarRadius.r * 2,
                height: avatarRadius.r * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: widget.profileUrl != null
                      ? CachedNetworkImage(
                          imageUrl: widget.profileUrl!,
                          fit: BoxFit.cover,
                          placeholder: (_, __) =>
                              Container(color: AppColors.bg),
                          errorWidget: (_, __, ___) => _defaultAvatar(),
                        )
                      : _defaultAvatar(),
                ),
              ),
            ),
          ),

          // ── Close button ─────────────────────────────────────
          Positioned(
            top: 8.h,
            right: 8.w,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 30.r,
                height: 30.r,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.22),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close_rounded,
                  size: 16.r,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _defaultAvatar() => Container(
        color: AppColors.bg,
        child: Icon(
          Icons.person_rounded,
          size: 32.r,
          color: AppColors.textDisabled,
        ),
      );
}
