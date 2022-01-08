import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:connect/Activities/videoPlayerActivity.dart';
import 'package:connect/services/Firestoredatabase.dart';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:connect/pages/perform_test.dart';
import 'package:connect/services/config.dart';
import 'package:connect/streams/buttonStreams.dart';
import 'package:connect/widgets/cu.dart';
import 'package:connect/widgets/graph_with_selecttor.dart';
import 'package:connect/widgets/lists_widgets.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
 import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart';
import 'package:connect/models/Chartsample.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:connect/models/BarChartModel.dart';
import 'package:connect/pages/connected_device_page.dart';
import 'package:connect/pages/graph_two.dart';
import 'package:connect/pages/graph_widget.dart';
import 'package:connect/services/database.dart';
import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:image/image.dart' as tt;
import 'package:image_picker/image_picker.dart';
 import 'package:screenshot/screenshot.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'app_map_view.dart';
import 'graph_3.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;



void returnHomePage(BuildContext context) {
 // Navigator.of(context).popUntil((route) => route.isFirst);
}





class SaveSucessActivity extends StatefulWidget {
  SaveSucessActivity({Key? key}) : super(key: key);

  @override
  _SaveSucessActivityState createState() => _SaveSucessActivityState();
}

class _SaveSucessActivityState extends State<SaveSucessActivity> {
  bool didCanceled = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 2000), () {
      if (true) {
        didCanceled = true;
        returnHomePage(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "Record has been saved Successfully",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor),
            ),
          ),
          Center(
            child: InkWell(
              onTap: () {
                didCanceled = true;
                returnHomePage(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Close",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}






