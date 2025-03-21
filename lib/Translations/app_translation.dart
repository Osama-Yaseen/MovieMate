import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en': {
      'app_title': 'Movie Mate',
      'login': 'Login',
      'signup': 'Sign Up',
      'email': 'Email',
      'password': 'Password',
      'username': 'Username',
      'retype_password': 'Re-type Password',
      'enter_email': 'Please enter a valid email!',
      'enter_password': 'Please enter your password!',
      'enter_username': 'Please enter your username!',
      'reenter_password': 'Please re-enter your password!',
      'passwords_not_match': 'Passwords do not match!',
      'already_have_account': 'Already have an account? Login!',
      'dont_have_account': 'Don\'t have an account? Sign up!',
      'camera': 'Camera',
      'gallery': 'Gallery',
      'add_profile_image': 'Add Profile Image',
      'pick_image': 'Please select a profile image!',
      'home': 'Home',
      'favorites': 'Favorites',
      'settings': 'Settings',
      'profile': 'Profile',
      'language': 'Language',
      'logout': 'Logout',
      'logout_message': 'You have been logged out.',
      'sidebar_version': 'Version 1.0.0',
      'top_rated': 'Top-Rated',
      'recent_movies': 'Recent Movies',
      'trending': 'Trending',
      'action': 'Action Movies',
      'horror': 'Horror Movies',
      'drama': 'Drama Movies',
      'romance': 'Romance Movies',
      'thriller': 'Thriller Movies',
      'see_all': 'See All',
      'search_movies': 'Search movies...',
      'save_changes': 'Save Changes',
      'watch_trailer': 'Watch Trailer',
      'translating': 'Translating...',
      'cast': 'Cast:',
      'overview': 'Overview:',
      "release_date": "Release Date:",
      "movie_trailer": "Movie Trailer",
      "success": "Success",
      "account_created": "Account created successfully!",
      "error": "Error",
      "something_went_wrong": "Something went wrong",
      "user_data_not_found": "User data not found in Firestore.",
      "logged_in_successfully": "Logged in successfully!",
      "login_failed": "Login Failed",
      "an_error_occurred": "An error occurred",
      "signed_out_successfully": "Signed out successfully!",
      "profile_updated": "Profile updated successfully!",
      "profile_update_failed": "Failed to update profile:",
      "image_upload_failed": "Failed to upload image:",
      "search_failed": "Failed to fetch search results",
      "load_more_failed": "Failed to load more movies",
      'invalid_email': 'Invalid email format. Please enter a valid email.',
      'user_not_found': 'No user found with this email. Please sign up first.',
      'wrong_password': 'Incorrect password. Please try again.',
      'user_disabled': 'Your account has been disabled. Contact support.',
      'email_already_in_use':
          'This email is already registered. Try logging in.',
      'weak_password': 'Password is too weak. Use at least 6 characters.',
      'too_many_requests': 'Too many attempts. Try again later.',
      'network_request_failed': 'Network error. Please check your connection.',
      'unexpected_error': 'An unexpected error occurred. Please try again.',
      'iap_unavailable': 'In-app purchases are not available.',
      'product_not_found': 'Product not found.',
      'purchase_failed': 'Purchase failed. Please try again.',
      'premium_activated': 'Premium Activated! Enjoy your benefits.',
      'billing_unavailable': 'Billing system is unavailable. Try again later.',
      'developer_error': 'Developer error occurred. Contact support.',
      'item_unavailable': 'This item is currently unavailable.',
      'user_canceled': 'Purchase was canceled.',
      'service_disconnected': 'Service was disconnected. Retry purchase.',
      'unexpected_iap_error': 'An unexpected error occurred during purchase.',
      'favorite_movies': 'Favorite Movies',
      "delete_account": "Delete Account",
      "delete_account_confirmation":
          "Are you sure you want to delete your account? This action cannot be undone.",
      "account_deleted": "Your account has been deleted successfully.",
      "account_deletion_failed": "Failed to delete account. Please try again.",
      "confirm": "Confirm",
      "cancel": "Cancel",
    },
    'ar': {
      'app_title': 'رفيق الأفلام',
      'login': 'تسجيل الدخول',
      'signup': 'إنشاء حساب',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'username': 'اسم المستخدم',
      'retype_password': 'أعد إدخال كلمة المرور',
      'enter_email': 'يرجى إدخال بريد إلكتروني صالح!',
      'enter_password': 'يرجى إدخال كلمة المرور!',
      'enter_username': 'يرجى إدخال اسم المستخدم!',
      'reenter_password': 'يرجى إعادة إدخال كلمة المرور!',
      'passwords_not_match': 'كلمات المرور غير متطابقة!',
      'already_have_account': 'لديك حساب بالفعل؟ سجل الدخول!',
      'dont_have_account': 'ليس لديك حساب؟ سجل الآن!',
      'camera': 'الكاميرا',
      'gallery': 'المعرض',
      'add_profile_image': 'إضافة صورة للملف الشخصي',
      'pick_image': 'يرجى اختيار صورة الملف الشخصي!',
      'home': 'الرئيسية',
      'favorites': 'المفضلة',
      'settings': 'الإعدادات',
      'profile': 'الملف الشخصي',
      'language': 'اللغة',
      'logout': 'تسجيل الخروج',
      'logout_message': 'تم تسجيل خروجك.',
      'sidebar_version': 'الإصدار 1.0.0',
      'top_rated': 'الأعلى تقييماً',
      'recent_movies': 'أحدث الأفلام',
      'trending': 'الشائع',
      'action': 'أفلام الأكشن',
      'horror': 'أفلام الرعب',
      'drama': 'أفلام الدراما',
      'romance': 'أفلام الرومانسية',
      'thriller': 'أفلام الإثارة',
      'see_all': 'عرض الكل',
      'search_movies': 'ابحث عن الأفلام...',
      'save_changes': 'حفظ التغييرات',
      'watch_trailer': 'مشاهدة الإعلان',
      'translating': 'جارٍ الترجمة...',
      'cast': 'طاقم العمل:',
      'overview': 'ملخص:',
      "release_date": "تاريخ الإصدار:",
      "movie_trailer": "إعلان الفيلم",
      "success": "نجاح",
      "account_created": "تم إنشاء الحساب بنجاح!",
      "error": "خطأ",
      "something_went_wrong": "حدث خطأ ما",
      "user_data_not_found": "لم يتم العثور على بيانات المستخدم في Firestore.",
      "logged_in_successfully": "تم تسجيل الدخول بنجاح!",
      "login_failed": "فشل تسجيل الدخول",
      "an_error_occurred": "حدث خطأ",
      "signed_out_successfully": "تم تسجيل الخروج بنجاح!",
      "profile_updated": "تم تحديث الملف الشخصي بنجاح!",
      "profile_update_failed": "فشل في تحديث الملف الشخصي:",
      "image_upload_failed": "فشل في تحميل الصورة:",
      "search_failed": "فشل في جلب نتائج البحث",
      "load_more_failed": "فشل في تحميل المزيد من الأفلام",
      'invalid_email':
          'تنسيق البريد الإلكتروني غير صالح. الرجاء إدخال بريد صحيح.',
      'user_not_found':
          'لم يتم العثور على مستخدم بهذا البريد. الرجاء التسجيل أولاً.',
      'wrong_password': 'كلمة المرور غير صحيحة. يرجى المحاولة مرة أخرى.',
      'user_disabled': 'تم تعطيل حسابك. يرجى التواصل مع الدعم.',
      'email_already_in_use':
          'البريد الإلكتروني مستخدم بالفعل. جرب تسجيل الدخول.',
      'weak_password': 'كلمة المرور ضعيفة جدًا. استخدم على الأقل 6 أحرف.',
      'too_many_requests': 'محاولات كثيرة جدًا. يرجى المحاولة لاحقًا.',
      'network_request_failed': 'خطأ في الشبكة. يرجى التحقق من الاتصال.',
      'unexpected_error': 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.',
      'iap_unavailable': 'عمليات الشراء داخل التطبيق غير متاحة.',
      'product_not_found': 'لم يتم العثور على المنتج.',
      'purchase_failed': 'فشل الشراء. يرجى المحاولة مرة أخرى.',
      'premium_activated': 'تم تفعيل البريميوم! استمتع بالمزايا.',
      'billing_unavailable': 'نظام الفوترة غير متاح حاليًا. حاول لاحقًا.',
      'developer_error': 'حدث خطأ في التطوير. تواصل مع الدعم.',
      'item_unavailable': 'هذا العنصر غير متاح حاليًا.',
      'user_canceled': 'تم إلغاء عملية الشراء.',
      'service_disconnected': 'تم قطع الخدمة. أعد المحاولة.',
      'unexpected_iap_error': 'حدث خطأ غير متوقع أثناء الشراء.',
      'favorite_movies': 'الأفلام المفضلة',
      "delete_account": "حذف الحساب",
      "delete_account_confirmation":
          "هل أنت متأكد أنك تريد حذف حسابك؟ لا يمكن التراجع عن هذا الإجراء.",
      "account_deleted": "تم حذف حسابك بنجاح.",
      "account_deletion_failed": "فشل في حذف الحساب. يرجى المحاولة مرة أخرى.",
      "confirm": "تأكيد",
      "cancel": "إلغاء",
    },
  };
}
