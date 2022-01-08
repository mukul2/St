
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:connect/screens/dashboardScreen.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/textConst.dart';
import 'package:connect/utils/textStyleConst.dart';
import 'package:connect/utils/themeManager.dart';

class DeleteTestPopUp extends StatefulWidget {
  String id;
  FirebaseFirestore firestore;
  DeleteTestPopUp({required this.id,required this.firestore});

  @override
  _DeleteTestPopUpState createState() => _DeleteTestPopUpState();
}

class _DeleteTestPopUpState extends State<DeleteTestPopUp> {

  @override
  Widget build(BuildContext context) {
    height=MediaQuery.of(context).size.height;
    width=MediaQuery.of(context).size.width;

    //-------------------------Alert dialog box--------------------------
      return Dialog(

        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),

        child: Wrap(
        //  crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                margin: EdgeInsets.only(
                    top: height * 0.01, left: width * 0.04, right: width * 0.04),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //-------------------------Header of dialogue box-----------------
                    Text(
                      "Delete",
                      style: interSemiBold.copyWith(
                        color: ThemeManager().getBlackColor,
                        fontSize: width * 0.039,
                      ),
                    ),

                    //----------------------Close icon-----------------------
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.clear,
                          size: width * 0.06,
                          color: ThemeManager().getLightGrey4Color,
                        )),
                  ],
                ),
              ),
            ),



            Container(
              margin: EdgeInsets.only(top: height * 0.015),
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
                  Text(TextConst.areYouSureText,
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
                            widget.firestore
                              .collection("pulltest")
                              .doc(widget.id)
                              .delete()
                              .then((value) {
                              print("deleted " + widget.id);
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            });
                            // Navigator.push(context,
                            //     MaterialPageRoute(
                            //       builder: (context) =>
                            //           BottomNavigationBarScreen(
                            //               initialBottomIndex: 2)));
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
