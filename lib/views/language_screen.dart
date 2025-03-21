import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_mate/controllers/auth_controller.dart';
import 'package:movie_mate/controllers/subscription_controller.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  void _changeLanguage(String langCode) {
    final SubscriptionController subscriptionController =
        Get.find<SubscriptionController>();

    // ✅ If user is NOT subscribed and selects Arabic, show a dialog
    if (langCode == "ar" &&
        !AuthController.instance.userData.value.isSubscribed) {
      _showPremiumDialog(subscriptionController);
      return;
    }
    Get.updateLocale(Locale(langCode));
    AuthController.instance.updateUserLanguageLocally(langCode);
  }

  void _showPremiumDialog(SubscriptionController subscriptionController) {
    Get.defaultDialog(
      title: "Premium Required 🚀",
      backgroundColor: Colors.grey,
      middleText: "Arabic language is available only for premium users.",
      confirm: ElevatedButton(
        onPressed: () async {
          Get.back();
          await subscriptionController.buyPremium();
          // if (success) {
          //   Get.updateLocale(
          //     Locale("ar"),
          //   ); // ✅ Switch to Arabic only if successful
          //   AuthController.instance.updateUserLanguageLocally('ar');
          // }
        },
        child: Text("Unlock Premium"),
      ),
      cancel: TextButton(onPressed: () => Get.back(), child: Text("Cancel")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "language".tr,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        iconTheme: IconThemeData(color: theme.colorScheme.onPrimary),
        elevation: 3,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🔹 Arabic Button (Restricted)
            _buildLanguageButton(
              context,
              title: "العربية",
              langCode: "ar",
              flag: "🇸🇦",
              isSelected: Get.locale?.languageCode == "ar",
            ),
            SizedBox(height: 20),
            // 🔹 English Button (Always Available)
            _buildLanguageButton(
              context,
              title: "English",
              langCode: "en",
              flag: "🇬🇧",
              isSelected: Get.locale?.languageCode == "en",
            ),
          ],
        ),
      ),
    );
  }

  // 🎨 Language Selection Button
  Widget _buildLanguageButton(
    BuildContext context, {
    required String title,
    required String langCode,
    required String flag,
    required bool isSelected,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => _changeLanguage(langCode),
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : Colors.grey[300],
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(flag, style: TextStyle(fontSize: 30)),
            SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
            if (isSelected)
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Icon(Icons.check_circle, color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }
}
