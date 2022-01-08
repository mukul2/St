import 'dart:convert';
import 'dart:core';
import 'dart:core';
import 'dart:core';
import 'dart:ffi';
import "dart:typed_data";
import 'package:connect/Activities/CustomerUserHome/FileExplolar/ui_components.dart';
import 'package:connect/Activities/CustomerUserHome/HomePager/SearchRecords/SearchRecords.dart';
import 'package:connect/Activities/CustomerUserHome/HomePager/appbar.dart';
import 'package:connect/Activities/TestViewAllInOneMap/AllTestInMapView.dart';
import 'package:connect/Activities/contstantWidgets/constantWidgets.dart';
import 'package:connect/Appabr/appbar_widget.dart';
import 'package:connect/components/appBarCustom.dart';
import 'package:connect/screens/home.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/featureSettings.dart';
import 'package:connect/utils/textConst.dart';
import 'package:connect/utils/textStyleConst.dart';
import 'package:connect/utils/themeManager.dart';
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

import '../../../DarkThemeManager.dart';
import 'logics.dart';

class FileExplorar2 extends StatefulWidget {
  // String folderParent;
  FirebaseFirestore customerFirestore;
  String customerId;
  Locale locale;
  Widget appbar;

  FileExplorar2({required this.customerFirestore,required this.appbar, required this.customerId, required this.locale});

  int selectedFolderType = 0;

  @override
  _FileExplorarState2 createState() => _FileExplorarState2();
}


class _FileExplorarState2 extends State<FileExplorar2> with AutomaticKeepAliveClientMixin<FileExplorar2>{
  bool didFirstLoad = true;
  PageController _controller = PageController(
    initialPage: 0,
  );

  int selectedTabIndex = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    AppTitleAppbarStream.getInstance().dataReload( TextConst.viewTestsAppbarText);
    return SafeArea(child: Scaffold(  backgroundColor: AppThemeManager().getScaffoldBackgroundColor(),  appBar: PreferredSize(
      preferredSize: AppBar().preferredSize,
      child:  ApplicationAppbar(). getAppbar(title: "Tests"),
    ),body: SingleChildScrollView(

     // physics: ScrollPhysics(),
      child: Column(children: [
      //  ApplicationAppbar(). getAppbar(title: "Tests"),
        Container(margin: EdgeInsets.only(top: height * 0.025,),
          child: InkWell(onTap: (){
            //
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>SearchRecords(locale: widget.locale,customerId: widget.customerId,customerFirestore: widget.customerFirestore,)));
          },
            child: Container(decoration: BoxDecoration(color: AppThemeManager().getSearchBoxColor(),  borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.02)),
              margin: EdgeInsets.only(top: 0,left: width * 0.05,right:width * 0.05,bottom: 0,  ),
              height: height * 0.055,
              width: width,
              child: Center(
                child:  Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8,0, 8, 0),
                      child: Image.asset("assets/icons/searchIcon.png",),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8,0, 8, 0),
                      child: Text("Search",style:TextStyle(fontSize:  width * 0.040,color: AppThemeManager().getSearchTextColor()),),
                    ),
                  ],
                ),
              ),
              // child: Center(
              //   child: TextFormField(enabled: false,
              //     keyboardType: TextInputType.text,
              //     decoration: InputDecoration(
              //       prefixIcon: Image.asset("assets/icons/searchIcon.png"),
              //       hintText: TextConst.searchText,
              //       hintStyle: interMedium.copyWith(
              //           fontSize: width * 0.035,
              //           color: ThemeManager().getLightGrey1Color),
              //       enabledBorder: OutlineInputBorder(
              //           borderSide: BorderSide(
              //             color: Colors.transparent,
              //           ),
              //           borderRadius: BorderRadius.circular(width * 0.014)),
              //       focusedBorder: OutlineInputBorder(
              //           borderSide: BorderSide(
              //             color: Colors.transparent,
              //           ),
              //           borderRadius: BorderRadius.circular(width * 0.014)),
              //       contentPadding: EdgeInsets.symmetric(
              //           vertical: height * 0.0, horizontal: width * 0.045),
              //       fillColor: ThemeManager().getLightGreenTextFieldColor,
              //       filled: true,
              //     ),
              //   ),
              // ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: height * 0.025,left: width * 0.05,right:width * 0.05,bottom: height * 0.025,  ),

