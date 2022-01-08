import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/Activities/CustomerUserHome/HomePager/appbar.dart';
import 'package:connect/Appabr/appbar_widget.dart';
import 'package:connect/components/buttonView.dart';
import 'package:connect/screens/generateReportShareScreen.dart';
import 'package:connect/screens/home.dart';
import 'package:connect/services/show_widgets.dart';
import 'package:connect/streams/buttonStreams.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/textConst.dart';
import 'package:connect/utils/textStyleConst.dart';
import 'package:connect/utils/themeManager.dart';
import 'package:connect/widgets/appwidgets.dart';
 import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'dart:ui' as ui;

import '../../../DarkThemeManager.dart';
import 'logics.dart';
enum fileSortType { none, title, date }
enum folderAction { rename, delete, move }
class ReportingsUi{
  FirebaseFirestore? firestore;
  BuildContext? context;
  String? customerID;


  ReportingsUi({this.context,this.firestore,this.customerID});
  createFolderDialog({required String parentFolderId}){
    TextEditingController _folderNameController = TextEditingController();

    SimpleDialog dialog = SimpleDialog(children: [
      Center(child: Text('Create a Folder')),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: _folderNameController,
        ),
      ),
      InkWell(
        onTap: () {
          firestore!.collection("folders").add({
            "name": _folderNameController.text,
            "parent": parentFolderId,
            "created_at": new DateTime.now().millisecondsSinceEpoch
          }).then((value) {
            Navigator.pop(context!);
            _folderNameController.clear();
          });
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          color: Theme.of(context!).primaryColor,
          child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Text(
                      "Create",
                      style: TextStyle(color: Colors.white),
                    )),
              )),
        ),
      )
    ]);
    return dialog;
  }
  getTopText(){
  return  Padding(
      padding: const EdgeInsets.all(8.0),
      child:  Text(
        "Choose record(s) and/or folder(s) to generate report",
        style: interMedium.copyWith(
            color: ThemeManager().getLightGrey9Color,
            fontSize: width * 0.041),
      ),
    );
  }
  getTableHeader(){
    return  Container(
      height: height * 0.08,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: ThemeManager().getLightGrey3Color,
              blurRadius: 15,
              spreadRadius: 1)
        ],
        color: ThemeManager().getWhiteColor,
      ),
      margin: EdgeInsets.only(left: width * 0.04, right: width * 0.04),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Select Files",
                style: interMedium.copyWith(
                    fontSize: width * 0.04,
                    color: ThemeManager().getBlackColor),
              ),
              SizedBox(
                height: height * 0.007,
              ),
              StreamBuilder<List>(
                  stream: ReportingsLogics().fileSelectedForReportStream().outData,
                  builder: (c, snapshot) {
                    print("stream out 2");
                    print(snapshot.data);
                    if(snapshot.hasData){
                      return Text(snapshot.data!.length.toString(),style: interMedium.copyWith(
                          fontSize: width * 0.039,
                          color: ThemeManager().getDarkGreenColor));
                    }else{
                      return Text("0",style: interMedium.copyWith(
                          fontSize: width * 0.039,
                          color: ThemeManager().getDarkGreenColor));
                    }
                  }),

            ],
          ),
          Container(
              color: ThemeManager().getLightGrey8Color,
              width: width * 0.002,
              height: height * 0.052),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Selected Folder",
                style: interMedium.copyWith(
                    fontSize: width * 0.04,
                    color: ThemeManager().getBlackColor),
              ),
              SizedBox(
                height: height * 0.007,
              ),
              StreamBuilder<List>(
                  stream: ReportingsLogics().folderSelectedForReportStream().outData,
                  builder: (c, snapshot) {
                    print("stream out 1");
                    print(snapshot.data);
                    if(snapshot.hasData){
                      return Text(snapshot.data!.length.toString(),
                          style: interMedium.copyWith(
                              fontSize: width * 0.039,
                              color: ThemeManager().getDarkGreenColor));
                    }else{
                      return Text("0",
                          style: interMedium.copyWith(
                              fontSize: width * 0.039,
                              color: ThemeManager().getDarkGreenColor));
                    }
                  })

            ],
          ),
        ],
      ),
    );
   return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context!).primaryColor,
          border: Border.all(color: Theme.of(context!).primaryColor),
        ),
        child: Row(
          children: [
            Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Selected Files",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )),
            Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Selected Folders",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
  getTableBody(){
   return  Padding(
     padding: const EdgeInsets.fromLTRB(10, 00, 10, 10),
     child: Container(
       decoration: BoxDecoration(
         border: Border.all(color: Theme.of(context!).primaryColor),
       ),
       child: Row(
         children: [
           Expanded(
               child: Center(
                 child: Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: StreamBuilder<List>(
                   stream: ReportingsLogics().fileSelectedForReportStream().outData,
                    builder: (c, snapshot) {
                     print("stream out 2");
                     print(snapshot.data);
                     if(snapshot.hasData){
                       return Text(snapshot.data!.length.toString());
                     }else{
                       return Text("0");
                     }
                    }),
                 ),
               )),
           Expanded(
               child: Center(
                 child: Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: StreamBuilder<List>(
                       stream: ReportingsLogics().folderSelectedForReportStream().outData,
                       builder: (c, snapshot) {
                         print("stream out 1");
                         print(snapshot.data);
                         if(snapshot.hasData){
                           return Text(snapshot.data!.length.toString());
                         }else{
                           return Text("0");
                         }
                       }),
                 ),
               )),
         ],
       ),
     ),
   );
  }
  mainWidget({required FirebaseFirestore firestore,required Locale locale,required String customerId }){
    return AllFileFolderForReporting(appbar: AppBar(),customerFirestore: firestore,locale: locale,customerId: customerId,);

  }
  showButtons(){
    show({required List files,required List folders}){
      print(files.length);
      print(folders.length);
      if(files.length>0 || folders.length>0)
      return  InkWell(
        onTap: () {
          TextEditingController contoller =
          new TextEditingController();
          TextEditingController contoller2 =
          new TextEditingController();
          TextEditingController contoller3 =
          new TextEditingController();
          TextEditingController contoller4 =
          new TextEditingController();
          TextEditingController contoller5 =
          new TextEditingController();
          TextEditingController contoller6 =
          new TextEditingController();
          TextEditingController contoller7 =
          new TextEditingController();
          late Uint8List _signatureData;
          GlobalKey<SfSignaturePadState> _signaturePadKey =
          GlobalKey();
          Future<void> _handleSaveButtonPressed() async {
            Uint8List data;
            bool isWeb = false;

            if (isWeb) {
              // final RenderSignaturePad renderSignaturePad =
              // _signaturePadKey.currentState!.context
              //     .findRenderObject() as RenderSignaturePad;
              // data = await ImageConverter.toImage(
              //     renderSignaturePad: renderSignaturePad);
              // setState(
              //       () {
              //     _signatureData = data;
              //   },
              // );
            } else {
              final ui.Image imageData = await _signaturePadKey
                  .currentState!
                  .toImage(pixelRatio: 3.0);
              final ByteData? bytes = await imageData.toByteData(
                  format: ui.ImageByteFormat.png);
              if (bytes != null) {
                data = bytes.buffer.asUint8List();
                //state management needed for this signature
                _signatureData = data;

              }
            }


          }
          //GenerateReportShareScreen

          Navigator.push(
              context!,
              MaterialPageRoute(
              builder: (BuildContext context) =>GenerateReportShareScreen(files: files,folders: folders,firestore: firestore!,customerID: customerID!,)));
if(false) {
  // Navigator.push(
  //     context!,
  //     MaterialPageRoute(
  //       builder: (BuildContext context) =>
  //           Scaffold(
  //             appBar: AppBar(
  //               title: Text("Generate Report"),
  //             ),
  //             body: SingleChildScrollView(
  //               child: Column(
  //                 children: [
  //                   Container(
  //                     height: 200,
  //                     child: Padding(
  //                       padding: const EdgeInsets.all(8.0),
  //                       child: Card(
  //                         elevation: 8,
  //                         shape: RoundedRectangleBorder(
  //                             borderRadius:
  //                             BorderRadius.circular(1.0)),
  //                         child: Stack(
  //                           children: [
  //                             Align(
  //                               alignment: Alignment.center,
  //                               child: SfSignaturePad(
  //                                   minimumStrokeWidth: 2,
  //                                   maximumStrokeWidth: 3,
  //                                   strokeColor: Colors.black,
  //                                   backgroundColor:
  //                                   Colors.white,
  //                                   key: _signaturePadKey),
  //                             ),
  //                             Align(
  //                               alignment: Alignment.center,
  //                               child: Text(
  //                                 "Signature",
  //                                 style: TextStyle(
  //                                     color: Colors.grey),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   ExpandablePanel(
  //                     header: Padding(
  //                       padding: const EdgeInsets.fromLTRB(
  //                           8, 15, 8, 4),
  //                       child: Text(
  //                         "Tap here to add more info",
  //                         style: TextStyle(fontSize: 18),
  //                       ),
  //                     ),
  //                     collapsed: Padding(
  //                       padding: const EdgeInsets.all(8.0),
  //                       child: Text(
  //                         "Site details,Customer Details,Anchor(s) Tested,Test Method and Statements,Analysis and Conclusion,Recommendations",
  //                         softWrap: true,
  //                         maxLines: 1,
  //                         overflow: TextOverflow.ellipsis,
  //                       ),
  //                     ),
  //                     expanded: Wrap(
  //                       children: [
  //                         Padding(
  //                           padding: const EdgeInsets.all(8.0),
  //                           child: TextFormField(
  //                             controller: contoller,
  //                             decoration: InputDecoration(
  //                               labelText: 'Site Details',
  //                               border: OutlineInputBorder(),
  //                             ),
  //                           ),
  //                         ),
  //                         Padding(
  //                           padding: const EdgeInsets.all(8.0),
  //                           child: TextFormField(
  //                             controller: contoller2,
  //                             decoration: InputDecoration(
  //                               labelText: 'Customer Details',
  //                               border: OutlineInputBorder(),
  //                             ),
  //                           ),
  //                         ),
  //                         Padding(
  //                           padding: const EdgeInsets.all(8.0),
  //                           child: TextFormField(
  //                             controller: contoller3,
  //                             decoration: InputDecoration(
  //                               labelText: 'Anchor(s) Tested',
  //                               border: OutlineInputBorder(),
  //                             ),
  //                           ),
  //                         ),
  //                         Padding(
  //                           padding: const EdgeInsets.all(8.0),
  //                           child: TextFormField(
  //                             controller: contoller4,
  //                             decoration: InputDecoration(
  //                               labelText:
  //                               'Test Method and Statements',
  //                               border: OutlineInputBorder(),
  //                             ),
  //                           ),
  //                         ),
  //                         Padding(
  //                           padding: const EdgeInsets.all(8.0),
  //                           child: TextFormField(
  //                             controller: contoller5,
  //                             decoration: InputDecoration(
  //                               labelText:
  //                               'Analysis and Conclusion',
  //                               border: OutlineInputBorder(),
  //                             ),
  //                           ),
  //                         ),
  //                         Padding(
  //                           padding: const EdgeInsets.all(8.0),
  //                           child: TextFormField(
  //                             controller: contoller6,
  //                             decoration: InputDecoration(
  //                               labelText: 'Recommendations',
  //                               border: OutlineInputBorder(),
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     // tapHeaderToExpand: true,
  //                     // hasIcon: true,
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: TextFormField(
  //                       controller: contoller7,
  //                       decoration: InputDecoration(
  //                         labelText: 'Password',
  //                         border: OutlineInputBorder(),
  //                       ),
  //                     ),
  //                   ),
  //                   Row(
  //                     children: [
  //                       Expanded(
  //                           child: InkWell(
  //                             onTap: () {
  //                               Navigator.of(context).pop();
  //                             },
  //                             child: Padding(
  //                               padding: const EdgeInsets.all(8.0),
  //                               child: Card(
  //                                 shape: RoundedRectangleBorder(
  //                                   borderRadius:
  //                                   BorderRadius.circular(0.0),
  //                                 ),
  //                                 color: Colors.grey,
  //                                 child: Center(
  //                                     child: Padding(
  //                                       padding:
  //                                       const EdgeInsets.all(8.0),
  //                                       child: Text(
  //                                         "Cancel",
  //                                         style: TextStyle(
  //                                             color: Colors.white),
  //                                       ),
  //                                     )),
  //                               ),
  //                             ),
  //                           )),
  //                       Expanded(
  //                           child: InkWell(
  //                             onTap: () async {
  //                               //download all test data with pic
  //
  //                               if (contoller7.text.length > 4) {
  //                                 print("genrate report clicked");
  //                                 showDialog<void>(
  //                                     context: context, builder: (context) =>
  //                                     AlertDialog(
  //
  //                                       content:
  //                                       Text('Generating report'),
  //
  //                                     ));
  //
  //                                 if (folders.length > 0) {
  //                                   try {
  //                                     void getOne() async {
  //                                       if (folders.length > 0) {
  //                                         QuerySnapshot<Map<String,
  //                                             dynamic>> itemsInOneFolder = await firestore!
  //                                             .collection("folders")
  //                                             .doc(folders.last)
  //                                             .collection("records")
  //                                             .get();
  //                                         if (itemsInOneFolder.size > 0 &&
  //                                             itemsInOneFolder.docs.length >
  //                                                 0) {
  //                                           for (int i = 0; i <
  //                                               itemsInOneFolder.docs
  //                                                   .length; i++) {
  //                                             files.add(itemsInOneFolder.docs[i]
  //                                                 .data()["id"]);
  //                                           }
  //                                         }
  //                                         String tempFolder = folders.last;
  //                                         folders.removeLast();
  //                                         //get new folders
  //
  //                                         QuerySnapshot<Map<String,
  //                                             dynamic>> newFolders = await firestore!
  //                                             .collection("folders")
  //                                             .where(
  //                                             "parent", isEqualTo: tempFolder)
  //                                             .get();
  //
  //                                         if (newFolders.docs.length > 0) {
  //                                           for (int i = 0; i <
  //                                               newFolders.docs.length; i++) {
  //                                             folders.add(
  //                                                 newFolders.docs[i].id);
  //                                           }
  //                                         }
  //
  //                                         if (folders.length > 0) {
  //                                           getOne();
  //                                         }
  //                                       }
  //                                     }
  //                                   } catch (e) {
  //                                     print("my ex");
  //                                     print(e);
  //                                   }
  //                                 } else {
  //                                   print("folder is empty");
  //                                 }
  //
  //                                 print(files);
  //                                 if (true &&
  //                                     contoller7.text.length > 4) {
  //                                   Uint8List dataSignature = Uint8List
  //                                       .fromList([]);
  //                                   final ui.Image imageData =
  //                                   await _signaturePadKey
  //                                       .currentState!
  //                                       .toImage(
  //                                       pixelRatio: 3.0);
  //                                   final ByteData? bytes =
  //                                   await imageData.toByteData(
  //                                       format: ui
  //                                           .ImageByteFormat
  //                                           .png);
  //                                   if (bytes != null) {
  //                                     dataSignature = bytes.buffer
  //                                         .asUint8List();
  //                                   }
  //
  //                                   List<dynamic> reports = [];
  //                                   getNextData() async {
  //                                     print(files.last);
  //
  //                                     var d = await firestore!
  //                                         .collection("pulltest")
  //                                         .doc(files
  //                                         .last)
  //                                         .get();
  //
  //                                     var attachments = await firestore!
  //                                         .collection("pulltest")
  //                                         .doc(files
  //                                         .last)
  //                                         .collection("attachments")
  //                                         .get();
  //                                     List attachment = [];
  //
  //                                     if (attachments.size > 0 &&
  //                                         attachments.docs.length >
  //                                             0) {
  //                                       for (int i = 0;
  //                                       i <
  //                                           attachments
  //                                               .docs.length;
  //                                       i++) {
  //                                         attachment.add({
  //                                           "id": attachments
  //                                               .docs[i].id,
  //                                           "type": attachments
  //                                               .docs[i]
  //                                               .get("type"),
  //                                           "time": attachments
  //                                               .docs[i]
  //                                               .get("time"),
  //                                           "link": attachments
  //                                               .docs[i]
  //                                               .get(attachments
  //                                               .docs[i]
  //                                               .get("type") + "File")
  //                                         });
  //                                       }
  //                                     }
  //
  //                                     reports.add({
  //                                       "attachment": attachment,
  //                                       "data": d.data(),
  //                                       "id": d.id
  //                                     });
  //                                     files
  //                                         .removeLast();
  //                                     if (files.length >
  //                                         0) {
  //                                       getNextData();
  //                                     } else {
  //                                       firestore!
  //                                           .collection("reports")
  //                                           .add({
  //                                         "report_by": FirebaseAuth
  //                                             .instance
  //                                             .currentUser!
  //                                             .uid,
  //                                         "field_1": contoller.text,
  //                                         "field_2":
  //                                         contoller2.text,
  //                                         "field_3":
  //                                         contoller3.text,
  //                                         "field_4":
  //                                         contoller4.text,
  //                                         "field_5":
  //                                         contoller5.text,
  //                                         "field_6":
  //                                         contoller6.text,
  //                                         // "data": reports,
  //                                         "created_at": DateTime
  //                                             .now()
  //                                             .millisecondsSinceEpoch,
  //                                         "signature": dataSignature
  //                                       }).then((value) async {
  //                                         for (int i = 0;
  //                                         i < reports.length;
  //                                         i++) {
  //                                           await firestore!
  //                                               .collection(
  //                                               "reports")
  //                                               .doc(value.id)
  //                                               .collection("items")
  //                                               .add(reports[i]);
  //                                         }
  //
  //                                         FirebaseFirestore.instance
  //                                             .collection(
  //                                             "customers")
  //                                             .doc(
  //                                             customerID)
  //                                             .get()
  //                                             .then((value2) {
  //                                           FirebaseFirestore
  //                                               .instance
  //                                               .collection(
  //                                               "reports")
  //                                               .add({
  //                                             "report_id": value.id,
  //                                             "password":
  //                                             contoller7.text,
  //                                             "resource_id": value2
  //                                                 .get("projectId")
  //                                           });
  //                                         });
  //                                         String link =
  //                                             "https://staht-16a50.web.app/?report=" +
  //                                                 value.id;
  //                                         Navigator.pop(context);
  //
  //                                         showAlertDialog(BuildContext
  //                                         context) {
  //                                           // set up the button
  //                                           Widget okButton =
  //                                           FlatButton(
  //                                             child: Text("Close"),
  //                                             onPressed: () {
  //                                               Navigator.pop(
  //                                                   context);
  //                                               Navigator.pop(
  //                                                   context);
  //                                             },
  //                                           );
  //                                           Widget Copy =
  //                                           FlatButton(
  //                                             child:
  //                                             Text("Copy Link"),
  //                                             onPressed: () {
  //                                               Clipboard.setData(
  //                                                   ClipboardData(
  //                                                       text:
  //                                                       link));
  //                                               Navigator.pop(
  //                                                   context);
  //                                               Navigator.pop(
  //                                                   context);
  //                                               Scaffold.of(context)
  //                                                   .showSnackBar(
  //                                                   SnackBar(
  //                                                       content:
  //                                                       Text(
  //                                                           "Copied to clipboard")));
  //                                             },
  //                                           );
  //                                           Widget share =
  //                                           FlatButton(
  //                                             child: Text(
  //                                                 "Share Link"),
  //                                             onPressed: () {
  //                                               Share.share(link);
  //                                               Navigator.pop(
  //                                                   context);
  //                                               Navigator.pop(
  //                                                   context);
  //                                             },
  //                                           );
  //
  //                                           // set up the AlertDialog
  //                                           AlertDialog alert =
  //                                           AlertDialog(
  //                                             title:
  //                                             Text("Success"),
  //                                             content: Text(link),
  //                                             actions: [
  //                                               okButton,
  //                                               Copy,
  //                                               share
  //                                             ],
  //                                           );
  //
  //                                           // show the dialog
  //                                           showDialog(
  //                                             context: context,
  //                                             builder: (BuildContext
  //                                             context) {
  //                                               return alert;
  //                                             },
  //                                           );
  //                                         }
  //
  //
  //                                         showAlertDialog(context);
  //                                       });
  //                                     }
  //                                   }
  //
  //                                   if (files.length >
  //                                       0) {
  //                                     getNextData();
  //                                   }
  //                                 } else {
  //                                   final snackBar = SnackBar(
  //                                       content: Text(
  //                                           'Password should be more than 4 character'));
  //
  //                                   ScaffoldMessenger.of(context)
  //                                       .showSnackBar(snackBar);
  //                                 }
  //                               }
  //                             },
  //                             child: Padding(
  //                               padding: const EdgeInsets.all(8.0),
  //                               child: Card(
  //                                 shape: RoundedRectangleBorder(
  //                                   borderRadius:
  //                                   BorderRadius.circular(0.0),
  //                                 ),
  //                                 color: Theme
  //                                     .of(context)
  //                                     .primaryColor,
  //                                 child: Center(
  //                                     child: Padding(
  //                                       padding:
  //                                       const EdgeInsets.all(8.0),
  //                                       child: Text("Generate",
  //                                           style: TextStyle(
  //                                               color: Colors.white)),
  //                                     )),
  //                               ),
  //                             ),
  //                           )),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //     ));
}
        },
        child: Container(
            margin: EdgeInsets.only(
                right: width * 0.05,
                left: width * 0.05,
                bottom: width * 0.18,
                top: height * 0.02),
            child: ButtonView(buttonLabel: TextConst.generateReportText,)),
        // child: Row(
        //   children: [
        //     Expanded(
        //         child: Padding(
        //           padding: const EdgeInsets.all(10.0),
        //           child: Container(
        //               decoration: BoxDecoration(boxShadow: [
        //                 BoxShadow(
        //                   color: Colors.grey,
        //                   offset: Offset(0.0, 1.0), //(x,y)
        //                   blurRadius: 6.0,
        //                 ),
        //               ], color: Theme.of(context!).primaryColor),
        //               child: Center(
        //                   child: Padding(
        //                     padding: const EdgeInsets.all(8.0),
        //                     child: Text(
        //                       "Press to Generate report",
        //                       style: TextStyle(
        //                         color: Colors.white,
        //                       ),
        //                     ),
        //                   ))),
        //         )),
        //     Expanded(
        //         child: Padding(
        //           padding: const EdgeInsets.all(10.0),
        //           child: Container(
        //               decoration: BoxDecoration(boxShadow: [
        //                 BoxShadow(
        //                   color: Colors.grey,
        //                   offset: Offset(0.0, 1.0), //(x,y)
        //                   blurRadius: 6.0,
        //                 ),
        //               ], color: Theme.of(context!).primaryColor),
        //               child: Center(
        //                   child: Padding(
        //                     padding: const EdgeInsets.all(8.0),
        //                     child: Text(
        //                       "Download Raw Data",
        //                       style: TextStyle(
        //                         color: Colors.white,
        //                       ),
        //                     ),
        //                   ))),
        //         )),
        //   ],
        // ),
      );
      else return Container(width: 0,height: 0,);
    }

    return StreamBuilder<List>(
        stream: ReportingsLogics().fileSelectedForReportStream().outData,
        initialData: [],
        builder: (c, snapshotFiles) {
          print("stream out 2");

          print(snapshotFiles.data);



            return StreamBuilder<List>(
                stream: ReportingsLogics().folderSelectedForReportStream().outData, initialData: [],
                builder: (c, snapshot) {
                  print("stream out 2");
                  print(snapshot.data);
                  if(snapshot.hasData){
                    if(snapshot.data!.length > 0){
                      return show(files: snapshotFiles.data!,folders: snapshot.data!);
                    }else{

                      return show(files: snapshotFiles.data!,folders: []);
                    }

                  }else{
                    if(snapshotFiles.hasData)
                    return show(files: snapshotFiles.data!,folders: []);
                    else  return show(files: [],folders: []);
                  }
                });




        });


  }
}
class AllFileFolderForReporting extends StatefulWidget {
  List<String> folderStack = ["root"];
  String currentFolderName = "";
  FirebaseFirestore customerFirestore;
  String customerId;
  Locale locale;
  Widget appbar;

