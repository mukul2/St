import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:connect/Activities/CameraGallaryWIdget/camera_gallary.dart';
import 'package:connect/Activities/CameraGallaryWIdget/camera_gallary2.dart';
import 'package:connect/Activities/CameraToggleSwitch/cameraToggle.dart';
import 'package:connect/Activities/CustomBottomNavigationBar/appBottomNavigationBar.dart';
import 'package:connect/Activities/CustomerUserHome/logics.dart';
import 'package:connect/Activities/TestPerformActivity/activity_page.dart';
import 'package:connect/Activities/TestPerformActivity/logics.dart';
import 'package:connect/Activities/TestPerformActivity/ui_components.dart';
import 'package:connect/Activities/TestSaveScreen/testSaveScreen.dart';
import 'package:connect/Appabr/appbar_widget.dart';
import 'package:connect/Toast/AppToast.dart';
import 'package:connect/components/appBarCustom.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/colorConst.dart';
import 'package:connect/utils/featureSettings.dart';
import 'package:connect/utils/textConst.dart';
import 'package:connect/utils/textStyleConst.dart';
import 'package:connect/utils/themeManager.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:flutter/painting.dart';
import 'package:flutter_svg/svg.dart';
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
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart' as gl;
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
import 'package:connect/Activities/old_test_perform/testStatusEnum.dart';
import 'package:video_player/video_player.dart';
import 'package:vibration/vibration.dart';
import '../../DarkThemeManager.dart';
import 'overLoadScreen.dart';
class OldPerformTestPageActivity extends StatefulWidget {
  late BluetoothDevice device;
  late String project;
  bool hasSavedOnce = false;

  List<Map<String, dynamic>> photos = [];
  FirebaseFirestore customerFirestore;
  double targetLoad = 5;
  bool vibStarted = false;
  bool testFinishViStarted = false;
  int lastVibTime = 0;

  int durationForTest = 5;
  int fullDuration = 5;
  int failedAT = 00;

  bool didPassed = true;
  String index2 = "";
  String index6 = "";
  List attachmentsFromPreviousScreen;
  gl.Position position;
  String loadMode;
 // Widget cameraWidget;

