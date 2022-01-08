import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/Appabr/appbar_widget.dart';
import 'package:connect/components/appBarCustom.dart';
import 'package:connect/components/buttonView.dart';
import 'package:connect/screens/home.dart';
import 'package:connect/screens/popup/deleteTestPopUp.dart';
import 'package:connect/screens/popup/editUpdateTitle.dart';
import 'package:connect/screens/popup/updateNoteDialog.dart';
import 'package:connect/screens/popup/updatetitleDialog.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/colorConst.dart';
import 'package:connect/utils/featureSettings.dart';
import 'package:connect/utils/textConst.dart';
import 'package:connect/utils/textStyleConst.dart';
import 'package:connect/utils/themeManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:connect/Activities/videoPlayerActivity.dart';
import 'package:connect/calculator.dart';
import 'package:connect/labels/appLabels.dart';
import 'package:connect/localization/language/languages.dart';
import 'package:connect/services/Firestoredatabase.dart';
import 'package:connect/services/restApi.dart';
import 'package:connect/streams/buttonStreams.dart';
import 'package:connect/widgets/graph_with_selecttor.dart';
import 'package:connect/widgets/lists_widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';

import 'CameraToggleSwitch/cameraToggle.dart';
import 'CustomBottomNavigationBar/appBottomNavigationBar.dart';
import 'CustomerUserHome/HomePager/appbar.dart';
import 'CustomerUserHome/logics.dart';
import 'TestPerformActivity/ui_components.dart';

class RecordViewStatefullActivity extends StatefulWidget {
  CameraController controller;
  FirebaseFirestore customerFirestore;
  String id;
  String width;
  String customerId = "";
  bool isRecording = false;
  var snapshotHistoryItem;
  int duration = 0;
  Locale locale;
  late File _image;
  int selectedTab;

  RecordViewStatefullActivity(
      {required this.width,
        required this.customerFirestore,
        required this.snapshotHistoryItem,
        required  this.id,
        required  this.locale,
        required  this.selectedTab,
        required this.controller});

  @override
  _RecordViewStatefullActivityState createState() =>
      _RecordViewStatefullActivityState();
}

