import 'dart:async';

class FileExplolarLogics{
  SelectedPositionChangeStream fileExplolarChangeListener(){
  return SelectedPositionChangeStream.getInstance();

}

}


class SelectedPositionChangeStream{
  static SelectedPositionChangeStream model =SelectedPositionChangeStream();
  final StreamController<int> _Controller = StreamController<int>.broadcast();

  Stream<int> get outData => _Controller.stream;

  Sink<int> get inData => _Controller.sink;

  dataReload(int v) {
    fetch().then((value) => inData.add(v));
  }

  void dispose() {
    _Controller.close();
  }

  static SelectedPositionChangeStream getInstance() {
    if (model == null) {
      model = new SelectedPositionChangeStream();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}