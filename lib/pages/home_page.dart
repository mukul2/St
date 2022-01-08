import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'dart:math';
import 'package:convert/convert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connect/models/BarChartModel.dart';
import 'package:connect/pages/BarChartDemo.dart';
import 'package:connect/pages/connected_device_page.dart';
import 'package:connect/pages/data_list.dart';
import 'package:connect/pages/perform_test.dart';
import 'package:connect/pages/writePage.dart';
import 'package:connect/screens/login.dart';
import 'package:connect/services/database.dart';
import 'package:connect/services/os_dependent_settings.dart';
import 'package:connect/services/themeManager.dart';
import 'package:connect/streams/AuthControllerStream.dart';
import 'package:connect/widgets.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:typed_data';

import 'TestPeromationActivity.dart';


enum TestStatus { stopped, running }

String printData = "";

Future<void> Home() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
     // theme: AppTheme().getThemeData(),
      title: 'Firebase Example App',
      home: HomePage()));
}

void _pushPage(BuildContext context, Widget page) {
  Navigator.of(context) /*!*/ .push(
    MaterialPageRoute<void>(builder: (_) => page),
  );
}

class HomePage extends StatefulWidget {
  /// The page title.
  final String title = 'Sign In & Out';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context) /*!*/ .push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  void _logOut() {
    FirebaseAuth.instance
        .signOut()
        .then((value) => {UserAuthStream.getInstance().signOut()});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          Center(
            child: InkWell(
              onTap: () {
                _pushPage(context, DataListPage());
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                child: Text("View Data List"),
              ),
            ),
          )
        ],
      ),
      drawer: Column(
        children: [],
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: _logOut, label: Text("Sign Out")),
      body: Center(
        child: InkWell(
          onTap: () {
            // DataListPage
            _pushPage(context, FlutterBlueApp());
          },
          child: Text("Open BLE"),
        ),
      ),
    );
  }
}

class FlutterBlueApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.lightBlue,
      home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return FindDevicesScreen();
            }
            return BluetoothOffScreen(state: state!,);
          }),
    );
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({ Key? key,required this.state}) : super(key: key);

  final BluetoothState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          Center(
            child: InkWell(
              onTap: () {
                _pushPage(context, DataListPage());
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                child: Text("View Data List"),
              ),
            ),
          )
        ],
      ),
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',

            ),
          ],
        ),
      ),
    );
  }
}

class FindDevicesScreen extends StatefulWidget {
  String title = "itle";

  @override
  _FindDevicesScreenState createState() => _FindDevicesScreenState();
}

class _FindDevicesScreenState extends State<FindDevicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[


            StreamBuilder<List<ScanResult>>(
              stream: FlutterBlue.instance.scanResults,
              initialData: [],
              builder: (c, snapshot) {
                //  updateData(snapshot.data);
                FirebaseFirestore firestore;
                //  Database(firestore: firestore).addData(snapshot.data);

                return Column(
                  children: snapshot.data!
                      .map(
                        (r) => ScanResultTile(
                          result: r,
                          onTap: () => Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            r.device.connect(autoConnect: false);
                            return Scaffold(body: Center(child: Text("Not using"),),);
                          //  return   PerformTestPageActivity(device: r.device, index6: '', testDuration: 0,);
                            Navigator.pop(context);
                            //return ConnectedDevicePage(device: r.device);
                            //return DeviceScreenLessDetails(r.device);
                          })),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot!=null && snapshot.data!=null&& snapshot.data == true) {
            return FloatingActionButton(
              child: Icon(Icons.stop),
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton(
                child: Icon(Icons.search),
                onPressed: () => FlutterBlue.instance
                    .startScan(timeout: Duration(seconds: 4)));
          }
        },
      ),
    );
  }
}

class FindDevicesScreenForTest extends StatefulWidget {
  String title = "itle";
  String projectID;
  FindDevicesScreenForTest({required this.projectID});
  var currentPageValue = 0;
  @override
  _FindDevicesScreenForTestState createState() => _FindDevicesScreenForTestState();
}

