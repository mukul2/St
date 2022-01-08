import 'dart:async';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'ui_components.dart';
import 'dart:ffi';
class TestPerformLogics{
  BuildContext? context;
  FirebaseFirestore? firestore;
  TestPerformLogics({this.context,this.firestore});
  CameraReadyStream cameraReadyStream = CameraReadyStream.getInstance();
  PhotoClickedStream photoClickedStream = PhotoClickedStream.getInstance();
  CommonAttachmentAddedStream commonAttachmentAddedStream = CommonAttachmentAddedStream.getInstance();
  VideoClickedStream videoClickedStream = VideoClickedStream.getInstance();
  GauseValueStreamAsFloat gauseValueStreamAsFloat = GauseValueStreamAsFloat.getInstance();
  TestStartStopStream testStartStopStream = TestStartStopStream.getInstance();
  CaptureScreensotStream captureScreensotStream = CaptureScreensotStream.getInstance();
  TimerUniversalStream timerUniversalStream = TimerUniversalStream.getInstance();
  saveTestBottomSheet({required String id}){
    Navigator.push(
      context!,
      MaterialPageRoute(builder: (context) => TestPerformUiComponents().saveIntoFileExplolar(
        firestore: firestore!,
        id: id,
      )),
    );
  }
  String convertwithDecimalplaces(List<int> data, int decimalPLace) {
    String returnValue = "";

    final result = data.map((b) => '${b.toRadixString(16).padLeft(2, '0')}');
    //print('bytes: ${result}');
    //HexEncoder _hexEncoder;
    var bd = ByteData(4);
    for (int i = 0; i < data.length; i++) {
      String tempVal = data[i].toRadixString(16).padLeft(2, '0').toString();
      //returnValue = returnValue+tempVal;

      bd.setUint8(i, data[i].toInt());
    }
    var f = bd.getFloat32(0);
    // print(f);
    bd.setUint32(0, 0x41480000);
    var f1 = bd.getFloat32(0);
    // print(f1);
    // print(_hexEncoder.);
//  returnValue =data[0].toRadixString(16).padLeft(2, '0')+data[0].toRadixString(16).padLeft(2, '0')+data[0].toRadixString(16).padLeft(2, '0')+data[0].toRadixString(16).padLeft(2, '0');

    // if(widget.targetLoad >f*1.1 ){
    //
    //
    //
    //  // setState(() {
    //     reachedTargetLoad = true ;
    //     lastReachTaregetLoadTime = DateTime.now().millisecondsSinceEpoch;
    // //  });
    // }ƒ
    // if(f >0.19 ){
    //  // setState(() {
    //     shouldStartRecordning = true ;
    //     lastReachOffsetLoadTime = DateTime.now().millisecondsSinceEpoch;
    //  // });ƒF
    // }
    TestPerformLogics().gauseValueStreamAsFloat.dataReload(getNumber(f,precision: 1));
    return getNumber(f,precision: 1).toString();
    return f.toStringAsFixed(decimalPLace);
  }
  double getNumber(double input, {int precision = 1}) =>
      double.parse('$input'.substring(0, '$input'.indexOf('.') + precision + 1));
  String durationToString(int miliseconds) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(miliseconds);
    int minute = dateTime.minute;
    int second = dateTime.second;
    int mili = dateTime.millisecond;
    //return dateTime.toIso8601String();

    //return dateTime.toString().split('.')[1];

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('mm:ss').format(dateTime);
    return formattedDate;

    // DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(seconds);
    // String minute = dateTime.minute.toString();
    // String second = dateTime.second.toString();
    // String mili = dateTime.millisecond.toString();
    //
    // //return duration.toString().split('.')[0];
    // return minute + " : " + second + " : " + mili + " m:s";
    // return duration.toString().split('.')[0];
  }
}

class CaptureScreensotStream{
  static CaptureScreensotStream model = CaptureScreensotStream();
  final StreamController<bool> _Controller = StreamController<bool>.broadcast();

  Stream<bool> get outData => _Controller.stream;

