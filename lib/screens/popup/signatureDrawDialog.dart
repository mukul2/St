
import 'dart:convert';
import 'dart:typed_data';

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
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
class DrawSignatureDialog extends StatefulWidget {
  Function(String)onFinished;
  DrawSignatureDialog({ required this.onFinished});

  @override
  _UpdatetextTitleState createState() => _UpdatetextTitleState();
}

class _UpdatetextTitleState extends State<DrawSignatureDialog> {
  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();
  void _handleClearButtonPressed() {
    signatureGlobalKey.currentState!.clear();
    setState(() {

    });
  }

  void _handleSaveButtonPressed() async {
    print("should show signature image 1");
    final data =
    await signatureGlobalKey.currentState!.toImage(pixelRatio: 3.0);
    final bytes = await data.toByteData(format: ui.ImageByteFormat.png);
   Uint8List d = bytes!.buffer.asUint8List();
   // widget.onFinished(base64Encode(  widget.onFinished(base64Encode(d))));
    print("should show signature image");
    print(base64Encode(d));


  }
  @override
  Widget build(BuildContext context) {

    //-------------------------Alert dialog box--------------------------
      return Dialog(

        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),

        child: Wrap(children: [
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
                    "Draw Signature",
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
            child: Column(
                children: [
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                          child: SfSignaturePad(
                              key: signatureGlobalKey,
                              backgroundColor: Colors.transparent,
                              strokeColor: Colors.black,
                              minimumStrokeWidth: 1.0,
                              maximumStrokeWidth: 4.0),
                          decoration:
                          BoxDecoration(border: Border.all(color: Colors.grey)))),
                 // SizedBox(height: 10),
                  // Row(children: <Widget>[
                  //   TextButton(
                  //     child: Text('ToImage'),
                  //     onPressed: _handleSaveButtonPressed,
                  //   ),
                  //   TextButton(
                  //     child: Text('Clear'),
                  //     onPressed: _handleClearButtonPressed,
                  //   )
                  // ], mainAxisAlignment: MainAxisAlignment.spaceEvenly)
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center),
          ),
          Row(
            children: [
              Expanded(child:GestureDetector(
                onTap: () {
                  Navigator.pop(context);

                },
                child: Container(   margin: EdgeInsets.only(left: height * 0.04,right: height * 0.01,top:0, bottom: 5), width: width,
                    child: ButtonView(
                        buttonLabel: "Close")
                ),
              )),
              Expanded(child:InkWell(
                onTap: () {
                  signatureGlobalKey.currentState!.clear();
                  setState(() {

                  });

                },
                child: Container(   margin: EdgeInsets.only(left: height * 0.01,right: height * 0.04,top:0, bottom: 5 ),width: width,
                    child: ButtonView(
                        buttonLabel: "Clear")
                ),
              )),

            ],
          ),
          InkWell(
            onTap: () async {
              print("should show signature image 1");
              final data =
                  await signatureGlobalKey.currentState!.toImage(pixelRatio: 3.0);
              final bytes = await data.toByteData(format: ui.ImageByteFormat.png);
              Uint8List d = bytes!.buffer.asUint8List();
               widget.onFinished(base64Encode(  widget.onFinished(base64Encode(d))));
              print("should show signature image");
              print(base64Encode(d));


            },
            child: Container(
                margin: EdgeInsets.only(left: height * 0.04,right: height * 0.04,top:10, bottom: height * 0.02),
                child: ButtonView(
                    buttonLabel: "Done")
            ),
          )
        ],),
      );
  }


}
