import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbar {
  AppSnackbar._();

  static void error(String message, {String title = 'ຜິດພາດ'}) {
    _show(
      title: title,
      message: message,
      bgColor: Colors.red.shade50,
      textColor: Colors.red.shade700,
      borderColor: Colors.red.shade200,
      icon: Icon(Icons.error_outline_rounded, color: Colors.red.shade400, size: 22),
    );
  }

  static void success(String message, {String title = 'ສຳເລັດ'}) {
    _show(
      title: title,
      message: message,
      bgColor: Colors.green.shade50,
      textColor: Colors.green.shade700,
      borderColor: Colors.green.shade200,
      icon: Icon(Icons.check_circle_outline_rounded, color: Colors.green.shade500, size: 22),
    );
  }

  static void info(String message, {String title = 'ຂໍ້ມູນ'}) {
    _show(
      title: title,
      message: message,
      bgColor: Colors.blue.shade50,
      textColor: Colors.blue.shade700,
      borderColor: Colors.blue.shade200,
      icon: Icon(Icons.info_outline_rounded, color: Colors.blue.shade400, size: 22),
    );
  }

  static void _show({
    required String title,
    required String message,
    required Color bgColor,
    required Color textColor,
    required Color borderColor,
    required Widget icon,
  }) {
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: bgColor,
      colorText: textColor,
      borderColor: borderColor,
      borderWidth: 1,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      icon: icon,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}
