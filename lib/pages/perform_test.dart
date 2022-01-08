import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:connect/utils/featureSettings.dart';
import 'package:flutter/material.dart';
import 'package:connect/streams/buttonStreams.dart';
import 'package:connect/widgets/cu.dart';
import 'package:connect/widgets/lists_widgets.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
 import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart';
import 'package:connect/models/Chartsample.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:connect/models/BarChartModel.dart';
import 'package:connect/pages/connected_device_page.dart';
import 'package:connect/pages/graph_two.dart';
import 'package:connect/pages/graph_widget.dart';
import 'package:connect/services/database.dart';
import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:image/image.dart' as tt;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'app_map_view.dart';
import 'graph_3.dart';



enum TestStatus { stopped, running }



class RetrivedValue extends StatefulWidget {
  // List<BarChartModel> data2 = [];
  List<ChartSampleData> data3 = [];
  List<double> data2 = [];
  List<ChartSampleData> onlyShow = [];
  List<String> testDataToSave = [];
  int _start = 20;
  int testDuration = 20;
  List<double> traceSine = [];
  String initButtonMessage = "Run New Pull Test";
  String messageDetails = "";

  bool shouldCollect = false;

  double radians = 0.0;
  BluetoothCharacteristic characteristic;
  String retValueFromStream = "No Data";

  String ser;
  String char;
  bool hasSuccessfullyFinishedTest = false;

  RetrivedValue(this.characteristic, this.ser, this.char);

  @override
  _RetrivedValueState createState() => _RetrivedValueState();
}

class _RetrivedValueState extends State<RetrivedValue> {
 late Timer _timer;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (widget._start == 0) {
          String uid = FirebaseAuth.instance.currentUser!.uid;
          Database(firestore: FirebaseFirestore.instance)
              .addTestData(uid: uid, data: widget.testDataToSave);
          setState(() {
            timer.cancel();
            widget.hasSuccessfullyFinishedTest = true;
            widget.shouldCollect = false;
            widget.messageDetails =
                "Test finished and saved.Click to run again";
          });
        } else {
          setState(() {
            widget._start--;
            widget.shouldCollect = true;
          });
        }
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      widget.messageDetails = widget.initButtonMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    TestStatus testStatus = TestStatus.stopped;
    return StreamBuilder<List<int>>(
        stream: widget.characteristic.value,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data!.length > 0) {
            if (widget.onlyShow.length < 100) {
              widget.onlyShow.add(ChartSampleData(
                  x: new DateTime.now(),
                  y: double.parse(convert(snapshot.data!)), color: 1));
            } else {
              widget.onlyShow.removeAt(0);
              widget.onlyShow.add(ChartSampleData(
                  color: 1,
                  x: new DateTime.now(),
                  y: double.parse(convert(snapshot.data!))));
            }

            if (widget.shouldCollect) {
              this.widget.testDataToSave.add(convert(snapshot.data!));
              this.widget.data2.add(double.parse(convert(snapshot.data!)));
              this.widget.data3.add(ChartSampleData(
                  x: new DateTime.now(),
                  y: double.parse(convert(snapshot.data!)), color: 1));
              // this.widget.data2.add(BarChartModel(
              //   time: widget.data2.length + 1,
              //   value: double.parse(convert(snapshot.data)),
              //   color: Colors.red,
              // ));
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FlatButton(
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0)),
                  child: new Text('round button'),
                  onPressed: () {},
                ),
                widget.onlyShow.length > 5
                    ? Container(
                        height: 200, child: DefaultPanning(widget.onlyShow,0))
                    : Text(""),
                // Container(height: 200, child: DefaultPanning(widget.onlyShow)),

                widget.shouldCollect
                    ? CircularProgressIndicator()
                    : Text(""),
                Text(
                  convert(snapshot.data!),
                  style: TextStyle(fontSize: 30),
                ),

