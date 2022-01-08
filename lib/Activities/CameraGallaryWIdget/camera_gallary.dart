import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:core';
import 'dart:core';
import 'dart:ffi';
import 'dart:io';
import "dart:typed_data";
import 'package:camera/camera.dart';
import 'package:connect/Activities/CustomerUserHome/HomePager/appbar.dart';
import 'package:connect/Activities/TestMapScreen/testMapScreen.dart';
import 'package:connect/screens/home.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/colorConst.dart';
import 'package:connect/utils/textConst.dart';
import 'package:connect/utils/textStyleConst.dart';
import 'package:connect/utils/themeManager.dart';
import 'package:convert/convert.dart';
 import 'package:flutter_svg/svg.dart';
 import 'package:connect/labels/appLabels.dart';
import 'package:connect/localization/language/languages.dart';
import 'package:connect/pages/pion.dart';
import 'package:connect/pages/settigs_page.dart';
import 'package:connect/services/Firestoredatabase.dart';
import 'package:connect/services/StorageManager.dart';
import 'package:connect/services/os_dependent_settings.dart';
import 'package:connect/services/themeManager.dart';
import 'package:connect/streams/buttonStreams.dart';
import 'package:connect/widgets/appwidgets.dart';
 import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:connect/pages/TestPeromationActivity.dart';
import 'package:connect/screens/CallWidget.dart';
import 'package:connect/services/Signal.dart';
import 'package:connect/widgets/cu.dart';
import 'package:image_picker/image_picker.dart';
 import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:share/share.dart';
import 'dart:ui' as ui;
 import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:connect/models/SavedData.dart';
import 'package:connect/models/todo.dart';
import 'package:connect/pages/TestDetailsPage.dart';
import 'package:connect/pages/app_map_view.dart';
import 'package:connect/pages/connected_device_page.dart';
import 'package:connect/pages/graph_3.dart';
import 'package:connect/pages/home_page.dart';
import 'package:connect/pages/map_view.dart';
import 'package:connect/pages/perform_test.dart';
import 'package:connect/services/auth.dart';
import 'package:connect/services/database.dart';
import 'package:connect/services/restApi.dart';
import 'package:connect/services/show_widgets.dart';
import 'package:connect/widgets/lists_widgets.dart';
import 'package:connect/widgets/todo_card.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';


import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../../Storage.dart';
import '../../widgets.dart';


class CameraGallaryActivity extends StatefulWidget {



  CameraGallaryActivity();

  @override
  _CameraGallaryActivityState createState() => _CameraGallaryActivityState();
}

class _CameraGallaryActivityState extends State<CameraGallaryActivity>  {
  int stage = 0 ;

  bool? isSelected = false;
  XFile? imageFile;
  bool? _isSelectForPhoto;
  List<String> imageList = [];
  List newImageList = [];
  ScrollController _scrollController = ScrollController();
  var camera;
  late CameraController _controller;
  Future<void>? _initializeControllerFuture;
  List<CameraDescription> cameras = [];
  bool _isRecording = false;
  static const countdownDuration = Duration(minutes: 0);
  Duration duration = Duration();
  Timer? timer;

  bool countDown = true;

  var loadValue = "0";
  var secondValue = "0";
  var loadUnitValue = "kN";


  int selectedPosition = 0;

  //TextEditingController controllerLoad = new TextEditingController();
  int selectedTime = 0;

  bool didLimitKnExceed = false;
  String index2 = "";
  String index6 = "";






  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //initMemoryOfLastTest();

