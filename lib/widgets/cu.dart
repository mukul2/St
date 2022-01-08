import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connect/streams/buttonStreams.dart';

const Color _colorOne = Color(0x33000000);
const Color _colorTwo = Color(0x24000000);
const Color _colorThree = Color(0x1F000000);


class CupertinoSegmentedControlDemo extends StatefulWidget {
  Map<int, Widget> logoWidgets;
  void Function(int) callback;
  int selected ;
  int val ;
  CupertinoSegmentedControlDemo({required this.logoWidgets,required this.callback,required this.selected,required this.val});

  @override
  _CupertinoSegmentedControlDemoState createState() =>
      _CupertinoSegmentedControlDemoState();
}

class _CupertinoSegmentedControlDemoState
    extends State<CupertinoSegmentedControlDemo> {


  final Map<int, Widget> icons = const <int, Widget>{
    0: Center(
      child: FlutterLogo(
        //colors: Colors.indigo,
        size: 200.0,
      ),
    ),
    1: Center(
      child: FlutterLogo(
       // colors: Colors.teal,
        size: 200.0,
      ),
    ),
    2: Center(
      child: FlutterLogo(
       // colors: Colors.cyan,
        size: 200.0,
      ),
    ),
  };

  int sharedValue = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabMenuSelctorStream.getInstance().outData.listen((event) {
      setState(() {
        sharedValue = event;
      });
    });

  }

  @override
  Widget build(BuildContext context) {




    return Wrap(children: [
      Container(width: MediaQuery.of(context).size.width,
        child: CupertinoSegmentedControl<int>(
          children: widget.logoWidgets,
          onValueChanged: (int val) {
            tabMenuSelctorStream.getInstance().dataReload(val);
            setState(() {
              sharedValue = val;
            });
            widget.callback(val);
          },
          groupValue: sharedValue,
        ),
      )
    ],);
  }
}