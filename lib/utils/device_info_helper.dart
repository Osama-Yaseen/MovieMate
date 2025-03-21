import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class DeviceInfoHelper {
  static Future<int> getAndroidVersion() async {
    if (Platform.isAndroid) {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.sdkInt; // ✅ Returns Android SDK version
    }
    return 0; // Default value for non-Android devices
  }
}
