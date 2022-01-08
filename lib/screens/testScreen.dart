import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/Activities/TestPerformActivity/logics.dart';
import 'package:connect/Activities/TestPerformActivity/ui_components.dart';
import 'package:connect/models/Chartsample.dart';
import 'package:connect/services/Firestoredatabase.dart';
import 'package:connect/utils/featureSettings.dart';
import 'package:connect/widgets/graph_with_selecttor.dart';
import 'package:connect/widgets/lists_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_svg/svg.dart';
 import 'package:image_picker/image_picker.dart';
 import 'package:connect/components/appBarCustom.dart';
import 'package:connect/screens/testMapScreen.dart';
import 'package:connect/screens/testSelectFolderScreen.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/colorConst.dart';
import 'package:connect/utils/textConst.dart';
import 'package:connect/utils/textStyleConst.dart';
import 'package:connect/utils/themeManager.dart';
import 'package:screenshot/screenshot.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TestScreen extends StatefulWidget {
  //late BluetoothDevice device;
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

  List imageListNew;
  final loadData = "0";
  final loadUnitData;
  // final minuteData;
  final secondData;
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
  BluetoothDevice device;

  late CameraController controller;
  TestScreen(
      {Key? key,
        required  this.project,
        required  this.customerFirestore,
      required this.imageListNew,
      required this.targetLoad,
      required this.loadUnitData,
      required this.device,


      // required this.minuteData,
        required this.index2,required this.index6,required this.start,
      required this.secondData, })
      : super(key: key);

  @override
  _TestScreenState createState() => _TestScreenState();
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

class _TestScreenState extends State<TestScreen> {

  bool didValueCrossed_0_2 = false;
  bool didTimerStarted = false;
  bool didTimerStopped = false;
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




  int _start = 2;
  int _startNew = 4;
  bool? isSelected = false;
  Function? onPressed;
  int _counter = 30;
  GlobalKey<State> chartKey = GlobalKey<State>();
  bool _enableAnchor = false;
  ZoomMode? _zoomModeType = ZoomMode.x;
  bool? _isSelectForPhoto;
  ScrollController _scrollController = ScrollController();
  static const countdownDuration = Duration(minutes: 0);
  Duration duration = Duration();
  Timer? timer;

  bool countDown = true;

