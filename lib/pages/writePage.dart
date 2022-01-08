import 'package:flutter/cupertino.dart';
import 'package:flutter_blue/flutter_blue.dart';

class WriteIntoDevice extends StatefulWidget {
  BluetoothCharacteristic bluetoothCharacteristic ;
  WriteIntoDevice(this.bluetoothCharacteristic);
  @override
  _WriteIntoDeviceState createState() => _WriteIntoDeviceState();
}

class _WriteIntoDeviceState extends State<WriteIntoDevice> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<int>>(
        stream: widget.bluetoothCharacteristic.value,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data!.length > 0) {


            return Text(snapshot.data.toString());
          } else
            return Text("No Data in Stream");
          return Text("Please wait");
        });
  }
}
