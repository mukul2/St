import 'dart:async';
import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:connect/screens/testMapScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
 import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:connect/components/appBarCustom.dart';
import 'package:connect/screens/popup/editTargetLoadAndTimePopUp.dart';
import 'package:connect/screens/testScreen.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/colorConst.dart';
import 'package:connect/utils/textConst.dart';
import 'package:connect/utils/textStyleConst.dart';
import 'package:connect/utils/themeManager.dart';
import 'package:video_player/video_player.dart';
import 'package:geolocator/geolocator.dart' as lo;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';



class TestMapScreen extends StatefulWidget {
  const TestMapScreen({Key? key}) : super(key: key);

  @override
  _TestMapScreenState createState() => _TestMapScreenState();
}

class _TestMapScreenState extends State<TestMapScreen> {
  bool? isSelected = false;
  XFile? imageFile;
  Set<Marker> _markers = {};
  LatLng? currentPosition;
  CameraPosition? defaultLocation;
  BitmapDescriptor? markerIcon;
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

  var loadValue = "21";
  var secondValue = "54";
  var loadUnitValue = "kN";

// used to set a markers on the map.
  Future<void> setMarkerIcon() async {
    markerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/icons/mapMarker1Icon.png');
  }

  void getUserLocation() async {
    var position = await GeolocatorPlatform.instance.getCurrentPosition(desiredAccuracy: lo.LocationAccuracy.high);

    setState(() {
      defaultLocation = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        // target: LatLng(21.2315, 72.8663),
        zoom: 14.4746,
      );
      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId('id-1'),
            position: LatLng(position.latitude, position.longitude),
            icon: markerIcon!,
            infoWindow:
            InfoWindow(title: "You are here!", snippet: "You are here!"),
          ),
        );
      });
    });
  }

