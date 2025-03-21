import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_mate/controllers/auth_controller.dart';
import 'package:movie_mate/helpers/snackbar_helper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final authController = Get.find<AuthController>();
  bool isEditing = false;
  File? selectedImage;

  late TextEditingController nameController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    final user = authController.userData.value;
    nameController = TextEditingController(text: user.userName);
    emailController = TextEditingController(text: user.email);
  }

  /// 📌 **Function to Pick & Upload a New Image**
  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          selectedImage = File(image.path);
        });
      }
    } catch (e) {
      SnackbarHelper.showCustomSnackbar(
        title: "error",
        message: "image_upload_failed".tr,
        isSuccess: false,
      );
    }
  }

  /// 📌 **Function to Save Changes**
  void _saveChanges() async {
    try {
      if (nameController.text.trim().isEmpty ||
          emailController.text.trim().isEmpty) {
        SnackbarHelper.showCustomSnackbar(
          title: "error",
          message: "enter_valid_details".tr,
          isSuccess: false,
        );
        return;
      }

      // Prevent unnecessary updates if nothing changed
      final user = authController.userData.value;
      if (nameController.text == user.userName &&
          emailController.text == user.email &&
          selectedImage == null) {
        SnackbarHelper.showCustomSnackbar(
          title: "info",
          message: "no_changes_detected".tr,
          isSuccess: false,
        );
        return;
      }

      await authController.updateUserProfile(
        userId: user.id!,
        newName: nameController.text.trim(),
        newEmail: emailController.text.trim(),
        newImageFile: selectedImage,
      );

      setState(() {
        isEditing = false;
        selectedImage = null; // Reset after saving
      });
    } catch (e) {
      SnackbarHelper.showCustomSnackbar(
        title: "error",
        message: "profile_update_failed".tr,
        isSuccess: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "profile".tr,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        iconTheme: IconThemeData(color: theme.colorScheme.onPrimary),
        actions: [
          // 📌 Edit Button
          IconButton(
            icon: Icon(isEditing ? Icons.close : Icons.edit),
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
                selectedImage = null; // Reset selected image on cancel
              });
            },
          ),
        ],
      ),
      body: Obx(() {
        final user = authController.userData.value;

        return authController.updateProfileLoading.value
            ? Center(
              child: SpinKitSpinningLines(
                color: theme.colorScheme.primary,
                size: 100,
              ),
            )
            : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SizedBox(height: 10),

                    /// 📌 **Profile Image with Edit Button**
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 65,
                          backgroundColor: theme.colorScheme.secondary,
                          backgroundImage:
                              selectedImage != null
                                  ? FileImage(selectedImage!)
                                  : user.imagePath == null ||
                                      user.imagePath!.isEmpty
                                  ? AssetImage("assets/images/user_avatar.png")
                                      as ImageProvider
                                  : CachedNetworkImageProvider(user.imagePath!),
                        ),
                        if (isEditing) // Show only when editing
                          Positioned(
                            bottom: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.2,
                                      ),
                                      blurRadius: 6,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),

                    SizedBox(height: 20),

                    /// 📌 **User Information Card (Editable Fields)**
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white.withValues(alpha: 0.1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildEditableField(
                            Icons.person,
                            "username".tr,
                            nameController,
                          ),
                          Divider(color: Colors.white24),
                          _buildEditableField(
                            Icons.email,
                            "email".tr,
                            emailController,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    /// 📌 **Save Changes Button (Only Appears When Editing)**
                    if (isEditing)
                      ElevatedButton.icon(
                        onPressed: _saveChanges,
                        icon: Icon(Icons.save, color: Colors.white),
                        label: Text(
                          "save_changes".tr,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),

                    SizedBox(height: 20),

                    /// 📌 **Delete Account Button**
                    ElevatedButton.icon(
                      onPressed: deleteAccount,
                      icon: Icon(Icons.delete_forever, color: Colors.white),
                      label: Text(
                        "delete_account".tr,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
      }),
    );
  }

  /// 📌 **Editable User Info Field**
  Widget _buildEditableField(
    IconData icon,
    String label,
    TextEditingController controller,
  ) {
    final theme = Theme.of(context);

    return TextField(
      controller: controller,
      enabled: isEditing,
      style: TextStyle(color: theme.colorScheme.onSurface),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: theme.colorScheme.primary),
        labelText: label,
        labelStyle: TextStyle(color: theme.colorScheme.primary),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: theme.colorScheme.primary),
        ),
      ),
    );
  }

  /// 📌 **Function to Delete User Account**
  void deleteAccount() async {
    Get.defaultDialog(
      title: "delete_account".tr,
      middleText: "delete_account_confirmation".tr,
      backgroundColor: Colors.white,
      titleStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      middleTextStyle: TextStyle(color: Colors.black87),
      confirm: ElevatedButton(
        onPressed: () async {
          Get.back(); // Close dialog
          await authController.deleteUserAccount();
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        child: Text("confirm".tr),
      ),
      cancel: TextButton(onPressed: () => Get.back(), child: Text("cancel".tr)),
    );
  }
}