  OldPerformTestPageActivity(
      {required this.index2,required this.index6,required this.start,
        required  this.testDuration,
        required   this.durationForTest,
        required   this.targetLoad,
        required  this.device,
        required  this.project,
        required  this.position,
        required  this.loadMode,
       // required  this.cameraWidget,
        required  this.attachmentsFromPreviousScreen,
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

  bool stopReading = false;

  late var camera;

  late CameraController controller;

  @override
  _PerformTestPageState createState() => _PerformTestPageState();
}

class _PerformTestPageState extends State<OldPerformTestPageActivity> {
  //double testCutOffValue = 0.2;
  bool countDown = true;
  static const countdownDuration = Duration(minutes: 0);
  Duration duration = Duration();
  late CameraController _controller;
  Widget lastSeenWidget = Text("Please wait");
  bool shouldAlertShow = true;
  String buffValue = "0";
  bool _isSelectForPhoto = true;
  bool isSelected = false;
  bool _isRecording = false;
  int minutes = 0;
  int seconds = 0;
  bool statusAlertShow = false;
  var camera;
  var timer;
  double cufOff = 0.2 ;
  double maxZoom = 0 ;
  double minZoom = 0 ;
  double zoom = 1 ;
  bool reachedTargetLoad = false;
  bool shouldStartRecordning = false;
  int lastReachTaregetLoadTime = 0;

  int lastReachOffsetLoadTime = 0;

  int startTime = 0;
  List videos = [];
  bool running = false;
  List commonAttachment = [];
  ScrollController _scrollController = ScrollController();
  String textAddress = "";
  //var testNameController = new TextEditingController();
  //var testNoteController = new TextEditingController();
 // late Location location;
 // LocationData currentLocation = new LocationData.fromMap({"lat": 0, "long": 0, "alt": 0});
  late BluetoothCharacteristic read;
  late BluetoothCharacteristic write;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late Timer _timer;

  bool isOverloadScreenShowing = false;

  //CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final picker = ImagePicker();
  double convertwithDecimalplacesSecond(List<int> data) {
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

    // if(widget.targetLoad >f*1.1 ){
    //
    //
    //
    //  // setState(() {
    //     reachedTargetLoad = true ;
    //     lastReachTaregetLoadTime = DateTime.now().millisecondsSinceEpoch;
    // //  });
    // }ƒ
    // if(f >0.19 ){
    //  // setState(() {
    //     shouldStartRecordning = true ;
    //     lastReachOffsetLoadTime = DateTime.now().millisecondsSinceEpoch;
    //  // });ƒF
    // }
    GauseValueStreamAsFloat.getInstance().dataReload(convertRightUnit(f));
    double dd = convertRightUnit(f);
    print("convertwithDecimalplaces ");
    print(dd.toStringAsPrecision(PrefferedDecimalPlaces));
   // String twoDeci = dd.toStringAsPrecision(PrefferedDecimalPlaces);
    return dd;
    //return f.toStringAsFixed(decimalPLace);
  }
  double convertwithDecimalplaces(List<int> data) {
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

    // if(widget.targetLoad >f*1.1 ){
    //
    //
    //
    //  // setState(() {
    //     reachedTargetLoad = true ;
    //     lastReachTaregetLoadTime = DateTime.now().millisecondsSinceEpoch;
    // //  });
    // }ƒ
    // if(f >0.19 ){
    //  // setState(() {
    //     shouldStartRecordning = true ;
    //     lastReachOffsetLoadTime = DateTime.now().millisecondsSinceEpoch;
    //  // });ƒF
    // }
    GauseValueStreamAsFloat.getInstance().dataReload(convertRightUnit(f));
    double dd = convertRightUnit(f);
    print("convertwithDecimalplaces ");
    print(dd.toStringAsPrecision(PrefferedDecimalPlaces));
    String twoDeci = dd.toStringAsPrecision(PrefferedDecimalPlaces);
    return double.parse(twoDeci);
    //return f.toStringAsFixed(decimalPLace);
  }
  double getNumber(double input, {int precision = 1}) {

    // try{
    //   String dd = '$input'.substring(0, '$input'.indexOf('.') + 2 + 1);
    //   double ii = double.parse(dd);
    //   return ii;
    // }catch(e){
    //
    //   String dd = '$input'.substring(0, '$input'.indexOf('.') + 1 + 1);
    //   dd=dd+"0";
    //
    //
    //   double ii = double.parse(dd);
    //   String d2 =  ii.toStringAsFixed(2);
    //   return double.parse(d2);
    //
    //   return ii;
    // }





    try{
      String dd = '$input'.substring(0, '$input'.indexOf('.') + PrefferedDecimalPlaces + 1);
      double ii = double.parse(dd);
      String ss = ii.toStringAsFixed(PrefferedDecimalPlaces);
      print("throwing "+ss);
      return double.parse(ss);
      //return  double.parse(ss).toStringAsFixed(precision);
   //  return double.parse('$input'.substring(0, '$input'.indexOf('.') + precision + 1));
    }catch(e){
      String dd = '$input'.substring(0, '$input'.indexOf('.') + 1 + 1);
      double ii = double.parse(dd);
      String ss = ii.toStringAsFixed(PrefferedDecimalPlaces);
      print("throwing "+ss);
      return double.parse(ss);
      //return  double.parse(ss).toStringAsFixed(precision);
    }
  }

  // double getNumber(double input, {int precision = 1}) =>
  //     double.parse('$input'.substring(0, '$input'.indexOf('.') + precision + 1));
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
      startTimerOld();
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
  void initCamera() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    setState(() {
      for (var i = 0; i < cameras.length; i++) {
        if (cameras[i].lensDirection == CameraLensDirection.back) {
          camera = cameras[i];
        } else {}
      }

      _controller = CameraController(
        // Get a specific camera from the list of available cameras.
        camera,
        // Define the resolution to use.
        ResolutionPreset.medium,
      );

      // Next, initialize the controller. This returns a Future.
      _initializeControllerFuture = _controller.initialize().then((value) async {
        maxZoom = await _controller.getMaxZoomLevel();
        minZoom = await _controller.getMinZoomLevel();
      });
    });
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

  void startTimerOld() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if(widget.start == 0)Vibration.vibrate(duration: 500);
        if (widget.start == 0) {


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
          if(widget.start==0){widget.isTimerGoing = false;}
          //  });
        }
      },
    );
  }

  @override
  void initState() {
    if(widget.loadMode == "kN"){

      cufOff = 0.2;
    }else{
      cufOff = 45;
    }

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

    listenAndActForTestStarted();
    listenforattachmentAdd();
    //listenenCompleateTask();
    listenForTargetLoad();








    super.initState();
    // setState(() {
    //   widget.messageDetails = widget.initButtonMessage;
    // });

    //listenCompleateTask();

     initCamera();
    initLocation();
    tryToConnect();

    //initCamera();

    getFromOldPageAttachment();
    print("time "+widget.testDuration.toString());

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
    TestStartStopStream.getInstance().outData.listen((event) {
      print("start stop listen value " + event.toString());

      running = event;
      print("expecting " + event.toString());
      print("im blokcing here ");
      print(widget.data3.length.toString());
      String key = "staht_" + DateTime.now().millisecondsSinceEpoch.toString();

      //if the test has been finished with timer triggered
      // widget.data3.length > 0 && widget.startedTime > 0
      if (widget.data3.length > 0 && widget.hasSavedOnce == false && event == false) {
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
                          child: LineMultiColor(unit: widget.loadMode,
                            data: testData,
                            max: widget.maxVal,
                            target: widget.targetLoad,
                            startedLoad: widget.startedTime,
                            duration: widget.durationForTest,
                            endedLoad: widget.endedTime,
                            fullDuration: widget.fullDuration, didPassed: true, prefferedDecimalPlace: PrefferedDecimalPlaces,),
                        ),
                        StreamBuilder<bool>(
                            stream: CaptureScreensotStream.getInstance().outData,
                            // async work
                            builder: (BuildContext context,
                                AsyncSnapshot<bool> snapshot) {
                              if (snapshot.hasData && snapshot.data == true) {
                                print("graph trigger");
                                CaptureScreensotStream.getInstance()
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
                          getNumber(widget.maxVal,precision: PrefferedDecimalPlaces).toString()+
                              " "+widget.loadMode+" at " +
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
                  true
                      ? InkWell(
                      onTap: () {
                        try{
                          CaptureScreensotStream.getInstance().dataReload(true);
                          _settingModalBottomSheet(context, widget,
                              key); //important !! show dialog now
                        }catch(e){
                          print(e);
                          _settingModalBottomSheet(context, widget,
                              key); //important !! show dialog now
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
                      : InkWell(
                      onTap: () {
                        returnHomePage(context);
                        // Navigator.pop(context);
                      },
                      child: Card(
                          color: Theme.of(context).primaryColor,
                          child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  "Close",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )))),
                ],
              ),
            ),
          );

          Navigator.of(context).push(new MaterialPageRoute<Null>(
              builder: (BuildContext context) {
                return dialog;
              },
              fullscreenDialog: true));
        } catch (e) {
          showMessageAsBottomSheet(context, e.toString());
        }
        GeolocatorPlatform.instance
            .getCurrentPosition(desiredAccuracy: gl.LocationAccuracy.high).then((value) {


          AppFirestore(firestore: widget.customerFirestore,auth: FirebaseAuth.instance, projectId: widget.project).savePullTestRecord(decimalPlace:PrefferedDecimalPlaces,loadMode: widget.loadMode,key: key,
            index2: widget.index2,
            index6: widget.index6,
            note:"",
            name: "",
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
            currentLocation:value,
            allPHotos: widget.photos,
            allvid: videos,
          );
        });



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
    double graphScalealue ;
    double warningLoad = 63;

    if(widget.loadMode == "kN"){
      graphScalealue = 2;
      cufOff = 0.2;
      warningLoad = CustomerHomePageLogic().MaxLoadKNWarning;
    }else{
      graphScalealue = 450;
      cufOff = 45;
      warningLoad = CustomerHomePageLogic().MaxLoadLBFWarning;
    }
    //warningLoad = 4;
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
    SimpleDialog dialog2 = SimpleDialog(children: [
      ListTile(
        leading: Text(currentFolderName),
        trailing: Icon(Icons.save),
      ),
      StreamBuilder<QuerySnapshot>(
          stream: widget.customerFirestore
              .collection("folders")
              .where("parent", isEqualTo: folderStack.last)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.data!.docs != null) {
              if (snapshot.data!.size > 0)
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount:
                    snapshot.data == null ? 0 : snapshot.data!.docs.length,
                    itemBuilder: (_, index) {
                      return ListTile(
                        onTap: () {
                          currentFolderName = snapshot.data!.docs[index]["name"];
                          folderStack.add(snapshot.data!.docs[index].id);
                          // setState(() {
                          //   widget.currentFolderName =  snapshot.data.docs[index]["name"];
                          //   widget.folderStack.add(snapshot.data.docs[index].id);
                          // });
                        },
                        leading: Icon(Icons.folder_open),
                        title:
                        Text(snapshot.data!.docs[index]["name"].toString()),
                      );
                    });
              else
                return Container(
                  height: 0,
                  width: 0,
                );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          })
    ]);

    SimpleDialog dialog = SimpleDialog(children: [
      Scaffold(
        appBar: AppBar(
          backgroundColor: reachedTargetLoad ? Colors.redAccent : Colors.black,
          actions: [
            InkWell(
                onTap: () {
                  setState(() {
                    widget.showFolderTreeByStopingStreamWidgets = false;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.done_outline),
                )),
          ],
          title: Text("Save Record"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.folderStack.length > 1
                ? Container(
              child: Container(
                child: Center(
                  child: ListTile(
                    leading: InkWell(
                      onTap: () {
                        setState(() {
                          widget.folderStack.removeLast();
                        });
                      },
                      child: Icon(Icons.keyboard_arrow_left),
                    ),
                    title: Text(widget.currentFolderName),
                    trailing: InkWell(
                        onTap: () {
                          // showDialog<void>(
                          //     context: context, builder: (context) => dialog);
                        },
                        child: Icon(Icons.add)),
                  ),
                ),
              ),
            )
                : Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(Icons.sd_storage_outlined),
                    title: Text("Root"),
                    trailing: InkWell(
                        onTap: () {
                          //showDialog<void>(context: context, builder: (context) => dialog);
                        },
                        child: Icon(Icons.add)),
                  ),
                )),
            (StreamBuilder<QuerySnapshot>(
                stream: widget.customerFirestore
                    .collection("folders")
                    .where("parent", isEqualTo: widget.folderStack.last)
                    .snapshots(),
                // TODO need a good mechanism for sorting ex .orderby("created_at")
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.data != null &&
                      snapshot.data!.docs != null) {
                    if (snapshot.data!.size > 0)
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data == null
                              ? 0
                              : snapshot.data!.docs.length,
                          itemBuilder: (_, index) {
                            return ListTile(
                              onTap: () {
                                setState(() {
                                  widget.currentFolderName =
                                  snapshot.data!.docs[index]["name"];
                                  widget.folderStack
                                      .add(snapshot.data!.docs[index].id);
                                });
                              },
                              leading: Icon(Icons.folder_open),
                              title: Text(
                                  snapshot.data!.docs[index]["name"].toString()),
                            );
                          });
                    else
                      return Container(
                        height: 0,
                        width: 0,
                      );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                })),
            StreamBuilder<QuerySnapshot>(
                stream: widget.customerFirestore
                    .collection("folders")
                    .doc(widget.folderStack.last)
                    .collection("records")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.data != null &&
                      snapshot.data!.docs.length > 0) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data == null
                            ? 0
                            : snapshot.data!.docs.length,
                        itemBuilder: (_, index) {
                          return ListTile(
                            onTap: () {
                              setState(() {
                                widget.folderStack
                                    .add(snapshot.data!.docs[index].id);
                              });
                            },
                            leading: Icon(Icons.hardware),
                            title: Text(
                                snapshot.data!.docs[index]["id"].toString()),
                          );
                        });
                  } else {
                    return Text("");
                  }
                })
          ],
        ),

      )
    ]);
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
    double screenWidth = MediaQuery.of(context).size.width;
    var bottomNav = Wrap(
      children: [
        Container(
          //margin: EdgeInsets.only(top: height*0.008),
          height: height*0.001,
          width: double.infinity,
          color: ThemeManager().getBlackColor.withOpacity(.15),
        ),
        Container(height:  (height * 0.075)- height*0.001,
          child: Center(
            child: Row(children:[
              Expanded(child: InkWell(onTap: (){
                Navigator.pop(context);
                CustomerHomePageLogic().tabChangedStream.dataReload(0);
              },
                child: Center(child: Container(
                    padding: EdgeInsets.only(right: screenWidth * 0.06),
                    child: SvgPicture.asset(
                      "assets/svg/homeIcon.svg",
                      color: ThemeManager().getBlackColor,
                      width: screenWidth * 0.028,
                      height: screenWidth * 0.06,
                    )),),
              )),
              Expanded(child: InkWell(onTap: (){
                Navigator.pop(context);
                CustomerHomePageLogic().tabChangedStream.dataReload(1);
              },
                child: Center(child: Container(
                    padding: EdgeInsets.only(right: screenWidth * 0.06),
                    child: SvgPicture.asset(
                      "assets/svg/strokeIcon.svg",
                      color: ThemeManager().getDarkGreenColor,
                      width: screenWidth * 0.028,
                      height: screenWidth * 0.06,
                    )),),
              )),
              Expanded(child: InkWell(onTap: (){
                Navigator.pop(context);
                CustomerHomePageLogic().tabChangedStream.dataReload(2);
              },
                child: Center(child: Container(
                    padding: EdgeInsets.only(right: screenWidth * 0.06),
                    child: SvgPicture.asset(
                      "assets/svg/chartIcon.svg",
                      color: ThemeManager().getDarkGrey3Color,
                      width: screenWidth * 0.028,
                      height: screenWidth * 0.06,
                    )),),
              )),
              Expanded(child: InkWell(onTap: (){
                Navigator.pop(context);
                CustomerHomePageLogic().tabChangedStream.dataReload(3);
              },
                child: Center(child: Container(
                    padding: EdgeInsets.only(right: screenWidth * 0.06),
                    child: SvgPicture.asset(
                      "assets/svg/vectorIcon.svg",
                      color: ThemeManager().getDarkGrey3Color,
                      width: screenWidth * 0.028,
                      height: screenWidth * 0.06,
                    )),),
              )),
            ],),
          ),
        ),
      ],
    );
   // Widget camera  =  CameraGallaryActivitySecond();
   // return Scaffold(body: camera,);
    CustomerHomePageLogic().tabChangedStream.dataReload(1);
    //height = MediaQuery.of(context).size.height*(1-0.075);
    //height = MediaQuery.of(context).size.height*(1-0.075);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;



    return SafeArea(child: Scaffold(backgroundColor: AppThemeManager().getScaffoldBackgroundColor(),
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
      //       stream: TestStartStopStream.getInstance().outData,
      //       initialData: false,
      //       builder: (c, snapshot) {
      //         if(snapshot.hasData && snapshot.data == true){
      //           return  Padding(
      //             padding: const EdgeInsets.all(8.0),
      //             child: InkWell(
      //
      //               //  onPressed: onPressed,
      //                 onTap: () async {
      //                   TestStartStopStream.getInstance().dataReload(false);
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
      body: Stack(
        children: [
          Positioned(top: 0,left: 0,right: 0,child:  Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ApplicationAppbar().  getAppbar(title: TextConst.testAppbarText),
              //----------------------Body of screen------------------------------------
              Padding(
                padding:  EdgeInsets.fromLTRB(1, 1, 1, 1),
                child: Container(
                  margin: EdgeInsets.only(left: width * 0.05, right: width * 0.05, top: height * 0.02),
                  child: Column( mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [


                      StreamBuilder<BluetoothDeviceState>(
                          stream: widget.device.state,
                          initialData: BluetoothDeviceState.connecting,
                          builder: (context, snapshot) {
                            if (snapshot.data == BluetoothDeviceState.connected) {
                              return StreamBuilder<List<BluetoothService>>(
                                // Initialize FlutterFire:
                                //  future: Firebase.initializeApp(),
                                  stream: widget.device.services,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data != null &&
                                        snapshot.data!.length > 0) {
                                      // return Text("size "+snapshot.data.length.toString());

                                      late  BluetoothCharacteristic cha;
                                      // BluetoothCharacteristic cha = snapshot.data[3].characteristics[2];

                                      print("Hope i write here");


                                      for (int i = 0;
                                      i < snapshot.data!.length;
                                      i++) {
                                        print("h5");
                                        print(snapshot.data![i].uuid.toString());
                                        for (int j = 0;
                                        j <
                                            snapshot
                                                .data![i].characteristics.length;
                                        j++) {
                                          print("h6");
                                          if ("f0001113-0451-4000-b000-000000000000" ==
                                              snapshot
                                                  .data![i].characteristics[j].uuid
                                                  .toString()) {
                                            print("h7");
                                            cha =
                                            snapshot.data![i].characteristics[j];
                                            break;
                                          }
                                        }
                                      }
                                      cha.setNotifyValue(true);


                                      return StreamBuilder<List<int>>(
                                          stream: cha.value,
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData &&
                                                snapshot.data != null &&
                                                snapshot.data!.length > 0) {
                                              if (widget.maxValForDisplay < convertRightUnit( double.parse(convertFromStreamToString(snapshot.data!)))) {
                                                widget.maxValForDisplay = convertRightUnit(double.parse(convertFromStreamToString(snapshot.data!))).toDouble();
                                                //  widget.maxVal = widget.maxValForDisplay;
                                              }
                                              if (widget.onlyShow.length < 5) {
                                                widget.onlyShow.add(ChartSampleData(x: new DateTime.now(), y: convertRightUnit( double.parse(convertFromStreamToString(snapshot.data!))), color: 1));
                                              } else {
                                                //widget.onlyShow.removeAt(0);
                                                widget.onlyShow.add(ChartSampleData(x: DateTime.now(), y: convertRightUnit(  double.parse(convertFromStreamToString(snapshot.data!))), color: 1));
                                              }
                                              // GauseValueStreamAsFloat.getInstance().outData.listen((event) {
                                              //   print("by str "+event.toStringAsFixed(PrefferedDecimalPlaces));
                                              //   print("by str2 "+event.toStringAsFixed(PrefferedDecimalPlaces).toString());
                                              //   print("by str3 "+event.toStringAsPrecision(PrefferedDecimalPlaces));
                                              //
                                              // });

                                             // print("hey "+  convertwithDecimalplaces(snapshot.data!).toString());
                                              print("hey fi "+  convertwithDecimalplaces(snapshot.data!).toStringAsFixed(PrefferedDecimalPlaces));



                                              return Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [


                                                  //graph
                                                  Stack(
                                                    children: [
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                              blurRadius: 2,
                                                              color: ThemeManager()
                                                                  .getLightGrey5Color
                                                                  .withOpacity(.1),
                                                            )
                                                          ],
                                                          color:AppThemeManager().getRealTimeGraphBoxBackgroundColor(),
                                                        ),
                                                        height: height * 0.24,
                                                        child: Padding(
                                                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                          //Initialize the spark charts widget
                                                          child: TestPerformUiComponents().graphSegment(onlyShow: widget.onlyShow, maxValForDisplay: widget.maxValForDisplay<graphScalealue?graphScalealue:widget.maxValForDisplay),),
                                                      ),
                                                      Positioned(
                                                        top: 3,
                                                        right: width * 0.15 ,
                                                        //left: width * 0.68,
                                                        child: Row(
                                                          children: [
                                                          StreamBuilder(
                                                          stream: GauseValueStreamAsFloat.getInstance().outData,
                                                          builder: (BuildContext context, AsyncSnapshot<double> snapshot){
                                                          if(snapshot.hasData){

                                                            String va =   widget.loadMode == "lbf"? snapshot.data!.toInt().toString(): snapshot.data!.toStringAsFixed(PrefferedDecimalPlaces).toString();

                                                            return  Text(  va,
                                                              // Text(  widget.loadMode == "lbf"?convertwithDecimalplaces(snapshot.data!).toInt().toString()+" ":convertFromStreamToString(snapshot.data!)+" ",
                                                              // Text(  widget.loadMode == "lbf"?convertwithDecimalplaces(snapshot.data!).toInt().toString()+" ":convertRightUnit( double.parse(convertFromStreamToString(snapshot.data!))).toString()+" ",
                                                              style: interBold.copyWith(
                                                                  color: AppThemeManager().getRealTimeGraphBoxLoadColor(),
                                                                  fontSize: height * 0.035),
                                                            );

                                                          }else return Container(width: 0,height: 0,);
                                                          }),


                                                         //  Text( convertFromStreamToString(snapshot.data!),
                                                         if(false)  Text(  widget.loadMode == "lbf"?convertwithDecimalplaces(snapshot.data!).toInt().toString()+" ":(convertwithDecimalplaces(snapshot.data!).toString()+(PrefferedDecimalPlaces==1?"":"")+" "),
                                                           // Text(  widget.loadMode == "lbf"?convertwithDecimalplaces(snapshot.data!).toInt().toString()+" ":convertFromStreamToString(snapshot.data!)+" ",
                                                           // Text(  widget.loadMode == "lbf"?convertwithDecimalplaces(snapshot.data!).toInt().toString()+" ":convertRightUnit( double.parse(convertFromStreamToString(snapshot.data!))).toString()+" ",
                                                              style: interBold.copyWith(
                                                                  color: AppThemeManager().getRealTimeGraphBoxLoadColor(),
                                                                  fontSize: height * 0.035),
                                                            ),
                                                            if(true)  Text(widget.loadMode,
                                                              style: interBold.copyWith(
                                                                  color: AppThemeManager().getRealTimeGraphBoxLoadColor(),
                                                                  fontSize: height * 0.025),
                                                            ),

                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),


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
                                          });
                                    } else {
                                      return Container(
                                          height: height * 0.24,
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ));
                                    }
                                  });
                            }
                            else  if (snapshot.data == BluetoothDeviceState.disconnected){
                              return Container(
                                  height:   height * 0.24,
                                  child: Center(
                                    child: InkWell(
                                        onTap: () {
                                          Connect;
                                        },
                                        child: Column(
                                          children: [
                                            Text(
                                              "Device is disconnected",
                                              style: TextStyle(color:AppThemeManager().getRealTimeGraphBoxLoadColor(),fontSize: 30),
                                            ),
                                            Text(
                                              "Please connect a device and try again",
                                              style: TextStyle(color: AppThemeManager().getRealTimeGraphBoxLoadColor()),
                                            ),
                                          ],
                                        )),
                                  ));
                            }else  if (snapshot.data == BluetoothDeviceState.connecting){
                              return Container(
                                  height:   height * 0.24,
                                  child: Center(
                                    child: InkWell(
                                        onTap: () {
                                          Connect;
                                        },
                                        child: Column(
                                          children: [
                                            Text(
                                              "Device is connecting",
                                              style: TextStyle(color: AppThemeManager().getRealTimeGraphBoxLoadColor(),fontSize: 30),
                                            ),
                                            Text(
                                              "Please wait",
                                              style: TextStyle(color:AppThemeManager().getRealTimeGraphBoxLoadColor()),
                                            ),
                                          ],
                                        )),
                                  ));
                            }else  if (snapshot.data == BluetoothDeviceState.disconnecting){
                              return Container(
                                  height:   height * 0.24,
                                  child: Center(
                                    child: InkWell(
                                        onTap: () {
                                          Connect;
                                        },
                                        child: Column(
                                          children: [
                                            Text(
                                              "Device is disconnecting",
                                              style: TextStyle(color: AppThemeManager().getRealTimeGraphBoxLoadColor(),fontSize: 30),
                                            ),
                                            Text(
                                              "Please wait",
                                              style: TextStyle(color:AppThemeManager().getRealTimeGraphBoxLoadColor()),
                                            ),
                                          ],
                                        )),
                                  ));
                            }else return Container( child: Text(snapshot.data.toString()), height:   height * 0.24,);
                          }),
                      Container(
                        margin: EdgeInsets.only(top: height * 0.01),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: ThemeManager().getLightGrey6Color,
                        ),
                        height: height * 0.06,
                        width: double.infinity,
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: width * 0.06, right: width * 0.02),
                              child: SvgPicture.asset(
                                ("assets/svg/loadIcon.svg"),
                                height: height * 0.03,
                                fit: BoxFit.cover,
                                color: ThemeManager().getDarkGreyTextColor,
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    constraints: BoxConstraints(
                                      maxWidth: width * 0.14,
                                    ),
                                    child: Text(widget.loadMode == "kN"? widget.targetLoad.toString():widget.targetLoad.toInt().toString(),
                                      style: interBold.copyWith(
                                          color: ThemeManager().getDarkGreyTextColor,
                                          fontSize: width * 0.050),
                                    ),
                                  ),
                                  Text(
                                    " " + widget.loadMode,
                                    style: interRegular.copyWith(
                                        color: ThemeManager().getDarkGreyTextColor,
                                        fontSize: width * 0.035),
                                  ),
                                  Container(
                                    margin:
                                    EdgeInsets.only(left: width * 0.07, right: width * 0.02),
                                    child: SvgPicture.asset(
                                      ("assets/svg/timeIcon.svg"),
                                      height: height * 0.028,
                                      fit: BoxFit.cover,
                                      color: ThemeManager().getDarkGreyTextColor,
                                    ),
                                  ),
                                  // Container(
                                  //   child: Text(
                                  //     widget.minuteData,
                                  //     style: interBold.copyWith(
                                  //         color: ThemeManager().getDarkGreyTextColor,
                                  //         fontSize: width * 0.045),
                                  //   ),
                                  // ),
                                  // Text(
                                  //   "m  ",
                                  //   style: interRegular.copyWith(
                                  //       color: ThemeManager().getDarkGreyTextColor,
                                  //       fontSize: width * 0.035),
                                  // ),
                                  Container(
                                    child: Text(
                                      widget.testDuration.toString(),
                                      style: interBold.copyWith(
                                          color: ThemeManager().getDarkGreyTextColor,
                                          fontSize: width * 0.045),
                                    ),
                                  ),
                                  Text(
                                    " sec",
                                    style: interRegular.copyWith(
                                        color: ThemeManager().getDarkGreyTextColor,
                                        fontSize: width * 0.035),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: height * 0.1,
                              width: width * 0.15,
                              decoration: BoxDecoration(
                                color: ThemeManager().getLightGrey3Color,
                                image: new DecorationImage(
                                  image: new ExactAssetImage('assets/icons/lockIcon.png',
                                      scale: 0.9),
                                ),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      camaraGalleryView(),
                      //camaraGalleryView2(),



                      StreamBuilder<dynamic>(
                          stream: CommonAttachmentAddedStream.getInstance().outData,
                          builder: (context, snapshot) {
                            print("common added stream");
                            if (snapshot.hasData) {
                              commonAttachment.insert(0,snapshot.data);
                              //if (commonAttachment.length >= 5) _scrollController.animateTo(width, duration: Duration(seconds: 2), curve: Curves.easeIn);

                            } else {
                              Container(
                                width: 0,
                                height: 0,
                              );
                            }
                            return  Stack(
                              alignment: Alignment.center,
                              clipBehavior: Clip.none,
                              children: [
                                SingleChildScrollView(physics: ClampingScrollPhysics(),
                                  controller: _scrollController,
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: List.generate(commonAttachment.length, (index) {
                                      return  Container(  height: height * 0.07,
                                          width: width * 0.18,
                                          child: commonAttachment[index]["type"] == "i" ? Image.file(File(commonAttachment[index]["thumb"]),
                                            fit: BoxFit.cover,
                                          )
                                              : Icon(Icons.play_arrow,color: ThemeManager().getDarkGreenColor,)
                                        //VideoPlay(
                                        //                                            file: File(commonAttachment[index]["videoPath"]),
                                        //                                          )

                                        // Image.file(File(commonAttachment[index]["thumb"]),
                                        //   fit: BoxFit.cover,
                                        // )

                                      );
                                    }),
                                  ),
                                ),
                                commonAttachment.length >= 5
                                    ? Positioned(
                                  left: -width * .02,
                                  right: -width * .02,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _scrollController.animateTo(-width,
                                              duration: Duration(seconds: 2),
                                              curve: Curves.easeIn);
                                        },
                                        child: Container(
                                          height: height * .08,
                                          width: width * .05,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: whiteColor,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: ThemeManager()
                                                      .getLightGrey1Color,
                                                  spreadRadius: .25,
                                                )
                                              ]),
                                          padding:
                                          EdgeInsets.only(left: width * .012),
                                          child: Icon(
                                            Icons.arrow_back_ios,
                                            color: Colors.black,
                                            size: height * .02,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _scrollController.animateTo(width,
                                              duration: Duration(seconds: 2),
                                              curve: Curves.easeIn);
                                        },
                                        child: Container(
                                          height: height * .08,
                                          width: width * .05,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: whiteColor,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: lightGrey1Color,
                                                  spreadRadius: .25,
                                                )
                                              ]),
                                          padding:
                                          EdgeInsets.only(left: width * .004),
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.black,
                                            size: height * .02,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                    : Container()
                              ],
                            );
                            return Container( height: height * 0.07,width: double.infinity,
                              child: ListView.builder(reverse: true,
                                  scrollDirection: Axis.horizontal,
                                  // gridDelegate:
                                  // SliverGridDelegateWithFixedCrossAxisCount(
                                  //     crossAxisCount: 4),
                                  shrinkWrap: true,
                                  itemCount: commonAttachment.length,
                                  itemBuilder: (_, index) {
                                    // return Padding(
                                    //   padding: const EdgeInsets.all(5.0),
                                    //   child: Container(
                                    //       child: Center(child: Text(commonAttachment[index]["type"]))),
                                    // );
                                    return Stack(
                                      children: [
                                        Align(
                                            alignment: Alignment.center,
                                            child: Container(  height: height * 0.07,
                                                width: width * 0.18,
                                                child: commonAttachment[index]["type"] == "i" ? Image.file(File(commonAttachment[index]["thumb"]),
                                                  fit: BoxFit.cover,
                                                )
                                                    : VideoPlay(
                                                  file: File(commonAttachment[index]["videoPath"]),
                                                )

                                              // Image.file(File(commonAttachment[index]["thumb"]),
                                              //   fit: BoxFit.cover,
                                              // )

                                            )
                                          //TODO

                                          //  :Image.memory(commonAttachment[index]["thumb"])),
                                        ),
                                        // Align(
                                        //   alignment: Alignment.center,
                                        //   child: Container(height: 50,width: 50,
                                        //       child: commonAttachment[index]
                                        //       ["type"] ==
                                        //           "i"
                                        //           ? Icon(
                                        //         Icons.insert_photo_outlined,
                                        //         color: Theme.of(context)
                                        //             .primaryColor,
                                        //       )
                                        //           : Icon(Icons.play_circle_fill,
                                        //           color: Theme.of(context)
                                        //               .primaryColor)),
                                        // ),
                                      ],
                                    );
                                  }),
                            );
                          }),


                      StreamBuilder<bool>(
                          stream: TestStartStopStream.getInstance().outData,
                          // initialData: false,
                          builder: (c, snapshotTestStatus) {






                            if(snapshotTestStatus.hasData && snapshotTestStatus.data == false && widget.startedTime>0&& widget.data3.length>0  && widget.endedTime>0 ){
                              //return test has been finished
                              print("state 3");
                              AppToast().show(message: "3");
                             // return Container(height: 40,color: Colors.redAccent,);

                              if(true) {
                                return testFinish(snapshotTestStatus.data!);
                              }else{

                              }
                            }
                            // else if(snapshotTestStatus.hasData && snapshotTestStatus.data == false && widget.startedTime == 0 && widget.endedTime == 0 && widget.shouldCollect==true){
                            //   //return test not resolved
                            //   //timer did not started
                            //   //load dropped
                            //   return testFinish(snapshotTestStatus.data!);
                            // }
                            else{
                              return StreamBuilder<double>(
                                  stream: GauseValueStreamAsFloat.getInstance().outData,
                                  builder: (c, snapshotGauseValue) {
                                    if (snapshotGauseValue.hasData) {
                                      // BuildContext dialogContext = context;
                                      if(snapshotGauseValue.hasData){

                                        if(snapshotGauseValue.data! > warningLoad && isOverloadScreenShowing == false){
                                          print("show overlaod warning");
                                          isOverloadScreenShowing = true;
                                          //show alert
                                          ShowOverloadWarningStream.getInstance().dataReload(true);
                                        }else    if(snapshotGauseValue.data! < warningLoad && isOverloadScreenShowing == true){
                                          ShowOverloadWarningStream.getInstance().dataReload(false);
                                          isOverloadScreenShowing = false;
                                        }





                                      }else{
                                        //Navigator.
                                        // Navigator.pop(context);

                                      }
                                      // OverLoadScreen();
                                      //
                                      if( snapshotTestStatus.hasData && snapshotTestStatus.data == false && widget.startedTime == 0 && widget.endedTime == 0 && widget.shouldCollect==true && snapshotGauseValue.data!.toDouble() < cufOff){
                                        TestStartStopStream.getInstance().dataReload(false);
                                        AppToast().show(message: "stopp 4");
                                        showSavedInfo(false);
                                        print("state 4");
                                        AppToast().show(message: "4");
                                        return testFinish(snapshotTestStatus.data!);
                                      }

                                      if (widget.startedTime == 0 &&
                                          widget.endedTime == 0 &&
                                          widget.onceStartedTimer == false &&
                                          widget.shouldCollect == false &&
                                          snapshotGauseValue.data! < cufOff) {
                                        //pre load
                                        return   Container(
                                            margin: EdgeInsets.only(top: height * 0.01),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      decoration: new BoxDecoration(
                                                        color: ThemeManager().getDarkGreenColor,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            blurRadius: 5,
                                                            color: ThemeManager().getDarkGreenColor,
                                                          )
                                                        ],
                                                      ),
                                                      padding: EdgeInsets.symmetric(horizontal: 15),
                                                      alignment: Alignment.center,
                                                      height: height * 0.07,
                                                      width: width * 0.7,
                                                      child: Text("Apply Pre-Load on Primary Piston to "+(widget.loadMode=="kN"? cufOff.toString():cufOff.toInt().toString())+" "+widget.loadMode,
                                                          style: interMedium.copyWith(
                                                              color: ThemeManager().getWhiteColor,
                                                              fontSize: width * 0.040)),
                                                    ),
                                                    ClipPath(
                                                      clipper: MyTriangle(),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          color: ThemeManager().getDarkGreenColor,
                                                        ),
                                                        width: width * 0.05,
                                                        height: height * 0.03,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  height: height * 0.07,
                                                  width: width * 0.13,
                                                  decoration: new BoxDecoration(
                                                      image: new DecorationImage(
                                                        image: new AssetImage("assets/images/testMachine1Image.png"),
                                                        fit: BoxFit.fill,
                                                      )),
                                                )
                                              ],
                                            ));
                                        return InkWell(
                                          onTap: () {
                                            widget.onceStartedTimer = true;
                                            TestStartStopStream.getInstance()
                                                .dataReload(true);
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
                                      } else if (widget.endedTime > 0) {
                                        if(snapshotGauseValue.data! < cufOff){
                                          TestStartStopStream.getInstance().dataReload(false);
                                           return testFinish(false);
                                        }



                                        //remove load
                                        return Container(
                                            margin: EdgeInsets.only(top: height * 0.01),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      decoration: new BoxDecoration(
                                                        color: ThemeManager().getDarkGreenColor,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            blurRadius: 5,
                                                            color: ThemeManager().getDarkGreenColor,
                                                          )
                                                        ],
                                                      ),
                                                      padding: EdgeInsets.symmetric(horizontal: 15),
                                                      alignment: Alignment.center,
                                                      height: height * 0.07,
                                                      width: width * 0.7,
                                                      child: Text("Remove load on Hex Drive",
                                                          style: interMedium.copyWith(
                                                              color: ThemeManager().getWhiteColor,
                                                              fontSize: width * 0.040)),
                                                    ),
                                                    ClipPath(
                                                      clipper: MyTriangle(),
                                                      child: Container(
                                                        color: ThemeManager().getDarkGreenColor,
                                                        width: width * 0.05,
                                                        height: height * 0.03,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  height: height * 0.07,
                                                  width: width * 0.13,
                                                  decoration: new BoxDecoration(
                                                      image: new DecorationImage(
                                                        image: new AssetImage("assets/images/testMachine2Image.png"),
                                                        fit: BoxFit.fill,
                                                      )),
                                                )
                                              ],
                                            ));
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
                                        //apply load
                                        return Container(
                                            margin: EdgeInsets.only(top: height * 0.01),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      decoration: new BoxDecoration(
                                                        color: ThemeManager().getDarkGreenColor,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            blurRadius: 5,
                                                            color: ThemeManager().getDarkGreenColor,
                                                          )
                                                        ],
                                                      ),
                                                      padding: EdgeInsets.symmetric(horizontal: 15),
                                                      alignment: Alignment.center,
                                                      height: height * 0.07,
                                                      width: width * 0.7,
                                                      child: Text("Apply load on Hex Drive to target "+(widget.loadMode=="kN"? widget.targetLoad.toString():widget.targetLoad.toInt().toString())+" "+widget.loadMode,
                                                          style: interMedium.copyWith(
                                                              color: ThemeManager().getWhiteColor,
                                                              fontSize: width * 0.040)),
                                                    ),
                                                    ClipPath(
                                                      clipper: MyTriangle(),
                                                      child: Container(
                                                        color: ThemeManager().getDarkGreenColor,
                                                        width: width * 0.05,
                                                        height: height * 0.03,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  height: height * 0.07,
                                                  width: width * 0.13,
                                                  decoration: new BoxDecoration(
                                                    image: new DecorationImage(
                                                      image:
                                                      new AssetImage("assets/images/testMachine2Image.png"),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ));
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
                                        if(snapshotGauseValue.data! < cufOff){
                                          TestStartStopStream.getInstance().dataReload(false);
                                          return testFinish(false);
                                        }

                                        //running test
                                        return  Container(
                                          margin: EdgeInsets.only(top: height * 0.02, left: width * 0.10),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(left: width * 0.06, right: width * 0.05),
                                                child: SvgPicture.asset(
                                                  ("assets/svg/scanningIcon.svg"),
                                                  height: height * 0.04,
                                                  fit: BoxFit.cover,
                                                  // color: ThemeManager().getDarkGrayTextColor,
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  'Test Running... '+widget.start.toString()+' secs',
                                                  style: interSemiBold.copyWith(
                                                      color: ThemeManager().getDarkGreenColor,
                                                      fontSize: width * 0.042),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                        return InkWell(
                                          onTap: () {
                                            widget.onceStartedTimer = true;
                                            TestStartStopStream.getInstance()
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
                                        //click to start
                                        return    GestureDetector(
                                          onTap: () {



                                            widget.isTimerGoing =  true;
                                            widget.onceStartedTimer = true;
                                            widget.startedTime = new DateTime.now().millisecondsSinceEpoch - startTime + 1000;
                                            TestStartStopStream.getInstance().dataReload(true);
                                            widget.isTimerGoing =  true;
                                            widget.onceStartedTimer = true;
                                            widget.startedTime = new DateTime.now().millisecondsSinceEpoch - startTime + 1000;

                                          },
                                          child: Container(
                                            padding: EdgeInsets.only(left: width * 0.02, right: width * 0.02),
                                            margin: EdgeInsets.only(top: height * 0.01),
                                            height: height * 0.06,
                                            width: width * 0.4,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(50)),
                                                gradient: LinearGradient(
                                                  colors: [
                                                    ThemeManager().getOrangeGradientColor,
                                                    ThemeManager().getYellowGradientColor,
                                                  ],
                                                )),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                SvgPicture.asset(
                                                  ("assets/svg/timeIcon.svg"),
                                                  color: ThemeManager().getWhiteColor,
                                                ),
                                                Container(
                                                  child: Text(
                                                    "Start Timer",
                                                    style: interSemiBold.copyWith(
                                                        color: ThemeManager().getWhiteColor,
                                                        fontSize: width * 0.040),
                                                  ),
                                                ),
                                              ],
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
                                  });
                            }

                          }),

                    ],
                  ),
                ),
              )




            ],
          ),),

          Align(alignment: Alignment.bottomCenter,child: Container(height: height*.08,child: AppBottomNavigationar(context: context).getNavigationBar(level: 0))),
          StreamBuilder<bool>(
          stream: ShowOverloadWarningStream.getInstance().outData,
          // async work
          builder: (BuildContext context,
          AsyncSnapshot<bool> snapshot) {
            return Container(height: height*0.5,child: Visibility(visible: (snapshot.hasData && snapshot.data == true)?true:false,child: OverLoadScreen()));


          })
        ],
      ),

        // Stack(children: [
        //   Positioned(top: 0,left: 0,right: 0,bottom:(height * 0.075) ,child: w),
        //   Align(alignment: Alignment.bottomCenter,child: bottomNav,),
        //
        // ],)

    ),);

  }

  Widget camaraGalleryView() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return FutureBuilder(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: height * 0.028),
                height: height * 0.24,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // return the widget to show the live preview of camera.
                    // Container(
                    //     height: height * 0.19,
                    //     width: double.infinity,
                    //     child: CameraPreview(_controller)),

                    Container(
                        height: height * 0.24,
                        width: double.infinity,
                        child:ClipRect(
                            child: new OverflowBox(
                                maxWidth: double.infinity,
                                maxHeight: double.infinity,
                                alignment: Alignment.center,
                                child: new FittedBox(
                                    fit: BoxFit.cover,
                                    alignment: Alignment.center,
                                    child: new Container(
                                        width: width,
                                        height: height*0.7,
                                        child: new  CameraPreview(_controller)
                                    )
                                )
                            )
                        )),
                        StreamBuilder<int>(
                        stream: RecordingTimerStream.getInstance().outData,
                        //recent
                        builder: (context, snapshot) {
                          if(snapshot.hasData &&  isSelected == true && _isRecording == true && snapshot.data!>0){
                           return  Positioned(
                              top: height * .02,
                              child: Container(
                                child: Text(
                                 "00 : "+twoDigits(snapshot.data!).toString(),
                                  style: TextStyle(
                                    color: whiteColor,
                                  ),
                                ),
                              ),
                            );
                          }else{
                            return Text("");
                          }
                        }),

                    isSelected == true && _isRecording == true
                        ? Positioned(
                      top: height * .02,
                      child: Container(
                        child: Text(
                          minutes + ":" + seconds,
                          style: TextStyle(
                            color: whiteColor,
                          ),
                        ),
                      ),
                    )
                        : Container(),
                    Wrap(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (isSelected == false) {

                              _controller.takePicture().then((value) {
                                RecordingStartedStoppedStream.getInstance().dataReload(false);
                                PhotoClickedStream.getInstance().dataReload({
                                  "imagePath":value.path,
                                  // "image": imageParts,
                                  "time": new DateTime.now()
                                      .millisecondsSinceEpoch
                                });

                                CommonAttachmentAddedStream.getInstance().dataReload({
                                  "thumb":value.path,
                                  "type": "i",
                                  // "data": imageParts,
                                  "time": new DateTime.now().millisecondsSinceEpoch
                                });


                                // setState(() {
                                //   imageFile = value;
                                //   if (imageList.length >= 5)
                                //     _scrollController.animateTo(width,
                                //         duration: Duration(seconds: 2),
                                //         curve: Curves.easeIn);
                                // });
                                // File media = File(value.path);
                                // imageList.add(media.path);
                                // newImageList.add(media);
                                //log(imageList.toString());
                              });
                            } else {
                              if (_isRecording == false) {
                                RecordingStartedStoppedStream.getInstance().dataReload(true);
                                _controller.startVideoRecording().then((value) {

                                    _isRecording = true;

                                  startTimer();
                                });
                              } else {
                                _controller.stopVideoRecording().then((value) {
                                  _isRecording = false;
                                  RecordingStartedStoppedStream.getInstance().dataReload(false);

                                  VideoClickedStream.getInstance().dataReload({
                                    "videoPath":value.path,
                                    // "video": imageParts,
                                    "time": new DateTime.now().millisecondsSinceEpoch - startTime
                                  });

                                  CommonAttachmentAddedStream.getInstance().dataReload({
                                    // "thumb":image.path,
                                    "type": "v",
                                    "videoPath":value.path,
                                    "time": new DateTime.now().millisecondsSinceEpoch
                                  });

                                  stopTimer();
                                  // setState(() {
                                  //   imageFile = value;
                                  //   _isRecording = false;
                                  //   if (imageList.length >= 5)
                                  //     _scrollController.animateTo(width,
                                  //         duration: Duration(seconds: 2),
                                  //         curve: Curves.easeIn);
                                  // });
                                  // File media = File(value.path);
                                  // imageList.add(media.path);
                                  // newImageList.add(media);
                                  // // log(imageList.toString());
                                  // stopTimer();
                                });
                              }
                            }
                          },
                          //VideoPhotoToggleStream
                          child: StreamBuilder<bool>(
                              stream: RecordingStartedStoppedStream.getInstance().outData,
                              //recent
                              builder: (context, snapshot) {
                                //false or null is video is not recording
                                if(snapshot.hasData){
                                  if(snapshot.data == false){
                                    return  Icon(
                                      Icons.circle_outlined,
                                      color: ThemeManager().getWhiteColor,
                                      size: height * .08,
                                    );
                                  }else{
                                      return  Container(
                                      height: height * .06,
                                      width: height * .06,
                                      decoration: BoxDecoration(
                                        color: whiteColor,
                                        shape: BoxShape.circle,
                                      ),
                                      alignment: Alignment.center,
                                      child: Container(
                                        decoration: BoxDecoration(color: blackColor),
                                        height: height * .02,
                                        width: height * .02,
                                      ),
                                    );
                                  }

                                }else{
                                 return Icon(
                                      Icons.circle_outlined,
                                      color: ThemeManager().getWhiteColor,
                                      size: height * .08,
                                    );
                                }



                              }),
                          // child: _isRecording == true
                          //     ? Container(
                          //   height: height * .06,
                          //   width: height * .06,
                          //   decoration: BoxDecoration(
                          //     color: whiteColor,
                          //     shape: BoxShape.circle,
                          //   ),
                          //   alignment: Alignment.center,
                          //   child: Container(
                          //     decoration: BoxDecoration(color: blackColor),
                          //     height: height * .02,
                          //     width: height * .02,
                          //   ),
                          // )
                          //     : Icon(
                          //   Icons.circle_outlined,
                          //   color: ThemeManager().getWhiteColor,
                          //   size: height * .08,
                          // ),
                        ),

                      ],
                    ),
                 gallaryPhotoAdd? Positioned(left: 10,bottom: 10,child:   Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: GestureDetector(
                        onTap: () async {

                          showDialog(
                              context: context,
                              builder: (_) => Dialog(child: Container(width: MediaQuery.of(context).size.width*0.9,child: Wrap(
                                children: [
                                  Container(height: 50,
                                    child: Stack(children: [
                                      Align(alignment: Alignment.centerLeft,child: Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: Text("Add attachments from Gallery",style: interSemiBold.copyWith(
                                            color: ThemeManager().getBlackColor,
                                            fontSize: width * 0.042),),
                                      ),),
                                      Align(alignment: Alignment.centerRight,child: InkWell(onTap: (){
                                        Navigator.pop(context);
                                      },child: Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: Icon(Icons.clear),
                                      ),),),
                                    ],),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Expanded(child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),color: ThemeManager().getDarkGreenColor),child:
                                          InkWell(onTap: () async {
                                            final ImagePicker _picker = ImagePicker();
                                            // Pick an image
                                            final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

                                            PhotoClickedStream.getInstance().dataReload({
                                              "imagePath":image!.path,
                                              // "image": imageParts,
                                              "time": new DateTime.now()
                                                  .millisecondsSinceEpoch
                                            });

                                            CommonAttachmentAddedStream.getInstance().dataReload({
                                              "thumb":image.path,
                                              "type": "i",
                                              // "data": imageParts,
                                              "time": new DateTime.now().millisecondsSinceEpoch
                                            });
                                            Navigator.pop(context);
                                          },
                                            child: Center(child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text("Pick Photo",style: interSemiBold.copyWith(
                                                  color: ThemeManager().getWhiteColor,
                                                  fontSize: width * 0.042),),
                                            ),),
                                          ),),
                                        ),),
                                        Expanded(child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),color: ThemeManager().getDarkGreenColor),child:
                                          InkWell(onTap: () async {
                                            final ImagePicker _picker = ImagePicker();
                                            // Pick an image
                                            final XFile? image = await _picker.pickVideo(source: ImageSource.gallery);

                                            VideoClickedStream.getInstance().dataReload({
                                              "videoPath":image!.path,
                                              // "video": imageParts,
                                              "time": new DateTime.now().millisecondsSinceEpoch - startTime
                                            });

                                            CommonAttachmentAddedStream.getInstance().dataReload({
                                              // "thumb":image.path,
                                              "type": "v",
                                              "videoPath":image.path,
                                              "time": new DateTime.now().millisecondsSinceEpoch
                                            });
                                            Navigator.pop(context);
                                          },
                                            child: Center(child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text("Pick Video",style: interSemiBold.copyWith(
                                                  color: ThemeManager().getWhiteColor,
                                                  fontSize: width * 0.042),),
                                            ),),
                                          ),),
                                        ),),
                                      ],
                                    ),
                                  ),

                                ],
                              ),),)
                          );


                        },
                        child: Icon(
                          Icons.photo_library_sharp,
                          color: ThemeManager().getWhiteColor,
                          size: height * .03,
                        ),
                      ),
                    ),):Container(width: 0,height: 0,),
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              left: width * 0.65, top: height * 0.015),
                          child: StreamBuilder<bool>(
                          stream: VideoPhotoToggleStream.getInstance().outData,
                          //recent
                          builder: (context, snapshot) {
                            //false or null is for photo

                          return  StreamBuilder<bool>(
                            stream: RecordingStartedStoppedStream.getInstance().outData,
        //recent
                            builder: (context, snapshotrecordingStartStop) {

                                return Visibility(visible:(snapshotrecordingStartStop.hasData && snapshotrecordingStartStop.data == true)?false:((snapshotrecordingStartStop.hasData && snapshotrecordingStartStop.data == false)?true:true),


                                  child: CameraToggle(isPhoto: !isSelected,isVideoSelected: (bool ) {


                                    _isSelectForPhoto = !bool;
                                    isSelected = bool;

                                  },));


                            });


                          }),



                        )
                      ],
                    ),

                    true? Positioned(left: 10,top: 10,child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: InkWell(onTap: (){


                            if(maxZoom>0 &&  zoom <maxZoom){
                              _controller.setZoomLevel((zoom+1)).then((value){
                                zoom++;
                              });

                            }

                          },
                            child: Card(color : ThemeManager().getDarkGreenColor,elevation: 4,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0),),
                              child: Container(width: 40,height: 40,child: Center(child:
                              Text("+",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white)),),),),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: InkWell(onTap: (){
                            if(minZoom>0 &&  zoom > minZoom){
                              _controller.setZoomLevel((zoom-1)).then((value){
                                zoom--;
                              });

                            }

                          },
                            child: Card(color: ThemeManager().getDarkGreenColor,elevation: 4,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0),),
                              child: Container(width: 40,height: 40,child: Center(child:
                              Text("-",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white)),),),),
                          ),
                        ),

                      ],
                    )):Container(width: 0,height: 0,),
                  ],
                ),
              ),
              // imageFile == null
              //     ? Container()
              //     : Stack(
              //   alignment: Alignment.center,
              //   clipBehavior: Clip.none,
              //   children: [
              //     SingleChildScrollView(
              //       controller: _scrollController,
              //       scrollDirection: Axis.horizontal,
              //       child: Row(
              //         children: List.generate(imageList.length, (index) {
              //           return Container(
              //             height: height * 0.07,
              //             width: width * 0.18,
              //             child: imageList[index].endsWith(".jpg")
              //                 ? Image.file(
              //               File(imageList[index]),
              //               fit: BoxFit.cover,
              //             )
              //                 : Container(
              //               child: Center(
              //                 child: VideoPlay(
              //                   file: File(imageList[index]),
              //                 ),
              //               ),
              //             ),
              //           );
              //         }),
              //       ),
              //     ),
              //     imageList.length >= 5
              //         ? Positioned(
              //       left: -width * .02,
              //       right: -width * .02,
              //       child: Row(
              //         mainAxisAlignment:
              //         MainAxisAlignment.spaceBetween,
              //         children: [
              //           GestureDetector(
              //             onTap: () {
              //               _scrollController.animateTo(-width,
              //                   duration: Duration(seconds: 2),
              //                   curve: Curves.easeIn);
              //             },
              //             child: Container(
              //               height: height * .08,
              //               width: width * .05,
              //               decoration: BoxDecoration(
              //                   shape: BoxShape.circle,
              //                   color: whiteColor,
              //                   boxShadow: [
              //                     BoxShadow(
              //                       color: ThemeManager()
              //                           .getLightGrey1Color,
              //                       spreadRadius: .25,
              //                     )
              //                   ]),
              //               padding:
              //               EdgeInsets.only(left: width * .012),
              //               child: Icon(
              //                 Icons.arrow_back_ios,
              //                 color: Colors.black,
              //                 size: height * .02,
              //               ),
              //             ),
              //           ),
              //           GestureDetector(
              //             onTap: () {
              //               _scrollController.animateTo(width,
              //                   duration: Duration(seconds: 2),
              //                   curve: Curves.easeIn);
              //             },
              //             child: Container(
              //               height: height * .08,
              //               width: width * .05,
              //               decoration: BoxDecoration(
              //                   shape: BoxShape.circle,
              //                   color: whiteColor,
              //                   boxShadow: [
              //                     BoxShadow(
              //                       color: lightGrey1Color,
              //                       spreadRadius: .25,
              //                     )
              //                   ]),
              //               padding:
              //               EdgeInsets.only(left: width * .004),
              //               child: Icon(
              //                 Icons.arrow_forward_ios,
              //                 color: Colors.black,
              //                 size: height * .02,
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     )
              //         : Container()
              //   ],
              // )
            ],
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
  //-------------------------------------test finish view----------------------
  Widget testFinish(bool event){

    return InkWell(onTap: (){

      showSavedInfo(event);



    },
      child: Container(
        margin: EdgeInsets.only(top: height * 0.01),
          child:  Container(
            padding: EdgeInsets.only(left: width * 0.02, right: width * 0.02),
            //margin: EdgeInsets.only(top: height * 0.02),
            height: height * 0.06,
            width: width * 0.4,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                gradient: LinearGradient(
                  colors: [
                    ThemeManager().getOrangeGradientColor,
                    ThemeManager().getYellowGradientColor,
                  ],
                )),
            child: Container(
              child: Center(
                child: Text(
                  "Done",
                  style: interSemiBold.copyWith(
                      color: ThemeManager().getWhiteColor,
                      fontSize: width * 0.040),
                ),
              ),
            ),
          ),
          // child:Row(
          //   children: [
          //     Container(
          //       decoration: new BoxDecoration(
          //         color:ThemeManager().getOrangeGradientColor,
          //         boxShadow: [
          //           BoxShadow(
          //             blurRadius:5,
          //             color:ThemeManager().getOrangeGradientColor,
          //           )
          //         ],
          //       ),
          //       padding: EdgeInsets.symmetric(horizontal: 15),
          //       alignment: Alignment.center,
          //       height: height*0.065,
          //       width: width*0.85 ,
          //
          //       child: Text(
          //           "Test Finished.Click to save",style: interMedium.copyWith(
          //           color: ThemeManager().getWhiteColor,
          //           fontSize: width * 0.040)
          //       ),
          //     ),
          //     ClipPath(
          //       clipper: MyTriangle(),
          //       child:   Container(
          //         decoration: BoxDecoration(
          //             color: ThemeManager().getOrangeGradientColor
          //         ),
          //         width: width*0.05,
          //         height:height*0.03,
          //       ),
          //     ),
          //
          //   ],
          // )
      ),
    );
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




        VideoClickedStream.getInstance().dataReload({
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

  void initCamera2() async {
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
    TestStartStopStream.getInstance().outData.listen((event) async {
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

        if (widget.shouldCollect == true ) {
          //  widget.testDataToSave.clear();
          //  widget.data2.clear();
          widget.hasSuccessfullyFinishedTest = false;
          //just commented the start timer
          startTimerOld();
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
    PhotoClickedStream.getInstance().outData.listen((event) {
      widget.photos.insert(0, event);
    });
    VideoClickedStream.getInstance().outData.listen((event) {
      videos.insert(0,event);
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
      BuildContext context, OldPerformTestPageActivity widget, String id) {
    print("Open screen for test saving location "+ id);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FileExplorarForTestSave(
        customerFirestore: widget.customerFirestore,
        id: id,
      )),
    );
    // showModalBottomSheet(
    //     context: context,
    //     builder: (BuildContext bc) {
    //       return FileExplorarForTestSave(
    //         customerFirestore: widget.customerFirestore,
    //         id: id,
    //       );
    //     });
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

  String convertFromStreamToString(List<int> data) {
    String returnValue = "";

   // final result = data.map((b) => '${b.toRadixString(16).padLeft(2, '0')}');
    //print('bytes: ${result}');
    HexEncoder _hexEncoder;
    var bd = ByteData(4);
    for (int i = 0; i < data.length; i++) {
     // String tempVal = data[i].toRadixString(16).padLeft(2, '0').toString();
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

  // return f.toStringAsFixed(PrefferedDecimalPlaces);
    // return f.toStringAsFixed(PrefferedDecimalPlaces)+"01";


    String vvv = getNumber(  f,precision:PrefferedDecimalPlaces).toString();
    print("roxy "+vvv);

    return vvv;
    try{
      return  getNumber(  f,precision:PrefferedDecimalPlaces).toString();
    }catch(e){
      return  getNumber(  f,precision:1).toString()+(PrefferedDecimalPlaces==1?"":"0");
    }

    return f.toStringAsFixed(1);
  }

  void listenForTargetLoad() {


    if(widget.loadMode == "kN"){
      cufOff = 0.2;

    }else{

      cufOff = 45;

    }




    int lastAdd = 0;
    GauseValueStreamAsFloat.getInstance().outData.listen((event)  {
      //print("raw " + event.toString());



      if(event > widget.targetLoad*1.00 && event< widget.targetLoad*1.2 && widget.isTimerGoing == false && widget.startedTime == 0 &&widget.endedTime == 0 &&widget.onceStartedTimer == false &&  widget.vibStarted == false &&  (widget.lastVibTime <  DateTime.now().millisecondsSinceEpoch-300000 ||  widget.lastVibTime==0)){
        widget.vibStarted == true;
        widget.lastVibTime =  DateTime.now().millisecondsSinceEpoch;
        if(widget.vibStarted == false){
          Vibration.vibrate(duration: 500).then((value) {
            widget.vibStarted == false;
          });
        }


      }

      //will stop the test if the test did not started timer and load fall down
      if (event <  cufOff &&  widget.shouldCollect == true  && widget.isTimerGoing == false && widget.startedTime>0 ) {
       // widget.didPassed = false ;
        widget.start = 0;

        widget.start = 0 ;
        widget.isTimerGoing = false;

        // setState(() {
        //timer.cancel();
        widget.hasSuccessfullyFinishedTest = true;
        widget.shouldCollect = false;
        widget.messageDetails = "Test finished and saved.Click to run again";



        AppToast().show(message: "stopp 5");
        TestStartStopStream.getInstance().dataReload(false);
      }
      //will stop the test if the test did  started timer but did not reached the full timer and load fall down
      if (event < cufOff &&
          widget.startedTime == 0 &&
          widget.onceStartedTimer == false &&
          widget.shouldCollect == true) {
        widget.didPassed = false;
        AppToast().show(message: "stopp 6");
        TestStartStopStream.getInstance().dataReload(false);
      }

      //will stop test if the test had reached the max load and then load fall down
      if (widget.shouldCollect == true && event < cufOff && widget.maxVal > widget.targetLoad && widget.isTimerGoing == false) {
       // AppToast().show(message: "stopp 7");
       // TestStartStopStream.getInstance().dataReload(false);
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
      if (event > cufOff && widget.shouldCollect == false) {
        widget.shouldCollect = true;
      }
    });
  }

  String getACurrentTimeStamp(String id) {
    String date = "";
    DateTime now = DateTime.now();
    final df = new DateFormat('hh:mm a dd MMM yyyy');
    String date_ = df.format(now);
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
        .update({"name": df}).then((value) {});
    return date_;
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
   // location = new Location();

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
      child: LineMultiColor(prefferedDecimalPlace: PrefferedDecimalPlaces,unit: widget.loadMode,didPassed: true,
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
      builder: (context) => Scaffold(backgroundColor: Colors.transparent,

        body: Center(
            child: capturedImage != null
                ? Image.memory(capturedImage)
                : Container()),
      ),
    );
  }
  void reset() {
    if (_isRecording) {
      duration = countdownDuration;
     // setState(() => duration = countdownDuration);
    } else {
      duration = Duration();
     // setState(() => duration = Duration());
    }
  }
  void addTime() {

    // final addSeconds = countDown ? 1 : -1;
    // setState(() {
    //   final seconds = duration.inSeconds + addSeconds;
    //   if (seconds < 0) {
    //     timer?.cancel();
    //   } else {
    //     duration = Duration(seconds: seconds);
    //   }
    // });
    // if(duration.inSeconds>19){
    //   _controller.stopVideoRecording().then((value) {
    //     setState(() {
    //
    //     });
    //
    //     // log(imageList.toString());
    //     stopTimer();
    //
    //
    //             VideoClickedStream.getInstance().dataReload({
    //               "videoPath":value.path,
    //               // "video": imageParts,
    //               "time": new DateTime.now().millisecondsSinceEpoch - startTime
    //             });
    //
    //             CommonAttachmentAddedStream.getInstance().dataReload({
    //               // "thumb":image.path,
    //               "type": "v",
    //               "videoPath":value.path,
    //               "time": new DateTime.now().millisecondsSinceEpoch
    //             });
    //   });
    // }





    final addSeconds = _isRecording ? 1 : -1;

      final seconds = duration.inSeconds + addSeconds;
      if (seconds < 0) {
        print("stop");
        timer?.cancel();
      } else {
        print("increasing time ");
        duration = Duration(seconds: seconds);

        RecordingTimerStream.getInstance().dataReload(duration.inSeconds);
        if(duration.inSeconds>19){
          print("stopping time ");
          stopTimer();
          _controller.stopVideoRecording().then((value) {
            _isRecording = false;
            RecordingStartedStoppedStream.getInstance().dataReload(false);

            VideoClickedStream.getInstance().dataReload({
              "videoPath":value.path,
              // "video": imageParts,
              "time": new DateTime.now().millisecondsSinceEpoch - startTime
            });

            CommonAttachmentAddedStream.getInstance().dataReload({
              // "thumb":image.path,
              "type": "v",
              "videoPath":value.path,
              "time": new DateTime.now().millisecondsSinceEpoch
            });
          });
        }
      }

  }

  Future<void> getFromOldPageAttachment() async {
    if(widget.attachmentsFromPreviousScreen.length>0){
      print(widget.attachmentsFromPreviousScreen);
      print("got "+widget.attachmentsFromPreviousScreen.length.toString());
      for(int i = 0 ; i < widget.attachmentsFromPreviousScreen.length ; i++){

    //  await  Future.delayed(Duration(seconds: 1));
        if(widget.attachmentsFromPreviousScreen[i].toString().endsWith("jpg")){





          commonAttachment.add({
            "thumb": widget.attachmentsFromPreviousScreen[i].toString(),
            "type": "i",
            // "data": imageParts,
            "time": new DateTime.now().millisecondsSinceEpoch
          });

          widget.photos.add({
            "imagePath":widget.attachmentsFromPreviousScreen[i].toString(),
            // "image": imageParts,
            "time": new DateTime.now()
                .millisecondsSinceEpoch
          });
          // PhotoClickedStream.getInstance().dataReload({
          //   "imagePath":widget.attachmentsFromPreviousScreen[i].toString(),
          //   // "image": imageParts,
          //   "time": new DateTime.now()
          //       .millisecondsSinceEpoch
          // });
          //
          // CommonAttachmentAddedStream.getInstance().dataReload({
          //   "thumb": widget.attachmentsFromPreviousScreen[i].toString(),
          //   "type": "i",
          //   // "data": imageParts,
          //   "time": new DateTime.now().millisecondsSinceEpoch
          // });
        }else{


          commonAttachment.add({
            // "thumb":image.path,
            "type": "v",
            "videoPath": widget.attachmentsFromPreviousScreen[i].toString(),
            "time": new DateTime.now().millisecondsSinceEpoch
          });

          videos.add({
            "videoPath": widget.attachmentsFromPreviousScreen[i].toString(),
            // "video": imageParts,
            "time": new DateTime.now().millisecondsSinceEpoch - startTime
          });
          // VideoClickedStream.getInstance().dataReload({
          //   "videoPath": widget.attachmentsFromPreviousScreen[i].toString(),
          //   // "video": imageParts,
          //   "time": new DateTime.now().millisecondsSinceEpoch - startTime
          // });
          //
          // CommonAttachmentAddedStream.getInstance().dataReload({
          //   // "thumb":image.path,
          //   "type": "v",
          //   "videoPath": widget.attachmentsFromPreviousScreen[i].toString(),
          //   "time": new DateTime.now().millisecondsSinceEpoch
          // });

          //
        }
      }
      setState(() {

      });
    }else{
      print("No attachment from old page");
    }

  }

  testStatus() {
   // widget.didPassed? "Pass":((widget.startedTime>0 &&widget.endedTime>0)?"Fail":"Not Resolved" )
    if(widget.didPassed == true)return "Pass";
    if(widget.startedTime == 0 &&widget.endedTime == 0)return "Not Timed";
    if(widget.startedTime > 0 &&widget.endedTime == 0)return "Fail";
    if(widget.didPassed == false)return "Fail";

  }

  void stopTimer({bool resets = true}) {
    if (resets) {
      reset();
    }
    timer?.cancel();
    RecordingTimerStream.getInstance().dataReload(0);
    //setState(() => timer?.cancel());
  }

  void startTimer() {
    try{
      timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
    }catch(e){

    }
  }

  void showSavedInfo(bool event) {
    print("save try");
    running = event;

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
            text: getACurrentTimeStamp(key).replaceAll("", ""));
        controllerTitle.selection = TextSelection(
            baseOffset: 0, extentOffset: controllerTitle.text.length);
        print("going to open inent");
        void listen() {
          widget.customerFirestore
              .collection("pulltest")
              .doc(key)
              .update({"name": controllerTitle.text});
        }

        controllerTitle.addListener(listen);
        ScreenshotController screenshotController = ScreenshotController();
        //look here




        bool existingTheme = darkTheme;

        darkTheme = false;
        Widget testWidget = new MaterialApp(debugShowCheckedModeBanner: false,home: Container(height: MediaQuery.of(context).size.width*0.5,width: MediaQuery.of(context).size.width,
          child: LineMultiColor(unit: widget.loadMode,prefferedDecimalPlace: PrefferedDecimalPlaces,
            data: testData,
            max: widget.maxVal,
            target: widget.targetLoad,
            startedLoad: widget.startedTime,
            duration: widget.durationForTest,
            endedLoad: widget.endedTime,
            fullDuration: widget.fullDuration, didPassed: true,),
        ));
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TestSaveScreen(widToScreenSot: Text(""), id: key,customerFirestore: widget.customerFirestore,status:testStatus(),end: TestPerformLogics().durationToString(widget.endedTime),start: TestPerformLogics().durationToString(widget.startedTime),peek: widget.loadMode=="kN"? widget.maxVal.toString()+" "+widget.loadMode+" at "+TestPerformLogics().durationToString(widget.maxAt):widget.maxVal.toInt().toString()+" "+widget.loadMode+" at "+TestPerformLogics().durationToString(widget.maxAt),)
            ));
        screenshotController
            .captureFromWidget(
            InheritedTheme.captureAll(
                context, Material(child: Container(color: Colors.white,height: MediaQuery.of(context).size.width*0.5,width: MediaQuery.of(context).size.width,child:testWidget))),
            delay: Duration(milliseconds: 100))
            .then((capturedImage) {
         // ShowCapturedWidget(context, capturedImage);
          // Handle captured image
          print("graph taken");
          widget.customerFirestore
              .collection("pulltest")
              .doc(key)
              .update({"graphImage": base64Encode(capturedImage!)}).then((value) {
                AppToast().show(message: "light graph taken;");







          });


            //  darkTheme = true;
            //  Widget testWidgetDark = new MaterialApp(debugShowCheckedModeBanner: false,home: Container(height: MediaQuery.of(context).size.width*0.5,width: MediaQuery.of(context).size.width,
            //    child: LineMultiColor(unit: widget.loadMode,
            //      data: testData,
            //      max: widget.maxVal,
            //      target: widget.targetLoad,
            //      startedLoad: widget.startedTime,
            //      duration: widget.durationForTest,
            //      endedLoad: widget.endedTime,
            //      fullDuration: widget.fullDuration, didPassed: true,),
            //  ));
            // darkTheme = existingTheme;




          // widget.customerFirestore
          //     .collection("pulltest")
          //     .doc(key)
          //     .update({"mapImage": widget.map});
       });


        // screenshotController
        //     .captureFromWidget(
        //     InheritedTheme.captureAll(
        //         context, Material(child: testWidget)),
        //     delay: Duration(seconds: 1))
        //     .then((capturedImage) {
        //   widget.customerFirestore
        //       .collection("pulltest")
        //       .doc(key)
        //       .update({"graphImage": base64Encode(capturedImage!)}).then((value) {
        //
        //   });
        // });

        // showDialog(
        //   context: context,
        //   builder: (context) {
        //     String contentText = "Content of Dialog";
        //     return StatefulBuilder(
        //       builder: (context, setState) {
        //         return Dialog(
        //           shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.all(Radius.circular(10))),
        //           child: Wrap(
        //             children: [
        //               Screenshot(
        //                 controller: screenshotController,
        //                 child: Container(height: MediaQuery.of(context).size.width*0.5,width:  MediaQuery.of(context).size.width,
        //                   child: LineMultiColor(unit: widget.loadMode,
        //                     data: testData,
        //                     max: widget.maxVal,
        //                     target: widget.targetLoad,
        //                     startedLoad: widget.startedTime,
        //                     duration: widget.durationForTest,
        //                     endedLoad: widget.endedTime,
        //                     fullDuration: widget.fullDuration, didPassed: true,),
        //                 ),
        //               ),
        //               Padding(
        //                 padding: const EdgeInsets.all(8.0),
        //                 child: Center(child: Text("Saving .........",style: TextStyle(fontSize: 18,color: ThemeManager().getDarkGreenColor,fontWeight: FontWeight.bold),)),
        //               ),
        //             ],
        //           ) ,
        //         );
        //
        //       },
        //     );
        //   },
        // );

        // Future.delayed(Duration(seconds: 2)).then((value) {
        //   screenshotController
        //       .capture(delay: Duration(milliseconds: 10))
        //       .then((capturedImage) async {
        //     // Navigator.pop(context);
        //
        //     widget.customerFirestore
        //         .collection("pulltest")
        //         .doc(key)
        //         .update({"graphImage": base64Encode(capturedImage!)}).then((value) {
        //       Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //               builder: (context) => TestSaveScreen( id: key,customerFirestore: widget.customerFirestore,status:testStatus(),end: TestPerformLogics().durationToString(widget.endedTime),start: TestPerformLogics().durationToString(widget.startedTime),peek: widget.loadMode=="kN"? widget.maxVal.toString()+" "+widget.loadMode+" at "+TestPerformLogics().durationToString(widget.maxAt):widget.maxVal.toInt().toString()+" "+widget.loadMode+" at "+TestPerformLogics().durationToString(widget.maxAt),)
        //           ));
        //
        //     });
        //   }).catchError((onError) {
        //     showDialog(
        //       context: context,
        //       builder: (context) {
        //         String contentText = "Content of Dialog";
        //         return StatefulBuilder(
        //           builder: (context, setState) {
        //             return Dialog(
        //               shape: RoundedRectangleBorder(
        //                   borderRadius: BorderRadius.all(Radius.circular(10))),
        //               child: Text(onError.toString()),
        //               // actions: <Widget>[
        //               //   TextButton(
        //               //     onPressed: () => Navigator.pop(context),
        //               //     child: Text("Cancel"),
        //               //   ),
        //               //   TextButton(
        //               //     onPressed: () {
        //               //       setState(() {
        //               //         contentText = "Changed Content of Dialog";
        //               //       });
        //               //     },
        //               //     child: Text("Change"),
        //               //   ),
        //               // ],
        //             );
        //           },
        //         );
        //       },
        //     );
        //
        //   });
        // });










        //
        // Navigator.of(context).push(new MaterialPageRoute<Null>(
        //     builder: (BuildContext context) {
        //       String width = MediaQuery.of(context).size.width.ceil().toString();
        //
        //       final scaffoldState = GlobalKey<ScaffoldState>();
        //       return TestSaveScreen( id: key,customerFirestore: widget.customerFirestore,status:testStatus(),end: TestPerformLogics().durationToString(widget.endedTime),start: TestPerformLogics().durationToString(widget.startedTime),peek: widget.maxVal.toString()+" at "+TestPerformLogics().durationToString(widget.maxAt),);
        //     },
        //     fullscreenDialog: true));

        // setState(() {
        //   widget.data3.clear();
        //   widget.data2.clear();
        //   // videos.clear();
        // });



        // Navigator.of(context).push(new MaterialPageRoute<Null>(
        //     builder: (BuildContext context) {
        //       return TestSaveScreen(id: key,customerFirestore: widget.customerFirestore,status:widget.didPassed? "Pass":((widget.start>0 &&widget.endedTime>0)?"Fail":"Not Resolved" ),end: TestPerformLogics().durationToString(widget.endedTime),start: TestPerformLogics().durationToString(widget.start),peek: widget.maxVal.toString()+" at "+widget.maxAt.toString(),);
        //     },
        //     fullscreenDialog: true));
      } catch (e) {
        print("save error");
        print(e);
        showMessageAsBottomSheet(context, e.toString());
      }
      // Position location =   GeolocatorPlatform.instance.getCurrentPosition(desiredAccuracy: gl.LocationAccuracy.high);
      save(gl.Position currentLocation){
        AppFirestore(firestore: widget.customerFirestore,auth: FirebaseAuth.instance, projectId: widget.project).savePullTestRecord(decimalPlace:PrefferedDecimalPlaces,key: key,
          index2: widget.index2,
          index6: widget.index6,
          note: "",loadMode: widget.loadMode,
          name:  getACurrentTimeStamp(key),
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
          currentLocation:currentLocation,
          allPHotos: widget.photos,
          allvid: videos,
        );
      }
      save(widget.position);



    }

  }

  double convertRightUnit(double parse) {
    double oldDouble = 0 ;
    double newDouble = 0 ;

    if(widget.loadMode == "lbf"){
      return (parse*224.80894).toInt().toDouble();

    } else{

      double  ddd = getNumber(  parse,precision:PrefferedDecimalPlaces);

          print("ready to show "+ddd.toStringAsFixed(PrefferedDecimalPlaces));
          return ddd;
      //return  ddd.toStringAsFixed(PrefferedDecimalPlaces);
      //return parse;
    }
  }
}

void returnHomePage(BuildContext context) {
 // Navigator.of(context).popUntil((route) => route.isFirst);
}

class FileExplorarForTestSave extends StatefulWidget {
  List<String> folderStack = ["root"];

  String currentFolderName = "";
  String id;

  // String folderParent;
  FirebaseFirestore customerFirestore;

  FileExplorarForTestSave({required this.customerFirestore, required this.id});

  int selectedFolderType = 0;

  @override
  _FileExplorarStateForSave createState() => _FileExplorarStateForSave();
}

class _FileExplorarStateForSave extends State<FileExplorarForTestSave> {
  TextEditingController _folderNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
          widget.customerFirestore.collection("folders").add({
            "name": _folderNameController.text,
            "parent": widget.folderStack.last,
            "created_at": new DateTime.now().millisecondsSinceEpoch
          });
          Navigator.pop(context);
          _folderNameController.clear();
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          color: Theme.of(context).primaryColor,
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
    return Scaffold(appBar: AppBar(title: Text("Save in a Folder"),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              onTap: () {
                widget.customerFirestore
                    .collection("folders")
                    .doc(widget.folderStack.last)
                    .collection("records")
                    .add({
                  "id": widget.id,
                  "created_at": new DateTime.now().millisecondsSinceEpoch
                });

                Future.delayed(Duration.zero, () {
                  CustomerHomePageLogic().connectedDevicesStream.dataReload(true);
                  returnHomePage(context);
                  // returnHomePage(context);
                  bool didCanceled = false;

                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (BuildContext context) =>
                  //             SaveSucessActivity()));
                });
              },
              subtitle: Text(widget.folderStack.last),
              title: Text("Save"),
              trailing: Icon(Icons.save),
            ),
            widget.folderStack.length > 1
                ? Container(
              child: Container(
                child: Center(
                  child: ListTile(
                    leading: InkWell(
                      onTap: () {
                        setState(() {
                          widget.folderStack.removeLast();
                        });
                      },
                      child: Icon(Icons.keyboard_arrow_left),
                    ),
                    title: Text(widget.currentFolderName),
                    trailing: InkWell(
                        onTap: () {
                          showDialog<void>(
                              context: context,
                              builder: (context) => dialog);
                        },
                        child: Icon(Icons.add)),
                  ),
                ),
              ),
            )
                : Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(Icons.sd_storage_outlined),
                    title: Text("Root"),
                    trailing: InkWell(
                        onTap: () {
                          showDialog<void>(
                              context: context,
                              builder: (context) => dialog);
                        },
                        child: Icon(Icons.add)),
                  ),
                )),
            (StreamBuilder<QuerySnapshot>(
                stream: widget.customerFirestore
                    .collection("folders")
                    .where("parent", isEqualTo: widget.folderStack.last)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData ) {
                    if (snapshot.data!.docs.length > 0)
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: snapshot.data == null
                              ? 0
                              : snapshot.data!.docs.length,
                          itemBuilder: (_, index) {
                            return ListTile(
                              onTap: () {
                                setState(() {
                                  widget.currentFolderName = snapshot.data!.docs[index]["name"];
                                  widget.folderStack
                                      .add(snapshot.data!.docs[index].id);
                                });
                              },
                              leading: Icon(Icons.folder_open),
                              title: Text(snapshot
                                  .data!.docs[index]["name"]
                                  .toString()),
                            );
                          });
                    else
                      return Container(
                        height: 0,
                        width: 0,
                      );
                  } else {
                    return Center(child: CircularProgressIndicator(color: Colors.redAccent,));
                  }
                })),
            StreamBuilder<QuerySnapshot>(
                stream: widget.customerFirestore
                    .collection("folders")
                    .doc(widget.folderStack.last)
                    .collection("records")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.hasData &&

                        snapshot.data!.docs.length > 0) {
                      return ListView.builder(
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (_, index) {
                            return ListTile(
                              onTap: () {
                                setState(() {
                                  widget.folderStack
                                      .add(snapshot.data!.docs[index].id);
                                });
                              },
                              leading: Icon(Icons.hardware),
                              title: Text(snapshot.data!.docs[index]["id"]
                                  .toString()),
                            );
                          });
                    }else{
                      return   Container(
                        height: 0,
                        width: 0,
                      );
                    }

                  } else {
                    return Center(child: CircularProgressIndicator(color: Colors.orange,));
                  }
                }),
          ],
        ),
      ),
    );
  }
}

