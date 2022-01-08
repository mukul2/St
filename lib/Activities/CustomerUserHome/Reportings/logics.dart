import 'dart:async';

class ReportingsLogics{
  FileSelectedForReportStream fileSelectedForReportStream(){
    return FileSelectedForReportStream.getInstance();
  }

  FolderSelectedForReportStream folderSelectedForReportStream(){
    return FolderSelectedForReportStream.getInstance();
  }


}
class FileSelectedForReportStream{
  static FileSelectedForReportStream model =FileSelectedForReportStream();
  final StreamController<List> _Controller = StreamController<List>.broadcast();

  Stream<List> get outData => _Controller.stream;

  Sink<List> get inData => _Controller.sink;

  dataReload(List v) {
    fetch().then((value) => inData.add(v));
  }

  void dispose() {
    _Controller.close();
  }

  static FileSelectedForReportStream getInstance() {
    if (model == null) {
      model = new FileSelectedForReportStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}
class FolderSelectedForReportStream{
  static FolderSelectedForReportStream model =FolderSelectedForReportStream();
  final StreamController<List> _Controller = StreamController<List>.broadcast();

  Stream<List> get outData => _Controller.stream;

  Sink<List> get inData => _Controller.sink;

  dataReload(List v) {
    fetch().then((value) => inData.add(v));
  }

  void dispose() {
    _Controller.close();
  }

  static FolderSelectedForReportStream getInstance() {
    if (model == null) {
      model = new FolderSelectedForReportStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}