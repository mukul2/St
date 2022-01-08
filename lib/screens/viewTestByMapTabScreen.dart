import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:connect/utils/appConst.dart';

class ViewTestByMapScreen extends StatefulWidget {
  const ViewTestByMapScreen({Key? key}) : super(key: key);

  @override
  _ViewTestByMapScreenState createState() => _ViewTestByMapScreenState();
}

class _ViewTestByMapScreenState extends State<ViewTestByMapScreen> {
  //----------------------Map marker latitude amd longitude data--------------
  dynamic mapLatLong = [
    {"latitude": 52.84149700629685, "longitude": -1.884403362729722},
    {"latitude": 53.010930, "longitude": -1.903397},
    {"latitude": 52.877285, "longitude": -1.961329},
    {"latitude": 52.91569186657271, "longitude": -1.5776655127332908},
    {"latitude": 52.6660343146926, "longitude": -2.0673672964747913},
    {"latitude": 52.51753618720615, "longitude": -1.9025723824283274},
    {"latitude": 53.23340514492625, "longitude": -2.7304843138979056},
    {"latitude": 52.38821980028023, "longitude": -2.4818920979463144},
  ];

  Set<Marker> markerSet = {};
  late BitmapDescriptor markerIcon;
  bool isMapLoading = true;

  @override
  void initState() {
    super.initState();

    setMarkerIcon().then((value) {
      addMarkerLatLong();
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
  void addMarkerLatLong() {
    setState(() {
      for (var i = 0; i <= mapLatLong.length; i++)
        markerSet.add(Marker(
            markerId: MarkerId(i.toString()),
            onTap: () {
              Fluttertoast.showToast(
                  msg: "Marker Tapped",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  fontSize: 16.0);
            },
            position:
                LatLng(mapLatLong[i]["latitude"], mapLatLong[i]["longitude"]),
            icon: markerIcon));
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return isMapLoading
        ? Center(child: CircularProgressIndicator())
        : Container(
            //--------------------------By Map tab body View---------------------
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(52.84149700629685, -1.884403362729722),
                zoom: 8,
              ),
              markers: markerSet,
              zoomControlsEnabled: false,
            ),
          );
  }
}