  Sink<bool> get inData => _Controller.sink;

  dataReload(bool v) {
    fetch().then((value) => inData.add(v));
  }

  void dispose() {
    _Controller.close();
  }

  static CaptureScreensotStream getInstance() {
    if (model == null) {
      model = new CaptureScreensotStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}
class CameraReadyStream{
  static CameraReadyStream model = CameraReadyStream();
  final StreamController<CameraController> _Controller = StreamController<CameraController>.broadcast();


  Stream<CameraController> get outData => _Controller.stream;

  Sink<CameraController> get inData => _Controller.sink;

  dataReload(CameraController status) {
    fetch().then((value) => inData.add(status));
  }

  void dispose() {
    _Controller.close();
  }

  static CameraReadyStream getInstance() {
    if (model == null) {
      model = new CameraReadyStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}


class PhotoClickedStream{
  static PhotoClickedStream model = PhotoClickedStream();
  final StreamController<dynamic> _Controller = StreamController<dynamic>.broadcast();

  Stream<dynamic> get outData => _Controller.stream;

  Sink<dynamic> get inData => _Controller.sink;

  dataReload(dynamic status) {
    fetch().then((value) => inData.add(status));
  }

  void dispose() {
    _Controller.close();
  }

  static PhotoClickedStream getInstance() {
    if (model == null) {
      model = new PhotoClickedStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}


class CommonAttachmentAddedStream{
  static CommonAttachmentAddedStream model = CommonAttachmentAddedStream();
  final StreamController<dynamic> _Controller = StreamController<dynamic>.broadcast();

  Stream<dynamic> get outData => _Controller.stream;

  Sink<dynamic> get inData => _Controller.sink;

  dataReload(dynamic status) {
    fetch().then((value) => inData.add(status));
  }

  void dispose() {
    _Controller.close();
  }

  static CommonAttachmentAddedStream getInstance() {
    if (model == null) {
      model = new CommonAttachmentAddedStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}
class VideoClickedStream{
  static VideoClickedStream model = VideoClickedStream();
  final StreamController<dynamic> _Controller = StreamController<dynamic>.broadcast();

  Stream<dynamic> get outData => _Controller.stream;

  Sink<dynamic> get inData => _Controller.sink;

  dataReload(dynamic status) {
    fetch().then((value) => inData.add(status));
  }

  void dispose() {
    _Controller.close();
  }

  static VideoClickedStream getInstance() {
    if (model == null) {
      model = new VideoClickedStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}


class TestStartStopStream{
  static TestStartStopStream model = TestStartStopStream();
  final StreamController<bool> _Controller = StreamController<bool>.broadcast();

  Stream<bool> get outData => _Controller.stream;

  Sink<bool> get inData => _Controller.sink;

  dataReload(bool status) {
    fetch().then((value) => inData.add(status));
  }

  void dispose() {
    _Controller.close();
  }

  static TestStartStopStream getInstance() {
    if (model == null) {
      model = new TestStartStopStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}


class GauseValueStreamAsFloat{
  static GauseValueStreamAsFloat model = GauseValueStreamAsFloat();
  final StreamController<double> _Controller = StreamController<double>.broadcast();

  Stream<double> get outData => _Controller.stream;

  Sink<double> get inData => _Controller.sink;

  dataReload(double status) {
    fetch().then((value) => inData.add(status));
  }

  void dispose() {
    _Controller.close();
  }

  static GauseValueStreamAsFloat getInstance() {
    if (model == null) {
      model = new GauseValueStreamAsFloat();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}

class TimerUniversalStream{
  static TimerUniversalStream model = TimerUniversalStream();
  final StreamController<int> _Controller = StreamController<int>.broadcast();

  Stream<int> get outData => _Controller.stream;

  Sink<int> get inData => _Controller.sink;

  dataReload(int status) {
    fetch().then((value) => inData.add(status));
  }

  void dispose() {
    _Controller.close();
  }

  static TimerUniversalStream getInstance() {
    if (model == null) {
      model = new TimerUniversalStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}