import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:connect/utils/featureSettings.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:connect/Activities/videoPlayerActivity.dart';
import 'package:connect/services/Firestoredatabase.dart';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:connect/pages/perform_test.dart';
import 'package:connect/services/config.dart';
import 'package:connect/streams/buttonStreams.dart';
import 'package:connect/widgets/cu.dart';
import 'package:connect/widgets/graph_with_selecttor.dart';
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
 import 'package:screenshot/screenshot.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import '../../Storage.dart';
import 'logics.dart';
import 'ui_components.dart';




class PerformTestPageActivity extends StatefulWidget {
  late BluetoothDevice device;
  late String project;
  bool hasSavedOnce = false;

  List<Map<String, dynamic>> photos = [];
  FirebaseFirestore customerFirestore;
  double targetLoad = 00;

  int durationForTest = 00;
  int fullDuration = 00;
  int failedAT = 00;

  bool didPassed = true;
  String index2 = "";
  String index6 = "";

  PerformTestPageActivity(
      {required this.index2,required this.index6,required this.start,
        required  this.testDuration,
        required   this.durationForTest,
        required   this.targetLoad,
        required  this.device,
        required  this.project,
        required  this.customerFirestore});

  // List<BarChartModel> data2 = [];
  List<ChartSampleData> data3 = [];
  List<double> data2 = [];
  List<ChartSampleData> onlyShow = [];
  List<String> testDataToSave = [];
  late int start;

  late int testDuration;

  List<double> traceSine = [];
  String initButtonMessage = "Run New Pull Test";
  late String messageDetails;

  bool shouldCollect = false;
  bool onceStartedTimer = false;

  bool savingModePrimary = false;

  double radians = 0.0;
  late BluetoothCharacteristic characteristic;
  String retValueFromStream = "No Data";

  late String ser;
  late String char;
  bool hasSuccessfullyFinishedTest = false;
  bool isTimerGoing = false;
  String folderParent = "root";
  List<String> folderStack = ["root"];

  String currentFolderName = "";
  bool showFolderTreeByStopingStreamWidgets = false;

  int duration = 0;
  double maxVal = 0;
  int maxAt = 0;
  double maxValForDisplay = 0;

  int startedTime = 0;
  int startedTimeXVal = 0;

  int endedTime = 0;
  int lastTime = 0;

  late var camera;

  late CameraController controller;

  @override
  _PerformTestPageState createState() => _PerformTestPageState();
}

class _PerformTestPageState extends State<PerformTestPageActivity> {
  Widget lastSeenWidget = Text("Please wait");
  bool shouldAlertShow = true;
  String buffValue = "0";

  bool statusAlertShow = false;

  bool reachedTargetLoad = false;
  bool shouldStartRecordning = false;
  int lastReachTaregetLoadTime = 0;

  int lastReachOffsetLoadTime = 0;

  int startTime = 0;
  List videos = [];
  bool running = false;
  List commonAttachment = [];
  String textAddress = "";
  var testNameController = new TextEditingController();
  var testNoteController = new TextEditingController();
 // late Location location;
 // LocationData currentLocation = new LocationData.fromMap({"lat": 0, "long": 0, "alt": 0});
  late BluetoothCharacteristic read;
  late BluetoothCharacteristic write;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late Timer _timer;

  //CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final picker = ImagePicker();



  void runTest() async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    //int counter = (prefs.getInt('timer') ?? 0) + 1;
    // int time = await prefs.getInt('timer');
    //  setState(() {
    //    widget.testDuration = time;
    //    widget.start = time;
    //  });

    //  setState(() {
    widget.data3.clear();
    //  widget.shouldCollect ? (widget.shouldCollect = false) : (widget.shouldCollect = true);
    widget.shouldCollect = true;
    //  });

