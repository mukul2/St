import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
 import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:connect/components/appBarCustom.dart';
import 'package:connect/components/buttonView.dart';
import 'package:connect/screens/popup/deleteTestPopUp.dart';
import 'package:connect/screens/testMapScreen.dart';
import 'package:connect/screens/viewTestsScreen.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/textConst.dart';
import 'package:connect/utils/textStyleConst.dart';
import 'package:connect/utils/themeManager.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TestReviewScreen extends StatefulWidget {

  TestReviewScreen({Key? key,}) : super(key: key);

  @override
  _Test262ScreenState createState() => _Test262ScreenState();
}

class _Test262ScreenState extends State<TestReviewScreen> {

  LatLng? currentPosition;
  CameraPosition? defaultLocation;
  BitmapDescriptor? markerIcon;
  Set<Marker> _markers = {};

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

  //------------------set marker image-------------
  Future<void> setMarkerIcon() async {
    markerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/icons/mapMarker1Icon.png');
  }

  //------------------set marker location---------
  void getUserLocation() async {

    setState(() {
      defaultLocation = CameraPosition(
        target: LatLng(52.4622548, -2.1698419),
        zoom: 14.4746,
      );
      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId('id-1'),
            position: LatLng(52.4622548, -2.1698419),
            icon: markerIcon!,
            infoWindow:
            InfoWindow(title: "You are here!", snippet: "You are here!"),
          ),
        );
      });
    });
  }

  //----------------Init camera
  void initCamera() async {

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
  void initState() {
    super.initState();

    setMarkerIcon().then((value) {
      getUserLocation();
    });

    initCamera();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ThemeManager().getWhiteColor,

      //---------------------------Appbar of screen------------------
      appBar: PreferredSize(
        preferredSize: Size(0, kToolbarHeight),
        child: AppBarCustom(appbarTitle: "Test#262"),
      ),

      //-------------------Body of screen--------------
      body: SingleChildScrollView(
        child: Column(
          children: [

            //-----------------------------Title Text field-------------------------
            Container(
              margin: EdgeInsets.only(
                  top: height * 0.025, left: width * 0.04, right: width * 0.04),

              child:Column(
                children: [

                  //----------------------Test result View----------
                  testResultPass(),

                  //-----------------Chart data view-----------
                  chartView(),

                  //----------------Title and Notes Text fields------
                  textFieldsView(),
                ],
              ),
            ),

            //--------------------------Test result data value-----------------------
            dividingLine(),
            targetValueData("Target Value: ","6.0 kN" ),
            dividingLine(),
            targetValueData("Max Value: ","7.1 kN at 00:13 " ),
            dividingLine(),
            targetValueData("Timed Section Started: ","00:24 " ),
            dividingLine(),
            targetValueData("Timed Section Finished:","00:24" ),
            dividingLine(),
            targetValueData("Timed Section Length:  ","00:10" ),
            dividingLine(),
            targetValueData("Device SN: "," RH1" ),
            dividingLine(),
            targetValueData("Next Calibration Date: "," " ),
            dividingLine(),

            //---------------------Pick image or video view-----------
            Container(
                margin: EdgeInsets.only(left: width*0.05,right: width*0.05),
                child: camaraGalleryView()),

            //---------------------------Map view-----------------------------
            Container(
              margin: EdgeInsets.only(top: height*0.02),
              child: mapView(),
            ),

            //--------------------------Update Button-----------------------
            GestureDetector(
              onTap: (){
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
               // showDialog(context: context, builder: (context)=> DeleteTestPopUp());
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
    );
  }

  //-----------------------------------Test Result Pass Button--------------------
  Widget testResultPass(){
    return   Container(
      margin: EdgeInsets.only(bottom: height*0.02),
      decoration: new BoxDecoration(
        color:ThemeManager().getLightGreenColor,
      ),
      padding: EdgeInsets.symmetric(horizontal: 15),
      alignment: Alignment.center,
      height: height*0.060,
      width: width,

      child: Text(
          "Test Result Pass",style: interMedium.copyWith(
          color: ThemeManager().getDarkGreenColor,
          fontSize: width * 0.042)
      ),
    );
  }

  //------------------------------------Chart View------------------------------
  Widget chartView(){
    return  Container(
        color: ThemeManager().getWhiteColor,
        height: height*0.22,
        child: SfCartesianChart(
            primaryXAxis: DateTimeAxis(),
            series: <ChartSeries>[
              // Renders line chart
              LineSeries<SalesData, DateTime>(
                  color: ThemeManager().getDarkGreenColor,
                  dataSource: chartData,
                  xValueMapper: (SalesData sales, _) => sales.year,
                  yValueMapper: (SalesData sales, _) => sales.sales
              )
            ]
        )
    );
  }

  //------------------------Title and Notes Text fields-------------
  Widget textFieldsView() {
    return Column(
      children: [

        //---------------Title text field-------------
        Container(
          margin: EdgeInsets.only(top: height*0.024),
          alignment: Alignment.topLeft,
          child:Text(
              "Title",style: interMedium.copyWith(
              color: ThemeManager().getPopUpTextGreyColor,
              fontSize: width * 0.041)
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: height * 0.015),
          child: TextFormField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: "25-June 2021 9:46",
              hintStyle: interMedium.copyWith(
                color: ThemeManager().getLightGrey1Color,
                fontSize: width * 0.040,),
              suffixIcon: Image(image:AssetImage('assets/icons/editIcon.png',),
                color: ThemeManager().getDarkGreenColor,),
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(width * 0.014)),
              contentPadding: EdgeInsets.symmetric(
                  vertical: height * 0.016, horizontal: width * 0.045),
              fillColor: ThemeManager().getLightGreenTextFieldColor,
              filled: true,

            ),
          ),
        ),

        //-----------------Notes Text field-------------------------
        Container(
          margin: EdgeInsets.only(top: height*0.02),
          alignment: Alignment.topLeft,
          child:Text(
              "Notes",style: interMedium.copyWith(
              color: ThemeManager().getPopUpTextGreyColor,
              fontSize: width * 0.041)
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: height * 0.015),
          child: TextField(
            maxLines: 7,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              suffixIcon: Container(
                margin: EdgeInsets.only(bottom: height*0.10),
                child: Image(image:AssetImage('assets/icons/editIcon.png',),
                  color: ThemeManager().getDarkGreenColor,),
              ),
              hintStyle: interMedium.copyWith(
                color: ThemeManager().getLightGrey1Color,
                fontSize: width * 0.040,),
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(width * 0.014)),
              contentPadding: EdgeInsets.symmetric(
                  vertical: height * 0.0, horizontal: width * 0.045),
              fillColor: ThemeManager().getLightGreenTextFieldColor,
              filled: true,
            ),
          ),
        ),
      ],
    );
  }

  //------------------------------------Target Value Data-------------------------
  Widget targetValueData(String dataname,String value)
  {
    return Container(
      margin: EdgeInsets.only(top: height*0.02,left: width*0.06),
      child: Row(
        children: [
          Container(
            alignment: Alignment.topLeft,
            child:Text(
                dataname,style: interMedium.copyWith(
                color: ThemeManager().getBlackColor,
                fontSize: width * 0.042)
            ),
          ),
          Container(
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

  //------------------------------------Dividing Line----------------------------
  Widget dividingLine(){
    return  Container(
      margin: EdgeInsets.only(top: height*0.02),
      color:ThemeManager().getBlackColor.withOpacity(.15),
      height: height*0.001,
      width: double.infinity,
    );
  }

  //---------------------Pick image or video view---------------
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
                    Container(
                        height: height * 0.19,
                        width: double.infinity,
                        child: CameraPreview(_controller)),

                    isSelected == true && _isRecording == true
                        ? Positioned(
                      top: height * .02,
                      child: Container(
                        child: Text(
                          minutes + ":" + seconds,
                          style: TextStyle(
                            color: ThemeManager().getWhiteColor,
                          ),
                        ),
                      ),
                    )
                        : Container(),

                    //-----------------Camera button to capture image or video-------
                    cameraCaptureButton(),

                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              left: width * 0.65, top: height * 0.015),

                          //---------Switch button to capture camera or video------
                          child: switchCameraOrVideo(),
                        )
                      ],
                    ),
                  ],
                ),
              ),

              Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [

                  //-----------------List of captured image or video-------------
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

                  //---------------Buttons to scroll imageVideo list-------
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
                                color: ThemeManager().getWhiteColor,
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
                              color: ThemeManager().getBlackColor,
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
                                    color: ThemeManager()
                                        .getLightGrey1Color,
                                    spreadRadius: .25,
                                  )
                                ]),
                            padding:
                            EdgeInsets.only(left: width * .004),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: ThemeManager().getBlackColor,
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

  Widget mapView() {
    return Stack(
      children: [
        Container(
          height: height * 0.28,
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
          ),
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
                  Text(
                      "52.4622548",style: interRegular.copyWith(
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
                      "-2.1698419",style: interRegular.copyWith(
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

  Widget switchCameraOrVideo(){
    return Container();
    // return FlutterSwitch(
    //   activeColor: ThemeManager().getWhiteColor,
    //   inactiveColor: ThemeManager().getWhiteColor,
    //   width: width * 0.16,
    //   height: height * 0.045,
    //   toggleSize: 45.0,
    //   value: isSelected!,
    //   padding: 1.0,
    //   activeIcon: Container(
    //     padding: EdgeInsets.all(8),
    //     decoration: BoxDecoration(
    //         boxShadow: [
    //           BoxShadow(
    //               blurRadius: 5,
    //               color: ThemeManager().getLightGrey1Color
    //           )
    //         ],
    //         color: ThemeManager().getWhiteColor,
    //         shape: BoxShape.circle),
    //     child: InkWell(
    //       onTap: () {
    //         setState(() {
    //           _isSelectForPhoto = true;
    //         });
    //         if (_isSelectForPhoto == true) {
    //           //_getFromVideo();
    //           Navigator.of(context).pop();
    //         }
    //       },
    //       child: Icon(
    //         Icons.video_call,
    //         color: ThemeManager().getDarkGreenColor,
    //       ),
    //     ),
    //   ),
    //   inactiveIcon: Container(
    //     padding: EdgeInsets.all(8),
    //     decoration: BoxDecoration(
    //         boxShadow: [
    //           BoxShadow(
    //               blurRadius: 5,
    //               color: ThemeManager().getLightGrey1Color
    //           )
    //         ],
    //         color: ThemeManager().getWhiteColor,
    //         shape: BoxShape.circle),
    //     child: Icon(
    //       Icons.camera_alt_outlined,
    //       color: ThemeManager().getDarkGreenColor,
    //     ),
    //   ),
    //   onToggle: (val) {
    //     setState(() {
    //       isSelected = val;
    //     });
    //   },
    // );
  }

  Widget cameraCaptureButton(){
    return GestureDetector(
      onTap: () {
        if (isSelected == false) {
          _controller.takePicture().then((value) {
            setState(() {
              imageFile = value;
              _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent +
                      (width * 0.18),
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
                _scrollController.animateTo(
                    _scrollController
                        .position.maxScrollExtent +
                        (width * 0.18),
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
          color: ThemeManager().getWhiteColor,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(color: ThemeManager().getBlackColor,),
          height: height * .02,
          width: height * .02,
        ),
      )
          : Icon(
        Icons.circle_outlined,
        color: ThemeManager().getWhiteColor,
        size: height * .08,
      ),
    );
  }

  //----------------------------Chart data-----------------------
  final List<SalesData> chartData = [
    SalesData(DateTime(2010), 35),
    SalesData(DateTime(2011), 20),
    SalesData(DateTime(2012), 34),
    SalesData(DateTime(2013), 28),
    SalesData(DateTime(2014), 40),
    SalesData(DateTime(2015), 28),
    SalesData(DateTime(2016), 40),
    SalesData(DateTime(2017), 20),
    SalesData(DateTime(2018), 34),
    SalesData(DateTime(2019), 28),
    SalesData(DateTime(2020), 40),
    SalesData(DateTime(2021), 20),
    SalesData(DateTime(2022), 34),
    SalesData(DateTime(2023), 35),
    SalesData(DateTime(2024), 20),
    SalesData(DateTime(2025), 34),
    SalesData(DateTime(2026), 28),
    SalesData(DateTime(2027), 40),
    SalesData(DateTime(2028), 20),
    SalesData(DateTime(2029), 34),
    SalesData(DateTime(2030), 35),
    SalesData(DateTime(2031), 20),
    SalesData(DateTime(2032), 34),
    SalesData(DateTime(2033), 28),
    SalesData(DateTime(2034), 40),
  ];

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

class SalesData {
  SalesData(this.year, this.sales);
  final DateTime year;
  final double sales;
}