  AllFileFolderForReporting({required this.appbar,required this.customerId, required this.customerFirestore, required this.locale});

  @override
  _AllFileFolderActivityReportingState createState() =>
      _AllFileFolderActivityReportingState();
}


class _AllFileFolderActivityReportingState
    extends State<AllFileFolderForReporting> {
  fileSortType selectedSortType = fileSortType.none;
  List<String> selectedItemFiles = [];
  List<String> selectedItemFolders = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedItemFiles.clear();
    selectedItemFolders.clear();

    listenClickedStream();
  }

  bool checkAvailableInFolders(String id) {
    if (selectedItemFolders.length > 0 && selectedItemFolders.contains(id)) {
      return true;
    } else {
      return false;
    }
  }

  bool checkAvailableInFiles(String id) {
    if (selectedItemFiles.length > 0 && selectedItemFiles.contains(id)) {
      return true;
    } else {
      return false;
    }
  }
  @override
  Widget build(BuildContext context) {

    TextEditingController _folderNameController = TextEditingController();
    AppTitleAppbarStream.getInstance().dataReload( TextConst.reportTitleText);



    return SafeArea(child: Scaffold( backgroundColor: AppThemeManager().getScaffoldBackgroundColor(),  appBar: PreferredSize(
      preferredSize: AppBar().preferredSize,
      child:  ApplicationAppbar(). getAppbar(title: "Report"),
    ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             // ApplicationAppbar(). getAppbar(title: "Report"),
              // Container(
              //     child: AppbarView(
              //       appbarTitleText: TextConst.reportTitleText,
              //     )
              // ),
              Container(
                margin: EdgeInsets.only(
                    //left: width * 0.05,
                   // right: width * 0.05,
                    top: height * 0.02,
                    bottom: height * 0.02),
                child: Column(children: [
                  ReportingsUi(). getTopText(),

                  ReportingsUi(context: context).getTableHeader(),
                  // ReportingsUi(context: context).getTableBody(),





                 false? Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: widget.folderStack.length > 1
                            ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Card(
                              child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      widget.folderStack.removeLast();
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.chevron_left_outlined),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.currentFolderName,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                            )
                          ],
                        )
                            : Container(
                          width: 0,
                          height: 0,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Wrap(
                          children: [
                            Card(
                              child: InkWell(
                                onTap: () {
                                  showDialog<void>(
                                      context: context, builder: (context) => ReportingsUi(firestore: widget.customerFirestore,context: context).createFolderDialog(parentFolderId: widget.folderStack.last));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.add),
                                ),
                              ),
                            ),

                            Container(
                              width: 50,
                              height: 50,
                              child: Card(
                                child: PopupMenuButton<fileSortType>(
                                  onSelected: (fileSortType value) {
                                    setState(() {
                                      selectedSortType = value;
                                    });
                                  },
                                  initialValue: selectedSortType,
                                  child: Center(child: Icon(Icons.sort)),
                                  itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<fileSortType>>[
                                    PopupMenuItem<fileSortType>(
                                      value: fileSortType.none,
                                      child: Text('None'),
                                    ),
                                    PopupMenuItem<fileSortType>(
                                      value: fileSortType.title,
                                      child: Text('Title'),
                                    ),
                                    PopupMenuItem<fileSortType>(
                                      value: fileSortType.date,
                                      child: Text('Date'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ):Container(height: 0,width: 0,),
                  Divider(),

                  ExpandenFolderActivityForReporting(parentFolder: 'root', locale: widget.locale,customerFirestore: widget.customerFirestore,customerId: widget.customerId,),


                //
                // false?  StreamBuilder<QuerySnapshot>(
                //       stream: widget.customerFirestore
                //           .collection("folders")
                //       //  .orderBy("created_at",descending: true)
                //           .where(
                //         "parent",
                //         isEqualTo: widget.folderStack.last,
                //       )
                //           .snapshots(),
                //       builder: (context, snapshot) {
                //         if (snapshot.hasData &&
                //             snapshot.data != null &&
                //             snapshot.data!.docs != null) {
                //           if (snapshot.data!.size > 0) {
                //             //List list = snapshot.data.docs;
                //             List<QueryDocumentSnapshot<Object?>> sortedList = [];
                //
                //             if (selectedSortType == fileSortType.none) {
                //               sortedList = snapshot.data!.docs;
                //             }
                //             if (selectedSortType == fileSortType.title) {
                //               sortedList = snapshot.data!.docs;
                //               try{
                //                 sortedList.sort((a, b) {
                //                   return a
                //                       .get("name")
                //                       .toString()
                //                       .toLowerCase()
                //                       .compareTo(
                //                       b.get("name").toString().toLowerCase());
                //                 });
                //               }catch(e){
                //                 print(e);
                //               }
                //             }
                //             if (selectedSortType == fileSortType.date) {
                //               sortedList = snapshot.data!.docs;
                //               try{
                //                 sortedList.sort((a, b) {
                //                   return a
                //                       .get("created_at")
                //                       .toString()
                //                       .toLowerCase()
                //                       .compareTo(
                //                       b.get("created_at").toString().toLowerCase());
                //                 });
                //               }catch(e){
                //                 print(e);
                //               }
                //               sortedList = sortedList.reversed.toList();
                //             }
                //
                //             return ListView.builder(
                //                 physics: ClampingScrollPhysics(),
                //                 // separatorBuilder: (context, index) {
                //                 //   return Divider();
                //                 // },
                //                 shrinkWrap: true,
                //                 padding: EdgeInsets.zero,
                //                 itemCount: sortedList.length,
                //                 itemBuilder: (_, index) {
                //                   return Container(
                //                     width: MediaQuery.of(context).size.width,
                //                     child: InkWell(
                //                       onTap: () {
                //                         setState(() {
                //                           widget.currentFolderName = sortedList[index]["name"];
                //                           widget.folderStack.add(sortedList[index].id);
                //                         });
                //                       },
                //                       child: Padding(
                //                         padding:
                //                         const EdgeInsets.fromLTRB(0, 2, 0, 2),
                //                         child: Container(
                //                           height: 40,
                //                           width: MediaQuery.of(context).size.width,
                //                           child: Stack(
                //                             children: [
                //                               Align(
                //                                 alignment: Alignment.centerLeft,
                //                                 child: Row(
                //                                   children: [
                //                                     Padding(
                //                                       padding:
                //                                       const EdgeInsets.fromLTRB(
                //                                           5, 5, 5, 5),
                //                                       child: Padding(
                //                                         padding:
                //                                         const EdgeInsets.all(4.0),
                //                                         child: Icon(
                //                                           Icons.folder,
                //                                           color: Theme.of(context)
                //                                               .primaryColor,
                //                                           size: 30,
                //                                         ),
                //                                       ),
                //                                     ),
                //                                     Column(
                //                                       mainAxisAlignment:
                //                                       MainAxisAlignment.center,
                //                                       crossAxisAlignment:
                //                                       CrossAxisAlignment.start,
                //                                       children: [
                //                                         Text(
                //                                           sortedList[index]["name"]
                //                                               .toString(),
                //                                           style: TextStyle(
                //                                               fontWeight:
                //                                               FontWeight.bold,
                //                                               color: Colors.black),
                //                                         ),
                //                                         timeFormate(sortedList[index]
                //                                         ["created_at"]),
                //                                       ],
                //                                     ),
                //                                   ],
                //                                 ),
                //                               ),
                //                               Align(
                //                                 alignment: Alignment.centerRight,
                //                                 child: Container(
                //                                   height: MediaQuery.of(context)
                //                                       .size
                //                                       .height,
                //                                   child: InkWell(
                //                                     onTap: () {
                //                                       if (checkAvailableInFolders(sortedList[index].id) == true) {
                //                                         selectedItemFolders.remove(sortedList[index].id);
                //                                         print("stream data put");
                //                                         print(selectedItemFolders.length);
                //                                         ReportingsLogics().folderSelectedForReportStream().dataReload(selectedItemFolders);
                //                                       } else {
                //                                         selectedItemFolders.add(sortedList[index].id);
                //                                         print("stream data put");
                //                                         print(selectedItemFolders.length);
                //                                         ReportingsLogics().folderSelectedForReportStream().dataReload(selectedItemFolders);
                //                                       }
                //
                //                                       // setState(() {
                //                                       //
                //                                       // });
                //                                     },
                //                                     child: Padding(
                //                                       padding:
                //                                       const EdgeInsets.all(8.0),
                //                                       child: StreamBuilder<List>(
                //                                           stream:ReportingsLogics().folderSelectedForReportStream().outData,
                //
                //                                           builder: (context, snapshot) {
                //                                             return  Text(checkAvailableInFolders(sortedList[index].id) ? "Remove" : "Select",
                //                                               style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                //                                             );
                //
                //                                           }),
                //
                //
                //                                     ),
                //                                   ),
                //                                 ),
                //                               ),
                //                             ],
                //                           ),
                //                         ),
                //                       ),
                //                     ),
                //                   );
                //
                //                 });
                //           } else
                //             return Container(
                //                 height: 000,
                //                 child: Center(child: Text("No Folders")));
                //         } else {
                //           return Center(child: Text("No Folders"));
                //         }
                //       }):Container(width: 0,height: 0,),
                //   false?  StreamBuilder<QuerySnapshot>(
                //       stream: widget.customerFirestore
                //           .collection("folders")
                //           .doc(widget.folderStack.last)
                //           .collection("records")
                //           .snapshots(),
                //       builder: (context, snapshot) {
                //         if (snapshot.hasData &&
                //             snapshot.data != null &&
                //             snapshot.data!.docs.length > 0) {
                //           // return Text(snapshot.data.docs[0].get("id"));
                //           Map<String, String> fileAndFolderSource =
                //           Map<String, String>();
                //
                //           List<QueryDocumentSnapshot<Object>> filteredData = [];
                //           List<DocumentSnapshot<Object>> allData = [];
                //
                //           for (int i = 0; i < snapshot.data!.docs.length; i++) {
                //             // allData.add(value)
                //
                //             widget.customerFirestore
                //                 .collection("pulltest")
                //                 .doc(snapshot.data!.docs[i].get("id"))
                //                 .get()
                //                 .then((value) {
                //               //value.data()["folderID"]= snapshot.data.docs[i].id;
                //               // Map<String, dynamic> da = value.data();
                //               fileAndFolderSource.putIfAbsent(
                //                   value.id, () => snapshot.data!.docs[i].id);
                //
                //               // da["folderID"] = snapshot.data.docs[i].id;
                //               allData.add(value);
                //               FilteredDataShow.getInstance().dataReload(allData);
                //
                //               print("size " + allData.length.toString());
                //             });
                //           }
                //
                //           // if (selectedSortType == fileSortType.none) {
                //           //   filteredData = snapshot.data.docs;
                //           // } else if (selectedSortType == fileSortType.date) {
                //           //   filteredData = snapshot.data.docs;
                //           //   filteredData.sort((a, b) {
                //           //     return a
                //           //         .get("name")
                //           //         .toString()
                //           //         .toLowerCase()
                //           //         .compareTo(b.get("name").toString().toLowerCase());
                //           //   });
                //           // }
                //           print("now = > " + allData.length.toString());
                //
                //           return StreamBuilder<List<DocumentSnapshot<Object>>>(
                //               stream: FilteredDataShow.getInstance().outData,
                //               builder: (BuildContext context,
                //                   AsyncSnapshot<List<DocumentSnapshot<Object>>>
                //                   snapshot) {
                //                 List<DocumentSnapshot<Object?>> sortedList = [];
                //                 if (snapshot.hasData && snapshot.data!.length > 0) {
                //                   if (selectedSortType == fileSortType.none) {
                //                     sortedList = snapshot.data!;
                //                   }
                //                   if (selectedSortType == fileSortType.title) {
                //                     sortedList = snapshot.data!;
                //                     try{
                //                       sortedList.sort((a, b) {
                //                         return a
                //                             .get("name")
                //                             .toString()
                //                             .toLowerCase()
                //                             .compareTo(
                //                             b.get("name").toString().toLowerCase());
                //                       });
                //                     }catch(e){
                //                       print(e);
                //                     }
                //                   }
                //                   if (selectedSortType == fileSortType.date) {
                //                     sortedList = snapshot.data!;
                //                     try{
                //                       sortedList.sort((a, b) {
                //                         return a
                //                             .get("time")
                //                             .toString()
                //                             .toLowerCase()
                //                             .compareTo(
                //                             b.get("time").toString().toLowerCase());
                //                       });
                //                     }catch(e){
                //
                //                     }
                //                     sortedList = sortedList.reversed.toList();
                //                   }
                //                   return sortedList.length > 0
                //                       ? ListView.builder(
                //                       physics: ClampingScrollPhysics(),
                //                       // separatorBuilder: (context, index) {
                //                       //   return Divider();
                //                       // },
                //                       padding: EdgeInsets.zero,
                //                       shrinkWrap: true,
                //                       itemCount: sortedList.length,
                //                       itemBuilder: (_, index) {
                //                         if (sortedList[index].exists &&
                //                             sortedList[index].get("name") !=
                //                                 null) {
                //                           return Container(
                //                             height: 40,
                //                             child: Stack(
                //                               children: [
                //                                 Align(
                //                                   alignment: Alignment.centerLeft,
                //                                   child: InkWell(
                //                                     onTap: () {
                //                                       print(sortedList[index]
                //                                           .data()
                //                                           .toString());
                //                                       if (sortedList[index]
                //                                           .exists &&
                //                                           sortedList[index]
                //                                               .get("name") !=
                //                                               null) {
                //                                         AppWidgets(customerId:  widget.customerId,customerFirestore:  widget
                //                                             .customerFirestore). showTestRecordBody(
                //
                //                                             sortedList[index].id,
                //                                             sortedList[index],
                //                                             context,widget.locale,3
                //                                         );
                //                                       }
                //                                     },
                //                                     child: Row(
                //                                       children: [
                //                                         Padding(
                //                                           padding:
                //                                           const EdgeInsets
                //                                               .fromLTRB(
                //                                               5, 5, 5, 5),
                //                                           child: Padding(
                //                                             padding:
                //                                             const EdgeInsets
                //                                                 .all(4.0),
                //                                             child: Icon(
                //                                               Icons
                //                                                   .sticky_note_2_rounded,
                //                                               size: 30,
                //                                             ),
                //                                           ),
                //                                         ),
                //                                         Column(
                //                                           mainAxisAlignment:
                //                                           MainAxisAlignment
                //                                               .start,
                //                                           crossAxisAlignment:
                //                                           CrossAxisAlignment
                //                                               .start,
                //                                           children: [
                //                                             Text(
                //                                                 sortedList[index]
                //                                                     .get("name"),
                //                                                 style: TextStyle(
                //                                                     fontWeight:
                //                                                     FontWeight
                //                                                         .bold,
                //                                                     color: Colors
                //                                                         .black)),
                //                                             timeFormate(
                //                                                 sortedList[index]
                //                                                     .get("time")),
                //                                           ],
                //                                         ),
                //                                       ],
                //                                     ),
                //                                   ),
                //                                 ),
                //                                 Align(
                //                                   alignment:
                //                                   Alignment.centerRight,
                //                                   child: InkWell(
                //                                     onTap: () {
                //                                       if (checkAvailableInFiles(sortedList[index].id) == true) {
                //                                         selectedItemFiles.remove(sortedList[index].id);
                //                                         print("stream data put 2");
                //                                         print(selectedItemFiles.length);
                //                                         ReportingsLogics().fileSelectedForReportStream().dataReload(selectedItemFiles);
                //                                       } else {
                //                                         selectedItemFiles.add(sortedList[index].id);
                //                                         print("stream data put 2");
                //                                         print(selectedItemFiles.length);
                //                                         ReportingsLogics().fileSelectedForReportStream().dataReload(selectedItemFiles);
                //                                       }
                //
                //
                //
                //                                       // setState(() {
                //                                       //
                //                                       // });
                //                                     },
                //                                     child: Padding(
                //                                       padding:
                //                                       const EdgeInsets.all(
                //                                           8.0),
                //                                       child:  StreamBuilder<List>(
                //                                           stream: ReportingsLogics().fileSelectedForReportStream().outData,
                //                                           builder: (c, snapshot) {
                //                                             return Text(
                //                                               checkAvailableInFiles(
                //                                                   sortedList[index]
                //                                                       .id)
                //                                                   ? "Remove"
                //                                                   : "Select",
                //                                               style: TextStyle(
                //                                                   color:
                //                                                   Theme.of(context)
                //                                                       .primaryColor,
                //                                                   fontWeight:
                //                                                   FontWeight.bold),
                //                                             );
                //                                           }),
                //
                //                                     ),
                //                                   ),
                //                                 ),
                //                               ],
                //                             ),
                //                           );
                //                         } else
                //                           return Container(
                //                             width: 0,
                //                             height: 0,
                //                           );
                //                       })
                //                       : Container(
                //                     width: 0,
                //                     height: 0,
                //                   );
                //                 } else
                //                   return Container(
                //                     width: 0,
                //                     height: 0,
                //                   );
                //               });
                //
                //
                //         } else {
                //           return Text("");
                //         }
                //       }):Container(width: 0,height: 0,),
                  ReportingsUi(context: context,firestore: widget.customerFirestore,customerID: widget.customerId).showButtons(),

                ],),
              ),

            ],
          ),
        ),
      ),
    ));



  }

  void listenClickedStream() {
    NeedToRefreshFilesNameAsStream.getInstance().outData.listen((event) {
      // Fluttertoast.showToast(
      //     msg: "clicked to refresh",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     fontSize: 16.0
      // );
      ReportingsLogics().fileSelectedForReportStream().dataReload( selectedItemFiles);
    });
    FileClickedForReportingAsStream.getInstance().outData.listen((event) {


    if (checkAvailableInFiles(event) == true) {
      print("passed true");
       selectedItemFiles.remove(event);

      ReportingsLogics().fileSelectedForReportStream().dataReload( selectedItemFiles);
    } else {
      print("passed false");
      selectedItemFiles.add(event);

      ReportingsLogics().fileSelectedForReportStream().dataReload(selectedItemFiles);
    }
    ReportingsLogics().fileSelectedForReportStream().dataReload(selectedItemFiles);
    ReportingsLogics().folderSelectedForReportStream().dataReload(selectedItemFolders);
    });



    //folder

    NeedToRefreshFoldersNameAsStream.getInstance().outData.listen((event) {
      // Fluttertoast.showToast(
      //     msg: "clicked to refresh",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     fontSize: 16.0
      // );
      //ReportingsLogics().fileSelectedForReportStream().dataReload( selectedItemFolders);
    });
    FolderClickedForReportingAsStream.getInstance().outData.listen((event) {


      if (checkAvailableInFolders(event) == true) {
        print("passed true");
        selectedItemFolders.remove(event);

        ReportingsLogics().folderSelectedForReportStream().dataReload( selectedItemFolders);
      } else {
        print("passed false");
        selectedItemFolders.add(event);

        ReportingsLogics().folderSelectedForReportStream().dataReload(selectedItemFolders);
      }
      ReportingsLogics().fileSelectedForReportStream().dataReload(selectedItemFiles);
      ReportingsLogics().folderSelectedForReportStream().dataReload(selectedItemFolders);
     // ReportingsLogics().folderSelectedForReportStream().dataReload(selectedItemFolders);
    });


  }




}