import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackbarHelper {
  static void showCustomSnackbar({
    required String title,
    required String message,
    bool isSuccess = true,
  }) {
    Get.snackbar(
      title.tr,
      message.tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xFFB85042), // ✅ Transparent black
      colorText: Colors.white,
      borderRadius: 20,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: EdgeInsets.all(16),
      duration: Duration(seconds: 3),
      animationDuration: Duration(milliseconds: 500),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
      boxShadows: [
        BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
      ],
      icon: Icon(
        isSuccess ? Icons.check_circle : Icons.error,
        color:
            isSuccess
                ? Colors.greenAccent
                : const Color.fromARGB(255, 92, 3, 3),
        size: 26,
      ),
    );
  }
}
