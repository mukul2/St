import 'package:connect/utils/themeManager.dart';
import 'package:flutter/material.dart';

import 'utils/featureSettings.dart';

class AppThemeManager{
  var whiteColor = Color(0xffFFFFFF);
  var blackColor = Color(0xff000000);
  var darkGreenColor = Color(0xff095D4C);
  var lightGreenTextFieldColor = Color(0xffF2F2F2);
  var lightGreenNotificationColor = Color(0xffF6F6F6);
  var darkGreyColor = Color(0xff5A5A5A);
  var darkGrey2Color =Color(0xff5C5C5C);
  var darkGrey3Color = Color(0xff767676);
  var lightGrey1Color = Color(0xff8A8A8A);
  var lightGrey2Color = Color(0xffBABABA);
  var lightGrey3Color = Color(0xffCECECE);
  var lightGrey4Color = Color(0xff8F8F8F);
  var lightGrey5Color = Color(0xff939393);
  var lightGrey6Color = Color(0xffEFEFEF);
  var lightGrey7Color = Color(0xff7C7C7C);
  var lightGrey8Color = Color(0xffEAEAEA);
  var lightGrey9Color = Color(0xff969696);
  var lightGrey10Color = Color(0xffEFEFF4);
  var lightGrey11Color = Color(0xffD2D2D2);
  var lightGrey12Color = Color(0xffC4C4C4);
  var lightGrey13Color = Color(0xff7A7A7A);
  var lightGrey14Color = Color(0xffE8E8E8);
  var lightGreyTransColor = Color(0xE8E8E8E8);
  var darkGreyTextColor=Color(0xff818181);
  var popUpTextGreyColor = Color(0xff9CA3AF);
  var lightYellowColor = Color(0xffFFF4E2);

  var orangeGradientColor = Color(0xffFF7500);
  var yellowGradientColor = Color(0xffFFB400);

  var extraDarkBlueColor = Color(0xff130F26);
  var darkBlueColor = Color(0xff0D30B1);
  var redColor = Color(0xffC70000);
  var red1Color = Color(0xffDC474F);
  var greenColor = Color(0xff359630);
  var green1Color = Color(0xff34C759);

  var lightGreenColor = Color(0xffC5FFEC);
  var lightGreen1Color = Color(0xffF3F3F3);
  var lightBlueColor = Color(0xffEEF2FD);
  var lightOrangeColor = Color(0xffFFEFD6);
  var lightBottleGreenColor = Color(0xffD5F5FB);
  var lightRedColor = Color(0xffFFC9CC);
  var darkprimary = Color(0xff2C3E50);
  var darkAccent = Color(0xff2E2E2E);
  AppThemeManager();
  Color getBackGroudColor(){
   return darkTheme?blackColor:whiteColor;
  }
  Color getAppbarColor(){
   return darkTheme?darkAccent:whiteColor;
  }
  Color getDividerColor(){
   return darkTheme?whiteColor:blackColor;
  }
  Color getAppbarTextColor(){
   return darkTheme?whiteColor:blackColor;
  }

  Color getAppbarIconColor(){
   return darkTheme?whiteColor:blackColor;
  }
  Color getScaffoldBackgroundColor(){
   return darkTheme?blackColor:whiteColor;
  }

  Color getTextColor1(){
    return darkTheme?whiteColor:darkGreyColor;
  }
  Color getTextColor2(){
    return darkTheme?whiteColor:blackColor;
  }
  Color getAvatarPlaceholderColor(){
    return darkTheme?whiteColor:Colors.blue;
  }
  Color getGraphBackgroundColor(){
    return darkTheme?blackColor:whiteColor;
  }
  Color getGraphBorderColor(){
    return darkTheme?blackColor:whiteColor;
  }
  Color getGraphTextColor(){
    return darkTheme?whiteColor:blackColor;
  }

  Color getGraphTargetColor(){
    return darkTheme?whiteColor:blackColor;
  }

  Color getBottomNavColor(){
    return darkTheme?darkAccent:whiteColor;
  }
  Color getBottomNavIconDeactive(){
    return darkTheme?whiteColor:blackColor;
  }
  Color getRealTimeGraphBoxBackgroundColor(){
    return darkTheme?darkAccent:whiteColor;
  }
  Color getRealTimeGraphBoxLoadColor(){
    return darkTheme?whiteColor:blackColor;
  }
  Color getSearchBoxColor(){
    return darkTheme?Colors.grey.withOpacity(0.3): Colors.grey.shade200;
  }
  Color getSearchTextColor(){
    return darkTheme?whiteColor: Colors.grey;
  }

  Color getTabColor(){
    return darkTheme?Colors.grey.withOpacity(0.5): darkGreenColor;
  }
  Color getTabBaseColor(){
    return darkTheme?Colors.grey.withOpacity(0.2): whiteColor;
  }

  Color getTabTextColor(){
    return darkTheme?Colors.grey.withOpacity(0.2): whiteColor;
  }
  Color getPrimaryVsDarkTextColor(){
    return darkTheme?whiteColor: darkGreenColor;
  }
}