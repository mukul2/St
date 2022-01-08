import 'package:flutter/material.dart';

import 'package:connect/models/BarChartModel.dart';
import 'package:connect/pages/home_page.dart';


class BarChartDemo extends StatefulWidget {
  @override
  _BarChartDemoState createState() => _BarChartDemoState();
}

class _BarChartDemoState extends State<BarChartDemo> {

  final List<BarChartModel> data2 = [
    // BarChartModel(
    //   time: 1,
    //   value: 7.79,
    //   color: charts.ColorUtil.fromDartColor(Color(0xFF47505F)),
    // ),
    // BarChartModel(
    //   time: 2,
    //   value: 7.39,
    //   color: charts.ColorUtil.fromDartColor(Color(0xFF47505F)),
    // ),
    // BarChartModel(
    //   time: 3,
    //   value: 7.69,
    //   color: charts.ColorUtil.fromDartColor(Color(0xFF47505F)),
    // ),
    // BarChartModel(
    //   time: 4,
    //   value: 7.49,
    //   color: charts.ColorUtil.fromDartColor(Color(0xFF47505F)),
    // ),
  ];




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Animated Bar Chart Demo"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),

    );
  }
}