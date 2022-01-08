import 'dart:convert';
import 'dart:core';
import 'dart:core';
import 'dart:core';
import 'dart:ffi';
import "dart:typed_data";
import 'package:connect/screens/home.dart';
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

import '../../../widgets.dart';


class DeviceReading extends StatefulWidget {
  BluetoothDevice? bluetoothDevice;
  String projct;
  FirebaseFirestore customerFirestore;
  QueryDocumentSnapshot userProfile;

  DeviceReading(
      {required this.userProfile,
        this.bluetoothDevice,
        required   this.projct,
        required  this.customerFirestore});

  @override
  _DeviceReadingState createState() => _DeviceReadingState();
}



class _DeviceReadingState extends State<DeviceReading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.bluetoothDevice == null
          ? Center(child: Text("No Device connected"))
          : Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Column(
          children: [
            Container(

              height: 50,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Icon(Icons.sensor_window),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              "Connected Devices",
                              style: TextStyle(

                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder<BluetoothState>(
                stream: FlutterBlue.instance.state,
                initialData: BluetoothState.unknown,
                builder: (c, snapshot) {
                  final state = snapshot.data;
                  if (state == BluetoothState.on) {
                    // return Text("Blutooth on");
                    return StreamBuilder<List<BluetoothDevice>>(
                      stream: Stream.periodic(Duration(seconds: 0))
                          .asyncMap((_) =>
                      FlutterBlue.instance.connectedDevices),
                      initialData: [],
                      builder: (c, snapshot) {
                        if (snapshot.hasData &&
                            snapshot.data!.length > 0) {
                          if (widget.bluetoothDevice != null) {
                          } else {
                            // setState(() {
                            //   widget.bluetoothDevice = snapshot.data.first ;
                            // });
                          }

                          return Column(
                            children: snapshot.data!
                                .map((d) => ListTile(
                              onTap: () {
                                setState(() {
                                  widget.bluetoothDevice =
                                      snapshot.data!.first;
                                });

                              },
                              leading: Checkbox(
                                value:
                                widget.bluetoothDevice != null
                                    ? (widget.bluetoothDevice!
                                    .id.id ==
                                    d.id.id
                                    ? true
                                    : false)
                                    : false, onChanged: (bool? value) {  },
                              ),
                              title: Text(d.name),
                              subtitle: Text(d.id.toString()),
                              trailing: StreamBuilder<
                                  BluetoothDeviceState>(
                                stream: d.state,
                                initialData: BluetoothDeviceState
                                    .disconnected,
                                builder: (c, snapshot) {
                                  if (snapshot.data ==
                                      BluetoothDeviceState
                                          .connected) {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (context) {
                                                  d.connect(
                                                      autoConnect: true);
                                                  return ConnectedDevicePage(auth: FirebaseAuth.instance,
                                                    firestore:
                                                    FirebaseFirestore
                                                        .instance,
                                                   // userBody: widget.userProfile,
                                                    device: d, calibratorID: '', key: null,);
                                                  //return DeviceScreenLessDetails(r.device);
                                                }));
                                      },
                                      child: Text(
                                        "Open Settings",
                                        style: TextStyle(
                                            color: Theme.of(
                                                context)
                                                .primaryColor),
                                      ),
                                    );

                                  }
                                  return Text(
                                      snapshot.data.toString());
                                },
                              ),
                            ))
                                .toList(),
                          );
                        } else {
                          return ListTile(
                            onTap: () {
                              FlutterBlue.instance.startScan(
                                  timeout: Duration(seconds: 4));
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
                                                  (r) =>
                                                  ScanResultTile(
                                                    result: r,
                                                    onTap: () {
                                                      r.device
                                                          .connect(
                                                          autoConnect:
                                                          false)
                                                          .then(
                                                              (value) {
                                                            initDeviceSlAndCalibDate(r.device);
                                                            setState(() {
                                                              widget.bluetoothDevice =
                                                                  r.device;
                                                            });
                                                          });
                                                      // return Scaffold();
                                                      //   return   PerformTestPage(device: r.device,project: widget.projectID,);
                                                      // return PerformTestPageActivity(
                                                      //     device: r
                                                      //         .device,
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
                    );
                    return FindDevicesScreenForTest(
                      projectID: widget.projct,
                    );
                  }
                  return ListTile(
                    title: Text("Turn on Blutooth"),
                    trailing: Icon(
                      Icons.bluetooth_disabled,
                      color: Theme.of(context).primaryColor,
                    ),
                  );
                  //return BluetoothOffScreen(state: state);
                }),
          ],
        ),
      ),
    );
  }
}