import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void toggleLocale() {
    if (_locale.languageCode == 'en') {
      _locale = const Locale('am');
    } else {
      _locale = const Locale('en');
    }
    notifyListeners();
  }
}
