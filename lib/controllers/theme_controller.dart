import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_mate/controllers/auth_controller.dart';

class ThemeController extends GetxController {
  static ThemeController get instance => Get.find();
  Rx<ThemeMode> themeMode = ThemeMode.light.obs; // Default system mode

  void toggleTheme() {
    if (themeMode.value == ThemeMode.light) {
      themeMode.value = ThemeMode.dark;
      Get.changeThemeMode(ThemeMode.dark);
      AuthController.instance.updateUserThemeLocally('dark');
    } else {
      themeMode.value = ThemeMode.light;
      Get.changeThemeMode(ThemeMode.light);
      AuthController.instance.updateUserThemeLocally('light');
    }
  }
}