class _FindDevicesScreenForTestState extends State<FindDevicesScreenForTest> {
  PageController controller = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 40,
                child: Stack(
                  children: [
                    Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          color:Theme.of(context).primaryColor,
                        )),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        height: 40,
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Row(
                            children: [
                              Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        widget.currentPageValue = 0;
                                        controller.animateToPage(0,
                                            duration: Duration(milliseconds: 500),
                                            curve: Curves.ease);
                                      });
                                    },
                                    child: Container(
                                      color: widget.currentPageValue == 0
                                          ? Theme.of(context).primaryColor
                                          : Colors.white,
                                      child: Center(
                                        child: Text(
                                          "Connected Devices",
                                          style: TextStyle(fontWeight: FontWeight.bold,
                                              color: widget.currentPageValue == 0
                                                  ? Colors.white
                                                  :Theme.of(context).primaryColor),
                                        ),
                                      ),
                                    ),
                                  )),
                              Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        widget.currentPageValue = 1;
                                        controller.animateToPage(1,
                                            duration: Duration(milliseconds: 500),
                                            curve: Curves.ease);
                                      });
                                    },
                                    child: Container(
                                      color: widget.currentPageValue == 1
                                          ?Theme.of(context).primaryColor
                                          : Colors.white,
                                      child: Center(
                                        child: Text("Discovered Devices",
                                            style: TextStyle(fontWeight: FontWeight.bold,
                                                color: widget.currentPageValue == 1
                                                    ? Colors.white
                                                    : Theme.of(context).primaryColor)),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 500,
              child: PageView(
                controller: controller,
                onPageChanged: (number) {
                  setState(() {
                    widget.currentPageValue = number;
                  });
                },
                children: <Widget>[
                  StreamBuilder<List<BluetoothDevice>>(
                    stream: Stream.periodic(Duration(seconds: 2))
                        .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                    initialData: [],
                    builder: (c, snapshot) => Column(
                      children: snapshot.data!
                          .map((d) => ListTile(
                        title: Text(d.name),
                        subtitle: Text(d.id.toString()),
                        trailing: StreamBuilder<BluetoothDeviceState>(
                          stream: d.state,
                          initialData: BluetoothDeviceState.disconnected,
                          builder: (c, snapshot) {
                            if (snapshot.data ==
                                BluetoothDeviceState.connected) {
                              return InkWell(
                                child: Text(
                                  'Perform Test',
                                ),
                                onTap: () => Navigator.of(context).push(
                                  //  MaterialPageRoute(builder: (context) => ConnectedDevicePage(device: d))),
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Scaffold(body: Center(child: Text("Not using")),)),)
                                            //PerformTestPageActivity(device: d,project: widget.projectID,))),

                              );
                            }
                            return Text(snapshot.data.toString());
                          },
                        ),
                      ))
                          .toList(),
                    ),
                  ),
                  StreamBuilder<List<ScanResult>>(
                    stream: FlutterBlue.instance.scanResults,
                    initialData: [],
                    builder: (c, snapshot) {
                      //  updateData(snapshot.data);
                      FirebaseFirestore firestore;
                      //  Database(firestore: firestore).addData(snapshot.data);

                      return Column(
                        children: snapshot.data!
                            .map(
                              (r) => ScanResultTile(
                            result: r,
                            onTap: () => Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              r.device.connect(autoConnect: false);
                              return   Scaffold(body: Center(child: Text("Not using")),);
                              Navigator.pop(context);
                              //return ConnectedDevicePage(device: r.device);
                              //return DeviceScreenLessDetails(r.device);
                            })),
                          ),
                        )
                            .toList(),
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),

      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data!=null && snapshot.data==true) {
            return FloatingActionButton(
              child: Icon(Icons.stop),
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton(
                child: Icon(Icons.search),
                onPressed: () => FlutterBlue.instance
                    .startScan(timeout: Duration(seconds: 4)));
          }
        },
      ),
    );
  }
}



class FindDevicesScreenForSettings extends StatefulWidget {
  String title = "itle";
  var currentPageValue = 0;
  @override
  _FindDevicesScreenForSettingsState createState() => _FindDevicesScreenForSettingsState();
}

