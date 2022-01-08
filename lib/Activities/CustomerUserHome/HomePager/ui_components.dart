import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

 import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/Activities/CameraToggleSwitch/cameraToggle.dart';
import 'package:connect/Appabr/appbar_widget.dart';
import 'package:connect/Toast/AppToast.dart';
import 'package:connect/services/Firestoredatabase.dart';
import 'package:connect/streams/buttonStreams.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/colorConst.dart';
import 'package:connect/utils/featureSettings.dart';
import 'package:connect/utils/textStyleConst.dart';
import 'package:connect/utils/themeManager.dart';
import 'package:connect/widgets/graph_with_selecttor.dart';
import 'package:connect/widgets/lists_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../logics.dart';
import 'logics.dart';


class MapViewOnDataCollectionActivity extends StatefulWidget {
  const MapViewOnDataCollectionActivity({Key? key}) : super(key: key);

  @override
  _MapViewOnDataCollectionActivityState createState() => _MapViewOnDataCollectionActivityState();
}

class _MapViewOnDataCollectionActivityState extends State<MapViewOnDataCollectionActivity> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Position?>(
        future:  GeolocatorPlatform.instance.getLastKnownPosition(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
            AppToast().show(message: snapshot.data.toString());
            String mapUri = "https://maps.googleapis.com/maps/api/staticmap?center=" +
                snapshot.data!.latitude
                    .toString() +
                "," +
                snapshot.data!.longitude
                    .toString() +
                "&zoom=8&size=" +
                ( width * 0.88).toStringAsFixed(0)+
                "x"+
                ( height * 0.21).toStringAsFixed(0)


                +"&maptype=normal"+
                "&markers=anchor:center|"+
                "icon:https%3A%2F%2Ffirebasestorage.googleapis.com%2Fv0%2Fb%2Fstaht-connect-322113.appspot.com%2Fo%2FmapMarker1Icon.png%3Falt%3Dmedia%26token%3D29e63d7e-2a40-46ec-ac38-740c4b22435d|"+
                snapshot.data!.latitude
                    .toString() +
                "," +
                snapshot.data!.longitude
                    .toString() +
                "&key=AIzaSyDOrDoiG0aLER7Y8cv2QhNr182Z0H5pMVw"+"&map_id="+(darkTheme?"90b3e5c6b64b6c5e":"");
            return      Container(
                height: height * 0.20,
                width: double.infinity,
                child: (snapshot.data != null)
                    ? Image.network(mapUri,fit: BoxFit.cover,)
                    : Center(
                  child:   Scaffold(body: Center(child: CircularProgressIndicator(color: Colors.redAccent,)),),
                ));
          }else  return Scaffold(body: Center(child: CircularProgressIndicator(color: Colors.redAccent,)),);

        });
  }
}

class CameraGallaryActivitySecond extends StatefulWidget {



  CameraGallaryActivitySecond();

  @override
  _CameraGallaryActivityState createState() => _CameraGallaryActivityState();
}

class _CameraGallaryActivityState extends State<CameraGallaryActivitySecond>  {
  int stage = 0 ;
  double maxZoom = 0;
  double minZoom = 0;
  double zoom = 1;
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
  Widget mapWidget  = Container(child: Center(child: Text("No Map Data"),),);

  var loadValue = "0";
  var secondValue = "0";
  var loadUnitValue = "";


  int selectedPosition = 0;

  //TextEditingController controllerLoad = new TextEditingController();
  int selectedTime = 0;

  bool didLimitKnExceed = false;
  String index2 = "";
  String index6 = "";

  final Map<int, Widget> logoWidgets = const <int, Widget>{
    0: Padding(
      padding: EdgeInsets.all(10),
      child: Text('30 Second'),
    ),
    1: Padding(
      padding: EdgeInsets.all(10),
      child: Text('60 Second'),
    ),
    2: Padding(
      padding: EdgeInsets.all(10),
      child: Text('Custom'),
    ),
  };



