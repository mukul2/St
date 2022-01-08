import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/Activities/CustomerUserHome/logics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connect/Activities/recordReviewActivity.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import 'package:flutter/material.dart';
class AppWidgets {
  late FirebaseFirestore customerFirestore;
late  String customerId;
  AppWidgets({required this.customerFirestore,required this.customerId});



  void showTestRecordBodyByQuery(

      String id,
      Map<String,dynamic> snapshotHistoryItem,
      BuildContext context,
      Locale locale,
      int selectedFrom
     ) {
    Future<void> _initializeControllerFuture;
   late CameraController _controller;
    var camera;
    File _image;
    void initCamera() async {
      WidgetsFlutterBinding.ensureInitialized();

      // Obtain a list of the available cameras on the device.
      final cameras = await availableCameras();

      // Get a specific camera from the list of available cameras.

      //  setState(() {
      camera = cameras.first;
      _controller = CameraController(
        // Get a specific camera from the list of available cameras.
        camera,
        // Define the resolution to use.
        ResolutionPreset.medium,
      );

      // Next, initialize the controller. This returns a Future.
   //   _initializeControllerFuture = _controller.initialize();
      print("go to init cm");
      _controller.initialize().then((value) async {
        print("go to init cm done");
        String width = MediaQuery.of(context).size.width.ceil().toString();
        // You can request multiple permissions at once.
        // Map<Permission, PermissionStatus> statuses = await [
        //   Permission.location, Permission.storage,Permission.camera,Permission.microphone,Permission.locationAlways,
        // ].request();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>RecordViewStatefullActivityQuery(selectedTab: selectedFrom,locale: locale,
                  width: width,
                  customerFirestore: customerFirestore,
                  snapshotHistoryItem: snapshotHistoryItem,
                  id: id,
                  controller: _controller,
                )));

        //update nav

       // CustomerHomePageLogic().tabChangedStream.dataReload(selectedFrom);

        // Navigator.of(context).push(new MaterialPageRoute<Null>(
        //     builder: (BuildContext context) {
        //
        //
        //       final scaffoldState = GlobalKey<ScaffoldState>();
        //       return RecordViewStatefullActivity(selectedTab: selectedFrom,locale: locale,
        //         width: width,
        //         customerFirestore: customerFirestore,
        //         snapshotHistoryItem: snapshotHistoryItem,
        //         id: id,
        //         controller: _controller,
        //       );
        //     },
        //     fullscreenDialog: true));

      });

      // });
    }

    initCamera();
    //init camera controler first

  }
  void showTestRecordBody(

      String id,
      dynamic snapshotHistoryItem,
      BuildContext context,
      Locale locale,
      int selectedFrom
     ) {
    Future<void> _initializeControllerFuture;
   late CameraController _controller;
    var camera;
    File _image;
    void initCamera() async {
      WidgetsFlutterBinding.ensureInitialized();

      // Obtain a list of the available cameras on the device.
      final cameras = await availableCameras();

      // Get a specific camera from the list of available cameras.

      //  setState(() {
      camera = cameras.first;
      _controller = CameraController(
        // Get a specific camera from the list of available cameras.
        camera,
        // Define the resolution to use.
        ResolutionPreset.medium,
      );

      // Next, initialize the controller. This returns a Future.
   //   _initializeControllerFuture = _controller.initialize();
      print("go to init cm");
      _controller.initialize().then((value) async {
        print("go to init cm done");
        String width = MediaQuery.of(context).size.width.ceil().toString();
        // You can request multiple permissions at once.
        // Map<Permission, PermissionStatus> statuses = await [
        //   Permission.location, Permission.storage,Permission.camera,Permission.microphone,Permission.locationAlways,
        // ].request();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>RecordViewStatefullActivity(selectedTab: selectedFrom,locale: locale,
                  width: width,
                  customerFirestore: customerFirestore,
                  snapshotHistoryItem: snapshotHistoryItem,
                  id: id,
                  controller: _controller,
                )));

        //update nav

       // CustomerHomePageLogic().tabChangedStream.dataReload(selectedFrom);

        // Navigator.of(context).push(new MaterialPageRoute<Null>(
        //     builder: (BuildContext context) {
        //
        //
        //       final scaffoldState = GlobalKey<ScaffoldState>();
        //       return RecordViewStatefullActivity(selectedTab: selectedFrom,locale: locale,
        //         width: width,
        //         customerFirestore: customerFirestore,
        //         snapshotHistoryItem: snapshotHistoryItem,
        //         id: id,
        //         controller: _controller,
        //       );
        //     },
        //     fullscreenDialog: true));

      });

      // });
    }

    initCamera();
    //init camera controler first

  }
}