import 'package:connect/Appabr/appbar_widget.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/textConst.dart';
import 'package:connect/utils/themeManager.dart';
import 'package:flutter/material.dart';
import 'package:connect/Components/AppBarCustom.dart';
import 'package:connect/components/buttonView.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/textConst.dart';
import 'package:connect/utils/textStyleConst.dart';
import 'package:connect/utils/themeManager.dart';

class CalibrationCalculateInputRefValueScreen extends StatefulWidget {
  const CalibrationCalculateInputRefValueScreen({Key? key}) : super(key: key);

  @override
  _CalibrationCalculateInputRefValueScreenState createState() =>
      _CalibrationCalculateInputRefValueScreenState();
}

class _CalibrationCalculateInputRefValueScreenState
    extends State<CalibrationCalculateInputRefValueScreen> {

  List inputList = [
    {
      "SN": "1",
      "Current Output": "10.0",
      "Raw Reading": "489137",
      "Ref Value": "10"
    },
    {
      "SN": "2",
      "Current Output": "20.0",
      "Raw Reading": "972010",
      "Ref Value": "20"
    },
    {
      "SN": "3",
      "Current Output": "30.0",
      "Raw Reading": "1452566",
      "Ref Value": "30"
    },
    {
      "SN": "4",
      "Current Output": "40.0",
      "Raw Reading": "1950241",
      "Ref Value": "40.3"
    },
    {
      "SN": "5",
      "Current Output": "50.0",
      "Raw Reading": "2421033",
      "Ref Value": "50"
    },
    {
      "SN": "6",
      "Current Output": "59.0",
      "Raw Reading": "2900756",
      "Ref Value": "60"
    },
  ];

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ThemeManager().getWhiteColor,



      body: Column(

        children: [
          ApplicationAppbar(). getAppbar(title:TextConst.calibrationText),
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
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          size: width * 0.045,
                          color: ThemeManager().getDarkGreenColor,
                        ),
                        Text(
                          TextConst.backText,
                          style: interMedium.copyWith(
                              color: ThemeManager().getDarkGreenColor,
                              fontSize: width * 0.045),
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
                      TextConst.inputRefValuesText,
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
            height: height * 0.06,
            color: ThemeManager().getDarkGreenColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  flex: 25,
                  child: Container(
                      margin: EdgeInsets.only(
                          top: height * 0.003, bottom: height * 0.003),
                      child: Text(
                        "SN",
                        style: interMedium.copyWith(
                            color: ThemeManager().getWhiteColor,
                            fontSize: width * 0.035),
                        textAlign: TextAlign.center,
                      )),
                ),
                VerticalDivider(
                  thickness: width * 0.0003,
                  color: ThemeManager().getWhiteColor,
                ),
                Expanded(
                    flex: 25,
                    child: Container(
                        margin: EdgeInsets.only(
                            top: height * 0.003, bottom: height * 0.003),
                        padding: EdgeInsets.only(right: width * 0.05),
                        child: Text(
                          "Current Output",
                          style: interMedium.copyWith(
                              color: ThemeManager().getWhiteColor,
                              fontSize: width * 0.035),
                          textAlign: TextAlign.center,
                        ))),
                VerticalDivider(
                  thickness: width * 0.0003,
                  color: ThemeManager().getWhiteColor,
                ),
                Expanded(
                    flex: 25,
                    child: Container(
                        margin: EdgeInsets.only(
                            top: height * 0.003, bottom: height * 0.003),
                        child: Text(
                          "Raw Reading",
                          style: interMedium.copyWith(
                              color: ThemeManager().getWhiteColor,
                              fontSize: width * 0.035),
                          textAlign: TextAlign.center,
                        ))),
                VerticalDivider(
                  thickness: width * 0.0004,
                  color: ThemeManager().getWhiteColor,
                ),
                Expanded(
                  flex: 25,
                  child: Container(
                      margin: EdgeInsets.only(
                          top: height * 0.003, bottom: height * 0.003),
                      child: Text(
                        "Ref Value",
                        style: interMedium.copyWith(
                            color: ThemeManager().getWhiteColor,
                            fontSize: width * 0.035),
                        textAlign: TextAlign.center,
                      )),
                ),
              ],
            ),
          ),
          Container(
            child: ListView.builder(
              itemCount: inputList.length,
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
                        flex: 25,
                        child: Container(
                            child: Text(
                              inputList[index]["SN"],
                          style: interMedium.copyWith(
                              color: ThemeManager().getBlackColor,
                              fontSize: width * 0.035),
                          textAlign: TextAlign.center,
                        )),
                      ),
                      Expanded(
                          flex: 25,
                          child: Container(
                              padding: EdgeInsets.only(right: width * 0.05),
                              child: Text(
                                inputList[index]["Current Output"],
                                style: interMedium.copyWith(
                                    color: ThemeManager().getBlackColor,
                                    fontSize: width * 0.035),
                                textAlign: TextAlign.center,
                              ))),
                      Expanded(
                          flex: 25,
                          child: Container(
                              child: Text(
                                inputList[index]["Raw Reading"],
                            style: interMedium.copyWith(
                                color: ThemeManager().getBlackColor,
                                fontSize: width * 0.035),
                            textAlign: TextAlign.center,
                          ))),
                      Expanded(
                        flex: 25,
                        child: Container(
                            child: Text(
                              inputList[index]["Ref Value"],
                          style: interMedium.copyWith(
                              color: ThemeManager().getBlackColor,
                              fontSize: width * 0.035),
                          textAlign: TextAlign.center,
                        )),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
              margin: EdgeInsets.only(
                  right: width * 0.05, left: width * 0.05, top: height * 0.02),
              child: ButtonView(buttonLabel: TextConst.addRefValueText)),
          GestureDetector(
            // onTap: () {
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => CalculatedCoefficients(),
            //       ));
            // },
            child: Container(
                margin: EdgeInsets.only(
                    left: width * 0.3, right: width * 0.3, top: height * 0.015),
                alignment: Alignment.center,
                height: height * 0.058,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(height * 0.05),
                    gradient: LinearGradient(
                        colors: [Color(0xffFF7500), Color(0xffFFB400)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.45, 0.99])),
                child: Text(
                  "Calculate",
                  style: interSemiBold.copyWith(
                      fontSize: width * 0.038, color: Colors.white),
                )),
          ),
        ],
      ),
    );
  }
}
