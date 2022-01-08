import 'package:connect/Appabr/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:connect/Components/AppBarCustom.dart';
import 'package:connect/components/buttonView.dart';
import 'package:connect/Activities/CalibrationUI/calibrationInputRefValueAddAndCalculateRawValueScreen.dart';
import 'package:connect/Activities/CalibrationUI/calibrationVerificationCheckAddAndSaveGaugeValueScreen.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/textConst.dart';
import 'package:connect/utils/textStyleConst.dart';
import 'package:connect/utils/themeManager.dart';

class CalibrationCalculatedCoefficientsScreen extends StatefulWidget {
  const CalibrationCalculatedCoefficientsScreen({Key? key}) : super(key: key);

  @override
  _CalibrationCalculatedCoefficientsScreenState createState() =>
      _CalibrationCalculatedCoefficientsScreenState();
}

class _CalibrationCalculatedCoefficientsScreenState
    extends State<CalibrationCalculatedCoefficientsScreen> {

  //------------------Calculated Coefficients data--------------
  List calculatedEfficientsData = [
    {
      "name": "3rd Co ef.",
      "value": "3.00E-20",
    },
    {
      "name": "2nd Co ef.",
      "value": "-1.57E-13",
    },
    {
      "name": "1st Co ef.",
      "value": "2.10E-05",
    },
    {
      "name": "0th Co ef.",
      "value": "2.10E-05",
    },
  ];

  var showGaugeValueScreen = false;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ThemeManager().getWhiteColor,

      //----------------Appbar of screen---------------
      appBar: PreferredSize(
          child:  ApplicationAppbar(). getAppbar(title:TextConst.calibrationText),
          preferredSize: Size(0, kToolbarHeight)),

      //-----------------Body of screen--------------
      body:
      showGaugeValueScreen == false
          ? calculatedCoefficientsScreenView()
          : CalibrationVerificationCheckAddAndSaveGaugeValueScreen(),
    );
  }

  Widget calculatedCoefficientsScreenView(){
    return SingleChildScrollView(

      child: Column(

        children: [

          //---------------back button and Title row----------
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
                                  CalibrationInputRefValueAddAndCalculateRawValueScreen(
                                    showInputRefValScreen: true,
                                  )));
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

                  //-----------------Calculated Coefficients Header text------
                  Container(
                    margin: EdgeInsets.only(
                      left: width * 0.09,
                    ),
                    child: Text(
                      TextConst.calculatedCoefficientsText,
                      style: interSemiBold.copyWith(
                          color: ThemeManager().getBlackColor,
                          fontSize: width * 0.043),
                    ),
                  ),
                ],
              ),
            ),
          ),

          //------------------------Calculated coefficient data View-----------
          Container(
            child: ListView.builder(
              itemCount: calculatedEfficientsData.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index)
              {
                return Container(
                  padding:
                  EdgeInsets.only(left: width * 0.05, right: width * 0.05),
                  decoration: BoxDecoration(
                    color: ThemeManager().getWhiteColor,
                    border: Border(
                        bottom: BorderSide(
                            color: ThemeManager().getLightGrey3Color,
                            width: height * 0.0007)),
                  ),
                  height: height * 0.055,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        calculatedEfficientsData[index]["name"],
                        style: interMedium.copyWith(fontSize: width * 0.038),
                      ),
                      Text(
                        calculatedEfficientsData[index]["value"],
                        style: interSemiBold.copyWith(
                            fontSize: width * 0.034,
                            color: ThemeManager().getDarkGreenColor),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          //-----------------Button - Apply changes----------------
          Container(
              margin: EdgeInsets.only(
                  right: width * 0.05,
                  left: width * 0.05,
                  top: height * 0.03),
              child: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => dataSavedPopUp(context));
                  },
                  child: ButtonView(buttonLabel: "Apply Changes"))),
        ],
      ),
    );
  }

  Widget dataSavedPopUp(BuildContext context){
    return Container(
      margin: EdgeInsets.only(
          right: width * 0.05, left: width * 0.05),

      child: Dialog(
        backgroundColor: Colors.transparent.withOpacity(0.0001),
        insetPadding: EdgeInsets.zero,

        child: Container(
          width: width,
          height: height*0.22,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(height * 0.012),
            color: ThemeManager().getWhiteColor,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Container(
                margin: EdgeInsets.only(top: height * 0.03,bottom: height*0.038),
                width: double.infinity,

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Text(
                      "Data Saved. ",textAlign: TextAlign.center,
                      style: interMedium.copyWith(
                          fontSize: width * 0.047,
                          color: ThemeManager().getBlackColor),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: height*0.006),
                      child: Text("Remove Load to 0.0 kN",textAlign: TextAlign.center,
                          style: interMedium.copyWith(
                              fontSize: width * 0.047,
                              color: ThemeManager().getBlackColor)),
                    )
                  ],
                ),
              ),


              Container(
                  margin: EdgeInsets.only(
                      right: width * 0.05,
                      left: width * 0.05),
                  child: InkWell(
                      onTap: () {
                        setState(() {
                          if(showGaugeValueScreen==false) {
                            showGaugeValueScreen = true;
                          }
                          else {
                            setState(() {
                              showGaugeValueScreen=false;
                            });
                          }
                        });
                        Navigator.pop(context);
                      },
                      child: ButtonView(
                          buttonLabel: TextConst.okText)))
            ],
          ),
        ),

      ),
    );
  }

}
