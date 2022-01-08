
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:connect/components/buttonView.dart';
import 'package:connect/Activities/CalibrationUI/calibrationCalculatedCoefficientsScreen.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/textConst.dart';
import 'package:connect/utils/textStyleConst.dart';
import 'package:connect/utils/themeManager.dart';

class CalibrationVerificationCheckAddAndSaveGaugeValueScreen
    extends StatefulWidget {
  const CalibrationVerificationCheckAddAndSaveGaugeValueScreen({Key? key})
      : super(key: key);

  @override
  _CalibrationVerificationCheckAddAndSaveGaugeValueScreenState
      createState() =>
      _CalibrationVerificationCheckAddAndSaveGaugeValueScreenState();
}

class _CalibrationVerificationCheckAddAndSaveGaugeValueScreenState
    extends State<CalibrationVerificationCheckAddAndSaveGaugeValueScreen> {

  List gaugeData=[
    {
      "Gauge Value":"10.0",
      "Ref Value(kN)":"10",
    },
    {
      "Gauge Value":"20.0",
      "Ref Value(kN)":"20",
    },
    {
      "Gauge Value":"30.0",
      "Ref Value(kN)":"30",
    },
    {
      "Gauge Value":"40.0",
      "Ref Value(kN)":"40.3",
    },
  ];

  bool showInputRefValGaugeValScreen = false;
  int startTimer = 1;

  void  _startTimer() {
    const oneSec = const Duration(seconds: 3);
    Timer.periodic(oneSec,
          (Timer timer) => mounted?
      setState(()
      {
        if (startTimer < 1) {
          timer.cancel();
        } else {
          startTimer = startTimer - 1;
        }
      },
      ):null,
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return showInputRefValGaugeValScreen == false
        ? verificationCheckGaugeValueScreenView()
        : inputRefValueGaugeValueScreenView();


  }

  Widget verificationCheckGaugeValueScreenView(){
    return Column(
      children: [
        Container(
          color: ThemeManager().getLightGreenColor,
          height: height * 0.061,
          child: Container(
            margin: EdgeInsets.only(
              left: width * 0.05,
              right: width * 0.05,
            ),
            child: Row(
              children: [
                //------------------Back button---------
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CalibrationCalculatedCoefficientsScreen()));
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_back_ios,
                        size: width * 0.043,
                        color: ThemeManager().getDarkGreenColor,
                      ),
                      Text(
                        TextConst.backText,
                        style: interMedium.copyWith(
                            color: ThemeManager().getDarkGreenColor,
                            fontSize: width * 0.043),
                      ),
                    ],
                  ),
                ),

                //-----------------Input Ref. values Header text------
                Container(
                  margin: EdgeInsets.only(
                    left: width * 0.15,
                  ),
                  child: Text(
                    TextConst.verificationCheckText,
                    style: interSemiBold.copyWith(
                        color: ThemeManager().getBlackColor,
                        fontSize: width * 0.043),
                  ),
                ),
              ],
            ),
          ),
        ),

        Container(
          margin: EdgeInsets.only(
            left: width * 0.057,
            right: width * 0.057,
            top: height * 0.02,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //------Raw value text-----
              Text(
                "Gauge Value",
                style: interSemiBold.copyWith(
                    color: ThemeManager().getBlackColor,
                    fontSize: width * 0.040),
              ),

              //------Ref value text-----
              Text(
                "Ref Value(kN)",
                style: interSemiBold.copyWith(
                    color: ThemeManager().getBlackColor,
                    fontSize: width * 0.040),
              ),
            ],
          ),
        ),

        Container(
          margin: EdgeInsets.only(top: height * 0.015),
          height: height * 0.0009,
          color: ThemeManager().getBlackColor.withOpacity(0.15),
        ),

        //---------------- Add Ref Value button ------------
        GestureDetector(
          onTap: () {
            addRefGaugeValuePopUp();
          },
          child: Container(
              margin: EdgeInsets.only(
                left: width * 0.057,
                right: width * 0.057,
                top: height * 0.03,
              ),
              height: height * 0.065,
              width: width,
              child: ButtonView(buttonLabel: TextConst.addRefValueText)),
        ),
      ],
    );
  }

  addRefGaugeValuePopUp() {
    showDialog(
      context: context,
      builder: (context)
      {
        return AlertDialog(
          scrollable: true,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          contentPadding: EdgeInsets.only(top: 10.0),

          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Container(
                margin: EdgeInsets.only(
                    top: height * 0.01,
                    left: width * 0.04,
                    right: width * 0.04),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    //------PopUp header Add Ref. value text--
                    Text(
                      TextConst.addRefValueDialogText,
                      style: interSemiBold.copyWith(
                        color: ThemeManager().getBlackColor,
                        fontSize: width * 0.045,
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          setState(() {
                            showInputRefValGaugeValScreen=false;
                          });
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.clear,
                          size: width * 0.06,
                          color: ThemeManager().getLightGrey4Color,
                        )),
                  ],
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        //---------Current Raw value text-------
                        Text(
                          TextConst.currentGaugeValueText,
                          style: interMedium.copyWith(
                            color: ThemeManager().getPopUpTextGreyColor,
                            fontSize: width * 0.036,
                          ),
                        ),

                        //-------Current Raw value data-------
                        Text(
                          "50.1",
                          style: interMedium.copyWith(
                            color: ThemeManager().getPopUpTextGreyColor,
                            fontSize: width * 0.036,
                          ),
                        ),
                      ],
                    ),

                    //-------------Text field to add Ref. value---------
                    Container(
                      margin: EdgeInsets.only(top: height * 0.015),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "5",
                          hintStyle: interMedium.copyWith(
                            color: ThemeManager().getLightGrey1Color,
                            fontSize: width * 0.036,
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                              borderRadius:
                              BorderRadius.circular(width * 0.014)),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: height * 0.0,
                              horizontal: width * 0.045),
                          fillColor: ThemeManager().getLightGreenTextFieldColor,
                          filled: true,
                        ),
                      ),
                    ),

                    //-----------------Save button----------------
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showInputRefValGaugeValScreen=true;
                            _startTimer();
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                          margin: EdgeInsets.only(
                              top: height * 0.04, bottom: height * 0.02),
                          height: height * 0.065,
                          width: width,
                          child: ButtonView(
                              buttonLabel: TextConst.saveButtonText)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget inputRefValueGaugeValueScreenView(){
    return  Column(
      children: [
        Container(
          color: ThemeManager().getLightGreenColor,
          height: height * 0.061,
          padding: EdgeInsets.only(
              left: width * 0.05,
              right: width * 0.05,
              top: height * 0.02,
              bottom: height * 0.02),
          child: Row(
            children: [

              //-----------------Back arrow button--------
              InkWell(
                onTap: () {
                  setState(() {
                    showInputRefValGaugeValScreen=false;
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back_ios,
                      size: width * 0.043,
                      color: ThemeManager().getDarkGreenColor,
                    ),
                    Text(
                      TextConst.backText,
                      style: interMedium.copyWith(
                          color: ThemeManager().getDarkGreenColor,
                          fontSize: width * 0.043),
                    ),
                  ],
                ),
              ),

              //-------------Input Ref. Value Header text--------------
              Container(
                margin: EdgeInsets.only(left: height * 0.082),
                child: Text(
                  TextConst.inputRefValuesText,
                  style: interSemiBold.copyWith(
                      color: ThemeManager().getBlackColor,
                      fontSize: width * 0.04),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: height * 0.06,
          color: ThemeManager().getDarkGreenColor,

          //----------------------Table Title texts--------------------
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              //----------------Gauge value text----------
              Expanded(
                flex: 50,
                child: Text(
                  TextConst.gaugeValueText,
                  style: interMedium.copyWith(
                      color: ThemeManager().getWhiteColor,
                      fontSize: width * 0.035),
                  textAlign: TextAlign.center,
                ),
              ),
              VerticalDivider(
                thickness: width * 0.0003,
                color: ThemeManager().getWhiteColor,
              ),

              //----------------Ref value Text----------
              Expanded(
                  flex: 50,
                  child: Container(

                       padding: EdgeInsets.only(right: width * 0.05),
                      child: Text(
                        "Ref Value(kN)",
                        style: interMedium.copyWith(
                            color: ThemeManager().getWhiteColor,
                            fontSize: width * 0.035),
                        textAlign: TextAlign.center,
                      ))),
            ],
          ),
        ),

        //--------------------------Gauge and Ref value data--------------
        Container(
          child: ListView.builder(
            itemCount: gaugeData.length,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                height: height * 0.035,
                color: ThemeManager().getWhiteColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex: 50,
                      child: Container(
                          child: Text(
                            gaugeData[index]["Gauge Value"],
                            style: interMedium.copyWith(
                                color: ThemeManager().getBlackColor,
                                fontSize: width * 0.035),
                            textAlign: TextAlign.center,
                          )),
                    ),
                    Expanded(
                        flex: 50,
                        child: Container(
                            padding: EdgeInsets.only(right: width * 0.05),
                            child: Text(
                              gaugeData[index]["Ref Value(kN)"],
                              style: interMedium.copyWith(
                                  color: ThemeManager().getBlackColor,
                                  fontSize: width * 0.035),
                              textAlign: TextAlign.center,
                            ))),

                  ],
                ),
              );
            },
          ),
        ),

        //----------------------------Add ref value button----------
        Container(
            margin: EdgeInsets.only(
                right: width * 0.05, left: width * 0.05, top: height * 0.02),
            child: ButtonView(buttonLabel: TextConst.addRefValueText)),

        //------------------------Save button---------------
        startTimer==1?
        Container(
            margin: EdgeInsets.only(
                right: width * 0.05, left: width * 0.05, top: height * 0.01),
            alignment: Alignment.center,
            height: height * 0.058,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(height*0.008),
              color: ThemeManager().getLightGrey6Color,
            ),
            child: Text(
              TextConst.saveButtonText,
              style: interSemiBold.copyWith(
                  fontSize: width*0.038, color: ThemeManager().getDarkGrey3Color),
            )):
        startTimer==0?
        GestureDetector(
          onTap: (){
            Share.share(
                'save this');
          },
          child: Container(
              margin: EdgeInsets.only(
                  right: width * 0.05, left: width * 0.05, top: height * 0.01),
              alignment: Alignment.center,
              height: height * 0.058,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(height*0.008),
                gradient: LinearGradient(
                   colors: [
                     ThemeManager().getOrangeGradientColor,
                     ThemeManager().getYellowGradientColor
                   ]
                )
              ),
              child: Text(
                TextConst.saveButtonText,
                style: interSemiBold.copyWith(
                    fontSize: width*0.038, color: ThemeManager().getWhiteColor),
              )),
        ):Container(),
      ],
    );
  }

}
