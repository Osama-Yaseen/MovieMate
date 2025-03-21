import 'dart:ui';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:movie_mate/controllers/auth_controller.dart';
import 'package:movie_mate/helpers/snackbar_helper.dart';

class SubscriptionController extends GetxController {
  final box = GetStorage();
  var isSubscribed = false.obs;
  final InAppPurchase _iap = InAppPurchase.instance;
  final String _subscriptionId = "premium_subscription"; // ✅ Google Play ID

  @override
  void onInit() {
    super.onInit();
    checkSubscription(); // ✅ Check subscription on startup
    _listenToPurchaseUpdates();
  }

  void checkSubscription() async {
    final bool available = await _iap.isAvailable();
    if (!available) return;

    await _iap.restorePurchases(); // Restore any previous purchases

    isSubscribed.value = box.read("isSubscribed") ?? false;
  }

  Future<bool> buyPremium() async {
    final bool available = await _iap.isAvailable();
    if (!available) {
      SnackbarHelper.showCustomSnackbar(
        title: "error",
        message: "iap_unavailable",
        isSuccess: false,
      );
      return false;
    }

    final ProductDetailsResponse response = await _iap.queryProductDetails({
      _subscriptionId,
    });
    if (response.notFoundIDs.isNotEmpty) {
      SnackbarHelper.showCustomSnackbar(
        title: "error",
        message: "product_not_found",
        isSuccess: false,
      );
      return false;
    }

    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: response.productDetails.first,
    );
    bool success = await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    return success;
  }

  void _listenToPurchaseUpdates() {
    _iap.purchaseStream.listen(
      (List<PurchaseDetails> purchases) {
        for (var purchase in purchases) {
          if (purchase.productID == _subscriptionId) {
            handlePurchase(purchase);
          }
        }
      },
      onError: (error) {
        String errorMessage = _getIAPErrorMessage(error).tr;
        SnackbarHelper.showCustomSnackbar(
          title: "error",
          message: errorMessage,
          isSuccess: false,
        );
      },
    );
  }

  void handlePurchase(PurchaseDetails purchase) async {
    if (purchase.status == PurchaseStatus.purchased) {
      isSubscribed.value = true;
      await AuthController.instance.updateUserSubscription();
      box.write("isSubscribed", true);
      // ✅ Now, switch the language after successful payment
      Get.updateLocale(Locale("ar"));
      AuthController.instance.updateUserLanguageLocally('ar');
      SnackbarHelper.showCustomSnackbar(
        title: "success",
        message: 'premium_activated',
        isSuccess: true,
      );
    } else if (purchase.status == PurchaseStatus.error) {
      SnackbarHelper.showCustomSnackbar(
        title: "error",
        message: 'purchase_failed',
        isSuccess: false,
      );
    }

    if (purchase.pendingCompletePurchase) {
      await _iap.completePurchase(purchase);
    }
  }

  Future<void> restorePurchases() async {
    final bool available = await _iap.isAvailable();
    if (!available) {
      SnackbarHelper.showCustomSnackbar(
        title: "error",
        message: 'iap_unavailable',
        isSuccess: false,
      );
      return;
    }

    await _iap.restorePurchases(); // ✅ Correct method for restoring purchases
  }

  // 🔹 Map error codes to user-friendly messages
  String _getIAPErrorMessage(dynamic error) {
    String errorCode = error.toString().toLowerCase();

    if (errorCode.contains('billing_unavailable')) {
      return 'billing_unavailable';
    } else if (errorCode.contains('developer_error')) {
      return 'developer_error';
    } else if (errorCode.contains('item_unavailable')) {
      return 'item_unavailable';
    } else if (errorCode.contains('user_canceled')) {
      return 'user_canceled';
    } else if (errorCode.contains('service_disconnected')) {
      return 'service_disconnected';
    } else {
      return 'unexpected_iap_error';
    }
  }
}
