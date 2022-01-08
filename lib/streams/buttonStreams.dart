import 'dart:async';
import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';



class CallButonsClickStreamCamera {
  static CallButonsClickStreamCamera model = new CallButonsClickStreamCamera();
  final StreamController<bool> _Controller = StreamController<bool>.broadcast();

  Stream<bool> get outData => _Controller.stream;

  Sink<bool> get inData => _Controller.sink;

  dataReload(bool status) {
    fetch().then((value) => inData.add(status));
  }

  void dispose() {
    _Controller.close();
  }

  static CallButonsClickStreamCamera getInstance() {
    if (model == null) {
      model = new CallButonsClickStreamCamera();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}

class CallButonsClickStreamScreen{
  static CallButonsClickStreamScreen model = CallButonsClickStreamScreen();
  final StreamController<bool> _Controller = StreamController<bool>.broadcast();

  Stream<bool> get outData => _Controller.stream;

  Sink<bool> get inData => _Controller.sink;

  dataReload(bool status) {
    fetch().then((value) => inData.add(status));
  }

  void dispose() {
    _Controller.close();
  }

  static CallButonsClickStreamScreen getInstance() {
    if (model == null) {
      model = new CallButonsClickStreamScreen();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}


class WidgetReadyStream{
  static WidgetReadyStream model = WidgetReadyStream();
  final StreamController<Widget> _Controller = StreamController<Widget>.broadcast();

  Stream<Widget> get outData => _Controller.stream;

  Sink<Widget> get inData => _Controller.sink;

  dataReload(Widget status) {
    fetch().then((value) => inData.add(status));
  }

  void dispose() {
    _Controller.close();
  }

  static WidgetReadyStream getInstance() {
    if (model == null) {
      model = new WidgetReadyStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}



class SelfStatusStream{
  static SelfStatusStream model = SelfStatusStream();
  final StreamController<String> _Controller = StreamController<String>.broadcast();

  Stream<String> get outData => _Controller.stream;

  Sink<String> get inData => _Controller.sink;

  dataReload(String status) {
    fetch().then((value) => inData.add(status));
  }

  void dispose() {
    _Controller.close();
  }

  static SelfStatusStream getInstance() {
    if (model == null) {
      model = new SelfStatusStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}


class CheckFndIsAdded{
  static CheckFndIsAdded model = CheckFndIsAdded();
  final StreamController<bool> _Controller = StreamController<bool>.broadcast();

  Stream<bool> get outData => _Controller.stream;

  Sink<bool> get inData => _Controller.sink;

  dataReload(bool status) {
    fetch().then((value) => inData.add(status));
  }

  void dispose() {
    _Controller.close();
  }

  static CheckFndIsAdded getInstance() {
    if (model == null) {
      model = new CheckFndIsAdded();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}





class AllFndListStream{
  static AllFndListStream model = AllFndListStream();
  final StreamController<List> _Controller = StreamController<List>.broadcast();

  Stream<List> get outData => _Controller.stream;

  Sink<List> get inData => _Controller.sink;

  dataReload(List status) {
    fetch().then((value) => inData.add(status));
  }

  void dispose() {
    _Controller.close();
  }

  static AllFndListStream getInstance() {
    if (model == null) {
      model = new AllFndListStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}



class getUserDetailStream{
  static getUserDetailStream model = getUserDetailStream();
  final StreamController<dynamic> _Controller = StreamController<dynamic>.broadcast();

  Stream<dynamic> get outData => _Controller.stream;

  Sink<dynamic> get inData => _Controller.sink;

  dataReload(dynamic status) {
    fetch().then((value) => inData.add(status));
  }

  void dispose() {
    _Controller.close();
  }

  static getUserDetailStream getInstance() {
    if (model == null) {
      model = new getUserDetailStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}



class FetchUserInfoStream{
  static FetchUserInfoStream model = FetchUserInfoStream();
  final StreamController<dynamic> _Controller = StreamController<dynamic>.broadcast();

  Stream<dynamic> get outData => _Controller.stream;

  Sink<dynamic> get inData => _Controller.sink;

  dataReload(dynamic status) {
    fetch().then((value) => inData.add(status));
  }

  void dispose() {
    _Controller.close();
  }

  static FetchUserInfoStream getInstance() {
    if (model == null) {
      model = new FetchUserInfoStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}


class LastMessagesStream{
  static LastMessagesStream model = LastMessagesStream();
  final StreamController<List> _Controller = StreamController<List>.broadcast();

  Stream<List> get outData => _Controller.stream;

  Sink<List> get inData => _Controller.sink;

  dataReload(List status) {
    fetch().then((value) => inData.add(status));
  }

  void dispose() {
    _Controller.close();
  }

  static LastMessagesStream getInstance() {
    if (model == null) {
      model = new LastMessagesStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}

class TimerUpdateStream{
  static TimerUpdateStream model = TimerUpdateStream();
  final StreamController<int> _Controller = StreamController<int>.broadcast();

  Stream<int> get outData => _Controller.stream;

  Sink<int> get inData => _Controller.sink;

  dataReload(int status) {
    fetch().then((value) => inData.add(status));
  }

  void dispose() {
    _Controller.close();
  }

  static TimerUpdateStream getInstance() {
    if (model == null) {
      model = new TimerUpdateStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}





class FilteredDataShow{
  static FilteredDataShow model = FilteredDataShow();
  final StreamController<List<DocumentSnapshot<Object>>> _Controller = StreamController<List<DocumentSnapshot<Object>>>.broadcast();

  Stream<List<DocumentSnapshot<Object>>> get outData => _Controller.stream;

  Sink<List<DocumentSnapshot<Object>>> get inData => _Controller.sink;

  dataReload(List<DocumentSnapshot<Object>> status) {
    fetch().then((value) => inData.add(status));
  }

  void dispose() {
    _Controller.close();
  }

  static FilteredDataShow getInstance() {
    if (model == null) {
      model = new FilteredDataShow();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}


class FilteredFolderShow{
  static FilteredFolderShow model =FilteredFolderShow();
  final StreamController<List<DocumentSnapshot<Object>>> _Controller = StreamController<List<DocumentSnapshot<Object>>>.broadcast();

  Stream<List<DocumentSnapshot<Object>>> get outData => _Controller.stream;

  Sink<List<DocumentSnapshot<Object>>> get inData => _Controller.sink;

  dataReload(List<DocumentSnapshot<Object>> status) {
    fetch().then((value) => inData.add(status));
  }

  void dispose() {
    _Controller.close();
  }

  static FilteredFolderShow getInstance() {
    if (model == null) {
      model = new FilteredFolderShow();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}



class tabMenuSelctorStream{
  static tabMenuSelctorStream model = tabMenuSelctorStream();
  final StreamController<int> _Controller = StreamController<int>.broadcast();

  Stream<int> get outData => _Controller.stream;

  Sink<int> get inData => _Controller.sink;

  dataReload(int status) {
    fetch().then((value) => inData.add(status));
  }

  void dispose() {
    _Controller.close();
  }

  static tabMenuSelctorStream getInstance() {
    if (model == null) {
      model = new tabMenuSelctorStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}

class AttachmentsAddedListener{
  static AttachmentsAddedListener model = AttachmentsAddedListener();
  final StreamController<List<dynamic>> _Controller = StreamController<List<dynamic>>.broadcast();

  Stream<List<dynamic>> get outData => _Controller.stream;

  Sink<List<dynamic>> get inData => _Controller.sink;

  dataReload(List<dynamic> status) {
    fetch().then((value) => inData.add(status));
  }

  void dispose() {
    _Controller.close();
  }

  static AttachmentsAddedListener getInstance() {
    if (model == null) {
      model = new AttachmentsAddedListener();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}



class Index2ValueStream{
  static Index2ValueStream model = Index2ValueStream();
  final StreamController<String> _Controller = StreamController<String>.broadcast();

  Stream<String> get outData => _Controller.stream;

  Sink<String> get inData => _Controller.sink;

  dataReload(String v) {
    fetch().then((value) => inData.add(v));
  }

  void dispose() {
    _Controller.close();
  }

  static Index2ValueStream getInstance() {
    if (model == null) {
      model = new Index2ValueStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}

class Index1ValueStream{
  static Index1ValueStream model = Index1ValueStream();
  final StreamController<String> _Controller = StreamController<String>.broadcast();

  Stream<String> get outData => _Controller.stream;

  Sink<String> get inData => _Controller.sink;

  dataReload(String v) {
    fetch().then((value) => inData.add(v));
  }

  void dispose() {
    _Controller.close();
  }

  static Index1ValueStream getInstance() {
    if (model == null) {
      model = new Index1ValueStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}


class gettingDatafromPCBStream{
  static gettingDatafromPCBStream model =gettingDatafromPCBStream();
  final StreamController<bool> _Controller = StreamController<bool>.broadcast();

  Stream<bool> get outData => _Controller.stream;

  Sink<bool> get inData => _Controller.sink;

  dataReload(bool v) {
    fetch().then((value) => inData.add(v));
  }

  void dispose() {
    _Controller.close();
  }

  static gettingDatafromPCBStream getInstance() {
    if (model == null) {
      model = new gettingDatafromPCBStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}

class ThemeAppBackgroundColorChangeStream{
  static ThemeAppBackgroundColorChangeStream model = ThemeAppBackgroundColorChangeStream();
  final StreamController<bool> _Controller = StreamController<bool>.broadcast();

  Stream<bool> get outData => _Controller.stream;

  Sink<bool> get inData => _Controller.sink;

  dataReload(bool v) {
    fetch().then((value) => inData.add(v));
  }

  void dispose() {
    _Controller.close();
  }

  static ThemeAppBackgroundColorChangeStream getInstance() {
    if (model == null) {
      model = new ThemeAppBackgroundColorChangeStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}

class ImageWriteStatusStream{
  static ImageWriteStatusStream model =ImageWriteStatusStream();
  final StreamController<double> _Controller = StreamController<double>.broadcast();

  Stream<double> get outData => _Controller.stream;

  Sink<double> get inData => _Controller.sink;

  dataReload(double v) {
    fetch().then((value) => inData.add(v));
  }

  void dispose() {
    _Controller.close();
  }

  static ImageWriteStatusStream getInstance() {
    if (model == null) {
      model = new ImageWriteStatusStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}



class VideoPhotoToggleStream{
  static VideoPhotoToggleStream model =VideoPhotoToggleStream();
  final StreamController<bool> _Controller = StreamController<bool>.broadcast();

  Stream<bool> get outData => _Controller.stream;

  Sink<bool> get inData => _Controller.sink;

  dataReload(bool v) {
    fetch().then((value) => inData.add(v));
  }

  void dispose() {
    _Controller.close();
  }

  static VideoPhotoToggleStream getInstance() {
    if (model == null) {
      model = new VideoPhotoToggleStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}

class RecordingStartedStoppedStream{
  static RecordingStartedStoppedStream model =RecordingStartedStoppedStream();
  final StreamController<bool> _Controller = StreamController<bool>.broadcast();

  Stream<bool> get outData => _Controller.stream;

  Sink<bool> get inData => _Controller.sink;

  dataReload(bool v) {
    fetch().then((value) => inData.add(v));
  }

  void dispose() {
    _Controller.close();
  }

  static RecordingStartedStoppedStream getInstance() {
    if (model == null) {
      model = new RecordingStartedStoppedStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}


class RecordingTimerStream{
  static RecordingTimerStream model =RecordingTimerStream();
  final StreamController<int> _Controller = StreamController<int>.broadcast();

  Stream<int> get outData => _Controller.stream;

  Sink<int> get inData => _Controller.sink;

  dataReload(int v) {
    fetch().then((value) => inData.add(v));
  }

  void dispose() {
    _Controller.close();
  }

  static RecordingTimerStream getInstance() {
    if (model == null) {
      model = new RecordingTimerStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}



class ExpandFolderStream{
  static ExpandFolderStream model =ExpandFolderStream();
  final StreamController<dynamic> _Controller = StreamController<dynamic>.broadcast();

  Stream<dynamic> get outData => _Controller.stream;

  Sink<dynamic> get inData => _Controller.sink;

  dataReload(dynamic v) {
    fetch().then((value) => inData.add(v));
  }

  void dispose() {
    _Controller.close();
  }

  static ExpandFolderStream getInstance() {
    if (model == null) {
      model = new ExpandFolderStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}



class ExpandFolderStreamL1{
  static ExpandFolderStreamL1 model =ExpandFolderStreamL1();
  final StreamController<dynamic> _Controller = StreamController<dynamic>.broadcast();

  Stream<dynamic> get outData => _Controller.stream;

  Sink<dynamic> get inData => _Controller.sink;

  dataReload(dynamic v) {
    fetch().then((value) => inData.add(v));
  }

  void dispose() {
    _Controller.close();
  }

  static ExpandFolderStreamL1 getInstance() {
    if (model == null) {
      model = new ExpandFolderStreamL1();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}



class ExpandFolderStreamL2{
  static ExpandFolderStreamL2 model =ExpandFolderStreamL2();
  final StreamController<dynamic> _Controller = StreamController<dynamic>.broadcast();

  Stream<dynamic> get outData => _Controller.stream;

  Sink<dynamic> get inData => _Controller.sink;

  dataReload(dynamic v) {
    fetch().then((value) => inData.add(v));
  }

  void dispose() {
    _Controller.close();
  }

  static ExpandFolderStreamL2 getInstance() {
    if (model == null) {
      model = new ExpandFolderStreamL2();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}


class ExpandFolderStreamL3{
  static ExpandFolderStreamL3 model =ExpandFolderStreamL3();
  final StreamController<dynamic> _Controller = StreamController<dynamic>.broadcast();

  Stream<dynamic> get outData => _Controller.stream;

  Sink<dynamic> get inData => _Controller.sink;

  dataReload(dynamic v) {
    fetch().then((value) => inData.add(v));
  }

  void dispose() {
    _Controller.close();
  }

  static ExpandFolderStreamL3 getInstance() {
    if (model == null) {
      model = new ExpandFolderStreamL3();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}



class ExpandFolderStreamL4{
  static ExpandFolderStreamL4 model =ExpandFolderStreamL4();
  final StreamController<dynamic> _Controller = StreamController<dynamic>.broadcast();

  Stream<dynamic> get outData => _Controller.stream;

  Sink<dynamic> get inData => _Controller.sink;

  dataReload(dynamic v) {
    fetch().then((value) => inData.add(v));
  }

  void dispose() {
    _Controller.close();
  }

  static ExpandFolderStreamL4 getInstance() {
    if (model == null) {
      model = new ExpandFolderStreamL4();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}


class HomePagePaginationStream{
  static HomePagePaginationStream model =HomePagePaginationStream();
  final StreamController<int> _Controller = StreamController<int>.broadcast();

  Stream<int> get outData => _Controller.stream;

  Sink<int> get inData => _Controller.sink;

  dataReload(int v) {
    fetch().then((value) => inData.add(v));
  }

  void dispose() {
    _Controller.close();
  }

  static HomePagePaginationStream getInstance() {
    if (model == null) {
      model = new HomePagePaginationStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}


class UnitChangedStream{
  static UnitChangedStream model =UnitChangedStream();
  final StreamController<String> _Controller = StreamController<String>.broadcast();

  Stream<String> get outData => _Controller.stream;

  Sink<String> get inData => _Controller.sink;

  dataReload(String v) {
    fetch().then((value) => inData.add(v));
  }

  void dispose() {
    _Controller.close();
  }

  static UnitChangedStream getInstance() {
    if (model == null) {
      model = new UnitChangedStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}

class TitleUpdateStream{
  static TitleUpdateStream model =TitleUpdateStream();
  final StreamController<String> _Controller = StreamController<String>.broadcast();

  Stream<String> get outData => _Controller.stream;

  Sink<String> get inData => _Controller.sink;

  dataReload(String v) {
    fetch().then((value) => inData.add(v));
  }

  void dispose() {
    _Controller.close();
  }

  static TitleUpdateStream getInstance() {
    if (model == null) {
      model = new TitleUpdateStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}

class ShowOverloadWarningStream{
  static ShowOverloadWarningStream model =ShowOverloadWarningStream();
  final StreamController<bool> _Controller = StreamController<bool>.broadcast();

  Stream<bool> get outData => _Controller.stream;

  Sink<bool> get inData => _Controller.sink;

  dataReload(bool v) {
    fetch().then((value) => inData.add(v));
  }

  void dispose() {
    _Controller.close();
  }

  static ShowOverloadWarningStream getInstance() {
    if (model == null) {
      model = new ShowOverloadWarningStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}

class AppTitleAppbarStream{
  static AppTitleAppbarStream model =AppTitleAppbarStream();
  final StreamController<String> _Controller = StreamController<String>.broadcast();

  Stream<String> get outData => _Controller.stream;

  Sink<String> get inData => _Controller.sink;

  dataReload(String v) {
    fetch().then((value) => inData.add(v));
  }

  void dispose() {
    _Controller.close();
  }

  static AppTitleAppbarStream getInstance() {
    if (model == null) {
      model = new AppTitleAppbarStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}

class UserLoggedInStream{
  static UserLoggedInStream model =UserLoggedInStream();
  final StreamController<bool> _Controller = StreamController<bool>.broadcast();

  Stream<bool> get outData => _Controller.stream;

  Sink<bool> get inData => _Controller.sink;

  dataReload(bool v) {
    fetch().then((value) => inData.add(v));
  }

  void dispose() {
    _Controller.close();
  }

  static UserLoggedInStream getInstance() {
    if (model == null) {
      model = new UserLoggedInStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}

class RecordRunningTimeStream{
  static RecordRunningTimeStream model =RecordRunningTimeStream();
  final StreamController<int> _Controller = StreamController<int>.broadcast();

  Stream<int> get outData => _Controller.stream;

  Sink<int> get inData => _Controller.sink;

  dataReload(int v) {
    fetch().then((value) => inData.add(v));
  }

  void dispose() {
    _Controller.close();
  }

  static RecordRunningTimeStream getInstance() {
    if (model == null) {
      model = new RecordRunningTimeStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}


class ScanWidgetStream{
  static ScanWidgetStream model =ScanWidgetStream();
  final StreamController<Widget> _Controller = StreamController<Widget>.broadcast();

  Stream<Widget> get outData => _Controller.stream;

  Sink<Widget> get inData => _Controller.sink;

  dataReload(Widget v) {
    fetch().then((value) => inData.add(v));
  }

  void dispose() {
    _Controller.close();
  }

  static ScanWidgetStream getInstance() {
    if (model == null) {
      model = new ScanWidgetStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}



class FileAddedForReportingAsStream{
  static FileAddedForReportingAsStream model =FileAddedForReportingAsStream();
  final StreamController<String> _Controller = StreamController<String>.broadcast();

  Stream<String> get outData => _Controller.stream;

  Sink<String> get inData => _Controller.sink;

  dataReload(String v) {
    fetch().then((value) => inData.add(v));
  }

  void dispose() {
    _Controller.close();
  }

  static FileAddedForReportingAsStream getInstance() {
    if (model == null) {
      model = new FileAddedForReportingAsStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}

class FileRemovedForReportingAsStream{
  static FileRemovedForReportingAsStream model =FileRemovedForReportingAsStream();
  final StreamController<String> _Controller = StreamController<String>.broadcast();

  Stream<String> get outData => _Controller.stream;

  Sink<String> get inData => _Controller.sink;

  dataReload(String v) {
    fetch().then((value) => inData.add(v));
  }

  void dispose() {
    _Controller.close();
  }

  static FileRemovedForReportingAsStream getInstance() {
    if (model == null) {
      model = new FileRemovedForReportingAsStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}

class FileClickedForReportingAsStream{
  static FileClickedForReportingAsStream model =FileClickedForReportingAsStream();
  final StreamController<String> _Controller = StreamController<String>.broadcast();

  Stream<String> get outData => _Controller.stream;

  Sink<String> get inData => _Controller.sink;

  dataReload(String v) {
    fetch().then((value) => inData.add(v));
  }

  void dispose() {
    _Controller.close();
  }

  static FileClickedForReportingAsStream getInstance() {
    if (model == null) {
      model = new FileClickedForReportingAsStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}

class FolderClickedForReportingAsStream{
  static FolderClickedForReportingAsStream model =FolderClickedForReportingAsStream();
  final StreamController<String> _Controller = StreamController<String>.broadcast();

  Stream<String> get outData => _Controller.stream;

  Sink<String> get inData => _Controller.sink;

  dataReload(String v) {
    fetch().then((value) => inData.add(v));
  }

  void dispose() {
    _Controller.close();
  }

  static FolderClickedForReportingAsStream getInstance() {
    if (model == null) {
      model = new FolderClickedForReportingAsStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}

class NeedToRefreshFilesNameAsStream{
  static NeedToRefreshFilesNameAsStream model =NeedToRefreshFilesNameAsStream();
  final StreamController<bool> _Controller = StreamController<bool>.broadcast();

  Stream<bool> get outData => _Controller.stream;

  Sink<bool> get inData => _Controller.sink;

  dataReload(bool v) {
    fetch().then((value) => inData.add(v));
  }

  void dispose() {
    _Controller.close();
  }

  static NeedToRefreshFilesNameAsStream getInstance() {
    if (model == null) {
      model = new NeedToRefreshFilesNameAsStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}


class NeedToRefreshFoldersNameAsStream{
  static NeedToRefreshFoldersNameAsStream model =NeedToRefreshFoldersNameAsStream();
  final StreamController<bool> _Controller = StreamController<bool>.broadcast();

  Stream<bool> get outData => _Controller.stream;

  Sink<bool> get inData => _Controller.sink;

  dataReload(bool v) {
    fetch().then((value) => inData.add(v));
  }

  void dispose() {
    _Controller.close();
  }

  static NeedToRefreshFoldersNameAsStream getInstance() {
    if (model == null) {
      model = new NeedToRefreshFoldersNameAsStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}




class ReportGenerateProgressStream{
  static ReportGenerateProgressStream model =ReportGenerateProgressStream();
  final StreamController<int> _Controller = StreamController<int>.broadcast();

  Stream<int> get outData => _Controller.stream;

  Sink<int> get inData => _Controller.sink;

  dataReload(int v) {
    fetch().then((value) => inData.add(v));
  }

  void dispose() {
    _Controller.close();
  }

  static ReportGenerateProgressStream getInstance() {
    if (model == null) {
      model = new ReportGenerateProgressStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}



class TestTitleUpdatedStream{
  static TestTitleUpdatedStream model =TestTitleUpdatedStream();
  final StreamController<bool> _Controller = StreamController<bool>.broadcast();

  Stream<bool> get outData => _Controller.stream;

  Sink<bool> get inData => _Controller.sink;

  dataReload(bool v) {
    fetch().then((value) => inData.add(v));
  }

  void dispose() {
    _Controller.close();
  }

  static TestTitleUpdatedStream getInstance() {
    if (model == null) {
      model = new TestTitleUpdatedStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}


class ReportSavedStream{
  static ReportSavedStream model =ReportSavedStream();
  final StreamController<int> _Controller = StreamController<int>.broadcast();

  Stream<int> get outData => _Controller.stream;

  Sink<int> get inData => _Controller.sink;

  dataReload(int v) {
    fetch().then((value) => inData.add(v));
  }

  void dispose() {
    _Controller.close();
  }

  static ReportSavedStream getInstance() {
    if (model == null) {
      model = new ReportSavedStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}
class ReportTestCounterStream{
  static ReportTestCounterStream model =ReportTestCounterStream();
  final StreamController<int> _Controller = StreamController<int>.broadcast();

  Stream<int> get outData => _Controller.stream;

  Sink<int> get inData => _Controller.sink;

  dataReload(int v) {
    fetch().then((value) => inData.add(v));
  }

  void dispose() {
    _Controller.close();
  }

  static ReportTestCounterStream getInstance() {
    if (model == null) {
      model = new ReportTestCounterStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}
class ReportFolderCounterStream{
  static ReportFolderCounterStream model =ReportFolderCounterStream();
  final StreamController<int> _Controller = StreamController<int>.broadcast();

  Stream<int> get outData => _Controller.stream;

  Sink<int> get inData => _Controller.sink;

  dataReload(int v) {
    fetch().then((value) => inData.add(v));
  }

  void dispose() {
    _Controller.close();
  }

  static ReportFolderCounterStream getInstance() {
    if (model == null) {
      model = new ReportFolderCounterStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}

class AttachmentUploadedStream{
  static AttachmentUploadedStream model =AttachmentUploadedStream();
  final StreamController<int> _Controller = StreamController<int>.broadcast();

  Stream<int> get outData => _Controller.stream;

  Sink<int> get inData => _Controller.sink;

  dataReload(int v) {
    fetch().then((value) => inData.add(v));
  }

  void dispose() {
    _Controller.close();
  }

  static AttachmentUploadedStream getInstance() {
    if (model == null) {
      model = new AttachmentUploadedStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}

