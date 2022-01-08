
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/components/buttonView.dart';
import 'package:connect/streams/buttonStreams.dart';
import 'package:flutter/material.dart';
import 'package:connect/screens/dashboardScreen.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/textConst.dart';
import 'package:connect/utils/textStyleConst.dart';
import 'package:connect/utils/themeManager.dart';
import 'package:flutter/services.dart';

class UpdatetextNote extends StatefulWidget {
  String title;
  FirebaseFirestore firestore;
  String id;
  UpdatetextNote({required this.title,required this.firestore,required this.id});

  @override
  _UpdatetextTitleState createState() => _UpdatetextTitleState();
}

class _UpdatetextTitleState extends State<UpdatetextNote> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = new TextEditingController(text: widget.title);
    height=MediaQuery.of(context).size.height;
    width=MediaQuery.of(context).size.width;
    titleController.text =  widget.title;
    titleController.selection = TextSelection.fromPosition(TextPosition(offset: titleController.text.length));
    //-------------------------Alert dialog box--------------------------
    return Dialog(

      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),

      child:  Wrap(children: [
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
                  "Edit Note",
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(maxLines: 8,minLines: 7,
            controller: titleController,autofocus: true,
            // keyboardType: TextInputType.numberWithOptions(decimal: true),
            // inputFormatters: [
            //   FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,1}'))
            // ],
            style: interMedium.copyWith(color: ThemeManager().getBlackColor),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              hintText: "Note of the test",
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

                widget.title = val.toString();

            },
            validator: (loadText) {
              if (loadText!.isEmpty) {
                return "Enter Note";
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
        GestureDetector(
          onTap: () {
            var newSubSecondVal = titleController.text;

            widget.firestore
                .collection("pulltest")
                .doc(widget.id)
                .update({"note": newSubSecondVal}).then(
                    (value) {
                  Navigator.pop(context);
                });
          },
          child: Container(
              margin: EdgeInsets.only(left:height * 0.02 ,right: height * 0.02,top: height * 0.02, bottom: height * 0.02),
              child: ButtonView(
                  buttonLabel: TextConst.saveButtonText)
          ),
        )
      ],),
    );
  }


}
