import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_mate/controllers/auth_controller.dart';

class LoginCard extends StatelessWidget {
  LoginCard({super.key});

  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  void login() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      AuthController.instance.logIn(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      formKey.currentState!.reset();
      emailController.clear();
      passwordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: Image.asset(
                  "assets/images/movie_bg.png",
                  fit: BoxFit.cover,
                ),
              ),

              // 🔹 Disable Blur on Android 8.1 or lower
              // if (androidVersion >= 28) // Android 9+ (SDK 28)
              //   Positioned.fill(
              //     child: BackdropFilter(
              //       filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              //       child: Container(
              //         color: theme.colorScheme.primaryContainer.withValues(
              //           alpha: 0.6,
              //         ),
              //       ),
              //     ),
              //   )
              // else
              //   Positioned.fill(
              //     child: Container(
              //       color: Colors.white, // ✅ Solid background for Android 8.1
              //     ),
              //   ),

              // Form Area
              Center(
                child: GestureDetector(
                  onTap:
                      () =>
                          FocusScope.of(context).unfocus(), // Dismiss keyboard
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "assets/images/movie.png",
                              width: 150,
                              height: 150,
                            ),

                            SizedBox(height: 20),

                            // Email Field
                            TextFormField(
                              validator:
                                  (value) =>
                                      value == null || value.trim().isEmpty
                                          ? 'enter_email'.tr
                                          : null,
                              controller: emailController,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                              ), // Dark text
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.email,
                                  color:
                                      theme
                                          .colorScheme
                                          .primary, // Terracotta Red
                                ),
                                hintText: 'email'.tr,
                                hintStyle: TextStyle(color: Colors.black54),
                                filled: true,
                                fillColor:
                                    theme
                                        .colorScheme
                                        .secondaryContainer, // Muted Teal
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.primary,
                                  ), // Terracotta Red
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.primary,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 15),

                            // Password Field
                            TextFormField(
                              validator:
                                  (value) =>
                                      value == null || value.trim().isEmpty
                                          ? 'enter_password'.tr
                                          : null,
                              controller: passwordController,
                              obscureText: true,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                              ), // Dark text
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color:
                                      theme
                                          .colorScheme
                                          .primary, // Terracotta Red
                                ),
                                hintText: 'password'.tr,
                                hintStyle: TextStyle(color: Colors.black54),
                                filled: true,
                                fillColor:
                                    theme
                                        .colorScheme
                                        .secondaryContainer, // Muted Teal
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.primary,
                                  ), // Terracotta Red
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.primary,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 25),

                            // Login Button with Loading Indicator
                            Obx(() {
                              return AuthController.instance.isLogin.value
                                  ? CircularProgressIndicator(
                                    color:
                                        theme
                                            .colorScheme
                                            .primary, // Terracotta Red
                                  )
                                  : ElevatedButton(
                                    onPressed: login,
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 50,
                                        vertical: 14,
                                      ),
                                      backgroundColor:
                                          theme
                                              .colorScheme
                                              .primary, // Terracotta Red
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      elevation: 10,
                                      shadowColor: theme.colorScheme.primary
                                          .withValues(alpha: 0.5),
                                    ),
                                    child: Text(
                                      "login".tr,
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                theme
                                                    .colorScheme
                                                    .onPrimary, // Beige text
                                          ),
                                    ),
                                  );
                            }),

                            SizedBox(height: 20),

                            // Toggle Between Login and Signup
                            TextButton(
                              onPressed: () {
                                AuthController.instance.switchCards.toggle();
                              },
                              style: TextButton.styleFrom(
                                foregroundColor:
                                    theme.colorScheme.secondary, // Muted Teal
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.secondary,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  shape: BoxShape.rectangle,
                                ),
                                padding: EdgeInsets.all(16),
                                child: Text(
                                  "dont_have_account".tr,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onPrimary
                                        .withValues(
                                          alpha: 0.8,
                                        ), // Softer contrast
                                    letterSpacing:
                                        0.5, // Smooth text appearance
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
