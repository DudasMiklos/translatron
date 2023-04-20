library translatron;

import 'dart:convert';
import 'dart:core';
import 'package:flutter/widgets.dart';
import 'package:translatron/translatron/api.dart';
import 'package:translatron/translatron/delegate.dart';
import 'package:translatron/translatron/file_storage.dart';
import 'package:translatron/translatron/local_storage.dart';
import 'package:translatron/translatron/utils.dart';

class TranslatronLocalization {
  static late Locale? _selectedLocale;
  Locale locale = const Locale('hu');

  static late String _hostname;
  static late String _versionPath;
  static late String _translationsPath;

  static late List<Locale> _supportedLocales;
  static late Map<String, String>? _apiHeaders;

  TranslatronLocalization(this.locale);

  static const LocalizationsDelegate<TranslatronLocalization> delegate =
      TranslatronLocalizationDelegate();

  static TranslatronLocalization? of(BuildContext context) {
    return Localizations.of<TranslatronLocalization>(
        context, TranslatronLocalization);
  }

  static Locale? get getSelectedLanguageLocale {
    return _selectedLocale;
  }

  static String? get getSelectedLanguageCode {
    return _selectedLocale?.languageCode.toLowerCase();
  }

  static set setSelectedLanguageLocale(Locale newLocale) {
    LocalStorage.presistLanguage(newLocale.languageCode.toLowerCase());
    _selectedLocale = newLocale;
  }

  static String get getHostname {
    return _hostname;
  }

  static String get getTranslationsPath {
    return _translationsPath;
  }

  static String get getVersionPath {
    return _versionPath;
  }

  static List<Locale> get getSupportedLocales {
    return _supportedLocales;
  }

  static Map<String, String>? get getApiHeaders {
    return _apiHeaders;
  }

  static bool isLanguageActice(String languageCode) {
    return getSelectedLanguageCode == languageCode;
  }

  //supportedLanguages defaults to hu only
  static Future<void> init({
    required String hostname,
    required String versionPath,
    required String translationsPath,
    List<Locale> supportedLocales = const [Locale('hu')],
    Map<String, String>? apiHeaders,
  }) async {
    _hostname = hostname;
    _versionPath = versionPath;
    _translationsPath = translationsPath;
    _supportedLocales = supportedLocales;
    _apiHeaders = apiHeaders;
    await LocalStorage.loadLanguage();
    final bool isNewVersionAvailable = await Utils.isNewVersionAvailable();
    if (isNewVersionAvailable) {
      Map<String, dynamic> magick = await Api.fetchTranslations();
      for (var locale in supportedLocales) {
        FileStorage.saveLanguage(
            locale, jsonEncode(magick["data"][locale.languageCode]));
      }
    }
    LocalStorage.presistLanguageVersion(Utils.getTranslationVersion);
  }

  static Map<String, String>? _localizedStrings;

  Future<bool> load() async {
    _localizedStrings = await FileStorage.loadLanguage(locale);
    return true;
  }

  String translate(String key) {
    return _localizedStrings![key] ?? "";
  }
}
