import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:core';
import 'dart:core';
import 'dart:ffi';
import 'dart:io' show Platform;
import "dart:typed_data";
import 'package:connect/DarkThemeManager.dart';
import 'package:connect/Toast/AppToast.dart';
import 'package:device_info/device_info.dart';
import 'package:http/http.dart' as http;
import 'package:connect/Activities/CameraToggleSwitch/cameraToggle.dart';
import 'package:connect/Activities/CustomBottomNavigationBar/appBottomNavigationBar.dart';
import 'package:connect/Activities/CustomerUserHome/HomePager/appbar.dart';
import 'package:connect/Activities/TestMapScreen/testMapScreen.dart';
import 'package:connect/Activities/contstantWidgets/constantWidgets.dart';
import 'package:connect/Appabr/appbar_widget.dart';
import 'package:connect/screens/home.dart';
import 'package:connect/screens/popup/AutoConnectPopUp.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/textConst.dart';
import 'package:connect/utils/textStyleConst.dart';
import 'package:connect/utils/themeManager.dart';
import 'package:convert/convert.dart';
 import 'package:flutter_svg/svg.dart';
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
import 'package:permission_handler/permission_handler.dart';

import 'package:screenshot/screenshot.dart';
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

import '../../Storage.dart';
import '../../widgets.dart';
import 'ConnectedDevices/connectedDevices.dart';
import 'FileExplolar/fileexplolar.dart';
import 'HomePager/HomeWidget.dart';
import 'Reportings/reportingActivity.dart';
import 'TestPerformSection/testPerformSection.dart';
import 'logics.dart';
String cloudRestApiBase2 = "https://us-central1-staht-connect-322113.cloudfunctions.net/";
class MyHomePage extends StatefulWidget {
  BluetoothDevice? connectedDevice;
  late String projct;
  late String customerId;
  late String customerName;
  late String region;

  double bottomSheetHeight = 80;

  late FirebaseFirestore customerFirestore;
  late FirebaseAuth auth;

  late  QueryDocumentSnapshot<Object?> profile;
  //late  IO.Socket socket;
  late Locale locale;

  MyHomePage(
      {Key? key,
        //required this.socket,
        required   this.profile,
        required  this.title,
        required  this.locale,
        required this.projct,
        required this.customerFirestore,
        required this.customerId,
        required this.auth,
        required this.region,
        required this.customerName})
      : super(key: key);

  late String title;
  late BluetoothDevice device;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class OnePage extends StatefulWidget {
  int pos = 0;

   OnePage({Key? key,}) : super(key: key);

  @override
  _OnePageState createState() => new _OnePageState();
}

class _OnePageState extends State<OnePage> with AutomaticKeepAliveClientMixin<OnePage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return    Scaffold(body: Center(child: InkWell(onTap: (){
      setState(() {
        widget.pos ++;
      });
    },child: Text("Test operation "+ widget.pos.toString())),),);
  }

  @override
  bool get wantKeepAlive => true;
}
class KeepAlivePage extends StatefulWidget {
  KeepAlivePage({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _KeepAlivePageState createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<KeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    /// Dont't forget this
    super.build(context);

    return widget.child;
  }
  @override
  bool get wantKeepAlive => true;

}
class TestPager extends StatefulWidget {
  int pos = 0 ;
   TestPager({Key? key}) : super(key: key);