// This function used to detect the available cameras in device and add the back camera description to the controller of camera.
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
  void dispose() {
    super.dispose();
   // _controller?.dispose();
    print("dispose");
    camera?.dispose();
  }


  @override
  void initState() {
    super.initState();
    reset();

    // _cameraController.

    setMarkerIcon().then((value) async {
      getUserLocation();

      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    });

    initCamera();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    super.reassemble();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            //-------------------------Appbar of screen------------------------
            AppBarCustom(appbarTitle: TextConst.testAppbarText),

            //------------------------Body of screen--------------------------
            Container(
              margin: EdgeInsets.only(
                  left: width * 0.05, right: width * 0.05, top: height * 0.03),
              child: Column(
                children: [
                  //------------------------map view-----------------
                  mapView(),

                  //-----------------test data - time and load-------------
                  editTestLoadAndTimeView(),

                  //------------------choose image----------------------
                  camaraGalleryView(),

                  //------------------play button view-------------------
                  playButton(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  //------------------------------------map view------------------------------
  Widget mapView() {
    return Container(
        height: height * 0.20,
        width: double.infinity,
        child: (defaultLocation != null)
            ? GoogleMap(
          mapType: MapType.normal,
          zoomControlsEnabled: false,
          initialCameraPosition: defaultLocation!,
          markers: _markers,
        )
            : Center(
          child: CircularProgressIndicator(),
        ));
  }

  //-------------------Edit target load and time view-------------
  Widget editTestLoadAndTimeView() {
    return Container(
      height: height * 0.06,
      margin: EdgeInsets.only(top: height * 0.03),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: ThemeManager().getWhiteColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: ThemeManager().getLightGrey3Color,
            )
          ]),
      child: Row(
        children: [
          //---------Load icon---------
          Container(
            margin: EdgeInsets.only(left: width * 0.06, right: width * 0.02),
            child: SvgPicture.asset(
              ("assets/svg/loadIcon.svg"),
              height: height * 0.03,
              color: ThemeManager().getBlackColor,
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: width * 0.14,
                  ),

                  //-----------Load value---------
                  child: Text(
                    loadValue,
                    style: interBold.copyWith(
                        color: ThemeManager().getBlackColor,
                        fontSize: width * 0.045),
                  ),
                ),

                //-----------Load unit------------
                Container(
                  margin: EdgeInsets.only(right: width * 0.04),
                  child: Text(
                    " " + loadUnitValue,
                    style: interRegular.copyWith(
                        color: ThemeManager().getBlackColor,
                        fontSize: width * 0.035),
                  ),
                ),

                //----------Time icon----------
                Container(
                  margin:
                  EdgeInsets.only(left: width * 0.07, right: width * 0.02),
                  child: SvgPicture.asset(
                    ("assets/svg/timeIcon.svg"),
                    height: height * 0.025,
                    color: ThemeManager().getBlackColor,
                    fit: BoxFit.cover,
                  ),
                ),

                // //---------Time Minute value---------
                // Container(
                //   child: Text(
                //     minuteValue,
                //     style: interBold.copyWith(
                //         color: ThemeManager().getBlackColor,
                //         fontSize: width * 0.045),
                //   ),
                // ),
                // Text(
                //   "m  ",
                //   style: interRegular.copyWith(
                //       color: ThemeManager().getBlackColor,
                //       fontSize: width * 0.035),
                // ),

                //----------time Second value-------
                Container(
                  child: Text(
                    secondValue,
                    style: interBold.copyWith(
                        color: ThemeManager().getBlackColor,
                        fontSize: width * 0.045),
                  ),
                ),
                Text(
                  " sec",
                  style: interRegular.copyWith(
                      color: ThemeManager().getBlackColor,
                      fontSize: width * 0.035),
                ),
              ],
            ),
          ),

          //---------------------Edit Test Load and Time value------------------
          GestureDetector(
            onTap: () {
              // showDialog(
              //     context: context,
              //     builder: (context) => EditTargetLoadAndTimePopUp(sharedPreferences: null,forceMode: "kN",oldTime: "0",oldLoad: "0",
              //       loadUnitValueCallback: (loadUnitVal) {
              //         setState(() {
              //           loadUnitValue = loadUnitVal;
              //         });
              //       },
              //       secondValueCallback: (loadVal) {
              //         setState(() {
              //           secondValue = loadVal;
              //         });
              //       },
              //       // minuteValueCallback: (minuteVal) {
              //       //   setState(() {
              //       //     minuteValue=minuteVal;
              //       //   });
              //       // },
              //       loadValueCallback: (loadVal) {
              //         setState(() {
              //           loadValue = loadVal;
              //         });
              //       },
              //     ));
            },
            child: Container(
              height: double.infinity,
              width: width * 0.16,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  gradient: LinearGradient(
                    colors: [
                      ThemeManager().getOrangeGradientColor,
                      ThemeManager().getYellowGradientColor,
                    ],
                  )),
              child: Image.asset('assets/icons/editIcon.png', scale: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  //------------------choose image----------------------
  Widget camaraGalleryView() {
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
                    // Container(
                    //     height: height * 0.19,
                    //     width: double.infinity,
                    //     child: CameraPreview(_controller)),
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
                              if (imageList.length >= 5)
                                _scrollController.animateTo(width,
                                    duration: Duration(seconds: 2),
                                    curve: Curves.easeIn);
                            });
                            File media = File(value.path);
                            imageList.add(media.path);
                            newImageList.add(media);
                            log(imageList.toString());
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
                        //   child:  FlutterSwitch(
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
                            fit: BoxFit.fill,
                          )
                              : VideoPlay(
                            file: File(imageList[index]),
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
          return CircularProgressIndicator();
        }
      },
    );
  }

  //------------------play button view-------------------
  Widget playButton() {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => TestScreen(
        //           imageListNew: imageList,
        //           secondData: secondValue,
        //           // minuteData: minuteValue,
        //           loadUnitData: loadUnitValue,
        //           loadData: loadValue,
        //         )));
      },
      child: Container(
        margin: EdgeInsets.only(top: height * 0.04),
        height: height * 0.065,
        width: width * 0.42,
        decoration: BoxDecoration(
            image: new DecorationImage(
              image: new ExactAssetImage('assets/icons/playButtonIcon.png',
                  scale: 1.0),
            ),
            borderRadius: BorderRadius.all(Radius.circular(50)),
            gradient: LinearGradient(
              colors: [
                ThemeManager().getOrangeGradientColor,
                ThemeManager().getYellowGradientColor,
              ],
            )),
      ),
    );
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
}