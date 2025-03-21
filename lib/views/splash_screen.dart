import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_mate/controllers/auth_controller.dart';
import 'package:movie_mate/views/auth_screen.dart';
import 'package:movie_mate/views/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      Get.off(
        () => Obx(() {
          return AuthController.instance.user.value == null
              ? const AuthScreen()
              : const HomeScreen();
        }),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🎬 App Logo
            Image.asset("assets/images/splash_logo.png", width: 200),

            const SizedBox(height: 20),

            // 🍿 Animated Text
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(seconds: 2),
              builder:
                  (context, value, child) =>
                      Opacity(opacity: value, child: child),
              child: Text(
                "Movie Mate",
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // 🔄 Loading Indicator
            CircularProgressIndicator(color: theme.colorScheme.primary),
          ],
        ),
      ),
    );
  }
}
