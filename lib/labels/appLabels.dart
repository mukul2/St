


import 'package:flutter/material.dart';
import 'package:connect/localization/language/language_bn.dart';
import 'package:connect/localization/language/language_en.dart';

class AppLabels {
  Locale locale;

  AppLabels({required this.locale});

  Widget loginLabel()  {
    switch(locale.languageCode){
      case "bn":
        return Text(LanguageBn().labelLogin);
      case "en":
        return Text(LanguageEn().labelLogin);


        default:
          return Text(LanguageEn().labelLogin);
    }

  }


  Widget GlobalSearchLabel()  {
    switch(locale.languageCode){
      case "bn":
        return Text(LanguageBn().labelSearch);
      case "en":
        return Text(LanguageEn().labelSearch);


      default:
        return Text(LanguageEn().labelSearch);
    }

  }
  Widget TargetLoadLabel()  {
    switch(locale.languageCode){
      case "bn":
        return Text(LanguageBn().labelTargetValue);
      case "en":
        return Text(LanguageEn().labelTargetValue);


      default:
        return Text(LanguageEn().labelSearch);
    }

  }
}