import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_mate/controllers/auth_controller.dart';

class SignupCard extends StatefulWidget {
  const SignupCard({super.key});

  @override
  State<SignupCard> createState() => _SignupCardState();
}

class _SignupCardState extends State<SignupCard> {
  final formKey = GlobalKey<FormState>();
  String? usernameText;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final reTypePasswordController = TextEditingController();
  File? imageFile;

  void createAccount() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      await AuthController.instance.signUp(
        emailController.text.trim(),
        passwordController.text.trim(),
        imageFile,
        usernameText!,
      );

      //formKey.currentState!.reset();
      emailController.clear();
      passwordController.clear();
      reTypePasswordController.clear();
    }
  }

  void uploadImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      setState(() {
        imageFile = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox.expand(
      child: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset("assets/images/movie_bg.png", fit: BoxFit.cover),
          ),

          // // Blurred Overlay for Readability
          // Positioned.fill(
          //   child: BackdropFilter(
          //     filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          //     child: Container(
          //       color: theme.colorScheme.primaryContainer.withValues(
          //         alpha: 0.6,
          //       ),
          //     ),
          //   ),
          // ),

          // Scrollable Form Area
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Profile Image Picker
                    InkWell(
                      child:
                          imageFile == null
                              ? Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color:
                                      theme
                                          .colorScheme
                                          .primary, // Terracotta Red
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.add,
                                  color:
                                      theme
                                          .colorScheme
                                          .onPrimary, // Light Beige
                                  size: 50,
                                ),
                              )
                              : CircleAvatar(
                                radius: 50,
                                backgroundColor:
                                    theme.colorScheme.secondary, // Muted Teal
                                backgroundImage: FileImage(imageFile!),
                              ),
                      onTap: () {
                        Get.bottomSheet(
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondary, // Muted Teal
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: Icon(
                                    Icons.camera,
                                    color: theme.colorScheme.primary,
                                  ),
                                  title: Text(
                                    "camera".tr,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  onTap: () {
                                    uploadImage(ImageSource.camera);
                                    Get.back();
                                  },
                                ),
                                ListTile(
                                  leading: Icon(
                                    Icons.photo_library,
                                    color: theme.colorScheme.primary,
                                  ),
                                  title: Text(
                                    "gallery".tr,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  onTap: () {
                                    uploadImage(ImageSource.gallery);
                                    Get.back();
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // Username Field
                    _buildTextField(
                      context,
                      controller: null,
                      hintText: 'username'.tr,
                      validatorText: 'enter_username'.tr,
                      onSaved: (value) => usernameText = value,
                    ),
                    const SizedBox(height: 15),

                    // Email Field
                    _buildTextField(
                      context,
                      controller: emailController,
                      hintText: 'email'.tr,
                      validatorText: 'enter_email'.tr,
                    ),
                    const SizedBox(height: 15),

                    // Password Field
                    _buildTextField(
                      context,
                      controller: passwordController,
                      hintText: 'password'.tr,
                      validatorText: 'enter_password'.tr,
                      obscureText: true,
                    ),
                    const SizedBox(height: 15),

                    // Re-type Password Field
                    _buildTextField(
                      context,
                      controller: reTypePasswordController,
                      hintText: 'reenter_password'.tr,
                      validatorText: 'passwords_not_match'.tr,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'passwords_not_match'.tr;
                        }
                        if (value.trim() != passwordController.text.trim()) {
                          return 'passwords_not_match'
                              .tr; // ✅ Now it ensures both match
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 25),

                    // Sign Up Button with Loading Indicator
                    Obx(() {
                      return AuthController.instance.isLogin.value
                          ? CircularProgressIndicator(
                            color: theme.colorScheme.primary,
                          ) // Terracotta Red
                          : ElevatedButton(
                            onPressed: createAccount,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 50,
                                vertical: 14,
                              ),
                              backgroundColor:
                                  theme.colorScheme.primary, // Terracotta Red
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 10,
                              shadowColor: theme.colorScheme.primary.withValues(
                                alpha: 0.5,
                              ),
                            ),
                            child: Text(
                              "signup".tr,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color:
                                    theme
                                        .colorScheme
                                        .onPrimary, // Light Beige text
                              ),
                            ),
                          );
                    }),
                    const SizedBox(height: 20),

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
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          shape: BoxShape.rectangle,
                        ),
                        padding: EdgeInsets.all(16),
                        child: Text(
                          "already_have_account".tr,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimary.withValues(
                              alpha: 0.8,
                            ), // Softer contrast
                            letterSpacing: 0.5, // Smooth text appearance
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController? controller,
    required String hintText,
    required String validatorText,
    bool obscureText = false,
    void Function(String?)? onSaved,
    String? Function(String?)? validator, // ✅ Allow custom validation
  }) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator:
          validator ??
          (value) =>
              (value == null || value.trim().isEmpty) ? validatorText : null,
      onSaved: onSaved,
      style: TextStyle(color: theme.colorScheme.onSurface), // Dark Text
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: theme.colorScheme.secondaryContainer, // Muted Teal
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: theme.colorScheme.primary),
        ),
      ),
    );
  }
}
