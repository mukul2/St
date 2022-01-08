import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/Activities/CustomerUserHome/HomePager/logics.dart';
import 'package:connect/Activities/CustomerUserHome/logics.dart';
import 'package:connect/screens/popup/testViewFromMap.dart';
import 'package:connect/utils/appConst.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:connect/utils/appConst.dart';

import '../../DarkThemeManager.dart';

class ViewTestByMapScreen extends StatefulWidget {
  List<QueryDocumentSnapshot<Object?>> mapLatLong ;
  FirebaseFirestore firestore;
  String customerId;
  Locale locale;

  ViewTestByMapScreen({required this.mapLatLong,required this.customerId,required this.firestore,required this.locale});
  @override
  _ViewTestByMapScreenState createState() => _ViewTestByMapScreenState();
}

class _ViewTestByMapScreenState extends State<ViewTestByMapScreen> {

  //----------------------Map marker latitude amd longitude data--------------
  // dynamic mapLatLong = [
  //   {"latitude": 52.84149700629685, "longitude": -1.884403362729722},
  //   {"latitude": 53.010930, "longitude": -1.903397},
  //   {"latitude": 52.877285, "longitude": -1.961329},
  //   {"latitude": 52.91569186657271, "longitude": -1.5776655127332908},
  //   {"latitude": 52.6660343146926, "longitude": -2.0673672964747913},
  //   {"latitude": 52.51753618720615, "longitude": -1.9025723824283274},
  //   {"latitude": 53.23340514492625, "longitude": -2.7304843138979056},
  //   {"latitude": 52.38821980028023, "longitude": -2.4818920979463144},
  // ];

  Set<Marker> markerSet = {};
  late BitmapDescriptor markerIcon;
  bool isMapLoading = true;

  @override
  void initState() {
    super.initState();

    setMarkerIcon().then((value) {
      addMarkerLatLong(context);
    });
  }

  //-------------------------Set Image marker-------------------
  Future<void> setMarkerIcon() async {
    markerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/icons/mapMarker1Icon.png');

    await Future.delayed(Duration(seconds: 1));

    setState(() {
      isMapLoading = false;
    });
  }

  //------------------------Add markers in markerSet------------
  void addMarkerLatLong(BuildContext maincontext) {
    setState(() {
      for (var i = 0; i <= widget.mapLatLong.length; i++)
        markerSet.add(Marker(
            markerId: MarkerId(i.toString()),
            onTap: () {
              showDialog(context: context,
                  builder: (BuildContext context){
                    return TestViewFromMap(title:widget.mapLatLong[i]["name"].toString().length>0?widget.mapLatLong[i]["name"]:"(No title)", onClickAction: (answer ) {
                      if(answer == true){
                        print("OPen");
                        HomePageLogics(firestore:widget.firestore ,context: maincontext,locale: widget.locale,customerId: widget.customerId).testRecordClickedEvent(data: widget.mapLatLong[i],id:widget.mapLatLong[i].id, pos: 2 ,);

                      }else{

                      }
                    },);
                  }
              );


              // Fluttertoast.showToast(
              //     msg: widget.mapLatLong[i]["name"],
              //     toastLength: Toast.LENGTH_SHORT,
              //     gravity: ToastGravity.BOTTOM,
              //     timeInSecForIosWeb: 1,
              //     fontSize: 16.0);
            },
            position: LatLng(widget.mapLatLong[i].get("location")["lat"],widget. mapLatLong[i].get("location")["long"]),
            icon: markerIcon));
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    Scaffold scaffold = Scaffold(backgroundColor: AppThemeManager().getScaffoldBackgroundColor(),body: isMapLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(body:  FutureBuilder<Position?>(
        future:  GeolocatorPlatform.instance.getLastKnownPosition(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            // _markers.add(
            //   Marker(
            //     markerId: MarkerId('id-1'),
            //     position: LatLng(snapshot.data!.latitude, snapshot.data!.longitude),
            //     // icon: markerIcon!,
            //     icon: markerIcon ,
            //     infoWindow:
            //     InfoWindow(title: "You are here!", snippet: "You are here!"),
            //   ),
            // );

            return   GoogleMap(

              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                new Factory<OneSequenceGestureRecognizer>(() => new EagerGestureRecognizer(),),
              ].toSet(),

              // gestureRecognizers: Set()
              // ..add( Factory<PanGestureRecognizer>(() => PanGestureRecognizer())),
              initialCameraPosition: CameraPosition(
                target: LatLng(snapshot.data!.latitude, snapshot.data!.longitude),
                zoom: 8,
              ),
              markers: markerSet,
              zoomControlsEnabled: true,
              myLocationEnabled: true,
            );
          }else  return Scaffold(body: Center(child: CircularProgressIndicator(color: Colors.redAccent,)),);

        }),),);
    return MaterialApp(home: scaffold,);

  //  return ;
  }
}
