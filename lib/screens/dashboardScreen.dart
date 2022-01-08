import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
  import 'package:connect/screens/homeScreen.dart';
import 'package:connect/screens/viewTestsScreen.dart';
import 'package:connect/screens/testMapScreen.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/themeManager.dart';

class BottomNavigationBarScreenNotUsing extends StatefulWidget {
  const BottomNavigationBarScreenNotUsing({Key? key}) : super(key: key);

  @override
  _BottomNavigationBarScreenState createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreenNotUsing> {


  //----------------------Set screens on BottomBar item tap------------------------
  List<Widget> bottomBarScreens() {
    return [
      HomeScreen(),
      TestMapScreen(),
      ViewTestsScreen(),
      Center(
        child: Text("share screen"),
      ),
    ];
  }

  //----------------------------Bottom navigation bar Items--------------------------


  Future checkPermissions() async {
    // var locationStatus = await Permission.location.status;
    // var cameraStatus = await Permission.camera.status;
    // var micStatus = await Permission.microphone.status;
    // if (locationStatus.isDenied ||
    //     cameraStatus.isDenied ||
    //     micStatus.isDenied) {
    //   Map<Permission, PermissionStatus> statuses = await [
    //     Permission.location,
    //     Permission.storage,
    //     Permission.camera,
    //     Permission.microphone,
    //   ].request();
    // }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPermissions();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    //----------------------------Bottom navigation bar View-----------------------
    return Container(width: 0,height: 0,);
  }
}
