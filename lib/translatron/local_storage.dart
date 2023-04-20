import 'dart:ui';
import 'dart:io';
import 'package:translatron/translatron.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  ///Gets the current language code[String] (example.: **hu**) from [SharedPreferences] using the **translatronLang** key
  static Future<void> loadLanguage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Object? value = sharedPreferences.get("translatronLang");
    String? lang;
    if (value != null) {
      lang = (value as String);
      Translatron.setSelectedLanguageLocale = Locale(lang);
    } else {
      lang = Platform.localeName.substring(0, 2);
      await presistLanguage(lang);
      Translatron.setSelectedLanguageLocale = Locale(lang);
    }
  }

  ///Persists the current language code[String] (example.: **hu**) to [SharedPreferences] using the **translatronLang** key
  static Future<void> presistLanguage(String lang) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("translatronLanguage", lang);
  }

  ///Gets the current language version[String] from [SharedPreferences] using the **translatronLanguageVersion** key
  static Future<String> loadLanguageVersion() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Object? value = sharedPreferences.get("translatronLanguageVersion");
    String? langVersion;
    if (value == null) {
      langVersion = "0.0.1";
      presistLanguageVersion(langVersion);
    } else {
      langVersion = (value as String);
    }
    return langVersion;
  }

  ///Persist a new language version[String] into [SharedPreferences] using the **translatronLanguageVersion** key
  static Future<void> presistLanguageVersion(String langVersion) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("translatronLanguageVersion", langVersion);
  }
}