    initCamera();
  }
  late AppLifecycleState _notification;


  @override
  void dispose() {
    timer!.cancel();
    _controller.dispose();

    super.dispose();
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
                margin: EdgeInsets.only(top: height * 0.035),
                height: height * 0.19,
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
                      //  height: height * 0.19,
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
                              if (imageList.length >= 5)
                                _scrollController.animateTo(width,
                                    duration: Duration(seconds: 2),
                                    curve: Curves.easeIn);
                            });
                            File media = File(value.path);
                            imageList.add(media.path);
                            newImageList.add(media);
                            //log(imageList.toString());
                          });
                        } else {
                          if (_isRecording == false) {
                            _controller.startVideoRecording().then((value) {
                              setState(() {
                                _isRecording = true;
                              });
                              startTimer();
                            });
                          } else {
                            _controller.stopVideoRecording().then((value) {
                              setState(() {
                                imageFile = value;
                                _isRecording = false;
                                if (imageList.length >= 5)
                                  _scrollController.animateTo(width,
                                      duration: Duration(seconds: 2),
                                      curve: Curves.easeIn);
                              });
                              File media = File(value.path);
                              imageList.add(media.path);
                              newImageList.add(media);
                              // log(imageList.toString());
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
                    // Column(
                    //   children: [
                    //     Container(
                    //       margin: EdgeInsets.only(
                    //           left: width * 0.65, top: height * 0.015),
                    //       child: FlutterSwitch(
                    //         activeColor: ThemeManager().getWhiteColor,
                    //         inactiveColor: ThemeManager().getWhiteColor,
                    //         width: width * 0.16,
                    //         height: height * 0.045,
                    //         toggleSize: 45.0,
                    //         value: isSelected!,
                    //         padding: 1.0,
                    //         activeIcon: Container(
                    //           padding: EdgeInsets.all(8),
                    //           decoration: BoxDecoration(
                    //               boxShadow: [
                    //                 BoxShadow(
                    //                   blurRadius: 5,
                    //                   color: Colors.grey,
                    //                 )
                    //               ],
                    //               color: ThemeManager().getWhiteColor,
                    //               shape: BoxShape.circle),
                    //           child: InkWell(
                    //             onTap: () {
                    //               setState(() {
                    //                 _isSelectForPhoto = true;
                    //               });
                    //               if (_isSelectForPhoto == true) {
                    //                 //_getFromVideo();
                    //                 Navigator.of(context).pop();
                    //               }
                    //             },
                    //             child: Icon(
                    //               Icons.video_call,
                    //               color: ThemeManager().getDarkGreenColor,
                    //             ),
                    //           ),
                    //         ),
                    //         inactiveIcon: Container(
                    //           padding: EdgeInsets.all(8),
                    //           decoration: BoxDecoration(
                    //               boxShadow: [
                    //                 BoxShadow(
                    //                   blurRadius: 5,
                    //                   color: Colors.grey,
                    //                 )
                    //               ],
                    //               color: ThemeManager().getWhiteColor,
                    //               shape: BoxShape.circle),
                    //           child: Icon(
                    //             Icons.camera_alt_outlined,
                    //             color: ThemeManager().getDarkGreenColor,
                    //           ),
                    //         ),
                    //         onToggle: (val) {
                    //           setState(() {
                    //             isSelected = val;
                    //           });
                    //         },
                    //       ),
                    //     )
                    //   ],
                    // ),
                  ],
                ),
              ),
              imageFile == null
                  ? Container()
                  : Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(imageList.length, (index) {
                        return Container(
                          height: height * 0.07,
                          width: width * 0.18,
                          child: imageList[index].endsWith(".jpg")
                              ? Image.file(
                            File(imageList[index]),
                            fit: BoxFit.cover,
                          )
                              : Container(
                            child: Center(
                              child: VideoPlay(
                                file: File(imageList[index]),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  imageList.length >= 5
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
              )
            ],
          );
        } else {
          return CircularProgressIndicator(color: Colors.yellow,);
        }
      },
    );
  }
  Future<bool> _willPopCallback() async {
    print("will pop pressed");

    // await showDialog or Show add banners or whatever
    // then
    return false; // return true if the route to be popped
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
      //_controller.lockCaptureOrientation(DeviceOrientation.landscapeLeft);

      // Next, initialize the controller. This returns a Future.
      _initializeControllerFuture = _controller.initialize();
    });
  }
  @override
  Widget build(BuildContext context) {
    return   camaraGalleryView();




  }

  void initMemoryOfLastTest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? oldTimer = prefs.getInt("timer");
    if (oldTimer == null || oldTimer == 0 || oldTimer == 30) {
      setState(() {
        selectedPosition = 0;
        selectedTime = 30;
      });
    } else if (oldTimer == 60) {
      setState(() {
        selectedPosition = 1;
        selectedTime = 60;
      });
    } else {
      setState(() {
        selectedPosition = 2;
        selectedTime = oldTimer;
      });
    }
  }



  void startTimer() {
    try{
      timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
    }catch(e){

    }
  }

  void reset() {
    if (countDown) {
      setState(() => duration = countdownDuration);
    } else {
      setState(() => duration = Duration());
    }
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

  reloadScreen () async {
    print("Reload");initState();
    setState(() {
      imageList.clear();
    });
    setState(() {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        _scrollController
            .animateTo(_scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 500), curve: Curves.ease)
            .then((value) async {
        });
      });
    });
  }

}