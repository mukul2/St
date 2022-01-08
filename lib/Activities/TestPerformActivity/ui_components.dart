import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/Activities/CustomerUserHome/logics.dart';
import 'package:connect/models/Chartsample.dart';
import 'package:connect/pages/graph_two.dart';
import 'package:connect/utils/appConst.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:connect/services/themeManager.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart' as gl;
import 'package:geolocator/geolocator.dart';
 import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../Storage.dart';
import 'logics.dart';
class TestPerformUiComponents{
  BuildContext? context;
  TestPerformUiComponents({this.context});
  mapSegment(BitmapDescriptor markerIcon){
    Set<Marker> _markers = {};

    return   FutureBuilder<Position?>(
        future:  GeolocatorPlatform.instance.getLastKnownPosition(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            _markers.add(
              Marker(
                markerId: MarkerId('id-1'),
                position: LatLng(snapshot.data!.latitude, snapshot.data!.longitude),
               // icon: markerIcon!,
                icon: markerIcon ,
                infoWindow:
                InfoWindow(title: "You are here!", snippet: "You are here!"),
              ),
            );
            return      Container(
                height: height * 0.20,
                width: double.infinity,
                child: (snapshot.data != null)
                    ? GoogleMap(myLocationEnabled: false,myLocationButtonEnabled: false,
                  mapType: MapType.normal,
                  zoomControlsEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(snapshot.data!.latitude, snapshot.data!.longitude),
                    zoom: 14.4746,
                  ),
                  markers: _markers,
                )
                    : Center(
                  child:   Scaffold(body: Center(child: CircularProgressIndicator(color: Colors.redAccent,)),),
                ));
          }else  return Scaffold(body: Center(child: CircularProgressIndicator(color: Colors.redAccent,)),);

        });


  }
  mapSegmentPutmarkerOnly(BitmapDescriptor markerIcon, double lat, double long){
    Set<Marker> _markers = {};
    _markers.add(
      Marker(
        markerId: MarkerId('id-1'),
        position: LatLng(lat, long),
        // icon: markerIcon!,
        icon: markerIcon ,
        infoWindow:
        InfoWindow(title: "You are here!", snippet: "You are here!"),
      ),
    );
    return      Container(
        height: height * 0.20,
        width: double.infinity,
        child:GoogleMap(myLocationEnabled: false,myLocationButtonEnabled: false,
          mapType: MapType.normal,
          zoomControlsEnabled: false,
          initialCameraPosition: CameraPosition(
            target: LatLng(lat, long),
            zoom: 14.4746,
          ),
          markers: _markers,
        ));


  }
  readingsSegment({required bool shouldCollect,required int start,required List<int> data}){
    try{
      return  Container(
        child: Center(
          child: Card(
            elevation:
            (shouldCollect ==
                true &&
                start
                    .isEven ==
                    true)
                ? 0
                : 5,
            color:
            (shouldCollect ==
                true &&
                start
                    .isEven ==
                    true)
                ? Colors.red
                : Theme.of(context!)
                .primaryColor,
            shape:
            RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(
                  75.0),
            ),
            child: InkWell(
                onTap: () {

                },
                child: double.parse(
                    TestPerformLogics().convertwithDecimalplaces(data, 1)) <
                    62.9
                    ? Container(
                    height: 150,
                    width: 150,
                    child: Center(
                        child: Card(
                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(90.0),
                            ),
                            child: Container(
                                width: 135,
                                height: 135,
                                child: Center(
                                    child: Container(
                                        width: 90,
                                        height: 60,
                                        child: Card(
                                          color: Theme.of(context!).primaryColor,
                                          child: StreamBuilder<bool>(
                                              stream:TestPerformLogics().testStartStopStream.outData,
                                              builder: (BuildContext context, AsyncSnapshot<bool> snapshotS) {
                                                if (snapshotS.hasData && snapshotS.data == true) {
                                                  return Center(
                                                      child: Text(
                                                        TestPerformLogics(). convertwithDecimalplaces(data, 1) + "kN",
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
                                                      ));
                                                } else {
                                                  return Center(
                                                      child: Text(
                                                        TestPerformLogics().convertwithDecimalplaces(data, 1) + "kN",
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
                                                      ));
                                                }
                                              }),
                                        )))))))
                    : Padding(
                  padding:
                  const EdgeInsets
                      .all(
                      8.0),
                  child: Padding(
                    padding:
                    const EdgeInsets
                        .all(
                        8.0),
                    child:
                    Container(
                      color: Colors
                          .redAccent,
                      child:
                      Center(
                        child:
                        Column(
                          children: [
                            Text(
                              "Max Load Reached",
                              style:
                              TextStyle(color: Colors.white),
                            ),
                            Text(
                              TestPerformLogics(). convertwithDecimalplaces(data,
                                  1),
                              style:
                              TextStyle(color: Colors.white, fontSize: 30),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
          ),
        ),
      );
    }catch(e){
      print(e);
      return Text("");


    }

  }

  graphSegment({required List<ChartSampleData> onlyShow,required double maxValForDisplay}){
  return  onlyShow.length > 20
        ? Padding(
          padding:  EdgeInsets.only(top: 20),
          child: Container(

      child: DefaultPanning(
            onlyShow,
            maxValForDisplay <
                0.2
                ? 2
                : maxValForDisplay),
    ),
        )
        : Text("");

  }
  CameraSegment(){
    return ImageClicker();
  }
  saveIntoFileExplolar({required FirebaseFirestore firestore,required String id}){
    return FileExplorarForTestSave(customerFirestore: firestore,id: id,);
  }
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
                  isTestRunning = false;
                  CustomerHomePageLogic().testRunningUniversalNotifier.dataReload(false);
                  //Navigator.of(context).popUntil((route) => route.isFirst);
                  // returnHomePage(context);
                  bool didCanceled = false;
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
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


class MapSample extends StatefulWidget {
  List<Marker> list = [];
  MapSample();
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  late BitmapDescriptor pinLocationIcon;
  Set<Marker> _markers = Set<Marker>();
  //late  Location location;
  late BitmapDescriptor sourceIcon;
  late BitmapDescriptor destinationIcon;
  //late LocationData currentLocation;
  Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor? markerIcon;
  CameraPosition? defaultLocation;
  static final CameraPosition _kGooglePlex = CameraPosition(

    target: LatLng(0, 0),
    zoom: 14.4746,
  );
  Future<void> setMarkerIcon() async {
    markerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/icons/mapMarker1Icon.png');
  }
  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(0, 0),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
  void getUserLocation() async {
    var position = await gl.GeolocatorPlatform.instance.getCurrentPosition(desiredAccuracy: gl.LocationAccuracy.high);
    print(position);

    setState(() {
     defaultLocation  = CameraPosition(
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //location = new Location();
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/destination_map_marker.png').then((onValue) {
      pinLocationIcon = onValue;
    });
    getUserLocation();
    setMarkerIcon().then((value) async {
      getUserLocation();

      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    });
    setMarkerIcon().then((value) {
      // location.getLocation().then((value) {
      //
      //   currentLocation = value;
      //   updatePinOnMap();
      //
      //   _markers.add(
      //     Marker(
      //       markerId: MarkerId('id-1'),
      //       position: LatLng(value.latitude!, value.longitude!),
      //       icon: markerIcon!,
      //       infoWindow:
      //       InfoWindow(title: "You are here!", snippet: "You are here!"),
      //     ),
      //   );
      //
      // });
      // location.onLocationChanged.listen((LocationData cLoc) {
      //   currentLocation = cLoc;
      //   updatePinOnMap();
      //
      //   _markers.add(
      //     Marker(
      //       markerId: MarkerId('id-1'),
      //       position: LatLng(cLoc.latitude!, cLoc.longitude!),
      //       icon: markerIcon!,
      //       infoWindow:
      //       InfoWindow(title: "You are here!", snippet: "You are here!"),
      //     ),
      //   );
      //
      //   // cLoc contains the lat and long of the
      //   // current user's position in real time,
      //   // so we're holding on to it
      //   //  currentLocation = cLoc;
      //   //   updatePinOnMap();
      // });
    });

    // set custom marker pins
    setSourceAndDestinationIcons();
    // set the initial location
    // setInitialLocation();
    // set custom marker pins
    // setSourceAndDestinationIcons();
    // set the initial location
    // setInitialLocation();
    setCustomMapPin();
  }
  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/destination_map_marker.png');
  }
  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        zoomControlsEnabled: false,
       // initialCameraPosition: _kGooglePlex!,
        markers: _markers,
        initialCameraPosition: defaultLocation == null?CameraPosition(
          target: LatLng(0, 0),
          // target: LatLng(21.2315, 72.8663),
          zoom: 14.4746,
        ):defaultLocation!,

       // myLocationEnabled: true,

        // onMapCreated: (GoogleMapController controller) {
        //   _controller.complete(controller);
        //   // setState(() {
        //   //   _markers.add(
        //   //       Marker(
        //   //           markerId: MarkerId('markerid'),
        //   //           position: LatLng(currentLocation.latitude,currentLocation.longitude),
        //   //           icon: pinLocationIcon
        //   //       )
        //   //   );
        //   // });
        // },
      ),

    );
  }
  void updatePinOnMap() async {

    // create a new CameraPosition instance
    // every time the location changes, so the camera
    // follows the pin as it moves with an animation
    // CameraPosition cPosition = CameraPosition(
    //   zoom: 18,
    //
    //   target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
    // );
    final GoogleMapController controller = await _controller.future;
  //  controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    // do this inside the setState() so Flutter gets notified
    // that a widget update is due
    // setState(() {
    //   // updated position
    //   var pinPosition = LatLng(currentLocation.latitude,
    //       currentLocation.longitude);
    //
    //   // the trick is to remove the marker (by id)
    //   // and add it again at the updated location
    //   // _markers.removeWhere(
    //   //         (m) => m.markerId.value == 'sourcePin');
    //   // _markers.add(Marker(
    //   //     markerId: MarkerId('sourcePin'),
    //   //     position: pinPosition, // updated position
    //   //     icon: sourceIcon
    //   // ));
    // });
  }
  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/driving_pin.png');

    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/destination_map_marker.png');
  }
  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}


class ImageClicker extends StatefulWidget {
  //void Function(dynamic) photoAddListener;
  //String projetId;

  ImageClicker();

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

      TestPerformLogics().cameraReadyStream.dataReload(_controller);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initCamera();
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
          final size = MediaQuery.of(context).size;
          final deviceRatio = size.width / size.height;
          print(size);
          print(deviceRatio);
          // calculate scale for aspect ratio widget
          var scale = _controller.value.aspectRatio / deviceRatio;
          print(scale);
          // check if adjustments are needed...
          if (_controller.value.aspectRatio < deviceRatio) {
            scale = 1 / scale;
            print(scale);
          }




          return Stack(
            children: [

              // Align(
              //   alignment: Alignment.center,
              //   child:  Transform.scale(
              //     scale: _controller.value.aspectRatio / deviceRatio,
              //     child: Center(
              //       child: AspectRatio(
              //         aspectRatio: _controller.value.aspectRatio,
              //         child: CameraPreview(_controller),
              //       ),
              //     ),
              //   ),
              // ),
              // Align(
              //   alignment: Alignment.center,
              //   child:  RotatedBox(quarterTurns: 1,child:CameraPreview(_controller) ,),
              // ),
              Align(
                alignment: Alignment.center,
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
                ),
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
                                       // showMessage(context, "error occured");
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

        TestPerformLogics().videoClickedStream .dataReload({
          "videoPath": video.path,
          // "video": imageParts,
          "time": new DateTime.now().millisecondsSinceEpoch
        });

        TestPerformLogics().commonAttachmentAddedStream .dataReload({
          // "thumb":image.path,
          "type": "v",
          "videoPath": video.path,
          "time": new DateTime.now().millisecondsSinceEpoch
        });

        // widget.photoAddListener();

      } catch (e) {
       // showMessage(context, e.toString());
        //showMessage(context, "error occured");
      }
    });
  }
}