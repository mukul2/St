import 'dart:convert';
import 'dart:core';
import 'dart:core';
import 'dart:core';
import 'dart:ffi';
import "dart:typed_data";
import 'package:connect/utils/appConst.dart';
import 'package:convert/convert.dart';
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


import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
class SearchRecords extends StatefulWidget {
  FirebaseFirestore customerFirestore;
  String customerId;
  Locale locale;

  SearchRecords({required this.customerId,required this.customerFirestore,required this.locale});

  List<QueryDocumentSnapshot> all = [];
  List<QueryDocumentSnapshot> filtered = [];

  @override
  _SearchRecordsState createState() => _SearchRecordsState();
}

class _SearchRecordsState extends State<SearchRecords> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      widget.all.clear();
    });
    Api(firestore: widget.customerFirestore).fetchCustomerUsersAllTestRecordWithFirestore(
        uid: FirebaseAuth.instance.currentUser!.uid,
        firestore: widget.customerFirestore)
        .listen((event) {
      setState(() {
        widget.all.clear();
      });
      for (int i = 0; i < event.docs.length; i++) {
        setState(() {
          widget.all.add(event.docs[i]);
          widget.filtered.add(event.docs[i]);
          widget.all.reversed;
          widget.filtered.reversed;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                margin: EdgeInsets.zero,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                              width: 50,
                              height: 50,
                              child: Icon(Icons.chevron_left,size: width * 0.045,))),
                      Container(
                        width: MediaQuery.of(context).size.width - 66,
                        child: TextFormField(
                          onChanged: (val) {
                            setState(() {
                              widget.filtered.clear();
                            });
                            if (val != null &&
                                val.length > 0 &&
                                widget.all.length > 0) {
                              for (int i = 0; i < widget.all.length; i++) {
                                if (widget.all[i].get("name").toString().toLowerCase().contains(val.toLowerCase()) || widget.all[i].get("note").toString().toLowerCase().contains(val.toLowerCase())) {
                                  setState(() {
                                    widget.filtered.add(widget.all[i]);
                                  });
                                } else {}
                              }
                            } else {
                              setState(() {
                                widget.filtered.addAll(widget.all);
                              });
                            }
                          },
                          controller: controller,
                          autofocus: true,
                          decoration: InputDecoration(hintStyle: TextStyle(fontSize: width * 0.040),
                              border: InputBorder.none, hintText: "Search"),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              ListView.separated(
                reverse: true,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: widget.filtered.length,
                itemBuilder: (_, index) {
                  return InkWell(
                    onTap: () {
                      AppWidgets(customerId:     widget.customerId,customerFirestore:
                      widget.customerFirestore ). showTestRecordBody(

                          widget.filtered[index].id,
                          widget.filtered[index],
                          context,widget.locale,2);
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0,0,10,0),
                          child: Container(
                            margin: EdgeInsets.only(
                              left: width * 0.04,
                              right: width * 0.02,

                            ),
                            child: Image.asset("assets/svg/gr.png",width: width * 0.040,),
                            // child: SvgPicture.asset(
                            //   ("assets/svg/gr.svg"),
                            //   fit: BoxFit.cover,
                            // ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                          child: Container(
                            width: MediaQuery.of(context).size.width - 100,
                            child: Wrap(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(0, 3, 0, 3),
                                    child: Text(
                                      widget.filtered[index].get("name"),
                                      style: TextStyle(fontSize:  width * 0.040,

                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(0, 3, 0, 3),
                                    child: Text(
                                      DateFormat('hh:mm aa MMM dd').format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              widget.filtered[index]["time"])),
                                      style: TextStyle(fontSize:  width * 0.040,),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}