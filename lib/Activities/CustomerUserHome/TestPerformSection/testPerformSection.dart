import 'dart:convert';
import 'dart:core';
import 'dart:core';
import 'dart:core';
import 'dart:ffi';
import "dart:typed_data";
import 'package:connect/Activities/CustomerUserHome/HomePager/appbar.dart';
import 'package:connect/Activities/CustomerUserHome/HomePager/ui_components.dart';
import 'package:connect/screens/home.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/textConst.dart';
import 'package:connect/utils/themeManager.dart';
import 'package:convert/convert.dart';
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

import '../../../Storage.dart';
import '../../../widgets.dart';


class TestPerformSection extends StatefulWidget {
  String projct;
  FirebaseFirestore customerFirestore;
   TestPerformSection({required this.projct,required this.customerFirestore});

  @override
  _TestPerformSectionState createState() => _TestPerformSectionState();
}

class _TestPerformSectionState extends State<TestPerformSection> {
  @override
  void initState() {
    super.initState();


  }
  prepareTestTab({ BluetoothDevice? device}) {
    print("preparing");
    print(DateTime.now());
    if(isTestRunning == false){
      return FutureBuilder<SharedPreferences>(
          future:  SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              String lastLoad =
                  snapshot.data!.getString("lastLoad")??"0";
              TextEditingController c =
              TextEditingController(
                  text: lastLoad);
              return   TakePreDataActivity(appbar: AppBar(),
                lastLoad: lastLoad,
                d: device!,
                customerId:
                widget.projct,
                customerFirestore:
                widget.customerFirestore,
                sPref: snapshot.data!,
                controller: c,
              );
            }else {
              return CircularProgressIndicator();
            }

          });

    }else{
      return Container(width: 0,height: 0,);;

    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(body: Column(children: [
        Container(
            child: AppbarView(
              appbarTitleText: TextConst.testsText,
            )
        ),
        Expanded(child:  StreamBuilder<List<BluetoothDevice>>(
          stream: FlutterBlue.instance.connectedDevices.asStream(),
          initialData: [],
          builder: (c, snapshot) {
            if (snapshot.hasData && snapshot.data!.length > 0) {
              print("hit this 2");

              return  prepareTestTab(device: snapshot.data!.last);

            } else {
              return ListTile(
                onTap: () {
                  FlutterBlue.instance
                      .startScan(timeout: Duration(seconds: 4));
                  showDialog<void>(
                      context: context,
                      builder: (context) => SimpleDialog(
                        children: [
                          StreamBuilder<List<ScanResult>>(
                            stream: FlutterBlue
                                .instance.scanResults,
                            initialData: [],
                            builder: (c, snapshot) {
                              //  updateData(snapshot.data);
                              FirebaseFirestore firestore;
                              //  Database(firestore: firestore).addData(snapshot.data);


                              return Column(
                                children: snapshot.data!
                                    .map(
                                      (r) => ScanResultTile(
                                    result: r,
                                    onTap: () {
                                      r.device
                                          .connect(
                                          autoConnect:
                                          false)
                                          .then(
                                              (value) {
                                            //fetch index2 and index6
                                            initDeviceSlAndCalibDate(r.device);

                                            Navigator.pop(
                                                context);


                                          });
                                      //return Scaffold(body: Text("Not using"),);
                                      //return Text("ok");
                                      //   return   PerformTestPage(device: r.device,project: widget.projectID,);
                                      // return PerformTestPageActivity(
                                      //     device:
                                      //         r.device,
                                      //     project: widget
                                      //         .projct);
                                      Navigator.pop(
                                          context);
                                      //return ConnectedDevicePage(device: r.device);
                                      //return DeviceScreenLessDetails(r.device);
                                    },
                                  ),
                                  //     (r) => ScanResultTile(
                                  //   result: r,
                                  //   onTap: () => Navigator.of(context)
                                  //       .push(MaterialPageRoute(builder: (context) {
                                  //     r.device.connect(autoConnect: false);
                                  //     //return Text("ok");
                                  //  //   return   PerformTestPage(device: r.device,project: widget.projectID,);
                                  //     return   PerformTestPage(device: r.device,project:"o",);
                                  //     Navigator.pop(context);
                                  //     //return ConnectedDevicePage(device: r.device);
                                  //     //return DeviceScreenLessDetails(r.device);
                                  //   })),
                                  // ),
                                )
                                    .toList(),
                              );
                            },
                          )
                        ],
                      ));
                },
                title: Text("No Device is Connected"),
                trailing: Text(
                  "Scan",
                  style: TextStyle(),
                ),
              );
            }
          },
        ),),


      ],),),
    );
  }
}

