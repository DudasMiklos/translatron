import 'dart:core';

import 'package:flutter/widgets.dart';
import 'package:translatron/translatron.dart';

class TranslatronDelegate extends LocalizationsDelegate<Translatron> {
  ///Not too interesting
  const TranslatronDelegate();

  /// Whether resources for the given locale can be loaded by this delegate.
  ///
  /// Return true if the instance of `T` loaded by this delegate's [load]
  /// method supports the given `locale`'s language.
  @override
  bool isSupported(Locale locale) {
    return Translatron.getSupportedLocales.contains(locale);
  }

  /// Start loading the resources for `locale`. The returned future completes
  /// when the resources have finished loading.
  ///
  /// It's assumed that this method will return an object that contains a
  /// collection of related string resources (typically defined with one method
  /// per resource). The object will be retrieved with [Localizations.of].
  @override
  Future<Translatron> load(Locale locale) async {
    Translatron localizations = Translatron(locale);

    await localizations.load();

    return localizations;
  }

  /// Returns true if the resources for this delegate should be loaded
  /// again by calling the [load] method.
  ///
  /// This method is called whenever its [Localizations] widget is
  /// rebuilt. If it returns true then dependent widgets will be rebuilt
  /// after [load] has completed.
  @override
  bool shouldReload(LocalizationsDelegate<Translatron> old) {
    return false;
  }
}
