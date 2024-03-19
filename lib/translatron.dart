library translatron;

import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:translatron/exception/exception_handler.dart';
import 'package:translatron/exception/exceptions/missing_api_params_exception.dart';
import 'package:translatron/exception/exceptions/wrong_api_response_exception.dart';
import 'package:translatron/translatron/api.dart';
import 'package:translatron/translatron/delegate.dart';
import 'package:translatron/translatron/file_storage.dart';
import 'package:translatron/translatron/local_storage.dart';
import 'package:translatron/translatron/utils.dart';

class Translatron {
  ///Stores the selected [Locale]
  static late Locale? _selectedLocale;

  ///Stores the current [Locale] defaults to, system language
  Locale locale = Locale(Platform.localeName.substring(0, 2));

  ///Stores the hostname[String] for api calls
  static late String _hostname;

  ///Stores the versionPath[String] for api calls
  static late String _versionPath;

  ///Stores the translationsPath[String] for api calls
  static late String _translationsPath;

  ///Stores the supported locales inside [List<Locale>]
  static late List<Locale> _supportedLocales;

  ///Stores the custom api headers inside [Map<String, String>?]
  static late Map<String, String>? _apiHeaders;

  ///Stores the reLoadAtStart[bool] for reload assets at start
  static late bool _reLoadAtStart;

  ///Nothing to see here
  Translatron(this.locale);

  ///Nothing to see here
  static const LocalizationsDelegate<Translatron> delegate =
      TranslatronDelegate();

  ///Returns the value of the key that was provided
  ///Excepts [String] containing the translation key
  ///Example:
  /// ```dart
  /// Translatron.of(context)!.translate("translation.key");
  /// ```
  static Translatron? of(BuildContext context) {
    return Localizations.of<Translatron>(context, Translatron);
  }

  /// Returns the selected [Locale]
  static Locale? get getSelectedLanguageLocale {
    return _selectedLocale;
  }

  /// Returns the reLoadAtStart [bool]
  static bool? get reLoadAtStart {
    return _reLoadAtStart;
  }

  /// Retruns the selected language code, example **hu** or **en**
  static String? get getSelectedLanguageCode {
    return _selectedLocale?.languageCode.toLowerCase();
  }

  /// Sets the selected language [Locale]
  /// Excepts [Locale]
  static set setSelectedLanguageLocale(Locale newLocale) {
    LocalStorage.persistLanguage(newLocale.languageCode.toLowerCase());
    _selectedLocale = newLocale;
  }

  /// Returns the hostname
  static String get getHostname {
    return _hostname;
  }

  /// Returns the hostname
  static String get getTranslationsPath {
    return _translationsPath;
  }

  /// Returns the hostname
  static String get getVersionPath {
    return _versionPath;
  }

  /// Returns the supported **Locales** in a [List<Locale>].
  static List<Locale> get getSupportedLocales {
    return _supportedLocales;
  }

  /// Returns the setted apiHeaders **Locales** in a Map<String, String>?
  static Map<String, String>? get getApiHeaders {
    return _apiHeaders;
  }

  /// Returns a [bool], if the language is active, for input use Language code in [String], example **hu**
  static bool isLanguageActice(String languageCode) {
    return getSelectedLanguageCode == languageCode;
  }

  /// Initalizes the Library
  /// for input you must provide:
  /// - [String] hostname         -> for example https://example.com
  /// - [String] versionPath      -> for example /api/translation/version
  /// - [String] translationsPath -> for example /api/translation/translations
  /// Optional parameters:
  /// - [List<Locale>] supportedLocales   -> defaults to: [Locale('hu')]
  /// - [Map<String, String>?] apiHeaders -> usage: set custom api headers for example auth Token,  defaults to: null
  static Future<void> init({
    String hostname = "",
    String versionPath = "",
    String translationsPath = "",
    List<Locale> supportedLocales = const [Locale('hu')],
    Map<String, String>? apiHeaders,
    bool hasWebServer = false,
    bool reLoadAtStart = false,
  }) async {
    _hostname = hostname;
    _versionPath = versionPath;
    _translationsPath = translationsPath;
    _supportedLocales = supportedLocales;
    _apiHeaders = apiHeaders;
    _reLoadAtStart = reLoadAtStart;
    await LocalStorage.loadLanguage();
    try {
      if (hasWebServer &&
          hostname.isNotEmpty &&
          versionPath.isNotEmpty &&
          translationsPath.isNotEmpty) {
        final bool isNewVersionAvailable = await Utils.isNewVersionAvailable();
        if (isNewVersionAvailable) {
          Map<String, dynamic>? magick = await Api.fetchTranslations();
          if (magick == null) {
            throw WrongApiResponseException();
          }
          for (var locale in supportedLocales) {
            FileStorage.saveLanguage(
                locale, jsonEncode(magick["data"][locale.languageCode]));
          }
        }
        LocalStorage.persistLanguageVersion(Utils.getTranslationVersion);
      } else if (hasWebServer && hostname.isEmpty ||
          versionPath.isEmpty ||
          translationsPath.isEmpty) {
        hasWebServer = false;
        throw MissingApiParamsException();
      }
    } catch (e) {
      ExceptionHandler.returnException(e);
    }
  }

  ///Stores the localized strings
  static Map<String, String>? _localizedStrings;

  ///Provide a load method, only used inside [TranslatronDelegate]
  Future<bool> load() async {
    _localizedStrings = await FileStorage.loadLanguage(locale);
    return true;
  }

  ///Returns the value of the key thats was provided
  ///Excepts [String] containing the translation key
  ///Example:
  /// ```dart
  /// Translatron.of(context)!.translate("translation.key");
  /// ```
  String translate(String key) {
    return _localizedStrings![key] ?? "";
  }
}