  @override
  void initState() {
    // TODO: implement initState
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    super.initState();
    //initMemoryOfLastTest();



    initCamera();
  }
  late AppLifecycleState _notification;


  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }



  Widget camaraGalleryView()  {
    return Text("OK");
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));





    try{
      return FutureBuilder(
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
                      gallaryPhotoAdd?   Positioned(left: 10,bottom: 10,child:      Padding(
                        padding: const EdgeInsets.all(8.0),
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

                                              // imageList.add(media.path);
                                              imageList.insert(0,image!.path);

                                              newImageList.add(image!.path);
                                              setState(() {
                                                imageFile = image;

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

                                              // imageList.add(media.path);
                                              imageList.insert(0,image!.path);

                                              newImageList.add(image!.path);
                                              setState(() {
                                                imageFile = image;

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
                      ),):Container(height: 0,width: 0,),
                      Wrap(
                          children:[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  if (isSelected == false) {
                                    _controller.takePicture().then((value) {
                                      setState(() {
                                        imageFile = value;

                                      });
                                      File media = File(value.path);
                                      // imageList.add(media.path);
                                      imageList.insert(0, media.path);

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

                                        });
                                        File media = File(value.path);
                                        // imageList.add(media.path);
                                        imageList.insert(0, media.path);
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
                            ),

                          ]
                      ),

                      Align(alignment: Alignment.topRight,child:  Container(
                        //width: width * 0.16,
                        // height: height * 0.045,
                        margin: EdgeInsets.only(
                            left: width * 0.65, top: height * 0.015,right: height * 0.015 ),
                        child: CameraToggle(isPhoto:!isSelected! ,isVideoSelected: (bool ) {
                          print("callbac came"+ bool.toString());

                          _isSelectForPhoto = !bool;
                          isSelected = bool;

                          // isSelected = bool;

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

                    ],
                  ),
                ),
                imageFile == null
                    ? Container()
                    : Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    SingleChildScrollView(physics: ClampingScrollPhysics(),
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
                                child: Icon(Icons.play_arrow,color: ThemeManager().getDarkGreenColor,),
                                //         child: VideoPlay(
                                //                file: File(imageList[index]),
                                // ),
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
                              // _scrollController.animateTo(0, duration: Duration(seconds: 2), curve: Curves.easeIn);
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
    }catch(e){
      return Center(child: Container(child: Center(child: Text("Failed to load camera"),),height: 200,width: 300,));
    }
  }
  Future<bool> _willPopCallback() async {
    print("will pop pressed");

    // await showDialog or Show add banners or whatever
    // then
    return false; // return true if the route to be popped
  }
  void initCamera() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Map<Permission, PermissionStatus> statuses = await [
    //   Permission.camera,
    //   Permission.storage,
    //   Permission.location,
    // ].request();
    // print(statuses[Permission.location]);


    if (true || await Permission.camera.request().isGranted && await Permission.camera.request().isGranted && await Permission.location.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      try{
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
          _initializeControllerFuture = _controller.initialize().then((value) async {
            maxZoom = await _controller.getMaxZoomLevel();
            minZoom = await _controller.getMinZoomLevel();
          });
        });
      }catch(e){
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
          _initializeControllerFuture = _controller.initialize().then((value) async {
            maxZoom = await _controller.getMaxZoomLevel();
            minZoom = await _controller.getMinZoomLevel();
          });
        });
      }
    }



  }
  @override
  Widget build(BuildContext context) {
    return camaraGalleryView();




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
    if(duration.inSeconds>19){
      _controller.stopVideoRecording().then((value) {
        setState(() {
          imageFile = value;
          _isRecording = false;

        });
        File media = File(value.path);
        imageList.insert(0, media.path);
        newImageList.insert(0, media);
        // log(imageList.toString());
        stopTimer();
      });
    }
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

  }

}
class HomePageUi{
  FirebaseFirestore firestore;
  String customerId;
  int itemPerPage = 15;
 // int selectedPage = 0;
  HomePageUi({required this.firestore,required this.customerId});
  Widget homePageRecentTests({required List<QueryDocumentSnapshot<Object?>> docsN,required BuildContext context,required Locale locale}){
    bool makeGraphFromLlb = false;


    return    FutureBuilder<BitmapDescriptor>(
        future: BitmapDescriptor.fromAssetImage(
            ImageConfiguration(), 'assets/icons/mapMarker1Icon.png'),
        builder: (context, snapshotMarker) {
          if(snapshotMarker.hasData){
            return ListView.builder(
              padding: EdgeInsets.zero,
              // itemCount:docsN.length>6?6:docsN.length,
              itemCount:docsN.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index)
              {
                QueryDocumentSnapshot dataToShow = docsN[docsN.length-1-index];
                Map<String, dynamic> dataAsMap = dataToShow.data() as Map<String, dynamic>;
               // MemoryImage mI = MemoryImage(base64Decode(dataAsMap["graphImage"]))
                Widget graphIMG = Container(height: height*0.22,
                  width: MediaQuery.of(context).size.width,
                  child: Image.memory(base64Decode(dataAsMap["graphImage"])),);
                return InkWell(onTap: (){
                  HomePageLogics(firestore:firestore ,context: context,locale: locale,customerId: customerId).testRecordClickedEvent(data: dataToShow,id:dataToShow.id, pos: 0 ,);
                  CustomerHomePageLogic().tabChangedStream.dataReload(0);
                },
                  child: Container(
                    margin: EdgeInsets.only(top: height*0.02),

                    child: Column(
                      children: [

                        //----------------------User profile image and name header------------------
                        Container(
                          margin: EdgeInsets.only(left: width*0.04),
                          child: Row(
                            children: [
                              //Image(image: AssetImage(homeScreenData[index]["userProfileImage"])),
                              CircleAvatar(),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: width*0.038),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(dataToShow.get("name"),maxLines: 1,
                                        style: interBold.copyWith(
                                            fontSize: width * 0.04),
                                      ),

                                      Container(

                                        margin: EdgeInsets.only(top: height*0.007),

                                        child: Text(DateFormat('hh:mm aa dd MMM yyyy',locale.languageCode)
                                            .format( true? DateTime.fromMillisecondsSinceEpoch(dataToShow["time"]):DateTime.fromMillisecondsSinceEpoch(dataToShow["time"])),
                                          style: interRegular.copyWith(
                                              fontSize: width * 0.03,
                                              color: ThemeManager().getBlackColor
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              // IconButton(
                              //   onPressed: (){},
                              //   splashRadius: 1,
                              //   icon: SvgPicture.asset("assets/svg/menuButtonIcon.svg"),
                              // ),
                            ],
                          ),
                        ),

                        //----------------------Measurements, time and result data------------------
                        Container(
                          margin: EdgeInsets.only(top: height * 0.01, left: width * 0.02),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: width * 0.04),
                                child: Column(
                                  children: [
                                    Container(
                                      height: width * 0.11,
                                      width: width * 0.11,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: ThemeManager().getLightBlueColor,
                                      ),
                                      child: Image(
                                          image: AssetImage(
                                              "assets/icons/peakLoadIcon.png")),
                                    ),
                                    Container(
                                        margin:
                                        EdgeInsets.only(top: height * 0.01),
                                        child: Row(
                                          children: [
                                            Text(dataToShow["loadMode"] == "kN"? dataToShow["max"].toString():dataToShow["max"].toInt().toString() ,
                                              style: interSemiBold.copyWith(
                                                  fontSize: width * 0.04),
                                            ),
                                            Container(
                                                margin: EdgeInsets.only(left: width*0.01),
                                                child: Text(getUnit(dataToShow),style: interRegular.copyWith(fontSize: width*0.031),))

                                          ],
                                        )),
                                    Container(
                                      margin:
                                      EdgeInsets.only(top: height * 0.005),
                                      child: Text("Peak Load",
                                          style: interRegular.copyWith(
                                              fontSize: width * 0.03,
                                              color: ThemeManager().getBlackColor)),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: width * 0.02),
                                child: Column(
                                  children: [
                                    Container(
                                      height: width * 0.11,
                                      width: width * 0.11,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: ThemeManager().getLightOrangeColor,
                                      ),
                                      child: Image(
                                          image: AssetImage(
                                              "assets/icons/targetLoadIcon.png")),
                                    ),
                                    Container(
                                        margin:
                                        EdgeInsets.only(top: height * 0.01),
                                        child: Row(
                                          children: [
                                            Text(dataToShow["loadMode"] == "kN"? dataToShow["targetLoad"].toString():dataToShow["targetLoad"].toInt().toString(),
                                              style: interSemiBold.copyWith(
                                                  fontSize: width * 0.04),
                                            ),
                                            Container(
                                                margin: EdgeInsets.only(left: width*0.01),
                                                child: Text(getUnit(dataToShow),style: interRegular.copyWith(fontSize: width*0.031),))

                                          ],
                                        )),
                                    Container(
                                        margin: EdgeInsets.only(
                                            top: height * 0.005),
                                        child: Text(
                                          "Target Load",
                                          style: interRegular.copyWith(
                                              fontSize: width * 0.03,
                                              color: ThemeManager().getBlackColor),
                                        )),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: width * 0.04),
                                child: Column(
                                  children: [
                                    Container(
                                      height: width * 0.11,
                                      width: width * 0.11,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: ThemeManager()
                                            .getLightBottleGreenColor,
                                      ),
                                      child: Image(
                                          image: AssetImage(
                                              "assets/icons/timeIcon.png")),
                                    ),
                                    Container(
                                        margin:
                                        EdgeInsets.only(top: height * 0.01),
                                        child: Row(
                                          children: [
                                            Text(
                                              dataToShow["targetDuration"].toString() ,
                                              style: interSemiBold.copyWith(
                                                  fontSize: width * 0.04),
                                            ),
                                            Container(
                                                margin: EdgeInsets.only(left: width*0.01),
                                                child: Text("secs",style: interRegular.copyWith(fontSize: width*0.031),))
                                          ],
                                        )),
                                    Container(
                                        margin: EdgeInsets.only(
                                            top: height * 0.005),
                                        child: Text(
                                          "Time",
                                          style: interRegular.copyWith(
                                              fontSize: width * 0.03,
                                              color: ThemeManager().getBlackColor),
                                        )),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: width * 0.07),
                                child: Column(
                                  children: [
                                    Container(
                                      height: width * 0.11,
                                      width: width * 0.11,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: dataToShow.get("startedLoad") == 0
                                            ?  Colors.yellow.withOpacity(0.3)
                                            : (dataToShow
                                            .get("startedLoad") >
                                            0
                                            ? (dataToShow
                                            .get("didPassed")
                                            ? Colors.green.withOpacity(0.1)
                                            : Colors.redAccent.withOpacity(0.1))
                                            :Colors.redAccent.withOpacity(0.1)) ,
                                      ),
                                      child:dataToShow.get("startedLoad") == 0
                                          ?  Container(

                                        child:Icon(Icons.warning_rounded,color: ThemeManager().getYellowGradientColor,),
                                      )
                                          : (dataToShow
                                          .get("startedLoad") >
                                          0
                                          ? (dataToShow
                                          .get("didPassed")
                                          ?  Image(image: AssetImage("assets/icons/passIcon.png"))
                                          :  Container(

                                        child: Icon(Icons.close_rounded,color: ThemeManager().getRedColor,),
                                      ))
                                          : Container(

                                        child:Icon(Icons.close_rounded,color: ThemeManager().getRedColor,),
                                      )) ,
                                      // child: Image(image: AssetImage("assets/icons/passIcon.png")),
                                    ),
                                    Container(
                                        margin:
                                        EdgeInsets.only(top: height * 0.01),
                                        child: dataToShow.get("startedLoad") == 0
                                            ? Text("Not Timed")
                                            : (dataToShow
                                            .get("startedLoad") >
                                            0
                                            ? (dataToShow
                                            .get("didPassed")
                                            ? Text(
                                          "Pass",
                                          style: interSemiBold.copyWith(
                                              fontSize: width * 0.04),
                                        )
                                            : Text("Fail",
                                            style: interSemiBold.copyWith(
                                                fontSize: width * 0.04)))
                                            : Text("Fail",
                                            style: interSemiBold.copyWith(
                                                fontSize: width * 0.04)))),
                                    Container(
                                        margin: EdgeInsets.only(
                                            top: height * 0.005),
                                        child: Text(
                                          "Result",
                                          style: interRegular.copyWith(
                                              fontSize: width * 0.03,
                                              color: ThemeManager().getBlackColor),
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        //----------------------Map image and other image slider-------------------
                        Container(
                          height: height*0.23,
                          margin: EdgeInsets.only(top: width*0.04),
                          child: FutureBuilder<QuerySnapshot>(
                              future: AppFirestore(firestore: firestore, auth: FirebaseAuth.instance,projectId: '').fetchCustomerUsersAllAttachmentFuture(testID:dataToShow.id),
                              // stream: fetchCustomerUsersAllAttachmentStream(
                              //     testID: widget.id,
                              //     firestore: widget.customerFirestore),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot>
                                  snapshotattachment) {
                                List<Widget> widgets = [];
                                // List<Widget> widgetsFullScreen = [];
                                List<dynamic> allFwi = [];



                                if (snapshotattachment.connectionState == ConnectionState.done) {
                                  //String markerLink = "https://firebasestorage.googleapis.com/v0/b/staht-connect-322113.appspot.com/o/pin.png?alt=media&token=1b0784fd-202a-47dd-8fe7-4a18ea5e6422";
                                  String markerLink = "https://developers.google.com/maps/documentation/maps-static/images/star.png";


                                  //     return Text("Image size "+snapshotattachment.data.length.toString());
                                  String mapUri = "https://maps.googleapis.com/maps/api/staticmap?center=" +
                                      dataToShow["location"]["lat"]
                                          .toString() +
                                      "," +
                                      dataToShow["location"]["long"]
                                          .toString() +
                                      "&zoom=15&size=" +
                                      (2560).toStringAsFixed(0)+
                                      "x640&markers="+
                                      //"icon:"+markerLink+"%7C" +
                                      dataToShow["location"]["lat"]
                                          .toString() +
                                      "," +
                                      dataToShow["location"]["long"]
                                          .toString() +
                                      "&key=AIzaSyBQH9dnXV9oUn0K8MMge3MlbhBgbLKzQ10";
                                  //
                                  Widget mapWidget  = GoogleMap(myLocationButtonEnabled: false,mapToolbarEnabled: false,
                                    initialCameraPosition: CameraPosition(
                                      target: LatLng(dataToShow["location"]["lat"],
                                          dataToShow["location"]["long"]),
                                      zoom: 8,
                                    ),
                                    markers: {
                                      Marker(
                                        markerId: MarkerId(index.toString()),
                                        position: LatLng(dataToShow["location"]["lat"],
                                            dataToShow["location"]["long"]),
                                        icon: snapshotMarker.data!,
                                      ),
                                    },

                                    // zoomControlsEnabled: false,
                                    // zoomGesturesEnabled: false,
                                  );

                                  //Uint8List mapIMage = base64Decode(dataToShow["mapImage"]);

                                  //   Widget mapWidget = Image.network(mapUri,fit: BoxFit.cover, height: height * 0.21, width: width * 0.88,);
                                  widgets.add(InkWell(onTap: (){
                                    //show this in dialog
                                    print("show map in dialog");
                                    // showDialog(context: context,
                                    //     builder: (BuildContext context){
                                    //       return Dialog(
                                    //         shape: RoundedRectangleBorder(
                                    //           borderRadius: BorderRadius.circular(2),
                                    //         ),
                                    //         elevation: 0,
                                    //         backgroundColor: Colors.transparent,
                                    //         child: Stack(children: [
                                    //           Align(alignment: Alignment.center,child: mapWidget,),
                                    //           Positioned(top: 15,left: 15,child: InkWell(onTap: (){
                                    //             Navigator.pop(context);
                                    //           },
                                    //             child: Card(shape: RoundedRectangleBorder(
                                    //                 borderRadius: BorderRadius.circular(20.0),
                                    //           ),color: ThemeManager().getDarkGreenColor,child: Container(width: 40,height: 40,child: Center(child :Icon(Icons.arrow_back,color: Colors.white,)),),) ,
                                    //           ),),
                                    //
                                    //
                                    //
                                    //         ],),
                                    //       );
                                    //     }
                                    // );
                                  },
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                          height: height * 0.21,
                                          width: width * 0.88,
                                          child: Stack(children: [
                                            Align(child: mapWidget,),
                                            Align(child:InkWell(onTap: (){
                                              print("show map in dialog 12");
                                              showDialog(context: context,
                                                  builder: (BuildContext context){
                                                    return Dialog(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(2),
                                                      ),
                                                      elevation: 0,
                                                      backgroundColor: Colors.transparent,
                                                      child:  Stack(children: [
                                                        Align(alignment: Alignment.center,child:  GoogleMap(myLocationButtonEnabled: false,mapToolbarEnabled: false,
                                                          initialCameraPosition: CameraPosition(
                                                            target: LatLng(dataToShow["location"]["lat"],
                                                                dataToShow["location"]["long"]),
                                                            zoom: 8,
                                                          ),
                                                          markers: {
                                                            Marker(
                                                              markerId: MarkerId(index.toString()),
                                                              position: LatLng(dataToShow["location"]["lat"],
                                                                  dataToShow["location"]["long"]),
                                                              icon: snapshotMarker.data!,
                                                            ),
                                                          },

                                                          // zoomControlsEnabled: false,
                                                          // zoomGesturesEnabled: false,
                                                        ),),
                                                        Positioned(top: 15,left: 15,child: InkWell(onTap: (){
                                                          Navigator.pop(context);
                                                        },
                                                          child: Card(elevation: 8,shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(20.0),
                                                          ),color: ThemeManager().getDarkGreenColor,child: Container(width: 40,height: 40,child: Center(child :Icon(Icons.arrow_back,color: Colors.white,)),),) ,
                                                        ),),



                                                      ],),
                                                    );
                                                  }
                                              );
                                            },
                                              child: Container(  height: height * 0.21,
                                                width: width * 0.88 ,),
                                            )),


                                          ],)),
                                      // child: Image.network(mapUri,fit: BoxFit.cover,)),
                                    ),
                                  ));
                                  widgets.add(Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                        height: height * 0.21,
                                        width: width * 0.88,
                                        //  child: Image.memory(base64Decode(dataToShow["graphImage"],),)),
                                        //child: snapshotGraph.data
                                        child: graphIMG
                                    ),
                                  ));
                                  for (int q = 0; q < snapshotattachment.data!.docs.length; q++) {
                                    // for (int q = snapshotattachment.data.docs.length-1; q >= snapshotattachment.data.docs.length; q--) {
                                    // String partId = snapshotattachment.data.docs[q].id;
                                    List allOnlyPhoto = [];
                                    if (snapshotattachment.data!.docs[q].get("type")=="photo") {
                                      allOnlyPhoto.add(snapshotattachment.data!.docs[q].get("photoFile"));
                                      Widget wI = Image.network(snapshotattachment.data!.docs[q].get("photoFile"),fit: BoxFit.cover,);

                                      widgets.add( InkWell(onTap: (){

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
                                          padding: const EdgeInsets.all(5.0),
                                          child: Container(
                                            // height: height*0.7,
                                            //width: width*0.9,
                                              child: wI),
                                        ),
                                      ));





                                      // widgetsFullScreen.add(wI);
                                      //widgetsFullScreen
                                      // allFwi.add({
                                      //   "wid": wI,
                                      //   "time": snapshotattachment
                                      //       .data!.docs[q]
                                      //       .get("time"),
                                      // });
                                      // AttachmentsAddedListener.getInstance()
                                      //     .dataReload(allFwi);

                                    } else {
                                      // Widget video = PlayVideoAutoPlayFromUrl(autoPlay: false,mute: true,name: snapshotattachment.data!.docs[q].get("videoFile"),);
                                      //  Widget video = Center(child: Icon(Icons.play_arrow_outlined),);
                                      //snapshotattachment.data.docs[q].get("type")
                                      //  widgets.add(PlayVideoFromUrl(name: snapshotattachment.data.docs[q].get("type"),));

                                      // widgetsFullScreen.add(video);
                                      //widgetsFullScreen
                                      // allFwi.add({
                                      //   "wid": video,
                                      //   "time": snapshotattachment
                                      //       .data!.docs[q]
                                      //       .get("time"),
                                      // });
                                      // AttachmentsAddedListener.getInstance()
                                      //     .dataReload(allFwi);
                                      widgets.add( InkWell(onTap: (){


                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>Scaffold(body:Center(child: PlayVideoAutoPlayFromUrl(autoPlay: true,mute: false,name: snapshotattachment.data!.docs[q].get("videoFile"),),)) ),);

                                      },
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Container(
                                            //height: height*0.7,
                                            // width: width*0.9,
                                              child: PlayVideoAutoPlayFromUrl(autoPlay: true,mute: true,name: snapshotattachment.data!.docs[q].get("videoFile"),)),
                                        ),
                                      ));
                                    }





                                  }



                                  ListView r = ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: widgets,
                                  );
                                  return Container(
                                    // height: 130,
                                    child: r,
                                  );

                                } else
                                  return Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                        height: height * 0.21,
                                        width: width * 1,
                                        //   child: Image.memory(base64Decode(dataToShow["graphImage"],),)),
                                        child: Center(child: CircularProgressIndicator(),)),
                                  );
                              }),
                        ),
                        Container(
                          height: height*0.23,
                          margin: EdgeInsets.only(top: width*0.04),
                          child: FutureBuilder<QuerySnapshot>(
                              future: AppFirestore(firestore: firestore, auth: FirebaseAuth.instance,projectId: '').fetchCustomerUsersAllAttachmentFuture(testID:dataToShow.id),
                              // stream: fetchCustomerUsersAllAttachmentStream(
                              //     testID: widget.id,
                              //     firestore: widget.customerFirestore),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot>
                                  snapshotattachment) {
                                List<Widget> widgets = [];
                                // List<Widget> widgetsFullScreen = [];
                                List<dynamic> allFwi = [];



                                if (snapshotattachment.connectionState == ConnectionState.done) {
                                  //String markerLink = "https://firebasestorage.googleapis.com/v0/b/staht-connect-322113.appspot.com/o/pin.png?alt=media&token=1b0784fd-202a-47dd-8fe7-4a18ea5e6422";
                                  String markerLink = "https://developers.google.com/maps/documentation/maps-static/images/star.png";


                                  //     return Text("Image size "+snapshotattachment.data.length.toString());
                                  String mapUri = "https://maps.googleapis.com/maps/api/staticmap?center=" +
                                      dataToShow["location"]["lat"]
                                          .toString() +
                                      "," +
                                      dataToShow["location"]["long"]
                                          .toString() +
                                      "&zoom=15&size=" +
                                      (2560).toStringAsFixed(0)+
                                      "x640&markers="+
                                      //"icon:"+markerLink+"%7C" +
                                      dataToShow["location"]["lat"]
                                          .toString() +
                                      "," +
                                      dataToShow["location"]["long"]
                                          .toString() +
                                      "&key=AIzaSyBQH9dnXV9oUn0K8MMge3MlbhBgbLKzQ10";
                                  //
                                  Widget mapWidget  = GoogleMap(myLocationButtonEnabled: false,mapToolbarEnabled: false,
                                    initialCameraPosition: CameraPosition(
                                      target: LatLng(dataToShow["location"]["lat"],
                                          dataToShow["location"]["long"]),
                                      zoom: 8,
                                    ),
                                    markers: {
                                      Marker(
                                        markerId: MarkerId(index.toString()),
                                        position: LatLng(dataToShow["location"]["lat"],
                                            dataToShow["location"]["long"]),
                                        icon: snapshotMarker.data!,
                                      ),
                                    },

                                    // zoomControlsEnabled: false,
                                    // zoomGesturesEnabled: false,
                                  );

                                  //Uint8List mapIMage = base64Decode(dataToShow["mapImage"]);

                                  //   Widget mapWidget = Image.network(mapUri,fit: BoxFit.cover, height: height * 0.21, width: width * 0.88,);
                                  widgets.add(InkWell(onTap: (){
                                    //show this in dialog
                                    print("show map in dialog");
                                    // showDialog(context: context,
                                    //     builder: (BuildContext context){
                                    //       return Dialog(
                                    //         shape: RoundedRectangleBorder(
                                    //           borderRadius: BorderRadius.circular(2),
                                    //         ),
                                    //         elevation: 0,
                                    //         backgroundColor: Colors.transparent,
                                    //         child: Stack(children: [
                                    //           Align(alignment: Alignment.center,child: mapWidget,),
                                    //           Positioned(top: 15,left: 15,child: InkWell(onTap: (){
                                    //             Navigator.pop(context);
                                    //           },
                                    //             child: Card(shape: RoundedRectangleBorder(
                                    //                 borderRadius: BorderRadius.circular(20.0),
                                    //           ),color: ThemeManager().getDarkGreenColor,child: Container(width: 40,height: 40,child: Center(child :Icon(Icons.arrow_back,color: Colors.white,)),),) ,
                                    //           ),),
                                    //
                                    //
                                    //
                                    //         ],),
                                    //       );
                                    //     }
                                    // );
                                  },
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                          height: height * 0.21,
                                          width: width * 0.88,
                                          child: Stack(children: [
                                            Align(child: mapWidget,),
                                            Align(child:InkWell(onTap: (){
                                              print("show map in dialog 12");
                                              showDialog(context: context,
                                                  builder: (BuildContext context){
                                                    return Dialog(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(2),
                                                      ),
                                                      elevation: 0,
                                                      backgroundColor: Colors.transparent,
                                                      child:  Stack(children: [
                                                        Align(alignment: Alignment.center,child:  GoogleMap(myLocationButtonEnabled: false,mapToolbarEnabled: false,
                                                          initialCameraPosition: CameraPosition(
                                                            target: LatLng(dataToShow["location"]["lat"],
                                                                dataToShow["location"]["long"]),
                                                            zoom: 8,
                                                          ),
                                                          markers: {
                                                            Marker(
                                                              markerId: MarkerId(index.toString()),
                                                              position: LatLng(dataToShow["location"]["lat"],
                                                                  dataToShow["location"]["long"]),
                                                              icon: snapshotMarker.data!,
                                                            ),
                                                          },

                                                          // zoomControlsEnabled: false,
                                                          // zoomGesturesEnabled: false,
                                                        ),),
                                                        Positioned(top: 15,left: 15,child: InkWell(onTap: (){
                                                          Navigator.pop(context);
                                                        },
                                                          child: Card(elevation: 8,shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(20.0),
                                                          ),color: ThemeManager().getDarkGreenColor,child: Container(width: 40,height: 40,child: Center(child :Icon(Icons.arrow_back,color: Colors.white,)),),) ,
                                                        ),),



                                                      ],),
                                                    );
                                                  }
                                              );
                                            },
                                              child: Container(  height: height * 0.21,
                                                width: width * 0.88 ,),
                                            )),


                                          ],)),
                                      // child: Image.network(mapUri,fit: BoxFit.cover,)),
                                    ),
                                  ));
                                  widgets.add(Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                        height: height * 0.21,
                                        width: width * 0.88,
                                         //  child: Image.memory(base64Decode(dataToShow["graphImage"],),)),
                                        //child: snapshotGraph.data
                                        child: graphIMG
                                    ),
                                  ));
                                  for (int q = 0; q < snapshotattachment.data!.docs.length; q++) {
                                    // for (int q = snapshotattachment.data.docs.length-1; q >= snapshotattachment.data.docs.length; q--) {
                                    // String partId = snapshotattachment.data.docs[q].id;
                                    List allOnlyPhoto = [];
                                    if (snapshotattachment.data!.docs[q].get("type")=="photo") {
                                      allOnlyPhoto.add(snapshotattachment.data!.docs[q].get("photoFile"));
                                      Widget wI = Image.network(snapshotattachment.data!.docs[q].get("photoFile"),fit: BoxFit.cover,);

                                      widgets.add( InkWell(onTap: (){

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
                                          padding: const EdgeInsets.all(5.0),
                                          child: Container(
                                            // height: height*0.7,
                                            //width: width*0.9,
                                              child: wI),
                                        ),
                                      ));





                                      // widgetsFullScreen.add(wI);
                                      //widgetsFullScreen
                                      // allFwi.add({
                                      //   "wid": wI,
                                      //   "time": snapshotattachment
                                      //       .data!.docs[q]
                                      //       .get("time"),
                                      // });
                                      // AttachmentsAddedListener.getInstance()
                                      //     .dataReload(allFwi);

                                    } else {
                                      // Widget video = PlayVideoAutoPlayFromUrl(autoPlay: false,mute: true,name: snapshotattachment.data!.docs[q].get("videoFile"),);
                                      //  Widget video = Center(child: Icon(Icons.play_arrow_outlined),);
                                      //snapshotattachment.data.docs[q].get("type")
                                      //  widgets.add(PlayVideoFromUrl(name: snapshotattachment.data.docs[q].get("type"),));

                                      // widgetsFullScreen.add(video);
                                      //widgetsFullScreen
                                      // allFwi.add({
                                      //   "wid": video,
                                      //   "time": snapshotattachment
                                      //       .data!.docs[q]
                                      //       .get("time"),
                                      // });
                                      // AttachmentsAddedListener.getInstance()
                                      //     .dataReload(allFwi);
                                      widgets.add( InkWell(onTap: (){


                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>Scaffold(body:Center(child: PlayVideoAutoPlayFromUrl(autoPlay: true,mute: false,name: snapshotattachment.data!.docs[q].get("videoFile"),),)) ),);

                                      },
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Container(
                                            //height: height*0.7,
                                            // width: width*0.9,
                                              child: PlayVideoAutoPlayFromUrl(autoPlay: true,mute: true,name: snapshotattachment.data!.docs[q].get("videoFile"),)),
                                        ),
                                      ));
                                    }





                                  }



                                  ListView r = ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: widgets,
                                  );
                                  return Container(
                                    // height: 130,
                                    child: r,
                                  );

                                } else
                                  return Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                        height: height * 0.21,
                                        width: width * 1,
                                        //   child: Image.memory(base64Decode(dataToShow["graphImage"],),)),
                                        child: Center(child: CircularProgressIndicator(),)),
                                  );
                              }),
                        ),
                      ],
                    ),
                  ),
                );
                prepareGraphData(){
                  //graphImage
                  return Future.value(Container(height: height*0.22,
                    width: MediaQuery.of(context).size.width,
                    child: Image.memory(base64Decode(dataAsMap["graphImage"])),));

                  return Future.value(Container(
                    color: ThemeManager().getWhiteColor,
                    height: height*0.22,
                    width: MediaQuery.of(context).size.width,
                    //  child: Text(snapshotRecord.data.data()["data"]["id"]),
                    child: LineMultiColorNoTracking(unit: getUnit(dataToShow),
                        data: jsonDecode(
                            dataToShow.get("data")),
                        max: dataToShow.get("max"),
                        target:
                        dataToShow.get("targetLoad"),
                        startedLoad:
                        dataToShow.get("startedLoad"),
                        duration: dataToShow
                            .get("targetDuration"),
                        endedLoad:
                        dataToShow.get("endedLoad"),
                        fullDuration:
                        dataToShow.get("lastTime"),
                        didPassed:
                        dataToShow.get("didPassed")),
                  ));
                }

                return FutureBuilder<Container>(
                  // Initialize FlutterFire:
                  //  future: Firebase.initializeApp(),
                    future: prepareGraphData(),
                    builder: (context, snapshotGraph) {
                      if(snapshotGraph.hasData){
                        return    InkWell(onTap: (){
                          HomePageLogics(firestore:firestore ,context: context,locale: locale,customerId: customerId).testRecordClickedEvent(data: dataToShow,id:dataToShow.id, pos: 0 ,);
                          CustomerHomePageLogic().tabChangedStream.dataReload(0);
                        },
                          child: Container(
                            margin: EdgeInsets.only(top: height*0.02),

                            child: Column(
                              children: [

                                //----------------------User profile image and name header------------------
                                Container(
                                  margin: EdgeInsets.only(left: width*0.04),
                                  child: Row(
                                    children: [
                                      //Image(image: AssetImage(homeScreenData[index]["userProfileImage"])),
                                      CircleAvatar(),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(left: width*0.038),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(dataToShow.get("name"),maxLines: 1,
                                                style: interBold.copyWith(
                                                    fontSize: width * 0.04),
                                              ),

                                              Container(

                                                margin: EdgeInsets.only(top: height*0.007),

                                                child: Text(DateFormat('hh:mm aa dd MMM yyyy',locale.languageCode)
                                                    .format( true? DateTime.fromMillisecondsSinceEpoch(dataToShow["time"]):DateTime.fromMillisecondsSinceEpoch(dataToShow["time"])),
                                                  style: interRegular.copyWith(
                                                      fontSize: width * 0.03,
                                                      color: ThemeManager().getBlackColor
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      // IconButton(
                                      //   onPressed: (){},
                                      //   splashRadius: 1,
                                      //   icon: SvgPicture.asset("assets/svg/menuButtonIcon.svg"),
                                      // ),
                                    ],
                                  ),
                                ),

                                //----------------------Measurements, time and result data------------------
                                Container(
                                  margin: EdgeInsets.only(top: height * 0.01, left: width * 0.02),

                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(left: width * 0.04),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: width * 0.11,
                                              width: width * 0.11,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: ThemeManager().getLightBlueColor,
                                              ),
                                              child: Image(
                                                  image: AssetImage(
                                                      "assets/icons/peakLoadIcon.png")),
                                            ),
                                            Container(
                                                margin:
                                                EdgeInsets.only(top: height * 0.01),
                                                child: Row(
                                                  children: [
                                                    Text(dataToShow["loadMode"] == "kN"? dataToShow["max"].toString():dataToShow["max"].toInt().toString() ,
                                                      style: interSemiBold.copyWith(
                                                          fontSize: width * 0.04),
                                                    ),
                                                    Container(
                                                        margin: EdgeInsets.only(left: width*0.01),
                                                        child: Text(getUnit(dataToShow),style: interRegular.copyWith(fontSize: width*0.031),))

                                                  ],
                                                )),
                                            Container(
                                              margin:
                                              EdgeInsets.only(top: height * 0.005),
                                              child: Text("Peak Load",
                                                  style: interRegular.copyWith(
                                                      fontSize: width * 0.03,
                                                      color: ThemeManager().getBlackColor)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(right: width * 0.02),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: width * 0.11,
                                              width: width * 0.11,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: ThemeManager().getLightOrangeColor,
                                              ),
                                              child: Image(
                                                  image: AssetImage(
                                                      "assets/icons/targetLoadIcon.png")),
                                            ),
                                            Container(
                                                margin:
                                                EdgeInsets.only(top: height * 0.01),
                                                child: Row(
                                                  children: [
                                                    Text(dataToShow["loadMode"] == "kN"? dataToShow["targetLoad"].toString():dataToShow["targetLoad"].toInt().toString(),
                                                      style: interSemiBold.copyWith(
                                                          fontSize: width * 0.04),
                                                    ),
                                                    Container(
                                                        margin: EdgeInsets.only(left: width*0.01),
                                                        child: Text(getUnit(dataToShow),style: interRegular.copyWith(fontSize: width*0.031),))

                                                  ],
                                                )),
                                            Container(
                                                margin: EdgeInsets.only(
                                                    top: height * 0.005),
                                                child: Text(
                                                  "Target Load",
                                                  style: interRegular.copyWith(
                                                      fontSize: width * 0.03,
                                                      color: ThemeManager().getBlackColor),
                                                )),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(right: width * 0.04),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: width * 0.11,
                                              width: width * 0.11,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: ThemeManager()
                                                    .getLightBottleGreenColor,
                                              ),
                                              child: Image(
                                                  image: AssetImage(
                                                      "assets/icons/timeIcon.png")),
                                            ),
                                            Container(
                                                margin:
                                                EdgeInsets.only(top: height * 0.01),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      dataToShow["targetDuration"].toString() ,
                                                      style: interSemiBold.copyWith(
                                                          fontSize: width * 0.04),
                                                    ),
                                                    Container(
                                                        margin: EdgeInsets.only(left: width*0.01),
                                                        child: Text("secs",style: interRegular.copyWith(fontSize: width*0.031),))
                                                  ],
                                                )),
                                            Container(
                                                margin: EdgeInsets.only(
                                                    top: height * 0.005),
                                                child: Text(
                                                  "Time",
                                                  style: interRegular.copyWith(
                                                      fontSize: width * 0.03,
                                                      color: ThemeManager().getBlackColor),
                                                )),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(right: width * 0.07),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: width * 0.11,
                                              width: width * 0.11,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: dataToShow.get("startedLoad") == 0
                                                    ?  Colors.yellow.withOpacity(0.3)
                                                    : (dataToShow
                                                    .get("startedLoad") >
                                                    0
                                                    ? (dataToShow
                                                    .get("didPassed")
                                                    ? Colors.green.withOpacity(0.1)
                                                    : Colors.redAccent.withOpacity(0.1))
                                                    :Colors.redAccent.withOpacity(0.1)) ,
                                              ),
                                              child:dataToShow.get("startedLoad") == 0
                                                  ?  Container(

                                                child:Icon(Icons.warning_rounded,color: ThemeManager().getYellowGradientColor,),
                                              )
                                                  : (dataToShow
                                                  .get("startedLoad") >
                                                  0
                                                  ? (dataToShow
                                                  .get("didPassed")
                                                  ?  Image(image: AssetImage("assets/icons/passIcon.png"))
                                                  :  Container(

                                                child: Icon(Icons.close_rounded,color: ThemeManager().getRedColor,),
                                              ))
                                                  : Container(

                                                child:Icon(Icons.close_rounded,color: ThemeManager().getRedColor,),
                                              )) ,
                                              // child: Image(image: AssetImage("assets/icons/passIcon.png")),
                                            ),
                                            Container(
                                                margin:
                                                EdgeInsets.only(top: height * 0.01),
                                                child: dataToShow.get("startedLoad") == 0
                                                    ? Text("Not Timed")
                                                    : (dataToShow
                                                    .get("startedLoad") >
                                                    0
                                                    ? (dataToShow
                                                    .get("didPassed")
                                                    ? Text(
                                                  "Pass",
                                                  style: interSemiBold.copyWith(
                                                      fontSize: width * 0.04),
                                                )
                                                    : Text("Fail",
                                                    style: interSemiBold.copyWith(
                                                        fontSize: width * 0.04)))
                                                    : Text("Fail",
                                                    style: interSemiBold.copyWith(
                                                        fontSize: width * 0.04)))),
                                            Container(
                                                margin: EdgeInsets.only(
                                                    top: height * 0.005),
                                                child: Text(
                                                  "Result",
                                                  style: interRegular.copyWith(
                                                      fontSize: width * 0.03,
                                                      color: ThemeManager().getBlackColor),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                //----------------------Map image and other image slider-------------------

                                Container(
                                  height: height*0.23,
                                  margin: EdgeInsets.only(top: width*0.04),
                                  child: FutureBuilder<QuerySnapshot>(
                                      future: AppFirestore(firestore: firestore, auth: FirebaseAuth.instance,projectId: '').fetchCustomerUsersAllAttachmentFuture(testID:dataToShow.id),
                                      // stream: fetchCustomerUsersAllAttachmentStream(
                                      //     testID: widget.id,
                                      //     firestore: widget.customerFirestore),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                          snapshotattachment) {
                                        List<Widget> widgets = [];
                                        // List<Widget> widgetsFullScreen = [];
                                        List<dynamic> allFwi = [];



                                        if (snapshotattachment.connectionState == ConnectionState.done) {
                                          //String markerLink = "https://firebasestorage.googleapis.com/v0/b/staht-connect-322113.appspot.com/o/pin.png?alt=media&token=1b0784fd-202a-47dd-8fe7-4a18ea5e6422";
                                          String markerLink = "https://developers.google.com/maps/documentation/maps-static/images/star.png";


                                          //     return Text("Image size "+snapshotattachment.data.length.toString());
                                          String mapUri = "https://maps.googleapis.com/maps/api/staticmap?center=" +
                                              dataToShow["location"]["lat"]
                                                  .toString() +
                                              "," +
                                              dataToShow["location"]["long"]
                                                  .toString() +
                                              "&zoom=15&size=" +
                                              (2560).toStringAsFixed(0)+
                                              "x640&markers="+
                                              //"icon:"+markerLink+"%7C" +
                                              dataToShow["location"]["lat"]
                                                  .toString() +
                                              "," +
                                              dataToShow["location"]["long"]
                                                  .toString() +
                                              "&key=AIzaSyBQH9dnXV9oUn0K8MMge3MlbhBgbLKzQ10";
                                          //
                                          Widget mapWidget  = GoogleMap(myLocationButtonEnabled: false,mapToolbarEnabled: false,
                                            initialCameraPosition: CameraPosition(
                                              target: LatLng(dataToShow["location"]["lat"],
                                                  dataToShow["location"]["long"]),
                                              zoom: 8,
                                            ),
                                            markers: {
                                              Marker(
                                                markerId: MarkerId(index.toString()),
                                                position: LatLng(dataToShow["location"]["lat"],
                                                    dataToShow["location"]["long"]),
                                                icon: snapshotMarker.data!,
                                              ),
                                            },

                                            // zoomControlsEnabled: false,
                                            // zoomGesturesEnabled: false,
                                          );

                                          //Uint8List mapIMage = base64Decode(dataToShow["mapImage"]);

                                          //   Widget mapWidget = Image.network(mapUri,fit: BoxFit.cover, height: height * 0.21, width: width * 0.88,);
                                          widgets.add(InkWell(onTap: (){
                                            //show this in dialog
                                            print("show map in dialog");
                                            // showDialog(context: context,
                                            //     builder: (BuildContext context){
                                            //       return Dialog(
                                            //         shape: RoundedRectangleBorder(
                                            //           borderRadius: BorderRadius.circular(2),
                                            //         ),
                                            //         elevation: 0,
                                            //         backgroundColor: Colors.transparent,
                                            //         child: Stack(children: [
                                            //           Align(alignment: Alignment.center,child: mapWidget,),
                                            //           Positioned(top: 15,left: 15,child: InkWell(onTap: (){
                                            //             Navigator.pop(context);
                                            //           },
                                            //             child: Card(shape: RoundedRectangleBorder(
                                            //                 borderRadius: BorderRadius.circular(20.0),
                                            //           ),color: ThemeManager().getDarkGreenColor,child: Container(width: 40,height: 40,child: Center(child :Icon(Icons.arrow_back,color: Colors.white,)),),) ,
                                            //           ),),
                                            //
                                            //
                                            //
                                            //         ],),
                                            //       );
                                            //     }
                                            // );
                                          },
                                            child: Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: Container(
                                                  height: height * 0.21,
                                                  width: width * 0.88,
                                                  child: Stack(children: [
                                                    Align(child: mapWidget,),
                                                    Align(child:InkWell(onTap: (){
                                                      print("show map in dialog 12");
                                                      showDialog(context: context,
                                                          builder: (BuildContext context){
                                                            return Dialog(
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(2),
                                                              ),
                                                              elevation: 0,
                                                              backgroundColor: Colors.transparent,
                                                              child:  Stack(children: [
                                                                Align(alignment: Alignment.center,child:  GoogleMap(myLocationButtonEnabled: false,mapToolbarEnabled: false,
                                                                  initialCameraPosition: CameraPosition(
                                                                    target: LatLng(dataToShow["location"]["lat"],
                                                                        dataToShow["location"]["long"]),
                                                                    zoom: 8,
                                                                  ),
                                                                  markers: {
                                                                    Marker(
                                                                      markerId: MarkerId(index.toString()),
                                                                      position: LatLng(dataToShow["location"]["lat"],
                                                                          dataToShow["location"]["long"]),
                                                                      icon: snapshotMarker.data!,
                                                                    ),
                                                                  },

                                                                  // zoomControlsEnabled: false,
                                                                  // zoomGesturesEnabled: false,
                                                                ),),
                                                                Positioned(top: 15,left: 15,child: InkWell(onTap: (){
                                                                  Navigator.pop(context);
                                                                },
                                                                  child: Card(elevation: 8,shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(20.0),
                                                                  ),color: ThemeManager().getDarkGreenColor,child: Container(width: 40,height: 40,child: Center(child :Icon(Icons.arrow_back,color: Colors.white,)),),) ,
                                                                ),),



                                                              ],),
                                                            );
                                                          }
                                                      );
                                                    },
                                                      child: Container(  height: height * 0.21,
                                                        width: width * 0.88 ,),
                                                    )),


                                                  ],)),
                                              // child: Image.network(mapUri,fit: BoxFit.cover,)),
                                            ),
                                          ));
                                          widgets.add(Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Container(
                                                height: height * 0.21,
                                                width: width * 0.88,
                                             //   child: Image.memory(base64Decode(dataToShow["graphImage"],),)),
                                                child: snapshotGraph.data),
                                          ));
                                          for (int q = 0; q < snapshotattachment.data!.docs.length; q++) {
                                            // for (int q = snapshotattachment.data.docs.length-1; q >= snapshotattachment.data.docs.length; q--) {
                                            // String partId = snapshotattachment.data.docs[q].id;
                                            List allOnlyPhoto = [];
                                            if (snapshotattachment.data!.docs[q].get("type")=="photo") {
                                              allOnlyPhoto.add(snapshotattachment.data!.docs[q].get("photoFile"));
                                              Widget wI = Image.network(snapshotattachment.data!.docs[q].get("photoFile"),fit: BoxFit.cover,);

                                              widgets.add( InkWell(onTap: (){

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
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: Container(
                                                    // height: height*0.7,
                                                    //width: width*0.9,
                                                      child: wI),
                                                ),
                                              ));





                                              // widgetsFullScreen.add(wI);
                                              //widgetsFullScreen
                                              // allFwi.add({
                                              //   "wid": wI,
                                              //   "time": snapshotattachment
                                              //       .data!.docs[q]
                                              //       .get("time"),
                                              // });
                                              // AttachmentsAddedListener.getInstance()
                                              //     .dataReload(allFwi);

                                            } else {
                                              // Widget video = PlayVideoAutoPlayFromUrl(autoPlay: false,mute: true,name: snapshotattachment.data!.docs[q].get("videoFile"),);
                                              //  Widget video = Center(child: Icon(Icons.play_arrow_outlined),);
                                              //snapshotattachment.data.docs[q].get("type")
                                              //  widgets.add(PlayVideoFromUrl(name: snapshotattachment.data.docs[q].get("type"),));

                                              // widgetsFullScreen.add(video);
                                              //widgetsFullScreen
                                              // allFwi.add({
                                              //   "wid": video,
                                              //   "time": snapshotattachment
                                              //       .data!.docs[q]
                                              //       .get("time"),
                                              // });
                                              // AttachmentsAddedListener.getInstance()
                                              //     .dataReload(allFwi);
                                              widgets.add( InkWell(onTap: (){


                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>Scaffold(body:Center(child: PlayVideoAutoPlayFromUrl(autoPlay: true,mute: false,name: snapshotattachment.data!.docs[q].get("videoFile"),),)) ),);

                                              },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: Container(
                                                    //height: height*0.7,
                                                    // width: width*0.9,
                                                      child: PlayVideoAutoPlayFromUrl(autoPlay: true,mute: true,name: snapshotattachment.data!.docs[q].get("videoFile"),)),
                                                ),
                                              ));
                                            }





                                          }



                                          ListView r = ListView(
                                            scrollDirection: Axis.horizontal,
                                            children: widgets,
                                          );
                                          return Container(
                                            // height: 130,
                                            child: r,
                                          );

                                        } else
                                          return Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Container(
                                                height: height * 0.21,
                                                width: width * 1,
                                                //   child: Image.memory(base64Decode(dataToShow["graphImage"],),)),
                                                child: Center(child: CircularProgressIndicator(),)),
                                          );
                                      }),
                                ),
                              ],
                            ),
                          ),
                        );

                      }else{
                        return CircularProgressIndicator();
                      }
                    });

              },
            );

          }else{
            return CircularProgressIndicator();
          }
        });

    // return ListView.separated(
    //   shrinkWrap: true,
    //   reverse: true,
    //   physics: ClampingScrollPhysics(),
    //   padding: EdgeInsets.zero,
    //   itemCount: docs.length,
    //   itemBuilder: (_, index) {
    //     return InkWell(
    //       onTap: () {
    //         HomePageLogics(firestore:firestore ,context: context,locale: locale,customerId: customerId).testRecordClickedEvent(data: docs[index],id:docs[index].id,pos:0);
    //
    //       },
    //       //didPassed
    //       child: Stack(
    //         children: [
    //           Align(
    //             alignment: Alignment.centerLeft,
    //             child: Row(
    //               children: [
    //                 Padding(
    //                   padding:
    //                   const EdgeInsets.fromLTRB(
    //                       4, 4, 4, 4),
    //                   child: Card(
    //                     color: Theme.of(context)
    //                         .primaryColor,
    //                     child: Icon(
    //                       Icons.show_chart_rounded,
    //                       color: Colors.white,
    //                     ),
    //                   ),
    //                 ),
    //                 Padding(
    //                   padding:
    //                   const EdgeInsets.fromLTRB(
    //                       4, 4, 4, 4),
    //                   child: Container(
    //                     width: MediaQuery.of(context)
    //                         .size
    //                         .width -
    //                         100,
    //                     child: Wrap(
    //                       children: [
    //                         Container(
    //                           width: MediaQuery.of(
    //                               context)
    //                               .size
    //                               .width,
    //                           child: Padding(
    //                             padding:
    //                             const EdgeInsets
    //                                 .fromLTRB(
    //                                 0, 3, 0, 3),
    //                             child: Text(
    //                               docs[index]
    //                                   .get("name"),
    //                               style: TextStyle(
    //
    //                                   fontWeight:
    //                                   FontWeight
    //                                       .bold),
    //                             ),
    //                           ),
    //                         ),
    //                         Container(
    //                           width: MediaQuery.of(
    //                               context)
    //                               .size
    //                               .width,
    //                           child: Padding(
    //                             padding:
    //                             const EdgeInsets
    //                                 .fromLTRB(
    //                                 0, 3, 0, 3),
    //                             child: Text(
    //                               DateFormat(
    //                                   'hh:mm aa MMM dd',locale.languageCode)
    //                                   .format(DateTime.fromMillisecondsSinceEpoch(
    //
    //                                   docs[index]
    //                                   [
    //                                   "time"])),
    //                               style: TextStyle(),
    //                             ),
    //                           ),
    //                         )
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //           // Align(
    //           //   alignment: Alignment.centerRight,
    //           //   child: snapshotHistory.data.docs[index].data()?( snapshotHistory.data.docs[index].get("didPassed")==true?Icon(Icons.done_all):Icons.close):Container(width: 0,height: 0,),
    //           // ),
    //         ],
    //       ),
    //     );
    //   },
    //   separatorBuilder: (context, index) {
    //     return Divider();
    //   },
    // );

  }

  String getUnit(dynamic dataToShow) {
    try{
      return  dataToShow["loadMode"]!=null?dataToShow["loadMode"]:"kN";
    }catch(e){
      return "kN";

    }

  }

}