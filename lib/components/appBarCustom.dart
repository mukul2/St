import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:connect/Screens/notificationScreen.dart';
import 'package:connect/Screens/settingScreen.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/textStyleConst.dart';
import 'package:connect/utils/themeManager.dart';

class AppBarCustom extends StatefulWidget {
  final appbarTitle;
  const AppBarCustom({Key? key,required this.appbarTitle}) : super(key: key);

  @override
  _AppBarCustomState createState() => _AppBarCustomState();
}

class _AppBarCustomState extends State<AppBarCustom> {

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    //------------------Common Appbar with different Title for all screens------------------
    return AppBar(

      elevation: 1,
      backgroundColor: ThemeManager().getWhiteColor,
      centerTitle: true,
      leadingWidth: width * 0.15,

      //------------------BlueTooth icon----------------------------
      leading: Container(
        padding: EdgeInsets.all(height * 0.0135),
        margin: EdgeInsets.only(left: width*0.035),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ThemeManager().getDarkBlueColor, //ThemeManager().getDarkBlueColor,
        ),
        child: SvgPicture.asset(
          ("assets/svg/bluetoothIcon.svg"),
        ),
      ),

      //------------------Title----------------------------
      title: Text(
        widget.appbarTitle,
        style: interBold.copyWith(
            color: ThemeManager().getBlackColor),
      ),

      actions: [

        //-----------------------Setting Icon--------------------
        GestureDetector(
          onTap: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SettingScreen()));
          },
          child: Container(
            margin: EdgeInsets.only(right: width * 0.06),
            child: Row(
              children: [
                SvgPicture.asset(
                  ("assets/svg/settingIcon.svg"),
                  fit: BoxFit.cover,
                ),

                //------------------------Notification icon---------------
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationScreen()));
                  },
                  child: Container(
                      margin: EdgeInsets.only(left: width * 0.05),
                      child: SvgPicture.asset(
                        ("assets/svg/notificationIcon.svg"),
                        fit: BoxFit.cover,
                      )
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