class _FindDevicesScreenForSettingsState extends State<FindDevicesScreenForSettings> {
  PageController controller = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 40,
                child: Stack(
                  children: [
                    Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          color:Theme.of(context).primaryColor,
                        )),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        height: 40,
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Row(
                            children: [
                              Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        widget.currentPageValue = 0;
                                        controller.animateToPage(0,
                                            duration: Duration(milliseconds: 500),
                                            curve: Curves.ease);
                                      });
                                    },
                                    child: Container(
                                      color: widget.currentPageValue == 0
                                          ? Theme.of(context).primaryColor
                                          : Colors.white,
                                      child: Center(
                                        child: Text(
                                          "Connected Devices",
                                          style: TextStyle(fontWeight: FontWeight.bold,
                                              color: widget.currentPageValue == 0
                                                  ? Colors.white
                                                  :Theme.of(context).primaryColor),
                                        ),
                                      ),
                                    ),
                                  )),
                              Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        widget.currentPageValue = 1;
                                        controller.animateToPage(1,
                                            duration: Duration(milliseconds: 500),
                                            curve: Curves.ease);
                                      });
                                    },
                                    child: Container(
                                      color: widget.currentPageValue == 1
                                          ?Theme.of(context).primaryColor
                                          : Colors.white,
                                      child: Center(
                                        child: Text("Discovered Devices",
                                            style: TextStyle(fontWeight: FontWeight.bold,
                                                color: widget.currentPageValue == 1
                                                    ? Colors.white
                                                    : Theme.of(context).primaryColor)),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 500,
              child: PageView(
                controller: controller,
                onPageChanged: (number) {
                  setState(() {
                    widget.currentPageValue = number;
                  });
                },
                children: <Widget>[
                  StreamBuilder<List<BluetoothDevice>>(
                    stream: Stream.periodic(Duration(seconds: 2))
                        .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                    initialData: [],
                    builder: (c, snapshot) => Column(
                      children: snapshot.data!
                          .map((d) => ListTile(
                        title: Text(d.name),
                        subtitle: Text(d.id.toString()),
                        trailing: StreamBuilder<BluetoothDeviceState>(
                          stream: d.state,
                          initialData: BluetoothDeviceState.disconnected,
                          builder: (c, snapshot) {
                            if (snapshot.data ==
                                BluetoothDeviceState.connected) {
                              return InkWell(
                                child: Text(
                                  'Open Settings',
                                ),
                                onTap: () => Navigator.of(context).push(
                                  //  MaterialPageRoute(builder: (context) => ConnectedDevicePage(device: d))),
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Scaffold(body: Center(child: Text("Not using")),)),)
                                            //PerformTestPageActivity(device: d))),

                              );
                            }
                            return Text(snapshot.data.toString());
                          },
                        ),
                      ))
                          .toList(),
                    ),
                  ),
                  StreamBuilder<List<ScanResult>>(
                    stream: FlutterBlue.instance.scanResults,
                    initialData: [],
                    builder: (c, snapshot) {
                      //  updateData(snapshot.data);
                      FirebaseFirestore firestore;
                      //  Database(firestore: firestore).addData(snapshot.data);

                      return Column(
                        children: snapshot.data!
                            .map(
                              (r) => ScanResultTile(
                            result: r,
                            onTap: () => Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              r.device.connect(autoConnect: false);
                              return Scaffold(body: Center(child: Text("Not using")),);
                             // return   PerformTestPageActivity(device: r.device);
                              Navigator.pop(context);
                              //return ConnectedDevicePage(device: r.device);
                              //return DeviceScreenLessDetails(r.device);
                            })),
                          ),
                        )
                            .toList(),
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),

      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data!=null && snapshot.data==true) {
            return FloatingActionButton(
              child: Icon(Icons.stop),
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton(
                child: Icon(Icons.search),
                onPressed: () => FlutterBlue.instance
                    .startScan(timeout: Duration(seconds: 4)));
          }
        },
      ),
    );
  }
}

