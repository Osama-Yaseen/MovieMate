import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:movie_mate/controllers/theme_controller.dart';
import 'package:movie_mate/helpers/snackbar_helper.dart';
import 'package:movie_mate/models/user_model.dart';
import 'package:movie_mate/views/auth_screen.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  final authController = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final GetStorage localStorage = GetStorage();
  final FirebaseStorage storage = FirebaseStorage.instance; // Firebase Storage

  // Observable user state
  Rxn<User> user = Rxn<User>();

  var isLogin = false.obs;
  var switchCards = false.obs;
  var updateProfileLoading = false.obs;

  // Store user as an observable model
  Rx<UserModel> userData =
      UserModel(
        userName: "",
        email: "",
        language: 'en',
        theme: 'light',
        isSubscribed: false,
      ).obs;

  var userLanguage = 'en';

  @override
  void onInit() {
    super.onInit();
    user.bindStream(authController.authStateChanges());
    loadUserFromStorage();
  }

  void switchBetweenAuthCards() {
    switchCards.value = !switchCards.value;
  }

  void updateUserThemeLocally(String newTheme) async {
    final storedUser = localStorage.read('userData');
    if (storedUser != null) {
      // 🔹 Prepare the Firestore update payload
      Map<String, dynamic> updatedData = {"theme": newTheme};

      // 🔹 Perform a single Firestore update
      await firestore
          .collection('users')
          .doc(storedUser['id'])
          .update(updatedData);

      // ✅ Update only the themeMode while keeping other data the same
      storedUser['theme'] = newTheme;

      // ✅ Save updated data back to local storage
      localStorage.write('userData', storedUser);

      userData.update((user) {
        // ✅ Only update theme in userData
        if (user != null) {
          user.theme = newTheme;
        }
      });
    }
  }

  void updateUserLanguageLocally(String lang) async {
    final storedUser = localStorage.read('userData');
    if (storedUser != null) {
      // 🔹 Prepare the Firestore update payload
      Map<String, dynamic> updatedData = {"language": lang};

      // 🔹 Perform a single Firestore update
      await firestore
          .collection('users')
          .doc(storedUser['id'])
          .update(updatedData);

      // ✅ Update only the themeMode while keeping other data the same
      storedUser['language'] = lang;

      // ✅ Save updated data back to local storage
      localStorage.write('userData', storedUser);

      userData.update((user) {
        // ✅ Only update language in userData
        if (user != null) {
          user.language = lang;
        }
      });

      userLanguage = lang;
    }
  }

  Future<void> updateUserSubscription() async {
    final storedUser = localStorage.read('userData');
    if (storedUser != null) {
      // 🔹 Prepare the Firestore update payload
      Map<String, dynamic> updatedData = {"isSubscribed": true};

      // 🔹 Perform a single Firestore update
      await firestore
          .collection('users')
          .doc(storedUser['id'])
          .update(updatedData);

      // ✅ Update only the themeMode while keeping other data the same
      storedUser['isSubscribed'] = true;

      // ✅ Save updated data back to local storage
      localStorage.write('userData', storedUser);

      userData.update((user) {
        // ✅ Only update language in userData
        if (user != null) {
          user.isSubscribed = true;
        }
      });
    }
  }

  // bool get isLogedIn => user.value != null;

  Future<void> signUp(
    String email,
    String password,
    File? image,
    String userName,
  ) async {
    try {
      isLogin.value = true;
      String? imageUrl = '';

      final userCred = await authController.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (image != null) {
        imageUrl = await uploadImageToFirebaseStorage(
          image,
          userCred.user!.uid,
        );
      }

      final user = UserModel(
        id: userCred.user!.uid,
        userName: userName,
        email: email,
        imagePath: imageUrl,
        language: 'en',
        theme: 'light',
        isSubscribed: false,
      );
      await addUserToFireStore(user);

      localStorage.write('userData', user.toMap());
      SnackbarHelper.showCustomSnackbar(
        title: "success",
        message: "account_created",
        isSuccess: true,
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = getFirebaseErrorMessage(e.code).tr;
      SnackbarHelper.showCustomSnackbar(
        title: "error",
        message: errorMessage,
        isSuccess: false,
      );
    } finally {
      isLogin.value = false;
    }
  }

  Future<void> addUserToFireStore(UserModel user) async {
    try {
      await firestore.collection('users').doc(user.id).set(user.toMap());
      userData.value = user;
    } catch (e) {
      String errorMessage = getFirestoreErrorMessage(e).tr;
      SnackbarHelper.showCustomSnackbar(
        title: "error",
        message: errorMessage,
        isSuccess: false,
      );
    }
  }

  void logIn(String email, String password) async {
    try {
      isLogin.value = true; // Show loading indicator

      // Try signing in user
      final userCred = await authController.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Ensure we have a valid user
      if (userCred.user == null) {
        SnackbarHelper.showCustomSnackbar(
          title: "error",
          message: "user_not_found",
          isSuccess: false,
        );
        return;
      }

      // Fetch user data from Firestore
      final querySnapShot =
          await firestore.collection('users').doc(userCred.user!.uid).get();

      if (querySnapShot.exists) {
        userData.value = UserModel.fromMap(
          userCred.user!.uid,
          querySnapShot.data()!,
        );
        localStorage.write('userData', userData.value.toMap());
      } else {
        SnackbarHelper.showCustomSnackbar(
          title: "error",
          message: "user_data_not_found",
          isSuccess: false,
        );
      }
      SnackbarHelper.showCustomSnackbar(
        title: "success",
        message: "logged_in_successfully",
        isSuccess: true,
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = getFirebaseErrorMessage(e.code).tr;
      SnackbarHelper.showCustomSnackbar(
        title: "error",
        message: errorMessage,
        isSuccess: false,
      );
    } finally {
      isLogin.value = false; // Hide loading indicator
    }
  }

  void loadUserFromStorage() async {
    try {
      final storedUser = await localStorage.read('userData');

      if (storedUser != null) {
        userData.value = UserModel.fromMap(storedUser['id'], storedUser);
        if (userData.value.theme == 'light') {
          ThemeController.instance.themeMode.value = ThemeMode.light;
        } else {
          ThemeController.instance.themeMode.value = ThemeMode.dark;
        }
        userLanguage = userData.value.language;
      }
    } catch (e) {
      String errorMessage = getFirestoreErrorMessage(e).tr;
      SnackbarHelper.showCustomSnackbar(
        title: "error",
        message: errorMessage,
        isSuccess: false,
      );
    }
  }

  void signOut() async {
    try {
      await authController.signOut();
      userData.value = UserModel(
        userName: '',
        email: '',
        language: 'en',
        theme: 'light',
        isSubscribed: false,
      );
      localStorage.remove('userData');
      SnackbarHelper.showCustomSnackbar(
        title: "success",
        message: "signed_out_successfully",
        isSuccess: true,
      );
    } on FirebaseAuthException catch (ex) {
      String errorMessage = getFirebaseErrorMessage(ex.code).tr;
      SnackbarHelper.showCustomSnackbar(
        title: "error",
        message: errorMessage,
        isSuccess: false,
      );
    }
  }

  // 🔹 Update User Info (Supports Profile Image too)
  Future<void> updateUserProfile({
    required String userId,
    required String newName,
    required String newEmail,
    File? newImageFile, // Optional image update
  }) async {
    try {
      updateProfileLoading.value = true;
      String? imageUrl;

      // 🔹 If a new image is selected, upload it
      if (newImageFile != null) {
        imageUrl = await uploadImageToFirebaseStorage(newImageFile, userId);
      }

      // 🔹 Prepare the Firestore update payload
      Map<String, dynamic> updatedData = {
        "userName": newName,
        "email": newEmail,
      };

      if (imageUrl != null) {
        updatedData["imagePath"] = imageUrl; // Only update image if changed
      }

      // 🔹 Perform a single Firestore update
      await firestore.collection('users').doc(userId).update(updatedData);

      // 🔹 Update the local user data
      userData.value = userData.value.copyWith(
        userName: newName,
        email: newEmail,
        imagePath:
            imageUrl ?? userData.value.imagePath, // Keep old image if unchanged
      );

      // 🔹 Save to local storage
      localStorage.write("userData", userData.value.toMap());

      SnackbarHelper.showCustomSnackbar(
        title: "success",
        message: "save_changes",
        isSuccess: true,
      );
    } catch (e) {
      String errorMessage = getFirestoreErrorMessage(e).tr;
      SnackbarHelper.showCustomSnackbar(
        title: "error",
        message: errorMessage,
        isSuccess: false,
      );
    } finally {
      updateProfileLoading.value = false;
    }
  }

  // 🔹 Upload Image to Firebase Storage
  Future<String?> uploadImageToFirebaseStorage(
    File image,
    String userId,
  ) async {
    try {
      String filePath =
          "profile_images/$userId.jpg"; // 🔥 Always overwrite old image
      Reference ref = storage.ref().child(filePath);

      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot snapshot = await uploadTask;

      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      String errorMessage = getFirestoreErrorMessage(e).tr;
      SnackbarHelper.showCustomSnackbar(
        title: "error",
        message: errorMessage,
        isSuccess: false,
      );
      return null;
    }
  }

  /// 📌 **Delete User Account from Firebase, Firestore, and Storage**
  Future<void> deleteUserAccount() async {
    try {
      User? currentUser = authController.currentUser;
      if (currentUser == null) return;

      // ✅ Fetch user data to check if an image exists
      DocumentSnapshot userDoc =
          await firestore.collection("users").doc(currentUser.uid).get();
      if (userDoc.exists) {
        String? imagePath = userDoc["imagePath"];
        if (imagePath!.isNotEmpty) {
          await _deleteUserImageFromStorage(imagePath);
        }
      }

      // ✅ Delete user data from Firestore
      await firestore.collection("users").doc(currentUser.uid).delete();

      // ✅ Delete user authentication
      await currentUser.delete();

      // ✅ Remove from local storage
      localStorage.remove("userData");

      // ✅ Sign out the user
      await authController.signOut();

      Get.offAll(() => AuthScreen());

      SnackbarHelper.showCustomSnackbar(
        title: "success",
        message: "account_deleted".tr,
        isSuccess: true,
      );
    } catch (e) {
      SnackbarHelper.showCustomSnackbar(
        title: "error",
        message: "account_deletion_failed".tr,
        isSuccess: false,
      );
    }
  }

  /// 📌 **Helper Method to Delete User Image from Firebase Storage**
  Future<void> _deleteUserImageFromStorage(String imageUrl) async {
    try {
      // Extract the file path from the full image URL
      RegExp regex = RegExp(r"\/o\/(.*?)\?");
      Match? match = regex.firstMatch(imageUrl);
      if (match != null && match.group(1) != null) {
        String filePath = Uri.decodeFull(match.group(1)!);
        await storage.ref().child(filePath).delete();
      }
    } catch (e) {
      print("❌ Failed to delete profile image: $e");
    }
  }

  String getFirestoreErrorMessage(dynamic error) {
    String errorCode = error.toString().toLowerCase();

    if (errorCode.contains('permission-denied')) {
      return 'permission_denied';
    } else if (errorCode.contains('unavailable')) {
      return 'firestore_unavailable';
    } else if (errorCode.contains('not-found')) {
      return 'document_not_found';
    } else if (errorCode.contains('already-exists')) {
      return 'document_already_exists';
    } else if (errorCode.contains('deadline-exceeded')) {
      return 'operation_timed_out';
    } else {
      return 'unexpected_firestore_error';
    }
  }

  // 📌 Function to Map Firebase Error Codes to User-Friendly Messages
  String getFirebaseErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'invalid-email':
        return 'Invalid email format. Please enter a valid email.';
      case 'user-not-found':
        return 'No user found with this email. Please sign up first.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'user-disabled':
        return 'Your account has been disabled. Contact support.';
      case 'email-already-in-use':
        return 'This email is already registered. Try logging in.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
