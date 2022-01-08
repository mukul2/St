import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/textConst.dart';
import 'package:connect/utils/textStyleConst.dart';
import 'package:connect/utils/themeManager.dart';

class OverLoadScreen extends StatefulWidget {

  @override
  _OverLoadScreenState createState() => _OverLoadScreenState();
}

class _OverLoadScreenState extends State<OverLoadScreen> {

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    // return Dialog(
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(2),
    //   ),
    //   elevation: 0,
    //   backgroundColor: Colors.white,
    //   child: Container(
    //     margin: EdgeInsets.only(top: height * 0.28,left: height * 0.027,right: height * 0.027),
    //     height: height * 0.45,
    //     width: width,
    //     child: Column(
    //       children: [
    //
    //         //------------------ Warning Image ---------------------------------
    //         Image(image: AssetImage("assets/icons/warningIcon.png")),
    //
    //         //------------------ OverLoad and Remove Load text----------------------------
    //         Container(
    //           margin: EdgeInsets.only(top: height * 0.03,),
    //           color: ThemeManager().getRedColor,
    //           height: height * 0.19,
    //           width: width,
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               Text(TextConst.overLoadText, style: interBold.copyWith(
    //                 color: ThemeManager().getWhiteColor,
    //                 fontSize: width * 0.099,
    //               ),),
    //               Text(TextConst.removeLoadText, style: interMedium.copyWith(
    //                 color: ThemeManager().getWhiteColor,
    //                 fontSize: width * 0.075,
    //               ),),
    //             ],
    //           ),
    //         ),
    //
    //         //------------------ Waiting for remove load text -----------------------
    //         Container(
    //           margin: EdgeInsets.only(top: height * 0.03,left: width * 0.085,right: width * 0.05),
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               SvgPicture.asset(
    //                 ("assets/svg/scanningIcon.svg"),
    //                 fit: BoxFit.cover,
    //                 height: height * 0.039,
    //                 color: ThemeManager().getDarkGrey3Color,
    //               ),
    //               Text(TextConst.waitingForLoadToBeRemovedText, style: interSemiBold.copyWith(
    //                 color: ThemeManager().getDarkGrey3Color,
    //                 fontSize: width * 0.038,
    //               ),),
    //             ],
    //           ),
    //
    //         ),
    //       ],
    //     ),
    //
    //   ),
    // );
    return Scaffold(
      backgroundColor: ThemeManager().getWhiteColor,

      body: Container(
        margin: EdgeInsets.only(top: height * 0.28,left: height * 0.027,right: height * 0.027),
        height: height * 0.45,
        width: width,
        child: Column(
          children: [

            //------------------ Warning Image ---------------------------------
            Image(image: AssetImage("assets/icons/warningIcon.png")),

            //------------------ OverLoad and Remove Load text----------------------------
            Container(
              margin: EdgeInsets.only(top: height * 0.03,),
              color: ThemeManager().getRedColor,
              height: height * 0.19,
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(TextConst.overLoadText, style: interBold.copyWith(
                    color: ThemeManager().getWhiteColor,
                    fontSize: width * 0.099,
                  ),),
                  Text(TextConst.removeLoadText, style: interMedium.copyWith(
                    color: ThemeManager().getWhiteColor,
                    fontSize: width * 0.075,
                  ),),
                ],
              ),
            ),

            //------------------ Waiting for remove load text -----------------------
            Container(
              margin: EdgeInsets.only(top: height * 0.03,left: width * 0.085,right: width * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(
                    ("assets/svg/scanningIcon.svg"),
                    fit: BoxFit.cover,
                    height: height * 0.039,
                    color: ThemeManager().getDarkGrey3Color,
                  ),
                  Text(TextConst.waitingForLoadToBeRemovedText, style: interSemiBold.copyWith(
                    color: ThemeManager().getDarkGrey3Color,
                    fontSize: width * 0.038,
                  ),),
                ],
              ),

            ),
          ],
        ),

      ),
    );
  }
}
