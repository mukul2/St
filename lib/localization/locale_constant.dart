import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:connect/main.dart';
import 'package:shared_preferences/shared_preferences.dart';




const String prefSelectedLanguageCode = "SelectedLanguageCode";

Future<Locale> setLocale(String languageCode) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(prefSelectedLanguageCode, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String languageCode = _prefs.getString(prefSelectedLanguageCode) ?? "en";
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  return languageCode != null && languageCode.isNotEmpty
      ? Locale(languageCode, '')
      : Locale('en', '');
}

void changeLanguage(BuildContext context, String? selectedLanguageCode) async {
  if(selectedLanguageCode!=null){
    var _locale = await setLocale(selectedLanguageCode);
    App.setLocale(context, _locale);
  }

}
