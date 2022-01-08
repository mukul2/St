
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/streams/buttonStreams.dart';
import 'package:flutter/material.dart';
import 'package:connect/screens/dashboardScreen.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/textConst.dart';
import 'package:connect/utils/textStyleConst.dart';
import 'package:connect/utils/themeManager.dart';
import 'package:flutter/services.dart';

class TestSavedPopUp extends StatefulWidget {

  //Function callback(bool) callback;

  TestSavedPopUp();

  @override
  _UpdatetextTitleState createState() => _UpdatetextTitleState();
}

class _UpdatetextTitleState extends State<TestSavedPopUp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // startTimer();
  }
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = new TextEditingController();
    height=MediaQuery.of(context).size.height;
    width=MediaQuery.of(context).size.width;
   // titleController.text =  widget.title;
    titleController.selection = TextSelection.fromPosition(TextPosition(offset: titleController.text.length));
    //-------------------------Alert dialog box--------------------------

    return Dialog(

      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),

      child: Wrap(
        //crossAxisAlignment: CrossAxisAlignment.end,
        children: [

          Container(height: 50,
            child: Stack(children: [
              Align(alignment: Alignment.centerLeft,child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Text("Test is saved successfully",maxLines: 1,style: TextStyle(fontSize: 20,color: ThemeManager().getDarkGreenColor,fontWeight: FontWeight.bold),),
              ),),
              Align(alignment: Alignment.centerRight,child:Container(color: Colors.white,
                margin: EdgeInsets.only(
                   // top: height * 0.01,
                   // left: width * 0.04,
                    right: width * 0.04),

                child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },

                    child: Icon(
                      Icons.clear,
                      size: width * 0.06,
                      color: ThemeManager().getLightGrey2Color,
                    )),
              ) ,),
            ],),
          ),



          Container(
           // margin: EdgeInsets.only(top: height * 0.015),
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
                Text("Test will be visible in home screen and in files",
                    style: interBold.copyWith(
                        color: ThemeManager().getPopUpTextGreyColor,
                        fontSize: width * 0.038)),

                Container(
                  margin: EdgeInsets.only(top: height*0.03,bottom: height*0.04),
                  child:    GestureDetector(
                    onTap: (){

                      Navigator.pop(context);

                    },
                    child: Container(
                      height: height * 0.065,
                      //width: width*0.33,
                      decoration: BoxDecoration(
                          color: ThemeManager().getDarkGreenColor,
                          borderRadius:
                          BorderRadius.circular(width * 0.014)),
                      alignment: Alignment.center,
                      child: Center(
                        child: Text("Done",
                          style: interSemiBold.copyWith(
                              fontSize: width * 0.045,
                              color: ThemeManager().getWhiteColor),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
             // widget.title = val.toString();
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

  void startTimer() {
    Future.delayed(Duration(seconds: 2)).then((value) {
      Navigator.pop(context);
    });

  }
}
