
import 'dart:io';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:connect/main.dart';
import 'package:connect/pages/TestPeromationActivity.dart';
import 'package:connect/pages/app_map_view.dart';
import 'package:connect/pages/connected_device_page.dart';
import 'package:connect/pages/graph_widget.dart';
import 'package:connect/pages/home_page.dart';
import 'package:connect/pages/login_page.dart';
import 'package:connect/pages/pion.dart';
import 'package:connect/screens/home.dart';
import 'package:connect/screens/login.dart';
import 'package:connect/services/Signal.dart';
import 'package:connect/services/auth.dart';
import 'package:connect/services/config.dart';
import 'package:connect/services/themeManager.dart';
import 'package:connect/streams/AuthControllerStream.dart';
import 'package:connect/streams/buttonStreams.dart';
import 'package:connect/widgets.dart';
import 'package:connect/widgets/cu.dart';
import 'package:connect/widgets/line_graph.dart';
import 'package:connect/widgets/sync_gra_n.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
 import 'package:connect/screens/login.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:connect/services/auth.dart';

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<FirebaseFirestore> initCustomerFirebase(String projectID) async {
    FirebaseApp app;

    try {
      app = await Firebase.initializeApp(
          name: projectID,
          options: FirebaseOptions(
            // appId: '1:17044794633:android:9f88d16d208f63229f37d8',
            appId: Platform.isAndroid
                ?Config().defaultAppIdAndroid
                : Config().defaultAppIdIOS,
            apiKey: Config().apiKey,
            messagingSenderId: '',
            projectId: projectID,
          ));
      FirebaseFirestore firestore =
      await FirebaseFirestore.instanceFor(app: app);
      return firestore;
    } catch (e) {
      FirebaseFirestore firestore =
      await FirebaseFirestore.instanceFor(app: Firebase.app(projectID));
      //FirebaseFirestore firestore = await FirebaseFirestore.instanceFor(app: app);
      return firestore;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Not using"),),);
    // return StreamBuilder(
    //     stream: _auth.authStateChanges(),
    //     builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
    //       if (snapshot.data?.uid == null) {
    //         //  return SplineArea();
    //         return Login(
    //           auth: _auth,
    //           firestore: _firestore,
    //         );
    //       } else {
    //         // return YouAreGenuser(
    //         //   auth: _auth,
    //         //   firestore: _firestore,
    //         // );
    //
    //         return FutureBuilder(
    //           // Initialize FlutterFire:
    //           //  future: Firebase.initializeApp(),
    //             future: FirebaseFirestore.instance
    //                 .collection("users")
    //                 .where("uid", isEqualTo: _auth.currentUser!.uid)
    //                 .get(),
    //             builder: (BuildContext context,
    //                 AsyncSnapshot<QuerySnapshot> snapshotprofile) {
    //               if (snapshotprofile.connectionState == ConnectionState.done) {
    //                 if (snapshotprofile.hasData &&
    //                     snapshotprofile.data != null) {
    //                   if (snapshotprofile.data!.docs.first.get("roleId") ==
    //                       role_id_customer_user) {
    //                     //return Scaffold(body: Center(child: Text(snapshot.data.docs[0].get.toString())));
    //
    //                     // return Text(snapshot.data.docs[0].get.toString());
    //
    //                     String customer_id =
    //                     snapshotprofile.data!.docs.first.get("parentId");
    //                     print("customer ");
    //                     print(customer_id);
    //
    //                     return FutureBuilder(
    //                       // Initialize FlutterFire:
    //                       //  future: Firebase.initializeApp(),
    //                         future: FirebaseFirestore.instance
    //                             .collection("customers")
    //                             .doc(snapshotprofile.data!.docs.first
    //                             .get("parentId"))
    //                             .get(),
    //                         builder: (BuildContext context,
    //                             AsyncSnapshot<DocumentSnapshot> snapshot) {
    //                           if (snapshot.connectionState ==
    //                               ConnectionState.done) {
    //                             if (snapshot.hasData && snapshot.data != null) {
    //                               print(snapshot.data!.get("projectId"));
    //
    //                               return FutureBuilder<FirebaseFirestore>(
    //                                 // Initialize FlutterFire:
    //                                 //  future: Firebase.initializeApp(),
    //                                   future: initCustomerFirebase(
    //                                       snapshot.data!.get("projectId")),
    //                                   builder: (BuildContext context,
    //                                       AsyncSnapshot<FirebaseFirestore>
    //                                       snapshotFirebaseStore) {
    //                                     if (snapshotFirebaseStore.hasData) {
    //                                       IO.Socket socket = AppSignal().initSignal();
    //
    //                                       //  return Text(snapshotprofile.data.docs.first.);
    //
    //                                       //  Vibration.vibrate(duration: 1000);
    //
    //                                       return MyHomePage(locale: widget.,
    //                                       //  socket: socket,
    //                                         profile: snapshotprofile.data!.docs.first,
    //                                         customerId: customer_id,
    //                                         customerName:
    //                                         snapshot.data!.get("prjectName"),
    //                                         customerFirestore: snapshotFirebaseStore.data!,
    //                                         projct:
    //                                         snapshot.data!.get("projectId"),
    //                                         auth: _auth, title: '',
    //                                       );
    //                                     } else {
    //                                       return Scaffold(
    //                                         body: Container(
    //                                             child: Center(
    //                                                 child:
    //                                                 CircularProgressIndicator())),
    //                                       );
    //                                     }
    //                                   });
    //
    //
    //
    //
    //                             } else {
    //                               return Scaffold(
    //                                 body: Container(
    //                                     child: Center(
    //                                         child:
    //                                         CircularProgressIndicator())),
    //                               );
    //                             }
    //                           } else {
    //                             return Scaffold(
    //                               body: Container(
    //                                   child:
    //                                   Center(child: Text("PLease wait"))),
    //                             );
    //                           }
    //                         });
    //                   } else if (snapshotprofile.data!.docs.first
    //                       .get("roleId") ==
    //                       role_id_staht_admin ||
    //                       snapshotprofile.data!.docs.first.get("roleId") ==
    //                           role_id_calibrator) {
    //                     final GlobalKey<ScaffoldState> scaffoldKey =
    //                     GlobalKey<ScaffoldState>();
    //                     return Scaffold(
    //                         key: scaffoldKey,
    //                         appBar: AppBar(
    //                           leading: Padding(
    //                             padding: const EdgeInsets.all(8.0),
    //                             child: Icon(
    //                               Icons.account_box_outlined,
    //                               color: Colors.white,
    //                             ),
    //                           ),
    //                           title: Text(snapshotprofile.data!.docs.first
    //                               .get("displayName")),
    //                         ),
    //                         body: Stack(
    //                           children: [
    //                             Align(
    //                               alignment: Alignment.topCenter,
    //                               child: Padding(
    //                                 padding: EdgeInsets.all(8.0),
    //                                 child: Container(
    //                                   width: MediaQuery.of(context).size.width,
    //                                   height:
    //                                   (MediaQuery.of(context).size.height -
    //                                       160) /
    //                                       2,
    //                                   decoration: BoxDecoration(
    //                                       borderRadius:
    //                                       BorderRadius.circular(5),
    //                                       border: Border.all(
    //                                           width: 2,
    //                                           color: Theme.of(context)
    //                                               .primaryColor)),
    //                                   child: Column(
    //                                     mainAxisAlignment:
    //                                     MainAxisAlignment.start,
    //                                     children: [
    //
    //                                     ],
    //                                   ),
    //                                 ),
    //                               ),
    //                             ),
    //                             Positioned(
    //                               top: ((MediaQuery.of(context).size.height -
    //                                   160) /
    //                                   2) +
    //                                   10,
    //                               bottom: 60,
    //                               left: 0,
    //                               right: 0,
    //                               child: Padding(
    //                                 padding: EdgeInsets.all(8.0),
    //                                 child: Container(
    //                                   width: MediaQuery.of(context).size.width,
    //                                   height:
    //                                   (MediaQuery.of(context).size.height -
    //                                       160) /
    //                                       2,
    //                                   decoration: BoxDecoration(
    //                                       borderRadius:
    //                                       BorderRadius.circular(5),
    //                                       border: Border.all(
    //                                           width: 2,
    //                                           color: Theme.of(context)
    //                                               .primaryColor)),
    //                                   child: Column(
    //                                     mainAxisAlignment:
    //                                     MainAxisAlignment.start,
    //                                     children: [
    //                                       ListTile(
    //                                         title: Text(
    //                                           "Connected Devices",
    //                                           style: TextStyle(
    //                                             color: Colors.blue,
    //                                           ),
    //                                         ),
    //                                         leading: Icon(
    //                                           Icons.add,
    //                                           color: Colors.blue,
    //                                         ),
    //                                       ),
    //                                       StreamBuilder<BluetoothState>(
    //                                           stream:
    //                                           FlutterBlue.instance.state,
    //                                           initialData:
    //                                           BluetoothState.unknown,
    //                                           builder: (c, snapshot) {
    //                                             final state = snapshot.data;
    //                                             if (state ==
    //                                                 BluetoothState.on) {
    //                                               // return Text("Blutooth on");
    //                                               return StreamBuilder<
    //                                                   List<BluetoothDevice>>(
    //                                                 stream: Stream.periodic(
    //                                                     Duration(
    //                                                         seconds: 0))
    //                                                     .asyncMap((_) =>
    //                                                 FlutterBlue.instance
    //                                                     .connectedDevices),
    //                                                 initialData: [],
    //                                                 builder: (c, snapshot) {
    //                                                   if (snapshot.hasData &&
    //                                                       snapshot.data!.length >
    //                                                           0) {
    //                                                     return Column(
    //                                                       children:
    //                                                       snapshot.data!
    //                                                           .map((d) =>
    //                                                           ListTile(
    //                                                             onTap:
    //                                                                 () {},
    //                                                             title: Text(
    //                                                                 d.name),
    //                                                             subtitle: Text(d
    //                                                                 .id
    //                                                                 .toString()),
    //                                                             trailing:
    //                                                             StreamBuilder<BluetoothDeviceState>(
    //                                                               stream:
    //                                                               d.state,
    //                                                               initialData:
    //                                                               BluetoothDeviceState.disconnected,
    //                                                               builder:
    //                                                                   (c, snapshot) {
    //                                                                 if (snapshot.data ==
    //                                                                     BluetoothDeviceState.connected) {
    //                                                                   return InkWell(
    //                                                                     onTap: () {
    //                                                                       Navigator.of(context).push(MaterialPageRoute(builder: (context) {
    //                                                                         d.connect(autoConnect: true);
    //                                                                         return ConnectedDevicePage(calibratorID: "admin",firestore: FirebaseFirestore.instance, userBody: snapshotprofile.data!.docs.first, device: d, auth: _auth,);
    //                                                                         //return DeviceScreenLessDetails(r.device);
    //                                                                       }));
    //                                                                     },
    //                                                                     child: Text(
    //                                                                       "Open Settings",
    //                                                                       style: TextStyle(color: Theme.of(context).primaryColor),
    //                                                                     ),
    //                                                                   );
    //                                                                 }
    //                                                                 return Text(snapshot.data.toString());
    //                                                               },
    //                                                             ),
    //                                                           ))
    //                                                           .toList(),
    //                                                     );
    //                                                   } else {
    //                                                     return ListTile(
    //                                                       onTap: () {
    //                                                         FlutterBlue.instance
    //                                                             .startScan(
    //                                                             timeout: Duration(
    //                                                                 seconds:
    //                                                                 4));
    //                                                         showDialog<void>(
    //                                                             context:
    //                                                             context,
    //                                                             builder:
    //                                                                 (contextD) =>
    //                                                                 SimpleDialog(
    //                                                                   children: [
    //                                                                     StreamBuilder<List<ScanResult>>(
    //                                                                       stream: FlutterBlue.instance.scanResults,
    //                                                                       initialData: [],
    //                                                                       builder: (c, snapshot) {
    //                                                                         //  updateData(snapshot.data);
    //                                                                         FirebaseFirestore firestore;
    //                                                                         //  Database(firestore: firestore).addData(snapshot.data);
    //
    //                                                                         return Column(
    //                                                                           children: snapshot.data!
    //                                                                               .map(
    //                                                                                 (r) => ScanResultTile(
    //                                                                               result: r,
    //                                                                               onTap: () {
    //                                                                                 r.device.connect(autoConnect: false).then((value) async {
    //                                                                                   Navigator.pop(context);
    //                                                                                   await r.device.discoverServices();
    //
    //                                                                                   List<BluetoothService> allservice = await r.device.services.first;
    //                                                                                   print("a X" + allservice.length.toString());
    //                                                                                   if (allservice.length > 3) {
    //                                                                                     print("b X" + allservice.length.toString());
    //                                                                                     BluetoothCharacteristic characteristicWritePurpose = allservice[3].characteristics[0];
    //                                                                                     BluetoothCharacteristic characteristicReadPurpose = allservice[3].characteristics[1];
    //                                                                                     String iceSerial = "";
    //                                                                                     String Serial = "";
    //                                                                                     getSerial2() async {
    //                                                                                       print("c X");
    //                                                                                       await characteristicWritePurpose.write(StringToASCII(COMMAND_INDEX_2_GET_), withoutResponse: true);
    //
    //                                                                                       List<int> responseAray2 = await characteristicReadPurpose.read();
    //                                                                                       await characteristicWritePurpose.write(StringToASCII(COMMAND_INDEX_2_GET_), withoutResponse: true);
    //
    //                                                                                       responseAray2 = await characteristicReadPurpose.read();
    //                                                                                       String responseInString = utf8.decode(responseAray2);
    //                                                                                       Serial = removeCodesFromStrings(responseInString, COMMAND_INDEX_2_GET_);
    //                                                                                       if (Serial.length == 0) {
    //                                                                                         getSerial2();
    //                                                                                       } else if (!iceSerial.contains("Default") && !Serial.contains("Default") && iceSerial != "Default" && Serial != "Default" && iceSerial != "No command presen" && Serial != "No command presen") {
    //                                                                                         print("g X");
    //                                                                                         //  lookUpBoard(Serial, iceSerial, scaffoldKey, characteristicReadPurpose, characteristicWritePurpose, r.device,);
    //                                                                                       } else {
    //                                                                                         print("h X");
    //
    //                                                                                         // set up the button
    //                                                                                         Widget okButton = FlatButton(
    //                                                                                           child: Text("OK"),
    //                                                                                           onPressed: () {},
    //                                                                                         );
    //
    //                                                                                         // set up the AlertDialog
    //                                                                                         AlertDialog alert = AlertDialog(
    //                                                                                           title: Text("SN and/or ICE SN is Default"),
    //                                                                                           content: Column(
    //                                                                                             children: [
    //                                                                                               InkWell(
    //                                                                                                 onTap: () {
    //                                                                                                   TextEditingController controllerIce = new TextEditingController();
    //
    //                                                                                                   Navigator.push(
    //                                                                                                     context,
    //                                                                                                     MaterialPageRoute(
    //                                                                                                         builder: (context) => Scaffold(
    //                                                                                                           appBar: AppBar(
    //                                                                                                             title: Text("Update ICE SN"),
    //                                                                                                           ),
    //                                                                                                           body: Wrap(
    //                                                                                                             children: [
    //                                                                                                               Padding(
    //                                                                                                                 padding: const EdgeInsets.all(8.0),
    //                                                                                                                 child: TextField(
    //                                                                                                                   controller: controllerIce,
    //                                                                                                                 ),
    //                                                                                                               ),
    //                                                                                                               InkWell(
    //                                                                                                                 onTap: () async {
    //                                                                                                                   String commandToWrite = COMMAND_INDEX_1_SET + controllerIce.text + COMMAND_SUFFIX;
    //                                                                                                                   print("command " + commandToWrite);
    //
    //                                                                                                                   try {
    //                                                                                                                     await characteristicWritePurpose.write(StringToASCII(commandToWrite), withoutResponse: true);
    //                                                                                                                     Navigator.pop(context);
    //                                                                                                                     Navigator.pop(context);
    //                                                                                                                     iceSerial = controllerIce.text;
    //
    //                                                                                                                    // return true;
    //                                                                                                                   } catch (e) {
    //                                                                                                                     //return false;
    //                                                                                                                   }
    //                                                                                                                 },
    //                                                                                                                 child: Padding(
    //                                                                                                                   padding: const EdgeInsets.all(8.0),
    //                                                                                                                   child: Card(
    //                                                                                                                     color: Theme.of(context).primaryColor,
    //                                                                                                                     child: Center(
    //                                                                                                                       child: Padding(
    //                                                                                                                         padding: const EdgeInsets.all(8.0),
    //                                                                                                                         child: Text(
    //                                                                                                                           "Save",
    //                                                                                                                           style: TextStyle(color: Colors.white),
    //                                                                                                                         ),
    //                                                                                                                       ),
    //                                                                                                                     ),
    //                                                                                                                   ),
    //                                                                                                                 ),
    //                                                                                                               ),
    //                                                                                                             ],
    //                                                                                                           ),
    //                                                                                                         )),
    //                                                                                                   );
    //
    //                                                                                                 },
    //                                                                                                 child: Padding(
    //                                                                                                   padding: const EdgeInsets.all(8.0),
    //                                                                                                   child: ListTile(
    //                                                                                                     title: Text(iceSerial),
    //                                                                                                     subtitle: Text("Change  ICE SN"),
    //                                                                                                   ),
    //                                                                                                 ),
    //                                                                                               ),
    //                                                                                               InkWell(
    //                                                                                                 onTap: () {
    //                                                                                                   TextEditingController controller = new TextEditingController();
    //
    //                                                                                                   Navigator.push(
    //                                                                                                     context,
    //                                                                                                     MaterialPageRoute(
    //                                                                                                         builder: (context) => Scaffold(
    //                                                                                                           appBar: AppBar(
    //                                                                                                             title: Text("Update  SN"),
    //                                                                                                           ),
    //                                                                                                           body: Wrap(
    //                                                                                                             children: [
    //                                                                                                               Padding(
    //                                                                                                                 padding: const EdgeInsets.all(8.0),
    //                                                                                                                 child: TextField(
    //                                                                                                                   controller: controller,
    //                                                                                                                 ),
    //                                                                                                               ),
    //                                                                                                               InkWell(
    //                                                                                                                 onTap: () async {
    //                                                                                                                   String commandToWrite = COMMAND_INDEX_2_SET + controller.text + COMMAND_SUFFIX;
    //                                                                                                                   print("command " + commandToWrite);
    //
    //                                                                                                                   try {
    //                                                                                                                     await characteristicWritePurpose.write(StringToASCII(commandToWrite), withoutResponse: true);
    //                                                                                                                     Navigator.pop(context);
    //                                                                                                                     Navigator.pop(context);
    //
    //                                                                                                                     Serial = controller.text;
    //
    //                                                                                                                   } catch (e) {
    //                                                                                                                   }
    //                                                                                                                 },
    //                                                                                                                 child: Padding(
    //                                                                                                                   padding: const EdgeInsets.all(8.0),
    //                                                                                                                   child: Card(
    //                                                                                                                     color: Theme.of(context).primaryColor,
    //                                                                                                                     child: Center(
    //                                                                                                                       child: Padding(
    //                                                                                                                         padding: const EdgeInsets.all(8.0),
    //                                                                                                                         child: Text(
    //                                                                                                                           "Save",
    //                                                                                                                           style: TextStyle(color: Colors.white),
    //                                                                                                                         ),
    //                                                                                                                       ),
    //                                                                                                                     ),
    //                                                                                                                   ),
    //                                                                                                                 ),
    //                                                                                                               ),
    //                                                                                                             ],
    //                                                                                                           ),
    //                                                                                                         )),
    //                                                                                                   );
    //
    //                                                                                                 },
    //                                                                                                 child: Padding(
    //                                                                                                   padding: const EdgeInsets.all(8.0),
    //                                                                                                   child: ListTile(
    //                                                                                                     title: Text(Serial),
    //                                                                                                     subtitle: Text("Change  SN"),
    //                                                                                                   ),
    //                                                                                                 ),
    //                                                                                               ),
    //                                                                                             ],
    //                                                                                           ),
    //                                                                                           actions: [
    //                                                                                             okButton,
    //                                                                                           ],
    //                                                                                         );
    //
    //                                                                                         // show the dialog
    //                                                                                         // showDialog(
    //                                                                                         //   context: context,
    //                                                                                         //   builder: (BuildContext context) {
    //                                                                                         //     return alert;
    //                                                                                         //   },
    //                                                                                         // );
    //
    //
    //
    //                                                                                         GlobalKey<ScaffoldState> scaffoldKey2 = GlobalKey<ScaffoldState>();
    //                                                                                         Navigator.push(
    //                                                                                             context,
    //                                                                                             MaterialPageRoute(
    //                                                                                                 builder: (context) => Scaffold(
    //                                                                                                     key: scaffoldKey2,
    //                                                                                                     appBar: AppBar(),
    //                                                                                                     body: Column(
    //                                                                                                       children: [
    //                                                                                                         ListTile(
    //                                                                                                           title: Text("SN and/or ICE SN is Default."),
    //                                                                                                           tileColor: Theme.of(context).primaryColor.withOpacity(0.1),
    //                                                                                                         ),
    //                                                                                                         InkWell(
    //                                                                                                           onTap: () {
    //                                                                                                             TextEditingController controllerIce = new TextEditingController();
    //
    //                                                                                                             Navigator.push(
    //                                                                                                               context,
    //                                                                                                               MaterialPageRoute(
    //                                                                                                                   builder: (context) => Scaffold(
    //                                                                                                                     appBar: AppBar(
    //                                                                                                                       title: Text("Update ICE SN"),
    //                                                                                                                     ),
    //                                                                                                                     body: Wrap(
    //                                                                                                                       children: [
    //                                                                                                                         Padding(
    //                                                                                                                           padding: const EdgeInsets.all(8.0),
    //                                                                                                                           child: TextField(
    //                                                                                                                             controller: controllerIce,
    //                                                                                                                           ),
    //                                                                                                                         ),
    //                                                                                                                         InkWell(
    //                                                                                                                           onTap: () async {
    //                                                                                                                             String commandToWrite = COMMAND_INDEX_1_SET + controllerIce.text + COMMAND_SUFFIX;
    //                                                                                                                             print("command " + commandToWrite);
    //
    //                                                                                                                             try {
    //                                                                                                                               await characteristicWritePurpose.write(StringToASCII(commandToWrite), withoutResponse: true);
    //                                                                                                                               Navigator.pop(context);
    //                                                                                                                               Navigator.pop(context);
    //                                                                                                                               iceSerial = controllerIce.text;
    //
    //
    //                                                                                                                             } catch (e) {
    //
    //                                                                                                                             }
    //                                                                                                                           },
    //                                                                                                                           child: Padding(
    //                                                                                                                             padding: const EdgeInsets.all(8.0),
    //                                                                                                                             child: Card(
    //                                                                                                                               color: Theme.of(context).primaryColor,
    //                                                                                                                               child: Center(
    //                                                                                                                                 child: Padding(
    //                                                                                                                                   padding: const EdgeInsets.all(8.0),
    //                                                                                                                                   child: Text(
    //                                                                                                                                     "Save",
    //                                                                                                                                     style: TextStyle(color: Colors.white),
    //                                                                                                                                   ),
    //                                                                                                                                 ),
    //                                                                                                                               ),
    //                                                                                                                             ),
    //                                                                                                                           ),
    //                                                                                                                         ),
    //                                                                                                                       ],
    //                                                                                                                     ),
    //                                                                                                                   )),
    //                                                                                                             );
    //
    //                                                                                                           },
    //                                                                                                           child: Padding(
    //                                                                                                             padding: const EdgeInsets.all(8.0),
    //                                                                                                             child: ListTile(
    //                                                                                                               title: Text(iceSerial),
    //                                                                                                               subtitle: Text("Change  ICE SN"),
    //                                                                                                             ),
    //                                                                                                           ),
    //                                                                                                         ),
    //                                                                                                         InkWell(
    //                                                                                                           onTap: () {
    //                                                                                                             TextEditingController controller = new TextEditingController();
    //
    //                                                                                                             Navigator.push(
    //                                                                                                               context,
    //                                                                                                               MaterialPageRoute(
    //                                                                                                                   builder: (context) => Scaffold(
    //                                                                                                                     appBar: AppBar(
    //                                                                                                                       title: Text("Update  SN"),
    //                                                                                                                     ),
    //                                                                                                                     body: Wrap(
    //                                                                                                                       children: [
    //                                                                                                                         Padding(
    //                                                                                                                           padding: const EdgeInsets.all(8.0),
    //                                                                                                                           child: TextField(
    //                                                                                                                             controller: controller,
    //                                                                                                                           ),
    //                                                                                                                         ),
    //                                                                                                                         InkWell(
    //                                                                                                                           onTap: () async {
    //                                                                                                                             String commandToWrite = COMMAND_INDEX_2_SET + controller.text + COMMAND_SUFFIX;
    //                                                                                                                             print("command " + commandToWrite);
    //
    //                                                                                                                             try {
    //                                                                                                                               await characteristicWritePurpose.write(StringToASCII(commandToWrite), withoutResponse: true);
    //                                                                                                                               Navigator.pop(context);
    //                                                                                                                               Navigator.pop(context);
    //                                                                                                                               Serial = controller.text;
    //
    //
    //                                                                                                                             } catch (e) {
    //
    //                                                                                                                             }
    //                                                                                                                           },
    //                                                                                                                           child: Padding(
    //                                                                                                                             padding: const EdgeInsets.all(8.0),
    //                                                                                                                             child: Card(
    //                                                                                                                               color: Theme.of(context).primaryColor,
    //                                                                                                                               child: Center(
    //                                                                                                                                 child: Padding(
    //                                                                                                                                   padding: const EdgeInsets.all(8.0),
    //                                                                                                                                   child: Text(
    //                                                                                                                                     "Save",
    //                                                                                                                                     style: TextStyle(color: Colors.white),
    //                                                                                                                                   ),
    //                                                                                                                                 ),
    //                                                                                                                               ),
    //                                                                                                                             ),
    //                                                                                                                           ),
    //                                                                                                                         ),
    //                                                                                                                       ],
    //                                                                                                                     ),
    //                                                                                                                   )),
    //                                                                                                             );
    //
    //                                                                                                           },
    //                                                                                                           child: Padding(
    //                                                                                                             padding: const EdgeInsets.all(8.0),
    //                                                                                                             child: ListTile(
    //                                                                                                               title: Text(Serial),
    //                                                                                                               subtitle: Text("Change SN"),
    //                                                                                                             ),
    //                                                                                                           ),
    //                                                                                                         ),
    //                                                                                                       ],
    //                                                                                                     ))));
    //                                                                                       }
    //                                                                                     }
    //
    //                                                                                     getICESerial2() async {
    //                                                                                       print("d X");
    //                                                                                       await characteristicWritePurpose.write(StringToASCII(COMMAND_INDEX_1_GET_), withoutResponse: true);
    //                                                                                       List<int> responseAray2 = await characteristicReadPurpose.read();
    //                                                                                       await characteristicWritePurpose.write(StringToASCII(COMMAND_INDEX_1_GET_), withoutResponse: true);
    //                                                                                       responseAray2 = await characteristicReadPurpose.read();
    //                                                                                       String responseInString = utf8.decode(responseAray2);
    //                                                                                       iceSerial = removeCodesFromStrings(responseInString, COMMAND_INDEX_1_GET_);
    //                                                                                       if (iceSerial.length == 0) {
    //                                                                                         print("e X");
    //                                                                                         getICESerial2();
    //                                                                                       }
    //                                                                                       if (Serial.length == 0) {
    //                                                                                         print("e X");
    //                                                                                         getSerial2();
    //                                                                                       } else {
    //                                                                                         //lookUpBoard(Serial, iceSerial, scaffoldKey, characteristicReadPurpose, characteristicWritePurpose, r.device);
    //                                                                                       }
    //                                                                                     }
    //
    //                                                                                     getSerial() async {
    //                                                                                       print("c X");
    //                                                                                       await characteristicWritePurpose.write(StringToASCII(COMMAND_INDEX_2_GET_), withoutResponse: true);
    //
    //                                                                                       List<int> responseAray2 = await characteristicReadPurpose.read();
    //                                                                                       await characteristicWritePurpose.write(StringToASCII(COMMAND_INDEX_2_GET_), withoutResponse: true);
    //
    //                                                                                       responseAray2 = await characteristicReadPurpose.read();
    //                                                                                       String responseInString = utf8.decode(responseAray2);
    //                                                                                       Serial = removeCodesFromStrings(responseInString, COMMAND_INDEX_2_GET_);
    //                                                                                       if (Serial.length == 0) {
    //                                                                                         getSerial();
    //                                                                                       }
    //                                                                                       if (iceSerial.length == 0) {
    //                                                                                         getICESerial2();
    //                                                                                       } else if (!iceSerial.contains("Default") && !Serial.contains("Default") && iceSerial != "Default" && Serial != "Default" && iceSerial != "No command presen" && Serial != "No command presen") {
    //                                                                                         print("g X");
    //                                                                                         // lookUpBoard(Serial, iceSerial, scaffoldKey, characteristicReadPurpose, characteristicWritePurpose, r.device);
    //                                                                                       } else {
    //                                                                                         print("h X");
    //
    //                                                                                         // set up the button
    //                                                                                         Widget okButton = FlatButton(
    //                                                                                           child: Text("OK"),
    //                                                                                           onPressed: () {},
    //                                                                                         );
    //
    //                                                                                         // set up the AlertDialog
    //                                                                                         AlertDialog alert = AlertDialog(
    //                                                                                           title: Text("SN and/or ICE SN is Default"),
    //                                                                                           content: Column(
    //                                                                                             children: [
    //                                                                                               InkWell(
    //                                                                                                 onTap: () {
    //                                                                                                   TextEditingController controller = new TextEditingController();
    //
    //                                                                                                   Navigator.push(
    //                                                                                                     context,
    //                                                                                                     MaterialPageRoute(
    //                                                                                                         builder: (context) => Scaffold(
    //                                                                                                           appBar: AppBar(
    //                                                                                                             title: Text("Update ICE SN"),
    //                                                                                                           ),
    //                                                                                                           body: Wrap(
    //                                                                                                             children: [
    //                                                                                                               Padding(
    //                                                                                                                 padding: const EdgeInsets.all(8.0),
    //                                                                                                                 child: TextField(
    //                                                                                                                   controller: controller,
    //                                                                                                                 ),
    //                                                                                                               ),
    //                                                                                                               InkWell(
    //                                                                                                                 onTap: () async {
    //                                                                                                                   String commandToWrite = COMMAND_INDEX_1_SET + controller.text + COMMAND_SUFFIX;
    //                                                                                                                   print("command " + commandToWrite);
    //
    //                                                                                                                   try {
    //                                                                                                                     await characteristicWritePurpose.write(StringToASCII(commandToWrite), withoutResponse: true);
    //                                                                                                                     Navigator.pop(context);
    //                                                                                                                     Navigator.pop(context);
    //
    //
    //                                                                                                                   } catch (e) {
    //
    //                                                                                                                   }
    //                                                                                                                 },
    //                                                                                                                 child: Padding(
    //                                                                                                                   padding: const EdgeInsets.all(8.0),
    //                                                                                                                   child: Card(
    //                                                                                                                     color: Theme.of(context).primaryColor,
    //                                                                                                                     child: Center(
    //                                                                                                                       child: Padding(
    //                                                                                                                         padding: const EdgeInsets.all(8.0),
    //                                                                                                                         child: Text(
    //                                                                                                                           "Save",
    //                                                                                                                           style: TextStyle(color: Colors.white),
    //                                                                                                                         ),
    //                                                                                                                       ),
    //                                                                                                                     ),
    //                                                                                                                   ),
    //                                                                                                                 ),
    //                                                                                                               ),
    //                                                                                                             ],
    //                                                                                                           ),
    //                                                                                                         )),
    //                                                                                                   );
    //
    //                                                                                                 },
    //                                                                                                 child: Padding(
    //                                                                                                   padding: const EdgeInsets.all(8.0),
    //                                                                                                   child: ListTile(
    //                                                                                                     title: Text(iceSerial),
    //                                                                                                     subtitle: Text("Change  SN"),
    //                                                                                                   ),
    //                                                                                                 ),
    //                                                                                               ),
    //                                                                                               InkWell(
    //                                                                                                 onTap: () {
    //                                                                                                   TextEditingController controller = new TextEditingController();
    //
    //                                                                                                   Navigator.push(
    //                                                                                                     context,
    //                                                                                                     MaterialPageRoute(
    //                                                                                                         builder: (context) => Scaffold(
    //                                                                                                           appBar: AppBar(
    //                                                                                                             title: Text("Update  SN"),
    //                                                                                                           ),
    //                                                                                                           body: Wrap(
    //                                                                                                             children: [
    //                                                                                                               Padding(
    //                                                                                                                 padding: const EdgeInsets.all(8.0),
    //                                                                                                                 child: TextField(
    //                                                                                                                   controller: controller,
    //                                                                                                                 ),
    //                                                                                                               ),
    //                                                                                                               InkWell(
    //                                                                                                                 onTap: () async {
    //                                                                                                                   String commandToWrite = COMMAND_INDEX_2_SET + controller.text + COMMAND_SUFFIX;
    //                                                                                                                   print("command " + commandToWrite);
    //
    //                                                                                                                   try {
    //                                                                                                                     await characteristicWritePurpose.write(StringToASCII(commandToWrite), withoutResponse: true);
    //                                                                                                                     Navigator.pop(context);
    //                                                                                                                     Navigator.pop(context);
    //
    //
    //                                                                                                                   } catch (e) {
    //
    //                                                                                                                   }
    //                                                                                                                 },
    //                                                                                                                 child: Padding(
    //                                                                                                                   padding: const EdgeInsets.all(8.0),
    //                                                                                                                   child: Card(
    //                                                                                                                     color: Theme.of(context).primaryColor,
    //                                                                                                                     child: Center(
    //                                                                                                                       child: Padding(
    //                                                                                                                         padding: const EdgeInsets.all(8.0),
    //                                                                                                                         child: Text(
    //                                                                                                                           "Save",
    //                                                                                                                           style: TextStyle(color: Colors.white),
    //                                                                                                                         ),
    //                                                                                                                       ),
    //                                                                                                                     ),
    //                                                                                                                   ),
    //                                                                                                                 ),
    //                                                                                                               ),
    //                                                                                                             ],
    //                                                                                                           ),
    //                                                                                                         )),
    //                                                                                                   );
    //
    //                                                                                                 },
    //                                                                                                 child: Padding(
    //                                                                                                   padding: const EdgeInsets.all(8.0),
    //                                                                                                   child: ListTile(
    //                                                                                                     title: Text(iceSerial),
    //                                                                                                     subtitle: Text("Change Ice SN"),
    //                                                                                                   ),
    //                                                                                                 ),
    //                                                                                               ),
    //                                                                                             ],
    //                                                                                           ),
    //                                                                                           actions: [
    //                                                                                             okButton,
    //                                                                                           ],
    //                                                                                         );
    //
    //                                                                                         // show the dialog
    //                                                                                         // showDialog(
    //                                                                                         //   context: context,
    //                                                                                         //   builder: (BuildContext context) {
    //                                                                                         //     return alert;
    //                                                                                         //   },
    //                                                                                         // );
    //
    //
    //
    //
    //                                                                                         Navigator.push(
    //                                                                                             context,
    //                                                                                             MaterialPageRoute(
    //                                                                                                 builder: (context) => Scaffold(
    //                                                                                                     appBar: AppBar(),
    //                                                                                                     body: Column(
    //                                                                                                       children: [
    //                                                                                                         ListTile(
    //                                                                                                           title: Text("SN and/or ICE SN is Default."),
    //                                                                                                           tileColor: Theme.of(context).primaryColor.withOpacity(0.1),
    //                                                                                                         ),
    //                                                                                                         InkWell(
    //                                                                                                           onTap: () {
    //                                                                                                             TextEditingController controllerICe = new TextEditingController();
    //
    //                                                                                                             Navigator.push(
    //                                                                                                               context,
    //                                                                                                               MaterialPageRoute(
    //                                                                                                                   builder: (context) => Scaffold(
    //                                                                                                                     appBar: AppBar(
    //                                                                                                                       title: Text("Update ICE SN"),
    //                                                                                                                     ),
    //                                                                                                                     body: Wrap(
    //                                                                                                                       children: [
    //                                                                                                                         Padding(
    //                                                                                                                           padding: const EdgeInsets.all(8.0),
    //                                                                                                                           child: TextField(
    //                                                                                                                             controller: controllerICe,
    //                                                                                                                           ),
    //                                                                                                                         ),
    //                                                                                                                         InkWell(
    //                                                                                                                           onTap: () async {
    //                                                                                                                             String commandToWrite = COMMAND_INDEX_1_SET + controllerICe.text + COMMAND_SUFFIX;
    //                                                                                                                             print("command " + commandToWrite);
    //
    //                                                                                                                             try {
    //                                                                                                                               await characteristicWritePurpose.write(StringToASCII(commandToWrite), withoutResponse: true);
    //                                                                                                                               Navigator.pop(context);
    //                                                                                                                               Navigator.pop(context);
    //                                                                                                                               iceSerial = controllerICe.text;
    //                                                                                                                               getICESerial2();
    //
    //                                                                                                                             } catch (e) {
    //
    //                                                                                                                             }
    //                                                                                                                           },
    //                                                                                                                           child: Padding(
    //                                                                                                                             padding: const EdgeInsets.all(8.0),
    //                                                                                                                             child: Card(
    //                                                                                                                               color: Theme.of(context).primaryColor,
    //                                                                                                                               child: Center(
    //                                                                                                                                 child: Padding(
    //                                                                                                                                   padding: const EdgeInsets.all(8.0),
    //                                                                                                                                   child: Text(
    //                                                                                                                                     "Save",
    //                                                                                                                                     style: TextStyle(color: Colors.white),
    //                                                                                                                                   ),
    //                                                                                                                                 ),
    //                                                                                                                               ),
    //                                                                                                                             ),
    //                                                                                                                           ),
    //                                                                                                                         ),
    //                                                                                                                       ],
    //                                                                                                                     ),
    //                                                                                                                   )),
    //                                                                                                             );
    //
    //
    //                                                                                                           },
    //                                                                                                           child: Padding(
    //                                                                                                             padding: const EdgeInsets.all(8.0),
    //                                                                                                             child: ListTile(
    //                                                                                                               title: Text(iceSerial),
    //                                                                                                               subtitle: Text("Change  SN"),
    //                                                                                                             ),
    //                                                                                                           ),
    //                                                                                                         ),
    //                                                                                                         InkWell(
    //                                                                                                           onTap: () {
    //                                                                                                             TextEditingController controller = new TextEditingController();
    //
    //                                                                                                             Navigator.push(
    //                                                                                                               context,
    //                                                                                                               MaterialPageRoute(
    //                                                                                                                   builder: (context) => Scaffold(
    //                                                                                                                     appBar: AppBar(
    //                                                                                                                       title: Text("Update  SN"),
    //                                                                                                                     ),
    //                                                                                                                     body: Wrap(
    //                                                                                                                       children: [
    //                                                                                                                         Padding(
    //                                                                                                                           padding: const EdgeInsets.all(8.0),
    //                                                                                                                           child: TextField(
    //                                                                                                                             controller: controller,
    //                                                                                                                           ),
    //                                                                                                                         ),
    //                                                                                                                         InkWell(
    //                                                                                                                           onTap: () async {
    //                                                                                                                             String commandToWrite = COMMAND_INDEX_2_SET + controller.text + COMMAND_SUFFIX;
    //                                                                                                                             print("command " + commandToWrite);
    //
    //                                                                                                                             try {
    //                                                                                                                               await characteristicWritePurpose.write(StringToASCII(commandToWrite), withoutResponse: true);
    //                                                                                                                               Serial = controller.text;
    //                                                                                                                               Navigator.pop(context);
    //                                                                                                                               Navigator.pop(context);
    //                                                                                                                               getICESerial2();
    //
    //                                                                                                                             } catch (e) {
    //
    //                                                                                                                             }
    //                                                                                                                           },
    //                                                                                                                           child: Padding(
    //                                                                                                                             padding: const EdgeInsets.all(8.0),
    //                                                                                                                             child: Card(
    //                                                                                                                               color: Theme.of(context).primaryColor,
    //                                                                                                                               child: Center(
    //                                                                                                                                 child: Padding(
    //                                                                                                                                   padding: const EdgeInsets.all(8.0),
    //                                                                                                                                   child: Text(
    //                                                                                                                                     "Save",
    //                                                                                                                                     style: TextStyle(color: Colors.white),
    //                                                                                                                                   ),
    //                                                                                                                                 ),
    //                                                                                                                               ),
    //                                                                                                                             ),
    //                                                                                                                           ),
    //                                                                                                                         ),
    //                                                                                                                       ],
    //                                                                                                                     ),
    //                                                                                                                   )),
    //                                                                                                             );
    //
    //                                                                                                           },
    //                                                                                                           child: Padding(
    //                                                                                                             padding: const EdgeInsets.all(8.0),
    //                                                                                                             child: ListTile(
    //                                                                                                               title: Text(Serial),
    //                                                                                                               subtitle: Text("Change SN"),
    //                                                                                                             ),
    //                                                                                                           ),
    //                                                                                                         ),
    //                                                                                                       ],
    //                                                                                                     ))));
    //                                                                                       }
    //                                                                                     }
    //
    //                                                                                     //get ice
    //                                                                                     await characteristicWritePurpose.write(StringToASCII(COMMAND_INDEX_1_GET_), withoutResponse: true);
    //                                                                                     List<int> responseAray2 = await characteristicReadPurpose.read();
    //                                                                                     await characteristicWritePurpose.write(StringToASCII(COMMAND_INDEX_1_GET_), withoutResponse: true);
    //                                                                                     responseAray2 = await characteristicReadPurpose.read();
    //                                                                                     String responseInString = utf8.decode(responseAray2);
    //                                                                                     iceSerial = removeCodesFromStrings(responseInString, COMMAND_INDEX_1_GET_);
    //
    //                                                                                     await characteristicWritePurpose.write(StringToASCII(COMMAND_INDEX_1_GET_), withoutResponse: true);
    //                                                                                     responseAray2 = await characteristicReadPurpose.read();
    //                                                                                     await characteristicWritePurpose.write(StringToASCII(COMMAND_INDEX_1_GET_), withoutResponse: true);
    //                                                                                     responseAray2 = await characteristicReadPurpose.read();
    //                                                                                     responseInString = utf8.decode(responseAray2);
    //                                                                                     iceSerial = removeCodesFromStrings(responseInString, COMMAND_INDEX_1_GET_);
    //
    //                                                                                     await characteristicWritePurpose.write(StringToASCII(COMMAND_INDEX_1_GET_), withoutResponse: true);
    //                                                                                     responseAray2 = await characteristicReadPurpose.read();
    //                                                                                     await characteristicWritePurpose.write(StringToASCII(COMMAND_INDEX_1_GET_), withoutResponse: true);
    //                                                                                     responseAray2 = await characteristicReadPurpose.read();
    //                                                                                     responseInString = utf8.decode(responseAray2);
    //                                                                                     iceSerial = removeCodesFromStrings(responseInString, COMMAND_INDEX_1_GET_);
    //                                                                                     //end ice
    //
    //                                                                                     //get sl
    //                                                                                     await characteristicWritePurpose.write(StringToASCII(COMMAND_INDEX_2_GET_), withoutResponse: true);
    //
    //                                                                                     responseAray2 = await characteristicReadPurpose.read();
    //                                                                                     await characteristicWritePurpose.write(StringToASCII(COMMAND_INDEX_2_GET_), withoutResponse: true);
    //
    //                                                                                     responseAray2 = await characteristicReadPurpose.read();
    //                                                                                     responseInString = utf8.decode(responseAray2);
    //                                                                                     Serial = removeCodesFromStrings(responseInString, COMMAND_INDEX_2_GET_);
    //                                                                                     await characteristicWritePurpose.write(StringToASCII(COMMAND_INDEX_2_GET_), withoutResponse: true);
    //
    //                                                                                     responseAray2 = await characteristicReadPurpose.read();
    //                                                                                     await characteristicWritePurpose.write(StringToASCII(COMMAND_INDEX_2_GET_), withoutResponse: true);
    //
    //                                                                                     responseAray2 = await characteristicReadPurpose.read();
    //                                                                                     responseInString = utf8.decode(responseAray2);
    //                                                                                     Serial = removeCodesFromStrings(responseInString, COMMAND_INDEX_2_GET_);
    //                                                                                     await characteristicWritePurpose.write(StringToASCII(COMMAND_INDEX_2_GET_), withoutResponse: true);
    //
    //                                                                                     responseAray2 = await characteristicReadPurpose.read();
    //                                                                                     await characteristicWritePurpose.write(StringToASCII(COMMAND_INDEX_2_GET_), withoutResponse: true);
    //
    //                                                                                     responseAray2 = await characteristicReadPurpose.read();
    //                                                                                     responseInString = utf8.decode(responseAray2);
    //                                                                                     Serial = removeCodesFromStrings(responseInString, COMMAND_INDEX_2_GET_);
    //                                                                                     //end sl
    //
    //                                                                                     // scaffoldKey.currentState.showBottomSheet((context) => Scaffold(
    //                                                                                     //       body: Column(
    //                                                                                     //         children: [],
    //                                                                                     //       ),
    //                                                                                     //     ));
    //                                                                                     GlobalKey<ScaffoldState> scaffoldKey20 = GlobalKey<ScaffoldState>();
    //                                                                                     Navigator.push(
    //                                                                                         context,
    //                                                                                         MaterialPageRoute(
    //                                                                                             builder: (context) =>Scaffold(key: scaffoldKey20,appBar: AppBar(),
    //                                                                                               body: Column(
    //                                                                                                 children: [
    //                                                                                                   InkWell(
    //                                                                                                     onTap: () {
    //                                                                                                       TextEditingController controllerIce = new TextEditingController();
    //
    //                                                                                                       Navigator.push(
    //                                                                                                         context,
    //                                                                                                         MaterialPageRoute(
    //                                                                                                             builder: (context) => Scaffold(
    //                                                                                                               appBar: AppBar(
    //                                                                                                                 title: Text("Update ICE SN"),
    //                                                                                                               ),
    //                                                                                                               body: Wrap(
    //                                                                                                                 children: [
    //                                                                                                                   Padding(
    //                                                                                                                     padding: const EdgeInsets.all(8.0),
    //                                                                                                                     child: TextField(
    //                                                                                                                       controller: controllerIce,
    //                                                                                                                     ),
    //                                                                                                                   ),
    //                                                                                                                   InkWell(
    //                                                                                                                     onTap: () async {
    //                                                                                                                       String commandToWrite = COMMAND_INDEX_1_SET + controllerIce.text + COMMAND_SUFFIX;
    //                                                                                                                       print("command " + commandToWrite);
    //
    //                                                                                                                       try {
    //                                                                                                                         await characteristicWritePurpose.write(StringToASCII(commandToWrite), withoutResponse: true);
    //                                                                                                                         Navigator.pop(context);
    //                                                                                                                         // Navigator.pop(context);
    //                                                                                                                         iceSerial = controllerIce.text;
    //                                                                                                                         Index1ValueStream.getInstance().dataReload( controllerIce.text);
    //
    //
    //                                                                                                                       } catch (e) {
    //
    //                                                                                                                       }
    //                                                                                                                     },
    //                                                                                                                     child: Padding(
    //                                                                                                                       padding: const EdgeInsets.all(8.0),
    //                                                                                                                       child: Card(
    //                                                                                                                         color: Theme.of(context).primaryColor,
    //                                                                                                                         child: Center(
    //                                                                                                                           child: Padding(
    //                                                                                                                             padding: const EdgeInsets.all(8.0),
    //                                                                                                                             child: Text(
    //                                                                                                                               "Save",
    //                                                                                                                               style: TextStyle(color: Colors.white),
    //                                                                                                                             ),
    //                                                                                                                           ),
    //                                                                                                                         ),
    //                                                                                                                       ),
    //                                                                                                                     ),
    //                                                                                                                   ),
    //                                                                                                                 ],
    //                                                                                                               ),
    //                                                                                                             )),
    //                                                                                                       );
    //                                                                                                     },
    //                                                                                                     child: Padding(
    //                                                                                                       padding: const EdgeInsets.all(8.0),
    //                                                                                                       child: ListTile(
    //                                                                                                         title: StreamBuilder(
    //                                                                                                             stream: Index1ValueStream.getInstance().outData,
    //                                                                                                             initialData: iceSerial,
    //                                                                                                             builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
    //                                                                                                               if (snapshot.hasData) {
    //                                                                                                                 return Text(snapshot.data!);
    //                                                                                                               } else {
    //                                                                                                                 return Text("Please wait");
    //                                                                                                               }
    //                                                                                                             }),
    //                                                                                                         subtitle: Text("Change  ICE SN"),
    //                                                                                                       ),
    //                                                                                                     ),
    //                                                                                                   ),
    //                                                                                                   InkWell(
    //                                                                                                     onTap: () {
    //                                                                                                       TextEditingController controller = new TextEditingController();
    //
    //                                                                                                       Navigator.push(
    //                                                                                                         context,
    //                                                                                                         MaterialPageRoute(
    //                                                                                                             builder: (context) => Scaffold(
    //                                                                                                               appBar: AppBar(
    //                                                                                                                 title: Text("Update  SN"),
    //                                                                                                               ),
    //                                                                                                               body: Wrap(
    //                                                                                                                 children: [
    //                                                                                                                   Padding(
    //                                                                                                                     padding: const EdgeInsets.all(8.0),
    //                                                                                                                     child: TextField(
    //                                                                                                                       controller: controller,
    //                                                                                                                     ),
    //                                                                                                                   ),
    //                                                                                                                   InkWell(
    //                                                                                                                     onTap: () async {
    //                                                                                                                       String commandToWrite = COMMAND_INDEX_2_SET + controller.text + COMMAND_SUFFIX;
    //                                                                                                                       print("command " + commandToWrite);
    //
    //                                                                                                                       try {
    //                                                                                                                         await characteristicWritePurpose.write(StringToASCII(commandToWrite), withoutResponse: true);
    //                                                                                                                         Navigator.pop(context);
    //                                                                                                                         Index2ValueStream.getInstance().dataReload( controller.text);
    //                                                                                                                         //Navigator.pop(context);
    //
    //                                                                                                                         Serial = controller.text;
    //
    //
    //                                                                                                                       } catch (e) {
    //
    //                                                                                                                       }
    //                                                                                                                     },
    //                                                                                                                     child: Padding(
    //                                                                                                                       padding: const EdgeInsets.all(8.0),
    //                                                                                                                       child: Card(
    //                                                                                                                         color: Theme.of(context).primaryColor,
    //                                                                                                                         child: Center(
    //                                                                                                                           child: Padding(
    //                                                                                                                             padding: const EdgeInsets.all(8.0),
    //                                                                                                                             child: Text(
    //                                                                                                                               "Save",
    //                                                                                                                               style: TextStyle(color: Colors.white),
    //                                                                                                                             ),
    //                                                                                                                           ),
    //                                                                                                                         ),
    //                                                                                                                       ),
    //                                                                                                                     ),
    //                                                                                                                   ),
    //                                                                                                                 ],
    //                                                                                                               ),
    //                                                                                                             )),
    //                                                                                                       );
    //
    //                                                                                                     },
    //                                                                                                     child: Padding(
    //                                                                                                       padding: const EdgeInsets.all(8.0),
    //                                                                                                       child: ListTile(
    //                                                                                                         title: StreamBuilder(
    //                                                                                                             stream: Index2ValueStream.getInstance().outData,
    //                                                                                                             initialData: Serial,
    //                                                                                                             builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
    //                                                                                                               if (snapshot.hasData) {
    //                                                                                                                 return Text(snapshot.data!);
    //                                                                                                               } else {
    //                                                                                                                 return Text("Please wait");
    //                                                                                                               }
    //                                                                                                             }),
    //                                                                                                         subtitle: Text("Change  SN"),
    //                                                                                                       ),
    //                                                                                                     ),
    //                                                                                                   ),
    //
    //                                                                                                   //   Directory_1_view_edit(
    //                                                                                                   //   bluetoothCharacteristicWrite: characteristicWritePurpose,
    //                                                                                                   //   bluetoothCharacteristicRead: characteristicReadPurpose,
    //                                                                                                   // ),
    //                                                                                                   //
    //                                                                                                   //   Directory_2_view_edit(
    //                                                                                                   //     bluetoothCharacteristicWrite:characteristicWritePurpose,
    //                                                                                                   //     bluetoothCharacteristicRead: characteristicReadPurpose,
    //                                                                                                   //   ),
    //                                                                                                   InkWell(
    //                                                                                                     onTap: () {
    //                                                                                                       lookUpBoard(getCalibratorId(snapshotprofile.data!.docs.first),Serial, iceSerial, scaffoldKey20, characteristicReadPurpose, characteristicWritePurpose, r.device,context,snapshotprofile.data!.docs.first,);
    //                                                                                                     },
    //                                                                                                     child: Card(
    //                                                                                                       color: Colors.blue,
    //                                                                                                       child: Container(
    //                                                                                                           child: Center(
    //                                                                                                               child: Padding(
    //                                                                                                                 padding: const EdgeInsets.all(8.0),
    //                                                                                                                 child: Text(
    //                                                                                                                   "Register",
    //                                                                                                                   style: TextStyle(color: Colors.white),
    //                                                                                                                 ),
    //                                                                                                               ))),
    //                                                                                                     ),
    //                                                                                                   ),
    //                                                                                                 ],
    //                                                                                               ),
    //                                                                                             )));
    //
    //
    //                                                                                     // scaffoldKey.currentState.showBottomSheet((context) => );
    //
    //                                                                                     getICESerial() async {
    //                                                                                       print("d X");
    //                                                                                       await characteristicWritePurpose.write(StringToASCII(COMMAND_INDEX_1_GET_), withoutResponse: true);
    //                                                                                       List<int> responseAray2 = await characteristicReadPurpose.read();
    //                                                                                       await characteristicWritePurpose.write(StringToASCII(COMMAND_INDEX_1_GET_), withoutResponse: true);
    //                                                                                       responseAray2 = await characteristicReadPurpose.read();
    //                                                                                       String responseInString = utf8.decode(responseAray2);
    //                                                                                       iceSerial = removeCodesFromStrings(responseInString, COMMAND_INDEX_1_GET_);
    //                                                                                       if (iceSerial.length == 0) {
    //                                                                                         print("e X");
    //                                                                                         getICESerial();
    //                                                                                       } else {
    //                                                                                         print("f X");
    //                                                                                         getSerial();
    //                                                                                       }
    //                                                                                     }
    //
    //                                                                                     // getICESerial();
    //                                                                                   } else {
    //                                                                                     print("i X");
    //                                                                                     print("service side " + allservice.length.toString());
    //                                                                                   }
    //                                                                                 });
    //                                                                                 //return Text("ok");
    //                                                                                 //   return   PerformTestPage(device: r.device,project: widget.projectID,);
    //                                                                                 //return PerformTestPageActivity(device: r.device, project: "");
    //                                                                                 Navigator.pop(context);
    //                                                                                 //return ConnectedDevicePage(device: r.device);
    //                                                                                 //return DeviceScreenLessDetails(r.device);
    //                                                                               },
    //                                                                             ),
    //                                                                             //     (r) => ScanResultTile(
    //                                                                             //   result: r,
    //                                                                             //   onTap: () => Navigator.of(context)
    //                                                                             //       .push(MaterialPageRoute(builder: (context) {
    //                                                                             //     r.device.connect(autoConnect: false);
    //                                                                             //     //return Text("ok");
    //                                                                             //  //   return   PerformTestPage(device: r.device,project: widget.projectID,);
    //                                                                             //     return   PerformTestPage(device: r.device,project:"o",);
    //                                                                             //     Navigator.pop(context);
    //                                                                             //     //return ConnectedDevicePage(device: r.device);
    //                                                                             //     //return DeviceScreenLessDetails(r.device);
    //                                                                             //   })),
    //                                                                             // ),
    //                                                                           )
    //                                                                               .toList(),
    //                                                                         );
    //                                                                       },
    //                                                                     )
    //                                                                   ],
    //                                                                 ));
    //                                                       },
    //                                                       title: Text(
    //                                                           "No Device is Connected"),
    //                                                       trailing: Text(
    //                                                         "Scan",
    //                                                         style: TextStyle(
    //                                                             color: Colors
    //                                                                 .blue),
    //                                                       ),
    //                                                     );
    //                                                   }
    //                                                 },
    //                                               );
    //                                             }
    //                                             return ListTile(
    //                                               title:
    //                                               Text("Turn on Blutooth"),
    //                                               trailing: Icon(
    //                                                 Icons.bluetooth_disabled,
    //                                                 color: Theme.of(context)
    //                                                     .primaryColor,
    //                                               ),
    //                                             );
    //                                             //return BluetoothOffScreen(state: state);
    //                                           }),
    //                                     ],
    //                                   ),
    //                                 ),
    //                               ),
    //                             ),
    //                             Align(
    //                               alignment: Alignment.bottomCenter,
    //                               child: Padding(
    //                                 padding: EdgeInsets.all(8.0),
    //                                 child: Container(
    //                                   height: 50,
    //                                   decoration: BoxDecoration(
    //                                       borderRadius:
    //                                       BorderRadius.circular(5),
    //                                       border: Border.all(
    //                                           width: 2,
    //                                           color: Theme.of(context)
    //                                               .primaryColor)),
    //                                   child: Center(
    //                                     child: Text("Connect a new device"),
    //                                   ),
    //                                 ),
    //                               ),
    //                             ),
    //                           ],
    //                         ));
    //                   } else if (snapshotprofile.data!.docs.first
    //                       .get("roleId") ==
    //                       role_id_calibrator) {
    //                     return Scaffold(
    //                         appBar: AppBar(
    //                           leading: Padding(
    //                             padding: const EdgeInsets.all(8.0),
    //                             child: Icon(
    //                               Icons.account_box_outlined,
    //                               color: Colors.white,
    //                             ),
    //                           ),
    //                           title: Text(snapshotprofile.data!.docs.first
    //                               .get("displayName")),
    //                         ),
    //                         body: Stack(
    //                           children: [
    //                             Align(
    //                               alignment: Alignment.topCenter,
    //                               child: Padding(
    //                                 padding: EdgeInsets.all(8.0),
    //                                 child: Container(
    //                                   width: MediaQuery.of(context).size.width,
    //                                   height:
    //                                   (MediaQuery.of(context).size.height -
    //                                       160) /
    //                                       2,
    //                                   decoration: BoxDecoration(
    //                                       borderRadius:
    //                                       BorderRadius.circular(5),
    //                                       border: Border.all(
    //                                           width: 2,
    //                                           color: Theme.of(context)
    //                                               .primaryColor)),
    //                                   child: Column(
    //                                     mainAxisAlignment:
    //                                     MainAxisAlignment.start,
    //                                     children: [
    //                                       ListTile(
    //                                         title: Text(
    //                                           "Calibrations",
    //                                           style: TextStyle(
    //                                             color: Colors.blue,
    //                                           ),
    //                                         ),
    //                                         leading: Icon(
    //                                           Icons.add,
    //                                           color: Colors.blue,
    //                                         ),
    //                                       ),
    //                                       StreamBuilder(
    //                                           stream: FirebaseFirestore.instance
    //                                               .collection("calibrations")
    //                                               .where("calibrationAdmin",
    //                                               isEqualTo: snapshotprofile
    //                                                   .data!.docs.first
    //                                                   .get("parent"))
    //                                               .snapshots(),
    //                                           builder: (BuildContext context,
    //                                               AsyncSnapshot<QuerySnapshot>
    //                                               snapshot) {
    //                                             if (snapshot.hasData) {
    //                                               return ListView.builder(
    //                                                   shrinkWrap: true,
    //                                                   itemCount: snapshot
    //                                                       .data!.docs.length,
    //                                                   itemBuilder: (BuildContext
    //                                                   ctxt,
    //                                                       int index) =>
    //                                                       ListTile(
    //                                                         leading: Icon(
    //                                                           Icons
    //                                                               .account_box_outlined,
    //                                                           color: Theme.of(
    //                                                               context)
    //                                                               .primaryColor,
    //                                                         ),
    //                                                         title: Text(snapshot
    //                                                             .data!
    //                                                             .docs[index]
    //                                                             .id),
    //                                                       ));
    //
    //                                             } else {
    //                                               return Center(
    //                                                 child: Text("No records"),
    //                                               );
    //                                             }
    //                                           }),
    //                                     ],
    //                                   ),
    //                                 ),
    //                               ),
    //                             ),
    //                             Positioned(
    //                               top: ((MediaQuery.of(context).size.height -
    //                                   160) /
    //                                   2) +
    //                                   10,
    //                               bottom: 60,
    //                               left: 0,
    //                               right: 0,
    //                               child: Padding(
    //                                 padding: EdgeInsets.all(8.0),
    //                                 child: Container(
    //                                   width: MediaQuery.of(context).size.width,
    //                                   height:
    //                                   (MediaQuery.of(context).size.height -
    //                                       160) /
    //                                       2,
    //                                   decoration: BoxDecoration(
    //                                       borderRadius:
    //                                       BorderRadius.circular(5),
    //                                       border: Border.all(
    //                                           width: 2,
    //                                           color: Theme.of(context)
    //                                               .primaryColor)),
    //                                   child: Column(
    //                                     mainAxisAlignment:
    //                                     MainAxisAlignment.start,
    //                                     children: [
    //                                       ListTile(
    //                                         title: Text(
    //                                           "Connected Devices",
    //                                           style: TextStyle(
    //                                             color: Colors.blue,
    //                                           ),
    //                                         ),
    //                                         leading: Icon(
    //                                           Icons.add,
    //                                           color: Colors.blue,
    //                                         ),
    //                                       ),
    //                                       StreamBuilder<BluetoothState>(
    //                                           stream:
    //                                           FlutterBlue.instance.state,
    //                                           initialData:
    //                                           BluetoothState.unknown,
    //                                           builder: (c, snapshot) {
    //                                             final state = snapshot.data;
    //                                             if (state ==
    //                                                 BluetoothState.on) {
    //                                               // return Text("Blutooth on");
    //                                               return StreamBuilder<
    //                                                   List<BluetoothDevice>>(
    //                                                 stream: Stream.periodic(
    //                                                     Duration(
    //                                                         seconds: 0))
    //                                                     .asyncMap((_) =>
    //                                                 FlutterBlue.instance
    //                                                     .connectedDevices),
    //                                                 initialData: [],
    //                                                 builder: (c, snapshot) {
    //                                                   if (snapshot.hasData &&
    //                                                       snapshot.data!.length >
    //                                                           0) {
    //                                                     return Column(
    //                                                       children:
    //                                                       snapshot.data!
    //                                                           .map((d) =>
    //                                                           ListTile(
    //                                                             onTap:
    //                                                                 () {},
    //                                                             title: Text(
    //                                                                 d.name),
    //                                                             subtitle: Text(d
    //                                                                 .id
    //                                                                 .toString()),
    //                                                             trailing:
    //                                                             StreamBuilder<BluetoothDeviceState>(
    //                                                               stream:
    //                                                               d.state,
    //                                                               initialData:
    //                                                               BluetoothDeviceState.disconnected,
    //                                                               builder:
    //                                                                   (c, snapshot) {
    //                                                                 if (snapshot.data ==
    //                                                                     BluetoothDeviceState.connected) {
    //                                                                   return InkWell(
    //                                                                     onTap: () {
    //                                                                       Navigator.of(context).push(MaterialPageRoute(builder: (context) {
    //                                                                         d.connect(autoConnect: true);
    //                                                                         return ConnectedDevicePage(calibratorID: snapshotprofile.data!.docs.first
    //                                                                             .get("parent"),firestore: FirebaseFirestore.instance, userBody: snapshotprofile.data!.docs.first, device: d, auth: _auth,);
    //                                                                         //return DeviceScreenLessDetails(r.device);
    //                                                                       }));
    //                                                                     },
    //                                                                     child: Text(
    //                                                                       "Open Settings",
    //                                                                       style: TextStyle(color: Theme.of(context).primaryColor),
    //                                                                     ),
    //                                                                   );
    //
    //                                                                 }
    //                                                                 return Text(snapshot.data.toString());
    //                                                               },
    //                                                             ),
    //                                                           ))
    //                                                           .toList(),
    //                                                     );
    //                                                   } else {
    //                                                     return ListTile(
    //                                                       onTap: () {
    //                                                         FlutterBlue.instance
    //                                                             .startScan(
    //                                                             timeout: Duration(
    //                                                                 seconds:
    //                                                                 4));
    //                                                         showDialog<void>(
    //                                                             context:
    //                                                             context,
    //                                                             builder:
    //                                                                 (context) =>
    //                                                                 SimpleDialog(
    //                                                                   children: [
    //                                                                     StreamBuilder<List<ScanResult>>(
    //                                                                       stream: FlutterBlue.instance.scanResults,
    //                                                                       initialData: [],
    //                                                                       builder: (c, snapshot) {
    //                                                                         //  updateData(snapshot.data);
    //                                                                         FirebaseFirestore firestore;
    //                                                                         //  Database(firestore: firestore).addData(snapshot.data);
    //
    //                                                                         return Column(
    //                                                                           children: snapshot.data!
    //                                                                               .map(
    //                                                                                 (r) => ScanResultTile(
    //                                                                               result: r,
    //                                                                               onTap: () {
    //                                                                                 r.device.connect(autoConnect: false).then((value) {
    //                                                                                   Navigator.pop(context);
    //                                                                                 });
    //                                                                                 //return Text("ok");
    //                                                                                 //   return   PerformTestPage(device: r.device,project: widget.projectID,);
    //                                                                                // return PerformTestPageActivity(device: r.device, project: "");
    //                                                                                 Navigator.pop(context);
    //                                                                                 //return ConnectedDevicePage(device: r.device);
    //                                                                                 //return DeviceScreenLessDetails(r.device);
    //                                                                               },
    //                                                                             ),
    //                                                                             //     (r) => ScanResultTile(
    //                                                                             //   result: r,
    //                                                                             //   onTap: () => Navigator.of(context)
    //                                                                             //       .push(MaterialPageRoute(builder: (context) {
    //                                                                             //     r.device.connect(autoConnect: false);
    //                                                                             //     //return Text("ok");
    //                                                                             //  //   return   PerformTestPage(device: r.device,project: widget.projectID,);
    //                                                                             //     return   PerformTestPage(device: r.device,project:"o",);
    //                                                                             //     Navigator.pop(context);
    //                                                                             //     //return ConnectedDevicePage(device: r.device);
    //                                                                             //     //return DeviceScreenLessDetails(r.device);
    //                                                                             //   })),
    //                                                                             // ),
    //                                                                           )
    //                                                                               .toList(),
    //                                                                         );
    //                                                                       },
    //                                                                     )
    //                                                                   ],
    //                                                                 ));
    //                                                       },
    //                                                       title: Text(
    //                                                           "No Device is Connected"),
    //                                                       trailing: Text(
    //                                                         "Scan",
    //                                                         style: TextStyle(
    //                                                             color: Colors
    //                                                                 .blue),
    //                                                       ),
    //                                                     );
    //                                                   }
    //                                                 },
    //                                               );
    //                                             }
    //                                             return ListTile(
    //                                               title:
    //                                               Text("Turn on Blutooth"),
    //                                               trailing: Icon(
    //                                                 Icons.bluetooth_disabled,
    //                                                 color: Theme.of(context)
    //                                                     .primaryColor,
    //                                               ),
    //                                             );
    //                                             //return BluetoothOffScreen(state: state);
    //                                           }),
    //                                     ],
    //                                   ),
    //                                 ),
    //                               ),
    //                             ),
    //                             Align(
    //                               alignment: Alignment.bottomCenter,
    //                               child: Padding(
    //                                 padding: EdgeInsets.all(8.0),
    //                                 child: Container(
    //                                   height: 50,
    //                                   decoration: BoxDecoration(
    //                                       borderRadius:
    //                                       BorderRadius.circular(5),
    //                                       border: Border.all(
    //                                           width: 2,
    //                                           color: Theme.of(context)
    //                                               .primaryColor)),
    //                                   child: Center(
    //                                     child: Text("Connect a new device"),
    //                                   ),
    //                                 ),
    //                               ),
    //                             ),
    //                           ],
    //                         ));
    //                   } else {
    //                     return Scaffold(
    //                       body: Text("Unsupported user"),
    //                     );
    //                   }
    //                 } else {
    //                   return Scaffold(
    //                     body: Text("Pease wait"),
    //                   );
    //                 }
    //               } else {
    //                 return Scaffold(
    //                   body: Text("Pease wait"),
    //                 );
    //               }
    //             });
    //       }
    //     }
    //   //Auth stream
    // );
  }

  Future<void> lookUpBoard(String calibrator,
      String sl,
      String iceSl,
      GlobalKey<ScaffoldState> scaffoldKey,
      BluetoothCharacteristic read,
      BluetoothCharacteristic write,
      BluetoothDevice device, BuildContext buildContext,dynamic userProfile) async {
    print("look up");

    try {
      var deviceRecord = await _firestore
          .collection("boards")
          .where("iceSl", isEqualTo: iceSl)
          .where("sl", isEqualTo: sl)
          .get();
      print(deviceRecord.docs.length);
      if (deviceRecord.docs.length == 0) {
        scaffoldKey.currentState!.showBottomSheet((context) => Scaffold(
          // key: scaffoldKey2,
          // appBar: AppBar(),
          body: Column(
            children: [
              ListTile(
                title: Text("Register new board"),
                tileColor:
                Theme.of(context).primaryColor.withOpacity(0.1),
              ),
              ListTile(
                onTap: () {
                  GlobalKey<ScaffoldState> scaffoldKey3 =
                  GlobalKey<ScaffoldState>();
                  TextEditingController controller =
                  new TextEditingController();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Scaffold(
                          key: scaffoldKey3,
                          appBar: AppBar(
                            title: Text("Update  SN"),
                          ),
                          body: Wrap(
                            children: [
                              Padding(
                                padding:
                                const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: controller,
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  String commandToWrite =
                                      COMMAND_INDEX_2_SET +
                                          controller.text +
                                          COMMAND_SUFFIX;
                                  print("command " +
                                      commandToWrite);

                                  try {
                                    await write.write(
                                        StringToASCII(
                                            commandToWrite),
                                        withoutResponse: true);
                                    lookUpBoard(calibrator,
                                        sl,
                                        iceSl,
                                        scaffoldKey3,
                                        read,
                                        write,
                                        device,buildContext,userProfile);

                                    // Navigator.pop(context);

                                    sl = controller.text;

                                   // return true;
                                  } catch (e) {
                                    //return false;
                                  }
                                },
                                child: Padding(
                                  padding:
                                  const EdgeInsets.all(8.0),
                                  child: Card(
                                    color: Theme.of(context)
                                        .primaryColor,
                                    child: Center(
                                      child: Padding(
                                        padding:
                                        const EdgeInsets
                                            .all(8.0),
                                        child: Text(
                                          "Save",
                                          style: TextStyle(
                                              color:
                                              Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  );
                },
                title: Text(sl),
                subtitle: Text("SN"),
              ),
              ListTile(
                onTap: () {
                  TextEditingController controllerIce =
                  new TextEditingController();
                  GlobalKey<ScaffoldState> scaffoldKey4 =
                  GlobalKey<ScaffoldState>();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Scaffold(
                          key: scaffoldKey4,
                          appBar: AppBar(
                            title: Text("Update ICE SN"),
                          ),
                          body: Wrap(
                            children: [
                              Padding(
                                padding:
                                const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: controllerIce,
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  String commandToWrite =
                                      COMMAND_INDEX_1_SET +
                                          controllerIce.text +
                                          COMMAND_SUFFIX;
                                  print("command " +
                                      commandToWrite);

                                  try {
                                    await write.write(
                                        StringToASCII(
                                            commandToWrite),
                                        withoutResponse: true);
                                    //Navigator.pop(context);
                                    //Navigator.pop(context);
                                    lookUpBoard(calibrator,sl,
                                        iceSl,
                                        scaffoldKey4,
                                        read,
                                        write,
                                        device,buildContext,userProfile);
                                    iceSl = controllerIce.text;

                                  //  return true;
                                  } catch (e) {
                                    //return false;
                                  }
                                },
                                child: Padding(
                                  padding:
                                  const EdgeInsets.all(8.0),
                                  child: Card(
                                    color: Theme.of(context)
                                        .primaryColor,
                                    child: Center(
                                      child: Padding(
                                        padding:
                                        const EdgeInsets
                                            .all(8.0),
                                        child: Text(
                                          "Save",
                                          style: TextStyle(
                                              color:
                                              Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  );
                },
                title: Text(iceSl),
                subtitle: Text("ICE SN"),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
                // child: Text("New Device has been detected,"),
              ),
              Row(
                children: [
                  Expanded(
                      child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Card(
                            color: Colors.redAccent,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Do not Register",
                                  style: TextStyle(
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ))),
                  Expanded(
                      child: InkWell(
                          onTap: () {
                            // Navigator.pop(context);
                            scaffoldKey.currentState!
                                .showBottomSheet(
                                  (context) => Scaffold(
                                  body: Column(
                                    children: [
                                      ListTile(
                                        title:
                                        Text("Choose a Customer"),
                                        tileColor: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.1),
                                      ),
                                      StreamBuilder<QuerySnapshot>(
                                          stream: _firestore
                                              .collection("customers")
                                              .snapshots(),
                                          builder:
                                              (c, snapshotCustomers) {
                                            if (snapshotCustomers
                                                .hasData) {
                                              return ListView.builder(
                                                  physics:
                                                  ClampingScrollPhysics(),
                                                  // separatorBuilder: (context, index) {
                                                  //   return Divider();
                                                  // },
                                                  shrinkWrap: true,
                                                  padding:
                                                  EdgeInsets.zero,
                                                  itemCount:
                                                  snapshotCustomers
                                                      .data!
                                                      .docs
                                                      .length,
                                                  itemBuilder:
                                                      (_, index) {
                                                    return ListTile(
                                                      onTap: () {
                                                        _firestore
                                                            .collection(
                                                            "boards")
                                                            .add({
                                                          "iceSl":
                                                          iceSl,
                                                          "sl": sl,
                                                          "customerId":
                                                          snapshotCustomers
                                                              .data!
                                                              .docs[
                                                          index]
                                                              .id,
                                                          "time": DateTime
                                                              .now()
                                                              .millisecondsSinceEpoch
                                                        }).then((value) {
                                                          Navigator.pop(context);
                                                        });
                                                      },
                                                      title: Text(
                                                          snapshotCustomers
                                                              .data!
                                                              .docs[
                                                          index]
                                                              .get(
                                                              "prjectName")),
                                                      trailing:
                                                      Container(
                                                        height: 45,
                                                        width: 45,
                                                        decoration:
                                                        BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              22.5),
                                                          color: Colors
                                                              .grey
                                                              .withOpacity(
                                                            0.4,
                                                          ),
                                                        ),
                                                        child: Icon(
                                                            Icons.done),
                                                      ),
                                                    );
                                                  });
                                            } else {
                                              return Center(
                                                child:
                                                CircularProgressIndicator(),
                                              );
                                            }
                                          }),
                                    ],
                                  )),
                            );
                          },
                          child: Card(
                            color: Theme.of(context).primaryColor,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Register",
                                    style: TextStyle(
                                        color: Colors.white)),
                              ),
                            ),
                          ))),
                ],
              ),
            ],
          ),
        ));

      } else {
        scaffoldKey.currentState!.showBottomSheet((context) =>Scaffold(
          //  appBar: AppBar(),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text("Customer Device connected"),
                tileColor:
                Theme.of(context).primaryColor.withOpacity(0.1),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Customer Name",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor),
                ),
              ),
              FutureBuilder<DocumentSnapshot>(
                  future: _firestore
                      .collection("customers")
                      .doc(deviceRecord.docs.first
                      .data()["customerId"])
                      .get(),
                  builder: (c, snapshot) {

                    if (snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(snapshot.data!.get("prjectName"),
                            style: TextStyle(fontSize: 18)),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Getting customer name"),
                      );
                    }
                  }),
              InkWell(
                onTap: () {

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Scaffold(
                            body: Scaffold(
                              appBar: AppBar(
                                title: Text("Product Information"),
                              ),
                              body: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    //getAll5InaRow(bluetoothCharacteristicWrite: widget.characteristicWritePurpose,bluetoothCharacteristicRead: widget.characteristicReadPurpose),
                                    Directory_1_view_edit(
                                      bluetoothCharacteristicWrite: write,
                                      bluetoothCharacteristicRead: read,
                                    ),

                                    Directory_2_view_edit(
                                      bluetoothCharacteristicWrite:write,
                                      bluetoothCharacteristicRead: read,
                                    ),
                                    Directory_3_view_edit(
                                      bluetoothCharacteristicWrite: write,
                                      bluetoothCharacteristicRead: read,
                                    ),
                                    Directory_4_view_edit(
                                      bluetoothCharacteristicWrite: write,
                                      bluetoothCharacteristicRead: read,
                                    ),
                                    Directory_9_view_edit(
                                      bluetoothCharacteristicWrite: write,
                                      bluetoothCharacteristicRead: read,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //       builder: (context) =>
                                        //           CalibartionStep4(
                                        //             //profile: userProfile,
                                        //             calibAdmin:calibrator,
                                        //             firestore: _firestore,
                                        //             device:device,
                                        //             characteristicWrite:write,
                                        //             characteristicRead:read,
                                        //              CoEf2: '', CoEf4: '', CoEf1: '', CoEf3: '',
                                        //           )),
                                        // );
                                      },
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.fromLTRB(
                                            8, 25, 8, 0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.all(
                                                  Radius.circular(
                                                      3)),
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          child: Center(
                                            child: Padding(
                                              padding:
                                              const EdgeInsets
                                                  .all(15.0),
                                              child: Text(
                                                "Next",
                                                style: TextStyle(
                                                    color:
                                                    Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )));




                  //start calibration
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => CalibartionStep4(
                  //         calibAdmin: calibrator,
                  //         firestore: _firestore,
                  //         device: device,
                  //         characteristicWrite: write,
                  //         characteristicRead: read,
                  //         productInfo: productInfo,
                  //       )),
                  // );
                },
                child: Card(
                  color: Theme.of(context).primaryColor,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Do Calibration",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
        // Navigator.push(
        // context,
        // MaterialPageRoute(
        //     builder: (context) => Scaffold(
        //           appBar: AppBar(),
        //           body: Column(
        //             mainAxisAlignment: MainAxisAlignment.start,
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               ListTile(
        //                 title: Text("Customer Device connected"),
        //                 tileColor:
        //                     Theme.of(context).primaryColor.withOpacity(0.1),
        //               ),
        //               Padding(
        //                 padding: const EdgeInsets.all(8.0),
        //                 child: Text(
        //                   "Customer Name",
        //                   style: TextStyle(
        //                       color: Theme.of(context).primaryColor),
        //                 ),
        //               ),
        //               FutureBuilder<DocumentSnapshot>(
        //                   future: _firestore
        //                       .collection("customers")
        //                       .doc(deviceRecord.docs.first
        //                           .data()["customerId"])
        //                       .get(),
        //                   builder: (c, snapshot) {
        //                     if (snapshot.hasData) {
        //                       return Padding(
        //                         padding: const EdgeInsets.all(8.0),
        //                         child: Text(snapshot.data.get("prjectName"),
        //                             style: TextStyle(fontSize: 18)),
        //                       );
        //                     } else {
        //                       return Padding(
        //                         padding: const EdgeInsets.all(8.0),
        //                         child: Text("Getting customer name"),
        //                       );
        //                     }
        //                   }),
        //               InkWell(
        //                 onTap: () {
        //                   //start calibration
        //                   Navigator.push(
        //                     context,
        //                     MaterialPageRoute(
        //                         builder: (context) => CalibartionStep4(
        //                               calibAdmin: null,
        //                               firestore: _firestore,
        //                               device: device,
        //                               characteristicWrite: write,
        //                               characteristicRead: read,
        //                               productInfo: productInfo,
        //                             )),
        //                   );
        //                 },
        //                 child: Card(
        //                   color: Theme.of(context).primaryColor,
        //                   child: Container(
        //                     width: MediaQuery.of(context).size.width,
        //                     child: Center(
        //                       child: Padding(
        //                         padding: const EdgeInsets.all(8.0),
        //                         child: Text(
        //                           "Do Calibration",
        //                           style: TextStyle(color: Colors.white),
        //                         ),
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         )));
      }
    } catch (e) {
      print(e);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(
                  title: Text("Register new board"),
                ),
                body: Column(
                  children: [
                    Text("New Device has been detected,"),
                    Row(
                      children: [
                        Expanded(
                            child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Card(
                                  color: Colors.redAccent,
                                  child: Center(
                                    child: Text(
                                      "Do not Register",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ))),
                        Expanded(
                            child: InkWell(
                                onTap: () {},
                                child: Card(
                                  color: Theme.of(context).primaryColor,
                                  child: Center(
                                    child: Text("Register",
                                        style:
                                        TextStyle(color: Colors.white)),
                                  ),
                                ))),
                      ],
                    ),
                  ],
                ),
              )));
    }
  }

  String getCalibratorId(QueryDocumentSnapshot<Object?> first) {
    try{
      if(first.get("parent")!=null){
        return first.get("parent");
      }else{
        return "";
      }

    }catch(e){
      try{
        if(first.get("parentType")!=null){
          return first.get("parentType");
        }else{
          return "";
        }
      }catch(e){
        return "";

      }

    }




  }
}