class ImageClicker extends StatefulWidget {
  //void Function(dynamic) photoAddListener;
  String projetId;

  ImageClicker({required this.projetId});

  var camera;

  @override
  _ImageClickerState createState() => _ImageClickerState();
}

class _ImageClickerState extends State<ImageClicker> {
  bool isRecording = false;

  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  void initCamera() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.

    setState(() {
      widget.camera = cameras.first;

      _controller = CameraController(
        // Get a specific camera from the list of available cameras.
        widget.camera,
        // Define the resolution to use.
        ResolutionPreset.medium,
      );

      // Next, initialize the controller. This returns a Future.
      _initializeControllerFuture = _controller.initialize();
      CameraReadyStream.getInstance().dataReload(_controller);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // initCamera();
    initCamera2();
  }
  void initCamera2() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    setState(() {
      for (var i = 0; i < cameras.length; i++) {
        if (cameras[i].lensDirection == CameraLensDirection.back) {
          widget.camera = cameras[i];
        } else {}
      }

      _controller = CameraController(
        // Get a specific camera from the list of available cameras.
        widget.camera,
        // Define the resolution to use.
        ResolutionPreset.medium,
      );
      //_controller.lockCaptureOrientation(DeviceOrientation.landscapeLeft);

      // Next, initialize the controller. This returns a Future.
      _initializeControllerFuture = _controller.initialize();
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.camera?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the Future is complete, display the preview.
          CameraReadyStream().dataReload(_controller);
          return Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: CameraPreview(_controller),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 50,
                    child: Row(
                      children: [
                        Expanded(
                            child: Center(
                              child: isRecording
                                  ? Container()
                                  : InkWell(
                                  onTap: () async {
                                    try {
                                      // Ensure that the camera is initialized.
                                      // await _initializeControllerFuture;

                                      // Attempt to take a picture and get the file `image`
                                      // where it was saved.
                                      final image = await _controller.takePicture();
                                      //  File _image = File(image.path);

                                      //   var thumbnail =tt.copyResize(tt.decodeImage(_image.readAsBytesSync()), width: 400);

                                      //List<int> imageBytes =thumbnail.data.toList();
                                      //  print(imageBytes);

                                      //  String base64Image = base64Encode(_image.readAsBytesSync());

                                      try {
                                        //  String base64Image = base64Encode(
                                        //      _image.readAsBytesSync());
                                        //  List imageParts = [];
                                        //  //  int mid = (base64Image.length/2).ceil();
                                        //  //imageParts.add(base64Image.substring(0,mid));
                                        //  //imageParts.add(base64Image.substring(mid,base64Image.length));
                                        //
                                        //  int gap = (1000 * 1000);
                                        // // int iteration = (base64Image.length / gap).ceil();
                                        //  int iteration = (base64Image.length / gap).ceil();
                                        //  for (int i = 0; i < iteration; i++) {
                                        //    if (base64Image.length >
                                        //        (((i * gap) + gap)))
                                        //      imageParts.add(
                                        //          base64Image.substring(i * gap,
                                        //              (((i * gap) + gap))));
                                        //    else
                                        //      imageParts.add(
                                        //          base64Image.substring(i * gap,
                                        //              base64Image.length));
                                        //  }

                                        //push in add photo stream
                                        PhotoClickedStream.getInstance()
                                            .dataReload({
                                          "imagePath": image.path,
                                          // "image": imageParts,
                                          "time": new DateTime.now()
                                              .millisecondsSinceEpoch
                                        });

                                        CommonAttachmentAddedStream
                                            .getInstance()
                                            .dataReload({
                                          "thumb": image.path,
                                          "type": "i",
                                          // "data": imageParts,
                                          "time": new DateTime.now()
                                              .millisecondsSinceEpoch
                                        });

                                        // CommonAttachmentAddedStream.getInstance().dataReload({
                                        //   "thumb": image.path,
                                        //   "image": imageParts,
                                        //   "time": new DateTime.now().millisecondsSinceEpoch
                                        // });
                                        // setState(() {
                                        //   widget.photos.add({
                                        //     "imagePath": image.path,
                                        //     "image": imageParts,
                                        //     "time": new DateTime.now().millisecondsSinceEpoch
                                        //   });
                                        // });
                                        // widget.photoAddListener();

                                      } catch (e) {
                                        showMessage(context, "error occured");
                                        //showMessage(context, "error occured");
                                      }

                                      //  widget.photos.add({"imagePath":image.path,"image":base64Image,"time":new DateTime.now().millisecondsSinceEpoch});

                                      // If the picture was taken, display it on a new screen.

                                    } catch (e) {
                                      // If an error occurs, log the error to the console.
                                      print(e);
                                    }
                                  },
                                  child:
                                  Icon(Icons.camera, color: Colors.white)),
                            )),
                        Expanded(
                            child: isRecording
                                ? Center(
                              child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      isRecording = false;
                                    });
                                    //  _timer.cancel();
                                    try {

                                      stopAndSave(_controller);
                                    } catch (e) {
                                      print(e.toString());
                                    }
                                  },
                                  child: Icon(Icons.stop,
                                      color: Colors.white)),
                            )
                                : InkWell(
                                onTap: () {

                                  try {
                                    _controller.startVideoRecording();
                                    setState(() {
                                      isRecording = true;
                                    });
                                    Future.delayed(
                                        const Duration(seconds: 20), () {
                                      if (isRecording == true) {
                                        // _timer.cancel();
                                        stopAndSave(_controller);
                                      }
                                    });
                                  } catch (e) {
                                    print("ca2");
                                    print(e.toString());
                                  }
                                },
                                child: Icon(
                                  Icons.video_call_rounded,
                                  color: Colors.white,
                                ))),
                      ],
                    ),
                  )),
            ],
          );
        } else {
          // Otherwise, display a loading indicator.
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
  Future<firebase_storage.FirebaseStorage> initCustomerFireStorage(String projectID) async {
    FirebaseApp app;

    try {
      app = await Firebase.initializeApp(
          name: projectID,
          options: FirebaseOptions(
            appId: Platform.isAndroid
                ?Config().defaultAppIdAndroid
                : Config().defaultAppIdIOS,
            apiKey: Config().apiKey,
            //  storageBucket:"gs://"+projectID+".appspot.com/",
            // storageBucket:"staht-16a50.appspot.com",

            messagingSenderId: '',
            projectId: projectID,
          ));
      firebase_storage.FirebaseStorage storage=  firebase_storage.FirebaseStorage.instanceFor(app: app);

      return storage;
    } catch (e) {


      firebase_storage.FirebaseStorage storage=  firebase_storage.FirebaseStorage.instanceFor(app: Firebase.app(projectID));

      //FirebaseFirestore firestore = await FirebaseFirestore.instanceFor(app: app);
      return storage;
    }
  }
  void stopAndSave(CameraController cameraController) {
    cameraController.stopVideoRecording().then((value) async {
      var video = File(value.path);

      // File file = File(filePath);






      // try {
      //   print("push storage");
      //   // initCustomerFireStorage(widget.projetId)
      //
      //
      //
      //
      //
      //
      //     firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('uploads/file-to-upload.mp4');
      //
      //
      //     await  ref.putFile(video);
      //     String link = await ref.getDownloadURL();
      //     print("download link");
      //     print(link);
      //
      //
      //
      //   // initCustomerFireStorage(widget.projetId);
      //   // firebase_storage.FirebaseStorage.instanceFor()
      //   //
      //   //  initCustomerFireStorage(widget.projetId)
      //   //     .ref('uploads/file-to-upload.mp4')
      //   //     .putFile(video);
      // } on firebase_core.FirebaseException catch (e) {
      //   // e.g, e.code == 'canceled'
      //   print(e);
      //   print("storage ex");
      // }

      try {



        // String base64Image = base64Encode(video.readAsBytesSync());
        // List imageParts = [];
        //  int mid = (base64Image.length/2).ceil();
        //imageParts.add(base64Image.substring(0,mid));
        //imageParts.add(base64Image.substring(mid,base64Image.length));


        // int gap = (1000 * 1000);
        // int iteration = (base64Image.length / gap).ceil();
        // for (int i = 0; i < iteration; i++) {
        //   if (base64Image.length > (((i * gap) + gap)))
        //     imageParts
        //         .add(base64Image.substring(i * gap, (((i * gap) + gap))));
        //   else
        //     imageParts
        //         .add(base64Image.substring(i * gap, base64Image.length));
        // }
        //  final image = await cameraController.takePicture();

        // File _image = File(image.path);

        //var thumbnail_resized =tt.copyResize(tt.decodeImage(_image.readAsBytesSync()), width: 100);
        // thumbnail_resized.
        // var r = thumbnail_resized.getBytes(format: tt.Format.rgba);
        // var resa = thumbnail_resized.data;

        //List<int> imageBytes =thumbnail.data.toList();
        //  print(imageBytes);

        // String base64ImageThum = base64Encode(_image.readAsBytesSync());
        // String base64ImageThum = base64Encode(thumbnail_resized);
        // String base64ImageThum=   base64Encode(thumbnail_resized.data.toList());

        //  String base64ImageT = base64Encode(_image.readAsBytesSync());
        // List imagePartsT = [];
        //  int mid = (base64Image.length/2).ceil();
        //imageParts.add(base64Image.substring(0,mid));
        //imageParts.add(base64Image.substring(mid,base64Image.length));

        // int gapT = (1000 * 1000);
        // int iterationT = (base64ImageThum.length / gapT).ceil();
        // for (int i = 0; i < iterationT; i++) {
        //   if (base64ImageThum.length > (((i * gapT) + gapT)))
        //     imagePartsT
        //         .add(base64Image.substring(i * gapT, (((i * gapT) + gapT))));
        //   else
        //     imagePartsT.add(
        //         base64ImageThum.substring(i * gapT, base64ImageThum.length));
        // }

        VideoClickedStream.getInstance().dataReload({
          "videoPath": video.path,
          // "video": imageParts,
          "time": new DateTime.now().millisecondsSinceEpoch
        });

        CommonAttachmentAddedStream.getInstance().dataReload({
          // "thumb":image.path,
          "type": "v",
          "videoPath": video.path,
          "time": new DateTime.now().millisecondsSinceEpoch
        });

        // widget.photoAddListener();

      } catch (e) {
        showMessage(context, e.toString());
        //showMessage(context, "error occured");
      }
    });
  }
}

class SaveSucessActivity extends StatefulWidget {
  SaveSucessActivity({Key? key}) : super(key: key);

  @override
  _SaveSucessActivityState createState() => _SaveSucessActivityState();
}

class _SaveSucessActivityState extends State<SaveSucessActivity> {
  bool didCanceled = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 2000), () {
      if (true) {
        didCanceled = true;
        returnHomePage(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "Record has been saved Successfully",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor),
            ),
          ),
          Center(
            child: InkWell(
              onTap: () {
                didCanceled = true;
                returnHomePage(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Close",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MyTriangle extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.addPolygon([
      Offset(0, size.height),
      Offset(0, 0),
      Offset(size.width, size.height / 2)
    ], true);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class VideoPlay extends StatefulWidget {
  File file;
  VideoPlay({required this.file});
  @override
  _VideoPlayState createState() => _VideoPlayState();
}

class _VideoPlayState extends State<VideoPlay> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.file)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _controller.setVolume(0);
          _controller.play();
          _controller.setLooping(true);
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _controller.value.isInitialized
          ? VideoPlayer(_controller)
          : Container(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}