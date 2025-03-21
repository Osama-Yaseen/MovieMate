import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_mate/controllers/auth_controller.dart';
import 'package:movie_mate/widgets/login_card.dart';
import 'package:movie_mate/widgets/signup_card.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access theme colors
    final authController = Get.find<AuthController>(); // ✅ Find Controller

    return Scaffold(
      backgroundColor: theme.colorScheme.primaryContainer,
      body: Obx(() {
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 400), // Smooth transition
          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child:
              authController.switchCards.value
                  ? SizedBox.expand(child: SignupCard()) // Full-screen mode
                  : SizedBox.expand(child: LoginCard()), // Full-screen mode
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => authController.switchBetweenAuthCards(), // ✅ Toggle
        child: Icon(Icons.swap_horiz),
      ),
    );
  }
}