                RaisedButton(
                  onPressed: () {
                    setState(() {
                      widget.shouldCollect
                          ? (widget.shouldCollect = false)
                          : (widget.shouldCollect = true);
                    });

                    if (widget.shouldCollect) {
                      widget.testDataToSave.clear();
                      widget.data2.clear();
                      widget.hasSuccessfullyFinishedTest = false;
                      startTimer();
                      setState(() {
                        widget._start = widget.testDuration;
                        widget.messageDetails = "Test is running.";
                      });
                    } else {
                      widget.hasSuccessfullyFinishedTest = false;
                      _timer.cancel();
                      setState(() {
                        widget._start = 0;
                        widget.data2.clear();
                        widget.testDataToSave.clear();
                        widget.messageDetails = widget.initButtonMessage;
                      });
                    }
                  },
                  child: Text(widget.messageDetails),
                ),
                Text(((widget.testDuration - widget._start) * 10).toString() +
                    " % Done"),
                //  widget.data2.length>0?  Container(height: 200,child: AnimationSplineDefault(widget.data2)):Center(child: Text("No Data"),),
                widget.data3.length > 0
                    ? Container(
                        height: 200, child: DefaultPanning(widget.data3,0))
                    : Center(
                        child: Text("No Data"),
                      ),
                Text(widget.testDataToSave.toString()),

                //BarChartDemo()
              ],
            );
          } else
            return Text("No Data in Stream");
          return Text("Please wait");
        });
  }
}

String convertwithDecimalplaces(List<int> data, int decimalPLace) {
  String returnValue = "";

  final result = data.map((b) => '${b.toRadixString(16).padLeft(2, '0')}');
  //print('bytes: ${result}');
  HexEncoder _hexEncoder;
  var bd = ByteData(4);
  for (int i = 0; i < data.length; i++) {
    String tempVal = data[i].toRadixString(16).padLeft(2, '0').toString();
    //returnValue = returnValue+tempVal;

    bd.setUint8(i, data[i].toInt());
  }
  var f = bd.getFloat32(0);
  // print(f);
  bd.setUint32(0, 0x41480000);
  var f1 = bd.getFloat32(0);
  // print(f1);
  // print(_hexEncoder.);
//  returnValue =data[0].toRadixString(16).padLeft(2, '0')+data[0].toRadixString(16).padLeft(2, '0')+data[0].toRadixString(16).padLeft(2, '0')+data[0].toRadixString(16).padLeft(2, '0');
  return f.toStringAsFixed(decimalPLace);
}

String convert(List<int> data) {
  String returnValue = "";

  final result = data.map((b) => '${b.toRadixString(16).padLeft(2, '0')}');
  //print('bytes: ${result}');
  HexEncoder _hexEncoder;
  var bd = ByteData(4);
  for (int i = 0; i < data.length; i++) {
    String tempVal = data[i].toRadixString(16).padLeft(2, '0').toString();
    //returnValue = returnValue+tempVal;

    bd.setUint8(i, data[i].toInt());
  }
  var f = bd.getFloat32(0);
  // print(f);
  bd.setUint32(0, 0x41480000);
  var f1 = bd.getFloat32(0);
  // print(f1);
  // print(_hexEncoder.);
//  returnValue =data[0].toRadixString(16).padLeft(2, '0')+data[0].toRadixString(16).padLeft(2, '0')+data[0].toRadixString(16).padLeft(2, '0')+data[0].toRadixString(16).padLeft(2, '0');
  return f.toStringAsFixed(PrefferedDecimalPlaces);
}

class _ChartData {
  _ChartData(this.x, this.y, Color color);

  final int x;
  final int y;
}




void saveAllphotos() {}

// void showWidgetinModal(
//     BuildContext context, PerformTestPage widget, Widget wid) {
//   showModalBottomSheet(
//       context: context,
//       builder: (BuildContext bc) {
//         return wid;
//       });
// }

void showMessage(BuildContext context, String message) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(message),
        );
      });
}