Widget DeviceScreenLessDetails(BluetoothDevice device) {
  Future<void> _calculation() async {
    device.connect().then((value) => {});
  }

  return Scaffold(
    appBar: AppBar(
      title: Text("Details"),
    ),
    body: Center(
      child: Text("Done"),
    ),
  );
}

class DeviceScreen extends StatelessWidget {
  const DeviceScreen({Key? key, required this.device}) : super(key: key);

  final BluetoothDevice device;

  List<int> _getRandomBytes() {
    final math = Random();
    return [
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255)
    ];
  }

  List<Widget> _buildServiceTiles(List<BluetoothService> services) {
    return services
        .map(
          (s) => ServiceTile(
            service: s,
            characteristicTiles: s.characteristics
                .map(
                  (c) => CharacteristicTile(
                    characteristic: c,
                    onReadPressed: () => c.read(),
                    onWritePressed: () async {
                      await c.write(_getRandomBytes(), withoutResponse: OsDependentSettings().writeWithresponse);
                      await c.read();
                    },
                    onNotificationPressed: () async {
                      await c.setNotifyValue(!c.isNotifying);
                      await c.read();
                    },
                    descriptorTiles: c.descriptors
                        .map(
                          (d) => DescriptorTile(
                            descriptor: d,
                            onReadPressed: () => d.read(),
                            onWritePressed: () => d.write(_getRandomBytes()),
                          ),
                        )
                        .toList(),
                  ),
                )
                .toList(),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(device.name),
        actions: <Widget>[
          StreamBuilder<BluetoothDeviceState>(
            stream: device.state,
            initialData: BluetoothDeviceState.connecting,
            builder: (c, snapshot) {
              VoidCallback onPressed;
              String text;
              switch (snapshot.data) {
                case BluetoothDeviceState.connected:
                  onPressed = () => device.connect(autoConnect: false);
                  text = 'CONNECT';
                  break;
                case BluetoothDeviceState.disconnected:
                  onPressed = () => device.connect(autoConnect: false);
                  text = 'CONNECT';
                  break;
                default:

                  text = snapshot.data.toString().substring(21).toUpperCase();
                  break;
              }
              return FlatButton(
                  //  onPressed: onPressed,
                  onPressed: () async {
                    print("connect calling");
                    print("device info ==");

                    print("device info ==");
                    // Connect to the device
                    try {
                      await device.connect(autoConnect: false);
                    } catch (e) {
                      // if (e.code != 'already_connected') {
                      //   throw e;
                      // }
                    } finally {
                      await device.discoverServices();
                    }
                  },
                  child: Text(
                    text,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .button!
                        .copyWith(color: Colors.white),
                  ));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder<List<BluetoothService>>(
              stream: device.services,
              builder: (c, snapshot) {
                if (device.services != null &&
                    snapshot.hasData &&
                    snapshot.data!.length > 0) {
                  printData = "";

                  BluetoothService service = snapshot.data![3];
                  BluetoothCharacteristic cha =
                      snapshot.data![3].characteristics[2];
                  cha.setNotifyValue(true);
                  print("Hope i write here");
                  // print(snapshot.data[3].characteristics[0].uuid.toString());
                  //print(snapshot.data[3].characteristics[0].write(StringToByteArray("GET|1|")));
                  // snapshot.data[3].characteristics[0].write(StringToByteArray("GET|9|mukulDevice")).then((value) => {
                  // print("print done, value is "+value.toString())
                  // });

                  return Center(
                      child: RetrivedValue(
                          cha,
                          snapshot.data![3].uuid.toString(),
                          snapshot.data![3].characteristics[2].uuid.toString()));
                  cha.setNotifyValue(true);
                  cha.value.listen((value) {
                    // do something with new value

                    print(value.toString());
                   // return Text(value.toString());
                  });
                }

                return Text("Please wait");
              },
            ),
            StreamBuilder<BluetoothDeviceState>(
              stream: device.state,
              initialData: BluetoothDeviceState.connecting,
              builder: (c, snapshot) => ListTile(
                leading: (snapshot.data == BluetoothDeviceState.connected)
                    ? Icon(Icons.bluetooth_connected)
                    : Icon(Icons.bluetooth_disabled),
                title: Text(
                    'Device is ${snapshot.data.toString().split('.')[1]}.'),
                subtitle: Text('${device.id}'),
                trailing: StreamBuilder<bool>(
                  stream: device.isDiscoveringServices,
                  initialData: false,
                  builder: (c, snapshot) => IndexedStack(
                    index:(snapshot.data!=null && snapshot.data ==true) ? 1 : 0,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () => device.discoverServices(),
                      ),
                      IconButton(
                        icon: SizedBox(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.grey),
                          ),
                          width: 18.0,
                          height: 18.0,
                        ),
                        onPressed: null,
                      )
                    ],
                  ),
                ),
              ),
            ),
            StreamBuilder<int>(
              stream: device.mtu,
              initialData: 0,
              builder: (c, snapshot) => ListTile(
                title: Text('MTU Size'),
                subtitle: Text('${snapshot.data} bytes'),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => device.requestMtu(223),
                ),
              ),
            ),
            StreamBuilder<List<BluetoothService>>(
              stream: device.services,
              initialData: [],
              builder: (c, snapshot) {
                return Column(
                  children: _buildServiceTiles(snapshot.data!),
                );
              },
            ),
            RaisedButton(
              onPressed: () {
               // _pushPage(context, SensorPage(device: device));
              },
              child: Text("Open Sensor Page"),
            )
          ],
        ),
      ),
    );
  }
}

