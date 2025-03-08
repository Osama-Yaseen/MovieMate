import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:movie_mate/Translations/app_translation.dart';
import 'package:movie_mate/controllers/auth_controller.dart';
import 'package:movie_mate/controllers/subscription_controller.dart';
import 'package:movie_mate/controllers/theme_controller.dart';
import 'package:movie_mate/themes/app_theme.dart';
import 'package:movie_mate/views/auth_screen.dart';
import 'package:movie_mate/views/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  Get.put(AuthController());
  Get.put(ThemeController());
  Get.put(SubscriptionController());

  final SubscriptionController subscriptionController = Get.find();
  InAppPurchase.instance.purchaseStream.listen((purchases) {
    for (var purchase in purchases) {
      subscriptionController.handlePurchase(purchase);
    }
  });

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(MainApp());
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    String? userLang = Get.find<AuthController>().userLanguage;

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme, // 🌞 Light Theme
      darkTheme: darkTheme, // 🌙 Dark Theme
      themeMode: Get.find<ThemeController>().themeMode.value,
      translations: AppTranslations(),
      locale: userLang == 'en' ? Locale('en') : Locale('ar'),
      fallbackLocale: Locale('ar'),
      home: Obx(() {
        return AuthController.instance.user.value == null
            ? AuthScreen()
            : HomeScreen();
      }),
    );
  }
}
