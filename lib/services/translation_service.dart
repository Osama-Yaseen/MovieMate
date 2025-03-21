import 'dart:convert';
import 'package:http/http.dart' as http;

class TranslationService {
  static const String apiKey =
      "AIzaSyCbSljDXHoXZnJGPebB_tzdpzUt2kYzrS0"; // Replace with your API Key
  static const String apiUrl =
      "https://translation.googleapis.com/language/translate/v2";

  /// 🌍 Translate Text from Any Language to Target Language (e.g., Arabic "ar")
  static Future<String> translateText(String text, String targetLang) async {
    if (text.isEmpty) return text; // If empty, return as is

    final response = await http.post(
      Uri.parse("$apiUrl?key=$apiKey"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"q": text, "target": targetLang, "format": "text"}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data["data"]["translations"][0]["translatedText"];
    } else {
      throw Exception("Translation failed: ${response.statusCode}");
    }
  }
}
