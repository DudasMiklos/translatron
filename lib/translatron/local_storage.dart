import 'dart:ui';
import 'dart:io';
import 'package:translatron/translatron.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<void> loadLanguage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Object? value = sharedPreferences.get("prometheusLang");
    String? lang;
    if (value != null) {
      lang = (value as String);
      TranslatronLocalization.setSelectedLanguageLocale = Locale(lang);
    } else {
      lang = Platform.localeName.substring(0, 2);
      await presistLanguage(lang);
      TranslatronLocalization.setSelectedLanguageLocale = Locale(lang);
    }
  }

  static Future<void> presistLanguage(String lang) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("prometheusLanguage", lang);
  }

  static Future<String> loadLanguageVersion() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Object? value = sharedPreferences.get("prometheusLanguageVersion");
    String? langVersion;
    if (value == null) {
      langVersion = "0.0.1";
      presistLanguageVersion(langVersion);
    } else {
      langVersion = (value as String);
    }
    return langVersion;
  }

  static Future<void> presistLanguageVersion(String langVersion) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("prometheusLanguageVersion", langVersion);
  }
}
