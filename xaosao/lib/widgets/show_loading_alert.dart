import 'package:flutter/material.dart';
import 'package:xaosao/widgets/loading_widget.dart';

import '../constants/app_color.dart';
import '../constants/app_image.dart';
import '../main.dart';

void showLoadingDialog({String imagePath = AppImage.xaosaoNoBack}) {
  final context = NavigationService.navigatorKey.currentContext;
  if (context == null) return;

  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.transparent,
    builder: (context) => PopScope(
      canPop: true,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primaryVariant.withValues(alpha: 0.55),
                  AppColors.textPrimary.withValues(alpha: 0.75),
                ],
              ),
            ),
          ),
          Dialog(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0,
            insetPadding: EdgeInsets.zero,
            child: LoadingWidget(imagePath: imagePath, size: 76),
          ),
        ],
      ),
    ),
  );
}

void hideLoadingDialog() {
  final context = NavigationService.navigatorKey.currentContext;
  if (context == null) return;

  Navigator.of(context, rootNavigator: true).pop();
}