  @override
  _TestPagerState createState() => _TestPagerState();
}

class _TestPagerState extends State<TestPager> with AutomaticKeepAliveClientMixin<TestPager>  {
  @override
  Widget build(BuildContext context) {
    //Notice the super-call here.
    super.build(context);
    return Scaffold(body: Center(child: InkWell(onTap: (){
      setState(() {
        widget.pos ++;
      });
    },child: Text("Test operation "+ widget.pos.toString())),),);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class _MyHomePageState extends State<MyHomePage> {
  Timer? timer;
  int bottomSelectedIndex = 0;
  Widget testRunningWidget = Text("NA");
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  //FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  late PersistentBottomSheetController persistentBottomSheetController;
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,

  );
   Widget buildPageView() {
    return PageView(

      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[

        // AllUsersListActivity(
        //   socket: widget.socket,
        //   firestore: FirebaseFirestore.instance,
        //   customerFirestore: widget.customerFirestore,
        //   customerId: widget.customerId,
        //   auth: widget.auth,
        //   customerName: widget.customerName,
        // ),
      ],
    );
  }

  void callReceiveSignal() {
    // print("trying to connect signsl");
    // try {
    //   widget.socket.on("callincome" + widget.auth.currentUser!.uid, (data) {
    //     showIncome(data);
    //     print("call income hit");
    //     print(data);
    //     AppSignal()
    //         .initSignal()
    //         .emit("ringing", {"id": widget.auth.currentUser!.uid});
    //   });
    //   widget.socket.on("mkl", (data) {
    //     print(data);
    //   });
    // } catch (e) {
    //   print(e.toString());
    // }
    // Timer.periodic(Duration(milliseconds: 1000), (timer) {
    //   if (mounted) {
    //     if(lastSeenTime+3000>DateTime.now().millisecondsSinceEpoch){
    //
    //     }else{
    //       widget.shouldShowIncomming = false ;
    //
    //     }
    //     StopRing();
    //
    //   }else{
    //     timer.cancel();
    //   }
    // });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
  }

  checkDatabaseStatus() async {
    FirebaseFirestore firestore = await FirebaseFirestore.instanceFor(app: Firebase.app(widget.projct));

    checkPlease() async {
      print("Initializing for "+widget.projct);
      String id = widget.customerId;
      try{
        print("write aatempt");
        await  firestore.collection("projectDetails").add({"id":id});
        print("Database is ok");

      }catch(e){
        print("Failed to write data.Going to set");
        print(e);
        Future addfirestoreRules({ required String projectID}) async {
          var url = cloudRestApiBase2+'addrules';
          final http.Response response = await http.post(Uri.parse(url),
            headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',},
            body: jsonEncode(<String, String> {   "project_id":projectID,}),);

        }
        Future addfirestore({ String? uid, String? projectID,required String region}) async {
          var body = jsonEncode(<String, String?>{ "project_id": projectID,"region":region});
          var url = cloudRestApiBase2 + 'addfirestore';
          final http.Response response = await http.post(Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: body,);



        }
        Future addfirebase({ String? projectID}) async {
          var body = jsonEncode(<String, String?>{ "project_id": projectID});
          var url = cloudRestApiBase2 + 'addfirebase';
          final http.Response response = await http.post(Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: body,);



        }


        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(width: MediaQuery.of(context).size.width*0.9,height: (MediaQuery.of(context).size.width*0.9)*0.5,child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Now Setting up",style: TextStyle(fontSize: 20),),
                  ),
                  Container(width: double.infinity,height: 0.01,color: Colors.grey,),
                  InkWell(onTap: () async {
                    Navigator.pop(context);
                    print("api hit starts");
                    await  addfirebase( projectID: id,);
                    await Future.delayed(Duration(seconds: 1));
                    await  addfirestore(region: widget.region, uid: "", projectID: id,);
                    addfirestoreRules(projectID: (id).trim(),);
                    addfirestoreRules(projectID: (id).trim(),);
                    addfirestoreRules(projectID: (id).trim(),);
                    addfirestoreRules(projectID: (id).trim(),);
                    addfirestoreRules(projectID: (id).trim(),);

                    await  addfirestore(region:widget.region, uid: "", projectID: id,);

                    addfirestoreRules(projectID: (id).trim(),);
                    addfirestoreRules(projectID: (id).trim(),);
                    addfirestoreRules(projectID: (id).trim(),);
                    addfirestoreRules(projectID: (id).trim(),);
                    addfirestoreRules(projectID: (id).trim(),);
                    addfirestoreRules(projectID: (id).trim(),);
                    addfirestoreRules(projectID: (id).trim(),);
                    addfirestoreRules(projectID: (id).trim(),);
                    addfirestoreRules(projectID: (id).trim(),);
                    addfirestoreRules(projectID: (id).trim(),);
                    addfirestoreRules(projectID: (id).trim(),);
                    addfirestoreRules(projectID: (id).trim(),);
                    addfirestoreRules(projectID: (id).trim(),);
                    addfirestoreRules(projectID: (id).trim(),);
                    addfirestoreRules(projectID: (id).trim(),);
                    checkPlease();
                  },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: ThemeManager().getDarkGreenColor,),width: double.infinity,child: Center(child: Text("OK",style: TextStyle(color: Colors.white,fontSize: 20)),)),
                    ),
                  ),

                ],
              ),),
            );
          },
        );






      }
    }
    checkPlease();

  }

  @override
  void initState() {
    super.initState();
    getPermissions();
    listenForScan(context);

    checkDatabaseStatus();




    // FlutterBlue.instance.state.listen((event) {
    //   if(event == BluetoothState.off){
    //     //signal blurtooth off\
    //     print("device is off");
    //     CustomerHomePageLogic().connectedDevicesStream.dataReload(false);
    //   }else {
    //     print("device is on");
    //     CustomerHomePageLogic().connectedDevicesStream.dataReload(true);
    //     // FlutterBlue.instance.connectedDevices.then((value) {
    //     //   if(value.length>0) {
    //     //     CustomerHomePageLogic().connectedDevicesStream.dataReload(true);
    //     //   }else{
    //     //     CustomerHomePageLogic().connectedDevicesStream.dataReload(false);
    //     //
    //     //   }
    //     // });
    //
    //   }
    // });

  }

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
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
                widget
                    .projct,
                customerFirestore:
                widget
                    .customerFirestore,
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
  List<Widget> bottomBarScreens() {

    return [
      HomeSection(appabr:ApplicationAppbar(). getAppbar(title: "Home"),locale: widget.locale,
        // profile: widget.profile,
        customerFirestore: widget.customerFirestore,
        customerId: widget.customerId,
        auth: widget.auth,
        customerName: widget.customerName, profile: widget.profile,
      ),


      StreamBuilder<bool>(
          stream:CustomerHomePageLogic().connectedDevicesStream.outData,


          builder: (c, snapshot) {
            print("rebuilding 2nd tab");
            return StreamBuilder<List<BluetoothDevice>>(
                stream:FlutterBlue.instance.connectedDevices.asStream(),
                initialData: [],
                builder: (c, snapshotDevices) {
                  print("rebuilding 2nd tab really");
                  if (snapshotDevices.hasData && snapshotDevices.data!.length > 0) {
                    return  FutureBuilder<SharedPreferences>(
                        future:  SharedPreferences.getInstance(),
                        builder: (context, snapshot) {
                          if(snapshot.hasData){
                            String lastLoad =
                                snapshot.data!.getString("lastLoad")??"0";
                            TextEditingController c =
                            TextEditingController(
                                text: lastLoad);

                            return  StreamBuilder<bool>(
                              stream:CustomerHomePageLogic().connectedDevicesStream.outData,


                              builder: (con, snapshotagain) {
                                return    FutureBuilder<bool>(
                                    future:Future.delayed(Duration(seconds: 0)).then((value) => true),


                                    builder: (con, snapshotTimer) {
                                      print("rebuilding 2nd tab really xx");
                                      if(snapshotTimer.hasData)
                                      return   TakePreDataActivity(appbar :ApplicationAppbar().  getAppbar(title: "Test"),
                                        lastLoad: lastLoad,
                                        d: snapshotDevices.data!.last,
                                        customerId:
                                        widget.projct,
                                        customerFirestore:
                                        widget.customerFirestore,
                                        sPref: snapshot.data!,
                                        controller: c,
                                      );else return Scaffold(body: Center(child: CircularProgressIndicator(),),);
                                    });
                                // return   TakePreDataActivity(
                                //   lastLoad: lastLoad,
                                //   d: snapshotDevices.data!.first,
                                //   customerId:
                                //   widget.projct,
                                //   customerFirestore:
                                //   widget.customerFirestore,
                                //   sPref: snapshot.data!,
                                //   controller: c,
                                // );
                              });

                          }else {
                            return CircularProgressIndicator();
                          }

                        });
                  }else
                    // return Scaffold(resizeToAvoidBottomInset: false,body: Center(child: InkWell(onTap: (){
                    //   FlutterBlue.instance.startScan(timeout: Duration(seconds: 4));
                    // },child: Center(child: TextFormField(),)),),);
                    return SafeArea(child:Scaffold(  backgroundColor: AppThemeManager().getScaffoldBackgroundColor(), appBar: PreferredSize(
                      preferredSize: AppBar().preferredSize,
                      child:  ApplicationAppbar(). getAppbar(title: "Tests"),
                    ),body: Column(
                      children: [
                        // Container(
                        //     child: AppbarView(
                        //       appbarTitleText: TextConst.testsText,
                        //     )
                        // ),
                        Container(height: 400,
                          child: Center(child: InkWell(onTap: (){
                            //FlutterBlue.instance.startScan(timeout: Duration(seconds: 4));
                            CustomerHomePageLogic().connectedDevicesStream.dataReload(true);
                          },child:  ConstantWidget().notDeviceConnected()),),
                        ),
                      ],
                    ),));
                }
            );
          }
      ),
    // TestMapScreen(),
      //TestPerformSection(projct: widget.projct,customerFirestore: widget.customerFirestore,),

      //
      // StreamBuilder<bool>(
      //     stream: CustomerHomePageLogic().connectedDevicesStream.outData,
      //     initialData: false,
      //     builder: (c, snapshot) {
      //       if(snapshot.hasData && snapshot.data == true){
      //         print("hit this 1");
      //         // FlutterBlue.instance.connectedDevices
      //
      //         return  FutureBuilder<List<BluetoothDevice>>(
      //           future: FlutterBlue.instance.connectedDevices,
      //           initialData: [],
      //           builder: (c, snapshot) {
      //             if (snapshot.hasData && snapshot.data!.length > 0) {
      //               print("hit this 2");
      //               if (widget.connectedDevice != null) {
      //               } else {
      //                 // setState(() {
      //                 //   widget.connectedDevice = snapshot.data!.last;
      //                 // });
      //               }
      //               return       prepareTestTab(device: snapshot.data!.last);
      //
      //             } else {
      //               return ListTile(
      //                 onTap: () {
      //                   FlutterBlue.instance
      //                       .startScan(timeout: Duration(seconds: 4));
      //                   showDialog<void>(
      //                       context: context,
      //                       builder: (context) => SimpleDialog(
      //                         children: [
      //                           StreamBuilder<List<ScanResult>>(
      //                             stream: FlutterBlue
      //                                 .instance.scanResults,
      //                             initialData: [],
      //                             builder: (c, snapshot) {
      //                               //  updateData(snapshot.data);
      //                               FirebaseFirestore firestore;
      //                               //  Database(firestore: firestore).addData(snapshot.data);
      //
      //                               return Column(
      //                                 children: snapshot.data!
      //                                     .map(
      //                                       (r) => ScanResultTile(
      //                                     result: r,
      //                                     onTap: () {
      //                                       r.device
      //                                           .connect(
      //                                           autoConnect:
      //                                           false)
      //                                           .then(
      //                                               (value) {
      //                                             //fetch index2 and index6
      //                                             initDeviceSlAndCalibDate(widget.device);
      //                                             setState(() {
      //                                               widget.device =
      //                                                   r.device;
      //                                             });
      //                                             Navigator.pop(
      //                                                 context);
      //
      //
      //                                           });
      //                                       //return Scaffold(body: Text("Not using"),);
      //                                       //return Text("ok");
      //                                       //   return   PerformTestPage(device: r.device,project: widget.projectID,);
      //                                       // return PerformTestPageActivity(
      //                                       //     device:
      //                                       //         r.device,
      //                                       //     project: widget
      //                                       //         .projct);
      //                                       Navigator.pop(
      //                                           context);
      //                                       //return ConnectedDevicePage(device: r.device);
      //                                       //return DeviceScreenLessDetails(r.device);
      //                                     },
      //                                   ),
      //                                   //     (r) => ScanResultTile(
      //                                   //   result: r,
      //                                   //   onTap: () => Navigator.of(context)
      //                                   //       .push(MaterialPageRoute(builder: (context) {
      //                                   //     r.device.connect(autoConnect: false);
      //                                   //     //return Text("ok");
      //                                   //  //   return   PerformTestPage(device: r.device,project: widget.projectID,);
      //                                   //     return   PerformTestPage(device: r.device,project:"o",);
      //                                   //     Navigator.pop(context);
      //                                   //     //return ConnectedDevicePage(device: r.device);
      //                                   //     //return DeviceScreenLessDetails(r.device);
      //                                   //   })),
      //                                   // ),
      //                                 )
      //                                     .toList(),
      //                               );
      //                             },
      //                           )
      //                         ],
      //                       ));
      //                 },
      //                 title: Text("No Device is Connected"),
      //                 trailing: Text(
      //                   "Scan",
      //                   style: TextStyle(),
      //                 ),
      //               );
      //             }
      //           },
      //         );
      //
      //       }else{
      //         return Scaffold(body: Center(child: Text("No Device connected 2")),);
      //
      //       }
      //
      //     }),

      FileExplorar2(appbar :  ApplicationAppbar(). getAppbar(title: "Tests"),locale: widget.locale,
        customerFirestore: widget.customerFirestore,
        customerId: widget.customerId,
      ),

      ShareReport(appbar : ApplicationAppbar().  getAppbar(title: "Tests"),locale: widget.locale,
        customerFirestore: widget.customerFirestore,
        customerId: widget.customerId,
      ),
    ];
  }
  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  void onTabTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery
        .of(context)
        .size
        .height;
    width = MediaQuery
        .of(context)
        .size
        .width;
    Widget w = Scaffold(body: TextFormField(),);

    // return PageView(
    //   children: bottomBarScreens(),
    // );

    PageController _controller = PageController(
      initialPage: 0,
      keepPage: false,
    );

    CustomerHomePageLogic().tabChangedStream.outData.listen((event) {
      _controller.jumpToPage(event);
      //_controller.animateToPage(event, duration: Duration(milliseconds: 200), curve:Curves.ease);
    });

    CustomerHomePageLogic().connectedDevicesStream.outData.listen((event) async {

      print("change");
     // if(_controller.page !=0) _controller.animateTo(0, duration: Duration(milliseconds: 200), curve:Curves.ease).then((value) {
     //    _controller.animateTo(1, duration: Duration(milliseconds: 200), curve:Curves.ease);
     //  });else{
     //   _controller.animateTo(1, duration: Duration(milliseconds: 200), curve:Curves.ease);
     // }

    //   await Future.delayed(Duration(seconds: 2));
    // try{
    //   _controller.jumpToPage(3);
    //   _controller.jumpToPage(1);
    // }catch(e){
    //   print(e);
    //    _controller.jumpToPage(3);
    //    _controller.jumpToPage(1);
    //   print("not done");
    // }
    });
    //AppTitleAppbarStream

    return Scaffold(



      body: Stack(children: [
      Positioned(bottom:  height * 0.075,top: 0,left: 0,right: 0,child: PageView(onPageChanged: (index){
        CustomerHomePageLogic().tabChangedStream.dataReload(index);
      },controller: _controller,physics:new NeverScrollableScrollPhysics(),children: bottomBarScreens(),)),
      Positioned(bottom:0, left: 0,right: 0,child: AppBottomNavigationar(context: context).getNavigationBar(level: 0)),
    //  Positioned( top: 110,right: 110,child: CameraToggle(isVideoSelected: (bool ) {},)),

    ],),);

    // return Scaffold(
    //
    // //     appBar: AppBar(elevation: 1,centerTitle: true,iconTheme: IconThemeData(
    // //         color: Colors.black
    // //     ),backgroundColor: Colors.white,actions: [
    // //   InkWell(onTap: (){
    // //     //showDialog(context: context, builder: (_) => ThemeDialog());
    // //
    // //     Navigator.push(
    // //         context,
    // //         MaterialPageRoute(
    // //             builder: (context) =>SettingsActivity()));
    // //
    // //   },child: Center(child: Padding(
    // //     padding: const EdgeInsets.fromLTRB(10,0, 30, 0),
    // //     child: Icon(Icons.settings),
    // //   ))),
    // //
    // //
    // //
    // //   InkWell(onTap: ()=>FirebaseAuth.instance.signOut(),child: Icon(Icons.logout),),
    // // ],),
    //     key: _scaffoldKey,
    //     bottomNavigationBar: BottomAppBar(
    //       child: Container(
    //         margin: EdgeInsets.only(left: width*0.06, right: width*0.06),
    //         height: height*0.075,
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: <Widget>[
    //             IconButton(
    //               icon: Container(
    //                 height: height * 0.03,
    //                 width: width * 0.06,
    //                 child: SvgPicture.asset("assets/svg/homeIcon.svg",fit: BoxFit.fill,color: bottomSelectedIndex==0?ThemeManager().getSelectednavColor:ThemeManager().getBlackColor,),
    //               ),
    //               onPressed: () {
    //                 setState(() {
    //                   bottomSelectedIndex = 0;
    //                 });
    //                 bottomTapped(bottomSelectedIndex);
    //               },
    //
    //             ),
    //
    //             IconButton(
    //               icon: Container(
    //                 height: height * 0.03,
    //                 width: width * 0.06,
    //                 child: SvgPicture.asset("assets/svg/strokeIcon.svg",fit: BoxFit.fill,color: bottomSelectedIndex==1?ThemeManager().getSelectednavColor:ThemeManager().getBlackColor,),
    //               ),
    //               onPressed: () {
    //                 setState(() {
    //                   bottomSelectedIndex = 1;
    //                 });
    //                 bottomTapped(bottomSelectedIndex);
    //               },
    //             ),
    //             IconButton(
    //               icon: Container(
    //                 height: height * 0.03,
    //                 width: width * 0.06,
    //                 child: SvgPicture.asset("assets/svg/chartIcon.svg",fit: BoxFit.fill,color: bottomSelectedIndex==2?ThemeManager().getSelectednavColor:ThemeManager().getBlackColor,),
    //               ),
    //               onPressed: () {
    //                 setState(() {
    //                   bottomSelectedIndex = 2;
    //                 });
    //                 bottomTapped(bottomSelectedIndex);
    //               },
    //             ),
    //             IconButton(
    //               icon: Container(
    //                 height: height * 0.03,
    //                 width: width * 0.06,
    //                 child: SvgPicture.asset("assets/svg/vectorIcon.svg",fit: BoxFit.fill,color: bottomSelectedIndex==3?ThemeManager().getSelectednavColor:ThemeManager().getBlackColor,),
    //               ),
    //               onPressed: () {
    //                 setState(() {
    //                   bottomSelectedIndex = 3;
    //                 });
    //                 bottomTapped(bottomSelectedIndex);
    //               },
    //             ),
    //           ],
    //
    //         ),
    //       ),
    //
    //     ),
    //
    //
    //     body: Stack(
    //       children: [
    //         Positioned(
    //             left: 0, right: 0, top: 00, bottom: 0, child: buildPageView()),
    //
    //         // Positioned(
    //         //   left: 0,
    //         //   right: 0,
    //         //   bottom: 00,
    //         //   child: Container(
    //         //
    //         //     child: StreamBuilder<BluetoothState>(
    //         //         stream: FlutterBlue.instance.state,
    //         //         initialData: BluetoothState.unknown,
    //         //         builder: (c, snapshot) {
    //         //           final state = snapshot.data;
    //         //           if (state == BluetoothState.on) {
    //         //             // return Text("Blutooth on");
    //         //             return StreamBuilder<List<BluetoothDevice>>(
    //         //               stream: Stream.periodic(Duration(seconds: 5))
    //         //                   .asyncMap(
    //         //                       (_) => FlutterBlue.instance.connectedDevices),
    //         //               initialData: [],
    //         //               builder: (c, snapshot) {
    //         //                 if (snapshot.hasData && snapshot.data!.length > 0) {
    //         //                   CustomerHomePageLogic().connectedDevicesStream.dataReload(true);
    //         //                   if (widget.connectedDevice != null) {
    //         //                   } else {
    //         //                     setState(() {
    //         //                       widget.connectedDevice = snapshot.data!.last;
    //         //                     });
    //         //                   }
    //         //
    //         //                   return Column(
    //         //                     children: snapshot.data!
    //         //                         .map((d) => ListTile(
    //         //                       onTap: () {
    //         //                         setState(() {
    //         //                           widget.connectedDevice = d;
    //         //                         });
    //         //                       },
    //         //                       leading: Checkbox(
    //         //                         value:
    //         //                         widget.connectedDevice != null
    //         //                             ? (widget.connectedDevice?.id
    //         //                             .id ==
    //         //                             d.id.id
    //         //                             ? true
    //         //                             : false)
    //         //                             : false, onChanged: (bool? value) {  },
    //         //                       ),
    //         //                       title: Text(d.name),
    //         //                       subtitle: Text(d.id.toString()),
    //         //                       trailing: StreamBuilder<
    //         //                           BluetoothDeviceState>(
    //         //                         stream: d.state,
    //         //                         initialData: BluetoothDeviceState
    //         //                             .disconnected,
    //         //                         builder: (c, snapshot) {
    //         //                           if (snapshot.data == BluetoothDeviceState.connected) {
    //         //                             return InkWell(
    //         //                               //CLick to Proceed
    //         //                               child: Text("Perform Test"),
    //         //                               onTap: () async {
    //         //                                 try {
    //         //                                   //get Share
    //         //                                   SharedPreferences
    //         //                                   sharedPref =
    //         //                                   await SharedPreferences
    //         //                                       .getInstance();
    //         //                                   String lastLoad =
    //         //                                       sharedPref.getString(
    //         //                                           "lastLoad")??"0";
    //         //                                   TextEditingController c =
    //         //                                   TextEditingController(
    //         //                                       text: lastLoad);
    //         //                                   Navigator.push(
    //         //                                     context,
    //         //                                     MaterialPageRoute(
    //         //                                         builder: (context) =>
    //         //                                             TakePreDataActivity(
    //         //                                               lastLoad: lastLoad,
    //         //                                               d: d,
    //         //                                               customerId:
    //         //                                               widget
    //         //                                                   .projct,
    //         //                                               customerFirestore:
    //         //                                               widget
    //         //                                                   .customerFirestore,
    //         //                                               sPref:
    //         //                                               sharedPref,
    //         //                                               controller: c,
    //         //                                             )),
    //         //                                   );
    //         //                                 } catch (e) {
    //         //                                   print(e.toString());
    //         //                                 }
    //         //                               },
    //         //                             );
    //         //                           }
    //         //                           return Text(
    //         //                               snapshot.data.toString());
    //         //                         },
    //         //                       ),
    //         //                     ))
    //         //                         .toList(),
    //         //                   );
    //         //                 } else {
    //         //                   return ListTile(
    //         //                     onTap: () {
    //         //                       FlutterBlue.instance
    //         //                           .startScan(timeout: Duration(seconds: 4));
    //         //                       showDialog<void>(
    //         //                           context: context,
    //         //                           builder: (context) => SimpleDialog(
    //         //                             children: [
    //         //                               StreamBuilder<List<ScanResult>>(
    //         //                                 stream: FlutterBlue
    //         //                                     .instance.scanResults,
    //         //                                 initialData: [],
    //         //                                 builder: (c, snapshot) {
    //         //                                   //  updateData(snapshot.data);
    //         //                                   FirebaseFirestore firestore;
    //         //                                   //  Database(firestore: firestore).addData(snapshot.data);
    //         //
    //         //                                   return Column(
    //         //                                     children: snapshot.data!
    //         //                                         .map(
    //         //                                           (r) => ScanResultTile(
    //         //                                         result: r,
    //         //                                         onTap: () {
    //         //                                           r.device
    //         //                                               .connect(
    //         //                                               autoConnect:
    //         //                                               false)
    //         //                                               .then(
    //         //                                                   (value) {
    //         //                                                 //fetch index2 and index6
    //         //                                                 initDeviceSlAndCalibDate(widget.device);
    //         //                                                 setState(() {
    //         //                                                   widget.device =
    //         //                                                       r.device;
    //         //                                                 });
    //         //                                                 Navigator.pop(
    //         //                                                     context);
    //         //
    //         //
    //         //                                               });
    //         //                                           //return Scaffold(body: Text("Not using"),);
    //         //                                           //return Text("ok");
    //         //                                           //   return   PerformTestPage(device: r.device,project: widget.projectID,);
    //         //                                           // return PerformTestPageActivity(
    //         //                                           //     device:
    //         //                                           //         r.device,
    //         //                                           //     project: widget
    //         //                                           //         .projct);
    //         //                                           Navigator.pop(
    //         //                                               context);
    //         //                                           //return ConnectedDevicePage(device: r.device);
    //         //                                           //return DeviceScreenLessDetails(r.device);
    //         //                                         },
    //         //                                       ),
    //         //                                       //     (r) => ScanResultTile(
    //         //                                       //   result: r,
    //         //                                       //   onTap: () => Navigator.of(context)
    //         //                                       //       .push(MaterialPageRoute(builder: (context) {
    //         //                                       //     r.device.connect(autoConnect: false);
    //         //                                       //     //return Text("ok");
    //         //                                       //  //   return   PerformTestPage(device: r.device,project: widget.projectID,);
    //         //                                       //     return   PerformTestPage(device: r.device,project:"o",);
    //         //                                       //     Navigator.pop(context);
    //         //                                       //     //return ConnectedDevicePage(device: r.device);
    //         //                                       //     //return DeviceScreenLessDetails(r.device);
    //         //                                       //   })),
    //         //                                       // ),
    //         //                                     )
    //         //                                         .toList(),
    //         //                                   );
    //         //                                 },
    //         //                               )
    //         //                             ],
    //         //                           ));
    //         //                     },
    //         //                     title: Text("No Device is Connected"),
    //         //                     trailing: Text(
    //         //                       "Scan",
    //         //                       style: TextStyle(),
    //         //                     ),
    //         //                   );
    //         //                 }
    //         //               },
    //         //             );
    //         //             return FindDevicesScreenForTest(
    //         //               projectID: widget.projct,
    //         //             );
    //         //           }
    //         //           return ListTile(
    //         //             title: Text("Turn on Bluetooth"),
    //         //             trailing: Icon(
    //         //               Icons.bluetooth,
    //         //               color: Colors.grey,
    //         //             ),
    //         //           );
    //         //           //return BluetoothOffScreen(state: state);
    //         //         }),
    //         //   ),
    //         // ),
    //         //TestPerformLogics().timerUniversalStream
    //
    //         Positioned(top: 90,right:0,child:  StreamBuilder<bool>(
    //             stream: CustomerHomePageLogic().testRunningUniversalNotifier.outData,
    //
    //
    //             builder: (c, snapshot) {
    //               if(snapshot.hasData && snapshot.data == true){
    //                 return Card(elevation: 5,child: Container(height:bottomSelectedIndex==1?MediaQuery.of(context).size.height-150: 300,width: bottomSelectedIndex==1?MediaQuery.of(context).size.width: 200,child:runningTestRunning));
    //
    //
    //                 return  StreamBuilder<Widget>(
    //                     stream: CustomerHomePageLogic().testRunningFlaotingWidgetStream.outData,
    //                   //  initialData: Center(child: Text("NA")),
    //                     builder: (c, snapshotW) {
    //                       print("Float wid");
    //                       if(snapshotW.hasData){
    //                         return Card(elevation: 5,child: Container(height: 400,width: 300,child: snapshotW.data));
    //
    //                       }else{
    //                         return Container(width: 0,height: 0,);
    //                       }
    //
    //                     });
    //
    //               }else{
    //                 return Container(width: 0,height: 0,);
    //               }
    //
    //             }),),
    //
    //
    //
    //
    //         // Positioned(left: 0,right:0, bottom: 0,child: Center(
    //         //   child: Card(shape: RoundedRectangleBorder(
    //         //     borderRadius: BorderRadius.circular(75.0),
    //         //   ),color: Theme.of(context).primaryColor,child: Container(
    //         //     height: 60,
    //         //     width: 150,
    //         //     child: Padding(
    //         //       padding: const EdgeInsets.all(8.0),
    //         //       child: Center(child: Text("Perform Test",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
    //         //     ),
    //         //   ),)
    //         // ) )
    //       ],
    //     ));
  }

  void showIncome(data) {
    final AlertDialog dialog = AlertDialog(
      title: Text('Incomming Call !! '),
      content: Text('You have an incomming call'),
      actions: [
        FlatButton(
          //  textColor: Color(0xFF6200EE),
          onPressed: () => Navigator.pop(context),
          child: Text('REJECT'),
        ),
        FlatButton(
          //textColor: Color(0xFF6200EE),
          onPressed: () {
            initCallIntent(
              //widget.socket,
                "a",
                widget.auth.currentUser!.uid,
                data["callerId"],
                false,
                FirebaseFirestore.instance,
                context,
                data["callerName"]);
            // Navigator.pop(context);
          },
          child: Text('ACCEPT'),
        ),
      ],
    );
    if (mounted) {
      showDialog<void>(context: context, builder: (context) => dialog);
    }
  }

  void initPushNotification() async{
    FirebaseMessaging messaging = FirebaseMessaging.instance;


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  Future<void> listenForScan(BuildContext context) async {

     try{
        [Permission.bluetoothConnect,Permission.bluetoothScan,Permission.location,Permission.camera,Permission.microphone,Permission.storage,].request();
       setState(() {

       });
     }catch(e){
       setState(() {

       });

     }


     try{
       [Permission.bluetoothConnect,Permission.bluetoothScan,Permission.location,Permission.camera,Permission.microphone,Permission.storage,].request();
       setState(() {

       });
     }catch(e){
       setState(() {

       });

     }

     try{
       [Permission.bluetoothConnect,Permission.bluetoothScan,Permission.location,Permission.camera,Permission.microphone,Permission.storage,].request();
       setState(() {

       });
     }catch(e){
       setState(() {

       });

     }


    List ignoredList = [];

    bool isDialogShowing = false ;
    // List<ScanResult>  discovertedDevices = [];
    // List<BluetoothDevice>  connectedDevices = [];
    //
    // FlutterBlue flutterBlue = FlutterBlue.instance;
    // // Start scanning
    // flutterBlue.startScan(timeout: Duration(seconds: 4));
    // FlutterBlue.instance.scanResults.listen((event) {
    //   discovertedDevices =  event;
    //
    // });
    //

    //
    // SharedPreferences.getInstance().then((sharedPreff) {
    //
    //   timer = Timer.periodic(Duration(seconds: 5), (Timer t) async {
    //     print("5 second done");
    //     flutterBlue.startScan(timeout: Duration(seconds: 4));
    //    List<BluetoothDevice>  conDevice = await FlutterBlue.instance.connectedDevices;
    //
    //    if(conDevice == 0){
    //      flutterBlue.startScan(timeout: Duration(seconds: 4));
    //      if(discovertedDevices.isNotEmpty && discovertedDevices.length>0){
    //        print("scanned device "+discovertedDevices.length.toString());
    //        for(int i = 0 ; i < discovertedDevices.toList().length ; i++){
    //          //value.containsKey(event.toList()[i].device.name
    //          print("looking "+discovertedDevices[i].device.name);
    //
    //          if(discovertedDevices[i].device.name!=null && discovertedDevices[i].device.name.length>0 && (discovertedDevices[i].device.name.contains("Staht") | discovertedDevices[i].device.name.contains("Default") | discovertedDevices[i].device.name.contains("Mukul"))){
    //            if( sharedPreff.containsKey(discovertedDevices[i].device.name ) ){
    //              if(true || ignoredList.contains(discovertedDevices[i].device.name)){
    //                try{
    //
    //                  //AutoConnectPopUp
    //                  if(isDialogShowing == false){
    //                     isDialogShowing = true ;
    //
    //                    showDialog<void>(
    //                        context: context,
    //                        builder: (context) {
    //
    //                          return AutoConnectPopUp(title: discovertedDevices[i].device.name,conenctionCallback: (val){
    //                            if(val){
    //                              // ignoredList.remove(scannedDevices[i].device.name);
    //                              discovertedDevices[i].device.connect(autoConnect: false);
    //                              sharedPreff.setString(discovertedDevices[i].device.name, discovertedDevices[i].device.name);
    //
    //                            }else{
    //                              ignoredList.add(discovertedDevices[i].device.name);
    //                            }
    //                             isDialogShowing = false ;
    //
    //                          },);
    //                        }).then((value) {
    //                      isDialogShowing = false ;
    //                    });
    //                  }
    //                  // else {
    //                  //   isDialogShowing = false ;
    //                  // }
    //
    //                  break;
    //
    //
    //
    //                }catch(e){
    //                  print(e);
    //
    //                }
    //              }else{
    //                print("device was in ignored list");
    //
    //              }
    //
    //            }
    //
    //          }
    //          // tryCachScan();
    //        }
    //      }else{
    //        flutterBlue.startScan(timeout: Duration(seconds: 4));
    //      }
    //    }
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //   });
    //
    //
    //
    // });


    int pendingCounter = 0;
    tryCachScan() async {
      try{
        //false ||  FlutterBlue.instance.isScanning == false
        if(true){
          await FlutterBlue.instance.startScan(timeout: Duration(seconds: 20));

        }else{

          print("old scan is running");
        }

      }catch(e){
        print("exeption on scanning");
        print(e);
      }
    }
    bool isBottomSheetOpen = false;
    //tryCachScan();



    //Stream.periodic(Duration(seconds: 0)).asyncMap((_) => FlutterBlue.instance.connectedDevices.


    BuildContext dialogContext = context;

     setState(() {

     });
   // FlutterBlue flutterBlue = FlutterBlue.instance;

     setState(() {

     });
    CustomerHomePageLogic().scanDevicesNotifier.outData.listen((event) {
      isBottomSheetOpen = true;
      print("a");

      FlutterBlue.instance.state.first.then((bleStopOnState) {
        if (bleStopOnState == BluetoothState.on){



          showModalBottomSheet(shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
          ),
              context: context,
              builder: (context) {
                print("bottom sheet open");
                isBottomSheetOpen = true;
                return Container(
                  //height: height * 0.32,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(height * 0.02),
                          topRight: Radius.circular(height * 0.02)),
                      color: ThemeManager().getWhiteColor),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: ThemeManager().getLightGrey3Color,
                                    width: height * 0.0007)),
                          ),
                          padding: EdgeInsets.only(left: width * 0.06, right: width * 0.06),
                          height: height * 0.058,
                          width: double.infinity,
                          margin: EdgeInsets.only(top: height * 0.006),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Select Device",
                                style: interSemiBold.copyWith(
                                    fontSize: width * 0.035,
                                    color: ThemeManager().getBlackColor),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  TextConst.cancelText,
                                  style: interRegular.copyWith(
                                      color: ThemeManager().getRedColor),
                                ),
                              )
                            ],
                          ),
                        ),
                        StreamBuilder<Widget>(
                            stream: ScanWidgetStream.getInstance().outData,
                            initialData: Center(child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Please wait",style: interSemiBold.copyWith(
                                        fontSize: width * 0.045,
                                        color: ThemeManager().getBlackColor) ,),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                ],
                              ),
                            ),),
                            builder: (c, snapshot) {
                              return snapshot.data!;
                            }),
                        // Container(
                        //   //height: height * 0.16,
                        //   child: scanResult,
                        // ),
                        Container(
                          margin: EdgeInsets.only(
                              top: height * 0.02, bottom: height * 0.025),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  padding: EdgeInsets.only(
                                      right: width * 0.038, bottom: height * 0.014),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/svg/scanningIcon.svg",
                                        height: height * 0.035,
                                      ),
                                      SizedBox(width: width * 0.03),
                                      Text(
                                        "Scanning Devices...",
                                        style: interSemiBold.copyWith(
                                            color: ThemeManager().getDarkGreenColor,
                                            fontSize: width * 0.038),
                                      )
                                    ],
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );

              }).whenComplete(() {
            FlutterBlue.instance.stopScan();
            print("bottom sheet closed");
            isBottomSheetOpen = false;
          });






          // FlutterBlue.instance.startScan(timeout: Duration(seconds: 1));

          //   flutterBlue.stopScan().then((value) {

          // Start scanning
          FlutterBlue.instance.startScan(timeout: Duration(seconds: 20));




          print("Scan new done with 2 sec");




          List<BluetoothDevice> conenctedDevices = [];
          // FlutterBlue.instance.startScan(timeout: Duration(seconds: 2));

          setState(() {

          });

          doScanForMenualConnect() async {
            await Future.delayed(Duration(seconds: 1));

            mixWithConnectedAndSacnned(List<BluetoothDevice> connectedStream){
              Widget scanResult = StreamBuilder<List<ScanResult>>(
                stream:FlutterBlue.instance.scanResults,
                initialData: [],
                builder: (c, snapshot) {

                  AppToast().show(message: "found "+snapshot.data!.length.toString());
                  //true ||

                  return Column(
                    children: snapshot.data!
                        .map(
                          (r) {
                        if ( r.device.name != null &&
                            r.device.name.length > 0 &&
                            (r.device.name.contains("Staht") | r.device
                                .name.contains("Default") | r.device.name
                                .contains("Mukul") | r.device.name.contains("BLE Gauge"))
                        )
                          return conenctedDevices.contains(r.device)
                              ? InkWell(onTap: () {
                            r.device.disconnect().then((value) {
                              CustomerHomePageLogic()
                                  .connectedDevicesStream.dataReload(
                                  true);
                            });
                            // FlutterBlue.instance.startScan(timeout: Duration(seconds: 1));
                            Navigator.of(context).pop();
                          }, child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: ThemeManager()
                                          .getLightGrey3Color,
                                      width: height * 0.0007)),
                            ),
                            height: height * 0.052,
                            width: double.infinity,
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: width * 0.06,
                                  right: width * 0.06),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment
                                    .center,
                                children: [
                                  Text(r.device.name,
                                    style: interMedium.copyWith(
                                        fontSize: width * 0.037),
                                  ),
                                  Text("Disconnect",
                                    style: interSemiBold.copyWith(
                                        fontSize: width * 0.033,
                                        color: ThemeManager()
                                            .getRedColor),
                                  ),
                                ],
                              ),
                            ),
                          ),)
                              : InkWell(onTap: () async {


                            CustomerHomePageLogic().connectedDevicesStream.dataReload(true);
                            r.device.connect(autoConnect: false).then((value) async {
                              CustomerHomePageLogic().connectedDevicesStream.dataReload(true);

                              SharedPreferences.getInstance().then((
                                  value) {
                                value.setString(
                                    r.device.name, r.device.name);
                              });
                              try {
                                Navigator.pop(context);
                              } catch (e) {

                              }
                              CustomerHomePageLogic()
                                  .connectedDevicesStream.dataReload(
                                  true);

                              SharedPreferences sf = await SharedPreferences
                                  .getInstance();
                              String index6;
                              String index2;


                              void initDeviceSlAndCalibDate() async {
                                Duration waitingDuration = Duration(
                                    milliseconds: 50);
                                await r.device.discoverServices();

                                List<
                                    BluetoothService> allService = await r
                                    .device.discoverServices();
                                // print(allService.length.toString());


                                dynamic readWrite = await OsDependentSettings()
                                    .getReadWriteCharacters(
                                    device: r.device);

                                BluetoothCharacteristic read = readWrite["read"];

                                BluetoothCharacteristic write = readWrite["write"];


                                getIndex6() async {
                                  await Future.delayed(waitingDuration);

                                  allService =
                                  await r.device.discoverServices();
                                  print(allService.length.toString());

                                  dynamic readWrite = await OsDependentSettings()
                                      .getReadWriteCharacters(
                                      device: r.device);

                                  read = readWrite["read"];

                                  write = readWrite["write"];


                                  await write.write(
                                      StringToASCII(COMMAND_INDEX_6_GET_),
                                      withoutResponse: OsDependentSettings()
                                          .writeWithresponse);
                                  await read.read();
                                  await write.write(
                                      StringToASCII(COMMAND_INDEX_6_GET_),
                                      withoutResponse: OsDependentSettings()
                                          .writeWithresponse);
                                  List<int> responseAray6 = await read
                                      .read();
                                  String responseInString6 = utf8.decode(
                                      responseAray6);
                                  String data6 =
                                  removeCodesFromStrings(
                                      responseInString6,
                                      COMMAND_INDEX_6_GET_);
                                  print("2 " + data6);
                                  String g = "ok";


                                  index6 = data6;
                                  sf.setString("index6", data6);

                                  if (index6.length == 0) {
                                    try {
                                      await getIndex6();
                                    } catch (e) {
                                      await Future.delayed(
                                          waitingDuration);
                                      await getIndex6();
                                    }
                                  }
                                }


                                //await widget.d.disconnect();


                                getIndex1() async {
                                  await Future.delayed(waitingDuration);

                                  await write.write(
                                      StringToASCII(COMMAND_INDEX_2_GET_),
                                      withoutResponse: OsDependentSettings()
                                          .writeWithresponse);
                                  await read.read();
                                  await write.write(
                                      StringToASCII(COMMAND_INDEX_2_GET_),
                                      withoutResponse: OsDependentSettings()
                                          .writeWithresponse);
                                  List<int> responseAray2 = await read
                                      .read();
                                  String responseInString = utf8.decode(
                                      responseAray2);
                                  String data =
                                  removeCodesFromStrings(responseInString,
                                      COMMAND_INDEX_2_GET_);
                                  print("2 " + data);


                                  index2 = data;
                                  sf.setString("index2", data);

                                  if (index2.length == 0) {
                                    try {
                                      await getIndex1();
                                    } catch (e) {
                                      await Future.delayed(
                                          waitingDuration);
                                      await getIndex1();
                                    }
                                  } else {
                                    try {
                                      await getIndex6();
                                    } catch (e) {
                                      await Future.delayed(
                                          waitingDuration);
                                      await getIndex6();
                                    }
                                  }
                                }

                                try {
                                  await getIndex1();
                                } catch (e) {
                                  await Future.delayed(waitingDuration);
                                  await getIndex1();
                                }


                                // Navigator.pop(context);
                              }
                              initDeviceSlAndCalibDate();
                            });
                            await Future.delayed(Duration(seconds: 1));
                            CustomerHomePageLogic().connectedDevicesStream.dataReload(true);
                            //return Text("ok");
                            //   return   PerformTestPage(device: r.device,project: widget.projectID,);
                            //   return PerformTestPageActivity(device: r.device, project: "", index2: '',);
                            //Navigator.pop(context);
                            //return ConnectedDevicePage(device: r.device);
                            //return DeviceScreenLessDetails(r.device);

                            await Future.delayed(Duration(seconds: 1));
                            CustomerHomePageLogic().connectedDevicesStream.dataReload(true);
                            try{
                              await  r.device.connect(autoConnect: false);
                            }catch(e){

                            }
                            await Future.delayed(Duration(seconds: 1));
                            CustomerHomePageLogic().connectedDevicesStream.dataReload(true);
                            try{
                              await  r.device.connect(autoConnect: false);
                            }catch(e){

                            }



                          },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: ThemeManager()
                                            .getLightGrey3Color,
                                        width: height * 0.0007)),
                              ),
                              height: height * 0.052,
                              width: double.infinity,
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: width * 0.06,
                                    right: width * 0.06),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment
                                      .center,
                                  children: [
                                    Text(r.device.name,
                                      style: interMedium.copyWith(
                                          fontSize: width * 0.037),
                                    ),
                                    Text("Select",
                                      style: interSemiBold.copyWith(
                                          fontSize: width * 0.033,
                                          color: ThemeManager()
                                              .getRedColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        else
                          return Container(width: 0, height: 0,);
                      },
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
                // builder: (c, snapshot) => Column(
                //   children: snapshot.data!
                //       .map(
                //         (r) => ScanResultTile(
                //       result: r,
                //       onTap: () {
                //         r.device.connect(autoConnect: false).then((value) async{
                //           CustomerHomePageLogic().connectedDevicesStream.dataReload(true);
                //
                //           SharedPreferences sf =await SharedPreferences.getInstance();
                //           String index6;
                //           String index2;
                //
                //
                //           void initDeviceSlAndCalibDate() async {
                //
                //             Duration waitingDuration = Duration(milliseconds: 50);
                //             await  r.device.discoverServices();
                //
                //             List<BluetoothService> allService = await r.device.discoverServices();
                //             // print(allService.length.toString());
                //
                //
                //             dynamic readWrite = await OsDependentSettings().getReadWriteCharacters(device: r.device);
                //
                //             BluetoothCharacteristic read = readWrite["read"];
                //
                //             BluetoothCharacteristic write = readWrite["write"];
                //
                //
                //
                //
                //             getIndex6()async{
                //               await Future.delayed(waitingDuration);
                //
                //               allService = await r.device.discoverServices();
                //               print(allService.length.toString());
                //
                //               dynamic readWrite = await OsDependentSettings().getReadWriteCharacters(device: r.device);
                //
                //               read = readWrite["read"];
                //
                //               write = readWrite["write"];
                //
                //
                //
                //
                //
                //
                //               await write.write(StringToASCII(COMMAND_INDEX_6_GET_),
                //                   withoutResponse: OsDependentSettings().writeWithresponse);
                //               await read.read();
                //               await write.write(StringToASCII(COMMAND_INDEX_6_GET_),
                //                   withoutResponse: OsDependentSettings().writeWithresponse);
                //               List<int> responseAray6 = await read.read();
                //               String responseInString6 = utf8.decode(responseAray6);
                //               String data6 =
                //               removeCodesFromStrings(responseInString6, COMMAND_INDEX_6_GET_);
                //               print("2 " + data6);
                //               String g = "ok";
                //
                //
                //
                //
                //               index6 = data6;
                //               sf.setString("index6", data6);
                //
                //               if(index6.length == 0){
                //                 try{
                //                   await getIndex6();
                //                 }catch(e){
                //                   await Future.delayed(waitingDuration);
                //                   await getIndex6();
                //                 }
                //               }
                //             }
                //
                //
                //             //await widget.d.disconnect();
                //
                //
                //             getIndex1()async{
                //               await Future.delayed(waitingDuration);
                //
                //               await write.write(StringToASCII(COMMAND_INDEX_2_GET_),
                //                   withoutResponse: OsDependentSettings().writeWithresponse);
                //               await read.read();
                //               await write.write(StringToASCII(COMMAND_INDEX_2_GET_),
                //                   withoutResponse: OsDependentSettings().writeWithresponse);
                //               List<int> responseAray2 = await read.read();
                //               String responseInString = utf8.decode(responseAray2);
                //               String data =
                //               removeCodesFromStrings(responseInString, COMMAND_INDEX_2_GET_);
                //               print("2 " + data);
                //
                //
                //               index2 = data;
                //               sf.setString("index2", data);
                //
                //               if(index2.length == 0){
                //                 try{
                //                   await getIndex1();
                //                 }catch(e){
                //                   await Future.delayed(waitingDuration);
                //                   await getIndex1();
                //                 }
                //
                //
                //
                //
                //
                //               }else{
                //                 try{
                //                   await getIndex6();
                //                 }catch(e){
                //                   await Future.delayed(waitingDuration);
                //                   await getIndex6();
                //                 }
                //               }
                //             }
                //
                //             try{
                //               await getIndex1();
                //             }catch(e){
                //               await Future.delayed(waitingDuration);
                //               await getIndex1();
                //             }
                //
                //
                //
                //           // Navigator.pop(context);
                //           }
                //           initDeviceSlAndCalibDate();
                //
                //         });
                //         //return Text("ok");
                //         //   return   PerformTestPage(device: r.device,project: widget.projectID,);
                //         //   return PerformTestPageActivity(device: r.device, project: "", index2: '',);
                //         //Navigator.pop(context);
                //         //return ConnectedDevicePage(device: r.device);
                //         //return DeviceScreenLessDetails(r.device);
                //       },
                //     ),
                //     //     (r) => ScanResultTile(
                //     //   result: r,
                //     //   onTap: () => Navigator.of(context)
                //     //       .push(MaterialPageRoute(builder: (context) {
                //     //     r.device.connect(autoConnect: false);
                //     //     //return Text("ok");
                //     //  //   return   PerformTestPage(device: r.device,project: widget.projectID,);
                //     //     return   PerformTestPage(device: r.device,project:"o",);
                //     //     Navigator.pop(context);
                //     //     //return ConnectedDevicePage(device: r.device);
                //     //     //return DeviceScreenLessDetails(r.device);
                //     //   })),
                //     // ),
                //   )
                //       .toList(),
                // ),
              );
              // if(isDialogShowing == true){
              //  // Navigator.pop(context);
              // }

              ScanWidgetStream.getInstance().dataReload(scanResult);
            }


            FlutterBlue.instance.connectedDevices.asStream().listen((connectedStream) {





              conenctedDevices = connectedStream.toList();

              //  FlutterBlue.instance.startScan(timeout: Duration(seconds: 2));


              mixWithConnectedAndSacnned(connectedStream);


              print("c");

            });
            mixWithConnectedAndSacnned([]);









          }


          doScanForMenualConnect();


          // FlutterBlue.instance.connectedDevices.then((value)  {
          //   print("d");
          //   if (value.length > 0) {
          //     CustomerHomePageLogic().connectedDevicesStream.dataReload(true);
          //     showModalBottomSheet(context: context, builder: (context) => Container(height: 300,
          //       decoration: BoxDecoration(
          //         color: Colors.white,
          //         borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),bottomLeft:Radius.circular(0),bottomRight: Radius.circular(0)),
          //       ),
          //       child: Column(
          //         children: value
          //             .map((d) => ListTile(
          //           onTap: () {
          //
          //           },
          //
          //           title: Text(d.name),
          //           subtitle: Text(d.id.toString()),
          //           trailing: StreamBuilder<
          //               BluetoothDeviceState>(
          //             stream: d.state,
          //             initialData: BluetoothDeviceState
          //                 .disconnected,
          //             builder: (c, snapshot) {
          //               if (snapshot.data == BluetoothDeviceState.connected) {
          //                 return InkWell(
          //                   //CLick to Proceed
          //                   child: Text("Perform Test"),
          //                   onTap: () async {
          //                     try {
          //                       //get Share
          //                       SharedPreferences
          //                       sharedPref =
          //                       await SharedPreferences
          //                           .getInstance();
          //                       String lastLoad =
          //                           sharedPref.getString(
          //                               "lastLoad")??"0";
          //                       TextEditingController c =
          //                       TextEditingController(
          //                           text: lastLoad);
          //                       // Navigator.push(
          //                       //   context,
          //                       //   MaterialPageRoute(
          //                       //       builder: (context) =>
          //                       //           TakePreDataActivity(
          //                       //             lastLoad: lastLoad,
          //                       //             d: d,
          //                       //             customerId:
          //                       //             widget.projct,
          //                       //             customerFirestore:
          //                       //             widget.customerFirestore,
          //                       //             sPref:
          //                       //             sharedPref,
          //                       //             controller: c,
          //                       //           )),
          //                       // );
          //                     } catch (e) {
          //                       print(e.toString());
          //                     }
          //                   },
          //                 );
          //               }
          //               return Text(
          //                   snapshot.data.toString());
          //             },
          //           ),
          //         ))
          //             .toList(),
          //       ),
          //     ));
          //
          //
          //
          //
          //
          //
          //   } else {
          //     Widget old = Container(
          //
          //       decoration: BoxDecoration(
          //         color: Colors.white,
          //         borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),bottomLeft:Radius.circular(0),bottomRight: Radius.circular(0)),
          //       ),
          //       child:  StreamBuilder<List<ScanResult>>(
          //         stream: FlutterBlue.instance.scanResults,
          //         initialData: [],
          //         builder: (c, snapshot) {
          //           //  updateData(snapshot.data);
          //           // FirebaseFirestore firestore;
          //           //  Database(firestore: firestore).addData(snapshot.data);
          //
          //           return Column(
          //             children: snapshot.data!
          //                 .map(
          //                   (r) => ScanResultTile(
          //                 result: r,
          //                 onTap: () {
          //                   r.device.connect(autoConnect: false).then((value) async{
          //                     CustomerHomePageLogic().connectedDevicesStream.dataReload(true);
          //
          //                     SharedPreferences sf =await SharedPreferences.getInstance();
          //                     String index6;
          //                     String index2;
          //
          //
          //                     void initDeviceSlAndCalibDate() async {
          //
          //                       Duration waitingDuration = Duration(milliseconds: 50);
          //                       await  r.device.discoverServices();
          //
          //                       List<BluetoothService> allService = await r.device.discoverServices();
          //                       // print(allService.length.toString());
          //
          //
          //                       dynamic readWrite = await OsDependentSettings().getReadWriteCharacters(device: r.device);
          //
          //                       BluetoothCharacteristic read = readWrite["read"];
          //
          //                       BluetoothCharacteristic write = readWrite["write"];
          //
          //
          //
          //
          //                       getIndex6()async{
          //                         await Future.delayed(waitingDuration);
          //
          //                         allService = await r.device.discoverServices();
          //                         print(allService.length.toString());
          //
          //                         dynamic readWrite = await OsDependentSettings().getReadWriteCharacters(device: r.device);
          //
          //                         read = readWrite["read"];
          //
          //                         write = readWrite["write"];
          //
          //
          //
          //
          //
          //
          //                         await write.write(StringToASCII(COMMAND_INDEX_6_GET_),
          //                             withoutResponse: OsDependentSettings().writeWithresponse);
          //                         await read.read();
          //                         await write.write(StringToASCII(COMMAND_INDEX_6_GET_),
          //                             withoutResponse: OsDependentSettings().writeWithresponse);
          //                         List<int> responseAray6 = await read.read();
          //                         String responseInString6 = utf8.decode(responseAray6);
          //                         String data6 =
          //                         removeCodesFromStrings(responseInString6, COMMAND_INDEX_6_GET_);
          //                         print("2 " + data6);
          //                         String g = "ok";
          //
          //
          //
          //
          //                         index6 = data6;
          //                         sf.setString("index6", data6);
          //
          //                         if(index6.length == 0){
          //                           try{
          //                             await getIndex6();
          //                           }catch(e){
          //                             await Future.delayed(waitingDuration);
          //                             await getIndex6();
          //                           }
          //                         }
          //                       }
          //
          //
          //                       //await widget.d.disconnect();
          //
          //
          //                       getIndex1()async{
          //                         await Future.delayed(waitingDuration);
          //
          //                         await write.write(StringToASCII(COMMAND_INDEX_2_GET_),
          //                             withoutResponse: OsDependentSettings().writeWithresponse);
          //                         await read.read();
          //                         await write.write(StringToASCII(COMMAND_INDEX_2_GET_),
          //                             withoutResponse: OsDependentSettings().writeWithresponse);
          //                         List<int> responseAray2 = await read.read();
          //                         String responseInString = utf8.decode(responseAray2);
          //                         String data =
          //                         removeCodesFromStrings(responseInString, COMMAND_INDEX_2_GET_);
          //                         print("2 " + data);
          //
          //
          //                         index2 = data;
          //                         sf.setString("index2", data);
          //
          //                         if(index2.length == 0){
          //                           try{
          //                             await getIndex1();
          //                           }catch(e){
          //                             await Future.delayed(waitingDuration);
          //                             await getIndex1();
          //                           }
          //
          //
          //
          //
          //
          //                         }else{
          //                           try{
          //                             await getIndex6();
          //                           }catch(e){
          //                             await Future.delayed(waitingDuration);
          //                             await getIndex6();
          //                           }
          //                         }
          //                       }
          //
          //                       try{
          //                         await getIndex1();
          //                       }catch(e){
          //                         await Future.delayed(waitingDuration);
          //                         await getIndex1();
          //                       }
          //
          //
          //
          //                       Navigator.pop(context);
          //                     }
          //                     initDeviceSlAndCalibDate();
          //
          //                   });
          //                   //return Text("ok");
          //                   //   return   PerformTestPage(device: r.device,project: widget.projectID,);
          //                   //   return PerformTestPageActivity(device: r.device, project: "", index2: '',);
          //                   Navigator.pop(context);
          //                   //return ConnectedDevicePage(device: r.device);
          //                   //return DeviceScreenLessDetails(r.device);
          //                 },
          //               ),
          //               //     (r) => ScanResultTile(
          //               //   result: r,
          //               //   onTap: () => Navigator.of(context)
          //               //       .push(MaterialPageRoute(builder: (context) {
          //               //     r.device.connect(autoConnect: false);
          //               //     //return Text("ok");
          //               //  //   return   PerformTestPage(device: r.device,project: widget.projectID,);
          //               //     return   PerformTestPage(device: r.device,project:"o",);
          //               //     Navigator.pop(context);
          //               //     //return ConnectedDevicePage(device: r.device);
          //               //     //return DeviceScreenLessDetails(r.device);
          //               //   })),
          //               // ),
          //             )
          //                 .toList(),
          //           );
          //         },
          //       ),
          //     );
          //     Widget scanResult = StreamBuilder<List<ScanResult>>(
          //       stream: FlutterBlue.instance.scanResults,
          //       initialData: [],
          //       builder: (c, snapshot) => Column(
          //         children: snapshot.data!
          //             .map(
          //               (r) => ScanResultTile(
          //             result: r,
          //             onTap: () {
          //               r.device.connect(autoConnect: false).then((value) async{
          //                 CustomerHomePageLogic().connectedDevicesStream.dataReload(true);
          //
          //                 SharedPreferences sf =await SharedPreferences.getInstance();
          //                 String index6;
          //                 String index2;
          //
          //
          //                 void initDeviceSlAndCalibDate() async {
          //
          //                   Duration waitingDuration = Duration(milliseconds: 50);
          //                   await  r.device.discoverServices();
          //
          //                   List<BluetoothService> allService = await r.device.discoverServices();
          //                   // print(allService.length.toString());
          //
          //
          //                   dynamic readWrite = await OsDependentSettings().getReadWriteCharacters(device: r.device);
          //
          //                   BluetoothCharacteristic read = readWrite["read"];
          //
          //                   BluetoothCharacteristic write = readWrite["write"];
          //
          //
          //
          //
          //                   getIndex6()async{
          //                     await Future.delayed(waitingDuration);
          //
          //                     allService = await r.device.discoverServices();
          //                     print(allService.length.toString());
          //
          //                     dynamic readWrite = await OsDependentSettings().getReadWriteCharacters(device: r.device);
          //
          //                     read = readWrite["read"];
          //
          //                     write = readWrite["write"];
          //
          //
          //
          //
          //
          //
          //                     await write.write(StringToASCII(COMMAND_INDEX_6_GET_),
          //                         withoutResponse: OsDependentSettings().writeWithresponse);
          //                     await read.read();
          //                     await write.write(StringToASCII(COMMAND_INDEX_6_GET_),
          //                         withoutResponse: OsDependentSettings().writeWithresponse);
          //                     List<int> responseAray6 = await read.read();
          //                     String responseInString6 = utf8.decode(responseAray6);
          //                     String data6 =
          //                     removeCodesFromStrings(responseInString6, COMMAND_INDEX_6_GET_);
          //                     print("2 " + data6);
          //                     String g = "ok";
          //
          //
          //
          //
          //                     index6 = data6;
          //                     sf.setString("index6", data6);
          //
          //                     if(index6.length == 0){
          //                       try{
          //                         await getIndex6();
          //                       }catch(e){
          //                         await Future.delayed(waitingDuration);
          //                         await getIndex6();
          //                       }
          //                     }
          //                   }
          //
          //
          //                   //await widget.d.disconnect();
          //
          //
          //                   getIndex1()async{
          //                     await Future.delayed(waitingDuration);
          //
          //                     await write.write(StringToASCII(COMMAND_INDEX_2_GET_),
          //                         withoutResponse: OsDependentSettings().writeWithresponse);
          //                     await read.read();
          //                     await write.write(StringToASCII(COMMAND_INDEX_2_GET_),
          //                         withoutResponse: OsDependentSettings().writeWithresponse);
          //                     List<int> responseAray2 = await read.read();
          //                     String responseInString = utf8.decode(responseAray2);
          //                     String data =
          //                     removeCodesFromStrings(responseInString, COMMAND_INDEX_2_GET_);
          //                     print("2 " + data);
          //
          //
          //                     index2 = data;
          //                     sf.setString("index2", data);
          //
          //                     if(index2.length == 0){
          //                       try{
          //                         await getIndex1();
          //                       }catch(e){
          //                         await Future.delayed(waitingDuration);
          //                         await getIndex1();
          //                       }
          //
          //
          //
          //
          //
          //                     }else{
          //                       try{
          //                         await getIndex6();
          //                       }catch(e){
          //                         await Future.delayed(waitingDuration);
          //                         await getIndex6();
          //                       }
          //                     }
          //                   }
          //
          //                   try{
          //                     await getIndex1();
          //                   }catch(e){
          //                     await Future.delayed(waitingDuration);
          //                     await getIndex1();
          //                   }
          //
          //
          //
          //                   Navigator.pop(context);
          //                 }
          //                 initDeviceSlAndCalibDate();
          //
          //               });
          //               //return Text("ok");
          //               //   return   PerformTestPage(device: r.device,project: widget.projectID,);
          //               //   return PerformTestPageActivity(device: r.device, project: "", index2: '',);
          //               Navigator.pop(context);
          //               //return ConnectedDevicePage(device: r.device);
          //               //return DeviceScreenLessDetails(r.device);
          //             },
          //           ),
          //           //     (r) => ScanResultTile(
          //           //   result: r,
          //           //   onTap: () => Navigator.of(context)
          //           //       .push(MaterialPageRoute(builder: (context) {
          //           //     r.device.connect(autoConnect: false);
          //           //     //return Text("ok");
          //           //  //   return   PerformTestPage(device: r.device,project: widget.projectID,);
          //           //     return   PerformTestPage(device: r.device,project:"o",);
          //           //     Navigator.pop(context);
          //           //     //return ConnectedDevicePage(device: r.device);
          //           //     //return DeviceScreenLessDetails(r.device);
          //           //   })),
          //           // ),
          //         )
          //             .toList(),
          //       ),
          //     );
          //     showModalBottomSheet(
          //         context: context,
          //         builder: (context) {
          //           return scanResult;
          //         });
          //
          //     FlutterBlue.instance.startScan(timeout: Duration(milliseconds: 500)).then((value){
          //
          //
          //
          //
          //
          //
          //
          //
          //       // showBottomSheet(
          //       //     context: context,
          //       //     builder: (context) => Container(
          //       //       child: StreamBuilder<List<ScanResult>>(
          //       //         stream: FlutterBlue
          //       //             .instance.scanResults,
          //       //         initialData: [],
          //       //         builder: (c, snapshot) {
          //       //           //  updateData(snapshot.data);
          //       //           FirebaseFirestore firestore;
          //       //           //  Database(firestore: firestore).addData(snapshot.data);
          //       //
          //       //           return ListView.builder(
          //       //             padding: EdgeInsets.zero,
          //       //             itemCount:snapshot.data!.length,
          //       //             shrinkWrap: true,
          //       //             itemBuilder: (BuildContext context, int index)
          //       //             {
          //       //               return InkWell(onTap: (){
          //       //               },
          //       //                 child: Stack(
          //       //                   children: [
          //       //                     Align(alignment: Alignment.centerLeft,child: Padding(
          //       //                       padding: const EdgeInsets.all(8.0),
          //       //                       child: Text(snapshot.data![index].device.name),
          //       //                     ),),
          //       //                     Align(alignment: Alignment.centerRight,child: Padding(
          //       //                       padding: const EdgeInsets.all(8.0),
          //       //                       child: Text("Use",style: TextStyle(color: Colors.red),),
          //       //                     ),),
          //       //                   ],
          //       //                 ),
          //       //               );
          //       //             },
          //       //           );
          //       //
          //       //           // return Column(
          //       //           //   children: snapshot.data!
          //       //           //       .map(
          //       //           //         (r) => ScanResultTile(
          //       //           //       result: r,
          //       //           //       onTap: () {
          //       //           //         r.device
          //       //           //             .connect(
          //       //           //             autoConnect:
          //       //           //             false)
          //       //           //             .then(
          //       //           //                 (value) {
          //       //           //               //fetch index2 and index6
          //       //           //               initDeviceSlAndCalibDate(widget.device);
          //       //           //               setState(() {
          //       //           //                 widget.device =
          //       //           //                     r.device;
          //       //           //               });
          //       //           //               Navigator.pop(
          //       //           //                   context);
          //       //           //
          //       //           //
          //       //           //             });
          //       //           //         //return Scaffold(body: Text("Not using"),);
          //       //           //         //return Text("ok");
          //       //           //         //   return   PerformTestPage(device: r.device,project: widget.projectID,);
          //       //           //         // return PerformTestPageActivity(
          //       //           //         //     device:
          //       //           //         //         r.device,
          //       //           //         //     project: widget
          //       //           //         //         .projct);
          //       //           //         Navigator.pop(
          //       //           //             context);
          //       //           //         //return ConnectedDevicePage(device: r.device);
          //       //           //         //return DeviceScreenLessDetails(r.device);
          //       //           //       },
          //       //           //     ),
          //       //           //     //     (r) => ScanResultTile(
          //       //           //     //   result: r,
          //       //           //     //   onTap: () => Navigator.of(context)
          //       //           //     //       .push(MaterialPageRoute(builder: (context) {
          //       //           //     //     r.device.connect(autoConnect: false);
          //       //           //     //     //return Text("ok");
          //       //           //     //  //   return   PerformTestPage(device: r.device,project: widget.projectID,);
          //       //           //     //     return   PerformTestPage(device: r.device,project:"o",);
          //       //           //     //     Navigator.pop(context);
          //       //           //     //     //return ConnectedDevicePage(device: r.device);
          //       //           //     //     //return DeviceScreenLessDetails(r.device);
          //       //           //     //   })),
          //       //           //     // ),
          //       //           //   )
          //       //           //       .toList(),
          //       //           // );
          //       //         },
          //       //       ),
          //       //     ));
          //
          //     } );
          //
          //
          //     // showDialog<void>(
          //     //     context: context,
          //     //     builder: (context) => SimpleDialog(
          //     //       children: [
          //     //         StreamBuilder<List<ScanResult>>(
          //     //           stream: FlutterBlue
          //     //               .instance.scanResults,
          //     //           initialData: [],
          //     //           builder: (c, snapshot) {
          //     //             //  updateData(snapshot.data);
          //     //             FirebaseFirestore firestore;
          //     //             //  Database(firestore: firestore).addData(snapshot.data);
          //     //
          //     //             return ListView.builder(
          //     //               padding: EdgeInsets.zero,
          //     //               itemCount:snapshot.data!.length,
          //     //               shrinkWrap: true,
          //     //               itemBuilder: (BuildContext context, int index)
          //     //               {
          //     //                 return InkWell(onTap: (){
          //     //                 },
          //     //                   child: Stack(
          //     //                     children: [
          //     //                       Align(alignment: Alignment.centerLeft,child: Padding(
          //     //                         padding: const EdgeInsets.all(8.0),
          //     //                         child: Text(snapshot.data![index].device.name),
          //     //                       ),),
          //     //                       Align(alignment: Alignment.centerRight,child: Padding(
          //     //                         padding: const EdgeInsets.all(8.0),
          //     //                         child: Text("Use",style: TextStyle(color: Colors.red),),
          //     //                       ),),
          //     //                     ],
          //     //                   ),
          //     //                 );
          //     //               },
          //     //             );
          //     //
          //     //             // return Column(
          //     //             //   children: snapshot.data!
          //     //             //       .map(
          //     //             //         (r) => ScanResultTile(
          //     //             //       result: r,
          //     //             //       onTap: () {
          //     //             //         r.device
          //     //             //             .connect(
          //     //             //             autoConnect:
          //     //             //             false)
          //     //             //             .then(
          //     //             //                 (value) {
          //     //             //               //fetch index2 and index6
          //     //             //               initDeviceSlAndCalibDate(widget.device);
          //     //             //               setState(() {
          //     //             //                 widget.device =
          //     //             //                     r.device;
          //     //             //               });
          //     //             //               Navigator.pop(
          //     //             //                   context);
          //     //             //
          //     //             //
          //     //             //             });
          //     //             //         //return Scaffold(body: Text("Not using"),);
          //     //             //         //return Text("ok");
          //     //             //         //   return   PerformTestPage(device: r.device,project: widget.projectID,);
          //     //             //         // return PerformTestPageActivity(
          //     //             //         //     device:
          //     //             //         //         r.device,
          //     //             //         //     project: widget
          //     //             //         //         .projct);
          //     //             //         Navigator.pop(
          //     //             //             context);
          //     //             //         //return ConnectedDevicePage(device: r.device);
          //     //             //         //return DeviceScreenLessDetails(r.device);
          //     //             //       },
          //     //             //     ),
          //     //             //     //     (r) => ScanResultTile(
          //     //             //     //   result: r,
          //     //             //     //   onTap: () => Navigator.of(context)
          //     //             //     //       .push(MaterialPageRoute(builder: (context) {
          //     //             //     //     r.device.connect(autoConnect: false);
          //     //             //     //     //return Text("ok");
          //     //             //     //  //   return   PerformTestPage(device: r.device,project: widget.projectID,);
          //     //             //     //     return   PerformTestPage(device: r.device,project:"o",);
          //     //             //     //     Navigator.pop(context);
          //     //             //     //     //return ConnectedDevicePage(device: r.device);
          //     //             //     //     //return DeviceScreenLessDetails(r.device);
          //     //             //     //   })),
          //     //             //     // ),
          //     //             //   )
          //     //             //       .toList(),
          //     //             // );
          //     //           },
          //     //         )
          //     //       ],
          //     //     ));
          //     // return InkWell(onTap: (){
          //     //
          //     // },
          //     //   child: ListTile(
          //     //     onTap: () {
          //     //
          //     //     },
          //     //     title: Text("No Device is Connected"),
          //     //     trailing: Text(
          //     //       "Scan",
          //     //       style: TextStyle(),
          //     //     ),
          //     //   ),
          //     //);
          //     // return ListTile(
          //     //   onTap: () {
          //     //
          //     //   },
          //     //   title: Text("No Device is Connected"),
          //     //   trailing: Text(
          //     //     "Scan",
          //     //     style: TextStyle(),
          //     //   ),
          //     // );
          //   }
          //
          // });


          //    });

        }else{
          showModalBottomSheet(shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
          ),
              context: context,
              builder: (context) {
                print("bottom sheet open");
                return Container(
                  //height: height * 0.32,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(height * 0.02),
                          topRight: Radius.circular(height * 0.02)),
                      color: ThemeManager().getWhiteColor),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: ThemeManager().getLightGrey3Color,
                                    width: height * 0.0007)),
                          ),
                          padding: EdgeInsets.only(left: width * 0.06, right: width * 0.06),
                          height: height * 0.058,
                          width: double.infinity,
                          margin: EdgeInsets.only(top: height * 0.006),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Bluetooth is OFF",
                                style: interSemiBold.copyWith(
                                    fontSize: width * 0.035,
                                    color: ThemeManager().getBlackColor),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  TextConst.cancelText,
                                  style: interRegular.copyWith(
                                      color: ThemeManager().getRedColor),
                                ),
                              )
                            ],
                          ),
                        ),

                        // Container(
                        //   //height: height * 0.16,
                        //   child: scanResult,
                        // ),
                        Container(
                          margin: EdgeInsets.only(
                              top: height * 0.02, bottom: height * 0.025),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  padding: EdgeInsets.only(
                                      right: width * 0.038, bottom: height * 0.014),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/svg/scanningIcon.svg",
                                        height: height * 0.035,
                                      ),
                                      SizedBox(width: width * 0.03),
                                      Text(
                                        "Please turn ON bluetooth...",
                                        style: interSemiBold.copyWith(
                                            color: ThemeManager().getDarkGreenColor,
                                            fontSize: width * 0.038),
                                      )
                                    ],
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );

              }).whenComplete(() => FlutterBlue.instance.stopScan());
        }
      });

      // FlutterBlue.instance.state.listen((event) {
      //   print("b");
      //
      // });



    });

    //Platform.isAndroid

    bool autoConnect = false;


    if(autoConnect) {
      SharedPreferences.getInstance().then((sharedPreff) {
        // tryCachScan();

        timer = Timer.periodic(Duration(seconds: 5), (Timer t) async {
          print("5 second done");
          // isBottomSheetOpen == false
          if (isBottomSheetOpen == false) {
            doWorkImportant(){
              FlutterBlue.instance.connectedDevices.then((value) {
                print("conencted device " + value.length.toString());
                if (value.length == 0) {
                  print("connected device " + value.length.toString());

                  //  tryCachScan();

                  doNext(List<ScanResult> scannedDevices){
                    {
                      print("scanned device " + scannedDevices.length.toString());
                      for (int i = 0; i < scannedDevices
                          .toList()
                          .length; i++) {
                        //value.containsKey(event.toList()[i].device.name
                        print("looking " + scannedDevices[i].device.name);

                        if (scannedDevices[i].device.name != null &&
                            scannedDevices[i].device.name.length > 0 &&
                            (scannedDevices[i].device.name.contains(
                                "Staht") | scannedDevices[i].device.name.contains(
                                "Default") | scannedDevices[i].device.name
                                .contains("Mukul"))) {
                          if (  sharedPreff.containsKey(scannedDevices[i].device.name)) {
                            if (ignoredList.contains(scannedDevices[i].device.name)== false) {
                              try {
                                //AutoConnectPopUp
                                if (isDialogShowing == false) {
                                  isDialogShowing = true ;

                                  showDialog<void>(
                                      context: context,
                                      builder: (context) {
                                        dialogContext = context;
                                        return AutoConnectPopUp(
                                          title: scannedDevices[i].device.name,
                                          conenctionCallback: (val) async {
                                            if (val == true ) {
                                              try{
                                                scannedDevices[i].device.connect(autoConnect: false).then((value) {

                                                  CustomerHomePageLogic().connectedDevicesStream.dataReload(true);
                                                });
                                                await Future.delayed(Duration(seconds: 1));
                                                CustomerHomePageLogic().connectedDevicesStream.dataReload(true);

                                                sharedPreff.setString(scannedDevices[i].device.name, scannedDevices[i].device.name);
                                              }catch(e){
                                                await  scannedDevices[i].device.connect(autoConnect: false);
                                                await Future.delayed(Duration(seconds: 1));
                                                await  CustomerHomePageLogic().connectedDevicesStream.dataReload(true);

                                                await  sharedPreff.setString(scannedDevices[i].device.name, scannedDevices[i].device.name);
                                              }
                                            } else {
                                              ignoredList.add(scannedDevices[i].device.name);
                                            }
                                            isDialogShowing = false ;

                                          },);
                                      }).then((value) {
                                    isDialogShowing = false ;
                                  });
                                }
                                // else {
                                //   isDialogShowing = false ;
                                // }

                                break;
                              } catch (e) {
                                print(e);
                              }
                            } else {
                              print("device was in ignored list");
                            }
                          }
                        }
                        // tryCachScan();
                      }
                    }
                  }



                  FlutterBlue.instance.scanResults.first.then((scannedDevices) {

                    print("scanned device " + scannedDevices.length.toString());
                    if ( scannedDevices.length > 0) {
                      doNext(scannedDevices);
                    }else{
                      FlutterBlue.instance.scanResults.last.then((value) {
                        if(value.length>0){
                          doNext(value);
                        }else{
                          FlutterBlue.instance.scanResults.listen((event) {
                            doNext(event);
                          });
                        }
                      });



                    }
                  });



                }
              });
            }
            //FlutterBlue.instance.startScan(timeout: Duration(seconds: 2));

            FlutterBlue.instance.startScan(timeout: Duration(seconds: 2));
            doWorkImportant();

            // flutterBlue.startScan(timeout: Duration(seconds: 2)).then((value) {
            //
            //
            //   doWorkImportant();
            //   //first scan
            //
            //
            //
            //
            //
            // });
            // doWorkImportant();
            // await Future.delayed(Duration(seconds: 1));
            // tryCachScan();

          } else {
            print("Scan stopped because bottomsheet is open");
          }
        });
      });
    }

  }

  Future<void> listenForScan2(BuildContext context) async {

    List ignoredList = [];

    bool isDialogShowing = false ;
    // List<ScanResult>  discovertedDevices = [];
    // List<BluetoothDevice>  connectedDevices = [];
    //
    // FlutterBlue flutterBlue = FlutterBlue.instance;
    // // Start scanning
    // flutterBlue.startScan(timeout: Duration(seconds: 4));
    // FlutterBlue.instance.scanResults.listen((event) {
    //   discovertedDevices =  event;
    //
    // });
    //

    //
    // SharedPreferences.getInstance().then((sharedPreff) {
    //
    //   timer = Timer.periodic(Duration(seconds: 5), (Timer t) async {
    //     print("5 second done");
    //     flutterBlue.startScan(timeout: Duration(seconds: 4));
    //    List<BluetoothDevice>  conDevice = await FlutterBlue.instance.connectedDevices;
    //
    //    if(conDevice == 0){
    //      flutterBlue.startScan(timeout: Duration(seconds: 4));
    //      if(discovertedDevices.isNotEmpty && discovertedDevices.length>0){
    //        print("scanned device "+discovertedDevices.length.toString());
    //        for(int i = 0 ; i < discovertedDevices.toList().length ; i++){
    //          //value.containsKey(event.toList()[i].device.name
    //          print("looking "+discovertedDevices[i].device.name);
    //
    //          if(discovertedDevices[i].device.name!=null && discovertedDevices[i].device.name.length>0 && (discovertedDevices[i].device.name.contains("Staht") | discovertedDevices[i].device.name.contains("Default") | discovertedDevices[i].device.name.contains("Mukul"))){
    //            if( sharedPreff.containsKey(discovertedDevices[i].device.name ) ){
    //              if(true || ignoredList.contains(discovertedDevices[i].device.name)){
    //                try{
    //
    //                  //AutoConnectPopUp
    //                  if(isDialogShowing == false){
    //                     isDialogShowing = true ;
    //
    //                    showDialog<void>(
    //                        context: context,
    //                        builder: (context) {
    //
    //                          return AutoConnectPopUp(title: discovertedDevices[i].device.name,conenctionCallback: (val){
    //                            if(val){
    //                              // ignoredList.remove(scannedDevices[i].device.name);
    //                              discovertedDevices[i].device.connect(autoConnect: false);
    //                              sharedPreff.setString(discovertedDevices[i].device.name, discovertedDevices[i].device.name);
    //
    //                            }else{
    //                              ignoredList.add(discovertedDevices[i].device.name);
    //                            }
    //                             isDialogShowing = false ;
    //
    //                          },);
    //                        }).then((value) {
    //                      isDialogShowing = false ;
    //                    });
    //                  }
    //                  // else {
    //                  //   isDialogShowing = false ;
    //                  // }
    //
    //                  break;
    //
    //
    //
    //                }catch(e){
    //                  print(e);
    //
    //                }
    //              }else{
    //                print("device was in ignored list");
    //
    //              }
    //
    //            }
    //
    //          }
    //          // tryCachScan();
    //        }
    //      }else{
    //        flutterBlue.startScan(timeout: Duration(seconds: 4));
    //      }
    //    }
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //   });
    //
    //
    //
    // });


    int pendingCounter = 0;
    tryCachScan() async {
      try{
        //false ||  FlutterBlue.instance.isScanning == false
        if(true){
          FlutterBlue.instance.startScan(timeout: Duration(seconds: 20));

        }else{

          print("old scan is running");
        }

      }catch(e){
        print("exeption on scanning");
        print(e);
      }
    }
    bool isBottomSheetOpen = false;




    //Stream.periodic(Duration(seconds: 0)).asyncMap((_) => FlutterBlue.instance.connectedDevices.

    //await getPermissions();
    BuildContext dialogContext = context;
    AppToast().show(message: "Asking permissions");
    // if (await Permission.camera.request().isGranted) {
    //   AppToast().show(message: "has camera perm");
    // }
    // await Permission.camera.status.then((value) {
    //   AppToast().show(message: "camera status "+value.toString());
    // });
    // await Permission.bluetoothConnect.status.then((value) {
    //   AppToast().show(message: "bluetoothConnect status "+value.toString());
    // });
    // Map<Permission, PermissionStatus> statuses = await  [
    // Permission.camera,Permission.bluetooth, Permission.bluetoothConnect,Permission.location,
    // Permission.bluetoothAdvertise,Permission.bluetoothScan,
    // ].request();
  //  AppToast().show(message: statuses.toString());




    FlutterBlue flutterBlue = FlutterBlue.instance;
   // tryCachScan();
    CustomerHomePageLogic().scanDevicesNotifier.outData.listen((event) {
      isBottomSheetOpen = true;
      print("a");

      flutterBlue.state.first.then((bleStopOnState) {
        if (bleStopOnState == BluetoothState.on){



          showModalBottomSheet(shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
          ),
              context: context,
              builder: (context) {
                print("bottom sheet open");
                isBottomSheetOpen = true;
                return Container(
                  //height: height * 0.32,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(height * 0.02),
                          topRight: Radius.circular(height * 0.02)),
                      color: ThemeManager().getWhiteColor),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: ThemeManager().getLightGrey3Color,
                                    width: height * 0.0007)),
                          ),
                          padding: EdgeInsets.only(left: width * 0.06, right: width * 0.06),
                          height: height * 0.058,
                          width: double.infinity,
                          margin: EdgeInsets.only(top: height * 0.006),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Select Device",
                                style: interSemiBold.copyWith(
                                    fontSize: width * 0.035,
                                    color: ThemeManager().getBlackColor),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  TextConst.cancelText,
                                  style: interRegular.copyWith(
                                      color: ThemeManager().getRedColor),
                                ),
                              )
                            ],
                          ),
                        ),
                        StreamBuilder<Widget>(
                        stream: ScanWidgetStream.getInstance().outData,
                        initialData: Center(child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Please wait",style: interSemiBold.copyWith(
                                fontSize: width * 0.045,
                                color: ThemeManager().getBlackColor) ,),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              ),
                            ],
                          ),
                        ),),
                        builder: (c, snapshot) {
                          return snapshot.data!;
                        }),
                        // Container(
                        //   //height: height * 0.16,
                        //   child: scanResult,
                        // ),
                        Container(
                          margin: EdgeInsets.only(
                              top: height * 0.02, bottom: height * 0.025),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  padding: EdgeInsets.only(
                                      right: width * 0.038, bottom: height * 0.014),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/svg/scanningIcon.svg",
                                        height: height * 0.035,
                                      ),
                                      SizedBox(width: width * 0.03),
                                      Text(
                                        "Scanning Devices...",
                                        style: interSemiBold.copyWith(
                                            color: ThemeManager().getDarkGreenColor,
                                            fontSize: width * 0.038),
                                      )
                                    ],
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );

              }).whenComplete(() {
           // flutterBlue.stopScan();
            print("bottom sheet closed");
            isBottomSheetOpen = false;
          });






           // FlutterBlue.instance.startScan(timeout: Duration(seconds: 1));

       //   flutterBlue.stopScan().then((value) {

            // Start scanning





              print("Scan new done with 2 sec");




              List<BluetoothDevice> conenctedDevices = [];
            //  FlutterBlue.instance.startScan(timeout: Duration(seconds: 2));

              doScanForMenualConnect() async {
                //await Future.delayed(Duration(seconds: 1));

                mixWithConnectedAndSacnned(List<BluetoothDevice> connectedStream){
                  Widget scanResult = StreamBuilder<List<ScanResult>>(
                    stream:flutterBlue.scanResults,
                    initialData: [],
                    builder: (c, snapshot) {
                      AppToast().show(message: snapshot.data!.length.toString()+" number device found");
                      //

                      return Column(
                        children: snapshot.data!
                            .map(
                              (r) {
                            if (r.device.name != null &&
                                r.device.name.length > 0 &&
                                (r.device.name.contains("Staht") | r.device
                                    .name.contains("Default") | r.device.name
                                    .contains("Mukul") | r.device.name.contains("BLE Gauge"))
                            )
                              return conenctedDevices.contains(r.device)
                                  ? InkWell(onTap: () {
                                r.device.disconnect().then((value) {
                                  CustomerHomePageLogic()
                                      .connectedDevicesStream.dataReload(
                                      true);
                                });
                                // FlutterBlue.instance.startScan(timeout: Duration(seconds: 1));
                                Navigator.of(context).pop();
                              }, child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: ThemeManager()
                                              .getLightGrey3Color,
                                          width: height * 0.0007)),
                                ),
                                height: height * 0.052,
                                width: double.infinity,
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: width * 0.06,
                                      right: width * 0.06),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    children: [
                                      Text(r.device.name,
                                        style: interMedium.copyWith(
                                            fontSize: width * 0.037),
                                      ),
                                      Text("Disconnect",
                                        style: interSemiBold.copyWith(
                                            fontSize: width * 0.033,
                                            color: ThemeManager()
                                                .getRedColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ),)
                                  : InkWell(onTap: () async {


                                CustomerHomePageLogic().connectedDevicesStream.dataReload(true);
                                r.device.connect(autoConnect: false).then((value) async {
                                  CustomerHomePageLogic().connectedDevicesStream.dataReload(true);

                                  SharedPreferences.getInstance().then((
                                      value) {
                                    value.setString(
                                        r.device.name, r.device.name);
                                  });
                                  try {
                                    Navigator.pop(context);
                                  } catch (e) {

                                  }
                                  CustomerHomePageLogic()
                                      .connectedDevicesStream.dataReload(
                                      true);

                                  SharedPreferences sf = await SharedPreferences
                                      .getInstance();
                                  String index6;
                                  String index2;


                                  void initDeviceSlAndCalibDate() async {
                                    Duration waitingDuration = Duration(
                                        milliseconds: 50);
                                    await r.device.discoverServices();

                                    List<
                                        BluetoothService> allService = await r
                                        .device.discoverServices();
                                    // print(allService.length.toString());


                                    dynamic readWrite = await OsDependentSettings()
                                        .getReadWriteCharacters(
                                        device: r.device);

                                    BluetoothCharacteristic read = readWrite["read"];

                                    BluetoothCharacteristic write = readWrite["write"];


                                    getIndex6() async {
                                      await Future.delayed(waitingDuration);

                                      allService =
                                      await r.device.discoverServices();
                                      print(allService.length.toString());

                                      dynamic readWrite = await OsDependentSettings()
                                          .getReadWriteCharacters(
                                          device: r.device);

                                      read = readWrite["read"];

                                      write = readWrite["write"];


                                      await write.write(
                                          StringToASCII(COMMAND_INDEX_6_GET_),
                                          withoutResponse: OsDependentSettings()
                                              .writeWithresponse);
                                      await read.read();
                                      await write.write(
                                          StringToASCII(COMMAND_INDEX_6_GET_),
                                          withoutResponse: OsDependentSettings()
                                              .writeWithresponse);
                                      List<int> responseAray6 = await read
                                          .read();
                                      String responseInString6 = utf8.decode(
                                          responseAray6);
                                      String data6 =
                                      removeCodesFromStrings(
                                          responseInString6,
                                          COMMAND_INDEX_6_GET_);
                                      print("2 " + data6);
                                      String g = "ok";


                                      index6 = data6;
                                      sf.setString("index6", data6);

                                      if (index6.length == 0) {
                                        try {
                                          await getIndex6();
                                        } catch (e) {
                                          await Future.delayed(
                                              waitingDuration);
                                          await getIndex6();
                                        }
                                      }
                                    }


                                    //await widget.d.disconnect();


                                    getIndex1() async {
                                      await Future.delayed(waitingDuration);

                                      await write.write(
                                          StringToASCII(COMMAND_INDEX_2_GET_),
                                          withoutResponse: OsDependentSettings()
                                              .writeWithresponse);
                                      await read.read();
                                      await write.write(
                                          StringToASCII(COMMAND_INDEX_2_GET_),
                                          withoutResponse: OsDependentSettings()
                                              .writeWithresponse);
                                      List<int> responseAray2 = await read
                                          .read();
                                      String responseInString = utf8.decode(
                                          responseAray2);
                                      String data =
                                      removeCodesFromStrings(responseInString,
                                          COMMAND_INDEX_2_GET_);
                                      print("2 " + data);


                                      index2 = data;
                                      sf.setString("index2", data);

                                      if (index2.length == 0) {
                                        try {
                                          await getIndex1();
                                        } catch (e) {
                                          await Future.delayed(
                                              waitingDuration);
                                          await getIndex1();
                                        }
                                      } else {
                                        try {
                                          await getIndex6();
                                        } catch (e) {
                                          await Future.delayed(
                                              waitingDuration);
                                          await getIndex6();
                                        }
                                      }
                                    }

                                    try {
                                      await getIndex1();
                                    } catch (e) {
                                      await Future.delayed(waitingDuration);
                                      await getIndex1();
                                    }


                                    // Navigator.pop(context);
                                  }
                                  initDeviceSlAndCalibDate();
                                });
                                await Future.delayed(Duration(seconds: 1));
                                CustomerHomePageLogic().connectedDevicesStream.dataReload(true);
                                //return Text("ok");
                                //   return   PerformTestPage(device: r.device,project: widget.projectID,);
                                //   return PerformTestPageActivity(device: r.device, project: "", index2: '',);
                                //Navigator.pop(context);
                                //return ConnectedDevicePage(device: r.device);
                                //return DeviceScreenLessDetails(r.device);

                                await Future.delayed(Duration(seconds: 1));
                                CustomerHomePageLogic().connectedDevicesStream.dataReload(true);
                                try{
                                  await  r.device.connect(autoConnect: false);
                                }catch(e){

                                }
                                await Future.delayed(Duration(seconds: 1));
                                CustomerHomePageLogic().connectedDevicesStream.dataReload(true);
                                try{
                                  await  r.device.connect(autoConnect: false);
                                }catch(e){

                                }



                              },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: ThemeManager()
                                                .getLightGrey3Color,
                                            width: height * 0.0007)),
                                  ),
                                  height: height * 0.052,
                                  width: double.infinity,
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: width * 0.06,
                                        right: width * 0.06),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      children: [
                                        Text(r.device.name,
                                          style: interMedium.copyWith(
                                              fontSize: width * 0.037),
                                        ),
                                        Text("Select",
                                          style: interSemiBold.copyWith(
                                              fontSize: width * 0.033,
                                              color: ThemeManager()
                                                  .getRedColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            else
                              return Container(width: 0, height: 0,);
                          },
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
                    // builder: (c, snapshot) => Column(
                    //   children: snapshot.data!
                    //       .map(
                    //         (r) => ScanResultTile(
                    //       result: r,
                    //       onTap: () {
                    //         r.device.connect(autoConnect: false).then((value) async{
                    //           CustomerHomePageLogic().connectedDevicesStream.dataReload(true);
                    //
                    //           SharedPreferences sf =await SharedPreferences.getInstance();
                    //           String index6;
                    //           String index2;
                    //
                    //
                    //           void initDeviceSlAndCalibDate() async {
                    //
                    //             Duration waitingDuration = Duration(milliseconds: 50);
                    //             await  r.device.discoverServices();
                    //
                    //             List<BluetoothService> allService = await r.device.discoverServices();
                    //             // print(allService.length.toString());
                    //
                    //
                    //             dynamic readWrite = await OsDependentSettings().getReadWriteCharacters(device: r.device);
                    //
                    //             BluetoothCharacteristic read = readWrite["read"];
                    //
                    //             BluetoothCharacteristic write = readWrite["write"];
                    //
                    //
                    //
                    //
                    //             getIndex6()async{
                    //               await Future.delayed(waitingDuration);
                    //
                    //               allService = await r.device.discoverServices();
                    //               print(allService.length.toString());
                    //
                    //               dynamic readWrite = await OsDependentSettings().getReadWriteCharacters(device: r.device);
                    //
                    //               read = readWrite["read"];
                    //
                    //               write = readWrite["write"];
                    //
                    //
                    //
                    //
                    //
                    //
                    //               await write.write(StringToASCII(COMMAND_INDEX_6_GET_),
                    //                   withoutResponse: OsDependentSettings().writeWithresponse);
                    //               await read.read();
                    //               await write.write(StringToASCII(COMMAND_INDEX_6_GET_),
                    //                   withoutResponse: OsDependentSettings().writeWithresponse);
                    //               List<int> responseAray6 = await read.read();
                    //               String responseInString6 = utf8.decode(responseAray6);
                    //               String data6 =
                    //               removeCodesFromStrings(responseInString6, COMMAND_INDEX_6_GET_);
                    //               print("2 " + data6);
                    //               String g = "ok";
                    //
                    //
                    //
                    //
                    //               index6 = data6;
                    //               sf.setString("index6", data6);
                    //
                    //               if(index6.length == 0){
                    //                 try{
                    //                   await getIndex6();
                    //                 }catch(e){
                    //                   await Future.delayed(waitingDuration);
                    //                   await getIndex6();
                    //                 }
                    //               }
                    //             }
                    //
                    //
                    //             //await widget.d.disconnect();
                    //
                    //
                    //             getIndex1()async{
                    //               await Future.delayed(waitingDuration);
                    //
                    //               await write.write(StringToASCII(COMMAND_INDEX_2_GET_),
                    //                   withoutResponse: OsDependentSettings().writeWithresponse);
                    //               await read.read();
                    //               await write.write(StringToASCII(COMMAND_INDEX_2_GET_),
                    //                   withoutResponse: OsDependentSettings().writeWithresponse);
                    //               List<int> responseAray2 = await read.read();
                    //               String responseInString = utf8.decode(responseAray2);
                    //               String data =
                    //               removeCodesFromStrings(responseInString, COMMAND_INDEX_2_GET_);
                    //               print("2 " + data);
                    //
                    //
                    //               index2 = data;
                    //               sf.setString("index2", data);
                    //
                    //               if(index2.length == 0){
                    //                 try{
                    //                   await getIndex1();
                    //                 }catch(e){
                    //                   await Future.delayed(waitingDuration);
                    //                   await getIndex1();
                    //                 }
                    //
                    //
                    //
                    //
                    //
                    //               }else{
                    //                 try{
                    //                   await getIndex6();
                    //                 }catch(e){
                    //                   await Future.delayed(waitingDuration);
                    //                   await getIndex6();
                    //                 }
                    //               }
                    //             }
                    //
                    //             try{
                    //               await getIndex1();
                    //             }catch(e){
                    //               await Future.delayed(waitingDuration);
                    //               await getIndex1();
                    //             }
                    //
                    //
                    //
                    //           // Navigator.pop(context);
                    //           }
                    //           initDeviceSlAndCalibDate();
                    //
                    //         });
                    //         //return Text("ok");
                    //         //   return   PerformTestPage(device: r.device,project: widget.projectID,);
                    //         //   return PerformTestPageActivity(device: r.device, project: "", index2: '',);
                    //         //Navigator.pop(context);
                    //         //return ConnectedDevicePage(device: r.device);
                    //         //return DeviceScreenLessDetails(r.device);
                    //       },
                    //     ),
                    //     //     (r) => ScanResultTile(
                    //     //   result: r,
                    //     //   onTap: () => Navigator.of(context)
                    //     //       .push(MaterialPageRoute(builder: (context) {
                    //     //     r.device.connect(autoConnect: false);
                    //     //     //return Text("ok");
                    //     //  //   return   PerformTestPage(device: r.device,project: widget.projectID,);
                    //     //     return   PerformTestPage(device: r.device,project:"o",);
                    //     //     Navigator.pop(context);
                    //     //     //return ConnectedDevicePage(device: r.device);
                    //     //     //return DeviceScreenLessDetails(r.device);
                    //     //   })),
                    //     // ),
                    //   )
                    //       .toList(),
                    // ),
                  );
                  // if(isDialogShowing == true){
                  //  // Navigator.pop(context);
                  // }

                  ScanWidgetStream.getInstance().dataReload(scanResult);
                }


                flutterBlue.connectedDevices.asStream().listen((connectedStream) {





                    conenctedDevices = connectedStream.toList();

                    //  FlutterBlue.instance.startScan(timeout: Duration(seconds: 2));


                   mixWithConnectedAndSacnned(connectedStream);


                    print("c");

                });
                mixWithConnectedAndSacnned([]);









              }


              doScanForMenualConnect();


              // FlutterBlue.instance.connectedDevices.then((value)  {
              //   print("d");
              //   if (value.length > 0) {
              //     CustomerHomePageLogic().connectedDevicesStream.dataReload(true);
              //     showModalBottomSheet(context: context, builder: (context) => Container(height: 300,
              //       decoration: BoxDecoration(
              //         color: Colors.white,
              //         borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),bottomLeft:Radius.circular(0),bottomRight: Radius.circular(0)),
              //       ),
              //       child: Column(
              //         children: value
              //             .map((d) => ListTile(
              //           onTap: () {
              //
              //           },
              //
              //           title: Text(d.name),
              //           subtitle: Text(d.id.toString()),
              //           trailing: StreamBuilder<
              //               BluetoothDeviceState>(
              //             stream: d.state,
              //             initialData: BluetoothDeviceState
              //                 .disconnected,
              //             builder: (c, snapshot) {
              //               if (snapshot.data == BluetoothDeviceState.connected) {
              //                 return InkWell(
              //                   //CLick to Proceed
              //                   child: Text("Perform Test"),
              //                   onTap: () async {
              //                     try {
              //                       //get Share
              //                       SharedPreferences
              //                       sharedPref =
              //                       await SharedPreferences
              //                           .getInstance();
              //                       String lastLoad =
              //                           sharedPref.getString(
              //                               "lastLoad")??"0";
              //                       TextEditingController c =
              //                       TextEditingController(
              //                           text: lastLoad);
              //                       // Navigator.push(
              //                       //   context,
              //                       //   MaterialPageRoute(
              //                       //       builder: (context) =>
              //                       //           TakePreDataActivity(
              //                       //             lastLoad: lastLoad,
              //                       //             d: d,
              //                       //             customerId:
              //                       //             widget.projct,
              //                       //             customerFirestore:
              //                       //             widget.customerFirestore,
              //                       //             sPref:
              //                       //             sharedPref,
              //                       //             controller: c,
              //                       //           )),
              //                       // );
              //                     } catch (e) {
              //                       print(e.toString());
              //                     }
              //                   },
              //                 );
              //               }
              //               return Text(
              //                   snapshot.data.toString());
              //             },
              //           ),
              //         ))
              //             .toList(),
              //       ),
              //     ));
              //
              //
              //
              //
              //
              //
              //   } else {
              //     Widget old = Container(
              //
              //       decoration: BoxDecoration(
              //         color: Colors.white,
              //         borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),bottomLeft:Radius.circular(0),bottomRight: Radius.circular(0)),
              //       ),
              //       child:  StreamBuilder<List<ScanResult>>(
              //         stream: FlutterBlue.instance.scanResults,
              //         initialData: [],
              //         builder: (c, snapshot) {
              //           //  updateData(snapshot.data);
              //           // FirebaseFirestore firestore;
              //           //  Database(firestore: firestore).addData(snapshot.data);
              //
              //           return Column(
              //             children: snapshot.data!
              //                 .map(
              //                   (r) => ScanResultTile(
              //                 result: r,
              //                 onTap: () {
              //                   r.device.connect(autoConnect: false).then((value) async{
              //                     CustomerHomePageLogic().connectedDevicesStream.dataReload(true);
              //
              //                     SharedPreferences sf =await SharedPreferences.getInstance();
              //                     String index6;
              //                     String index2;
              //
              //
              //                     void initDeviceSlAndCalibDate() async {
              //
              //                       Duration waitingDuration = Duration(milliseconds: 50);
              //                       await  r.device.discoverServices();
              //
              //                       List<BluetoothService> allService = await r.device.discoverServices();
              //                       // print(allService.length.toString());
              //
              //
              //                       dynamic readWrite = await OsDependentSettings().getReadWriteCharacters(device: r.device);
              //
              //                       BluetoothCharacteristic read = readWrite["read"];
              //
              //                       BluetoothCharacteristic write = readWrite["write"];
              //
              //
              //
              //
              //                       getIndex6()async{
              //                         await Future.delayed(waitingDuration);
              //
              //                         allService = await r.device.discoverServices();
              //                         print(allService.length.toString());
              //
              //                         dynamic readWrite = await OsDependentSettings().getReadWriteCharacters(device: r.device);
              //
              //                         read = readWrite["read"];
              //
              //                         write = readWrite["write"];
              //
              //
              //
              //
              //
              //
              //                         await write.write(StringToASCII(COMMAND_INDEX_6_GET_),
              //                             withoutResponse: OsDependentSettings().writeWithresponse);
              //                         await read.read();
              //                         await write.write(StringToASCII(COMMAND_INDEX_6_GET_),
              //                             withoutResponse: OsDependentSettings().writeWithresponse);
              //                         List<int> responseAray6 = await read.read();
              //                         String responseInString6 = utf8.decode(responseAray6);
              //                         String data6 =
              //                         removeCodesFromStrings(responseInString6, COMMAND_INDEX_6_GET_);
              //                         print("2 " + data6);
              //                         String g = "ok";
              //
              //
              //
              //
              //                         index6 = data6;
              //                         sf.setString("index6", data6);
              //
              //                         if(index6.length == 0){
              //                           try{
              //                             await getIndex6();
              //                           }catch(e){
              //                             await Future.delayed(waitingDuration);
              //                             await getIndex6();
              //                           }
              //                         }
              //                       }
              //
              //
              //                       //await widget.d.disconnect();
              //
              //
              //                       getIndex1()async{
              //                         await Future.delayed(waitingDuration);
              //
              //                         await write.write(StringToASCII(COMMAND_INDEX_2_GET_),
              //                             withoutResponse: OsDependentSettings().writeWithresponse);
              //                         await read.read();
              //                         await write.write(StringToASCII(COMMAND_INDEX_2_GET_),
              //                             withoutResponse: OsDependentSettings().writeWithresponse);
              //                         List<int> responseAray2 = await read.read();
              //                         String responseInString = utf8.decode(responseAray2);
              //                         String data =
              //                         removeCodesFromStrings(responseInString, COMMAND_INDEX_2_GET_);
              //                         print("2 " + data);
              //
              //
              //                         index2 = data;
              //                         sf.setString("index2", data);
              //
              //                         if(index2.length == 0){
              //                           try{
              //                             await getIndex1();
              //                           }catch(e){
              //                             await Future.delayed(waitingDuration);
              //                             await getIndex1();
              //                           }
              //
              //
              //
              //
              //
              //                         }else{
              //                           try{
              //                             await getIndex6();
              //                           }catch(e){
              //                             await Future.delayed(waitingDuration);
              //                             await getIndex6();
              //                           }
              //                         }
              //                       }
              //
              //                       try{
              //                         await getIndex1();
              //                       }catch(e){
              //                         await Future.delayed(waitingDuration);
              //                         await getIndex1();
              //                       }
              //
              //
              //
              //                       Navigator.pop(context);
              //                     }
              //                     initDeviceSlAndCalibDate();
              //
              //                   });
              //                   //return Text("ok");
              //                   //   return   PerformTestPage(device: r.device,project: widget.projectID,);
              //                   //   return PerformTestPageActivity(device: r.device, project: "", index2: '',);
              //                   Navigator.pop(context);
              //                   //return ConnectedDevicePage(device: r.device);
              //                   //return DeviceScreenLessDetails(r.device);
              //                 },
              //               ),
              //               //     (r) => ScanResultTile(
              //               //   result: r,
              //               //   onTap: () => Navigator.of(context)
              //               //       .push(MaterialPageRoute(builder: (context) {
              //               //     r.device.connect(autoConnect: false);
              //               //     //return Text("ok");
              //               //  //   return   PerformTestPage(device: r.device,project: widget.projectID,);
              //               //     return   PerformTestPage(device: r.device,project:"o",);
              //               //     Navigator.pop(context);
              //               //     //return ConnectedDevicePage(device: r.device);
              //               //     //return DeviceScreenLessDetails(r.device);
              //               //   })),
              //               // ),
              //             )
              //                 .toList(),
              //           );
              //         },
              //       ),
              //     );
              //     Widget scanResult = StreamBuilder<List<ScanResult>>(
              //       stream: FlutterBlue.instance.scanResults,
              //       initialData: [],
              //       builder: (c, snapshot) => Column(
              //         children: snapshot.data!
              //             .map(
              //               (r) => ScanResultTile(
              //             result: r,
              //             onTap: () {
              //               r.device.connect(autoConnect: false).then((value) async{
              //                 CustomerHomePageLogic().connectedDevicesStream.dataReload(true);
              //
              //                 SharedPreferences sf =await SharedPreferences.getInstance();
              //                 String index6;
              //                 String index2;
              //
              //
              //                 void initDeviceSlAndCalibDate() async {
              //
              //                   Duration waitingDuration = Duration(milliseconds: 50);
              //                   await  r.device.discoverServices();
              //
              //                   List<BluetoothService> allService = await r.device.discoverServices();
              //                   // print(allService.length.toString());
              //
              //
              //                   dynamic readWrite = await OsDependentSettings().getReadWriteCharacters(device: r.device);
              //
              //                   BluetoothCharacteristic read = readWrite["read"];
              //
              //                   BluetoothCharacteristic write = readWrite["write"];
              //
              //
              //
              //
              //                   getIndex6()async{
              //                     await Future.delayed(waitingDuration);
              //
              //                     allService = await r.device.discoverServices();
              //                     print(allService.length.toString());
              //
              //                     dynamic readWrite = await OsDependentSettings().getReadWriteCharacters(device: r.device);
              //
              //                     read = readWrite["read"];
              //
              //                     write = readWrite["write"];
              //
              //
              //
              //
              //
              //
              //                     await write.write(StringToASCII(COMMAND_INDEX_6_GET_),
              //                         withoutResponse: OsDependentSettings().writeWithresponse);
              //                     await read.read();
              //                     await write.write(StringToASCII(COMMAND_INDEX_6_GET_),
              //                         withoutResponse: OsDependentSettings().writeWithresponse);
              //                     List<int> responseAray6 = await read.read();
              //                     String responseInString6 = utf8.decode(responseAray6);
              //                     String data6 =
              //                     removeCodesFromStrings(responseInString6, COMMAND_INDEX_6_GET_);
              //                     print("2 " + data6);
              //                     String g = "ok";
              //
              //
              //
              //
              //                     index6 = data6;
              //                     sf.setString("index6", data6);
              //
              //                     if(index6.length == 0){
              //                       try{
              //                         await getIndex6();
              //                       }catch(e){
              //                         await Future.delayed(waitingDuration);
              //                         await getIndex6();
              //                       }
              //                     }
              //                   }
              //
              //
              //                   //await widget.d.disconnect();
              //
              //
              //                   getIndex1()async{
              //                     await Future.delayed(waitingDuration);
              //
              //                     await write.write(StringToASCII(COMMAND_INDEX_2_GET_),
              //                         withoutResponse: OsDependentSettings().writeWithresponse);
              //                     await read.read();
              //                     await write.write(StringToASCII(COMMAND_INDEX_2_GET_),
              //                         withoutResponse: OsDependentSettings().writeWithresponse);
              //                     List<int> responseAray2 = await read.read();
              //                     String responseInString = utf8.decode(responseAray2);
              //                     String data =
              //                     removeCodesFromStrings(responseInString, COMMAND_INDEX_2_GET_);
              //                     print("2 " + data);
              //
              //
              //                     index2 = data;
              //                     sf.setString("index2", data);
              //
              //                     if(index2.length == 0){
              //                       try{
              //                         await getIndex1();
              //                       }catch(e){
              //                         await Future.delayed(waitingDuration);
              //                         await getIndex1();
              //                       }
              //
              //
              //
              //
              //
              //                     }else{
              //                       try{
              //                         await getIndex6();
              //                       }catch(e){
              //                         await Future.delayed(waitingDuration);
              //                         await getIndex6();
              //                       }
              //                     }
              //                   }
              //
              //                   try{
              //                     await getIndex1();
              //                   }catch(e){
              //                     await Future.delayed(waitingDuration);
              //                     await getIndex1();
              //                   }
              //
              //
              //
              //                   Navigator.pop(context);
              //                 }
              //                 initDeviceSlAndCalibDate();
              //
              //               });
              //               //return Text("ok");
              //               //   return   PerformTestPage(device: r.device,project: widget.projectID,);
              //               //   return PerformTestPageActivity(device: r.device, project: "", index2: '',);
              //               Navigator.pop(context);
              //               //return ConnectedDevicePage(device: r.device);
              //               //return DeviceScreenLessDetails(r.device);
              //             },
              //           ),
              //           //     (r) => ScanResultTile(
              //           //   result: r,
              //           //   onTap: () => Navigator.of(context)
              //           //       .push(MaterialPageRoute(builder: (context) {
              //           //     r.device.connect(autoConnect: false);
              //           //     //return Text("ok");
              //           //  //   return   PerformTestPage(device: r.device,project: widget.projectID,);
              //           //     return   PerformTestPage(device: r.device,project:"o",);
              //           //     Navigator.pop(context);
              //           //     //return ConnectedDevicePage(device: r.device);
              //           //     //return DeviceScreenLessDetails(r.device);
              //           //   })),
              //           // ),
              //         )
              //             .toList(),
              //       ),
              //     );
              //     showModalBottomSheet(
              //         context: context,
              //         builder: (context) {
              //           return scanResult;
              //         });
              //
              //     FlutterBlue.instance.startScan(timeout: Duration(milliseconds: 500)).then((value){
              //
              //
              //
              //
              //
              //
              //
              //
              //       // showBottomSheet(
              //       //     context: context,
              //       //     builder: (context) => Container(
              //       //       child: StreamBuilder<List<ScanResult>>(
              //       //         stream: FlutterBlue
              //       //             .instance.scanResults,
              //       //         initialData: [],
              //       //         builder: (c, snapshot) {
              //       //           //  updateData(snapshot.data);
              //       //           FirebaseFirestore firestore;
              //       //           //  Database(firestore: firestore).addData(snapshot.data);
              //       //
              //       //           return ListView.builder(
              //       //             padding: EdgeInsets.zero,
              //       //             itemCount:snapshot.data!.length,
              //       //             shrinkWrap: true,
              //       //             itemBuilder: (BuildContext context, int index)
              //       //             {
              //       //               return InkWell(onTap: (){
              //       //               },
              //       //                 child: Stack(
              //       //                   children: [
              //       //                     Align(alignment: Alignment.centerLeft,child: Padding(
              //       //                       padding: const EdgeInsets.all(8.0),
              //       //                       child: Text(snapshot.data![index].device.name),
              //       //                     ),),
              //       //                     Align(alignment: Alignment.centerRight,child: Padding(
              //       //                       padding: const EdgeInsets.all(8.0),
              //       //                       child: Text("Use",style: TextStyle(color: Colors.red),),
              //       //                     ),),
              //       //                   ],
              //       //                 ),
              //       //               );
              //       //             },
              //       //           );
              //       //
              //       //           // return Column(
              //       //           //   children: snapshot.data!
              //       //           //       .map(
              //       //           //         (r) => ScanResultTile(
              //       //           //       result: r,
              //       //           //       onTap: () {
              //       //           //         r.device
              //       //           //             .connect(
              //       //           //             autoConnect:
              //       //           //             false)
              //       //           //             .then(
              //       //           //                 (value) {
              //       //           //               //fetch index2 and index6
              //       //           //               initDeviceSlAndCalibDate(widget.device);
              //       //           //               setState(() {
              //       //           //                 widget.device =
              //       //           //                     r.device;
              //       //           //               });
              //       //           //               Navigator.pop(
              //       //           //                   context);
              //       //           //
              //       //           //
              //       //           //             });
              //       //           //         //return Scaffold(body: Text("Not using"),);
              //       //           //         //return Text("ok");
              //       //           //         //   return   PerformTestPage(device: r.device,project: widget.projectID,);
              //       //           //         // return PerformTestPageActivity(
              //       //           //         //     device:
              //       //           //         //         r.device,
              //       //           //         //     project: widget
              //       //           //         //         .projct);
              //       //           //         Navigator.pop(
              //       //           //             context);
              //       //           //         //return ConnectedDevicePage(device: r.device);
              //       //           //         //return DeviceScreenLessDetails(r.device);
              //       //           //       },
              //       //           //     ),
              //       //           //     //     (r) => ScanResultTile(
              //       //           //     //   result: r,
              //       //           //     //   onTap: () => Navigator.of(context)
              //       //           //     //       .push(MaterialPageRoute(builder: (context) {
              //       //           //     //     r.device.connect(autoConnect: false);
              //       //           //     //     //return Text("ok");
              //       //           //     //  //   return   PerformTestPage(device: r.device,project: widget.projectID,);
              //       //           //     //     return   PerformTestPage(device: r.device,project:"o",);
              //       //           //     //     Navigator.pop(context);
              //       //           //     //     //return ConnectedDevicePage(device: r.device);
              //       //           //     //     //return DeviceScreenLessDetails(r.device);
              //       //           //     //   })),
              //       //           //     // ),
              //       //           //   )
              //       //           //       .toList(),
              //       //           // );
              //       //         },
              //       //       ),
              //       //     ));
              //
              //     } );
              //
              //
              //     // showDialog<void>(
              //     //     context: context,
              //     //     builder: (context) => SimpleDialog(
              //     //       children: [
              //     //         StreamBuilder<List<ScanResult>>(
              //     //           stream: FlutterBlue
              //     //               .instance.scanResults,
              //     //           initialData: [],
              //     //           builder: (c, snapshot) {
              //     //             //  updateData(snapshot.data);
              //     //             FirebaseFirestore firestore;
              //     //             //  Database(firestore: firestore).addData(snapshot.data);
              //     //
              //     //             return ListView.builder(
              //     //               padding: EdgeInsets.zero,
              //     //               itemCount:snapshot.data!.length,
              //     //               shrinkWrap: true,
              //     //               itemBuilder: (BuildContext context, int index)
              //     //               {
              //     //                 return InkWell(onTap: (){
              //     //                 },
              //     //                   child: Stack(
              //     //                     children: [
              //     //                       Align(alignment: Alignment.centerLeft,child: Padding(
              //     //                         padding: const EdgeInsets.all(8.0),
              //     //                         child: Text(snapshot.data![index].device.name),
              //     //                       ),),
              //     //                       Align(alignment: Alignment.centerRight,child: Padding(
              //     //                         padding: const EdgeInsets.all(8.0),
              //     //                         child: Text("Use",style: TextStyle(color: Colors.red),),
              //     //                       ),),
              //     //                     ],
              //     //                   ),
              //     //                 );
              //     //               },
              //     //             );
              //     //
              //     //             // return Column(
              //     //             //   children: snapshot.data!
              //     //             //       .map(
              //     //             //         (r) => ScanResultTile(
              //     //             //       result: r,
              //     //             //       onTap: () {
              //     //             //         r.device
              //     //             //             .connect(
              //     //             //             autoConnect:
              //     //             //             false)
              //     //             //             .then(
              //     //             //                 (value) {
              //     //             //               //fetch index2 and index6
              //     //             //               initDeviceSlAndCalibDate(widget.device);
              //     //             //               setState(() {
              //     //             //                 widget.device =
              //     //             //                     r.device;
              //     //             //               });
              //     //             //               Navigator.pop(
              //     //             //                   context);
              //     //             //
              //     //             //
              //     //             //             });
              //     //             //         //return Scaffold(body: Text("Not using"),);
              //     //             //         //return Text("ok");
              //     //             //         //   return   PerformTestPage(device: r.device,project: widget.projectID,);
              //     //             //         // return PerformTestPageActivity(
              //     //             //         //     device:
              //     //             //         //         r.device,
              //     //             //         //     project: widget
              //     //             //         //         .projct);
              //     //             //         Navigator.pop(
              //     //             //             context);
              //     //             //         //return ConnectedDevicePage(device: r.device);
              //     //             //         //return DeviceScreenLessDetails(r.device);
              //     //             //       },
              //     //             //     ),
              //     //             //     //     (r) => ScanResultTile(
              //     //             //     //   result: r,
              //     //             //     //   onTap: () => Navigator.of(context)
              //     //             //     //       .push(MaterialPageRoute(builder: (context) {
              //     //             //     //     r.device.connect(autoConnect: false);
              //     //             //     //     //return Text("ok");
              //     //             //     //  //   return   PerformTestPage(device: r.device,project: widget.projectID,);
              //     //             //     //     return   PerformTestPage(device: r.device,project:"o",);
              //     //             //     //     Navigator.pop(context);
              //     //             //     //     //return ConnectedDevicePage(device: r.device);
              //     //             //     //     //return DeviceScreenLessDetails(r.device);
              //     //             //     //   })),
              //     //             //     // ),
              //     //             //   )
              //     //             //       .toList(),
              //     //             // );
              //     //           },
              //     //         )
              //     //       ],
              //     //     ));
              //     // return InkWell(onTap: (){
              //     //
              //     // },
              //     //   child: ListTile(
              //     //     onTap: () {
              //     //
              //     //     },
              //     //     title: Text("No Device is Connected"),
              //     //     trailing: Text(
              //     //       "Scan",
              //     //       style: TextStyle(),
              //     //     ),
              //     //   ),
              //     //);
              //     // return ListTile(
              //     //   onTap: () {
              //     //
              //     //   },
              //     //   title: Text("No Device is Connected"),
              //     //   trailing: Text(
              //     //     "Scan",
              //     //     style: TextStyle(),
              //     //   ),
              //     // );
              //   }
              //
              // });


    //    });

        }else{
          showModalBottomSheet(shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
          ),
              context: context,
              builder: (context) {
                print("bottom sheet open");
                return Container(
                  //height: height * 0.32,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(height * 0.02),
                          topRight: Radius.circular(height * 0.02)),
                      color: ThemeManager().getWhiteColor),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: ThemeManager().getLightGrey3Color,
                                    width: height * 0.0007)),
                          ),
                          padding: EdgeInsets.only(left: width * 0.06, right: width * 0.06),
                          height: height * 0.058,
                          width: double.infinity,
                          margin: EdgeInsets.only(top: height * 0.006),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Bluetooth is OFF",
                                style: interSemiBold.copyWith(
                                    fontSize: width * 0.035,
                                    color: ThemeManager().getBlackColor),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  TextConst.cancelText,
                                  style: interRegular.copyWith(
                                      color: ThemeManager().getRedColor),
                                ),
                              )
                            ],
                          ),
                        ),

                        // Container(
                        //   //height: height * 0.16,
                        //   child: scanResult,
                        // ),
                        Container(
                          margin: EdgeInsets.only(
                              top: height * 0.02, bottom: height * 0.025),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  padding: EdgeInsets.only(
                                      right: width * 0.038, bottom: height * 0.014),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/svg/scanningIcon.svg",
                                        height: height * 0.035,
                                      ),
                                      SizedBox(width: width * 0.03),
                                      Text(
                                        "Please turn ON bluetooth...",
                                        style: interSemiBold.copyWith(
                                            color: ThemeManager().getDarkGreenColor,
                                            fontSize: width * 0.038),
                                      )
                                    ],
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );

              });
        }
      });

        // FlutterBlue.instance.state.listen((event) {
        //   print("b");
        //
        // });



    });
    flutterBlue.startScan(timeout: Duration(seconds: 20));
    //Platform.isAndroid

    bool autoConnect = false;


    if(autoConnect) {
      SharedPreferences.getInstance().then((sharedPreff) {
        // tryCachScan();

        timer = Timer.periodic(Duration(seconds: 5), (Timer t) async {
          print("5 second done");
          // isBottomSheetOpen == false
          if (isBottomSheetOpen == false) {
            doWorkImportant(){
              flutterBlue.connectedDevices.then((value) {
                print("conencted device " + value.length.toString());
                if (value.length == 0) {
                  print("connected device " + value.length.toString());

                  //  tryCachScan();

                  doNext(List<ScanResult> scannedDevices){
                    {
                      print("scanned device " + scannedDevices.length.toString());
                      for (int i = 0; i < scannedDevices
                          .toList()
                          .length; i++) {
                        //value.containsKey(event.toList()[i].device.name
                        print("looking " + scannedDevices[i].device.name);

                        if (scannedDevices[i].device.name != null &&
                            scannedDevices[i].device.name.length > 0 &&
                            (scannedDevices[i].device.name.contains(
                                "Staht") | scannedDevices[i].device.name.contains(
                                "Default") | scannedDevices[i].device.name
                                .contains("Mukul"))) {
                          if (  sharedPreff.containsKey(scannedDevices[i].device.name)) {
                            if (ignoredList.contains(scannedDevices[i].device.name)== false) {
                              try {
                                //AutoConnectPopUp
                                if (isDialogShowing == false) {
                                  isDialogShowing = true ;

                                  showDialog<void>(
                                      context: context,
                                      builder: (context) {
                                        dialogContext = context;
                                        return AutoConnectPopUp(
                                          title: scannedDevices[i].device.name,
                                          conenctionCallback: (val) async {
                                            if (val == true ) {
                                            try{
                                              scannedDevices[i].device.connect(autoConnect: false).then((value) {

                                                CustomerHomePageLogic().connectedDevicesStream.dataReload(true);
                                              });
                                              await Future.delayed(Duration(seconds: 1));
                                              CustomerHomePageLogic().connectedDevicesStream.dataReload(true);

                                              sharedPreff.setString(scannedDevices[i].device.name, scannedDevices[i].device.name);
                                            }catch(e){
                                              await  scannedDevices[i].device.connect(autoConnect: false);
                                              await Future.delayed(Duration(seconds: 1));
                                              await  CustomerHomePageLogic().connectedDevicesStream.dataReload(true);

                                              await  sharedPreff.setString(scannedDevices[i].device.name, scannedDevices[i].device.name);
                                            }
                                            } else {
                                              ignoredList.add(scannedDevices[i].device.name);
                                            }
                                            isDialogShowing = false ;

                                          },);
                                      }).then((value) {
                                    isDialogShowing = false ;
                                  });
                                }
                                // else {
                                //   isDialogShowing = false ;
                                // }

                                break;
                              } catch (e) {
                                print(e);
                              }
                            } else {
                              print("device was in ignored list");
                            }
                          }
                        }
                        // tryCachScan();
                      }
                    }
                  }



                  flutterBlue.scanResults.first.then((scannedDevices) {

                    print("scanned device " + scannedDevices.length.toString());
                    if ( scannedDevices.length > 0) {
                      doNext(scannedDevices);
                    }else{
                      flutterBlue.scanResults.last.then((value) {
                        if(value.length>0){
                          doNext(value);
                        }else{
                          flutterBlue.scanResults.listen((event) {
                            doNext(event);
                          });
                        }
                      });



                    }
                  });



                }
              });
            }
            //FlutterBlue.instance.startScan(timeout: Duration(seconds: 2));

            flutterBlue.startScan(timeout: Duration(seconds: 2));
            doWorkImportant();

            // flutterBlue.startScan(timeout: Duration(seconds: 2)).then((value) {
            //
            //
            //   doWorkImportant();
            //   //first scan
            //
            //
            //
            //
            //
            // });
           // doWorkImportant();
            // await Future.delayed(Duration(seconds: 1));
            // tryCachScan();

          } else {
            print("Scan stopped because bottomsheet is open");
          }
        });
      });
    }

  }
  Future<bool> _usesAdditionalBlePermissions() async {
    if (Platform.isAndroid) {
      final packageInfo = await DeviceInfoPlugin().androidInfo;
      final sdk = packageInfo.version.sdkInt;
      return sdk >= 31;
    }

    return false;
  }
  Future<void> getPermissions() async {
    if(Platform.isAndroid){
      try{
        [Permission.bluetoothConnect,Permission.bluetoothScan,Permission.location,Permission.camera,Permission.microphone,Permission.storage,].request();
        setState(() {

        });
      }catch(e){
        setState(() {

        });

      }
    }else{
      try{
        [Permission.location,Permission.camera,Permission.microphone,Permission.storage,].request();
        setState(() {

        });
      }catch(e){
        setState(() {

        });

      }
    }

   //  const platform = MethodChannel('samples.flutter.dev/battery');
   //
   //
   //
   //  try {
   //    final int result = await platform.invokeMethod('getBatteryLevel');
   //  } on PlatformException catch (e) {
   //  }
   //
   //
   //  try {
   //    final int result = await platform.invokeMethod('getBatteryLevel2');
   //  } on PlatformException catch (e) {
   //  }
   //
   //
   //
   //  try {
   //    final int result = await platform.invokeMethod('getBatteryLevel');
   //    AppToast().show(message: result.toString());
   //  } on PlatformException catch (e) {
   //    AppToast().show(message: e.toString());
   //  }
   //
   //  if (await Permission.bluetoothScan.request().isGranted) {
   //    AppToast().show(message: "b scan granted");
   //
   //  }
   //  if (await Permission.bluetoothConnect.request().isGranted) {
   //    AppToast().show(message: "b COnnet granted");
   //  }
   //  if (await Permission.bluetooth.request().isGranted) {
   //    AppToast().show(message: "b blu granted");
   //
   //  }
   //  if (await Permission.bluetoothAdvertise.request().isGranted) {
   //    AppToast().show(message: "b adver granted");
   //
   //  }
   //  try{
   //    await [Permission.bluetoothScan,].request();
   //    await [Permission.bluetoothConnect,  ].request();
   //    await [ Permission.bluetooth, ].request();
   //    await [ Permission.bluetoothAdvertise,].request();
   //
   //    Map<Permission, PermissionStatus> statuses = await [Permission.bluetoothScan,Permission.bluetoothConnect,  Permission.bluetooth, Permission.bluetoothAdvertise,].request();
   //    print(statuses.toString());
   //  }catch(e){
   //    print("From Excep");
   //    print(e);
   //  }
   //
   //
   //
   // bool res = await _usesAdditionalBlePermissions();
   //  if(res){
   //    Map<Permission, PermissionStatus> statuses = await [
   //      Permission.bluetoothScan,
   //    ].request();
   //  }
   // if(res){
   //   Map<Permission, PermissionStatus> statuses = await [
   //     Permission.bluetoothConnect,
   //   ].request();
   // }



  }




}

