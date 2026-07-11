import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class AppSvgIcon extends StatelessWidget {
  final String assetName;
  final double? width;
  final double? height;
  final Color? color;
  const AppSvgIcon({
    super.key,
    required this.assetName,
    this.width,
    this.height,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetName,
      width: width ?? 22.w,
      height: height ?? 22.h,
      colorFilter: color != null
          ? ColorFilter.mode(color ?? Colors.black, BlendMode.srcIn)
          : null,
      fit: BoxFit.contain,
      alignment: Alignment.center,
      allowDrawingOutsideViewBox: true,
      placeholderBuilder: (context) =>
          const Center(child: CircularProgressIndicator()),
      errorBuilder: (context, error, stackTrace) {
        return const Center(child: Icon(Icons.error));
      },
      semanticsLabel: assetName,
      excludeFromSemantics: true,
      clipBehavior: Clip.none,
      key: key,
    );
  }
}