class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({ Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}

// class TestFinishedActivity extends StatefulWidget {
//   List<ChartSampleData> data3;
//   List<Map<String,dynamic>>photos = [];
//   @override
//   _TestFinishedActivityState createState() => _TestFinishedActivityState();
// }
//
// class _TestFinishedActivityState extends State<TestFinishedActivity> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body: Stack(children: [
//       Align(
//         alignment: Alignment.center,
//         child: Column(
//           children: [
//             Container(
//                 height: 200, child: DefaultPanning(widget.data3)),
//             GridView.builder(
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 3),
//                 shrinkWrap: true,
//                 itemCount: widget.photos.length,
//                 itemBuilder: (_, index) {
//                   return Padding(
//                     padding: const EdgeInsets.all(5.0),
//                     child: Container(child:Image.file(File(widget.photos[index]["imagePath"]),fit: BoxFit.cover,) ),
//                   );
//
//                 }),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text("Test Finished. Do you want to save ?"),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 children: [
//                   Expanded(child: InkWell(onTap: (){
//
//                     Navigator.pop(context);
//                   },child: Container(child: Card(color: Colors.redAccent,child: Center(child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text("NO",style: TextStyle(color: Colors.white),),
//                   )))))),
//                   Expanded(child: InkWell(onTap: (){
//                     setState(() {
//                       widget.savingModePrimary = true ;
//                     });
//
//                     FirebaseFirestore firestore = FirebaseFirestore
//                         .instanceFor(
//                         app: Firebase.app(
//                             widget.project));
//                     List<Map<String,
//                         dynamic>> testData = [];
//                     for (int i = 0; i <
//                         widget.data3.length; i++) {
//                       testData.add({
//                         "time": widget.data3[i]
//                             .x
//                             .millisecondsSinceEpoch,
//                         "value": widget.data3[i].y
//                       });
//                     }
//                     try{
//
//                       List allPHotos = widget.photos;
//                       firestore.collection("pulltest")
//                           .add({
//                         "note":testNoteController.text,
//                         "name":testNameController.text,
//                         "address":textAddress,
//                         "time":new DateTime.now().millisecondsSinceEpoch,
//
//                         "uid": FirebaseAuth.instance.currentUser.uid,
//                         "data": jsonEncode(testData),
//                         //"photo": jsonEncode(widget.photos),
//                         "location":currentLocation==null?0:{"lat":currentLocation.latitude,"long":currentLocation.longitude,"alt":currentLocation.altitude}
//                       }).then((value) {
//                         for(int i = 0 ; i < allPHotos.length ; i ++){
//
//                           firestore.collection("pulltest").doc(value.id).collection("attachments").add({"type":"photo"}).then((valueofAttachmentId) {
//                             //showMessage(context, allPHotos[i].length.toString());
//
//                             List imagePartsStack = [];
//                             for(int  j = 0 ; j < allPHotos[i]["image"].length; j++){
//
//
//                               imagePartsStack.add(allPHotos[i]["image"][j]);
//
//
//                             }
//
//                             int index = 0;
//                             pushData(){
//                               firestore.collection("attachmentparts").add({"data":imagePartsStack.last,"id":valueofAttachmentId.id,"index":index}).then((valueofattachmentpost) {
//                                 index++;
//                                 imagePartsStack.removeLast();
//                                 if(imagePartsStack.isNotEmpty)pushData();
//                                 else {
//                                   if(i == (allPHotos.length-1)){
//                                     setState(() {
//
//
//
//                                       widget.savingModePrimary = true ;
//
//
//
//
//                                       widget.data3.clear();
//                                       widget.data2.clear();
//                                       widget.photos.clear();
//                                     });
//
//                                     _settingModalBottomSheet(context, widget,value.id);
//                                   }
//                                 }
//
//
//                               });
//                             }
//                             if(imagePartsStack.length>0){
//                               pushData();
//                             }
//
//
//
//
//
//                           });
//
//
//                         }
//
//
//
//
//
//
//                       });
//                     }catch(e){
//                       showMessage(context,e.toString());
//                     }
//                     // WidgetsBinding.instance.addPostFrameCallback((_){
//                     //
//                     //   // Add Your Code here.
//                     //   _YesNoBottomSheet(context,widget.data3,widget.photos,widget.project,currentLocation,widget);
//                     // });
//
//
//                   },child: Card(color: Theme.of(context).primaryColor,child: Center(child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text("Yes",style: TextStyle(color: Colors.white),),
//                   ))))),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       Align(
//         alignment: Alignment.center,
//         child: Container(
//           color: Color.fromARGB(27,0,0,0),
//           height: MediaQuery.of(context).size.height,
//           width:  MediaQuery.of(context).size.width,
//           child: Center(
//             child: Visibility(
//               visible: widget.savingModePrimary,
//               child: Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Container(
//                   color: Colors.white,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: CircularProgressIndicator(),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text("Please wait"),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       )
//     ],),);
//   }
// }


class CameraPreviewComplex extends StatefulWidget {
  late CameraController controller;
  var camera;

  CameraPreviewComplex({Key? key}) : super(key: key);

  @override
  _CameraPreviewComplexState createState() => _CameraPreviewComplexState();
}

class _CameraPreviewComplexState extends State<CameraPreviewComplex> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
