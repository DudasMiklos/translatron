import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:translatron/exception/exceptions/wrong_api_response_exception.dart';
import 'package:translatron/translatron.dart';

class Api {
  ///Fetched the newest translation version code from the provided **versionPath**
  ///returns [Future<Map<String, dynamic>>]
  ///Throws a [WrongApiResponseException] if there is response status was not 200
  static Future<Map<String, dynamic>?> fetchTranslationVersion() async {
    try {
      final response = await http.get(
        Uri.parse(Translatron.getHostname + Translatron.getVersionPath),
        headers: Translatron.getApiHeaders,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw WrongApiResponseException();
      }
    } catch (e) {
      // ExceptionHandler.returnException(e);
      return null;
    }
  }

  ///Fetched the newest translation from the provided **translationsPath**
  ///returns [Future<Map<String, dynamic>>]
  ///Throws an [WrongApiResponseException] if there is response status was not 200
  static Future<Map<String, dynamic>?> fetchTranslations() async {
    try {
      final response = await http.get(
        Uri.parse(Translatron.getHostname + Translatron.getTranslationsPath),
        headers: Translatron.getApiHeaders,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw WrongApiResponseException();
      }
    } catch (e) {
      // ExceptionHandler.returnException(e);
      return null;
    }
  }
}
