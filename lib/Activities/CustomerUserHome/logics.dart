import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class CustomerHomePageLogic{
  ShowBleDevicesListStream connectedDevicesStream  = ShowBleDevicesListStream.getInstance();
  TestRunningFlaotingWidgetStream testRunningFlaotingWidgetStream  = TestRunningFlaotingWidgetStream.getInstance();
  TestRunningUniversalNotifier testRunningUniversalNotifier  = TestRunningUniversalNotifier.getInstance();
  ScanDevicesNotifier scanDevicesNotifier  = ScanDevicesNotifier.getInstance();
  ConnectedNotifier connectedNotifier  = ConnectedNotifier.getInstance();
  TabChangedStream tabChangedStream  = TabChangedStream.getInstance();

  double get MaxLoadLBF => 13488;
  double get MaxLoadKN => 60;
  double get MaxLoadKNWarning => 63;
  double get MaxLoadLBFWarning => 14163;

}



class ShowBleDevicesListStream{
  static ShowBleDevicesListStream model =ShowBleDevicesListStream();
  final StreamController<bool> _Controller = StreamController<bool>.broadcast();

  Stream<bool> get outData => _Controller.stream;

  Sink<bool> get inData => _Controller.sink;

  dataReload(bool v) {
    fetch().then((value) => inData.add(v));
  }

  void dispose() {
    _Controller.close();
  }

  static ShowBleDevicesListStream getInstance() {
    if (model == null) {
      model = new ShowBleDevicesListStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}

class TestRunningFlaotingWidgetStream{
  static TestRunningFlaotingWidgetStream model =TestRunningFlaotingWidgetStream();
  final StreamController<Widget> _Controller = StreamController<Widget>.broadcast();

  Stream<Widget> get outData => _Controller.stream;

  Sink<Widget> get inData => _Controller.sink;

  dataReload(Widget v) {
    fetch().then((value) => inData.add(v));
  }

  void dispose() {
    _Controller.close();
  }

  static TestRunningFlaotingWidgetStream getInstance() {
    if (model == null) {
      model = new TestRunningFlaotingWidgetStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}
class TestRunningUniversalNotifier{
  static TestRunningUniversalNotifier model =TestRunningUniversalNotifier();
  final StreamController<bool> _Controller = StreamController<bool>.broadcast();

  Stream<bool> get outData => _Controller.stream;

  Sink<bool> get inData => _Controller.sink;

  dataReload(bool v) {
    fetch().then((value) => inData.add(v));
  }

  void dispose() {
    _Controller.close();
  }

  static TestRunningUniversalNotifier getInstance() {
    if (model == null) {
      model = new TestRunningUniversalNotifier();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}

class ScanDevicesNotifier{
  static ScanDevicesNotifier model =ScanDevicesNotifier();
  final StreamController<bool> _Controller = StreamController<bool>.broadcast();

  Stream<bool> get outData => _Controller.stream;

  Sink<bool> get inData => _Controller.sink;

  dataReload(bool v) {
    fetch().then((value) => inData.add(v));
  }

  void dispose() {
    _Controller.close();
  }

  static ScanDevicesNotifier getInstance() {
    if (model == null) {
      model = new ScanDevicesNotifier();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}

class ConnectedNotifier{
  static ConnectedNotifier model =ConnectedNotifier();
  final StreamController<bool> _Controller = StreamController<bool>.broadcast();

  Stream<bool> get outData => _Controller.stream;

  Sink<bool> get inData => _Controller.sink;

  dataReload(bool v) {
    fetch().then((value) => inData.add(v));
  }

  void dispose() {
    _Controller.close();
  }

  static ConnectedNotifier getInstance() {
    if (model == null) {
      model = new ConnectedNotifier();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}


class TabChangedStream{
  static TabChangedStream model =TabChangedStream();
  final StreamController<int> _Controller = StreamController<int>.broadcast();

  Stream<int> get outData => _Controller.stream;

  Sink<int> get inData => _Controller.sink;

  dataReload(int v) {
    fetch().then((value) => inData.add(v));
  }

  void dispose() {
    _Controller.close();
  }

  static TabChangedStream getInstance() {
    if (model == null) {
      model = new TabChangedStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}