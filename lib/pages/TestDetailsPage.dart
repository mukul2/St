import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'dart:math';
import 'package:convert/convert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:connect/models/BarChartModel.dart';
import 'package:connect/models/SavedData.dart';
import 'package:connect/pages/BarChartDemo.dart';
import 'package:connect/pages/data_list.dart';
import 'package:connect/services/database.dart';
import 'package:connect/streams/AuthControllerStream.dart';
import 'package:connect/widgets.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:typed_data';

class TestDetailsPage extends StatefulWidget {
  mData testData ;
  List data = [];
  List<BarChartModel> data2  = [];

  TestDetailsPage(this.testData);

  @override
  _TestDetailsPageState createState() => _TestDetailsPageState();
}

class _TestDetailsPageState extends State<TestDetailsPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      widget.data =   json.decode(widget.testData.value);

      for(int i = 0;i<widget.data.length;i++){
        widget.data2.add(BarChartModel(
          time:  widget.data2.length+1,
          value: widget.data[i],
          color: Colors.red,
        ));
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.testData.todoId),),
      body: SingleChildScrollView(
        // child:  BarChartGraph(
        //   data: widget.data2,
        // )
     ),

    );
  }
}
