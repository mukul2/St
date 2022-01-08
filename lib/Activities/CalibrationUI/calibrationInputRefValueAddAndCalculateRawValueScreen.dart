
import 'package:connect/Appabr/appbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connect/components/appBarCustom.dart';
import 'package:connect/components/buttonView.dart';
import 'package:connect/Activities/CalibrationUI/calibrationCalculatedCoefficientsScreen.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/textConst.dart';
import 'package:connect/utils/textStyleConst.dart';
import 'package:connect/utils/themeManager.dart';

class CalibrationInputRefValueAddAndCalculateRawValueScreen extends StatefulWidget {
  final showInputRefValScreen;

  const CalibrationInputRefValueAddAndCalculateRawValueScreen(
      {Key? key, required this.showInputRefValScreen})
      : super(key: key);

  @override
  _CalibrationInputRefValueAddAndCalculateRawValueScreenState createState() =>
      _CalibrationInputRefValueAddAndCalculateRawValueScreenState();
}

class _CalibrationInputRefValueAddAndCalculateRawValueScreenState
    extends State<CalibrationInputRefValueAddAndCalculateRawValueScreen> {

  //---------------------Input ref values-------------------
  List inputRefList = [
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

  late bool showCalculateInputRefScreen;

  @override
  void initState() {
    super.initState();
    showCalculateInputRefScreen=widget.showInputRefValScreen;
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ThemeManager().getWhiteColor,

      //----------- App Bar of screen--------------------------
      appBar: PreferredSize(
        preferredSize: Size(0,kToolbarHeight),
        child: ApplicationAppbar(). getAppbar(title:TextConst.calibrationText),
      ),

      //--------------Body of screen--------------------
      body: showCalculateInputRefScreen == false

            //------------------Raw value - Add ref value screen view---------
          ? addRefValueScreenView()

           //------------------Calculate Input ref value screen view----------
          : calculateInputRefValueScreenView()
    );
  }


  //------------------Raw value - Add ref value screen view---------
  Widget addRefValueScreenView(){
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
                    Navigator.pop(context);
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
                TextConst.rawValueText,
                style: interSemiBold.copyWith(
                    color: ThemeManager().getBlackColor,
                    fontSize: width * 0.040),
              ),

              //------Ref value text-----
              Text(
                TextConst.refValueText,
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

            //--------------Dialogue popup to Add ref value----------------
            addRefRawValuePopUp();
          },
          child: Container(
              margin: EdgeInsets.only(
                left: width * 0.057,
                right: width * 0.057,
                top: height * 0.03,
              ),
              height: height * 0.065,
              width: width,
              child: ButtonView(buttonLabel: TextConst.addRefValueText)
          ),
        ),

        //------------------- Calculate Button -------------------
        Container(
          margin: EdgeInsets.only(
            left: width * 0.30,
            right: width * 0.30,
            top: height * 0.43,
          ),
          height: height * 0.062,
          width: width * 0.65,
          decoration: BoxDecoration(
              color: ThemeManager().getLightGrey6Color,
              borderRadius: BorderRadius.circular(width * 0.20)),
          alignment: Alignment.center,
          child: Text(
            TextConst.calculateText,
            style: interSemiBold.copyWith(
                fontSize: width * 0.040,
                color: ThemeManager().getDarkGrey3Color),
          ),
        ),
      ],
    );
  }

  //----------------- Add Ref Value PopUp -----------------------
  addRefRawValuePopUp() {
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
                          TextConst.currentRawValueText,
                          style: interMedium.copyWith(
                            color: ThemeManager().getPopUpTextGreyColor,
                            fontSize: width * 0.036,
                          ),
                        ),

                        //-------Current Raw value data-------
                        Text(
                          "277796",
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
                          showCalculateInputRefScreen=true;
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

  //------------------Calculate Input ref value screen view----------
  Widget calculateInputRefValueScreenView(){
    return SingleChildScrollView(
      child: Column(

        children: [
          Column(
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
                          setState(() {
                            showCalculateInputRefScreen=false;
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

                //------------------------Table Header-----------------
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

              //-------------------------Input Ref data-----------------
              Container(
                child: ListView.builder(
                  itemCount: inputRefList.length,
                   shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      height: height * 0.035,
                      color: ThemeManager().getWhiteColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [

                          //---------SN data-----------
                          Expanded(
                            flex: 25,
                            child: Container(
                                child: Text(
                                  inputRefList[index]["SN"],
                                  style: interMedium.copyWith(
                                      color: ThemeManager().getBlackColor,
                                      fontSize: width * 0.035),
                                  textAlign: TextAlign.center,
                                )),
                          ),

                          //--------Current Output data--------
                          Expanded(
                              flex: 25,
                              child: Container(
                                  padding: EdgeInsets.only(right: width * 0.05),
                                  child: Text(
                                    inputRefList[index]["Current Output"],
                                    style: interMedium.copyWith(
                                        color: ThemeManager().getBlackColor,
                                        fontSize: width * 0.035),
                                    textAlign: TextAlign.center,
                                  ))),

                          //---------Raw Reading data-----------
                          Expanded(
                              flex: 25,
                              child: Container(
                                  child: Text(
                                    inputRefList[index]["Raw Reading"],
                                    style: interMedium.copyWith(
                                        color: ThemeManager().getBlackColor,
                                        fontSize: width * 0.035),
                                    textAlign: TextAlign.center,
                                  ))),

                          //----------Ref Value data--------------
                          Expanded(
                            flex: 25,
                            child: Container(
                                child: Text(
                                  inputRefList[index]["Ref Value"],
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

              //----------------------Button - Add ref. value----------------
              Container(
                      margin: EdgeInsets.only(
                          right: width * 0.05, left: width * 0.05, top: height * 0.02),
                      child: ButtonView(buttonLabel: TextConst.addRefValueText)),

             ],
          ),

          //-----------------------Button - Calculate--------------
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CalibrationCalculatedCoefficientsScreen(),
                  ));
            },
            child: Container(
                margin: EdgeInsets.only(
                    left: width * 0.3,
                    right: width * 0.3,
                   top: height * 0.25,
                    bottom: height * 0.09),
                alignment: Alignment.center,
                height: height * 0.058,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(height * 0.05),
                    gradient: LinearGradient(
                      colors: [
                        ThemeManager().getOrangeGradientColor,
                        ThemeManager().getYellowGradientColor
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )),
                child: Text(
                  TextConst.calculateText,
                  style: interSemiBold.copyWith(
                      fontSize: width * 0.038, color: ThemeManager().getWhiteColor),
                )),
          ),
        ],
      ),
    );
  }

}