String convert(List<int> data) {
  String returnValue = "";

  final result = data.map((b) => '${b.toRadixString(16).padLeft(2, '0')}');
  //print('bytes: ${result}');
  HexEncoder _hexEncoder;
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
  return getNumber(f,precision: 1).toString();
}
double getNumber(double input, {int precision = 1}) =>
    double.parse('$input'.substring(0, '$input'.indexOf('.') + precision + 1));
String _dataParser(List<int> dataFromDevice) {
  return utf8.decode(dataFromDevice);
}

String convert2(List<int> data) {
  String returnValue = "";

  final result = data.map((b) => '${b.toRadixString(16).padLeft(2, '0')}');
  print('bytes: ${result}');
  HexEncoder _hexEncoder;
  var bd = ByteData(data.length);
  for (int i = 0; i < data.length; i++) {
    String tempVal = data[i].toRadixString(16).padLeft(2, '0').toString();
    //returnValue = returnValue+tempVal;

    bd.setUint8(i, data[i].toInt());
  }
  var f = bd.getFloat32(0);
  print(f);
  bd.setUint32(0, 0x41480000);
  var f1 = bd.getFloat32(0);
  print(f1);
  // print(_hexEncoder.);
//  returnValue =data[0].toRadixString(16).padLeft(2, '0')+data[0].toRadixString(16).padLeft(2, '0')+data[0].toRadixString(16).padLeft(2, '0')+data[0].toRadixString(16).padLeft(2, '0');
  return f.toString();
}

List<int> StringToByteArray(String input) {
  return utf8.encode(input);
}

void _sendCommandToDevice(BluetoothCharacteristic characteristic) async {
  final command = "AT Z\r";
  final command2 = "SET|9|4321| \r";
  final command3 = "SET|9|4321| \@";
  final command4 = "SET|9|4321| \n";
  final command5 = "SET|9|4321|\n";
  final command6 = "SET|9|4321|@";

  final convertedCommand = AsciiEncoder().convert(command2);
  print("command1 data is  " + convertedCommand.toString());
  print("command2 data is  " + AsciiEncoder().convert(command3).toString());
  print("command3 data is  " + AsciiEncoder().convert(command4).toString());
  print("command4 data is  " + AsciiEncoder().convert(command5).toString());
  print("command5 data is  " + AsciiEncoder().convert(command6).toString());
  //await characteristic.write(convertedCommand);
  await characteristic.write(AsciiEncoder().convert(command6));
  characteristic.write(convertedCommand, withoutResponse: OsDependentSettings().writeWithresponse).then((value) {
    print("write done, response is " + value.toString());
  });
}
