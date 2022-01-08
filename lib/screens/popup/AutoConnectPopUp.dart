
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:connect/screens/dashboardScreen.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/textConst.dart';
import 'package:connect/utils/textStyleConst.dart';
import 'package:connect/utils/themeManager.dart';

class AutoConnectPopUp extends StatefulWidget {
  Function(bool) conenctionCallback;
  String title;

  AutoConnectPopUp({required this.conenctionCallback,required this.title});

  @override
  _DeleteTestPopUpState createState() => _DeleteTestPopUpState();
}

class _DeleteTestPopUpState extends State<AutoConnectPopUp> {

  @override
  Widget build(BuildContext context) {
    height=MediaQuery.of(context).size.height;
    width=MediaQuery.of(context).size.width;

    //-------------------------Alert dialog box--------------------------
      return Dialog(

        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),

        child: Wrap(

         // crossAxisAlignment: CrossAxisAlignment.m,
          children: [

            Container(height: 50,
              child: Stack(children: [
                Align(alignment: Alignment.centerRight,child:  Container(
                  margin: EdgeInsets.only(
                      top: height * 0.01,
                      left: width * 0.04,
                      right: width * 0.04),

                  child: GestureDetector(
                      onTap: () {
                        widget.conenctionCallback(false);
                        Navigator.pop(context);
                      },

                      child: Icon(
                        Icons.clear,
                        size: width * 0.06,
                        color: ThemeManager().getLightGrey2Color,
                      )),
                ),),
                Align(alignment: Alignment.centerLeft,child: Padding(
                  padding:  EdgeInsets.fromLTRB(20, 0,0, 0),
                  child: Text(widget.title,style: interBold.copyWith(
                      color: ThemeManager().getBlackColor,
                    fontSize: width * 0.040),),
                ),),
              ],),
            ),



            Container(
            //  margin: EdgeInsets.only(top: height * 0.015),
              height: height * 0.001,
              color: ThemeManager().getBlackColor.withOpacity(0.19),
            ),

            Container(
              margin: EdgeInsets.only(
                  top: height * 0.02,
                  left: width * 0.04,
                  right: width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  //----------------------Alert text-------------------
                  Text("Do you want to connect?",
                      style: interBold.copyWith(
                      color: ThemeManager().getPopUpTextGreyColor,
                      fontSize: width * 0.038)),

                  Container(
                    margin: EdgeInsets.only(top: height*0.03,bottom: height*0.04),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: (){
                            widget.conenctionCallback(true);
                            Navigator.pop(context);

                        },
                          child: Container(
                            height: height * 0.065,
                            width: width*0.33,
                            decoration: BoxDecoration(
                                color: ThemeManager().getDarkGreenColor,
                                borderRadius:
                                BorderRadius.circular(width * 0.014)),
                            alignment: Alignment.center,
                            child: Text(
                              TextConst.yesText,
                              style: interSemiBold.copyWith(
                                  fontSize: width * 0.045,
                                  color: ThemeManager().getWhiteColor),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            widget.conenctionCallback(false);
                            Navigator.pop(context);
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: width*0.04),
                            height: height * 0.065,
                            width: width*0.33,
                            decoration: BoxDecoration(
                                color: ThemeManager().getLightGrey6Color,
                                borderRadius:
                                BorderRadius.circular(width * 0.014)),
                            alignment: Alignment.center,
                            child: Text(
                              TextConst.noText,
                              style: interSemiBold.copyWith(
                                  fontSize: width * 0.045,
                                  color: ThemeManager().getLightGrey7Color),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  }
}
