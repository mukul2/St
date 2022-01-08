import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:connect/pages/graph_3.dart';
import 'package:connect/pages/graph_two.dart';
import 'package:connect/services/restApi.dart';
import 'package:connect/services/show_widgets.dart';
import 'package:connect/services/themeManager.dart';
import 'package:connect/widgets/appwidgets.dart';
import 'package:connect/widgets/lists_widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:flutter/material.dart';

String base =
    "data:image/png;base64,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";



class MapPage2 extends StatefulWidget {
  List<QueryDocumentSnapshot> allReports = [];
  Locale locale;

  MapPage2({required this.allReports,required this.firestore,required this.customerId,required this.locale});
  String customerId;

  late BitmapDescriptor pinLocationIcon;
  FirebaseFirestore firestore;

  @override
  State<StatefulWidget> createState() => MapPageState();
}

class MapPageState extends State<MapPage2> {
  Set<Marker> _markers = {};
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    // setCustomMapPin();
  }

  void setCustomMapPin() async {
    // pinLocationIcon = await BitmapDescriptor.fromAssetImage(
    //     ImageConfiguration(devicePixelRatio: 2.5),
    //     'assets/destination_map_marker.png');
    Uint8List bytes = base64.decode(base);
    BitmapDescriptor pinLocationIcon2 = await BitmapDescriptor.fromBytes(bytes);
    setState(() {
      widget.pinLocationIcon = pinLocationIcon2;
    });
  }

  @override
  Widget build(BuildContext context) {
    LatLng pinPosition;
    if (widget.allReports.length > 0) {
      pinPosition = LatLng(double.parse(widget.allReports.last.get("location")["lat"].toString()),
          double.parse(widget.allReports.last.get("location")["long"].toString()));
    } else {
      pinPosition = LatLng(0.0, 0.0);
    }

    // these are the minimum required values to set
    // the camera position
    CameraPosition initialLocation =
        CameraPosition(zoom: 16, bearing: 30, target: pinPosition);

    return GoogleMap(
        myLocationEnabled: true,
        compassEnabled: true,
        markers: _markers,
        initialCameraPosition: initialLocation,
        onMapCreated: (GoogleMapController controller) {
          //  controller.setMapStyle(Utils.mapStyles);
          _controller.complete(controller);
          if (widget.allReports.length > 0) {
            for (int i = 0; i < widget.allReports.length; i++) {
              setState(() {
                _markers.add(Marker(
                  markerId: MarkerId(widget.allReports[i].id),
                  position: pinPosition,
                  infoWindow: InfoWindow(
                    title: widget.allReports[i].id,
                    snippet: widget.allReports[i].id,
                    onTap: () {


                      AppWidgets(customerId:  widget.customerId,customerFirestore:  widget.firestore). showTestRecordBody(

                          widget.allReports[i].id,
                          widget.allReports[i],
                          context,widget.locale,2
                         );


/*

                      //show record detail
                      Navigator.of(context)
                          .push(
                          new MaterialPageRoute<
                              Null>(
                              builder:
                                  (BuildContext
                              context) {
                                    String width = MediaQuery.of(context).size.width.ceil().toString();





                                return Scaffold(
                                  appBar: AppBar(
                                    title: Text(widget.allReports[i].id),
                                  ),
                                  body: FutureBuilder<
                                      DocumentSnapshot>(
                                      future: Api().fetchOnerecordWithFirestore(
                                          firestore:
                                          widget.firestore,
                                          id: widget.allReports[i].id),
                                      builder: (c,
                                          snapshotRecord) {
                                        if (snapshotRecord
                                            .hasData &&
                                            snapshotRecord
                                                .data
                                                .exists) {

                                         // width = "400";
                                          String mapUri = "https://maps.googleapis.com/maps/api/staticmap?center="+widget.allReports[i].get("location")["lat"].toString()+","+widget.allReports[i].get("location")["long"].toString()+"&zoom=16&size="+width+"x200&markers="+widget.allReports[i].get("location")["lat"].toString()+","+widget.allReports[i].get("location")["long"].toString()+"&key=AIzaSyBQH9dnXV9oUn0K8MMge3MlbhBgbLKzQ10";

                                          print(mapUri);
                                          return Column(
                                            children: [
                                              Container(height: 200, width: MediaQuery.of(context).size.width,
                                                //  child: Text(snapshotRecord.data.get["data"]["id"]),
                                                child: DefaultPanning2(jsonDecode(snapshotRecord.data.get("data"))),
                                              ),

                                              FutureBuilder<List<QueryDocumentSnapshot>>(
                                                  future: fetchCustomerUsersAllAttachment(
                                                      testID: widget.allReports[i].id,
                                                      firestore: widget.firestore),
                                                  builder: (BuildContext context,
                                                      AsyncSnapshot<List<QueryDocumentSnapshot>>
                                                      snapshotattachment) {
                                                    if (snapshotattachment.hasData) {
                                                      List<Widget> widgets = [];

                                                 //     return Text("Image size "+snapshotattachment.data.length.toString());

                                                      for(int q  = 0 ; q < snapshotattachment.data.length ; q ++ ) {
                                                        String partId = snapshotattachment
                                                            .data[q].id;
                                                        widgets.add(
                                                            FutureBuilder<List<
                                                                QueryDocumentSnapshot>>(
                                                              // Initialize FlutterFire:
                                                                future: fetchAttachmentAllParts(
                                                                    attachmentId: partId,
                                                                    firestore: widget
                                                                        .firestore),
                                                                builder: (
                                                                    BuildContext context,
                                                                    AsyncSnapshot<
                                                                        List<
                                                                            QueryDocumentSnapshot>>
                                                                    snapshotattachmentParts) {
                                                                  if (snapshotattachmentParts
                                                                      .hasData &&
                                                                      snapshotattachmentParts
                                                                          .data
                                                                          .length >
                                                                          0) {
                                                                    var im;
                                                                    String fullImage = "";
                                                                    try{

                                                                      fullImage = "";
                                                                      for (int i = snapshotattachmentParts.data.length - 1; i >= 0; i--) {
                                                                        // for (int i = 0; i < snapshotattachmentParts.data.length; i++) {
                                                                        fullImage = fullImage + snapshotattachmentParts.data[i].get("data");
                                                                      }


                                                                      Uint8List bytes = base64.decode(fullImage);
                                                                      im = Image.memory(bytes,fit: BoxFit.cover,
                                                                      );


                                                                    }catch(e){
                                                                      fullImage = "";
                                                                      // for (int i = snapshotattachmentParts.data.length - 1; i >= 0; i--) {
                                                                      for (int i = 0; i < snapshotattachmentParts.data.length; i++) {
                                                                        fullImage = fullImage + snapshotattachmentParts.data[i].get("data");
                                                                      }


                                                                      Uint8List bytes = base64.decode(fullImage);
                                                                      im = Image.memory(bytes,fit: BoxFit.cover,
                                                                      );

                                                                    }
                                                                    return InkWell(
                                                                      onTap: () {
                                                                        // showWidgetinModal(context, Center(
                                                                        //   child: Container(
                                                                        //     child: im,
                                                                        //     height: 480,
                                                                        //     width: 270,
                                                                        //   ),
                                                                        // ));
                                                                      },
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.all(8.0),
                                                                        child: Container(
                                                                            width: 100,
                                                                            height: 125,
                                                                            child: im),
                                                                      ),
                                                                    );
                                                                    //  return Image.
                                                                    // return Text(snapshotattachmentParts
                                                                    //     .data.length
                                                                    //     .toString() +
                                                                    //     " parts");
                                                                  }
                                                                  else
                                                                    return Text(
                                                                        "No attachment part found");
                                                                }));
                                                      }

                                                      //fetchAttachmentAllParts
                                                      ListView r = ListView(
                                                        scrollDirection: Axis.horizontal,
                                                        children: widgets,
                                                      );
                                                      return Container(height: 125,child: r);
                                                      /*
                                                      for (int k = 0; k < snapshotattachment.data.length; k++) {
                                                        String partId = snapshotattachment.data[k].id;
                                                        widgets.add(FutureBuilder<List<QueryDocumentSnapshot>>(
                                                          // Initialize FlutterFire:
                                                            future: fetchAttachmentAllParts(
                                                                attachmentId: partId,
                                                                firestore: widget.firestore),
                                                            builder: (BuildContext context,
                                                                AsyncSnapshot<List<QueryDocumentSnapshot>>
                                                                snapshotattachmentParts) {
                                                              if (snapshotattachmentParts.hasData &&
                                                                  snapshotattachmentParts.data.length >
                                                                      0) {
                                                                String fullImage = "";
                                                                for (int i = snapshotattachmentParts
                                                                    .data.length -
                                                                    1;
                                                                i >= 0;
                                                                i--) {
                                                                  fullImage = fullImage +
                                                                      snapshotattachmentParts.data[i]
                                                                          .get["data"];
                                                                }
                                                                Uint8List bytes =
                                                                base64.decode(fullImage);
                                                                var im =   Image.memory(bytes,
                                                                    fit: BoxFit.cover);
                                                                return InkWell(onTap: (){
                                                                  // showWidgetinModal(context, Center(
                                                                  //   child: Container(
                                                                  //     child: im,
                                                                  //     height: 480,
                                                                  //     width: 270,
                                                                  //   ),
                                                                  // ));
                                                                },
                                                                  child: Container(
                                                                      width: 200,
                                                                      height: 250,
                                                                      child: im),
                                                                );
                                                                //  return Image.
                                                                // return Text(snapshotattachmentParts
                                                                //     .data.length
                                                                //     .toString() +
                                                                //     " parts");
                                                              }
                                                              else
                                                                return Text("No attachment part found");
                                                            })) ;

                                                        return Text(r.children.length.toString());
                                                      }*/
                                                    } else
                                                      return Text("No attachment");
                                                  }),
                                              Center(child:Image.network(mapUri))

                                            ],
                                          );
                                        } else {
                                          return Text(
                                              "No Data");
                                        }
                                      }),
                                );
                              },
                              fullscreenDialog:
                              true));

                      */





                     // showTestresultModal(context, widget.allReports[i].id, widget.firestore);
                      // Do something
                    },
                  ),
                ));
              });
            }
          }
        });
  }
}



class Utils {
  static String mapStyles = '''[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dadada"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#c9c9c9"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  }
]''';
}
