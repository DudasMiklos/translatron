import 'dart:core';
import 'package:flutter/widgets.dart';
import 'package:translatron/translatron.dart';

class TranslatronLocalizationDelegate
    extends LocalizationsDelegate<TranslatronLocalization> {
  const TranslatronLocalizationDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['hu', 'en'].contains(locale.languageCode);
  }

  @override
  Future<TranslatronLocalization> load(Locale locale) async {
    TranslatronLocalization localizations = TranslatronLocalization(locale);

    await localizations.load();

    return localizations;
  }

  @override
  bool shouldReload(LocalizationsDelegate<TranslatronLocalization> old) {
    return false;
  }
}
