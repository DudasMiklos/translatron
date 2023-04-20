import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:translatron/translatron.dart';

class Api {
  static Future<Map<String, dynamic>> fetchTranslationVersion() async {
    final response = await http.get(
      Uri.parse(TranslatronLocalization.getHostname +
          TranslatronLocalization.getVersionPath),
      headers: TranslatronLocalization.getApiHeaders,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data'); //TODO
    }
  }

  static Future<Map<String, dynamic>> fetchTranslations() async {
    final response = await http.get(
      Uri.parse(TranslatronLocalization.getHostname +
          TranslatronLocalization.getTranslationsPath),
      headers: TranslatronLocalization.getApiHeaders,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data'); //TODO
    }
  }
}
