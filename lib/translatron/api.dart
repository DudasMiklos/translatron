import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:translatron/translatron.dart';

class Api {
  ///Fetched the newest translation version code from the provided **versionPath**
  ///returns [Future<Map<String, dynamic>>]
  ///Throws an [Exception] if there is response status wasnt 200
  static Future<Map<String, dynamic>> fetchTranslationVersion() async {
    final response = await http.get(
      Uri.parse(Translatron.getHostname + Translatron.getVersionPath),
      headers: Translatron.getApiHeaders,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  ///Fetched the newest translation from the provided **translationsPath**
  ///returns [Future<Map<String, dynamic>>]
  ///Throws an [Exception] if there is response status wasnt 200
  static Future<Map<String, dynamic>> fetchTranslations() async {
    final response = await http.get(
      Uri.parse(Translatron.getHostname + Translatron.getTranslationsPath),
      headers: Translatron.getApiHeaders,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data'); //TODO
    }
  }
}