    if (widget.shouldCollect) {
      widget.testDataToSave.clear();
      widget.data2.clear();
      widget.hasSuccessfullyFinishedTest = false;
      startTimer();
      //    setState(() {
      widget.start = widget.testDuration;
      widget.messageDetails = "Test is running.";
      //   });
    } else {
      widget.hasSuccessfullyFinishedTest = false;
      _timer.cancel();
      //  setState(() {
      widget.start = 0;
      widget.data2.clear();
      widget.testDataToSave.clear();
      widget.messageDetails = widget.initButtonMessage;
      //   });
    }
  }

  void tryToConnect() async {

    print("1");
    try {
      await widget.device.connect(autoConnect: false);
    } catch (e) {
      print("2");
      print(e);
      // if (e.code != 'already_connected') {
      //   print('already_connected');
      //   throw e;
      // }
    } finally {
      print('discover');
      await widget.device.discoverServices();

      String writeUid = "F0001111-0451-4000-B000-000000000000";
      String readUid = "F0001112-0451-4000-B000-000000000000";


      List<BluetoothService> allService = await widget.device.services.first;
      print(allService.length.toString());

      for (int i = 0;
      i < allService.length;
      i++) {

        for (int j = 0;
        j <
            allService[i].characteristics.length;
        j++) {
          print(i.toString()+"  "+j.toString());
          print(allService[i].toString());
          //print(allService[i].characteristics[j].uuid.toString());
          if (writeUid.toLowerCase() ==
              allService[i].characteristics[j].uuid
                  .toString().toLowerCase()) {
            print("h7");
            setState(() {
              write = allService[i].characteristics[j];
            });
            print("write found");
            break;
          }
        }
      }


      for (int i = 0;
      i < allService.length;
      i++) {

        for (int j = 0;
        j <
            allService[i].characteristics.length;
        j++) {
          print("h6");
          if (readUid.toLowerCase() ==
              allService[i].characteristics[j].uuid
                  .toString().toLowerCase()) {
            print("h7");
            setState(() {
              read = allService[i].characteristics[j];
            });
            print("read found");
            break;
          }
        }
      }



    }

  }

  void Connect() {
    widget.device.connect(autoConnect: false);
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (widget.start == 0) {
          widget.isTimerGoing = false;
          String uid = FirebaseAuth.instance.currentUser!.uid;
          Database(firestore: FirebaseFirestore.instance)
              .addTestData(uid: uid, data: widget.testDataToSave);
          //TestStartStopStream.getInstance().dataReload(false);
          draftSaved();
          // setState(() {
          timer.cancel();
          widget.endedTime =
              new DateTime.now().millisecondsSinceEpoch - startTime;
          widget.hasSuccessfullyFinishedTest = true;
          widget.shouldCollect = false;
          widget.messageDetails = "Test finished and saved.Click to run again";
          // });
        } else {
          widget.isTimerGoing = true;
          //      setState(() {
          widget.start--;
          widget.shouldCollect = true;
          //  });
        }
      },
    );
  }

  @override
  void initState() {
    setState(() {
      widget.hasSavedOnce == false;
      widget.data3 = [];
      print("timer and duration set for " + widget.durationForTest.toString());
      widget.start = widget.durationForTest;
      widget.duration = widget.durationForTest;
    });

    // TODO: implement initState

    //initTestCounterTimer();
    //GauseValueStreamAsFloat.getInstance().dataReload(10);
    GauseValueStreamAsFloat.getInstance().dataReload(0);
    listenAndActForTestStarted();
    listenforattachmentAdd();
    listenCompleateTask();
    listenForTargetLoad();

    GauseValueStreamAsFloat.getInstance().dataReload(0);






    super.initState();
    // setState(() {
    //   widget.messageDetails = widget.initButtonMessage;
    // });

    //listenCompleateTask();

    //  initCamera();
    initLocation();
    tryToConnect();

// widget.device.connect(autoConnect: false);
  }

  getUserLocation() async {
    //call this async method from whereever you need

    // LocationData myLocation;
    // String error;
    // Location location = new Location();
    // try {
    //   myLocation = await location.getLocation();
    // } on PlatformException catch (e) {
    //   if (e.code == 'PERMISSION_DENIED') {
    //     error = 'please grant permission';
    //     print(error);
    //   }
    //   if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
    //     error = 'permission denied- please enable it from app settings';
    //     print(error);
    //   }
    //   myLocation = await location.getLocation();
    // }
    // currentLocation = myLocation;
    // final coordinates = new Coordinates(myLocation.latitude, myLocation.longitude);
    //var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    // var first = addresses.first;
    //print(' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
    return "No address";
  }

  listenCompleateTask() {
    TestPerformLogics().testStartStopStream.outData.listen((event) {
      print("start stop listen value " + event.toString());

      running = event;
      print("expecting " + event.toString());
      print("im blokcing here ");
      print(widget.data3.length.toString());
      String key = "staht_" + DateTime.now().millisecondsSinceEpoch.toString();

      //if the test has been finished with timer triggered
      // widget.data3.length > 0 && widget.startedTime > 0
      if (widget.data3.length > 0 &&
          widget.hasSavedOnce == false &&
          event == false) {
        widget.hasSavedOnce = true;


        //TestStartStopStream.getInstance().dataReload(true);

        List<Map<String, dynamic>> testData = [];
        for (int i = 0; i < widget.data3.length; i++) {
          testData.add({
            "time": widget.data3[i].x.millisecondsSinceEpoch,
            "time_duration":
            widget.data3[i].x.millisecondsSinceEpoch - startTime,
            "color": widget.data3[i].color,
            //"time_duration": widget.data3[i].x.millisecondsSinceEpoch ,
            "value":widget.data3[i].y
          });
        }

        print("Now save");
        print("phto "+widget.photos.length.toString());
        print("video ");
        print(videos.length.toString());

        //FirebaseFirestore firestore = FirebaseFirestore.instanceFor(app: Firebase.app(widget.project));

        try {

          TextEditingController controllerTitle = new TextEditingController(
              text: getACurrentTimeStamp(key).replaceAll("auto_generated", ""));
          controllerTitle.selection = TextSelection(
              baseOffset: 0, extentOffset: controllerTitle.text.length);
          setState(() {
            widget.data3.clear();
            widget.data2.clear();
            // videos.clear();
          });
          void listen() {
            widget.customerFirestore
                .collection("pulltest")
                .doc(key)
                .update({"name": controllerTitle.text});
          }

          controllerTitle.addListener(listen);
          ScreenshotController screenshotController = ScreenshotController();
          //look here
          Widget dialog = Scaffold(
            appBar: AppBar(
              leading: Container(),
              title: Text("Save Record"),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: controllerTitle,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        //errorText: 'Please give  a name',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(
                          Icons.title,
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      minLines: 3,
                      //Normal textInputField will be displayed
                      maxLines: 4,
                      // when user presses enter it will adapt to it
                      onChanged: (val) {
                        widget.customerFirestore
                            .collection("pulltest")
                            .doc(key)
                            .update({"note": val});
                      },
                      decoration: InputDecoration(
                        labelText: 'Notes',
                        //errorText: 'Please give  a name',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(
                          Icons.title,
                        ),
                      ),
                    ),
                  ),

                  //Container(height: 200, child: DefaultPanning(widget.data3)),
                  // Container(
                  //     height: 200,
                  //     child: DefaultPanning2(widget.maxVal, 0,testData,0,0)),



                  Screenshot(
                    controller: screenshotController,
                    child: Column(
                      children: [
                        Container(height: 200,
                          child: LineMultiColor(prefferedDecimalPlace: PrefferedDecimalPlaces,unit: "kN",
                            data: testData,
                            max: widget.maxVal,
                            target: widget.targetLoad,
                            startedLoad: widget.startedTime,
                            duration: widget.durationForTest,
                            endedLoad: widget.endedTime,
                            fullDuration: widget.fullDuration, didPassed: true,),
                        ),
                        StreamBuilder<bool>(
                            stream: TestPerformLogics().captureScreensotStream.outData,
                            // async work
                            builder: (BuildContext context,
                                AsyncSnapshot<bool> snapshot) {
                              if (snapshot.hasData && snapshot.data == true) {
                                TestPerformLogics().captureScreensotStream
                                    .dataReload(true);
                                screenshotController
                                    .capture(delay: Duration(milliseconds: 10))
                                    .then((capturedImage) async {
                                  //update photo



                                  widget.customerFirestore
                                      .collection("pulltest")
                                      .doc(key)
                                      .update({"graphImage": base64Encode(capturedImage!)});
                                }).catchError((onError) {
                                  print(onError);
                                });

                                return Container(
                                  width: 0,
                                  height: 0,
                                );
                              } else
                                return Container(
                                  width: 0,
                                  height: 0,
                                );
                            }),
                        //CaptureScreensotStream.getInstance()
                      ],
                    ),
                  ),
                  // FutureBuilder<Widget>(
                  //     future: showAndSaveAsImage(context, key, testData),
                  //     // async work
                  //     builder:
                  //         (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                  //       if (snapshot.hasData) {
                  //         return Container(
                  //           height: 200,
                  //           width: MediaQuery.of(context).size.width,
                  //           //  child: Text(snapshotRecord.data.data()["data"]["id"]),
                  //           child: snapshot.data,
                  //         );
                  //       } else
                  //         return Center(
                  //           child: Text("Please wait"),
                  //         );
                  //     }),

                  commonAttachment.length > 0
                      ? GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4),
                      shrinkWrap: true,
                      itemCount: commonAttachment.length,
                      itemBuilder: (_, index) {
                        // return Padding(
                        //   padding: const EdgeInsets.all(5.0),
                        //   child: Container(
                        //       child: Center(child: Text(commonAttachment[index]["type"]))),
                        // );
                        return Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Stack(
                            children: [
                              Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                      child: commonAttachment[index]
                                      ["type"] ==
                                          "i"
                                          ? InkWell(
                                        onTap: () {
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Scaffold(
                                                    body: Image.file(
                                                      File(
                                                          commonAttachment[
                                                          index]
                                                          [
                                                          "thumb"]),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ));
                                        },
                                        child: Image.file(
                                          File(commonAttachment[index]
                                          ["thumb"]),
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                          : createThumnailForVideo(
                                          commonAttachment[index])

                                    // Image.file(
                                    //   File(
                                    //       commonAttachment[index]["thumb"]),
                                    //   fit: BoxFit.cover,
                                    // )
                                  )
                                //   :Image.memory(commonAttachment[index]["thumb"])),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                    child:
                                    commonAttachment[index]["type"] == "i"
                                        ? Icon(
                                      Icons.insert_photo_outlined,
                                      color: Theme.of(context)
                                          .primaryColor,
                                    )
                                        : Icon(Icons.play_circle_fill,
                                        color: Theme.of(context)
                                            .primaryColor)),
                              ),
                            ],
                          ),
                        );
                      })
                      : Container(
                    width: 0,
                    height: 0,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text("Max Value"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          getNumber(widget.maxVal,precision: 1).toString()+
                              " kN at " +
                              durationToString(widget.maxAt),
                          style: TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text("Timed Section Started"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          widget.startedTime > 0
                              ? durationToString((widget.startedTime))
                              : "Timer not Started",
                          //  (widget.startedTime / 1000).ceil().toString(),
                          style: TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text("Timed Section Finished"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          widget.startedTime > 0
                              ? durationToString((widget.endedTime))
                              : "Timer not Started",
                          style: TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text("Test Result"),
                      ),
                      widget.startedTime == 0
                          ? Text("Timer not Started")
                          : (widget.startedTime > 0
                          ? (widget.didPassed
                          ? Text(
                        "Pass",
                        style: TextStyle(color: Colors.greenAccent),
                      )
                          : Text("Fail",
                          style: TextStyle(color: Colors.redAccent)))
                          : Text("Fail",
                          style: TextStyle(color: Colors.redAccent)))
                    ],
                  ),
                  widget.didPassed
                      ? Container()
                      : Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text("Failed At : "),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          widget.failedAT > 0
                              ? durationToString((widget.failedAT))
                              : "--:--",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor),
                        ),
                      )
                    ],
                  ),
                  /*
                    Container(
                        height: 100, child: horizontal_image_list(widget.photos)),
                    Container(
                        height: 66,
                        child: horizontal_video_thumbnail_list(videos)),

                     */

                  // Container(
                  //     child: Text(videos.length.toString() + " videos")),
                  // ListView.builder(
                  //   //  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                  //     shrinkWrap: true,
                  //
                  //     itemCount: widget.photos.length,
                  //     itemBuilder: (_, index) {
                  //       return Padding(
                  //         padding: const EdgeInsets.all(5.0),
                  //         child: Container(child:Image.file(File(widget.photos[index]["imagePath"]),fit: BoxFit.cover,) ),
                  //       );
                  //
                  //     }),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Text("Test Finished. Do you want to save ?"),
                  // ),
                  Row(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Device SN"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.index2,style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).primaryColor),),
                    ),
                  ],),
                  Row(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Next Calibration Date"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.index6,style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).primaryColor),),
                    ),
                  ],),
                  //widget.startedTime > 0
                  InkWell(
                      onTap: () {
                        try{
                          TestPerformLogics().captureScreensotStream.dataReload(true);
                          TestPerformLogics(context: context,firestore: widget.customerFirestore).saveTestBottomSheet(id: key);

                        }catch(e){
                          TestPerformLogics(context: context,firestore: widget.customerFirestore).saveTestBottomSheet(id: key);
//important !! show dialog now
                        }

                      },
                      child: Card(
                          color: Theme.of(context).primaryColor,
                          child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  "Save In a Folder",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ))))

                ],
              ),
            ),
          );
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>WillPopScope(child: dialog,  onWillPop: () async => false)));


        } catch (e) {
          showMessageAsBottomSheet(context, e.toString());
        }

        AppFirestore(firestore: widget.customerFirestore,auth: FirebaseAuth.instance, projectId: widget.project).savePullTestRecord(decimalPlace:PrefferedDecimalPlaces,loadMode: "kN",key: key,
          index2: widget.index2,
          index6: widget.index6,
          note:testNoteController.text,
          name: testNameController.text,
          textAddress: textAddress,
          maxVal: widget.maxVal,
          maxAt: widget.maxAt,
          startedTime:  widget.startedTime,
          startedTimeXVal: widget.startedTimeXVal,
          endedTime: widget.endedTime,
          testDuration: widget.testDuration,
          didPassed: widget.didPassed,
          failedAT:  widget.failedAT,
          lastTime: widget.lastTime,
          targetLoad: widget.targetLoad,
          durationForTest:  widget.durationForTest,
          data3:testData,
          startTime: startTime,
          currentLocation:null,
          allPHotos: widget.photos,
          allvid: videos,
        );


      }
      //if the test has been finished withoout timer triggered
      //omitted && widget.data3.length > 0 && widget.startedTime>0

    });
  }

  String durationToString(int miliseconds) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(miliseconds);
    int minute = dateTime.minute;
    int second = dateTime.second;
    int mili = dateTime.millisecond;
    //return dateTime.toIso8601String();

    //return dateTime.toString().split('.')[1];

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('mm:ss').format(dateTime);
    return formattedDate;

    // DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(seconds);
    // String minute = dateTime.minute.toString();
    // String second = dateTime.second.toString();
    // String mili = dateTime.millisecond.toString();
    //
    // //return duration.toString().split('.')[0];
    // return minute + " : " + second + " : " + mili + " m:s";
    // return duration.toString().split('.')[0];
  }

  @override
  Widget build(BuildContext context) {
    // listenCompleateTask();
    itemClickListener(int val) async {
      //   SharedPreferences prefs = await SharedPreferences.getInstance();
/*
      if (val == 0) {
        await prefs.setInt('timer', 5);
        widget.testDuration = 5;
        widget.start = 5;
      }
      if (val == 1) {
        await prefs.setInt('timer', 15);
        widget.testDuration = 15;
        widget.start = 15;
      }
      if (val == 2) {
        await prefs.setInt('timer', 20);
        widget.testDuration = 20;
        widget.start = 20;
      }
      */
    }

    List<String> folderStack = ["root"];

    String currentFolderName = "";



    final Map<int, Widget> logoWidgets = const <int, Widget>{
      0: Padding(
        padding: EdgeInsets.all(10),
        child: Text('5 Second'),
      ),
      1: Padding(
        padding: EdgeInsets.all(10),
        child: Text('15 Second'),
      ),
      2: Padding(
        padding: EdgeInsets.all(10),
        child: Text('20 Second'),
      ),
    };
    String lastVal = "";

    return SafeArea(child: Scaffold(
      key: scaffoldKey,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //   runTest();
      //   },
      //   child: widget.shouldCollect?Text((widget.testDuration - widget.start).toString()):Icon(Icons.group_work_sharp),
      // ),
      // appBar: AppBar(
      //   title: Text(widget.duration.toString() +
      //       " second | " +
      //       widget.targetLoad.toString() +
      //       " kN"),
      //   actions: <Widget>[
      //
      //
      //
      //     StreamBuilder<bool>(
      //       stream: TestPerformLogics().testStartStopStream.outData,
      //       initialData: false,
      //       builder: (c, snapshot) {
      //         if(snapshot.hasData && snapshot.data == true){
      //           return  Padding(
      //             padding: const EdgeInsets.all(8.0),
      //             child: InkWell(
      //
      //               //  onPressed: onPressed,
      //                 onTap: () async {
      //                   TestPerformLogics().testStartStopStream.dataReload(false);
      //                 },
      //                 child: Icon(Icons.stop)),
      //           );
      //         }else{
      //           return Container(width: 0,height: 0,);
      //         }
      //       },
      //     )
      //   ],
      // ),

      //widget.data2.length > 0 && widget.shouldCollect == false
      body: SingleChildScrollView(
        child:  Column(
          children: [

            StreamBuilder<double>(
                stream: TestPerformLogics().gauseValueStreamAsFloat.outData,
                builder: (c, snapshotGauseValue) {
                  if (snapshotGauseValue.hasData) {
                    //
                    if (widget.endedTime > 0) {
                      return Container(
                        decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(0)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  "Remove Load",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )),
                        ),
                      );
                    } else if (widget.startedTime == 0 &&
                        widget.endedTime == 0 &&
                        widget.onceStartedTimer == false &&
                        snapshotGauseValue.data! <
                            widget.targetLoad * 1.0) {
                      return Container(
                        decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(0)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  "Apply Load",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )),
                        ),
                      );
                    } else if (widget.startedTime > 0 &&
                        widget.endedTime == 0 &&
                        widget.onceStartedTimer == true &&
                        widget.shouldCollect == true) {
                      TestPerformLogics().timerUniversalStream.dataReload(widget.start);
                      return InkWell(
                        onTap: () {
                          widget.onceStartedTimer = true;
                          TestPerformLogics().testStartStopStream
                              .dataReload(false);

                          widget.endedTime =
                              new DateTime.now().millisecondsSinceEpoch -
                                  startTime;
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(0)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    "Click to Stop Timer (" +
                                        widget.start.toString() +
                                        ")",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )),
                          ),
                        ),
                      );
                    } else if (widget.startedTime == 0 &&
                        widget.endedTime == 0 &&
                        widget.onceStartedTimer == false &&
                        widget.shouldCollect == true &&
                        snapshotGauseValue.data! >
                            widget.targetLoad * 1.0) {
                      return InkWell(
                        onTap: () {
                          widget.onceStartedTimer = true;
                          TestPerformLogics().testStartStopStream .dataReload(true);
                          widget.startedTime =
                              new DateTime.now().millisecondsSinceEpoch -
                                  startTime +
                                  1000;
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.greenAccent,
                              borderRadius: BorderRadius.circular(0)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    "Click to Start Timer",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                )),
                          ),
                        ),
                      );
                    }

                    else
                      return Container(
                        width: 0,
                        height: 0,
                      );


                  } else
                    return Container(
                      width: 0,
                      height: 0,
                    );
                }),

            StreamBuilder<BluetoothDeviceState>(
                stream: widget.device.state,
                initialData: BluetoothDeviceState.connecting,
                builder: (context, snapshot) {
                  if (snapshot.data == BluetoothDeviceState.connected) {
                    return FutureBuilder<List<BluetoothService>>(
                      // Initialize FlutterFire:
                      //  future: Firebase.initializeApp(),
                        future: widget.device.discoverServices(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data != null ) {
                            // return Text("size "+snapshot.data.length.toString());

                            late  BluetoothCharacteristic cha;
                            // BluetoothCharacteristic cha = snapshot.data[3].characteristics[2];

                            print("Hope i write here");


                            for (int i = 0; i < snapshot.data!.length; i++) {
                              print(snapshot.data![i].uuid.toString());
                              for (int j = 0;
                              j < snapshot.data![i].characteristics.length;
                              j++) {
                                print("h6");
                                if ("f0001113-0451-4000-b000-000000000000" ==
                                    snapshot
                                        .data![i].characteristics[j].uuid
                                        .toString()) {
                                  print("h7");
                                  cha =
                                  snapshot.data![i].characteristics[j];
                                  cha.setNotifyValue(true);
                                  break;
                                }
                              }
                            }




                            return cha!=null? StreamBuilder<List<int>>(
                                stream: cha.value,
                                builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
                                  if (snapshot.hasData ) {
                                    if (widget.maxValForDisplay <
                                        double.parse(convertFromStreamToString(snapshot.data))) {
                                      widget.maxValForDisplay =
                                          double.parse(convertFromStreamToString(snapshot.data));
                                    }
                                    if (widget.onlyShow.length < 100) {
                                      widget.onlyShow.add(ChartSampleData(
                                          x: new DateTime.now(),
                                          y: double.parse(convertFromStreamToString(snapshot.data)), color: 1));
                                    } else {
                                      //widget.onlyShow.removeAt(0);
                                      widget.onlyShow.add(ChartSampleData(
                                          x: DateTime.now(),
                                          y: double.parse(convertFromStreamToString(snapshot.data)), color: 1));
                                    }
                                    // return Text("good");


                                    return Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [

                                        //graph segment



                                        TestPerformUiComponents(context: context).readingsSegment(shouldCollect: widget.shouldCollect, data: snapshot.data!,start: widget.start),
                                        TestPerformUiComponents().graphSegment(onlyShow: widget.onlyShow, maxValForDisplay: widget.maxValForDisplay),



                                      ],
                                    );
                                  } else
                                    return Scaffold(
                                      body: Center(
                                          child: Text(
                                            "0",
                                            style: TextStyle(fontSize: 50),
                                          )),
                                    );
                                  return Text("Please wait");
                                }):CircularProgressIndicator();
                          } else {
                            return Container(
                                height: 100,
                                child: Center(
                                  child: InkWell(
                                      onTap: () {
                                        Connect;
                                      },
                                      child: Card(
                                          color: Theme.of(context)
                                              .primaryColor,
                                          child: Text(
                                            "Start Reading",
                                            style: TextStyle(
                                                color: Colors.white),
                                          ))),
                                ));
                          }
                        });
                  } else {
                    return Container(
                        height: 300,
                        child: Center(
                          child: InkWell(
                              onTap: () {
                                Connect;
                              },
                              child: Card(
                                  color: Theme.of(context).primaryColor,
                                  child: Text(
                                    "Start Reading",
                                    style: TextStyle(color: Colors.white),
                                  ))),
                        ));
                  }
                }),






            Container(
              height: 200,
              child: Row(
                children: [
                  // Expanded(
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: TestPerformUiComponents().mapSegment(),
                  //     )),

                  //CameraReadyStream.getInstance()
                  //


                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: TestPerformUiComponents().CameraSegment(),
                    ),
                  ),
                ],
              ),
            ),

            StreamBuilder<dynamic>(
                stream:TestPerformLogics().commonAttachmentAddedStream.outData,
                builder: (context, snapshot) {
                  print("common added stream");
                  if (snapshot.hasData) {
                    commonAttachment.add(snapshot.data);

                    return GridView.builder(
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4),
                        shrinkWrap: true,
                        itemCount: commonAttachment.length,
                        itemBuilder: (_, index) {
                          // return Padding(
                          //   padding: const EdgeInsets.all(5.0),
                          //   child: Container(
                          //       child: Center(child: Text(commonAttachment[index]["type"]))),
                          // );
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Stack(
                              children: [
                                Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                        child: commonAttachment[index]
                                        ["type"] ==
                                            "i"
                                            ? Image.file(
                                          File(commonAttachment[
                                          index]["thumb"]),
                                          fit: BoxFit.cover,
                                        )
                                            : createThumnailForVideo(
                                            commonAttachment[index])

                                      // Image.file(File(commonAttachment[index]["thumb"]),
                                      //   fit: BoxFit.cover,
                                      // )

                                    )
                                  //TODO

                                  //  :Image.memory(commonAttachment[index]["thumb"])),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                      child: commonAttachment[index]
                                      ["type"] ==
                                          "i"
                                          ? Icon(
                                        Icons.insert_photo_outlined,
                                        color: Theme.of(context)
                                            .primaryColor,
                                      )
                                          : Icon(Icons.play_circle_fill,
                                          color: Theme.of(context)
                                              .primaryColor)),
                                ),
                              ],
                            ),
                          );
                        });
                  } else {
                    return Container(
                      width: 0,
                      height: 0,
                    );
                  }
                }),




          ],
        ),
      ),



    ));
  }

  void draftSaved() {}

  void stopAndSave(CameraController cameraController) {
    cameraController.stopVideoRecording().then((value) {
      var video = File(value.path);

      try {
        // String base64Image = base64Encode(
        //     video.readAsBytesSync());
        // List imageParts = [];
        // //  int mid = (base64Image.length/2).ceil();
        // //imageParts.add(base64Image.substring(0,mid));
        // //imageParts.add(base64Image.substring(mid,base64Image.length));
        //
        // int gap = (1000 * 1000);
        // // int iteration = (base64Image.length / gap).ceil();
        // int iteration = (base64Image.length / gap).ceil();
        // for (int i = 0; i < iteration; i++) {
        //   if (base64Image.length >
        //       (((i * gap) + gap)))
        //     imageParts.add(
        //         base64Image.substring(i * gap,
        //             (((i * gap) + gap))));
        //   else
        //     imageParts.add(
        //         base64Image.substring(i * gap,
        //             base64Image.length));
        // }




        TestPerformLogics().videoClickedStream .dataReload({
          "videoPath": video.path,
          // "video": imageParts,
          "time": new DateTime.now().millisecondsSinceEpoch - startTime
        });

        videos.add({
          "videoPath": video.path,
          // "video": imageParts,
          "time": new DateTime.now().millisecondsSinceEpoch - startTime
        });

        // widget.photoAddListener();

      } catch (e) {
        showMessageAsBottomSheet(context, "error occured");
      }
    });
  }

  void initCamera() async {
    print("initing camera");
    WidgetsFlutterBinding.ensureInitialized();

    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.

    setState(() {
      widget.camera = cameras.first;
      widget.controller = CameraController(
        // Get a specific camera from the list of available cameras.
        widget.camera,
        // Define the resolution to use.
        ResolutionPreset.low,
      );
      print("sending to stream 2");
      //CameraReadyStream.getInstance().dataReload(true);
      // Next, initialize the controller. This returns a Future.
      _initializeControllerFuture = widget.controller.initialize();
    });
    print("sending to stream");

    Future.delayed(const Duration(seconds: 3), () {
      //CameraReadyStream.getInstance().dataReload(true);
    });

    //widget.controller.takePicture();
  }

  void initTestCounterTimer() async {
    widget.testDuration = widget.durationForTest;
    widget.start = widget.durationForTest;
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setInt('timer', 5);
    // widget.testDuration = 5;
    // widget.start = 5;
  }

  void listenAndActForTestStarted() async {
    //only responsible for starting a test
    //done no operation when the timer/test finishes
    TestPerformLogics().testStartStopStream.outData.listen((event) async {
      if (event == true) {
        print("Test should start");
        //int counter = (prefs.getInt('timer') ?? 0) + 1;
        // int time = await prefs.getInt('timer');
        // setState(() {
        //widget.testDuration = time;
        // widget.start = time;
        //  });

        //  setState(() {
        // this clear has  been cleared for temp widget.data3.clear();
        //  widget.shouldCollect ? (widget.shouldCollect = false) : (widget.shouldCollect = true);
        widget.shouldCollect = true;
        //  });

        if (widget.shouldCollect) {
          //  widget.testDataToSave.clear();
          //  widget.data2.clear();
          widget.hasSuccessfullyFinishedTest = false;
          //just commented the start timer
          startTimer();
          //    setState(() {
          widget.start = widget.testDuration;
          widget.messageDetails = "Test is running.";
          //   });
        } else {
          //widget.endedTime   = new DateTime.now().millisecondsSinceEpoch - startTime;
          widget.hasSuccessfullyFinishedTest = false;
          _timer.cancel();
          //  setState(() {
          widget.start = 0;
          widget.data2.clear();
          widget.testDataToSave.clear();
          widget.messageDetails = widget.initButtonMessage;
          //   });
        }
        //runTest();
      } else {
        print("Test blocked");
      }
    });
  }

  void listenforattachmentAdd() {
    TestPerformLogics().photoClickedStream.outData.listen((event) {
      widget.photos.add(event);
    });
    TestPerformLogics().videoClickedStream.outData.listen((event) {
      videos.add(event);
    });
  }

  Widget createThumnailForVideo(dynamic data) {
    // List parts = data["videoPath"];
    // print("Parts size " + parts.length.toString());
    // String base = "";
    //
    // //for (int i = parts.length - 1; i >= 0; i--) {
    // for (int i = 0; i < parts.length; i++) {
    //   // for (int i = 0; i < snapshotattachmentParts.data.length; i++) {
    //   base = base + parts[i];
    // }
    Future<Uint8List>getData(String link )async{
      return File(link).readAsBytesSync();


    }

    // Uint8List bytes = await File(data["videoPath"]).readAsBytesSync();
    return FutureBuilder<Uint8List>(
        future: getData(data["videoPath"]),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return Center(
              child: InkWell(
                onTap: () async {
                  MaterialPageRoute(
                      builder: (context) => Scaffold());
                },
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: PlayVideoAutoPlay(
                        name: data["time"].toString(),
                        video: snapshot.data!,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.play_circle_fill,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),

                //child: Image.memory(base64.decode(snapshotRecord.data.get("thumb")))
              ),
            );

          }else{
            return Center(child: CircularProgressIndicator(),);
          }

        });


  }

  void _settingModalBottomSheet(
      BuildContext context, PerformTestPageActivity widget, String id) {


  }

  void showMessageAsBottomSheet(BuildContext context, String message) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(message),
          );
        });
  }

  String convertFromStreamToString(List<int>? data) {
    String returnValue = "";
    if (data != null){
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
    return getNumber(f, precision: 1).toString();
  }else{
      return "0";
    }

    //return f.toStringAsFixed(1);
  }

  void listenForTargetLoad() {
    int lastAdd = 0;
    TestPerformLogics().gauseValueStreamAsFloat.outData.listen((event)  {
      //print("raw " + event.toString());

      if(event > widget.targetLoad*0.95 && event< widget.targetLoad*1.05){
        //Vibration.vibrate(duration: 1000);
      }

      //will stop the test if the test did not started timer and load fall down
      //  if (event < 0.2 && widget.startedTime == 0 && widget.didPassed == true) {
      //    widget.didPassed = false ;
      //
      //    TestStartStopStream.getInstance().dataReload(false);
      //  }
      //will stop the test if the test did  started timer but did not reached the full timer and load fall down
      if (event < 0.2 &&
          widget.startedTime == 0 &&
          widget.onceStartedTimer == false &&
          widget.shouldCollect == true) {
        widget.didPassed = false;

        TestPerformLogics().testStartStopStream.dataReload(false);
      }

      //will stop test if the test had reached the max load and then load fall down
      if (widget.shouldCollect == true &&
          event < 0.2 &&
          widget.maxVal > widget.targetLoad) {
        TestPerformLogics().testStartStopStream.dataReload(false);
      }
      DateTime cdt = DateTime.now();
      if (widget.shouldCollect == true &&
          lastAdd < cdt.millisecondsSinceEpoch) {
        lastAdd = cdt.millisecondsSinceEpoch;
        widget.lastTime = cdt.millisecondsSinceEpoch - startTime;
        if (widget.maxVal < event) {
          widget.maxVal = event;
          widget.maxAt = cdt.millisecondsSinceEpoch - startTime;
        }
        this.widget.testDataToSave.add(event.toString());
        this.widget.data2.add(event);

        // if(lastAdd < cdt.millisecondsSinceEpoch)
        this.widget.data3.add(ChartSampleData(
            x: cdt, y: event, color: widget.isTimerGoing == true ? 0 : 1));
      }

      if (event < widget.targetLoad &&
          widget.startedTime > 0 &&
          widget.endedTime < 1 &&
          widget.didPassed == true) {
        widget.didPassed = false;
        widget.failedAT = DateTime.now().millisecondsSinceEpoch - startTime;
        // widget.onceStartedTimer = true;
        // TestStartStopStream.getInstance().dataReload(true);
      }

      if (startTime == 0) {
        startTime = DateTime.now().millisecondsSinceEpoch;
      }

      //triggers the reading logic
      if (event > 0.2 && widget.shouldCollect == false) {
        widget.shouldCollect = true;
      }
    });
  }

  String getACurrentTimeStamp(String id) {
    String date = "";
    DateTime now = DateTime.now();
    date = "" +
        now.day.toString() +
        "-" +
        getMonthName(now.month) +
        "-" +
        now.year.toString() +
        "   " +
        now.hour.toString() +
        " : " +
        now.minute.toString();
    widget.customerFirestore
        .collection("pulltest")
        .doc(id)
        .update({"name": date}).then((value) {});
    return date;
  }

  String getMonthName(int month) {
    if (month == 1) return "January";
    if (month == 2) return "Feb";
    if (month == 3) return "March";
    if (month == 4) return "Appril";
    if (month == 5) return "May";
    if (month == 6) return "June";
    if (month == 7) return "Jully";
    if (month == 8) return "Aug";
    if (month == 9) return "Sep";
    if (month == 10) return "Oct";
    if (month == 11) return "Nov";
    if (month == 12) return "Dec";else return "";;
  }

  void initLocation() {
    //location = new Location();

    // location.onLocationChanged.listen((LocationData cLoc) async {
    //   currentLocation = cLoc;
    //   final coordinates = new Coordinates(cLoc.latitude, cLoc.longitude);
    //   var addresses =
    //   await Geocoder.local.findAddressesFromCoordinates(coordinates);
    //   var first = addresses.first;
    //   textAddress =
    //   (' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
    //   print(textAddress);
    // });
  }

  Future<Widget> showAndSaveAsImage(BuildContext context, String key,
      List<Map<String, dynamic>> testData) async {
    ScreenshotController screenshotController = ScreenshotController();
    Screenshot(
      controller: screenshotController,
      child: Container(
          padding: const EdgeInsets.all(30.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent, width: 5.0),
            color: Colors.amberAccent,
          ),
          child: Text("This widget will be captured as an image")),
    );

    screenshotController
        .capture(delay: Duration(milliseconds: 10))
        .then((capturedImage) async {
      print("capture doe");
      ShowCapturedWidget(context, capturedImage!);
    }).catchError((onError) {
      print("capture error");
      print(onError);
    });

    GlobalKey _globalKey = new GlobalKey();
    Widget graph = Container(
      height: 200,
      child: LineMultiColor(prefferedDecimalPlace: PrefferedDecimalPlaces,unit: "kN",didPassed: true,
          data: testData,
          max: widget.maxVal,
          target: widget.targetLoad,
          startedLoad: widget.startedTime,
          duration: widget.durationForTest,
          endedLoad: widget.endedTime,
          fullDuration: widget.fullDuration),
    );

    //  await Future.delayed(Duration(seconds: 3));

    widget.customerFirestore
        .collection("pulltest")
        .doc(key)
        .update({"tes": 123});


    return graph;


  }

  Future<dynamic> ShowCapturedWidget(
      BuildContext context, Uint8List capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text("Captured widget screenshot"),
        ),
        body: Center(
            child: capturedImage != null
                ? Image.memory(capturedImage)
                : Container()),
      ),
    );
  }
}