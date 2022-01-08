import 'package:connect/Activities/CustomerUserHome/logics.dart';
import 'package:connect/streams/buttonStreams.dart';
import 'package:connect/utils/featureSettings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/textConst.dart';
import 'package:connect/utils/textStyleConst.dart';
import 'package:connect/utils/themeManager.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef LoadVal = Function(String);
typedef LoadUnitVal = Function(String);
typedef SecondVal = Function(String);

class EditTargetLoadAndTimePopUp extends StatefulWidget {
  LoadVal loadValueCallback;
  LoadUnitVal loadUnitValueCallback;
  SecondVal secondValueCallback;
   String oldLoad;
  String oldTime;
  String forceMode ;
  SharedPreferences sharedPreferences;

  EditTargetLoadAndTimePopUp(
      {Key? key,
      required this.loadValueCallback,
      required this.loadUnitValueCallback,
      required this.oldLoad,
      required this.oldTime,
      required this.forceMode,
      required this.sharedPreferences,
      required this.secondValueCallback})
      : super(key: key);

  @override
  _EditTargetLoadAndTimePopUpState createState() =>
      _EditTargetLoadAndTimePopUpState();
}

class _EditTargetLoadAndTimePopUpState
    extends State<EditTargetLoadAndTimePopUp> {

  //var loadValue = "21";
 // var secondValue = "54";
  //String? dropdownUnitValue = "kN";
  var loadUnitValue = "kN";
  bool isClear = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController loadController = new TextEditingController(text: widget.oldLoad);
    TextEditingController timeSecondController =
    new TextEditingController(text: widget.oldTime);
    timeSecondController.selection=TextSelection.fromPosition(TextPosition(offset: timeSecondController.text.length));
    loadController.selection=TextSelection.fromPosition(TextPosition(offset: loadController.text.length));
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
   // loadValue = widget.oldLoad;
    //secondValue = widget.oldTime;
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        scrollable: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        contentPadding: EdgeInsets.only(top: height * 0.012),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: height * 0.01, left: width * 0.04, right: width * 0.04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //-------------------------Header of dialogue box-----------------
                  Text(
                    "Edit Target Load and Time",
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
            Container(
              margin: EdgeInsets.only(top: height * 0.015),
              height: height * 0.001,
              color: ThemeManager().getBlackColor.withOpacity(0.2),
            ),
            Form(
              key: _formKey,
              child: Container(
                margin: EdgeInsets.only(
                    top: height * 0.02,
                    left: width * 0.04,
                    right: width * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //-----------------------Target Load fields--------------------
                    Text(
                      "Target Load",
                      style: interMedium.copyWith(
                        color: ThemeManager().getPopUpTextGreyColor,
                        fontSize: width * 0.036,
                      ),
                    ),

                    //-------------Target load TextField and Unit Dropdown--------------------
                    targetLoadFields(loadController),

                    //--------------------------Time Duration fields-----------------
                    Container(
                      margin: EdgeInsets.only(top: height * 0.014),
                      child: Text(
                        "Time Duration",
                        style: interMedium.copyWith(
                          color: ThemeManager().getPopUpTextGreyColor,
                          fontSize: width * 0.036,
                        ),
                      ),
                    ),

                    //--------------Time Duration Minutes And Seconds dropdown---------------
                    timeDurationFields(timeSecondController),

                    //---------------------------Save button----------------------
                    GestureDetector(
                      onTap: () {
                        var newSubSecondVal = timeSecondController.text
                            .replaceAll(" seconds", "");

                        if (_formKey.currentState!.validate()) {
                          UnitChangedStream.getInstance().dataReload(widget.forceMode!);
                          widget.sharedPreferences.setString("loadUnit",widget.forceMode! );
                         // widget.sharedPreferences.setString("loadUnit",widget.forceMode! );
                         // widget.sharedPreferences.setString("loadUnit",widget.forceMode! );
                          setState(() {
                           this.widget.oldLoad = loadController.text;
                           this.loadUnitValue = widget.forceMode!;
                            this.widget.oldTime = newSubSecondVal;
                            widget.loadValueCallback(widget.oldLoad);
                            widget.loadUnitValueCallback(loadUnitValue);
                            widget.secondValueCallback(widget.oldTime );
                            print(this.widget.oldLoad +
                                this.loadUnitValue +
                                this.widget.oldTime );
                          });
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            top: height * 0.04, bottom: height * 0.02),
                        height: height * 0.065,
                        width: width,
                        decoration: BoxDecoration(
                            color: ThemeManager().getDarkGreenColor,
                            borderRadius: BorderRadius.circular(width * 0.014)),
                        alignment: Alignment.center,
                        child: Text(
                          TextConst.saveButtonText,
                          style: interSemiBold.copyWith(
                              fontSize: width * 0.047,
                              color: ThemeManager().getWhiteColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  //-------------Target load TextField and Unit Dropdown--------------------
  Widget targetLoadFields(TextEditingController loadController) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //------------------------Target load TextField------------
        Flexible(
          flex: 4,
          child: Container(
            color: ThemeManager().getLightGreenTextFieldColor,
            child: TextFormField(
              controller: loadController,
              keyboardType: TextInputType.numberWithOptions(decimal:widget.forceMode == "kN"),
              inputFormatters: [
                PrefferedDecimalPlaces==1?  FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,1}')): FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
              ],
              style: interMedium.copyWith(color: ThemeManager().getBlackColor),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                hintText: "kN / lbf",
                hintStyle: interMedium.copyWith(
                    color: ThemeManager().getLightGrey1Color),
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(width * 0.014)),
                contentPadding: EdgeInsets.symmetric(
                    vertical: height * 0.015, horizontal: width * 0.045),
                fillColor: ThemeManager().getLightGreenTextFieldColor,
                filled: true,
              ),onChanged: (val){
              setState(() {
                widget.oldLoad = val.toString();
              });
            },
              validator: (loadText) {
                if (loadText!.isEmpty) {
                  return "Enter target load";
                }
                if (widget.forceMode == "kN" && double.parse(loadText!)>CustomerHomePageLogic().MaxLoadKN) {
                  return "Max load range is "+CustomerHomePageLogic().MaxLoadKN.toString();
                }
                if (widget.forceMode == "lbf" && double.parse(loadText!)>CustomerHomePageLogic().MaxLoadLBF) {
                  return "Max load range is "+CustomerHomePageLogic().MaxLoadLBF.toInt().toString();
                }
              },
            ),
          ),
        ),

        //-------------------Target Load Unit Dropdown-------------------
        Flexible(
          flex: 1,
          child: Container(
            color: ThemeManager().getLightGreenTextFieldColor,
            child: DropdownButtonFormField<String>(
              dropdownColor: ThemeManager().getLightGreenTextFieldColor,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent))),
              value: widget.forceMode,
              items: [
                DropdownMenuItem<String>(
                  child: Text("kN"),
                  value: "kN",
                ),
                DropdownMenuItem<String>(
                  child: Text("lbf"),
                  value: "lbf",
                )
              ],
              onChanged: (value) {
                setState(() {
                  if(value == "lbf"){
                   //int oldVal = int.parse(loadController.text);

                  // loadController = TextEditingController(text: oldVal.toString());
                  }

                  widget.forceMode = value!;
                });
              },
              hint: Text(
                widget.forceMode,
                style: interMedium.copyWith(
                    color: ThemeManager().getLightGrey1Color),
              ),
              validator: (loadUnitVal) {
                if (loadUnitVal == null) {
                  return "Select load unit";
                }
              },
            ),
          ),
        )
      ],
    );
  }

  //--------------------Time Duration Seconds text field-----------------------
  Widget timeDurationFields(TextEditingController timeSecondController) {
    return Container(
      color: ThemeManager().getLightGreenTextFieldColor,
      child: TextFormField(
       // maxLength: 5,
        controller: timeSecondController,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: interMedium.copyWith(color: ThemeManager().getBlackColor),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          suffix: Text("Seconds"),
          // suffixStyle: interMedium.copyWith(
          //     color: isClear == true
          //         ? Colors.transparent
          //         : ThemeManager().getDarkGreyTextColor),
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
              borderRadius: BorderRadius.circular(width * 0.014)),
          contentPadding: EdgeInsets.symmetric(
              vertical: height * 0.015, horizontal: width * 0.045),
          fillColor: ThemeManager().getLightGreenTextFieldColor,
          filled: true,
        ),
        onFieldSubmitted: (value) {
          // setState(() {
          //   isClear = false;
          // });
        },
        onChanged: (value) {
          //if (value.length == 0) {
            setState(() {
              widget.oldTime = value.toString();
            });
          // }
        },
        validator: (secondVal) {
          var subVal = secondVal!.replaceAll("seconds", "");
          var numberValue = int.tryParse(subVal);

          if (secondVal.isEmpty) {
            return "Enter seconds";
          } else if (numberValue! < 5) {
            return "Enter more than 4 seconds";
          }
          if (numberValue! > 3600) {
            return "Test Cannot  be longer than 3600 seconds";
          }

        },
      ),
    );
  }
}