  XFile? imageFile;
  List<String> imageList = [];
  List newImageList = [];
  var camera;
  late CameraController _controller;
  Future<void>? _initializeControllerFuture;
  List<CameraDescription> cameras = [];
  bool _isRecording = false;

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
      _initializeControllerFuture = _controller.initialize();
    });
  }

  scanningCountDown() {
    _counter = 30;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_counter > 0) {
        setState(() {
          _counter--;
        });
      } else {
        _timer!.cancel();
      }
    });
  }

  startTimer1Page() {
    const oneSec = const Duration(seconds: 3);
    Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  startTimer2Page() {
    var oneSec = Duration(seconds: 2);
    Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_startNew < 1) {
            timer.cancel();
          } else {
            _startNew = _startNew - 1;
          }
        },
      ),
    );
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
  @override
  void initState() {

    setState(() {
      widget.hasSavedOnce == false;
      widget.data3 = [];
      print("timer and duration set for " + widget.durationForTest.toString());
      widget.start = widget.durationForTest;
      widget.duration = widget.durationForTest;
    });
   // startTimer1Page();

  //  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    super.initState();

    initCamera();

    TestPerformLogics().gauseValueStreamAsFloat.dataReload(0);
    listenAndActForTestStarted();
    listenforattachmentAdd();
   // listenCompleateTask();
    listenForTargetLoad();

   TestPerformLogics().gauseValueStreamAsFloat.dataReload(0);

   initDeviceReading();
  }
  void listenForTargetLoad() {
    int lastAdd = 0;
    TestPerformLogics().gauseValueStreamAsFloat.outData.listen((event)  {

      //do vibration
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

      //detect when to start reading data
      if(event>0.2 && didValueCrossed_0_2 == false && widget.shouldCollect == false){
        didValueCrossed_0_2 = true;
        widget.shouldCollect = true;
      }

      //detect when to stop test if load drops
      if (event < 0.2 && widget.startedTime == 0 && widget.onceStartedTimer == false && widget.shouldCollect == true) {
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
                          child: LineMultiColor(prefferedDecimalPlace: PrefferedDecimalPlaces,unit: widget.loadUnitData,
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
                             TestPerformLogics(). durationToString(widget.maxAt),
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
                              ?  TestPerformLogics(). durationToString((widget.startedTime))
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
                              ?  TestPerformLogics(). durationToString((widget.endedTime))
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
                              ?  TestPerformLogics(). durationToString((widget.failedAT))
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
          print(e);
         // showMessageAsBottomSheet(context, e.toString());
        }

        // AppFirestore(firestore: widget.customerFirestore,auth: FirebaseAuth.instance, projectId: widget.project).savePullTestRecord(loadMode: "kN",key: key,
        //   index2: widget.index2,
        //   index6: widget.index6,
        //   note:testNoteController.text,
        //   name: testNameController.text,
        //   textAddress: textAddress,
        //   maxVal: widget.maxVal,
        //   maxAt: widget.maxAt,
        //   startedTime:  widget.startedTime,
        //   startedTimeXVal: widget.startedTimeXVal,
        //   endedTime: widget.endedTime,
        //   testDuration: widget.testDuration,
        //   didPassed: widget.didPassed,
        //   failedAT:  widget.failedAT,
        //   lastTime: widget.lastTime,
        //   targetLoad: widget.targetLoad,
        //   durationForTest:  widget.durationForTest,
        //   data3:testData,
        //   startTime: startTime,
        //   currentLocation:currentLocation,
        //   allPHotos: widget.photos,
        //   allvid: videos,
        // );


      }
      //if the test has been finished withoout timer triggered
      //omitted && widget.data3.length > 0 && widget.startedTime>0

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
  @override
  void dispose() {
    super.dispose();
    camera?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;



    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            //-----------------------Test Screen Appbar--------------------------------------
            AppBarCustom(appbarTitle: TextConst.testAppbarText),

            //----------------------Body of screen------------------------------------
            Container(
              margin: EdgeInsets.only(left: width * 0.05, right: width * 0.05, top: height * 0.02),
              child: Column(
                children: [
                  chartDataView(),
                  lockedTestLoadAndTimeData(),
                  pickedImageOrVideoView(),

                StreamBuilder<double>(
                    stream: TestPerformLogics().gauseValueStreamAsFloat.outData,
                    builder: (c, snapshotGauseValue) {
                      if (snapshotGauseValue.hasData) {
                        //print("ok = "+snapshotGauseValue.data.toString());
                       // return Text(snapshotGauseValue.data.toString());
                        //
                        if (widget.startedTime>0 && widget.endedTime > 0) {
                          return  removeLoadOnHexDrive();
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
                          return applyPreLoad();
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

                          return  testRunningCounter();
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
                          return startTimerButtonView();
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
              /*    applyPreLoad(),

                  applyLoadOnHexDrive(),
                  startTimerButtonView(),
                  testRunningCounter(),
                  removeLoadOnHexDrive(),
                 removeLoadOnPrimary(),
                  testFinishView(),
                  */
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  //----------------------------------Test chart data view--------------------------------
   chartDataView() {
    //ble reading stream
    print("go list ");
    return    StreamBuilder<double>(
        stream: TestPerformLogics().gauseValueStreamAsFloat.outData,
        builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            if (widget.maxValForDisplay < snapshot.data!.toDouble()) {
              widget.maxValForDisplay = snapshot.data!.toDouble();
            }
            if (widget.onlyShow.length < 100) {widget.onlyShow.add(ChartSampleData(x: new DateTime.now(), y: snapshot.data!.toDouble(), color: 1));
            } else {
              //widget.onlyShow.removeAt(0);
              widget.onlyShow.add(ChartSampleData(x: DateTime.now(), y: snapshot.data!.toDouble(), color: 1));
            }
            // return Text("good");
            //  TestPerformUiComponents(context: context).readingsSegment(shouldCollect: widget.shouldCollect, data: snapshot.data!,start: widget.start);
            return Stack(
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
                    color: ThemeManager()
                        .getWhiteColor,
                  ),
                  height: height * 0.25,
                  child: Padding(
                    padding: const EdgeInsets.all(
                        8.0),
                    //Initialize the spark charts widget
                    child: TestPerformUiComponents()
                        .graphSegment(
                        onlyShow: widget.onlyShow,
                        maxValForDisplay: widget
                            .maxValForDisplay),),
                ),
                Positioned(
                  top: 10,
                  left: width * 0.68,
                  child: Row(
                    children: [

                      Text(snapshot.data!.toDouble().toString(),
                        style: interBold.copyWith(
                            color: ThemeManager()
                                .getOrangeGradientColor,
                            fontSize: height * 0.035),
                      ),
                      Text(
                        "kN",
                        style: interBold.copyWith(
                            color: ThemeManager()
                                .getYellowGradientColor,
                            fontSize: height * 0.025),
                      ),
                    ],
                  ),
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
            );});

    StreamBuilder<List<BluetoothDevice>>(
        stream: Stream.periodic(Duration(seconds: 1))
            .asyncMap((_) => FlutterBlue.instance.connectedDevices),
        initialData: [],
        builder: (c, snapshotConnectedDevices) {
          if(snapshotConnectedDevices.hasData && snapshotConnectedDevices.data!.length>0){
            return StreamBuilder<BluetoothDeviceState>(
                stream: snapshotConnectedDevices.data!.last.state,
                //initialData: BluetoothDeviceState.connecting,
                builder: (context, snapshot) {
                  if (snapshot.data == BluetoothDeviceState.connected) {

                    return  StreamBuilder<List<BluetoothService>>(
                      // Initialize FlutterFire:
                      //  future: Firebase.initializeApp(),
                        stream: snapshotConnectedDevices.data!.last.services,
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data != null ) {
                            Future<BluetoothCharacteristic?> findCharacter() {
                              BluetoothCharacteristic? cha;
                              for (int i = 0; i < snapshot.data!.length; i++) {
                                print(snapshot.data![i].uuid.toString());
                                for (int j = 0;
                                j < snapshot.data![i].characteristics.length;
                                j++) {
                                  print("h6");
                                  if ("f0001113-0451-4000-b000-000000000000" == snapshot.data![i].characteristics[j].uuid.toString()) {
                                    print("h7");
                                    cha = snapshot.data![i].characteristics[j];
                                    cha.setNotifyValue(true);
                                    print("character found");
                                    //return Future.value(cha);
                                    break;
                                  }
                                }
                              }
                              print("character returned");
                              return Future.value(cha);
                            }




                            return FutureBuilder<BluetoothCharacteristic?>(
                              // Initialize FlutterFire:
                              //  future: Firebase.initializeApp(),
                                future: findCharacter(),
                                builder: (context, snapshot) {
                                  if(snapshot.hasData) {
                                    return snapshot.data != null ? StreamBuilder<List<
                                        int>>(
                                        stream: snapshot.data!.value,
                                        builder: (BuildContext context, AsyncSnapshot<
                                            List<int>> snapshot) {
                                          if (snapshot.hasData) {
                                            print(snapshot.data);
                                            TestPerformLogics()
                                                .gauseValueStreamAsFloat.dataReload(
                                                double.parse(
                                                    convertFromStreamToString(
                                                        snapshot.data)));
                                            if (widget.maxValForDisplay <
                                                double.parse(
                                                    convertFromStreamToString(
                                                        snapshot.data))) {
                                              widget.maxValForDisplay =
                                                  double.parse(
                                                      convertFromStreamToString(
                                                          snapshot.data));
                                            }
                                            if (widget.onlyShow.length < 100) {
                                              widget.onlyShow.add(ChartSampleData(
                                                  x: new DateTime.now(),
                                                  y: double.parse(
                                                      convertFromStreamToString(
                                                          snapshot.data)), color: 1));
                                            } else {
                                              //widget.onlyShow.removeAt(0);
                                              widget.onlyShow.add(ChartSampleData(
                                                  x: DateTime.now(),
                                                  y: double.parse(
                                                      convertFromStreamToString(
                                                          snapshot.data)), color: 1));
                                            }
                                            // return Text("good");
                                            //  TestPerformUiComponents(context: context).readingsSegment(shouldCollect: widget.shouldCollect, data: snapshot.data!,start: widget.start);
                                            return Stack(
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
                                                    color: ThemeManager()
                                                        .getWhiteColor,
                                                  ),
                                                  height: height * 0.25,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(
                                                        8.0),
                                                    //Initialize the spark charts widget
                                                    child: TestPerformUiComponents()
                                                        .graphSegment(
                                                        onlyShow: widget.onlyShow,
                                                        maxValForDisplay: widget
                                                            .maxValForDisplay),),
                                                ),
                                                Positioned(
                                                  top: 10,
                                                  left: width * 0.68,
                                                  child: Row(
                                                    children: [

                                                      Text(
                                                        TestPerformLogics()
                                                            .convertwithDecimalplaces(
                                                            snapshot.data!, 1),
                                                        style: interBold.copyWith(
                                                            color: ThemeManager()
                                                                .getOrangeGradientColor,
                                                            fontSize: height * 0.035),
                                                      ),
                                                      Text(
                                                        "kN",
                                                        style: interBold.copyWith(
                                                            color: ThemeManager()
                                                                .getYellowGradientColor,
                                                            fontSize: height * 0.025),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                            return Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [

                                                //graph segment


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
                                        }) : Center(child: Text("Error Occured"),);
                                  }else{
                                    return CircularProgressIndicator(color: Colors.redAccent,);
                                  }

                                });





                          }
                          else {
                            return Container(
                                height: 100,
                                child: Center(
                                  child: InkWell(
                                      onTap: () {
                                        snapshotConnectedDevices.data!.last.connect(autoConnect: false);
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
                    snapshotConnectedDevices.data!.last.connect(autoConnect: false).then((value) {
                      snapshotConnectedDevices.data!.last.discoverServices();
                    });
                    return Container(
                        height: 300,
                        child: Center(
                          child: InkWell(
                              onTap: () {
                                snapshotConnectedDevices.data!.last.connect(autoConnect: false);
                              },
                              child: Card(
                                  color: Theme.of(context).primaryColor,
                                  child: Text(
                                    "Connect",
                                    style: TextStyle(color: Colors.white),
                                  ))),
                        ));
                  }
                });
          }else return Container(width: 0,height: 0,);
        });

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: 2,
                color: ThemeManager().getLightGrey5Color.withOpacity(.1),
              )
            ],
            color: ThemeManager().getWhiteColor,
          ),
          height: height * 0.25,
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              //Initialize the spark charts widget
              child: SfCartesianChart(
                  key: chartKey,
                  plotAreaBorderWidth: 0,
                  primaryXAxis: DateTimeAxis(
                      name: 'X-Axis',
                      majorGridLines: const MajorGridLines(width: 0)),
                  primaryYAxis: NumericAxis(
                      axisLine: const AxisLine(width: 0),
                      anchorRangeToVisiblePoints: _enableAnchor,
                      majorTickLines: const MajorTickLines(size: 0)),
                  series: getDefaultPanningSeries(),
                  zoomPanBehavior: ZoomPanBehavior(

                      /// To enable the pinch zooming as true.
                      enablePinching: true,
                      zoomMode: _zoomModeType!,
                      enablePanning: true,
                      enableMouseWheelZooming: true))),
        ),
        Positioned(
          left: width * 0.58,
          child: Row(
            children: [
              Text(
                "16.5 ",
                style: interBold.copyWith(
                    color: ThemeManager().getOrangeGradientColor,
                    fontSize: height * 0.035),
              ),
              Text(
                "kN",
                style: interBold.copyWith(
                    color: ThemeManager().getYellowGradientColor,
                    fontSize: height * 0.025),
              ),
            ],
          ),
        ),
      ],
    );
  }

  //-----------------Locked test Load and Time data-------------
  Widget lockedTestLoadAndTimeData() {
    return Container(
      margin: EdgeInsets.only(top: height * 0.02),
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
                  child: Text(
                    widget.targetLoad.toString(),
                    style: interBold.copyWith(
                        color: ThemeManager().getDarkGreyTextColor,
                        fontSize: width * 0.050),
                  ),
                ),
                Text(
                  " " + widget.loadUnitData,
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
                    widget.secondData,
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
    );
  }

  //------------------choose image----------------------
  Widget pickedImageOrVideoView() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return FutureBuilder(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final size = MediaQuery.of(context).size;
          return Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: height * 0.035),
                height: height * 0.19,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // return the widget to show the live preview of camera.
                    Container(
                        height: height * 0.19,
                        width: double.infinity,
                        child: ClipRect(
                            child: new OverflowBox(
                                maxWidth: double.infinity,
                                maxHeight: double.infinity,
                                alignment: Alignment.center,
                                child: new FittedBox(
                                    fit: BoxFit.cover,
                                    alignment: Alignment.center,
                                    child: new Container(
                                        width: size.width,
                                        height: size.height*0.7,
                                        child: new  CameraPreview(_controller)
                                    )
                                )
                            )
                        )),
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
                    GestureDetector(
                      onTap: () {
                        if (isSelected == false) {
                          _controller.takePicture().then((value) {
                            setState(() {
                              imageFile = value;
                              if (widget.imageListNew.length >= 5)
                                _scrollController.animateTo(width,
                                    duration: Duration(seconds: 2),
                                    curve: Curves.easeIn);
                            });
                            File media = File(value.path);
                            imageList.add(media.path);
                            widget.imageListNew.add(media.path);
                            newImageList.add(media);
                            log(imageList.toString());
                          });
                        } else {
                          if (_isRecording == false) {
                            _controller.startVideoRecording().then((value) {
                              setState(() {
                                _isRecording = true;
                              });
                            });
                            startTimer();
                          } else {
                            _controller.stopVideoRecording().then((value) {
                              setState(() {
                                imageFile = value;
                                _isRecording = false;
                                if (widget.imageListNew.length >= 5)
                                  _scrollController.animateTo(width,
                                      duration: Duration(seconds: 2),
                                      curve: Curves.easeIn);
                              });
                              File media = File(value.path);
                              imageList.add(media.path);
                              widget.imageListNew.add(media.path);
                              newImageList.add(media);
                              log(imageList.toString());
                              stopTimer();
                            });
                          }
                        }
                      },
                      child: _isRecording == true
                          ? Container(
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
                            )
                          : Icon(
                              Icons.circle_outlined,
                              color: ThemeManager().getWhiteColor,
                              size: height * .08,
                            ),
                    ),
                    Column(
                      children: [
                        // Container(
                        //   margin: EdgeInsets.only(
                        //       left: width * 0.65, top: height * 0.015),
                        //   child: FlutterSwitch(
                        //     activeColor: ThemeManager().getWhiteColor,
                        //     inactiveColor: ThemeManager().getWhiteColor,
                        //     width: width * 0.16,
                        //     height: height * 0.045,
                        //     toggleSize: 45.0,
                        //     value: isSelected!,
                        //     padding: 1.0,
                        //     activeIcon: Container(
                        //       padding: EdgeInsets.all(8),
                        //       decoration: BoxDecoration(
                        //           boxShadow: [
                        //             BoxShadow(
                        //               blurRadius: 5,
                        //               color: Colors.grey,
                        //             )
                        //           ],
                        //           color: ThemeManager().getWhiteColor,
                        //           shape: BoxShape.circle),
                        //       child: InkWell(
                        //         onTap: () {
                        //           setState(() {
                        //             _isSelectForPhoto = true;
                        //           });
                        //           if (_isSelectForPhoto == true) {
                        //             //_getFromVideo();
                        //             Navigator.of(context).pop();
                        //           }
                        //         },
                        //         child: Icon(
                        //           Icons.video_call,
                        //           color: ThemeManager().getDarkGreenColor,
                        //         ),
                        //       ),
                        //     ),
                        //     inactiveIcon: Container(
                        //       padding: EdgeInsets.all(8),
                        //       decoration: BoxDecoration(
                        //           boxShadow: [
                        //             BoxShadow(
                        //               blurRadius: 5,
                        //               color: Colors.grey,
                        //             )
                        //           ],
                        //           color: ThemeManager().getWhiteColor,
                        //           shape: BoxShape.circle),
                        //       child: Icon(
                        //         Icons.camera_alt_outlined,
                        //         color: ThemeManager().getDarkGreenColor,
                        //       ),
                        //     ),
                        //     onToggle: (val) {
                        //       setState(() {
                        //         isSelected = val;
                        //       });
                        //     },
                        //   ),
                        // )
                      ],
                    ),
                  ],
                ),
              ),
              Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          List.generate(widget.imageListNew.length, (index) {
                        return Container(
                          height: height * 0.07,
                          width: width * 0.18,
                          child: widget.imageListNew[index].endsWith(".jpg")
                              ? Image.file(
                                  File(widget.imageListNew[index]),
                                  fit: BoxFit.fill,
                                )
                              : VideoPlay(
                                  file: File(widget.imageListNew[index]),
                                ),
                        );
                      }),
                    ),
                  ),
                  widget.imageListNew.length >= 5
                      ? Positioned(
                          left: -width * .02,
                          right: -width * .02,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      color: ThemeManager().getWhiteColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              ThemeManager().getLightGrey1Color,
                                          spreadRadius: .25,
                                        )
                                      ]),
                                  padding: EdgeInsets.only(left: width * .012),
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
                                      color: ThemeManager().getWhiteColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              ThemeManager().getLightGrey1Color,
                                          spreadRadius: .25,
                                        )
                                      ]),
                                  padding: EdgeInsets.only(left: width * .004),
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
              )
            ],
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  //--------------------------------apply pre load view-----------------------------
  Widget applyPreLoad() {
    return Visibility(
     // visible: _start == 2 ? true : false,
      child: Container(
          margin: EdgeInsets.only(top: height * 0.04),
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
                    width: width * 0.6,
                    child: Text("Apply Pre-Load on Primary Piston to 0.2 kN",
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
                height: height * 0.12,
                width: width * 0.22,
                decoration: new BoxDecoration(
                    image: new DecorationImage(
                  image: new AssetImage("assets/images/testMachine1Image.png"),
                  fit: BoxFit.fill,
                )),
              )
            ],
          )),
    );
  }

  //--------------------------------apply load on hex drive view-----------------------------
  Widget applyLoadOnHexDrive() {
    return Visibility(
      visible: _start == 1 ? true : false,
      child: Container(
          margin: EdgeInsets.only(top: height * 0.04),
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
                    width: width * 0.6,
                    child: Text("Apply load on Hex Drive to target 60 kN",
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
                height: height * 0.12,
                width: width * 0.22,
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image:
                        new AssetImage("assets/images/testMachine2Image.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              )
            ],
          )),
    );
  }

  //--------------------------------start timer button-----------------------------
  Widget startTimerButtonView() {
    return Visibility(
     //visible: _start == 0 && _startNew == 4 ? true : false,
      child: GestureDetector(
        onTap: () {
          TestPerformLogics().testStartStopStream.dataReload(true);
          //scanningCountDown();
         // startTimer2Page();
        },
        child: Container(
          padding: EdgeInsets.only(left: width * 0.02, right: width * 0.02),
          margin: EdgeInsets.only(top: height * 0.02),
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
      ),
    );
  }

  //-------------------------------test running counter view-----------------------------
  Widget testRunningCounter() {
    return Visibility(
      visible: true,
     // visible: _start == 0 && _startNew == 3 ? true : false,
      child: Container(
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
                'Test Running... $_counter secs',
                style: interSemiBold.copyWith(
                    color: ThemeManager().getDarkGreenColor,
                    fontSize: width * 0.042),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //--------------------------------remove load on hex drive view-----------------------------
  Widget removeLoadOnHexDrive() {



    return Visibility(
     // visible: _start == 0 && _startNew == 2 ? true : false,
      child: Container(
          margin: EdgeInsets.only(top: height * 0.04),
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
                    width: width * 0.6,
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
                height: height * 0.12,
                width: width * 0.22,
                decoration: new BoxDecoration(
                    image: new DecorationImage(
                  image: new AssetImage("assets/images/testMachine2Image.png"),
                  fit: BoxFit.fill,
                )),
              )
            ],
          )),
    );
  }

  //--------------------------------remove load on primary view-----------------------------
  Widget removeLoadOnPrimary() {
    return Visibility(
      visible: _start == 0 && _startNew == 1 ? true : false,
      child: Container(
          margin: EdgeInsets.only(top: height * 0.04),
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
                    width: width * 0.6,
                    child: Text("Remove load on Primary",
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
                height: height * 0.12,
                width: width * 0.22,
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image:
                        new AssetImage("assets/images/testMachine1Image.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              )
            ],
          )),
    );
  }

  //--------------------------------test Finish view-----------------------------
  Widget testFinishView() {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //     context,
        //     PageTransition(
        //       duration: Duration(milliseconds: 995),
        //       curve: Curves.linear,
        //       type: PageTransitionType.bottomToTop,
        //       child: TestSelectFolderScreen(),
        //     ));
      },
      child: Visibility(
        visible: _start == 0 && _startNew == 0 ? true : false,
        child: Container(
            margin: EdgeInsets.only(top: height * 0.04),
            child: Row(
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
                  height: height * 0.065,
                  width: width * 0.85,
                  child: Text("Test Finished",
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
            )),
      ),
    );
  }

  //--------------------------------Chart data-----------------------------------
  List<AreaSeries<ChartSampleData, DateTime>> getDefaultPanningSeries() {
    final List<Color> color = <Color>[];
    color.add(Colors.teal[50]!);
    color.add(Colors.teal[200]!);
    color.add(Colors.teal);

    final List<double> stops = <double>[];
    stops.add(0.0);
    stops.add(0.4);
    stops.add(1.0);

    final LinearGradient gradientColors = LinearGradient(
        colors: color,
        stops: stops,
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter);
    return <AreaSeries<ChartSampleData, DateTime>>[
      AreaSeries<ChartSampleData, DateTime>(
          dataSource: getDateTimeData(),
          xValueMapper: (ChartSampleData sales, _) => sales.x as DateTime,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          gradient: gradientColors)
    ];
  }

  List<ChartSampleData> getDateTimeData() {
    final List<ChartSampleData> randomData = <ChartSampleData>[
      ChartSampleData(x: DateTime(1950, 3, 31), y: 80.7, color: 0),

    ];
    return randomData;
  }

  void reset() {
    if (countDown) {
      setState(() => duration = countdownDuration);
    } else {
      setState(() => duration = Duration());
    }
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  void addTime() {
    final addSeconds = countDown ? 1 : -1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      if (seconds < 0) {
        timer?.cancel();
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void stopTimer({bool resets = true}) {
    if (resets) {
      reset();
    }
    setState(() => timer?.cancel());
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

  void initDeviceReading() {
    widget.device.discoverServices().then((value) {
      print("s er list ");
      print(value.length);
      BluetoothCharacteristic? cha;
      for (int i = 0; i < value!.length; i++) {
        print(value![i].uuid.toString());
        for (int j = 0;
        j < value![i].characteristics.length;
        j++) {
          print("h6");
          if ("f0001113-0451-4000-b000-000000000000" == value![i].characteristics[j].uuid.toString()) {
            print("h7");
            cha = value![i].characteristics[j];
            cha.setNotifyValue(true);
            cha.value.listen((event) {
              print("getting");

              TestPerformLogics().gauseValueStreamAsFloat.dataReload(TestPerformLogics().getNumber(double.parse(convertFromStreamToString(event)),precision: 1));
                  print(event);
            });


            //return Future.value(cha);
            break;
          }
        }
      }

    });
  }
}
String convertFromStreamToString(List<int>? data) {
  String returnValue = "";
  if (data != null){
    final result = data.map((b) => '${b.toRadixString(16).padLeft(2, '0')}');
    //print('bytes: ${result}');
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

double getNumber(double input, {required int precision }) =>
    double.parse('$input'.substring(0, '$input'.indexOf('.') + precision + 1));