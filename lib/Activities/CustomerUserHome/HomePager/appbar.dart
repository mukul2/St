
import 'dart:async';
import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/DarkThemeManager.dart';
import 'package:connect/Toast/AppToast.dart';
import 'package:connect/pages/settigs_page.dart';
import 'package:connect/screens/home.dart';
import 'package:connect/screens/popup/AutoConnectPopUp.dart';
import 'package:connect/screens/settingScreen.dart';
import 'package:connect/utils/featureSettings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_svg/svg.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/textStyleConst.dart';
import 'package:connect/utils/themeManager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../logics.dart';

class AppbarView extends StatefulWidget {
   String appbarTitleText;
   AppbarView({Key ?key,required this.appbarTitleText}) : super(key: key);

  @override
  _AppbarViewState createState() => _AppbarViewState();






}

class _AppbarViewState extends State<AppbarView> {
  //Timer? timer;

  List<ScanResult> discovertedDevices = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(Platform.isAndroid){
      try{
        [Permission.bluetoothConnect,Permission.bluetoothScan].request();

      }catch(e){
        setState(() {

        });
      }
    }


  //  perm2();
    //startAutoScanning();
    // work();

  }

  Future<String> perm1() async {
    const platform = MethodChannel('samples.flutter.dev/battery');
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      return "ok";
    } on PlatformException catch (e) {
      return "failed";
    }
  }
  Future<String> perm2() async {
    const platform = MethodChannel('samples.flutter.dev/battery');
    try {
      final int result = await platform.invokeMethod('getBatteryLevel2');
      return "ok";
    } on PlatformException catch (e) {
      return "failed";
    }
  }
  @override
  Widget build(BuildContext context) {
    bool is12 = false;
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    //Permission.bluetoothConnect.status
    if(Platform.isAndroid){
      return  StreamBuilder<PermissionStatus>(
          stream: Permission.bluetoothScan.status.asStream(),
          builder: (context, snapshotpermissionScan) {
            if(snapshotpermissionScan.hasData){
              if(snapshotpermissionScan.data == PermissionStatus.granted){
                return   StreamBuilder<PermissionStatus>(
                    stream: Permission.bluetoothConnect.status.asStream(),
                    builder: (context, snapshotpermission) {
                      if(snapshotpermission.hasData){
                        if(snapshotpermission.data == PermissionStatus.granted){
                          //granted
                          return      Container( height:AppBar().preferredSize.height ,decoration: BoxDecoration(color:AppThemeManager().getAppbarColor(),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color:darkTheme?Colors.black: Colors.grey,
                                  blurRadius: 1.0,
                                  offset: Offset(0.0, 0.75)
                              )
                            ],
                          ),
                            child: Stack(
                              //crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Align(alignment: Alignment.centerLeft,child: StreamBuilder<List<BluetoothDevice>>(
                                  stream: Stream.periodic(Duration(seconds: 0)).asyncMap((_) => FlutterBlue.instance.connectedDevices),
                                  initialData: [],
                                  builder: (c, snapshot) {
                                    //return Icon(Icons.bluetooth);

                                    if(snapshot.hasData){
                                      return Container(
                                        padding: EdgeInsets.all(height*0.015),
                                        margin: EdgeInsets.only(left: width*0.03,right: width*0.25),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:  snapshot.data!.length>0? ThemeManager().getDarkBlueColor:Colors.grey,
                                        ),

                                        child: InkWell(onTap: (){










                                          try{
                                            Permission.bluetoothScan.status.then((value) {
                                              Permission.bluetoothConnect.status.then((value) {
                                                AppToast().show(message: value.toString());
                                                if(value.isGranted)CustomerHomePageLogic().scanDevicesNotifier.dataReload(true);

                                              });

                                            });
                                          }catch(e){
                                            setState(() {

                                            });
                                          }




                                        },
                                          child: SvgPicture.asset(
                                            ("assets/svg/bluetoothIcon.svg"),
                                            fit: BoxFit.cover,
                                            height: height*0.035,

                                          ),
                                        ),);
                                    }else{
                                      return Container(
                                        padding: EdgeInsets.all(height*0.015),
                                        margin: EdgeInsets.only(left: width*0.03,right: width*0.25),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:  Colors.grey,
                                        ),

                                        child: InkWell(onTap: (){


                                          try{
                                            Permission.bluetoothConnect.status.then((value) {

                                              AppToast().show(message: value.toString());
                                              if(value.isGranted)CustomerHomePageLogic().scanDevicesNotifier.dataReload(true);

                                            });
                                          }catch(e){
                                            setState(() {

                                            });
                                          }



                                        },
                                          child: SvgPicture.asset(
                                            ("assets/svg/bluetoothIcon.svg"),
                                            fit: BoxFit.cover,
                                            height: height*0.035,

                                          ),
                                        ),);
                                    }



                                  },

                                  // child: SvgPicture.asset(
                                  //   ("assets/svg/bluetoothIcon.svg"),
                                  //   fit: BoxFit.cover,
                                  //   height: height*0.035,
                                  //   color: Colors.blue,
                                  // ),
                                ),),
                                Align(alignment: Alignment.center,child: Text(
                                  widget.appbarTitleText.length>25? widget.appbarTitleText.substring(0,24):widget.appbarTitleText,maxLines: 1,
                                  style: interRegular.copyWith(
                                      color: AppThemeManager().getAppbarTextColor() ,
                                      fontWeight: FontWeight.w800,
                                      fontSize: width * 0.052),
                                ),),

                                Align(alignment: Alignment.centerRight,child: InkWell(onTap: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>SettingScreen()));
                                },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      // top: height*0.025,
                                        right: width*0.058),
                                    child: SvgPicture.asset(
                                      ("assets/svg/settingIcon.svg"),
                                      fit: BoxFit.cover,color:AppThemeManager().getAppbarIconColor() ,
                                    ),
                                  ),
                                ),),




                                // Container(
                                //  margin: EdgeInsets.only(top: height*0.025,right: width*0.05),
                                //   child: SvgPicture.asset(
                                //     ("assets/svg/notificationIcon.svg"),
                                //     fit: BoxFit.cover,
                                //   ),
                                // ),
                              ],
                            ),
                            // child: Wrap(
                            //   children: [
                            //     Container(height:AppBar().preferredSize.height ,
                            //       child: Stack(
                            //         //crossAxisAlignment: CrossAxisAlignment.center,
                            //         children: [
                            //           Align(alignment: Alignment.centerLeft,child: StreamBuilder<List<BluetoothDevice>>(
                            //             stream: Stream.periodic(Duration(seconds: 0)).asyncMap((_) => FlutterBlue.instance.connectedDevices),
                            //             initialData: [],
                            //             builder: (c, snapshot) {
                            //
                            //
                            //               return Container(
                            //                 padding: EdgeInsets.all(height*0.015),
                            //                 margin: EdgeInsets.only(left: width*0.03,right: width*0.25),
                            //                 decoration: BoxDecoration(
                            //                   shape: BoxShape.circle,
                            //                   color:  snapshot.data!.length>0? ThemeManager().getDarkBlueColor:Colors.grey,
                            //                 ),
                            //
                            //                 child: InkWell(onTap: (){
                            //                   CustomerHomePageLogic().scanDevicesNotifier.dataReload(true);
                            //                 },
                            //                   child: SvgPicture.asset(
                            //                     ("assets/svg/bluetoothIcon.svg"),
                            //                     fit: BoxFit.cover,
                            //                     height: height*0.035,
                            //
                            //                   ),
                            //                 ),);
                            //             },
                            //
                            //             // child: SvgPicture.asset(
                            //             //   ("assets/svg/bluetoothIcon.svg"),
                            //             //   fit: BoxFit.cover,
                            //             //   height: height*0.035,
                            //             //   color: Colors.blue,
                            //             // ),
                            //           ),),
                            //           Align(alignment: Alignment.center,child: Text(
                            //             widget.appbarTitleText.length>25? widget.appbarTitleText.substring(0,24):widget.appbarTitleText,maxLines: 1,
                            //             style: interRegular.copyWith(
                            //                 color: ThemeManager().getBlackColor,
                            //                 fontWeight: FontWeight.w800,
                            //                 fontSize: width * 0.052),
                            //           ),),
                            //
                            //           Align(alignment: Alignment.centerRight,child: InkWell(onTap: (){
                            //             Navigator.push(
                            //                 context,
                            //                 MaterialPageRoute(
                            //                     builder: (context) =>SettingScreen()));
                            //           },
                            //             child: Container(
                            //               margin: EdgeInsets.only(
                            //                 // top: height*0.025,
                            //                   right: width*0.058),
                            //               child: SvgPicture.asset(
                            //                 ("assets/svg/settingIcon.svg"),
                            //                 fit: BoxFit.cover,
                            //               ),
                            //             ),
                            //           ),),
                            //
                            //
                            //
                            //
                            //           // Container(
                            //           //  margin: EdgeInsets.only(top: height*0.025,right: width*0.05),
                            //           //   child: SvgPicture.asset(
                            //           //     ("assets/svg/notificationIcon.svg"),
                            //           //     fit: BoxFit.cover,
                            //           //   ),
                            //           // ),
                            //         ],
                            //       ),
                            //     ),
                            //     Container(
                            //       margin: EdgeInsets.only(top: height*0.008),
                            //       height: height*0.001,
                            //       width: double.infinity,
                            //       color: ThemeManager().getBlackColor.withOpacity(.15),
                            //     )
                            //   ],
                            // ),
                          );
                        }else{
                          return      Container(height:AppBar().preferredSize.height ,decoration: BoxDecoration(color:AppThemeManager().getAppbarColor(),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color:darkTheme?Colors.black: Colors.grey,
                                  blurRadius: 1.0,
                                  offset: Offset(0.0, 0.75)
                              )
                            ],
                          ),
                            child: Stack(
                              //crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Align(alignment: Alignment.centerLeft,child: Container(
                                  padding: EdgeInsets.all(height*0.015),
                                  margin: EdgeInsets.only(left: width*0.03,right: width*0.25),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ThemeManager().getDarkGreyColor,
                                  ),

                                  child: InkWell(onTap: () async {
                                    setState(() {

                                    });
                                    CustomerHomePageLogic().scanDevicesNotifier.dataReload(true);
                                    setState(() {

                                    });

                                  },
                                    child: SvgPicture.asset(
                                      ("assets/svg/bluetoothIcon.svg"),
                                      fit: BoxFit.cover,
                                      height: height*0.035,

                                    ),
                                  ),),),
                                Align(alignment: Alignment.center,child: Text(
                                  widget.appbarTitleText.length>25? widget.appbarTitleText.substring(0,24):widget.appbarTitleText,maxLines: 1,
                                  style: interRegular.copyWith(
                                      color: AppThemeManager().getAppbarTextColor() ,
                                      fontWeight: FontWeight.w800,
                                      fontSize: width * 0.052),
                                ),),

                                Align(alignment: Alignment.centerRight,child: InkWell(onTap: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>SettingScreen()));
                                },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      // top: height*0.025,
                                        right: width*0.058),
                                    child: SvgPicture.asset(
                                      ("assets/svg/settingIcon.svg"),
                                      fit: BoxFit.cover,color:AppThemeManager().getAppbarIconColor() ,
                                    ),
                                  ),
                                ),),




                                // Container(
                                //  margin: EdgeInsets.only(top: height*0.025,right: width*0.05),
                                //   child: SvgPicture.asset(
                                //     ("assets/svg/notificationIcon.svg"),
                                //     fit: BoxFit.cover,
                                //   ),
                                // ),
                              ],
                            ),
                            // child: Wrap(
                            //   children: [
                            //     Container(height:AppBar().preferredSize.height ,
                            //       child: Stack(
                            //         //crossAxisAlignment: CrossAxisAlignment.center,
                            //         children: [
                            //           Align(alignment: Alignment.centerLeft,child: StreamBuilder<List<BluetoothDevice>>(
                            //             stream: Stream.periodic(Duration(seconds: 0)).asyncMap((_) => FlutterBlue.instance.connectedDevices),
                            //             initialData: [],
                            //             builder: (c, snapshot) {
                            //
                            //
                            //               return Container(
                            //                 padding: EdgeInsets.all(height*0.015),
                            //                 margin: EdgeInsets.only(left: width*0.03,right: width*0.25),
                            //                 decoration: BoxDecoration(
                            //                   shape: BoxShape.circle,
                            //                   color:  snapshot.data!.length>0? ThemeManager().getDarkBlueColor:Colors.grey,
                            //                 ),
                            //
                            //                 child: InkWell(onTap: (){
                            //                   CustomerHomePageLogic().scanDevicesNotifier.dataReload(true);
                            //                 },
                            //                   child: SvgPicture.asset(
                            //                     ("assets/svg/bluetoothIcon.svg"),
                            //                     fit: BoxFit.cover,
                            //                     height: height*0.035,
                            //
                            //                   ),
                            //                 ),);
                            //             },
                            //
                            //             // child: SvgPicture.asset(
                            //             //   ("assets/svg/bluetoothIcon.svg"),
                            //             //   fit: BoxFit.cover,
                            //             //   height: height*0.035,
                            //             //   color: Colors.blue,
                            //             // ),
                            //           ),),
                            //           Align(alignment: Alignment.center,child: Text(
                            //             widget.appbarTitleText.length>25? widget.appbarTitleText.substring(0,24):widget.appbarTitleText,maxLines: 1,
                            //             style: interRegular.copyWith(
                            //                 color: ThemeManager().getBlackColor,
                            //                 fontWeight: FontWeight.w800,
                            //                 fontSize: width * 0.052),
                            //           ),),
                            //
                            //           Align(alignment: Alignment.centerRight,child: InkWell(onTap: (){
                            //             Navigator.push(
                            //                 context,
                            //                 MaterialPageRoute(
                            //                     builder: (context) =>SettingScreen()));
                            //           },
                            //             child: Container(
                            //               margin: EdgeInsets.only(
                            //                 // top: height*0.025,
                            //                   right: width*0.058),
                            //               child: SvgPicture.asset(
                            //                 ("assets/svg/settingIcon.svg"),
                            //                 fit: BoxFit.cover,
                            //               ),
                            //             ),
                            //           ),),
                            //
                            //
                            //
                            //
                            //           // Container(
                            //           //  margin: EdgeInsets.only(top: height*0.025,right: width*0.05),
                            //           //   child: SvgPicture.asset(
                            //           //     ("assets/svg/notificationIcon.svg"),
                            //           //     fit: BoxFit.cover,
                            //           //   ),
                            //           // ),
                            //         ],
                            //       ),
                            //     ),
                            //     Container(
                            //       margin: EdgeInsets.only(top: height*0.008),
                            //       height: height*0.001,
                            //       width: double.infinity,
                            //       color: ThemeManager().getBlackColor.withOpacity(.15),
                            //     )
                            //   ],
                            // ),
                          );

                        }
                      }
                      else{
                        return Container(width: 0,height: 0,);
                      }

                    });
              }else{
                return      Container(height:AppBar().preferredSize.height ,decoration: BoxDecoration(color:AppThemeManager().getAppbarColor(),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color:darkTheme?Colors.black: Colors.grey,
                        blurRadius: 1.0,
                        offset: Offset(0.0, 0.75)
                    )
                  ],
                ),
                  child: Stack(
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(alignment: Alignment.centerLeft,child: Container(
                        padding: EdgeInsets.all(height*0.015),
                        margin: EdgeInsets.only(left: width*0.03,right: width*0.25),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ThemeManager().getDarkGreyColor,
                        ),

                        child: InkWell(onTap: () async {

                          try{
                            CustomerHomePageLogic().scanDevicesNotifier.dataReload(true);
                            setState(() {

                            });
                          }catch(e){
                            setState(() {

                            });
                          }


                          // Map<Permission, PermissionStatus> statuses = await  [
                          // Permission.camera,Permission.bluetooth, Permission.bluetoothConnect,Permission.location,
                          // Permission.bluetoothAdvertise,Permission.bluetoothScan,
                          // ].request();

                        },
                          child: SvgPicture.asset(
                            ("assets/svg/bluetoothIcon.svg"),
                            fit: BoxFit.cover,
                            height: height*0.035,

                          ),
                        ),),),
                      Align(alignment: Alignment.center,child: Text(
                        widget.appbarTitleText.length>25? widget.appbarTitleText.substring(0,24):widget.appbarTitleText,maxLines: 1,
                        style: interRegular.copyWith(
                            color: AppThemeManager().getAppbarTextColor() ,
                            fontWeight: FontWeight.w800,
                            fontSize: width * 0.052),
                      ),),

                      Align(alignment: Alignment.centerRight,child: InkWell(onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>SettingScreen()));
                      },
                        child: Container(
                          margin: EdgeInsets.only(
                            // top: height*0.025,
                              right: width*0.058),
                          child: SvgPicture.asset(
                            ("assets/svg/settingIcon.svg"),
                            fit: BoxFit.cover,color:AppThemeManager().getAppbarIconColor() ,
                          ),
                        ),
                      ),),




                      // Container(
                      //  margin: EdgeInsets.only(top: height*0.025,right: width*0.05),
                      //   child: SvgPicture.asset(
                      //     ("assets/svg/notificationIcon.svg"),
                      //     fit: BoxFit.cover,
                      //   ),
                      // ),
                    ],
                  ),
                  // child: Wrap(
                  //   children: [
                  //     Container(height:AppBar().preferredSize.height ,
                  //       child: Stack(
                  //         //crossAxisAlignment: CrossAxisAlignment.center,
                  //         children: [
                  //           Align(alignment: Alignment.centerLeft,child: StreamBuilder<List<BluetoothDevice>>(
                  //             stream: Stream.periodic(Duration(seconds: 0)).asyncMap((_) => FlutterBlue.instance.connectedDevices),
                  //             initialData: [],
                  //             builder: (c, snapshot) {
                  //
                  //
                  //               return Container(
                  //                 padding: EdgeInsets.all(height*0.015),
                  //                 margin: EdgeInsets.only(left: width*0.03,right: width*0.25),
                  //                 decoration: BoxDecoration(
                  //                   shape: BoxShape.circle,
                  //                   color:  snapshot.data!.length>0? ThemeManager().getDarkBlueColor:Colors.grey,
                  //                 ),
                  //
                  //                 child: InkWell(onTap: (){
                  //                   CustomerHomePageLogic().scanDevicesNotifier.dataReload(true);
                  //                 },
                  //                   child: SvgPicture.asset(
                  //                     ("assets/svg/bluetoothIcon.svg"),
                  //                     fit: BoxFit.cover,
                  //                     height: height*0.035,
                  //
                  //                   ),
                  //                 ),);
                  //             },
                  //
                  //             // child: SvgPicture.asset(
                  //             //   ("assets/svg/bluetoothIcon.svg"),
                  //             //   fit: BoxFit.cover,
                  //             //   height: height*0.035,
                  //             //   color: Colors.blue,
                  //             // ),
                  //           ),),
                  //           Align(alignment: Alignment.center,child: Text(
                  //             widget.appbarTitleText.length>25? widget.appbarTitleText.substring(0,24):widget.appbarTitleText,maxLines: 1,
                  //             style: interRegular.copyWith(
                  //                 color: ThemeManager().getBlackColor,
                  //                 fontWeight: FontWeight.w800,
                  //                 fontSize: width * 0.052),
                  //           ),),
                  //
                  //           Align(alignment: Alignment.centerRight,child: InkWell(onTap: (){
                  //             Navigator.push(
                  //                 context,
                  //                 MaterialPageRoute(
                  //                     builder: (context) =>SettingScreen()));
                  //           },
                  //             child: Container(
                  //               margin: EdgeInsets.only(
                  //                 // top: height*0.025,
                  //                   right: width*0.058),
                  //               child: SvgPicture.asset(
                  //                 ("assets/svg/settingIcon.svg"),
                  //                 fit: BoxFit.cover,
                  //               ),
                  //             ),
                  //           ),),
                  //
                  //
                  //
                  //
                  //           // Container(
                  //           //  margin: EdgeInsets.only(top: height*0.025,right: width*0.05),
                  //           //   child: SvgPicture.asset(
                  //           //     ("assets/svg/notificationIcon.svg"),
                  //           //     fit: BoxFit.cover,
                  //           //   ),
                  //           // ),
                  //         ],
                  //       ),
                  //     ),
                  //     Container(
                  //       margin: EdgeInsets.only(top: height*0.008),
                  //       height: height*0.001,
                  //       width: double.infinity,
                  //       color: ThemeManager().getBlackColor.withOpacity(.15),
                  //     )
                  //   ],
                  // ),
                );
              }

            }else{
              return Container(width: 0,height: 0,);
            }
          });
    }else{
      return      Container(height:AppBar().preferredSize.height ,decoration: BoxDecoration(color:AppThemeManager().getAppbarColor(),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color:darkTheme?Colors.black: Colors.grey,
              blurRadius: 1.0,
              offset: Offset(0.0, 0.75)
          )
        ],
      ),
        child: Stack(
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(alignment: Alignment.centerLeft,child: StreamBuilder<List<BluetoothDevice>>(
              stream: Stream.periodic(Duration(seconds: 0)).asyncMap((_) => FlutterBlue.instance.connectedDevices),
              initialData: [],
              builder: (c, snapshot) {
                //return Icon(Icons.bluetooth);

                if(snapshot.hasData && snapshot.data!.length>0){
                  return Container(
                    padding: EdgeInsets.all(height*0.015),
                    margin: EdgeInsets.only(left: width*0.03,right: width*0.25),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:  snapshot.data!.length>0? ThemeManager().getDarkBlueColor:Colors.grey,
                    ),

                    child: InkWell(onTap: (){
                      CustomerHomePageLogic().scanDevicesNotifier.dataReload(true);
                      },
                      child: SvgPicture.asset(
                        ("assets/svg/bluetoothIcon.svg"),
                        fit: BoxFit.cover,
                        height: height*0.035,

                      ),
                    ),);
                }else{
                  return Container(
                    padding: EdgeInsets.all(height*0.015),
                    margin: EdgeInsets.only(left: width*0.03,right: width*0.25),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:  Colors.grey,
                    ),

                    child: InkWell(onTap: (){


                      CustomerHomePageLogic().scanDevicesNotifier.dataReload(true);



                    },
                      child: SvgPicture.asset(
                        ("assets/svg/bluetoothIcon.svg"),
                        fit: BoxFit.cover,
                        height: height*0.035,

                      ),
                    ),);
                }



              },

              // child: SvgPicture.asset(
              //   ("assets/svg/bluetoothIcon.svg"),
              //   fit: BoxFit.cover,
              //   height: height*0.035,
              //   color: Colors.blue,
              // ),
            ),),
            Align(alignment: Alignment.center,child: Text(
              widget.appbarTitleText.length>25? widget.appbarTitleText.substring(0,24):widget.appbarTitleText,maxLines: 1,
              style: interRegular.copyWith(
                  color: AppThemeManager().getAppbarTextColor() ,
                  fontWeight: FontWeight.w800,
                  fontSize: width * 0.052),
            ),),

            Align(alignment: Alignment.centerRight,child: InkWell(onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>SettingScreen()));
            },
              child: Container(
                margin: EdgeInsets.only(
                  // top: height*0.025,
                    right: width*0.058),
                child: SvgPicture.asset(
                  ("assets/svg/settingIcon.svg"),
                  fit: BoxFit.cover,color:AppThemeManager().getAppbarIconColor() ,

                ),
              ),
            ),),




            // Container(
            //  margin: EdgeInsets.only(top: height*0.025,right: width*0.05),
            //   child: SvgPicture.asset(
            //     ("assets/svg/notificationIcon.svg"),
            //     fit: BoxFit.cover,
            //   ),
            // ),
          ],
        ),
        // child: Wrap(
        //   children: [
        //     Container(height:AppBar().preferredSize.height ,
        //       child: Stack(
        //         //crossAxisAlignment: CrossAxisAlignment.center,
        //         children: [
        //           Align(alignment: Alignment.centerLeft,child: StreamBuilder<List<BluetoothDevice>>(
        //             stream: Stream.periodic(Duration(seconds: 0)).asyncMap((_) => FlutterBlue.instance.connectedDevices),
        //             initialData: [],
        //             builder: (c, snapshot) {
        //
        //
        //               return Container(
        //                 padding: EdgeInsets.all(height*0.015),
        //                 margin: EdgeInsets.only(left: width*0.03,right: width*0.25),
        //                 decoration: BoxDecoration(
        //                   shape: BoxShape.circle,
        //                   color:  snapshot.data!.length>0? ThemeManager().getDarkBlueColor:Colors.grey,
        //                 ),
        //
        //                 child: InkWell(onTap: (){
        //                   CustomerHomePageLogic().scanDevicesNotifier.dataReload(true);
        //                 },
        //                   child: SvgPicture.asset(
        //                     ("assets/svg/bluetoothIcon.svg"),
        //                     fit: BoxFit.cover,
        //                     height: height*0.035,
        //
        //                   ),
        //                 ),);
        //             },
        //
        //             // child: SvgPicture.asset(
        //             //   ("assets/svg/bluetoothIcon.svg"),
        //             //   fit: BoxFit.cover,
        //             //   height: height*0.035,
        //             //   color: Colors.blue,
        //             // ),
        //           ),),
        //           Align(alignment: Alignment.center,child: Text(
        //             widget.appbarTitleText.length>25? widget.appbarTitleText.substring(0,24):widget.appbarTitleText,maxLines: 1,
        //             style: interRegular.copyWith(
        //                 color: ThemeManager().getBlackColor,
        //                 fontWeight: FontWeight.w800,
        //                 fontSize: width * 0.052),
        //           ),),
        //
        //           Align(alignment: Alignment.centerRight,child: InkWell(onTap: (){
        //             Navigator.push(
        //                 context,
        //                 MaterialPageRoute(
        //                     builder: (context) =>SettingScreen()));
        //           },
        //             child: Container(
        //               margin: EdgeInsets.only(
        //                 // top: height*0.025,
        //                   right: width*0.058),
        //               child: SvgPicture.asset(
        //                 ("assets/svg/settingIcon.svg"),
        //                 fit: BoxFit.cover,
        //               ),
        //             ),
        //           ),),
        //
        //
        //
        //
        //           // Container(
        //           //  margin: EdgeInsets.only(top: height*0.025,right: width*0.05),
        //           //   child: SvgPicture.asset(
        //           //     ("assets/svg/notificationIcon.svg"),
        //           //     fit: BoxFit.cover,
        //           //   ),
        //           // ),
        //         ],
        //       ),
        //     ),
        //     Container(
        //       margin: EdgeInsets.only(top: height*0.008),
        //       height: height*0.001,
        //       width: double.infinity,
        //       color: ThemeManager().getBlackColor.withOpacity(.15),
        //     )
        //   ],
        // ),
      );
      return      Container(height:AppBar().preferredSize.height ,decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey,
              blurRadius: 1.0,
              offset: Offset(0.0, 0.75)
          )
        ],
        color: Theme.of(context).bottomAppBarColor,
      ),
        child: Stack(
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(alignment: Alignment.centerLeft,child: Container(
              padding: EdgeInsets.all(height*0.015),
              margin: EdgeInsets.only(left: width*0.03,right: width*0.25),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ThemeManager().getDarkGreyColor,
              ),

              child: InkWell(onTap: () async {

                CustomerHomePageLogic().scanDevicesNotifier.dataReload(true);


                // Map<Permission, PermissionStatus> statuses = await  [
                // Permission.camera,Permission.bluetooth, Permission.bluetoothConnect,Permission.location,
                // Permission.bluetoothAdvertise,Permission.bluetoothScan,
                // ].request();

              },
                child: SvgPicture.asset(
                  ("assets/svg/bluetoothIcon.svg"),
                  fit: BoxFit.cover,
                  height: height*0.035,

                ),
              ),),),
            Align(alignment: Alignment.center,child: Text(
              widget.appbarTitleText.length>25? widget.appbarTitleText.substring(0,24):widget.appbarTitleText,maxLines: 1,
              style: interRegular.copyWith(
                  color: ThemeManager().getBlackColor,
                  fontWeight: FontWeight.w800,
                  fontSize: width * 0.052),
            ),),

            Align(alignment: Alignment.centerRight,child: InkWell(onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>SettingScreen()));
            },
              child: Container(
                margin: EdgeInsets.only(
                  // top: height*0.025,
                    right: width*0.058),
                child: SvgPicture.asset(
                  ("assets/svg/settingIcon.svg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),),




            // Container(
            //  margin: EdgeInsets.only(top: height*0.025,right: width*0.05),
            //   child: SvgPicture.asset(
            //     ("assets/svg/notificationIcon.svg"),
            //     fit: BoxFit.cover,
            //   ),
            // ),
          ],
        ),
        // child: Wrap(
        //   children: [
        //     Container(height:AppBar().preferredSize.height ,
        //       child: Stack(
        //         //crossAxisAlignment: CrossAxisAlignment.center,
        //         children: [
        //           Align(alignment: Alignment.centerLeft,child: StreamBuilder<List<BluetoothDevice>>(
        //             stream: Stream.periodic(Duration(seconds: 0)).asyncMap((_) => FlutterBlue.instance.connectedDevices),
        //             initialData: [],
        //             builder: (c, snapshot) {
        //
        //
        //               return Container(
        //                 padding: EdgeInsets.all(height*0.015),
        //                 margin: EdgeInsets.only(left: width*0.03,right: width*0.25),
        //                 decoration: BoxDecoration(
        //                   shape: BoxShape.circle,
        //                   color:  snapshot.data!.length>0? ThemeManager().getDarkBlueColor:Colors.grey,
        //                 ),
        //
        //                 child: InkWell(onTap: (){
        //                   CustomerHomePageLogic().scanDevicesNotifier.dataReload(true);
        //                 },
        //                   child: SvgPicture.asset(
        //                     ("assets/svg/bluetoothIcon.svg"),
        //                     fit: BoxFit.cover,
        //                     height: height*0.035,
        //
        //                   ),
        //                 ),);
        //             },
        //
        //             // child: SvgPicture.asset(
        //             //   ("assets/svg/bluetoothIcon.svg"),
        //             //   fit: BoxFit.cover,
        //             //   height: height*0.035,
        //             //   color: Colors.blue,
        //             // ),
        //           ),),
        //           Align(alignment: Alignment.center,child: Text(
        //             widget.appbarTitleText.length>25? widget.appbarTitleText.substring(0,24):widget.appbarTitleText,maxLines: 1,
        //             style: interRegular.copyWith(
        //                 color: ThemeManager().getBlackColor,
        //                 fontWeight: FontWeight.w800,
        //                 fontSize: width * 0.052),
        //           ),),
        //
        //           Align(alignment: Alignment.centerRight,child: InkWell(onTap: (){
        //             Navigator.push(
        //                 context,
        //                 MaterialPageRoute(
        //                     builder: (context) =>SettingScreen()));
        //           },
        //             child: Container(
        //               margin: EdgeInsets.only(
        //                 // top: height*0.025,
        //                   right: width*0.058),
        //               child: SvgPicture.asset(
        //                 ("assets/svg/settingIcon.svg"),
        //                 fit: BoxFit.cover,
        //               ),
        //             ),
        //           ),),
        //
        //
        //
        //
        //           // Container(
        //           //  margin: EdgeInsets.only(top: height*0.025,right: width*0.05),
        //           //   child: SvgPicture.asset(
        //           //     ("assets/svg/notificationIcon.svg"),
        //           //     fit: BoxFit.cover,
        //           //   ),
        //           // ),
        //         ],
        //       ),
        //     ),
        //     Container(
        //       margin: EdgeInsets.only(top: height*0.008),
        //       height: height*0.001,
        //       width: double.infinity,
        //       color: ThemeManager().getBlackColor.withOpacity(.15),
        //     )
        //   ],
        // ),
      );
    }











   // return FutureBuilder(
   //      future: perm1(),
   //      builder: (BuildContext context, AsyncSnapshot snapshot) {
   //        if(snapshot.connectionState == ConnectionState.done){
   //         return FutureBuilder(
   //              future: perm2(),
   //              builder: (BuildContext context, AsyncSnapshot snapshot) {
   //                if(snapshot.connectionState == ConnectionState.done){
   //                  return      Container(height:AppBar().preferredSize.height ,decoration: BoxDecoration(
   //                    boxShadow: <BoxShadow>[
   //                      BoxShadow(
   //                          color: Colors.grey,
   //                          blurRadius: 1.0,
   //                          offset: Offset(0.0, 0.75)
   //                      )
   //                    ],
   //                    color: Theme.of(context).bottomAppBarColor,
   //                  ),
   //                    child: Stack(
   //                      //crossAxisAlignment: CrossAxisAlignment.center,
   //                      children: [
   //                        Align(alignment: Alignment.centerLeft,child: StreamBuilder<List<BluetoothDevice>>(
   //                          stream: Stream.periodic(Duration(seconds: 0)).asyncMap((_) => FlutterBlue.instance.connectedDevices),
   //                          initialData: [],
   //                          builder: (c, snapshot) {
   //                            //return Icon(Icons.bluetooth);
   //
   //                            if(snapshot.hasData){
   //                              return Container(
   //                                padding: EdgeInsets.all(height*0.015),
   //                                margin: EdgeInsets.only(left: width*0.03,right: width*0.25),
   //                                decoration: BoxDecoration(
   //                                  shape: BoxShape.circle,
   //                                  color:  snapshot.data!.length>0? ThemeManager().getDarkBlueColor:Colors.grey,
   //                                ),
   //
   //                                child: InkWell(onTap: (){
   //                                  CustomerHomePageLogic().scanDevicesNotifier.dataReload(true);
   //                                },
   //                                  child: SvgPicture.asset(
   //                                    ("assets/svg/bluetoothIcon.svg"),
   //                                    fit: BoxFit.cover,
   //                                    height: height*0.035,
   //
   //                                  ),
   //                                ),);
   //                            }else{
   //                              return Container(
   //                                padding: EdgeInsets.all(height*0.015),
   //                                margin: EdgeInsets.only(left: width*0.03,right: width*0.25),
   //                                decoration: BoxDecoration(
   //                                  shape: BoxShape.circle,
   //                                  color:  Colors.grey,
   //                                ),
   //
   //                                child: InkWell(onTap: (){
   //                                  CustomerHomePageLogic().scanDevicesNotifier.dataReload(true);
   //                                },
   //                                  child: SvgPicture.asset(
   //                                    ("assets/svg/bluetoothIcon.svg"),
   //                                    fit: BoxFit.cover,
   //                                    height: height*0.035,
   //
   //                                  ),
   //                                ),);
   //                            }
   //
   //
   //
   //                          },
   //
   //                          // child: SvgPicture.asset(
   //                          //   ("assets/svg/bluetoothIcon.svg"),
   //                          //   fit: BoxFit.cover,
   //                          //   height: height*0.035,
   //                          //   color: Colors.blue,
   //                          // ),
   //                        ),),
   //                        Align(alignment: Alignment.center,child: Text(
   //                          widget.appbarTitleText.length>25? widget.appbarTitleText.substring(0,24):widget.appbarTitleText,maxLines: 1,
   //                          style: interRegular.copyWith(
   //                              color: ThemeManager().getBlackColor,
   //                              fontWeight: FontWeight.w800,
   //                              fontSize: width * 0.052),
   //                        ),),
   //
   //                        Align(alignment: Alignment.centerRight,child: InkWell(onTap: (){
   //                          Navigator.push(
   //                              context,
   //                              MaterialPageRoute(
   //                                  builder: (context) =>SettingScreen()));
   //                        },
   //                          child: Container(
   //                            margin: EdgeInsets.only(
   //                              // top: height*0.025,
   //                                right: width*0.058),
   //                            child: SvgPicture.asset(
   //                              ("assets/svg/settingIcon.svg"),
   //                              fit: BoxFit.cover,
   //                            ),
   //                          ),
   //                        ),),
   //
   //
   //
   //
   //                        // Container(
   //                        //  margin: EdgeInsets.only(top: height*0.025,right: width*0.05),
   //                        //   child: SvgPicture.asset(
   //                        //     ("assets/svg/notificationIcon.svg"),
   //                        //     fit: BoxFit.cover,
   //                        //   ),
   //                        // ),
   //                      ],
   //                    ),
   //                    // child: Wrap(
   //                    //   children: [
   //                    //     Container(height:AppBar().preferredSize.height ,
   //                    //       child: Stack(
   //                    //         //crossAxisAlignment: CrossAxisAlignment.center,
   //                    //         children: [
   //                    //           Align(alignment: Alignment.centerLeft,child: StreamBuilder<List<BluetoothDevice>>(
   //                    //             stream: Stream.periodic(Duration(seconds: 0)).asyncMap((_) => FlutterBlue.instance.connectedDevices),
   //                    //             initialData: [],
   //                    //             builder: (c, snapshot) {
   //                    //
   //                    //
   //                    //               return Container(
   //                    //                 padding: EdgeInsets.all(height*0.015),
   //                    //                 margin: EdgeInsets.only(left: width*0.03,right: width*0.25),
   //                    //                 decoration: BoxDecoration(
   //                    //                   shape: BoxShape.circle,
   //                    //                   color:  snapshot.data!.length>0? ThemeManager().getDarkBlueColor:Colors.grey,
   //                    //                 ),
   //                    //
   //                    //                 child: InkWell(onTap: (){
   //                    //                   CustomerHomePageLogic().scanDevicesNotifier.dataReload(true);
   //                    //                 },
   //                    //                   child: SvgPicture.asset(
   //                    //                     ("assets/svg/bluetoothIcon.svg"),
   //                    //                     fit: BoxFit.cover,
   //                    //                     height: height*0.035,
   //                    //
   //                    //                   ),
   //                    //                 ),);
   //                    //             },
   //                    //
   //                    //             // child: SvgPicture.asset(
   //                    //             //   ("assets/svg/bluetoothIcon.svg"),
   //                    //             //   fit: BoxFit.cover,
   //                    //             //   height: height*0.035,
   //                    //             //   color: Colors.blue,
   //                    //             // ),
   //                    //           ),),
   //                    //           Align(alignment: Alignment.center,child: Text(
   //                    //             widget.appbarTitleText.length>25? widget.appbarTitleText.substring(0,24):widget.appbarTitleText,maxLines: 1,
   //                    //             style: interRegular.copyWith(
   //                    //                 color: ThemeManager().getBlackColor,
   //                    //                 fontWeight: FontWeight.w800,
   //                    //                 fontSize: width * 0.052),
   //                    //           ),),
   //                    //
   //                    //           Align(alignment: Alignment.centerRight,child: InkWell(onTap: (){
   //                    //             Navigator.push(
   //                    //                 context,
   //                    //                 MaterialPageRoute(
   //                    //                     builder: (context) =>SettingScreen()));
   //                    //           },
   //                    //             child: Container(
   //                    //               margin: EdgeInsets.only(
   //                    //                 // top: height*0.025,
   //                    //                   right: width*0.058),
   //                    //               child: SvgPicture.asset(
   //                    //                 ("assets/svg/settingIcon.svg"),
   //                    //                 fit: BoxFit.cover,
   //                    //               ),
   //                    //             ),
   //                    //           ),),
   //                    //
   //                    //
   //                    //
   //                    //
   //                    //           // Container(
   //                    //           //  margin: EdgeInsets.only(top: height*0.025,right: width*0.05),
   //                    //           //   child: SvgPicture.asset(
   //                    //           //     ("assets/svg/notificationIcon.svg"),
   //                    //           //     fit: BoxFit.cover,
   //                    //           //   ),
   //                    //           // ),
   //                    //         ],
   //                    //       ),
   //                    //     ),
   //                    //     Container(
   //                    //       margin: EdgeInsets.only(top: height*0.008),
   //                    //       height: height*0.001,
   //                    //       width: double.infinity,
   //                    //       color: ThemeManager().getBlackColor.withOpacity(.15),
   //                    //     )
   //                    //   ],
   //                    // ),
   //                  );
   //
   //                }else{
   //                  return Container(height: 0,width: 0,);
   //                }
   //              });
   //        }else{
   //          return Container(height: 0,width: 0,);
   //        }
   //      });




  }

  void startAutoScanning() {
    List ignoredList = [];

    bool isDialogShowing = false ;

    // SharedPreferences.getInstance().then((sharedPreff) {
    //
    //   timer = Timer.periodic(Duration(seconds: 5), (Timer t) async {
    //     print("5 second done");
    //
    //     if(discovertedDevices.length == 0){
    //       print("connected device "+discovertedDevices.length.toString());
    //
    //       //  tryCachScan();
    //
    //       if(discovertedDevices.isNotEmpty && discovertedDevices.length>0){
    //         print("scanned device "+discovertedDevices.length.toString());
    //         for(int i = 0 ; i < discovertedDevices.toList().length ; i++){
    //           //value.containsKey(event.toList()[i].device.name
    //           print("looking "+discovertedDevices[i].device.name);
    //
    //           if(discovertedDevices[i].device.name!=null && discovertedDevices[i].device.name.length>0 && (discovertedDevices[i].device.name.contains("BLE Gauge") | discovertedDevices[i].device.name.contains("Staht") | discovertedDevices[i].device.name.contains("Default") | discovertedDevices[i].device.name.contains("Mukul"))){
    //             if(true ||  sharedPreff.containsKey(discovertedDevices[i].device.name ) ){
    //               if(true || ignoredList.contains(discovertedDevices[i].device.name)){
    //                 try{
    //
    //                   //AutoConnectPopUp
    //                   if(isDialogShowing == false){
    //                     // isDialogShowing = true ;
    //
    //                     showDialog<void>(
    //                         context: context,
    //                         builder: (context) {
    //
    //                           return AutoConnectPopUp(title: discovertedDevices[i].device.name,conenctionCallback: (val){
    //                             if(val){
    //                               // ignoredList.remove(scannedDevices[i].device.name);
    //                               discovertedDevices[i].device.connect(autoConnect: false);
    //                               sharedPreff.setString(discovertedDevices[i].device.name, discovertedDevices[i].device.name);
    //
    //                             }else{
    //                               ignoredList.add(discovertedDevices[i].device.name);
    //                             }
    //                             // isDialogShowing = false ;
    //
    //                           },);
    //                         }).then((value) {
    //                       // isDialogShowing = false ;
    //                     });
    //                   }
    //                   // else {
    //                   //   isDialogShowing = false ;
    //                   // }
    //
    //                   break;
    //
    //
    //
    //                 }catch(e){
    //                   print(e);
    //
    //                 }
    //               }else{
    //                 print("device was in ignored list");
    //
    //               }
    //
    //             }
    //
    //           }
    //           // tryCachScan();
    //         }
    //       }
    //
    //
    //
    //     }
    //
    //
    //
    //     });
    //
    //
    //
    //   });



  }

  Future<void> work() async {

    bool isShown = await Permission.contacts.isRestricted;
    AppToast().show(message: " pari con "+isShown.toString());

    bool isShown2 = await Permission.bluetoothConnect.isRestricted;
    AppToast().show(message:" pari  conne"+ isShown2.toString());

  }
}
