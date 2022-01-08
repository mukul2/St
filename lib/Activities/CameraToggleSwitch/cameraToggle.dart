import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:core';
import 'dart:core';
import 'dart:ffi';
import 'dart:io';
import "dart:typed_data";
import 'package:camera/camera.dart';
import 'package:connect/Activities/CustomerUserHome/HomePager/appbar.dart';
import 'package:connect/Activities/TestMapScreen/testMapScreen.dart';
import 'package:connect/screens/home.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/colorConst.dart';
import 'package:connect/utils/textConst.dart';
import 'package:connect/utils/textStyleConst.dart';
import 'package:connect/utils/themeManager.dart';
import 'package:convert/convert.dart';
 import 'package:flutter_svg/svg.dart';
 import 'package:connect/labels/appLabels.dart';
import 'package:connect/localization/language/languages.dart';
import 'package:connect/pages/pion.dart';
import 'package:connect/pages/settigs_page.dart';
import 'package:connect/services/Firestoredatabase.dart';
import 'package:connect/services/StorageManager.dart';
import 'package:connect/services/os_dependent_settings.dart';
import 'package:connect/services/themeManager.dart';
import 'package:connect/streams/buttonStreams.dart';
import 'package:connect/widgets/appwidgets.dart';
 import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:connect/pages/TestPeromationActivity.dart';
import 'package:connect/screens/CallWidget.dart';
import 'package:connect/services/Signal.dart';
import 'package:connect/widgets/cu.dart';
import 'package:image_picker/image_picker.dart';

import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:share/share.dart';
import 'dart:ui' as ui;
 import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:connect/models/SavedData.dart';
import 'package:connect/models/todo.dart';
import 'package:connect/pages/TestDetailsPage.dart';
import 'package:connect/pages/app_map_view.dart';
import 'package:connect/pages/connected_device_page.dart';
import 'package:connect/pages/graph_3.dart';
import 'package:connect/pages/home_page.dart';
import 'package:connect/pages/map_view.dart';
import 'package:connect/pages/perform_test.dart';
import 'package:connect/services/auth.dart';
import 'package:connect/services/database.dart';
import 'package:connect/services/restApi.dart';
import 'package:connect/services/show_widgets.dart';
import 'package:connect/widgets/lists_widgets.dart';
import 'package:connect/widgets/todo_card.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
 class CameraToggle extends StatefulWidget {
  bool isPhoto = true;

  Function(bool) isVideoSelected;
  CameraToggle({required this.isVideoSelected,required this.isPhoto,});
  @override
  _CameraToggleState createState() => _CameraToggleState();
}

class _CameraToggleState extends State<CameraToggle> {
  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: (){
      print("Clicked");
      setState(() {
        widget.isPhoto = !widget.isPhoto;
      });
      VideoPhotoToggleStream.getInstance().dataReload(widget.isPhoto);
      widget.isVideoSelected(!widget.isPhoto);
    },
      child: Container(color: Colors.transparent,

        // decoration:  BoxDecoration(
        //   color: ThemeManager().getWhiteColor,
        //   shape: BoxShape.circle),
        width: width * 0.16,
        height: height * 0.045,
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular( width * 0.08),color: Colors.white),
          child: Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Center(child:Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius:widget.isPhoto?5: 0,
                        color:widget.isPhoto?Colors.grey: Colors.white,
                      )
                    ],
                    color: ThemeManager().getWhiteColor,
                    shape: BoxShape.circle),
                child: Icon(
                  Icons.photo_camera,
                  color: widget.isPhoto?ThemeManager().getDarkGreenColor:Colors.grey[400],
                ),
              ) ,)),
              Expanded(child: Center(child:Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius:widget.isPhoto?0: 5,
                        color:widget.isPhoto?Colors.white: Colors.grey,
                      )
                    ],
                    color: ThemeManager().getWhiteColor,
                    shape: BoxShape.circle),
                child: Icon(
                  Icons.videocam_rounded,
                  color: widget.isPhoto?Colors.grey[400]:ThemeManager().getDarkGreenColor,
                ),
              ) ,)),
            ],
          ),
        ),
      ),
    );
  }
}