          //-------------------TabBar view--------------------
          child: tabBarView(),
        ),
        StreamBuilder<int>(
            stream: FileExplolarLogics().fileExplolarChangeListener().outData,
            //recent
            builder: (context, snapshot) {
              show(int pos){
                switch(pos){
                  case 0 :
                    return UserTestsByRecent( customerFirestore: widget.customerFirestore,
                      customerId: widget.customerId,locale: widget.locale,);
                  case 1 :
                    return  AllFileFolderActivity(
                      customerFirestore: widget.customerFirestore,
                      customerId: widget.customerId,locale: widget.locale,
                    );
                  case 2 :
                  // pinPosition = LatLng(double.parse(widget.allReports.last.get("location")["lat"].toString()),
                  //     double.parse(widget.allReports.last.get("location")["long"].toString()));

                    return  Container(
                        height: height-height*0.35,
                        margin: EdgeInsets.only(left: width * 0.05,right:width * 0.05,  ),
                        // child: Text("Map view is disabled"),
                        child: StreamBuilder(
                          // Initialize FlutterFire:
                            stream: Api(firestore: widget.customerFirestore)
                                .fetchCustomerUsersAllTestRecordWithFirestore(
                                uid: FirebaseAuth.instance.currentUser!.uid,
                                firestore: widget.customerFirestore),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshotHistory) {
                              if (snapshotHistory.hasData &&
                                  snapshotHistory.data!.docs.length > 0) {


                                return  FutureBuilder<List<QueryDocumentSnapshot<Object?>>>(
                                    future: prepareData(snapshotHistory.data!.docs),
                                    builder: (context, snapshot) {
                                      if(snapshot.hasData){
                                        return ViewTestByMapScreen(mapLatLong: snapshot.data!, locale: widget.locale,customerId: widget.customerId,firestore: widget.customerFirestore,);
                                      }else{
                                        return     ConstantWidget().notData();
                                      }
                                    });

                                return MapPage2(
                                  customerId: widget.customerId,
                                  allReports: snapshotHistory.data!.docs,
                                  firestore: widget.customerFirestore, locale: widget.locale,
                                );
                              } else {
                                return  ConstantWidget().notData();;
                              }
                            })

                    );
                  default:
                    return  ConstantWidget().notData();
                }

              }
              if(snapshot.hasData){
                widget.selectedFolderType = snapshot.data!;
                return show(snapshot.data!);

              }else{
                //return Container();
                return show(1);

              }

            })
      ],),
    ),));
     SafeArea(child: Scaffold(backgroundColor: Colors.white,resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(

         // mainAxisAlignment: MainAxisAlignment.start,
         // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.appbar,
            // Container(
            //     child: AppbarView(
            //       appbarTitleText: TextConst.viewTestsAppbarText,
            //     )
            // ),
           // AppBarCustom(appbarTitle: TextConst.viewTestsAppbarText,),
            Container( margin: EdgeInsets.only(
                top: height * 0.025,
              //  left: width * 0.05,
               // right: width * 0.05,
                left: 0,
                right:0
            ),
              child: Column(

                //crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                InkWell(onTap: (){
                 //
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>SearchRecords(locale: widget.locale,customerId: widget.customerId,customerFirestore: widget.customerFirestore,)));
                },
                  child: Container(decoration: BoxDecoration(color: Colors.grey.shade300,  borderRadius: BorderRadius.circular(width * 0.014)),
                    margin: EdgeInsets.only(top: 0,left: width * 0.05,right:width * 0.05,bottom: 0,  ),
                    height: height * 0.045,
                    width: width,
                    child: Center(
                      child:  Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8,0, 8, 0),
                            child: Image.asset("assets/icons/searchIcon.png"),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8,0, 8, 0),
                            child: Text("Search"),
                          ),
                        ],
                      ),
                    ),
                    // child: Center(
                    //   child: TextFormField(enabled: false,
                    //     keyboardType: TextInputType.text,
                    //     decoration: InputDecoration(
                    //       prefixIcon: Image.asset("assets/icons/searchIcon.png"),
                    //       hintText: TextConst.searchText,
                    //       hintStyle: interMedium.copyWith(
                    //           fontSize: width * 0.035,
                    //           color: ThemeManager().getLightGrey1Color),
                    //       enabledBorder: OutlineInputBorder(
                    //           borderSide: BorderSide(
                    //             color: Colors.transparent,
                    //           ),
                    //           borderRadius: BorderRadius.circular(width * 0.014)),
                    //       focusedBorder: OutlineInputBorder(
                    //           borderSide: BorderSide(
                    //             color: Colors.transparent,
                    //           ),
                    //           borderRadius: BorderRadius.circular(width * 0.014)),
                    //       contentPadding: EdgeInsets.symmetric(
                    //           vertical: height * 0.0, horizontal: width * 0.045),
                    //       fillColor: ThemeManager().getLightGreenTextFieldColor,
                    //       filled: true,
                    //     ),
                    //   ),
                    // ),
                  ),
                ),
                // Container(
                //   height: height * 0.045,
                //   width: width,
                //   child: TextFormField(
                //     keyboardType: TextInputType.text,
                //     decoration: InputDecoration(
                //       prefixIcon: Image.asset("assets/icons/searchIcon.png"),
                //       hintText: TextConst.searchText,
                //       hintStyle: interMedium.copyWith(
                //           fontSize: width * 0.035,
                //           color: ThemeManager().getLightGrey1Color),
                //       enabledBorder: OutlineInputBorder(
                //           borderSide: BorderSide(
                //             color: Colors.transparent,
                //           ),
                //           borderRadius: BorderRadius.circular(width * 0.014)),
                //       focusedBorder: OutlineInputBorder(
                //           borderSide: BorderSide(
                //             color: Colors.transparent,
                //           ),
                //           borderRadius: BorderRadius.circular(width * 0.014)),
                //       contentPadding: EdgeInsets.symmetric(
                //           vertical: height * 0.0, horizontal: width * 0.045),
                //       fillColor: ThemeManager().getLightGreenTextFieldColor,
                //       filled: true,
                //     ),
                //   ),
                // ),

                //--------------------TabBar view------------------------
                Container(
                  margin: EdgeInsets.only(top: height * 0.025,left: width * 0.05,right:width * 0.05,bottom: height * 0.025,  ),

                  //-------------------TabBar view--------------------
                  child: tabBarView(),
                ),
                // FileExplolarUI().top_bar_one(),
                //
                // Divider(height: 1),
                // FileExplolarUI().expolar_type_selector(),


                SingleChildScrollView(
                  child: StreamBuilder<int>(
                      stream: FileExplolarLogics().fileExplolarChangeListener().outData,
                      //recent
                      builder: (context, snapshot) {
                        show(int pos){
                          switch(pos){
                            case 0 :
                              return UserTestsByRecent( customerFirestore: widget.customerFirestore,
                                customerId: widget.customerId,locale: widget.locale,);
                            case 1 :
                              return  AllFileFolderActivity(
                                customerFirestore: widget.customerFirestore,
                                customerId: widget.customerId,locale: widget.locale,
                              );
                            case 2 :
                              // pinPosition = LatLng(double.parse(widget.allReports.last.get("location")["lat"].toString()),
                              //     double.parse(widget.allReports.last.get("location")["long"].toString()));

                              return  Container(
                                  height: height-height*0.35,
                                  margin: EdgeInsets.only(left: width * 0.05,right:width * 0.05,  ),
                                  // child: Text("Map view is disabled"),
                                  child: StreamBuilder(
                                    // Initialize FlutterFire:
                                      stream: Api(firestore: widget.customerFirestore)
                                          .fetchCustomerUsersAllTestRecordWithFirestore(
                                          uid: FirebaseAuth.instance.currentUser!.uid,
                                          firestore: widget.customerFirestore),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot> snapshotHistory) {
                                        if (snapshotHistory.hasData &&
                                            snapshotHistory.data!.docs.length > 0) {


                                          return  FutureBuilder<List<QueryDocumentSnapshot<Object?>>>(
                                          future: prepareData(snapshotHistory.data!.docs),
                                          builder: (context, snapshot) {
                                            if(snapshot.hasData){
                                              return ViewTestByMapScreen(mapLatLong: snapshot.data!, locale: widget.locale,customerId: widget.customerId,firestore: widget.customerFirestore,);
                                            }else{
                                              return     ConstantWidget().notData();
                                            }
                                          });

                                          return MapPage2(
                                            customerId: widget.customerId,
                                            allReports: snapshotHistory.data!.docs,
                                            firestore: widget.customerFirestore, locale: widget.locale,
                                          );
                                        } else {
                                          return  ConstantWidget().notData();;
                                        }
                                      })

                                  );
                            default:
                              return  ConstantWidget().notData();
                          }

                        }
                        if(snapshot.hasData){
                          widget.selectedFolderType = snapshot.data!;
                          return show(snapshot.data!);

                        }else{
                          //return Container();
                          return show(1);

                        }

                      }),
                ),
              ],),
            ),





          ],
        ),
      ),
    ));




  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  Widget tabBarView() {
    return DefaultTabController(
      length: 3,
      initialIndex: selectedTabIndex,

      child: Column(
        children: [
          Container(
            height: height * 0.06,
            decoration: BoxDecoration(
             // border: Border.all(color: ThemeManager().getLightGrey1Color, width: 0.1),
              boxShadow: [
                BoxShadow(
                  color: (AppThemeManager().getTabColor()).withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 7,
                  //offset: Offset(0, 1), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.02),
            ),

            child: Material(
              color: AppThemeManager().getTabBaseColor(),
              borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.02),

              child: TabBar(
                  onTap: (index) {

                    FileExplolarLogics().fileExplolarChangeListener().dataReload(index);
                    setState(() {
                      selectedTabIndex = index;
                    });
                  },
                  labelColor: ThemeManager().getWhiteColor,
                  unselectedLabelColor:darkTheme? ThemeManager().getWhiteColor: ThemeManager().getBlackColor,
                  indicator: BoxDecoration(
                      color: (AppThemeManager().getTabColor()),
                      borderRadius: selectedTabIndex == 0
                          ? BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10))
                          : selectedTabIndex == 2
                          ? BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10))
                          : BorderRadius.zero),
                  labelPadding: EdgeInsets.symmetric(horizontal: 0),
                  labelStyle: interMedium.copyWith(fontSize: width * 0.038),
                  tabs: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(color: Colors.grey, width: 0.5),
                        ),
                      ),
                      child: Tab(
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Text(
                            TextConst.last30DaysTabBarText,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(color: Colors.grey, width: 0.5),
                        ),
                      ),
                      child: Tab(
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Text(
                            TextConst.allTabBarText,
                          ),
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          TextConst.byMapTabBarText,
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }

 Future<List<QueryDocumentSnapshot<Object?>>> prepareData(List<QueryDocumentSnapshot<Object?>> docs) {
   return Future.value(docs);
    List returnData = [];
    for(int i = 0 ; i < docs.length ; i ++){
      returnData.add({"id":docs[i].id,"latitude":docs[i].get("location")["lat"], "longitude": docs[i].get("location")["long"]},);
    }
   // return Future.value(returnData);

  }

}