class _RecordViewStatefullActivityState
    extends State<RecordViewStatefullActivity> {
  late Timer _timer;
  dynamic lastInfo;
  late Future<void> _initializeControllerFuture;
  var camera;
  late CameraController _controller;
  double zoom = 1.0;
  bool isRecordingSomething = false;
  Timer? timer;
  List<Widget> allItems = [];
  Duration duration = Duration();
  static const countdownDuration = Duration(minutes: 0);
  bool isSelected = false;
  bool _isSelectForPhoto = true;
  bool _isRecording = false;
  double maxZoom = 0;
  double minZoom = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initTitleCheckListener();
    initCamera();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
    listenCamerStatus();
    TimerUpdateStream.getInstance().dataReload(-1);
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
  @override
  Widget build(BuildContext context) {
    final scaffoldState = GlobalKey<ScaffoldState>();
    bool newAppabr = true;

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    CustomerHomePageLogic().tabChangedStream.dataReload(widget.selectedTab);
    double screenWidth = MediaQuery.of(context).size.width;
    var bottomNav = Wrap(
      children: [
        Container(
          //margin: EdgeInsets.only(top: height*0.008),
          height: height*0.001,
          width: double.infinity,
          color: ThemeManager().getBlackColor.withOpacity(.15),
        ),
        Container(color: Colors.white,height:  (height * 0.075)- height*0.001,
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
                      color:widget.selectedTab == 0? ThemeManager().getDarkGreenColor:ThemeManager().getDarkGrey3Color,
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
                      color: widget.selectedTab == 1? ThemeManager().getDarkGreenColor:ThemeManager().getDarkGrey3Color,
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
                      color: widget.selectedTab == 2? ThemeManager().getDarkGreenColor:ThemeManager().getDarkGrey3Color,
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
                      color: widget.selectedTab == 3? ThemeManager().getDarkGreenColor:ThemeManager().getDarkGrey3Color,
                      width: screenWidth * 0.028,
                      height: screenWidth * 0.06,
                    )),),
              )),
            ],),
          ),
        ),
      ],
    );
    String getUnit(dynamic dataToShow) {
      try{
        return  dataToShow["loadMode"]!=null?dataToShow["loadMode"]:"kN";
      }catch(e){
        return "kN";

      }

    }
    //AppTitleAppbarStream.getInstance().dataReload( widget.snapshotHistoryItem["name"]);
    return SafeArea(child: Scaffold(
      backgroundColor: ThemeManager().getWhiteColor,
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
          Padding(
            padding:  EdgeInsets.only(bottom: (MediaQuery.of(context).size.height * 0.075) ),
            child: Scaffold(
              key: scaffoldState,
//               appBar:newAppabr?PreferredSize(
//                 preferredSize: Size(0, kToolbarHeight),
//                 child: AppBarCustom(appbarTitle: widget.snapshotHistoryItem["name"]),
//               ): AppBar(
//                 actions: [
//                   /*
//             StreamBuilder<int>(
//                 stream: TimerUpdateStream.getInstance().outData,
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData &&
//                       snapshot.data != null &&
//                       snapshot.data != -1) {
//                     return InkWell(
//                       onTap: () {
//                         TimerUpdateStream.getInstance().dataReload(-1);
//                         _timer.cancel();
//                         stopAndSave();
//                         // TimerUpdateStream.getInstance().dataReload()
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.all(10.0),
//                         child: Icon(Icons.stop),
//                       ),
//                     );
//                   } else {
//                     return InkWell(
//                       onTap: () {
//                         const oneSec = const Duration(seconds: 1);
//                         _timer = new Timer.periodic(
//                           oneSec,
//                           (Timer timer) {
//                             widget.duration = 1 + widget.duration;
//                             TimerUpdateStream.getInstance()
//                                 .dataReload(widget.duration);
//                             // setState(() {
//                             //   widget.duration = 1+ widget.duration;
//                             // });
//                           },
//                         );
//
//                         widget.controller.startVideoRecording();
//
//                         Future.delayed(const Duration(seconds: 20), () {
//                           _timer.cancel();
//                           stopAndSave();
//                         });
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.all(10.0),
//                         child: Icon(Icons.video_call_rounded),
//                       ),
//                     );
//                   }
//                 }),
//             */
//
//                   InkWell(
//                     onTap: () async {
//                       showModalBottomSheet(
//                           context: context,
//                           builder: (builder) {
//                             return Stack(
//                               children: [
//                                 Align(
//                                   alignment: Alignment.center,
//                                   child: Container(
//                                     height: 600,
//                                     width: MediaQuery.of(context).size.width,
//                                     color: Colors.black,
//                                     child: CameraPreview(widget.controller),
//                                   ),
//                                 ),
//                                 Align(
//                                   alignment: Alignment.bottomCenter,
//                                   child: Container(
//                                     height: 100,
//                                     width: MediaQuery.of(context).size.width,
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                       children: [
//                                         Expanded(
//                                             child: InkWell(
//                                               onTap: () {
//                                                 Navigator.of(context).pop();
//                                               },
//                                               child: Center(
//                                                 child: Padding(
//                                                   padding: const EdgeInsets.all(8.0),
//                                                   child: StreamBuilder<int>(
//                                                       stream:
//                                                       TimerUpdateStream.getInstance()
//                                                           .outData,
//                                                       builder: (context, snapshot) {
//                                                         print("Stream output for cam  " +
//                                                             snapshot.data.toString());
//                                                         if (snapshot.hasData &&
//                                                             snapshot.data != null &&
//                                                             snapshot.data != -1) {
//                                                           return InkWell(
//                                                             onTap: () {
//                                                               TimerUpdateStream
//                                                                   .getInstance()
//                                                                   .dataReload(-1);
//                                                               _timer.cancel();
//
//                                                               stopAndSave();
//                                                               // TimerUpdateStream.getInstance().dataReload()
//                                                             },
//                                                             child: Padding(
//                                                               padding: const EdgeInsets.all(
//                                                                   10.0),
//                                                               child: Icon(
//                                                                 Icons.stop,
//                                                                 color: Colors.white,
//                                                                 size: 50,
//                                                               ),
//                                                             ),
//                                                           );
//                                                         } else {
//                                                           return InkWell(
//                                                             onTap: () {
//                                                               widget.duration = 0;
//
//                                                               const oneSec = const Duration(
//                                                                   seconds: 1);
//                                                               _timer = new Timer.periodic(
//                                                                 oneSec,
//                                                                     (Timer timer) {
//                                                                   widget.duration =
//                                                                       1 + widget.duration;
//                                                                   TimerUpdateStream
//                                                                       .getInstance()
//                                                                       .dataReload(
//                                                                       widget.duration);
//                                                                   // setState(() {
//                                                                   //   widget.duration = 1+ widget.duration;
//                                                                   // });
//                                                                 },
//                                                               );
//
//                                                               widget.controller
//                                                                   .startVideoRecording();
//                                                               isRecordingSomething = true;
//
//                                                               // Future.delayed(const Duration(seconds: 20), () {
//                                                               //   _timer.cancel();
//                                                               //   stopAndSave();
//                                                               // });
//                                                             },
//                                                             child: Padding(
//                                                               padding: const EdgeInsets.all(
//                                                                   10.0),
//                                                               child: Icon(
//                                                                 Icons.video_call_rounded,
//                                                                 color: Colors.white,
//                                                                 size: 50,
//                                                               ),
//                                                             ),
//                                                           );
//                                                         }
//                                                       }),
//                                                 ),
//                                               ),
//                                             )),
//
//                                         /*
//                                   Expanded(
//                                     child: isRecordingSomething? InkWell(
//                                       onTap: () {
//                                         TimerUpdateStream.getInstance().dataReload(-1);
//                                         _timer.cancel();
//
//                                         stopAndSave();
//                                         // TimerUpdateStream.getInstance().dataReload()
//                                       },
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(10.0),
//                                         child: Icon(Icons.stop,color: Colors.white,size: 50,),
//                                       ),
//                                     ):InkWell(
//                                       onTap: () {
//
//
//                                           const oneSec = const Duration(seconds: 1);
//                                           _timer = new Timer.periodic(
//                                             oneSec,
//                                                 (Timer timer) {
//                                               widget.duration = 1 + widget.duration;
//                                               TimerUpdateStream.getInstance().dataReload(widget.duration);
//                                               // setState(() {
//                                               //   widget.duration = 1+ widget.duration;
//                                               // });
//                                             },
//                                           );
//
//
//
//                                           widget.controller.startVideoRecording();
//                                           isRecordingSomething = true ;
//
//                                           Future.delayed(const Duration(seconds: 20), () {
//                                             _timer.cancel();
//                                             stopAndSave();
//                                           });
//
//
//
//
//                                       },
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(10.0),
//                                         child: Icon(Icons.video_call_rounded,color: Colors.white,size: 50,),
//                                       ),
//                                     ),
//                                   ),
//
//                                    */
//                                         Expanded(
//                                             child: InkWell(
//                                               onTap: () async {
//                                                 try {
//                                                   // Ensure that the camera is initialized.
//                                                   //  await _initializeControllerFuture;
//
//                                                   // Attempt to take a picture and get the file `image`
//                                                   // where it was saved.
//                                                   final image =
//                                                   await widget.controller.takePicture();
//                                                   widget._image = File(image.path);
//
//                                                   //   var thumbnail =tt.copyResize(tt.decodeImage(_image.readAsBytesSync()), width: 400);
//
//                                                   //List<int> imageBytes =thumbnail.data.toList();
//                                                   //  print(imageBytes);
//
//                                                   String base64Image = base64Encode(
//                                                       widget._image.readAsBytesSync());
//
//                                                   try {
//                                                     // String base64Image = base64Encode(widget._image.readAsBytesSync());
//                                                     //List imageParts = [];
//                                                     //  int mid = (base64Image.length/2).ceil();
//                                                     //imageParts.add(base64Image.substring(0,mid));
//                                                     //imageParts.add(base64Image.substring(mid,base64Image.length));
//                                                     // if (true) {
//                                                     //   int gap = (1000 * 1000);
//                                                     //   int iteration =
//                                                     //   (base64Image.length / gap).ceil();
//                                                     //   for (int i = 0; i < iteration; i++) {
//                                                     //     if (base64Image.length >
//                                                     //         (((i * gap) + gap)))
//                                                     //       imageParts.add(
//                                                     //           base64Image.substring(i * gap,
//                                                     //               (((i * gap) + gap))));
//                                                     //     else
//                                                     //       imageParts.add(
//                                                     //           base64Image.substring(i * gap,
//                                                     //               base64Image.length));
//                                                     //   }
//                                                     // } else {
//                                                     //   imageParts.add(base64Image);
//                                                     // }
//
//                                                     //uploadPhotos
//                                                     AppFirestore(firestore:  widget.customerFirestore, projectId: '', auth: FirebaseAuth.instance). uploadPhotos(
//                                                       widget.id,
//                                                       [
//                                                         {
//                                                           "imagePath": image.path,
//                                                           //"image": imageParts,
//                                                           "time": new DateTime.now()
//                                                               .millisecondsSinceEpoch
//                                                         }
//                                                       ],
//                                                     )
//                                                         .then((value) {});
//                                                     //upload now
//                                                     //   widget.photos.add({"imagePath":image.path,"image":imageParts,"time":new DateTime.now().millisecondsSinceEpoch});
//                                                   } catch (e) {
//                                                     //  showMessage(context, "error occured");
//                                                   }
//
//                                                   //  widget.photos.add({"imagePath":image.path,"image":base64Image,"time":new DateTime.now().millisecondsSinceEpoch});
//
//                                                   // If the picture was taken, display it on a new screen.
//
//                                                 } catch (e) {
//                                                   // If an error occurs, log the error to the console.
//                                                   print(e);
//                                                 }
//                                               },
//                                               child: Center(
//                                                 child: Padding(
//                                                   padding: const EdgeInsets.all(8.0),
//                                                   child: Icon(
//                                                     Icons.camera,
//                                                     color: Colors.white,
//                                                     size: 50,
//                                                   ),
//                                                 ),
//                                               ),
//                                             )),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 Align(
//                                   alignment: Alignment.topRight,
//                                   child: InkWell(
//                                     onTap: () {
//                                       Navigator.of(context).pop();
//                                     },
//                                     child: Container(
//                                       height: 50,
//                                       width: 50,
//                                       child: Center(
//                                         child: Icon(
//                                           Icons.close,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             );
//                             return new Wrap(
//                               children: [
//                                 Container(
//                                   height: 200,
//                                   width: MediaQuery.of(context).size.width,
//                                   color: Colors.black,
//                                 ),
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                         child: InkWell(
//                                           onTap: () {
//                                             Navigator.of(context).pop();
//                                           },
//                                           child: Center(
//                                             child: Padding(
//                                               padding: const EdgeInsets.all(8.0),
//                                               child: Icon(
//                                                 Icons.fiber_manual_record_rounded,
//                                                 color: Colors.redAccent,
//                                               ),
//                                             ),
//                                           ),
//                                         )),
//                                     Expanded(
//                                         child: InkWell(
//                                           onTap: () {
//                                             Navigator.of(context).pop();
//                                           },
//                                           child: Center(
//                                             child: Padding(
//                                               padding: const EdgeInsets.all(8.0),
//                                               child: Icon(
//                                                 Icons.camera,
//                                                 color: Colors.redAccent,
//                                               ),
//                                             ),
//                                           ),
//                                         )),
//                                   ],
//                                 ),
//                               ],
//                             );
//                           });
//
//                       /*  try {
//                   // Ensure that the camera is initialized.
//                 //  await _initializeControllerFuture;
//
//                   // Attempt to take a picture and get the file `image`
//                   // where it was saved.
//                   final image = await  widget.controller.takePicture();
//                   widget. _image = File(image.path);
//
//
//
//                   //   var thumbnail =tt.copyResize(tt.decodeImage(_image.readAsBytesSync()), width: 400);
//
//                   //List<int> imageBytes =thumbnail.data.toList();
//                   //  print(imageBytes);
//
//
//                   String base64Image = base64Encode(widget._image.readAsBytesSync());
//
//                   try{
//                     String base64Image = base64Encode(widget._image.readAsBytesSync());
//                     List imageParts = [];
//                     //  int mid = (base64Image.length/2).ceil();
//                     //imageParts.add(base64Image.substring(0,mid));
//                     //imageParts.add(base64Image.substring(mid,base64Image.length));
//                     if(true){
//                       int  gap  = (1000*1000);
//                       int iteration  = (base64Image.length/gap).ceil();
//                       for(int i = 0 ; i < iteration; i ++){
//                         if(base64Image.length>(((i*gap)+gap)))
//                           imageParts.add(base64Image.substring(i*gap,(((i*gap)+gap))));
//                         else   imageParts.add(base64Image.substring(i*gap,base64Image.length));
//                       }
//                     }else{
//                       imageParts.add(base64Image);
//                     }
//
//                     uploadPhotos(widget.id ,[{"imagePath":image.path,"image":imageParts,"time":new DateTime.now().millisecondsSinceEpoch}],widget.customerFirestore).then((value) {
//
//
//                     });
//                     //upload now
//                     //   widget.photos.add({"imagePath":image.path,"image":imageParts,"time":new DateTime.now().millisecondsSinceEpoch});
//                   }catch(e){
//                     //  showMessage(context, "error occured");
//                   }
//
//
//
//
//
//
//                   //  widget.photos.add({"imagePath":image.path,"image":base64Image,"time":new DateTime.now().millisecondsSinceEpoch});
//
//                   // If the picture was taken, display it on a new screen.
//
//                 } catch (e) {
//                   // If an error occurs, log the error to the console.
//                   print(e);
//                 }
//
//                 */
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: Icon(Icons.camera),
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () {
//                       TextEditingController controller;
//                       controller = new TextEditingController(
//                           text: widget.snapshotHistoryItem["name"]);
//                       if (lastInfo != null) {
//                         controller =
//                         new TextEditingController(text: lastInfo.get("name"));
//                       }
//
//                       Navigator.of(context).push(new MaterialPageRoute<Null>(
//                           builder: (BuildContext context) {
//                             return Scaffold(
//                               appBar: AppBar(
//                                 title: Text("Update"),
//                               ),
//                               body: Container(
//                                 decoration: BoxDecoration(
//                                   color: Color.fromARGB(255, 247, 247, 247),
//                                   borderRadius: BorderRadius.only(
//                                       topLeft: Radius.circular(10.0),
//                                       topRight: Radius.circular(10.0)),
//                                 ),
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(15.0),
//                                   child: Wrap(
//                                     children: [
//                                       Text(
//                                         "Update Title",
//                                         style: TextStyle(
//                                             fontSize: 20, fontWeight: FontWeight.bold),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: TextFormField(
//                                           controller: controller,
//                                           autofocus: true,
//                                           decoration: InputDecoration(
//                                             labelText: 'Title',
//                                             border: OutlineInputBorder(),
//                                           ),
//                                         ),
//                                       ),
//                                       InkWell(
//                                         onTap: () {
//                                           widget.customerFirestore
//                                               .collection("pulltest")
//                                               .doc(widget.id)
//                                               .update({"name": controller.text}).then(
//                                                   (value) {
//                                                 Navigator.pop(context);
//                                               });
//                                         },
//                                         child: Card(
//                                           color: Theme.of(context).primaryColor,
//                                           child: Center(
//                                               child: Padding(
//                                                 padding: const EdgeInsets.all(10.0),
//                                                 child: Text(
//                                                   "Submit",
//                                                   style: TextStyle(
//                                                       color: Colors.white,
//                                                       fontWeight: FontWeight.bold),
//                                                 ),
//                                               )),
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                           fullscreenDialog: true));
//
// /*
//                 showModalBottomSheet(
//                     context: context,
//                     builder: (builder) {
//                       return new Container(
//                         decoration: BoxDecoration(
//                           color: Color.fromARGB(255, 247, 247, 247),
//                           borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(10.0),
//                               topRight: Radius.circular(10.0)),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(15.0),
//                           child: Wrap(
//                             children: [
//                               Text(
//                                 "Update Title",
//                                 style: TextStyle(
//                                     fontSize: 20, fontWeight: FontWeight.bold),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: TextFormField(
//                                   controller: controller,
//                                   //initialValue:  snapshotHistoryItem["note"],
//                                 ),
//                               ),
//                               InkWell(
//                                 onTap: () {
//                                   widget.customerFirestore
//                                       .collection("pulltest")
//                                       .doc(widget.id)
//                                       .update({"name": controller.text}).then(
//                                           (value) {
//                                     Navigator.pop(context);
//                                   });
//                                 },
//                                 child: Card(
//                                   color: Theme.of(context).primaryColor,
//                                   child: Center(
//                                       child: Padding(
//                                     padding: const EdgeInsets.all(10.0),
//                                     child: Text(
//                                       "Submit",
//                                       style: TextStyle(
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                   )),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       );
//                     });
//                 */
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: Icon(Icons.edit),
//                     ),
//                   ),
//                   //share with button is disabled
//                   // InkWell(
//                   //   onTap: () {
//                   //     TextEditingController controller = new TextEditingController(
//                   //         text: widget.snapshotHistoryItem["name"]);
//                   //     showModalBottomSheet(
//                   //         context: context,
//                   //         builder: (builder) {
//                   //           return new Container(
//                   //             decoration: BoxDecoration(
//                   //               color: Color.fromARGB(255, 247, 247, 247),
//                   //               borderRadius: BorderRadius.only(
//                   //                   topLeft: Radius.circular(10.0),
//                   //                   topRight: Radius.circular(10.0)),
//                   //             ),
//                   //             child: Padding(
//                   //               padding: const EdgeInsets.all(10.0),
//                   //               child: Wrap(
//                   //                 children: [
//                   //                   Container(
//                   //                       width: MediaQuery.of(context).size.width,
//                   //                       child: Text(
//                   //                         "Share with",
//                   //                         style: TextStyle(
//                   //                             fontSize: 20,
//                   //                             fontWeight: FontWeight.bold),
//                   //                       )),
//                   //                   Container(
//                   //                     width: MediaQuery.of(context).size.width,
//                   //                     child: customers_users_list(
//                   //                         auth: FirebaseAuth.instance,
//                   //                         testID: widget.id,
//                   //                         firestore: widget.customerFirestore,
//                   //                         customerId: widget.customerId),
//                   //                   ),
//                   //                   InkWell(
//                   //                     onTap: () {
//                   //                       Navigator.pop(context);
//                   //                     },
//                   //                     child: Card(
//                   //                       color: Theme.of(context).primaryColor,
//                   //                       child: Center(
//                   //                           child: Padding(
//                   //                             padding: const EdgeInsets.all(10.0),
//                   //                             child: Text(
//                   //                               "Close",
//                   //                               style: TextStyle(
//                   //                                   color: Colors.white,
//                   //                                   fontWeight: FontWeight.bold),
//                   //                             ),
//                   //                           )),
//                   //                     ),
//                   //                   )
//                   //                 ],
//                   //               ),
//                   //             ),
//                   //           );
//                   //         });
//                   //   },
//                   //   child: Padding(
//                   //     padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
//                   //     child: Icon(Icons.share),
//                   //   ),
//                   // ),
//                   InkWell(
//                     onTap: () {
//                       showModalBottomSheet(
//                           context: context,
//                           builder: (builder) {
//                             return new Wrap(
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text(
//                                     "Do you want to delete this record?",
//                                     style: TextStyle(
//                                         fontSize: 20,
//                                         color: Theme.of(context).primaryColor),
//                                   ),
//                                 ),
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                         child: InkWell(
//                                           onTap: () {
//                                             Navigator.of(context).pop();
//                                           },
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Card(
//                                               elevation: 8,
//                                               color: Colors.grey,
//                                               child: Center(
//                                                   child: Padding(
//                                                     padding: const EdgeInsets.all(15.0),
//                                                     child: Text(
//                                                       "Cancel",
//                                                       style: TextStyle(
//                                                           color: Colors.white,
//                                                           fontWeight: FontWeight.bold),
//                                                     ),
//                                                   )),
//                                             ),
//                                           ),
//                                         )),
//                                     Expanded(
//                                         child: InkWell(
//                                           onTap: () async{
//                                             await AppFirestore(projectId: '',auth:FirebaseAuth.instance,firestore:widget.customerFirestore ).deletetest(id: widget.id);
//                                             Navigator.of(context).pop();
//                                             Navigator.of(context).pop();
//
//
//
//                                           },
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Card(
//                                               elevation: 8,
//                                               color: Theme.of(context).primaryColor,
//                                               child: Center(
//                                                   child: Padding(
//                                                     padding: const EdgeInsets.all(15.0),
//                                                     child: Text(
//                                                       "Delete",
//                                                       style: TextStyle(
//                                                           color: Colors.white,
//                                                           fontWeight: FontWeight.bold),
//                                                     ),
//                                                   )),
//                                             ),
//                                           ),
//                                         )),
//                                   ],
//                                 ),
//                               ],
//                             );
//                           });
//
//                       showAlertDialog(BuildContext context) {
//                         // set up the buttons
//                         Widget cancelButton = FlatButton(
//                           child: Text("No"),
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                         );
//                         Widget continueButton = FlatButton(
//                           child: Text("Yes"),
//                           onPressed: () {
//                             widget.customerFirestore
//                                 .collection("pulltest")
//                                 .doc(widget.id)
//                                 .delete()
//                                 .then((value) {
//                               print("deleted " + widget.id);
//                               Navigator.of(context).pop();
//                               Navigator.of(context).pop();
//                             });
//                           },
//                         );
//
//                         // set up the AlertDialog
//                         AlertDialog alert = AlertDialog(
//                           title: Text("Delete Record"),
//                           content: Text("Would you like to delete the record?"),
//                           actions: [
//                             cancelButton,
//                             continueButton,
//                           ],
//                         );
//
//                         // show the dialog
//                         showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return alert;
//                           },
//                         );
//                       }
//
//                       //   showAlertDialog(context);
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
//                       child: Icon(Icons.delete),
//                     ),
//                   ),
//                 ],
//                 title: StreamBuilder<DocumentSnapshot>(
//                     stream: widget.customerFirestore
//                         .collection("pulltest")
//                         .doc(widget.id)
//                         .snapshots(),
//                     builder: (BuildContext context,
//                         AsyncSnapshot<DocumentSnapshot> snapshotattachment) {
//                       if (snapshotattachment.hasData) {
//                         lastInfo = snapshotattachment.data;
//                         // WidgetsBinding.instance.addPostFrameCallback((_){
//                         //   setState(() {
//                         //     lastInfo = snapshotattachment.data;
//                         //   });
//                         // });
//
//                         return Text(snapshotattachment.data!
//                             .get("name")
//                             .toString()
//                             .replaceAll("auto_generated", ""));
//                       } else {
//                         return Text("Please wait");
//                       }
//                     }),
//                 // title: Text(widget.snapshotHistoryItem["name"]),
//               ),
              body: StreamBuilder<DocumentSnapshot>(
                  stream: Api(firestore:widget.customerFirestore, ).fetchOnerecordWithFirestore(
                      firestore: widget.customerFirestore, id: widget.id),
                  builder: (c, snapshotRecord) {
                    if (snapshotRecord.hasData) {

                      Map<String, dynamic> dataJson = snapshotRecord.data!.data() as Map<String, dynamic>;
                      lastInfo = snapshotRecord.data!;
                      // width = "400";
                      String mapUri = "https://maps.googleapis.com/maps/api/staticmap?center=" +
                          widget.snapshotHistoryItem["location"]["lat"]
                              .toString() +
                          "," +
                          widget.snapshotHistoryItem["location"]["long"]
                              .toString() +
                          "&zoom=16&size=" +
                          widget.width +
                          "x200&markers=" +
                          widget.snapshotHistoryItem["location"]["lat"]
                              .toString() +
                          "," +
                          widget.snapshotHistoryItem["location"]["long"]
                              .toString() +
                          "&key=AIzaSyBQH9dnXV9oUn0K8MMge3MlbhBgbLKzQ10";

                      print(mapUri);
                      TextEditingController controllenName = new TextEditingController(text:snapshotRecord.data!.get("name") );
                      TextEditingController controlleNote = new TextEditingController(text:snapshotRecord.data!.get("note") );
                      String title = snapshotRecord.data!.get("name");
                      String note = snapshotRecord.data!.get("note");

                      TitleUpdateStream.getInstance().outData.listen((event) {
                        if(event!=null){
                          title =  event;
                        }
                      });
                      //margin: EdgeInsets.only(top: height * 0.025, left: width * 0.04, right: width * 0.04),
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            ApplicationAppbar().  getAppbar(title: title),
                            SingleChildScrollView(
                              child: Container(

                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Container(
                                    //   height: 200,
                                    //   width: MediaQuery.of(context).size.width,
                                    //   //  child: Text(snapshotRecord.data.data()["data"]["id"]),
                                    //   child: CustomizedLine(context: context,max: snapshotRecord.data.get("max"),doubledata: jsonDecode(
                                    //     snapshotRecord.data.get("data"),
                                    //   ),),
                                    // ),
                                    // Container(
                                    //   height: 200,
                                    //   width: MediaQuery.of(context).size.width,
                                    //   //  child: Text(snapshotRecord.data.data()["data"]["id"]),
                                    //   child: DefaultPanning2(
                                    //     snapshotRecord.data.get("max"),
                                    //       snapshotRecord.data.get("targetLoad"),
                                    //     jsonDecode(
                                    //       snapshotRecord.data.get("data"),
                                    //
                                    //     ), snapshotRecord.data.get("startedLoad"), snapshotRecord.data.get("endedLoad"),
                                    //   ),
                                    // ),

                                    Container(
                                      margin: EdgeInsets.only(top: height * 0.020, left: width * 0.04, right: width * 0.04),
                                      child: Wrap(
                                        children: [
                                          Card(
                                              margin: EdgeInsets.only(bottom: height*0.02),



                                              child:Container( height: height*0.060,
                                                width: width,
                                                child: Stack(
                                                  children: [
                                                    Align(alignment: Alignment.centerLeft,child: Row(
                                                      children: [
                                                        //snapshotRecord
                                                        Container(
                                                          margin: EdgeInsets.only(
                                                            left: width * 0.04,
                                                          ),
                                                          child: SvgPicture.asset(
                                                            ("assets/svg/folderIcon.svg"),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        Container(
                                                          margin: EdgeInsets.only(
                                                            left: width * 0.02,
                                                          ),
                                                          child: Icon(Icons.chevron_right_rounded),
                                                        ),
                                                        Padding(padding: EdgeInsets.all( width * 0.02),child: dataJson["folder"]!=null?  FutureBuilder<DocumentSnapshot>(
                                                            future:widget.customerFirestore.collection("folders").doc(dataJson["folder"]).get() ,
                                                            builder: (context, snapshot) {
                                                              if(snapshot.hasData){
                                                                return Text(snapshot.data!.get("name"),style: interMedium.copyWith(
                                                                    color: ThemeManager().getPopUpTextGreyColor,
                                                                    fontSize: width * 0.041));

                                                              }else{
                                                                return Text("");
                                                              }
                                                            }):Text("---",style: interMedium.copyWith(
                                                            color: ThemeManager().getPopUpTextGreyColor,
                                                            fontSize: width * 0.041)),),

                                                      ],
                                                    ),),
                                                    Align(alignment: Alignment.centerRight,child: Padding(padding: EdgeInsets.all( width * 0.02),
                                                      child: dataJson["folder"]!=null?
                                                      FutureBuilder<DocumentSnapshot>(
                                                          future:widget.customerFirestore.collection("folders").doc(dataJson["folder"]).get() ,
                                                          builder: (context, snapshot) {
                                                            if(snapshot.hasData){
                                                              return InkWell(onTap: (){
                                                                //MoveFileActivity

                                                                showDialog(
                                                                  context: context,
                                                                  builder: (_) =>   MoveFileActivity(move: true,locale: Locale("en"), recordId:snapshotRecord.data!.id, dataToMove: snapshotRecord.data!, customerFirestore: widget.customerFirestore, customerId:  widget.customerFirestore.app.options.projectId, curentFolderID: dataJson["folder"],  ),
                                                                );



                                                              },
                                                                child: Text("Move",style: interMedium.copyWith(
                                                                    color: ThemeManager().getDarkGreenColor,
                                                                    fontSize: width * 0.041)),
                                                              );

                                                            }else{
                                                              return Text("");
                                                            }
                                                          }):
                                                      InkWell(onTap: (){
                                                        showDialog(
                                                          context: context,
                                                          builder: (_) =>   MoveFileActivity(move: false,locale: Locale("en"), recordId:snapshotRecord.data!.id, dataToMove: snapshotRecord.data!, customerFirestore: widget.customerFirestore, customerId:  widget.customerFirestore.app.options.projectId, curentFolderID:"",  ),
                                                        );
                                                      },
                                                        child: Text("Select Folder",style: interMedium.copyWith(
                                                            color: ThemeManager().getDarkGreenColor,
                                                            fontSize: width * 0.041)),
                                                      ),),),
                                                  ],
                                                ),
                                              )
                                            // child: Text("Test Result Pass",style: interMedium.copyWith(color: ThemeManager().getDarkGreenColor, fontSize: width * 0.042)

                                          ),
                                          Container(
                                            margin: EdgeInsets.only(bottom: height*0.02),
                                            decoration: new BoxDecoration(
                                              color:ThemeManager().getLightGreenColor,
                                            ),
                                            padding: EdgeInsets.symmetric(horizontal: 15),
                                            alignment: Alignment.center,
                                            height: height*0.060,
                                            width: width,

                                            child: snapshotRecord.data!.get("startedLoad") == 0
                                                ? Text("Test Result Not Timed",style: interMedium.copyWith(color: ThemeManager().getDarkGreenColor, fontSize: width * 0.042),)
                                                : (snapshotRecord.data!
                                                .get("startedLoad") >
                                                0
                                                ? (snapshotRecord.data!.get("didPassed") == true
                                                ? Text(
                                              "Test Result Pass",
                                              style: interMedium.copyWith(color: ThemeManager().getDarkGreenColor, fontSize: width * 0.042),
                                            )
                                                : Text("Test Result Fail",
                                                style:interMedium.copyWith(color: ThemeManager().getDarkGreenColor, fontSize: width * 0.042)))
                                                : Text("Test Result Fail",
                                                style: interMedium.copyWith(color: ThemeManager().getDarkGreenColor, fontSize: width * 0.042))),
                                            // child: Text("Test Result Pass",style: interMedium.copyWith(color: ThemeManager().getDarkGreenColor, fontSize: width * 0.042)

                                          ),

                                          Container(
                                            color: ThemeManager().getWhiteColor,
                                            height: height*0.22,
                                            width: MediaQuery.of(context).size.width,
                                            //  child: Text(snapshotRecord.data.data()["data"]["id"]),
                                            child: LineMultiColor(prefferedDecimalPlace: PrefferedDecimalPlaces,unit: getUnit(snapshotRecord.data!),
                                                data: jsonDecode(
                                                    snapshotRecord.data!.get("data")),
                                                max: snapshotRecord.data!.get("max"),
                                                target:
                                                snapshotRecord.data!.get("targetLoad"),
                                                startedLoad:
                                                snapshotRecord.data!.get("startedLoad"),
                                                duration: snapshotRecord.data!
                                                    .get("targetDuration"),
                                                endedLoad:
                                                snapshotRecord.data!.get("endedLoad"),
                                                fullDuration:
                                                snapshotRecord.data!.get("lastTime"),
                                                didPassed:
                                                snapshotRecord.data!.get("didPassed")),
                                          ),
                                          false?  ListView(shrinkWrap: true,scrollDirection: Axis.horizontal,
                                            children: [
                                              Container(width: 80,
                                                height: 50,
                                                child: Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(3.0),
                                                      child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),color: ThemeManager().getDarkGreenColor),height: 20,width: 20,),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(3.0),
                                                      child: Center(child: Text("Load")),
                                                    ),
                                                  ],),
                                              ),
                                              Container(width: 80, height: 50,
                                                child: Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(3.0),
                                                      child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),color: Colors.greenAccent),height: 20,width: 20,),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(3.0),
                                                      child: Center(child: Text("T St")),
                                                    ),
                                                  ],),
                                              ),
                                              Container(width: 80, height: 50,
                                                child: Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(3.0),
                                                      child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),color: Colors.redAccent,),height: 20,width: 20),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(3.0),
                                                      child: Center(child: Text("T End")),
                                                    ),
                                                  ],),
                                              ),
                                              Container(width: 80, height: 50,
                                                child: Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(3.0),
                                                      child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),color: Colors.black,),height: 20,width: 20),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(3.0),
                                                      child: Center(child: Text("Target")),
                                                    ),
                                                  ],),
                                              ),
                                            ],
                                          ):Container(width: 0,height: 0,),


                                          Container(
                                            margin: EdgeInsets.only(top: height*0.024),
                                            alignment: Alignment.topLeft,
                                            child:Text("Title",style: interMedium.copyWith(
                                                color: ThemeManager().getPopUpTextGreyColor,
                                                fontSize: width * 0.041)
                                            ),
                                          ),
                                          //title
                                          InkWell(onTap: (){
                                            showDialog(context: context,
                                                builder: (BuildContext context){
                                                  return UpdatetextTitle(title:title,firestore: widget.customerFirestore,id:widget.id);
                                                }
                                            ).whenComplete(() => TestTitleUpdatedStream.getInstance().dataReload(true));
                                          },
                                            child: Container(decoration: BoxDecoration(color:  ThemeManager().getLightGreenTextFieldColor,borderRadius: BorderRadius.circular(width * 0.014)),
                                              margin: EdgeInsets.only(top: height * 0.015),
                                              child: Padding(
                                                padding:  EdgeInsets.symmetric(
                                                    vertical: height * 0.016, horizontal: width * 0.045),
                                                child: Stack(children: [
                                                  Align(alignment: Alignment.centerLeft,child: Padding(
                                                    padding: const EdgeInsets.only(right: 50),
                                                    child: Text(title,maxLines: 1,),
                                                  ),),
                                                  Align(alignment: Alignment.centerRight,child: InkWell(child: Image(image:AssetImage('assets/icons/editIcon.png',),
                                                    color: ThemeManager().getDarkGreenColor,),onTap: (){

                                                    showDialog(context: context,
                                                        builder: (BuildContext context){
                                                          return UpdatetextTitle(title:title,firestore: widget.customerFirestore,id:snapshotRecord.data!.id);
                                                        }
                                                    );





                                                    // TextEditingController controller;
                                                    // controller = new TextEditingController(
                                                    //     text: snapshotRecord.data!.get("name"));
                                                    // if (lastInfo != null) {
                                                    //   controller =
                                                    //   new TextEditingController(text: lastInfo.get("name"));
                                                    // }
                                                    //
                                                    // Navigator.of(context).push(new MaterialPageRoute<Null>(
                                                    //     builder: (BuildContext context) {
                                                    //       return Scaffold(
                                                    //         appBar: AppBar(
                                                    //           title: Text("Update"),
                                                    //         ),
                                                    //         body: Container(
                                                    //           decoration: BoxDecoration(
                                                    //             color: Color.fromARGB(255, 247, 247, 247),
                                                    //             borderRadius: BorderRadius.only(
                                                    //                 topLeft: Radius.circular(10.0),
                                                    //                 topRight: Radius.circular(10.0)),
                                                    //           ),
                                                    //           child: Padding(
                                                    //             padding: const EdgeInsets.all(15.0),
                                                    //             child: Wrap(
                                                    //               children: [
                                                    //                 Text(
                                                    //                   "Update Title",
                                                    //                   style: TextStyle(
                                                    //                       fontSize: 20, fontWeight: FontWeight.bold),
                                                    //                 ),
                                                    //                 Padding(
                                                    //                   padding: const EdgeInsets.all(8.0),
                                                    //                   child: TextFormField(
                                                    //                     controller: controller,
                                                    //                     autofocus: true,
                                                    //                     decoration: InputDecoration(
                                                    //                       labelText: 'Title',
                                                    //                       border: OutlineInputBorder(),
                                                    //                     ),
                                                    //                   ),
                                                    //                 ),
                                                    //                 InkWell(
                                                    //                   onTap: () {
                                                    //                     widget.customerFirestore
                                                    //                         .collection("pulltest")
                                                    //                         .doc(widget.id)
                                                    //                         .update({"name": controller.text}).then(
                                                    //                             (value) {
                                                    //                           Navigator.pop(context);
                                                    //                         });
                                                    //                   },
                                                    //                   child: Card(
                                                    //                     color: Theme.of(context).primaryColor,
                                                    //                     child: Center(
                                                    //                         child: Padding(
                                                    //                           padding: const EdgeInsets.all(10.0),
                                                    //                           child: Text(
                                                    //                             "Submit",
                                                    //                             style: TextStyle(
                                                    //                                 color: Colors.white,
                                                    //                                 fontWeight: FontWeight.bold),
                                                    //                           ),
                                                    //                         )),
                                                    //                   ),
                                                    //                 )
                                                    //               ],
                                                    //             ),
                                                    //           ),
                                                    //         ),
                                                    //       );
                                                    //     },
                                                    //     fullscreenDialog: true));
                                                  },),),
                                                ],),
                                              ),
                                            ),
                                          ),

                                          Container(
                                            margin: EdgeInsets.only(top: height*0.02),
                                            alignment: Alignment.topLeft,
                                            child:Text(
                                                "Notes",style: interMedium.copyWith(
                                                color: ThemeManager().getPopUpTextGreyColor,
                                                fontSize: width * 0.041)
                                            ),
                                          ),

                                          InkWell(onTap: (){
                                            showDialog(context: context,
                                                builder: (BuildContext context){
                                                  return UpdatetextNote(title:note,firestore: widget.customerFirestore,id:widget.id);
                                                }
                                            );
                                          },
                                            child: Container(height: 150,decoration: BoxDecoration(color:  ThemeManager().getLightGreenTextFieldColor,borderRadius: BorderRadius.circular(width * 0.014)),
                                              margin: EdgeInsets.only(top: height * 0.015),
                                              child: Padding(
                                                padding:  EdgeInsets.symmetric(
                                                    vertical: height * 0.016, horizontal: width * 0.045),
                                                child: Stack(children: [
                                                  Align(alignment: Alignment.topLeft,child: Padding(
                                                    padding: const EdgeInsets.only(right: 50),
                                                    child: Text(note),
                                                  ),),
                                                  Align(alignment: Alignment.topRight,child: InkWell(child: Image(image:AssetImage('assets/icons/editIcon.png',),
                                                    color: ThemeManager().getDarkGreenColor,),onTap: (){

                                                    // TextEditingController controller;
                                                    // controller = new TextEditingController(
                                                    //     text:snapshotRecord.data!.get("note"));
                                                    // if (lastInfo != null) {
                                                    //   controller =
                                                    //   new TextEditingController(text: lastInfo.get("note"));
                                                    // }
                                                    //
                                                    // Navigator.of(context).push(new MaterialPageRoute<Null>(
                                                    //     builder: (BuildContext context) {
                                                    //       return Scaffold(
                                                    //         appBar: AppBar(
                                                    //           title: Text("Update"),
                                                    //         ),
                                                    //         body: Container(
                                                    //           decoration: BoxDecoration(
                                                    //             color: Color.fromARGB(255, 247, 247, 247),
                                                    //             borderRadius: BorderRadius.only(
                                                    //                 topLeft: Radius.circular(10.0),
                                                    //                 topRight: Radius.circular(10.0)),
                                                    //           ),
                                                    //           child: Padding(
                                                    //             padding: const EdgeInsets.all(15.0),
                                                    //             child: Wrap(
                                                    //               children: [
                                                    //                 Text(
                                                    //                   "Update note",
                                                    //                   style: TextStyle(
                                                    //                       fontSize: 20, fontWeight: FontWeight.bold),
                                                    //                 ),
                                                    //                 Padding(
                                                    //                   padding: const EdgeInsets.all(8.0),
                                                    //                   child: TextFormField(
                                                    //                     controller: controller,
                                                    //                     autofocus: true,
                                                    //                     decoration: InputDecoration(
                                                    //                       labelText: 'Nitle',
                                                    //                       border: OutlineInputBorder(),
                                                    //                     ),
                                                    //                   ),
                                                    //                 ),
                                                    //                 InkWell(
                                                    //                   onTap: () {
                                                    //                     widget.customerFirestore
                                                    //                         .collection("pulltest")
                                                    //                         .doc(widget.id)
                                                    //                         .update({"note": controller.text}).then(
                                                    //                             (value) {
                                                    //                           Navigator.pop(context);
                                                    //                         });
                                                    //                   },
                                                    //                   child: Card(
                                                    //                     color: Theme.of(context).primaryColor,
                                                    //                     child: Center(
                                                    //                         child: Padding(
                                                    //                           padding: const EdgeInsets.all(10.0),
                                                    //                           child: Text(
                                                    //                             "Submit",
                                                    //                             style: TextStyle(
                                                    //                                 color: Colors.white,
                                                    //                                 fontWeight: FontWeight.bold),
                                                    //                           ),
                                                    //                         )),
                                                    //                   ),
                                                    //                 )
                                                    //               ],
                                                    //             ),
                                                    //           ),
                                                    //         ),
                                                    //       );
                                                    //     },
                                                    //     fullscreenDialog: true));
                                                  },),),
                                                ],),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    dividingLine(),
                                    targetValueData("Date & Time  ",DateFormat('hh:mm aa dd MMM yyyy').format(DateTime.fromMillisecondsSinceEpoch(snapshotRecord.data!.get("time")))),


                                    dividingLine(),
                                    targetValueData("Target Value  ", snapshotRecord.data!.get("loadMode") == "kN"? double.parse(snapshotRecord.data!.get("targetLoad").toString()).toStringAsFixed(PrefferedDecimalPlaces) +" "+getUnit(snapshotRecord.data!): double.parse(snapshotRecord.data!.get("targetLoad").toString()).toInt().toString() + " "+getUnit(snapshotRecord.data!) ),

                                    dividingLine(),
                                    targetValueData("Max Value  ", (snapshotRecord.data!.get("loadMode") == "kN"? double.parse(snapshotRecord.data!.get("max").toString()).toStringAsFixed(PrefferedDecimalPlaces)+ " ": double.parse(snapshotRecord.data!.get("max").toString()).toInt().toString()) +" "+getUnit(snapshotRecord.data!) +" at " + Calculators(). durationToString(snapshotRecord.data!.get("maxAt"))),

                                    dividingLine(),
                                    targetValueData("Timed Section Started  ",snapshotRecord.data!.get("startedLoad") > 0 ?   Calculators().durationToString((((snapshotRecord.data!.get("startedLoad"))))) : "Timer not Started",),

                                    dividingLine(),
                                    targetValueData("Timed Section Finished  ",snapshotRecord.data!.get("endedLoad") > 0
                                        ?   Calculators().durationToString(((snapshotRecord
                                        .data!
                                        .get("endedLoad"))))
                                        : "Timer not Started"),

                                    dividingLine(),
                                    targetValueData("Timed Section Length  ",Calculators(). durationToString(((snapshotRecord.data!
                                        .get("targetDuration") *
                                        1000)))),

                                    snapshotRecord.data!.get("didPassed")
                                        ? Container(width: 0,height: 0,)
                                        : Column(children: [
                                      dividingLine(),
                                      targetValueData("Failed At  ",Calculators(). durationToString((snapshotRecord
                                          .data!
                                          .get("failedAt")))),
                                    ],),


                                    dividingLine(),
                                    targetValueData("Device SN  ",snapshotRecord.data!.get("index2")!=null && snapshotRecord.data!.get("index2").toString().length>0? snapshotRecord.data!.get("index2"):"No data"),

                                    dividingLine(),
                                    targetValueData("Next Calibration Date  ",snapshotRecord.data!.get("index6")!=null&& snapshotRecord.data!.get("index2").toString().length>0? snapshotRecord.data!.get("index6"):"No data"),


                                    Container(
                                      margin: EdgeInsets.only(top: height * 0.025, left: width * 0.04, right: width * 0.04),
                                      child: Wrap(
                                        children: [
                                          false? StreamBuilder<QuerySnapshot>(
                                              stream: AppFirestore(firestore:
                                              widget.customerFirestore, auth: FirebaseAuth.instance,projectId: '').fetchCustomerUsersAllAttachmentStream(testID: widget.id),
                                              // stream: fetchCustomerUsersAllAttachmentStream(
                                              //     testID: widget.id,
                                              //     firestore: widget.customerFirestore),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<QuerySnapshot>
                                                  snapshotattachment) {
                                                List<Widget> widgets = [];
                                                List<Widget> widgetsFullScreen = [];
                                                List<dynamic> allFwi = [];
                                                if (snapshotattachment.hasData) {

                                                  print("wow");

                                                  //     return Text("Image size "+snapshotattachment.data.length.toString());

                                                  for (int q = 0; q < snapshotattachment.data!.docs.length; q++) {
                                                    // for (int q = snapshotattachment.data.docs.length-1; q >= snapshotattachment.data.docs.length; q--) {
                                                    // String partId = snapshotattachment.data.docs[q].id;
                                                    if (snapshotattachment.data!.docs[q].get("type")=="photo") {
                                                      Widget wI = Image.network(snapshotattachment.data!.docs[q].get("photoFile"));

                                                      widgets.add( InkWell(onTap: (){

                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>Scaffold(body: Center(child: wI),)));

                                                      },
                                                        child: Padding(
                                                          padding:
                                                          const EdgeInsets.all(
                                                              2.0),
                                                          child: Container(
                                                              width: 100,
                                                              height: 125,
                                                              child: wI),
                                                        ),
                                                      ));





                                                      widgetsFullScreen.add(wI);
                                                      //widgetsFullScreen
                                                      allFwi.add({
                                                        "wid": wI,
                                                        "time": snapshotattachment
                                                            .data!.docs[q]
                                                            .get("time"),
                                                      });
                                                      AttachmentsAddedListener.getInstance()
                                                          .dataReload(allFwi);

                                                    } else {
                                                      Widget video = PlayVideoAutoPlayFromUrl(autoPlay: false,mute: true,name: snapshotattachment.data!.docs[q].get("videoFile"),);
                                                      //snapshotattachment.data.docs[q].get("type")
                                                      //  widgets.add(PlayVideoFromUrl(name: snapshotattachment.data.docs[q].get("type"),));

                                                      widgetsFullScreen.add(video);
                                                      //widgetsFullScreen
                                                      allFwi.add({
                                                        "wid": video,
                                                        "time": snapshotattachment
                                                            .data!.docs[q]
                                                            .get("time"),
                                                      });
                                                      AttachmentsAddedListener.getInstance()
                                                          .dataReload(allFwi);
                                                      widgets.add( InkWell(onTap: (){

                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>Scaffold(body: Center(child: PlayVideoAutoPlayFromUrl(autoPlay: true,mute: false,name: snapshotattachment.data!.docs[q].get("videoFile"),)),)));

                                                      },
                                                        child: Padding(
                                                          padding:
                                                          const EdgeInsets.all(
                                                              2.0),
                                                          child: Container(
                                                              width: 100,
                                                              height: 125,
                                                              child: video),
                                                        ),
                                                      ));
                                                    }
                                                  }



                                                  ListView r = ListView(
                                                    scrollDirection: Axis.horizontal,
                                                    children: widgets,
                                                  );
                                                  return Container(
                                                    height: 130,
                                                    child: r,
                                                  );

                                                } else
                                                  return Text("No attachment");
                                              }):Container(height: 0,width: 0,),
                                          // Row(children: [
                                          //   Padding(
                                          //     padding: const EdgeInsets.all(10.0),
                                          //     child: Center(child: Container(
                                          //       height: 100,
                                          //       child: FutureBuilder<void>(
                                          //         future: _initializeControllerFuture,
                                          //         builder: (context, snapshot) {
                                          //           if (snapshot.connectionState == ConnectionState.done) {
                                          //             // If the Future is complete, display the preview.
                                          //             return CameraPreview(_controller);
                                          //           } else {
                                          //             // Otherwise, display a loading indicator.
                                          //             return Center(child: CircularProgressIndicator());
                                          //           }
                                          //         },
                                          //       ),
                                          //     ),),
                                          //   ),
                                          //   Container(
                                          //     child: Center(child:Wrap(children: [
                                          //       Container(
                                          //         child: InkWell(onTap: ()async{
                                          //           //add photo
                                          //           try {
                                          //             // Ensure that the camera is initialized.
                                          //             await _initializeControllerFuture;
                                          //
                                          //             // Attempt to take a picture and get the file `image`
                                          //             // where it was saved.
                                          //             final image = await _controller.takePicture();
                                          //             _image = File(image.path);
                                          //
                                          //
                                          //
                                          //             //   var thumbnail =tt.copyResize(tt.decodeImage(_image.readAsBytesSync()), width: 400);
                                          //
                                          //             //List<int> imageBytes =thumbnail.data.toList();
                                          //             //  print(imageBytes);
                                          //
                                          //
                                          //             String base64Image = base64Encode(_image.readAsBytesSync());
                                          //
                                          //             try{
                                          //               String base64Image = base64Encode(_image.readAsBytesSync());
                                          //               List imageParts = [];
                                          //               //  int mid = (base64Image.length/2).ceil();
                                          //               //imageParts.add(base64Image.substring(0,mid));
                                          //               //imageParts.add(base64Image.substring(mid,base64Image.length));
                                          //               if(true){
                                          //                 int  gap  = (1000*1000);
                                          //                 int iteration  = (base64Image.length/gap).ceil();
                                          //                 for(int i = 0 ; i < iteration; i ++){
                                          //                   if(base64Image.length>(((i*gap)+gap)))
                                          //                     imageParts.add(base64Image.substring(i*gap,(((i*gap)+gap))));
                                          //                   else   imageParts.add(base64Image.substring(i*gap,base64Image.length));
                                          //                 }
                                          //               }else{
                                          //                 imageParts.add(base64Image);
                                          //               }
                                          //
                                          //               uploadPhotos(id ,[{"imagePath":image.path,"image":imageParts,"time":new DateTime.now().millisecondsSinceEpoch}],customerFirestore).then((value) {
                                          //
                                          //
                                          //               });
                                          //               //upload now
                                          //               //   widget.photos.add({"imagePath":image.path,"image":imageParts,"time":new DateTime.now().millisecondsSinceEpoch});
                                          //             }catch(e){
                                          //               //  showMessage(context, "error occured");
                                          //             }
                                          //
                                          //
                                          //
                                          //
                                          //
                                          //
                                          //             //  widget.photos.add({"imagePath":image.path,"image":base64Image,"time":new DateTime.now().millisecondsSinceEpoch});
                                          //
                                          //             // If the picture was taken, display it on a new screen.
                                          //
                                          //           } catch (e) {
                                          //             // If an error occurs, log the error to the console.
                                          //             print(e);
                                          //           }
                                          //
                                          //
                                          //
                                          //         },
                                          //           child: Card(color: Theme.of(context).primaryColor,
                                          //             child: Padding(
                                          //               padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                                          //               child: Text("Add Photo",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                          //             ),
                                          //           ),
                                          //         ),
                                          //       ),
                                          //       Container(
                                          //         child: InkWell(onTap: ()async{
                                          //           //add video
                                          //           try {
                                          //             // Ensure that the camera is initialized.
                                          //             await _initializeControllerFuture;
                                          //
                                          //             // Attempt to take a picture and get the file `image`
                                          //             // where it was saved.
                                          //             _controller.startVideoRecording();
                                          //
                                          //             Future.delayed(const Duration(seconds: 5), () {
                                          //
                                          //               _controller.stopVideoRecording().then((value){
                                          //
                                          //                 _image = File(value.path);
                                          //
                                          //
                                          //                 String base64Image = base64Encode(_image.readAsBytesSync());
                                          //
                                          //                 try{
                                          //                   String base64Image = base64Encode(_image.readAsBytesSync());
                                          //                   List imageParts = [];
                                          //                   //  int mid = (base64Image.length/2).ceil();
                                          //                   //imageParts.add(base64Image.substring(0,mid));
                                          //                   //imageParts.add(base64Image.substring(mid,base64Image.length));
                                          //                   if(true){
                                          //                     int  gap  = (1000*1000);
                                          //                     int iteration  = (base64Image.length/gap).ceil();
                                          //                     for(int i = 0 ; i < iteration; i ++){
                                          //                       if(base64Image.length>(((i*gap)+gap)))
                                          //                         imageParts.add(base64Image.substring(i*gap,(((i*gap)+gap))));
                                          //                       else   imageParts.add(base64Image.substring(i*gap,base64Image.length));
                                          //                     }
                                          //                   }else{
                                          //                     imageParts.add(base64Image);
                                          //                   }
                                          //
                                          //                   uploadVideos(id ,[{"imagePath":value.path,"image":imageParts,"time":new DateTime.now().millisecondsSinceEpoch}],customerFirestore).then((value) {
                                          //
                                          //
                                          //                   });
                                          //                   //upload now
                                          //                   //   widget.photos.add({"imagePath":image.path,"image":imageParts,"time":new DateTime.now().millisecondsSinceEpoch});
                                          //                 }catch(e){
                                          //                   //  showMessage(context, "error occured");
                                          //                 }
                                          //
                                          //
                                          //               });
                                          //
                                          //
                                          //
                                          //             });
                                          //
                                          //
                                          //
                                          //
                                          //
                                          //
                                          //
                                          //             //   var thumbnail =tt.copyResize(tt.decodeImage(_image.readAsBytesSync()), width: 400);
                                          //
                                          //             //List<int> imageBytes =thumbnail.data.toList();
                                          //             //  print(imageBytes);
                                          //
                                          //
                                          //
                                          //
                                          //
                                          //
                                          //
                                          //
                                          //             //  widget.photos.add({"imagePath":image.path,"image":base64Image,"time":new DateTime.now().millisecondsSinceEpoch});
                                          //
                                          //             // If the picture was taken, display it on a new screen.
                                          //
                                          //           } catch (e) {
                                          //             // If an error occurs, log the error to the console.
                                          //             print(e);
                                          //           }
                                          //
                                          //
                                          //
                                          //         },
                                          //           child: Card(color: Theme.of(context).primaryColor,
                                          //             child: Padding(
                                          //               padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                                          //               child: Text("Add Video",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                          //             ),
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     ],),),
                                          //   ),
                                          //
                                          // ],),
                                          FutureBuilder(
                                            future: _initializeControllerFuture,
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState == ConnectionState.done) {
                                                return Column(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(top: height * 0.035),
                                                      height: height * 0.29,
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
                                                              height: height * 0.29,
                                                              width: double.infinity,
                                                              child:ClipRect(
                                                                  child: new OverflowBox(
                                                                      maxWidth: double.infinity,
                                                                      maxHeight: double.infinity,
                                                                      alignment: Alignment.center,
                                                                      child: new FittedBox(
                                                                          fit: BoxFit.cover,
                                                                          alignment: Alignment.center,
                                                                          child: GestureDetector(
                                                                            behavior: HitTestBehavior.translucent,
                                                                            onScaleStart: (details) {
                                                                              //zoom = _scaleFactor;
                                                                            },
                                                                            onScaleUpdate: (details) {
                                                                              double pinchLevel = details.scale;
                                                                              //pinchLevel <= minZoom && pinchLevel>=minZoom
                                                                              if(true){
                                                                                print("trying "+ (details.scale).toString());


                                                                                _controller.setZoomLevel( details.scale).then((value) {
                                                                                  zoom = details.scale;
                                                                                });
                                                                              }



                                                                            },
                                                                            child: new Container(
                                                                                width: width,
                                                                                height: height*0.7,
                                                                                child: new  CameraPreview(_controller)
                                                                            ),
                                                                          )
                                                                      )
                                                                  )
                                                              )),

                                                          //RecordRunningTimeStream.getInstance()


                                                          Align(alignment: Alignment.topCenter,child: StreamBuilder<int>(
                                                              stream: RecordRunningTimeStream.getInstance().outData,
                                                              builder: (context, snapshot) {
                                                                if(snapshot.hasData && _isRecording){
                                                                  return Padding(
                                                                    padding:  EdgeInsets.only(top: height * .02),
                                                                    child: Container(
                                                                      child: Text(
                                                                        "00" + ":" +(snapshot.data!>9? snapshot.data.toString():"0"+ snapshot.data.toString()),
                                                                        style: TextStyle(
                                                                          color: whiteColor,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                }else{
                                                                  return Container(width: 0,height: 0,);
                                                                }

                                                              }),),

                                                          // isSelected == true && _isRecording == true
                                                          //     ? Positioned(
                                                          //   top: height * .02,
                                                          //   child: Container(
                                                          //     child: Text(
                                                          //       minutes + ":" + seconds,
                                                          //       style: TextStyle(
                                                          //         color: whiteColor,
                                                          //       ),
                                                          //     ),
                                                          //   ),
                                                          // )
                                                          //     : Container(width: 0,height: 0,),
                                                          GestureDetector(
                                                            onTap: () {
                                                              if (isSelected == false) {

                                                                _controller.takePicture().then((value) {
                                                                  RecordingStartedStoppedStream.getInstance().dataReload(false);

                                                                  //uploadPhotos
                                                                  AppFirestore(firestore:  widget.customerFirestore, projectId: '', auth: FirebaseAuth.instance). uploadPhotos(
                                                                    widget.id,
                                                                    [
                                                                      {
                                                                        "imagePath":value.path,
                                                                        //"image": imageParts,
                                                                        "time": new DateTime.now()
                                                                            .millisecondsSinceEpoch
                                                                      }
                                                                    ],
                                                                  )
                                                                      .then((value) {});

                                                                  // PhotoClickedStream.getInstance().dataReload({
                                                                  //   "imagePath":value.path,
                                                                  //   // "image": imageParts,
                                                                  //   "time": new DateTime.now()
                                                                  //       .millisecondsSinceEpoch
                                                                  // });
                                                                  //
                                                                  // CommonAttachmentAddedStream.getInstance().dataReload({
                                                                  //   "thumb":value.path,
                                                                  //   "type": "i",
                                                                  //   // "data": imageParts,
                                                                  //   "time": new DateTime.now().millisecondsSinceEpoch
                                                                  // });


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
                                                                // if (_isRecording == false) {
                                                                //   _controller.startVideoRecording().then((value) {
                                                                //     setState(() {
                                                                //       _isRecording = true;
                                                                //     });
                                                                //     startTimer();
                                                                //   });
                                                                // } else {
                                                                //   _controller.stopVideoRecording().then((value) {
                                                                //     setState(() {
                                                                //       imageFile = value;
                                                                //       _isRecording = false;
                                                                //       if (imageList.length >= 5)
                                                                //         _scrollController.animateTo(width,
                                                                //             duration: Duration(seconds: 2),
                                                                //             curve: Curves.easeIn);
                                                                //     });
                                                                //     File media = File(value.path);
                                                                //     imageList.add(media.path);
                                                                //     newImageList.add(media);
                                                                //     // log(imageList.toString());
                                                                //     stopTimer();
                                                                //   });
                                                                // }













                                                                if (_isRecording == false) {
                                                                  RecordingStartedStoppedStream.getInstance().dataReload(true);
                                                                  _controller.startVideoRecording().then((value) {

                                                                    _isRecording = true;

                                                                    startTimer();
                                                                  });
                                                                } else {
                                                                  _controller.stopVideoRecording().then((value) {
                                                                    RecordRunningTimeStream.getInstance().dataReload(-1);
                                                                    _isRecording = false;
                                                                    RecordingStartedStoppedStream.getInstance().dataReload(false);
                                                                    stopTimer();

                                                                    //uploadPhotos
                                                                    AppFirestore(firestore:  widget.customerFirestore, projectId: '', auth: FirebaseAuth.instance). uploadVideos(
                                                                      widget.id,
                                                                      [
                                                                        {
                                                                          "imagePath":value.path,
                                                                          //"image": imageParts,
                                                                          "time": new DateTime.now()
                                                                              .millisecondsSinceEpoch
                                                                        }
                                                                      ],
                                                                    )
                                                                        .then((value) {});

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
                                                          Align(alignment: Alignment.topRight,child:  Container(
                                                            //width: width * 0.16,
                                                            // height: height * 0.045,
                                                            margin: EdgeInsets.only(
                                                                left: width * 0.65, top: height * 0.015,right: height * 0.015 ),
                                                            child: CameraToggle(isPhoto: !isSelected,isVideoSelected: (bool ) {
                                                              print("callbac came"+ bool.toString());

                                                              _isSelectForPhoto = !bool;
                                                              isSelected = bool;

                                                            },),



                                                          ),),

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

                                                          false? Container( height: height * 0.19,
                                                            width: double.infinity,
                                                            child: Positioned(top: 20,left: 20,child:    StreamBuilder<int>(
                                                                stream: RecordRunningTimeStream.getInstance().outData,
                                                                builder: (context, snapshot) {
                                                                  if(snapshot.hasData && snapshot.data!>1){
                                                                    return Icon(Icons.fiber_manual_record,color: Colors.redAccent,);
                                                                  }else{
                                                                    return Container(width: 0,height: 0,);
                                                                  }

                                                                })),
                                                          ):Container(width: 0,height: 0,)
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
                                          ),
                                          if(true) Container(height: height * 0.07,
                                            child: StreamBuilder<QuerySnapshot>(
                                                stream: AppFirestore(firestore: widget.customerFirestore, auth: FirebaseAuth.instance,projectId: '').fetchCustomerUsersAllAttachmentStream(testID:widget.snapshotHistoryItem.id),
                                                // stream: fetchCustomerUsersAllAttachmentStream(
                                                //     testID: widget.id,
                                                //     firestore: widget.customerFirestore),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<QuerySnapshot>
                                                    snapshotattachment) {
                                                  List<Widget> widgets = [];
                                                  // List<Widget> widgetsFullScreen = [];
                                                  List<dynamic> allFwi = [];
                                                  if (snapshotattachment.hasData && snapshotattachment.data!.docs.length>0) {

                                                    //sort here
                                                    List<QueryDocumentSnapshot> allAttachments = snapshotattachment.data!.docs;

                                                    allAttachments.sort((b, a) {
                                                      return a
                                                          .get("time")
                                                          .compareTo(
                                                          b.get("time"));
                                                    });

                                                    //     return Text("Image size "+snapshotattachment.data.length.toString());
                                                    // String mapUri = "https://maps.googleapis.com/maps/api/staticmap?center=" +
                                                    //     docs[index]["location"]["lat"]
                                                    //         .toString() +
                                                    //     "," +
                                                    //     docs[index]["location"]["long"]
                                                    //         .toString() +
                                                    //     "&zoom=16&size=" +
                                                    //     (width*0.9).toStringAsFixed(0)+
                                                    //     "x200&markers=" +
                                                    //     docs[index]["location"]["lat"]
                                                    //         .toString() +
                                                    //     "," +
                                                    //     docs[index]["location"]["long"]
                                                    //         .toString() +
                                                    //     "&key=AIzaSyBQH9dnXV9oUn0K8MMge3MlbhBgbLKzQ10";



                                                    for (int q = 0; q < allAttachments.length; q++) {
                                                      // for (int q = snapshotattachment.data.docs.length-1; q >= snapshotattachment.data.docs.length; q--) {
                                                      // String partId = snapshotattachment.data.docs[q].id;
                                                      if (allAttachments[q].get("type")=="photo") {
                                                        Widget wI = Image.network(allAttachments[q].get("photoFile"),fit: BoxFit.cover,);

                                                        widgets.add( Container( height: height * 0.07,
                                                          width: width * 0.18,
                                                          child: InkWell(onTap: (){



                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>SafeArea(child: Scaffold(body: Column(children: [

                                                                      ApplicationAppbar().getAppbar(title: "Photo"),
                                                                      Stack(children: [
                                                                        Align(alignment: Alignment.center,child: wI,),
                                                                        Positioned(top: 15,left: 15,child: InkWell(onTap: (){
                                                                          Navigator.pop(context);
                                                                        },
                                                                          child: Card(elevation: 8,shape: RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.circular(20.0),
                                                                          ),color: ThemeManager().getDarkGreenColor,child: Container(width: 40,height: 40,child: Center(child :Icon(Icons.arrow_back,color: Colors.white,)),),) ,
                                                                        ),),



                                                                      ],)
                                                                    ],),))));



                                                          },
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(0.0),
                                                              child: Container(
                                                                  height: height * 0.07,
                                                                  width: width * 0.18,
                                                                  child: wI),
                                                            ),
                                                          ),
                                                        ));

                                                        if(false){
                                                          allFwi.add({
                                                            "wid": wI,
                                                            "time": snapshotattachment
                                                                .data!.docs[q]
                                                                .get("time"),
                                                          });
                                                          AttachmentsAddedListener.getInstance().dataReload(allFwi);
                                                        }





                                                        // widgetsFullScreen.add(wI);
                                                        //widgetsFullScreen


                                                      } else {
                                                        //  Widget videoV = PlayVideoAutoPlayFromUrl(autoPlay: false,mute: true,name: snapshotattachment.data!.docs[q].get("videoFile"),);
                                                        //  Widget video = Center(child: Padding(
                                                        //    padding: const EdgeInsets.all(0.0),
                                                        //    child: Stack(children: [
                                                        //      Align(alignment: Alignment.center,child: PlayVideoAutoPlayFromUrl(autoPlay: true,mute: false,name: snapshotattachment.data!.docs[q].get("videoFile"),),),
                                                        //      Align(alignment: Alignment.center,child:Icon(Icons.play_arrow_outlined,color: ThemeManager().getDarkGreenColor,size: 40,),),
                                                        //
                                                        //    ],),
                                                        //  ),);

                                                        Widget video = Center(child:PlayVideoAutoPlayFromUrl(autoPlay: true,mute: false,name: allAttachments[q].get("videoFile"),),);
                                                        //snapshotattachment.data.docs[q].get("type")
                                                        //  widgets.add(PlayVideoFromUrl(name: snapshotattachment.data.docs[q].get("type"),));

                                                        // widgetsFullScreen.add(video);
                                                        //widgetsFullScreen
                                                        if(false){
                                                          allFwi.add({
                                                            "wid": video,
                                                            "time": snapshotattachment
                                                                .data!.docs[q]
                                                                .get("time"),
                                                          });
                                                          AttachmentsAddedListener.getInstance().dataReload(allFwi);
                                                        }
                                                        widgets.add( Container( height: height * 0.07,
                                                          width: width * 0.18,
                                                          child: InkWell(onTap: (){

                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>Scaffold(body: Center(child: PlayVideoAutoPlayFromUrl(autoPlay: true,mute: false,name: allAttachments[q].get("videoFile"),)),)));

                                                          },
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(0.0),
                                                              child: Container(
                                                                  height: height * 0.07,
                                                                  width: width * 0.18,
                                                                  child:PlayVideoAutoPlayFromUrl(autoPlay: true,mute: true,name: allAttachments[q].get("videoFile"),)),
                                                            ),
                                                          ),
                                                        ));
                                                      }
                                                    }



                                                    ListView r = ListView(
                                                      scrollDirection: Axis.horizontal,
                                                      children: widgets,
                                                    );
                                                    return Container( height :height * 0.07,child: r);

                                                  } else
                                                    return Center(child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text("No attachment"),
                                                    ));
                                                }),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: height*0.02),
                                            child: mapView(widget.snapshotHistoryItem["location"]["lat"]!=null?widget.snapshotHistoryItem["location"]["lat"]:0,widget.snapshotHistoryItem["location"]["long"]!=null?widget.snapshotHistoryItem["location"]["long"]:0,),
                                          ),
                                          // InkWell(
                                          //     onTap: () async {
                                          //       if (widget.snapshotHistoryItem["location"]
                                          //       ["lat"] !=
                                          //           null &&
                                          //           widget.snapshotHistoryItem["location"]
                                          //           ["long"] !=
                                          //               null) {
                                          //         final availableMaps =
                                          //         await MapLauncher.installedMaps;
                                          //         print(
                                          //             availableMaps); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]
                                          //
                                          //         await availableMaps.first.showMarker(
                                          //           coords: Coords(
                                          //               widget.snapshotHistoryItem[
                                          //               "location"]["lat"],
                                          //               widget.snapshotHistoryItem[
                                          //               "location"]["long"]),
                                          //           title: "Test Location",
                                          //         );
                                          //       }
                                          //     },
                                          //     child: Center(child: Image.network(mapUri))),

                                          // InkWell(
                                          //   onTap: () async {
                                          //     if (widget.snapshotHistoryItem["location"]
                                          //     ["lat"] !=
                                          //         null &&
                                          //         widget.snapshotHistoryItem["location"]
                                          //         ["long"] !=
                                          //             null) {
                                          //       final availableMaps =
                                          //       await MapLauncher.installedMaps;
                                          //       print(
                                          //           availableMaps); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]
                                          //
                                          //       await availableMaps.first.showMarker(
                                          //         coords: Coords(
                                          //             widget.snapshotHistoryItem["location"]
                                          //             ["lat"],
                                          //             widget.snapshotHistoryItem["location"]
                                          //             ["long"]),
                                          //         title: "Test Location",
                                          //       );
                                          //     }
                                          //   },
                                          //   child: Padding(
                                          //     padding: const EdgeInsets.all(8.0),
                                          //     child: Container(
                                          //       decoration: BoxDecoration(
                                          //           border: Border.all(
                                          //               color: Theme.of(context)
                                          //                   .primaryColor)),
                                          //       child: Padding(
                                          //         padding: const EdgeInsets.all(0.0),
                                          //         child: Table(
                                          //           children: [
                                          //             TableRow(
                                          //                 decoration: BoxDecoration(
                                          //                     color: Theme.of(context)
                                          //                         .primaryColor
                                          //                         .withOpacity(0.1)),
                                          //                 children: [
                                          //                   Padding(
                                          //                     padding:
                                          //                     const EdgeInsets.all(8.0),
                                          //                     child: Center(
                                          //                         child: Text("Lat ")),
                                          //                   ),
                                          //                   Padding(
                                          //                     padding:
                                          //                     const EdgeInsets.all(8.0),
                                          //                     child: Center(
                                          //                         child: Text("Long ")),
                                          //                   )
                                          //                 ]),
                                          //             TableRow(children: [
                                          //               Padding(
                                          //                 padding:
                                          //                 const EdgeInsets.all(8.0),
                                          //                 child: Center(
                                          //                   child: Text(
                                          //                     widget.snapshotHistoryItem[
                                          //                     "location"]
                                          //                     ["lat"] !=
                                          //                         null
                                          //                         ? widget
                                          //                         .snapshotHistoryItem[
                                          //                     "location"]["lat"]
                                          //                         .toString()
                                          //                         : "No Data",
                                          //                     style: TextStyle(
                                          //                         color: Theme.of(context)
                                          //                             .primaryColor),
                                          //                   ),
                                          //                 ),
                                          //               ),
                                          //               Padding(
                                          //                 padding:
                                          //                 const EdgeInsets.all(8.0),
                                          //                 child: Center(
                                          //                   child: Text(
                                          //                     widget.snapshotHistoryItem[
                                          //                     "location"]
                                          //                     ["long"] !=
                                          //                         null
                                          //                         ? widget
                                          //                         .snapshotHistoryItem[
                                          //                     "location"]
                                          //                     ["long"]
                                          //                         .toString()
                                          //                         : "No Data",
                                          //                     style: TextStyle(
                                          //                         color: Theme.of(context)
                                          //                             .primaryColor),
                                          //                   ),
                                          //                 ),
                                          //               )
                                          //             ]),
                                          //           ],
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                          // Row(
                                          //   children: [
                                          //     Padding(
                                          //       padding: const EdgeInsets.all(8.0),
                                          //       child: Text("Lat "),
                                          //     ),
                                          //     Padding(
                                          //       padding: const EdgeInsets.all(8.0),
                                          //       child: Text(
                                          //         widget.snapshotHistoryItem["location"]["lat"]
                                          //             .toString(),
                                          //         style: TextStyle(
                                          //             color: Theme.of(context).primaryColor),
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
                                          // Row(
                                          //   children: [
                                          //     Padding(
                                          //       padding: const EdgeInsets.all(8.0),
                                          //       child: Text("Long "),
                                          //     ),
                                          //     Padding(
                                          //       padding: const EdgeInsets.all(8.0),
                                          //       child: Text(
                                          //         widget.snapshotHistoryItem["location"]["long"]
                                          //             .toString(),
                                          //         style: TextStyle(
                                          //             color: Theme.of(context).primaryColor),
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),

//                             ListTile(
//                               onTap: () {
//                                 TextEditingController controller;
//                                 controller = new TextEditingController(
//                                     text: widget.snapshotHistoryItem["note"]);
//                                 if (lastInfo != null) {
//                                   controller = new TextEditingController(
//                                       text: lastInfo.get("note"));
//                                 }
//
//                                 Navigator.of(context)
//                                     .push(new MaterialPageRoute<Null>(
//                                     builder: (BuildContext context) {
//                                       return Scaffold(
//                                         appBar: AppBar(
//                                           title: Text("Update Note"),
//                                         ),
//                                         body: Container(
//                                           decoration: BoxDecoration(
//                                             color: Color.fromARGB(
//                                                 255, 247, 247, 247),
//                                             borderRadius:
//                                             BorderRadius.only(
//                                                 topLeft:
//                                                 Radius.circular(
//                                                     10.0),
//                                                 topRight:
//                                                 Radius.circular(
//                                                     10.0)),
//                                           ),
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(
//                                                 15.0),
//                                             child: Wrap(
//                                               children: [
//                                                 Padding(
//                                                   padding:
//                                                   const EdgeInsets
//                                                       .all(8.0),
//                                                   child: TextFormField(
//                                                     onFieldSubmitted:
//                                                         (v) {
//                                                       widget
//                                                           .customerFirestore
//                                                           .collection(
//                                                           "pulltest")
//                                                           .doc(widget.id)
//                                                           .update({
//                                                         "note": v
//                                                       }).then((value) {
//                                                         Navigator.pop(
//                                                             context);
//                                                       });
//                                                     },
//                                                     controller:
//                                                     controller,
//                                                     autofocus: true,
//                                                     maxLines: 4,
//                                                     minLines: 4,
//                                                     decoration:
//                                                     InputDecoration(
//                                                       labelText: 'Note',
//                                                       border:
//                                                       OutlineInputBorder(),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 InkWell(
//                                                   onTap: () {
//                                                     widget
//                                                         .customerFirestore
//                                                         .collection(
//                                                         "pulltest")
//                                                         .doc(widget.id)
//                                                         .update({
//                                                       "note":
//                                                       controller.text
//                                                     }).then((value) {
//                                                       Navigator.pop(
//                                                           context);
//                                                     });
//                                                   },
//                                                   child: Card(
//                                                     color:
//                                                     Theme.of(context)
//                                                         .primaryColor,
//                                                     child: Center(
//                                                         child: Padding(
//                                                           padding:
//                                                           const EdgeInsets
//                                                               .all(10.0),
//                                                           child: Text(
//                                                             "Submit",
//                                                             style: TextStyle(
//                                                                 color: Colors
//                                                                     .white,
//                                                                 fontWeight:
//                                                                 FontWeight
//                                                                     .bold),
//                                                           ),
//                                                         )),
//                                                   ),
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                     fullscreenDialog: true));
//
//                                 // showModalBottomSheet(
//                                 //     context: context,
//                                 //     builder: (builder) {
//                                 //       return new Container(
//                                 //         decoration: BoxDecoration(
//                                 //           color: Color.fromARGB(255, 247, 247, 247),
//                                 //           borderRadius: BorderRadius.only(
//                                 //               topLeft: Radius.circular(10.0),
//                                 //               topRight: Radius.circular(10.0)),
//                                 //         ),
//                                 //         child: Padding(
//                                 //           padding: const EdgeInsets.all(15.0),
//                                 //           child: Wrap(
//                                 //             children: [
//                                 //               Text(
//                                 //                 "Update Note",
//                                 //                 style: TextStyle(
//                                 //                     fontSize: 20,
//                                 //                     fontWeight: FontWeight.bold),
//                                 //               ),
//                                 //               Padding(
//                                 //                 padding: const EdgeInsets.all(8.0),
//                                 //                 child: TextFormField(
//                                 //                   controller: controller,
//                                 //                   //initialValue:  snapshotHistoryItem["note"],
//                                 //                 ),
//                                 //               ),
//                                 //               InkWell(
//                                 //                 onTap: () {
//                                 //                   widget.customerFirestore
//                                 //                       .collection("pulltest")
//                                 //                       .doc(widget.id)
//                                 //                       .update({
//                                 //                     "note": controller.text
//                                 //                   }).then((value) {
//                                 //                     Navigator.pop(context);
//                                 //                   });
//                                 //                 },
//                                 //                 child: Card(
//                                 //                   color: Theme.of(context)
//                                 //                       .primaryColor,
//                                 //                   child: Center(
//                                 //                       child: Padding(
//                                 //                     padding:
//                                 //                         const EdgeInsets.all(10.0),
//                                 //                     child: Text(
//                                 //                       "Submit",
//                                 //                       style: TextStyle(
//                                 //                           color: Colors.white,
//                                 //                           fontWeight:
//                                 //                               FontWeight.bold),
//                                 //                     ),
//                                 //                   )),
//                                 //                 ),
//                                 //               )
//                                 //             ],
//                                 //           ),
//                                 //         ),
//                                 //       );
//                                 //     });
//
//                                 // scaffoldState.currentState
//                                 //     .showBottomSheet((context) => Container(
//                                 //   decoration: BoxDecoration(
//                                 //   color: Color.fromARGB(255, 247, 247, 247 ),
//                                 //     borderRadius: BorderRadius.only(
//                                 //         topLeft: Radius.circular(10.0),
//                                 //         topRight: Radius.circular(10.0)),
//                                 //   ),
//                                 //   child: Wrap(
//                                 //     children: [
//                                 //       TextFormField(
//                                 //         initialValue:  snapshotHistoryItem["note"],
//                                 //       ),
//                                 //       Card(color: Theme.of(context).primaryColor,
//                                 //         child: Center(child: Padding(
//                                 //           padding: const EdgeInsets.all(10.0),
//                                 //           child: Text("Submit",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
//                                 //         )),
//                                 //       )
//                                 //     ],
//                                 //   ),
//                                 // ));
// /*
//                                 showBottomSheet(
//                                     context: context,
//                                     builder: (context) => Container(
//                                       color: Colors.grey,
//                                       child: Column(
//                                         children: [
//                                           TextFormField(
//                                             initialValue:  snapshotHistoryItem["note"],
//                                           ),
//                                           Card(color: Theme.of(context).primaryColor,
//                                             child: Center(child: Text("Submit",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
//                                           )
//                                         ],
//                                       ),
//                                     ));
//                                 */
//                               },
//                               trailing: Icon(Icons.edit),
//                               title: Text(
//                                 "Notes",
//                                 style: TextStyle(
//                                     color: Theme.of(context).primaryColor),
//                               ),
//                               subtitle: StreamBuilder<DocumentSnapshot>(
//                                   stream: widget.customerFirestore
//                                       .collection("pulltest")
//                                       .doc(widget.id)
//                                       .snapshots(),
//                                   builder: (BuildContext context,
//                                       AsyncSnapshot<DocumentSnapshot>
//                                       snapshotattachment) {
//                                     if (snapshotattachment.hasData) {
//                                       lastInfo = snapshotattachment.data;
//                                       // WidgetsBinding.instance.addPostFrameCallback((_){
//                                       // setState(() {
//                                       //   lastInfo = snapshotattachment.data;
//                                       // });
//                                       // });
//                                       return Text(snapshotattachment.data!
//                                           .get("note"));
//                                     } else {
//                                       return Text("Please wait");
//                                     }
//                                   }),
//                             ),
//                             ListTile(
//                               onTap: () {
//                                 // TextEditingController controller= new TextEditingController(text:  snapshotHistoryItem["note"]);
//                                 // showModalBottomSheet(
//                                 //     context: context,
//                                 //     builder: (builder){
//                                 //       return new Container(
//                                 //         decoration: BoxDecoration(
//                                 //           color: Color.fromARGB(255, 247, 247, 247 ),
//                                 //           borderRadius: BorderRadius.only(
//                                 //               topLeft: Radius.circular(10.0),
//                                 //               topRight: Radius.circular(10.0)),
//                                 //         ),
//                                 //         child: Padding(
//                                 //           padding: const EdgeInsets.all(15.0),
//                                 //           child: Wrap(
//                                 //             children: [
//                                 //               Text("Update Note",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
//                                 //               Padding(
//                                 //                 padding: const EdgeInsets.all(8.0),
//                                 //                 child: TextFormField(
//                                 //                   controller: controller,
//                                 //                   //initialValue:  snapshotHistoryItem["note"],
//                                 //                 ),
//                                 //               ),
//                                 //               InkWell(onTap: (){
//                                 //                 customerFirestore.collection("pulltest").doc(id).update({"note":controller.text}).then((value) {
//                                 //                   Navigator.pop(context);
//                                 //                 });
//                                 //               },
//                                 //                 child: Card(color: Theme.of(context).primaryColor,
//                                 //                   child: Center(child: Padding(
//                                 //                     padding: const EdgeInsets.all(10.0),
//                                 //                     child: Text("Submit",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
//                                 //                   )),
//                                 //                 ),
//                                 //               )
//                                 //             ],
//                                 //           ),
//                                 //         ),
//                                 //       );
//                                 //     }
//                                 // );
//
//                                 // scaffoldState.currentState
//                                 //     .showBottomSheet((context) => Container(
//                                 //   decoration: BoxDecoration(
//                                 //   color: Color.fromARGB(255, 247, 247, 247 ),
//                                 //     borderRadius: BorderRadius.only(
//                                 //         topLeft: Radius.circular(10.0),
//                                 //         topRight: Radius.circular(10.0)),
//                                 //   ),
//                                 //   child: Wrap(
//                                 //     children: [
//                                 //       TextFormField(
//                                 //         initialValue:  snapshotHistoryItem["note"],
//                                 //       ),
//                                 //       Card(color: Theme.of(context).primaryColor,
//                                 //         child: Center(child: Padding(
//                                 //           padding: const EdgeInsets.all(10.0),
//                                 //           child: Text("Submit",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
//                                 //         )),
//                                 //       )
//                                 //     ],
//                                 //   ),
//                                 // ));
// /*
//                                 showBottomSheet(
//                                     context: context,
//                                     builder: (context) => Container(
//                                       color: Colors.grey,
//                                       child: Column(
//                                         children: [
//                                           TextFormField(
//                                             initialValue:  snapshotHistoryItem["note"],
//                                           ),
//                                           Card(color: Theme.of(context).primaryColor,
//                                             child: Center(child: Text("Submit",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
//                                           )
//                                         ],
//                                       ),
//                                     ));
//                                 */
//                               },
//                               title: Text(
//                                 "Time",
//                                 style: TextStyle(
//                                     color: Theme.of(context).primaryColor),
//                               ),
//                               subtitle: Text(
//                                 DateFormat(' dd MMM yyyy , hh:mm aa ').format(
//                                     DateTime.fromMillisecondsSinceEpoch(
//                                         widget.snapshotHistoryItem["time"])),
//                                 style: TextStyle(),
//                               ),
//                             ),

                                          // ListTile(
                                          //   title: Text(
                                          //     "Address",
                                          //     style: TextStyle(
                                          //         color: Theme.of(context).primaryColor),
                                          //   ),
                                          //   subtitle: Text(
                                          //     widget.snapshotHistoryItem["address"],
                                          //     style: TextStyle(),
                                          //   ),
                                          // ),

                                          GestureDetector(
                                            onTap: (){
                                              Navigator.pop(context);
                                              // widget.customerFirestore
                                              //     .collection("pulltest")
                                              //     .doc(widget.id)
                                              //     .update({"note": note}).then(
                                              //         (value) {
                                              //
                                              //     });
                                              // widget.customerFirestore
                                              //     .collection("pulltest")
                                              //     .doc(widget.id)
                                              //     .update({"name": title}).then(
                                              //         (value) {
                                              //
                                              //     });
                                              // Navigator.push(context,
                                              //     MaterialPageRoute(
                                              //         builder: (context) => ViewTestsScreen(
                                              //           initialTabIndex: 0,
                                              //         )));
                                            },
                                            child: Container(
                                                margin: EdgeInsets.only(
                                                    left: width * 0.05,
                                                    right: width * 0.05,
                                                    bottom: height * 0.02,
                                                    top: height * 0.028),
                                                child: ButtonView(buttonLabel: TextConst.updateText)),
                                          ),

                                          //--------------------------Delete Button-----------------------
                                          GestureDetector(
                                            onTap: (){

                                              showDialog(context: context, builder: (context)=> DeleteTestPopUp(id: widget.id,firestore: widget.customerFirestore,));
                                            },
                                            child: Container(
                                                margin: EdgeInsets.only(
                                                  left: width * 0.05,
                                                  right: width * 0.05,
                                                  bottom: height * 0.05,
                                                ),
                                                child: Container(
                                                    alignment: Alignment.center,
                                                    height: height * 0.06,
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(height*0.008),
                                                      color: ThemeManager().getLightGrey6Color,
                                                    ),
                                                    child: Text( TextConst.deleteText,
                                                      style: interSemiBold.copyWith(
                                                          fontSize: width*0.04, color: ThemeManager().getLightGrey7Color),
                                                    ))),
                                          ),
                                        ],
                                      ),
                                    ),


                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator(),);
                    }
                  }),
            ),
          ),
          Align(alignment: Alignment.bottomCenter,child: AppBottomNavigationar(context: context).getNavigationBar(level: 0),),
        ],
      ),

      // Stack(children: [
      //   Positioned(top: 0,left: 0,right: 0,bottom:(height * 0.075) ,child: w),
      //   Align(alignment: Alignment.bottomCenter,child: bottomNav,),
      //
      // ],)

    ),);


  }

  void stopAndSave() {
    isRecordingSomething = false;
    widget.controller.stopVideoRecording().then((value) {
      //widget._image = File(value.path);

      //  String base64Image = base64Encode(widget._image.readAsBytesSync());

      try {
        // String base64Image = base64Encode(widget._image.readAsBytesSync());
        List imageParts = [];
        //  int mid = (base64Image.length/2).ceil();
        //imageParts.add(base64Image.substring(0,mid));
        //imageParts.add(base64Image.substring(mid,base64Image.length));
        // if (true) {
        //   int gap = (1000 * 1000);
        //   int iteration = (base64Image.length / gap).ceil();
        //   for (int i = 0; i < iteration; i++) {
        //     if (base64Image.length > (((i * gap) + gap)))
        //       imageParts
        //           .add(base64Image.substring(i * gap, (((i * gap) + gap))));
        //     else
        //       imageParts
        //           .add(base64Image.substring(i * gap, base64Image.length));
        //   }
        // } else {
        //   imageParts.add(base64Image);
        // }

        uploadVideos(
            widget.id,
            [
              {
                "imagePath": value.path,
                //"image": imageParts,
                "time": new DateTime.now().millisecondsSinceEpoch
              }
            ],
            widget.customerFirestore)
            .then((value) {});
        //upload now
        //   widget.photos.add({"imagePath":image.path,"image":imageParts,"time":new DateTime.now().millisecondsSinceEpoch});
      } catch (e) {
        //  showMessage(context, "error occured");
      }
    });
  }

  prepareVideoThumb(param0) {}

  int fetchLastTime(List data) {
    int val = 0;
    if (data.length > 0) {
      for (int i = 0; i < data.length; i++) {
        val = val + int.parse(data[i]["time_duration"].toString());
      }
      return val;
    } else
      return 0;
  }

  List<double> prepareData(List data) {
    List<double> allY = [];
    for (int i = 0; i < data.length; i++) {
      allY.add(data[i]["value"]);
    }
    List<double> ypos = [10.0, 40.0, 100.0, 60.0, 40.0, 55.0, 200.0];
    return allY;
  }

  void initTitleCheckListener() {
    widget.customerFirestore
        .collection("pulltest")
        .doc(widget.id)
        .get()
        .then((value) {
      if (value.get("name").toString().contains("auto_generated")) {
        //show bottomshett to update title
        TextEditingController controller;
        controller = new TextEditingController(
            text: widget.snapshotHistoryItem["name"]
                .toString()
                .replaceAll("auto_generated", ""));
        controller.selection =
            TextSelection(baseOffset: 0, extentOffset: controller.text.length);

        if (lastInfo != null) {
          controller = new TextEditingController(
              text: lastInfo
                  .get("name")
                  .toString()
                  .replaceAll("auto_generated", ""));
        }

        Navigator.of(context).push(new MaterialPageRoute<Null>(
            builder: (BuildContext context) {
              return Scaffold(
                appBar: AppBar(
                  title: Text("Update"),
                ),
                body: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 247, 247, 247),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Wrap(
                      children: [
                        Text(
                          "Update Title",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: controller,
                            autofocus: true,
                            decoration: InputDecoration(
                              labelText: 'Title',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            widget.customerFirestore
                                .collection("pulltest")
                                .doc(widget.id)
                                .update({"name": controller.text}).then(
                                    (value) {
                                  Navigator.pop(context);
                                });
                          },
                          child: Card(
                            color: Theme.of(context).primaryColor,
                            child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "Submit",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
            fullscreenDialog: true));
      }
    });
  }

  Widget dividingLine(){
    return  Container(
      // margin: EdgeInsets.only(top: height*0.02),
      color:ThemeManager().getBlackColor.withOpacity(.15),
      height: height*0.001,
      width: double.infinity,
    );
  }

  Widget mapView(double lat, double long) {
    return Stack(
      children: [
        Container(
          height: height * 0.28,
          width: double.infinity,
          child:   FutureBuilder<BitmapDescriptor>(
              future: BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/icons/mapMarker1Icon.png'),
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  return   TestPerformUiComponents().mapSegmentPutmarkerOnly(snapshot.data!,lat,long);

                }else{
                  return Container(width: 0,height: 0,child: CircularProgressIndicator());
                }
              }),
        ),
        Container(
          height:height*0.08,
          width: width,
          margin: EdgeInsets.only(top: height*0.18,left: width*0.06,right: width*0.06),
          decoration: BoxDecoration(
              color: ThemeManager().getWhiteColor,
              borderRadius: BorderRadius.circular(10)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      "Lat",style: interMedium.copyWith(
                      color: ThemeManager().getBlackColor,
                      fontSize: width * 0.040)
                  ),
                  Text(lat.toStringAsFixed(5),style: interRegular.copyWith(
                      color: ThemeManager().getDarkGreenColor,
                      fontSize: width * 0.040)
                  ),
                ],
              ),
              Container(
                color: ThemeManager().getBlackColor,
                height: height*0.05,
                width: width*0.001,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      "Long",style: interMedium.copyWith(
                      color: ThemeManager().getBlackColor,
                      fontSize: width * 0.040)
                  ),
                  Text(
                      long.toStringAsFixed(5),style: interRegular.copyWith(
                      color: ThemeManager().getDarkGreenColor,
                      fontSize: width * 0.040)
                  ),
                ],
              )
            ],
          ),

        )
      ],
    );
  }
  void reset() {
    if (_isRecording) {
      duration = countdownDuration;
    } else {
      duration = Duration();
    }
  }


  void addTime() {
    final addSeconds = _isRecording ? 1 : -1;

    final seconds = duration.inSeconds + addSeconds;
    if (seconds < 0) {
      timer?.cancel();
    } else {
      duration = Duration(seconds: seconds);
    }

    if(duration.inSeconds> 19 ){
      RecordRunningTimeStream.getInstance().dataReload(-1);
      _controller.stopVideoRecording().then((value) {
        _isRecording = false;
        RecordingStartedStoppedStream.getInstance().dataReload(false);
        //stopTimer();

        //uploadPhotos
        AppFirestore(firestore:  widget.customerFirestore, projectId: '', auth: FirebaseAuth.instance). uploadVideos(
          widget.id,
          [
            {
              "imagePath":value.path,
              //"image": imageParts,
              "time": new DateTime.now()
                  .millisecondsSinceEpoch
            }
          ],
        )
            .then((value) {});
      });
    }else{
      RecordRunningTimeStream.getInstance().dataReload(duration.inSeconds);
    }
  }

  void stopTimer({bool resets = true}) {
    if (resets) {
      reset();
    }
    timer?.cancel();
  }
  void startTimer() {
    try{
      timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
    }catch(e){

    }
  }

  void listenCamerStatus() {
    VideoPhotoToggleStream.getInstance().outData.listen((event) {

      setState(() {
        _isSelectForPhoto = event;
        isSelected = !event;
      });

    });
  }

}  //------------------------------------Target Value Data-------------------------
Widget targetValueData(String dataname,String value)
{
  return Container(height: 50,
    margin: EdgeInsets.only(left: width*0.06,right:width*0.06 ),
    child: Stack(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child:Text(
              dataname,style: interMedium.copyWith(
              color: ThemeManager().getBlackColor,
              fontSize: width * 0.042)
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child:Text(
              value,style: interMedium.copyWith(
              color: ThemeManager().getDarkGreenColor,
              fontSize: width * 0.042)
          ),
        ),
      ],
    ),
  );
}
