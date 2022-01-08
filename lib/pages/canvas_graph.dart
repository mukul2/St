import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:connect/pages/app_map_view.dart';
import 'package:connect/pages/connected_device_page.dart';
import 'package:connect/pages/graph_widget.dart';
import 'package:connect/pages/home_page.dart';
import 'package:connect/pages/login_page.dart';

import 'package:connect/screens/home.dart';
import 'package:connect/screens/login.dart';
import 'package:connect/services/Signal.dart';
import 'package:connect/services/auth.dart';
import 'package:connect/services/themeManager.dart';
import 'package:connect/streams/AuthControllerStream.dart';
import 'package:connect/widgets.dart';
import 'package:connect/widgets/cu.dart';
import 'package:connect/widgets/line_graph.dart';
import 'package:connect/widgets/sync_gra_n.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
class PathExample extends StatelessWidget {
  List<double> ypos ;
  PathExample({required this.ypos});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PathPainter(ypos: ypos),
    );
  }
}

class PathPainter extends CustomPainter {
  List<double> ypos ;
  PathPainter({required this.ypos});

  @override
  void paint(Canvas canvas, Size size) {
    //List<double> ypos = [10.0, 20.0, 100.0, 60.0, 40.0, 35.0, 80.0]; // random y points
    canvas.translate(0.0, size.height);
    final Path path = new Path();
    final Paint paint = new Paint();
    paint.color = Colors.blue;
    final double center = size.height/2;
    path.moveTo(0.0, 0.0); // first point in bottom left corner of container

    path.lineTo(0.0, - (ypos[0] + center)); // creates a point translated in y inline with leading edge
    final int dividerCnst = ypos.length; // number of points in graph
    for(int i = 1; i < dividerCnst + 1; i++){
      path.lineTo(size.width/dividerCnst * i - size.width/(dividerCnst * 2), - (ypos[i-1] + center));
    }
    path.lineTo(size.width, -(ypos[dividerCnst - 1] + center)); // the last point in line with trailing edge
    path.lineTo(size.width, 0.0); // last point in bottom right corner of container
    path.close();
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}