import 'package:connect/Activities/CustomerUserHome/logics.dart';
import 'package:connect/streams/buttonStreams.dart';
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

class UpdateTitle extends StatefulWidget {
  String title;

  UpdateTitle(
      {Key? key,
      required this.title,
     })
      : super(key: key);

  @override
  _UpdateTitlePopUpState createState() =>
      _UpdateTitlePopUpState();
}

class _UpdateTitlePopUpState
    extends State<UpdateTitle> {

  //var loadValue = "21";
 // var secondValue = "54";
  //String? dropdownUnitValue = "kN";
  var loadUnitValue = "kN";
  bool isClear = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = new TextEditingController(text: widget.title);

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
   // loadValue = widget.oldLoad;
    //secondValue = widget.oldTime;

    return  Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(color: Colors.white,height: 300,width: width * 0.9,
       // child: Text("Good"),
        child: ListView(shrinkWrap: true,
         // crossAxisAlignment: CrossAxisAlignment.start,
          //mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: height * 0.01, left: width * 0.04, right: width * 0.04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //-------------------------Header of dialogue box-----------------
                  Text(
                    "Edit Title",
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
                      "Title",
                      style: interMedium.copyWith(
                        color: ThemeManager().getPopUpTextGreyColor,
                        fontSize: width * 0.036,
                      ),
                    ),

                    //-------------Target load TextField and Unit Dropdown--------------------
                    targetLoadFields(titleController),

                    //--------------------------Time Duration fields-----------------


                    //--------------Time Duration Minutes And Seconds dropdown---------------


                    //---------------------------Save button----------------------
                    GestureDetector(
                      onTap: () {
                        var newSubSecondVal = titleController.text;

                        if (_formKey.currentState!.validate()) {



                          TitleUpdateStream.getInstance().dataReload(newSubSecondVal!);
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
      ),
    );
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
                    "Edit Title",
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
                      "Title",
                      style: interMedium.copyWith(
                        color: ThemeManager().getPopUpTextGreyColor,
                        fontSize: width * 0.036,
                      ),
                    ),

                    //-------------Target load TextField and Unit Dropdown--------------------
                    targetLoadFields(titleController),

                    //--------------------------Time Duration fields-----------------


                    //--------------Time Duration Minutes And Seconds dropdown---------------


                    //---------------------------Save button----------------------
                    GestureDetector(
                      onTap: () {
                        var newSubSecondVal = titleController.text;

                        if (_formKey.currentState!.validate()) {
                          TitleUpdateStream.getInstance().dataReload(newSubSecondVal!);
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
        Container(
          color: ThemeManager().getLightGreenTextFieldColor,
          child: TextFormField(
            controller: loadController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,1}'))
            ],
            style: interMedium.copyWith(color: ThemeManager().getBlackColor),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              hintText: "Title of the test",
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
              widget.title = val.toString();
            });
          },
            validator: (loadText) {
              if (loadText!.isEmpty) {
                return "Enter title";
              }
              // if (widget.forceMode == "kN" && double.parse(loadText!)>CustomerHomePageLogic().MaxLoadKN) {
              //   return "Maxi load range is "+CustomerHomePageLogic().MaxLoadKN.toString();
              // }
              // if (widget.forceMode == "lbf" && double.parse(loadText!)>CustomerHomePageLogic().MaxLoadLBF) {
              //   return "Maxi load range is "+CustomerHomePageLogic().MaxLoadLBF.toString();
              // }
            },
          ),
        ),

        //-------------------Target Load Unit Dropdown-------------------

      ],
    );
  }

}
