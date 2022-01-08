import 'package:flutter/material.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/textStyleConst.dart';
import 'package:connect/utils/themeManager.dart';

class ButtonView extends StatelessWidget {
  String buttonLabel;
  ButtonView({Key? key,required this.buttonLabel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Container(
        alignment: Alignment.center,
        height: height * 0.058,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height*0.008),
          color: ThemeManager().getDarkGreenColor,
        ),
        child: Text(
          buttonLabel,
          style: interSemiBold.copyWith(
              fontSize: width*0.04, color: ThemeManager().getWhiteColor),
        ));
  }
}
