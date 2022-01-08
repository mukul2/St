import 'dart:convert';
import 'dart:core';
import 'dart:core';
import 'dart:core';
import 'dart:ffi';
import "dart:typed_data";
import 'package:connect/Activities/CustomerUserHome/HomePager/ui_components.dart';
import 'package:connect/Activities/contstantWidgets/constantWidgets.dart';
import 'package:connect/Appabr/appbar_widget.dart';
import 'package:connect/DarkThemeManager.dart';
import 'package:connect/Toast/AppToast.dart';
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
import 'package:flutterfire_ui/firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

import '../logics.dart';
import 'SearchRecords/SearchRecords.dart';
import 'appbar.dart';
import 'logics.dart';
class HomeSection extends StatefulWidget {
  FirebaseFirestore customerFirestore;
  int listType = 0;

  List folders = [];
  List records = [];
  String folderParent = "root";
  String customerId;
  String customerName;
  FirebaseAuth auth;
  late QueryDocumentSnapshot<Object?> profile;
  Locale locale;
  Widget appabr;

  late  CollectionReference firestoreFolderRef;

  HomeSection(
      {required this.profile,
        required  this.customerFirestore,
        required this.customerId,
        required this.locale,
        required this.auth,
        required this.appabr,
        required this.customerName});

  @override
  _HomeSectionState createState() => _HomeSectionState();
}

class _HomeSectionState extends State<HomeSection> with AutomaticKeepAliveClientMixin<HomeSection> {
  TextEditingController _folderNameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(false){
      HomePageLogics(firestore: widget.customerFirestore,auth: FirebaseAuth.instance)
          .fetchCustomerUsersLastSixTestRecordWithFirestoreFuture().then((value) {

        List<QueryDocumentSnapshot<Object?>> data =  value.docs;
        // data = data.reversed
        int needToCache = 0;
        int NOneedToCache = 0;
        int loop = 0;

        for(int i = 0 ; i < data.length ; i++){
          loop++;
          Map<String, dynamic> dataOneTest = data[i].data() as Map<String, dynamic>;{
            List photos = [];

            if(dataOneTest.containsKey("gridCount")){

              widget.customerFirestore
                  .collection("pulltest")
                  .doc(data[i].id)
                  .collection("attachments").get().then((value) {
                if(value.docs.length>0){
                  List<QueryDocumentSnapshot> q = value.docs;
                  int photoCount = 0;
                  for(int j = 0 ; j < q.length ; j++){
                    Map<String, dynamic> dataSingleAttachment =q[j].data() as Map<String, dynamic>;
                    if(dataSingleAttachment["type"] == "photo"){
                      photoCount++;
                      photos.add(dataSingleAttachment["photoFile"]);
                    }
                  }
                  //true ||
                  if(photoCount<7 &&  dataOneTest["gridCount"] < photoCount){
                    needToCache++;
                    AppFirestore(firestore:widget.customerFirestore, auth:FirebaseAuth.instance, projectId: widget.customerFirestore.app.options.projectId). makeImageGrid(customerFirestore:widget.customerFirestore,photoLInks: photos,id: data[i].id,);
                  }else{
                    NOneedToCache++;
                    // AppToast().show(message: "No need to cache");
                  }
                }
              });
            }else{
              needToCache++;
              AppFirestore(firestore:widget.customerFirestore, auth:FirebaseAuth.instance, projectId: widget.customerFirestore.app.options.projectId). makeImageGrid(customerFirestore:widget.customerFirestore,photoLInks: photos,id: data[i].id,);

            }
          }
        }

      });
    }

  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    AppTitleAppbarStream.getInstance().dataReload( TextConst.homeAppbarTitleText);

    String getUnit(dynamic dataToShow) {
      try {
        return dataToShow["loadMode"] != null ? dataToShow["loadMode"] : "kN";
      } catch (e) {
        return "kN";
      }
    }

    return Scaffold(backgroundColor: AppThemeManager().getScaffoldBackgroundColor(),   appBar: PreferredSize(
      preferredSize: AppBar().preferredSize,
      child:  ApplicationAppbar(). getAppbar(title: "Home"),
    ),
        body: Column(
          children: [
           // widget.appabr,

            //-------------------------Appbar view------------------------
            // Container(
            //     child: AppbarView(
            //       appbarTitleText: TextConst.homeAppbarTitleText,
            //     )
            // ),

            //-------------------------Screen body view-------------------
        // FutureBuilder(
        // future:  HomePageLogics(firestore: widget.customerFirestore,auth: FirebaseAuth.instance)
        //     .fetchCustomerUsersLastSixTestRecordWithFirestoreFuture(),
        // builder: (BuildContext context,
        //     AsyncSnapshot<QuerySnapshot> snapshotHistoryF) {
        //   if(snapshotHistoryF.connectionState == ConnectionState.done){
        //
        //
        //     List<QueryDocumentSnapshot<Object?>> data =  snapshotHistoryF.data!.docs;
        //     // data = data.reversed
        //     int needToCache = 0;
        //     int NOneedToCache = 0;
        //     int loop = 0;
        //
        //     for(int i = 0 ; i < data.length ; i++){
        //       loop++;
        //       Map<String, dynamic> dataOneTest = data[i].data() as Map<String, dynamic>;{
        //         List photos = [];
        //
        //         if(dataOneTest.containsKey("gridCount")){
        //
        //           widget.customerFirestore
        //               .collection("pulltest")
        //               .doc(data[i].id)
        //               .collection("attachments").get().then((value) {
        //             if(value.docs.length>0){
        //               List<QueryDocumentSnapshot> q = value.docs;
        //               int photoCount = 0;
        //               for(int j = 0 ; j < q.length ; j++){
        //                 Map<String, dynamic> dataSingleAttachment =q[j].data() as Map<String, dynamic>;
        //                 if(dataSingleAttachment["type"] == "photo"){
        //                   photoCount++;
        //                   photos.add(dataSingleAttachment["photoFile"]);
        //                 }
        //               }
        //               //true ||
        //               if(photoCount<7 &&  dataOneTest["gridCount"] < photoCount){
        //                 needToCache++;
        //                  AppFirestore(firestore:widget.customerFirestore, auth:FirebaseAuth.instance, projectId: widget.customerFirestore.app.options.projectId). makeImageGrid(customerFirestore:widget.customerFirestore,photoLInks: photos,id: data[i].id,);
        //               }else{
        //                 NOneedToCache++;
        //                 // AppToast().show(message: "No need to cache");
        //               }
        //             }
        //           });
        //         }else{
        //           needToCache++;
        //            AppFirestore(firestore:widget.customerFirestore, auth:FirebaseAuth.instance, projectId: widget.customerFirestore.app.options.projectId). makeImageGrid(customerFirestore:widget.customerFirestore,photoLInks: photos,id: data[i].id,);
        //
        //         }
        //       }
        //     }
        //
        //     AppToast().show(message: needToCache.toString()+"--"+NOneedToCache.toString()+"by "+loop.toString());
        //
        //
        //     return Expanded(
        //       child: StreamBuilder(
        //         // Initialize FlutterFire:
        //           stream: HomePageLogics(firestore: widget.customerFirestore,auth: FirebaseAuth.instance)
        //               .fetchCustomerUsersLastSixTestRecordWithFirestore(),
        //           builder: (BuildContext context,
        //               AsyncSnapshot<QuerySnapshot> snapshotHistory) {
        //             if (snapshotHistory.hasData && snapshotHistory.data!.docs.length > 0) {
        //               // return Text("ok");
        //
        //
        //               return HomePageUi(firestore: widget.customerFirestore, customerId: widget.customerId).homePageRecentTests( docsN:data,context: context,locale: widget.locale);
        //
        //
        //             } else {
        //               return ConstantWidget().notData();
        //             }
        //           }),
        //     );
        //
        //   }else{
        //     return Scaffold(body: CircularProgressIndicator(),);
        //   }
        // }),


         if(false)   FutureBuilder<BitmapDescriptor>(
                future: BitmapDescriptor.fromAssetImage(
                    ImageConfiguration(), 'assets/icons/mapMarker1Icon.png'),
                builder: (context, snapshotMarker) {
                  if(snapshotMarker.hasData){
                   return Expanded(child: FirestoreListView<Map<String,dynamic>>(

                      //   loadingBuilder: (context){
                      //   return Container(height: 50,width: double.infinity,color: Colors.blue.withOpacity(0.1),child: Center(child: Text("Loading more..",style: TextStyle(color: Colors.black),),),);
                      // },
                      query: HomePageLogics(firestore: widget.customerFirestore,auth: FirebaseAuth.instance)
                          .fetchCustomerUsersLastSixTestRecordWithFirestoreQuery(),
                      itemBuilder: (context, snapshot) {
                        Map<String, dynamic> dataAsMap = snapshot.data();
                        Widget graphIMG = Container(height: height*0.22,
                          width: MediaQuery.of(context).size.width,
                          //dataAsMap.containsKey("graphImageDark")

                          child: Image.memory((darkTheme ) ?( dataAsMap.containsKey("graphImageDark"??"")? base64Decode(dataAsMap["graphImageDark"??""]):(base64Decode(dataAsMap.containsKey("graphImage")?dataAsMap["graphImage"]:""))) : base64Decode(dataAsMap.containsKey("graphImage")?dataAsMap["graphImage"]:"")),
                        );
                        return InkWell(onTap: (){
                          setState(() {

                          });
                          HomePageLogics(firestore:widget.customerFirestore ,context: context,locale: widget.locale,customerId:  widget.customerId).testRecordClickedEventQuery(data: dataAsMap,id:snapshot.id, pos: 0 ,);
                          CustomerHomePageLogic().tabChangedStream.dataReload(0);
                        },
                          child: Container(
                            margin: EdgeInsets.only(top: height*0.02),

                            child: Column(
                              children: [

                                //----------------------User profile image and name header------------------
                                Container(
                                  margin: EdgeInsets.only(left: width*0.04),
                                  child: Row(
                                    children: [
                                      //Image(image: AssetImage(homeScreenData[index]["userProfileImage"])),
                                      CircleAvatar(backgroundColor: AppThemeManager().getAvatarPlaceholderColor() ,),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(left: width*0.038),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(dataAsMap["name"],maxLines: 1,
                                                style: interBold.copyWith(color: AppThemeManager().getTextColor1(),
                                                    fontSize: width * 0.04),
                                              ),

                                              Container(

                                                margin: EdgeInsets.only(top: height*0.007),

                                                child: Text(DateFormat('hh:mm aa dd MMM yyyy',widget.locale.languageCode)
                                                    .format( true? DateTime.fromMillisecondsSinceEpoch(dataAsMap["time"]):DateTime.fromMillisecondsSinceEpoch(dataAsMap["time"])),
                                                  style: interRegular.copyWith(
                                                      fontSize: width * 0.03,
                                                      color: AppThemeManager().getTextColor1(),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      // IconButton(
                                      //   onPressed: (){},
                                      //   splashRadius: 1,
                                      //   icon: SvgPicture.asset("assets/svg/menuButtonIcon.svg"),
                                      // ),
                                    ],
                                  ),
                                ),

                                //----------------------Measurements, time and result data------------------
                                Container(
                                  margin: EdgeInsets.only(top: height * 0.01, left: width * 0.02),

                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(left: width * 0.04),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: width * 0.11,
                                              width: width * 0.11,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: ThemeManager().getLightBlueColor,
                                              ),
                                              child: Image(
                                                  image: AssetImage(
                                                      "assets/icons/peakLoadIcon.png")),
                                            ),
                                            Container(
                                                margin:
                                                EdgeInsets.only(top: height * 0.01),
                                                child: Row(
                                                  children: [
                                                    Text(dataAsMap["loadMode"] == "kN"? dataAsMap["max"].toString():dataAsMap["max"].toInt().toString() ,
                                                      style: interSemiBold.copyWith(color: AppThemeManager().getTextColor1(),
                                                          fontSize: width * 0.04),
                                                    ),
                                                    Container(
                                                        margin: EdgeInsets.only(left: width*0.01),
                                                        child: Text(getUnit(dataAsMap),style: interRegular.copyWith(color: AppThemeManager().getTextColor1(),fontSize: width*0.031),))

                                                  ],
                                                )),
                                            Container(
                                              margin:
                                              EdgeInsets.only(top: height * 0.005),
                                              child: Text("Peak Load",
                                                  style: interRegular.copyWith(
                                                      fontSize: width * 0.03,color: AppThemeManager().getTextColor2(),)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(right: width * 0.02),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: width * 0.11,
                                              width: width * 0.11,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: ThemeManager().getLightOrangeColor,
                                              ),
                                              child: Image(
                                                  image: AssetImage(
                                                      "assets/icons/targetLoadIcon.png")),
                                            ),
                                            Container(
                                                margin:
                                                EdgeInsets.only(top: height * 0.01),
                                                child: Row(
                                                  children: [
                                                    Text(dataAsMap["loadMode"] == "kN"? dataAsMap["targetLoad"].toString():dataAsMap["targetLoad"].toInt().toString(),
                                                      style: interSemiBold.copyWith(color: AppThemeManager().getTextColor1(),
                                                          fontSize: width * 0.04),
                                                    ),
                                                    Container(
                                                        margin: EdgeInsets.only(left: width*0.01),
                                                        child: Text(getUnit(dataAsMap),style: interRegular.copyWith(color: AppThemeManager().getTextColor1(),fontSize: width*0.031),))

                                                  ],
                                                )),
                                            Container(
                                                margin: EdgeInsets.only(
                                                    top: height * 0.005),
                                                child: Text(
                                                  "Target Load",
                                                  style: interRegular.copyWith(
                                                      fontSize: width * 0.03,color: AppThemeManager().getTextColor2(),),
                                                )),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(right: width * 0.04),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: width * 0.11,
                                              width: width * 0.11,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: ThemeManager()
                                                    .getLightBottleGreenColor,
                                              ),
                                              child: Image(
                                                  image: AssetImage(
                                                      "assets/icons/timeIcon.png")),
                                            ),
                                            Container(
                                                margin:
                                                EdgeInsets.only(top: height * 0.01),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      dataAsMap["targetDuration"].toString() ,
                                                      style: interSemiBold.copyWith(color: AppThemeManager().getTextColor1(),
                                                          fontSize: width * 0.04),
                                                    ),
                                                    Container(
                                                        margin: EdgeInsets.only(left: width*0.01),
                                                        child: Text("secs",style: interRegular.copyWith(color: AppThemeManager().getTextColor1(),fontSize: width*0.031),))
                                                  ],
                                                )),
                                            Container(
                                                margin: EdgeInsets.only(
                                                    top: height * 0.005),
                                                child: Text(
                                                  "Time",
                                                  style: interRegular.copyWith(
                                                      fontSize: width * 0.03,
                                                    color: AppThemeManager().getTextColor2(),),
                                                )),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(right: width * 0.07),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: width * 0.11,
                                              width: width * 0.11,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: dataAsMap["startedLoad"] == 0
                                                    ?  Colors.yellow.withOpacity(0.3)
                                                    : (dataAsMap["startedLoad"] >
                                                    0
                                                    ? (dataAsMap["didPassed"]
                                                    ? Colors.green.withOpacity(0.1)
                                                    : Colors.redAccent.withOpacity(0.1))
                                                    :Colors.redAccent.withOpacity(0.1)) ,
                                              ),
                                              child:dataAsMap["startedLoad"] == 0
                                                  ?  Container(

                                                child:Icon(Icons.warning_rounded,color: ThemeManager().getYellowGradientColor,),
                                              )
                                                  : (dataAsMap["startedLoad"] >
                                                  0
                                                  ? (dataAsMap["didPassed"]
                                                  ?  Image(image: AssetImage("assets/icons/passIcon.png"))
                                                  :  Container(

                                                child: Icon(Icons.close_rounded,color: ThemeManager().getRedColor,),
                                              ))
                                                  : Container(

                                                child:Icon(Icons.close_rounded,color: ThemeManager().getRedColor,),
                                              )) ,
                                              // child: Image(image: AssetImage("assets/icons/passIcon.png")),
                                            ),
                                            Container(
                                                margin:
                                                EdgeInsets.only(top: height * 0.01),
                                                child: dataAsMap["startedLoad"] == 0
                                                    ? Text("Not Timed", style: interSemiBold.copyWith( color: AppThemeManager().getTextColor1(),
                                                    fontSize: width * 0.04),
                                                )
                                                    : (dataAsMap["startedLoad"] >
                                                    0
                                                    ? (dataAsMap["didPassed"]
                                                    ? Text(
                                                  "Pass",
                                                  style: interSemiBold.copyWith( color: AppThemeManager().getTextColor1(),
                                                      fontSize: width * 0.04),
                                                )
                                                    : Text("Fail",
                                                    style: interSemiBold.copyWith( color: AppThemeManager().getTextColor1(),
                                                        fontSize: width * 0.04)))
                                                    : Text("Fail",
                                                    style: interSemiBold.copyWith( color: AppThemeManager().getTextColor1(),
                                                        fontSize: width * 0.04)))),
                                            Container(
                                                margin: EdgeInsets.only(
                                                    top: height * 0.005),
                                                child: Text(
                                                  "Result",
                                                  style: interRegular.copyWith(
                                                      fontSize: width * 0.03,
                                                      color: AppThemeManager().getTextColor2()),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                //----------------------Map image and other image slider-------------------

                                Container(
                                  height: height*0.23,
                                  margin: EdgeInsets.only(top: width*0.04),
                                  child: FutureBuilder<QuerySnapshot>(
                                      future: AppFirestore(firestore: widget.customerFirestore, auth: FirebaseAuth.instance,projectId: '').fetchCustomerUsersAllAttachmentFuture(testID:snapshot.id),
                                      // stream: fetchCustomerUsersAllAttachmentStream(
                                      //     testID: widget.id,
                                      //     firestore: widget.customerFirestore),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                          snapshotattachment) {
                                        List<Widget> widgets = [];
                                        // List<Widget> widgetsFullScreen = [];
                                        List<dynamic> allFwi = [];



                                        if (snapshotattachment.connectionState == ConnectionState.done) {
                                          //String markerLink = "https://firebasestorage.googleapis.com/v0/b/staht-connect-322113.appspot.com/o/pin.png?alt=media&token=1b0784fd-202a-47dd-8fe7-4a18ea5e6422";
                                          String markerLink = "https://developers.google.com/maps/documentation/maps-static/images/star.png";

                                          String mapUri2 = "https://maps.googleapis.com/maps/api/staticmap?zoom=8&size=512x512&maptype=normal&markers=icon:https%3A%2F%2Ffirebasestorage.googleapis.com%2Fv0%2Fb%2Fstaht-connect-322113.appspot.com%2Fo%2FmapMarker1Icon.png%3Falt%3Dmedia%26token%3D29e63d7e-2a40-46ec-ac38-740c4b22435d|52.462375848649536,%20-2.1703763865421832&key=AIzaSyDOrDoiG0aLER7Y8cv2QhNr182Z0H5pMVw";


                                          //     return Text("Image size "+snapshotattachment.data.length.toString());
                                          String mapUriStyled = "https://maps.googleapis.com/maps/api/staticmap?size=512x512&zoom=15&center=Brooklyn&style=feature:road.local%7Celement:geometry%7Ccolor:0x00ff00&style=feature:landscape%7Celement:geometry.fill%7Ccolor:0x000000&style=element:labels%7Cinvert_lightness:true&style=feature:road.arterial%7Celement:labels%7Cinvert_lightness:false&key=AIzaSyDOrDoiG0aLER7Y8cv2QhNr182Z0H5pMVw";
                                          String mapUri = "https://maps.googleapis.com/maps/api/staticmap?center=" +
                                              dataAsMap["location"]["lat"]
                                                  .toString() +
                                              "," +
                                              dataAsMap["location"]["long"]
                                                  .toString() +
                                              "&zoom=8&size=" +
                                              ( width * 0.88).toStringAsFixed(0)+
                                              "x"+
                                          ( height * 0.21).toStringAsFixed(0)


                                               +"&maptype=normal"+
                                                  "&markers=anchor:center|"+
                                              "icon:https%3A%2F%2Ffirebasestorage.googleapis.com%2Fv0%2Fb%2Fstaht-connect-322113.appspot.com%2Fo%2FmapMarker1Icon.png%3Falt%3Dmedia%26token%3D29e63d7e-2a40-46ec-ac38-740c4b22435d|"+
                                              dataAsMap["location"]["lat"]
                                                  .toString() +
                                              "," +
                                              dataAsMap["location"]["long"]
                                                  .toString() +
                                              "&key=AIzaSyDOrDoiG0aLER7Y8cv2QhNr182Z0H5pMVw"+"&map_id="+(darkTheme?"90b3e5c6b64b6c5e":"");
                                          //
                                          // GoogleMap mapWidget  = GoogleMap(myLocationButtonEnabled: false,mapToolbarEnabled: false,
                                          //   initialCameraPosition: CameraPosition(
                                          //     target: LatLng(dataAsMap["location"]["lat"],
                                          //         dataAsMap["location"]["long"]),
                                          //     zoom: 8,
                                          //   ),
                                          //   markers: {
                                          //     Marker(
                                          //       markerId: MarkerId(snapshot.id),
                                          //       position: LatLng(dataAsMap["location"]["lat"],
                                          //           dataAsMap["location"]["long"]),
                                          //       icon: snapshotMarker.data!,
                                          //     ),
                                          //   },
                                          //
                                          //   // zoomControlsEnabled: false,
                                          //   // zoomGesturesEnabled: false,
                                          // );



                                          //Uint8List mapIMage = base64Decode(dataToShow["mapImage"]);

                                          Widget mapWidget = Image.network(mapUri,fit: BoxFit.cover, height: height * 0.21, width: width * 0.88,);
                                          widgets.add(InkWell(onTap: (){
                                            //show this in dialog
                                            print("show map in dialog");
                                            // showDialog(context: context,
                                            //     builder: (BuildContext context){
                                            //       return Dialog(
                                            //         shape: RoundedRectangleBorder(
                                            //           borderRadius: BorderRadius.circular(2),
                                            //         ),
                                            //         elevation: 0,
                                            //         backgroundColor: Colors.transparent,
                                            //         child: Stack(children: [
                                            //           Align(alignment: Alignment.center,child: mapWidget,),
                                            //           Positioned(top: 15,left: 15,child: InkWell(onTap: (){
                                            //             Navigator.pop(context);
                                            //           },
                                            //             child: Card(shape: RoundedRectangleBorder(
                                            //                 borderRadius: BorderRadius.circular(20.0),
                                            //           ),color: ThemeManager().getDarkGreenColor,child: Container(width: 40,height: 40,child: Center(child :Icon(Icons.arrow_back,color: Colors.white,)),),) ,
                                            //           ),),
                                            //
                                            //
                                            //
                                            //         ],),
                                            //       );
                                            //     }
                                            // );
                                          },
                                            child: Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: Container(
                                                  height: height * 0.21,
                                                  width: width * 0.88,
                                                  child: Stack(children: [
                                                    Align(child: mapWidget,),
                                                    Align(child:InkWell(onTap: (){
                                                      print("show map in dialog 12");
                                                      showDialog(context: context,
                                                          builder: (BuildContext context){
                                                            return Dialog(
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(2),
                                                              ),
                                                              elevation: 0,
                                                              backgroundColor: Colors.transparent,
                                                              child:  Stack(children: [
                                                                Align(alignment: Alignment.center,child:  GoogleMap(myLocationButtonEnabled: false,mapToolbarEnabled: false,
                                                                  initialCameraPosition: CameraPosition(
                                                                    target: LatLng(dataAsMap["location"]["lat"],
                                                                        dataAsMap["location"]["long"]),
                                                                    zoom: 8,
                                                                  ),
                                                                  markers: {
                                                                    Marker(
                                                                      markerId: MarkerId(snapshot.id),
                                                                      position: LatLng(dataAsMap["location"]["lat"],
                                                                          dataAsMap["location"]["long"]),
                                                                      icon: snapshotMarker.data!,
                                                                    ),
                                                                  },

                                                                  // zoomControlsEnabled: false,
                                                                  // zoomGesturesEnabled: false,
                                                                ),),
                                                                Positioned(top: 15,left: 15,child: InkWell(onTap: (){
                                                                  Navigator.pop(context);
                                                                },
                                                                  child: Card(elevation: 8,shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(20.0),
                                                                  ),color: ThemeManager().getDarkGreenColor,child: Container(width: 40,height: 40,child: Center(child :Icon(Icons.arrow_back,color: Colors.white,)),),) ,
                                                                ),),



                                                              ],),
                                                            );
                                                          }
                                                      );
                                                    },
                                                      child: Container(  height: height * 0.21,
                                                        width: width * 0.88 ,),
                                                    )),


                                                  ],)),
                                              // child: Image.network(mapUri,fit: BoxFit.cover,)),
                                            ),
                                          ));
                                          widgets.add(Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Container(
                                                height: height * 0.21,
                                                width: width * 0.88,
                                                //  child: Image.memory(base64Decode(dataToShow["graphImage"],),)),
                                                //child: snapshotGraph.data
                                                child: graphIMG
                                            ),
                                          ));
                                          for (int q = 0; q < snapshotattachment.data!.docs.length; q++) {
                                            // for (int q = snapshotattachment.data.docs.length-1; q >= snapshotattachment.data.docs.length; q--) {
                                            // String partId = snapshotattachment.data.docs[q].id;
                                            List allOnlyPhoto = [];
                                            if (snapshotattachment.data!.docs[q].get("type")=="photo") {
                                              allOnlyPhoto.add(snapshotattachment.data!.docs[q].get("photoFile"));
                                              Widget wI = Image.network(snapshotattachment.data!.docs[q].get("photoFile"),fit: BoxFit.cover,);

                                              widgets.add( InkWell(onTap: (){

                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>SafeArea(child: Scaffold(body: Column(children: [

                                                          ApplicationAppbar().getAppbar(title: "Photo"),
                                                          Stack(children: [
                                                            Align(alignment: Alignment.center,child: wI,),
                                                            Positioned(top: 15,left: 15,child: InkWell(onTap: (){
                                                              Navigator.pop(context);
                                                            },
                                                              child: Card(elevation: 8,shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(20.0),
                                                              ),color: ThemeManager().getDarkGreenColor,child: Container(width: 40,height: 40,child: Center(child :Icon(Icons.arrow_back,color: Colors.white,)),),) ,
                                                            ),),



                                                          ],)
                                                        ],),))));

                                              },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: Container(
                                                    // height: height*0.7,
                                                    //width: width*0.9,
                                                      child: wI),
                                                ),
                                              ));





                                              // widgetsFullScreen.add(wI);
                                              //widgetsFullScreen
                                              // allFwi.add({
                                              //   "wid": wI,
                                              //   "time": snapshotattachment
                                              //       .data!.docs[q]
                                              //       .get("time"),
                                              // });
                                              // AttachmentsAddedListener.getInstance()
                                              //     .dataReload(allFwi);

                                            } else {
                                              // Widget video = PlayVideoAutoPlayFromUrl(autoPlay: false,mute: true,name: snapshotattachment.data!.docs[q].get("videoFile"),);
                                              //  Widget video = Center(child: Icon(Icons.play_arrow_outlined),);
                                              //snapshotattachment.data.docs[q].get("type")
                                              //  widgets.add(PlayVideoFromUrl(name: snapshotattachment.data.docs[q].get("type"),));

                                              // widgetsFullScreen.add(video);
                                              //widgetsFullScreen
                                              // allFwi.add({
                                              //   "wid": video,
                                              //   "time": snapshotattachment
                                              //       .data!.docs[q]
                                              //       .get("time"),
                                              // });
                                              // AttachmentsAddedListener.getInstance()
                                              //     .dataReload(allFwi);
                                              widgets.add( InkWell(onTap: (){


                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>Scaffold(body:Center(child: PlayVideoAutoPlayFromUrl(autoPlay: true,mute: false,name: snapshotattachment.data!.docs[q].get("videoFile"),),)) ),);

                                              },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: Container(
                                                    //height: height*0.7,
                                                    // width: width*0.9,
                                                      child: PlayVideoAutoPlayFromUrl(autoPlay: true,mute: true,name: snapshotattachment.data!.docs[q].get("videoFile"),)),
                                                ),
                                              ));
                                            }





                                          }



                                          ListView r = ListView(
                                            scrollDirection: Axis.horizontal,
                                            children: widgets,
                                          );
                                          return Container(
                                            // height: 130,
                                            child: r,
                                          );

                                        } else
                                          return Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Container(
                                                height: height * 0.21,
                                                width: width * 1,
                                                //   child: Image.memory(base64Decode(dataToShow["graphImage"],),)),
                                                child: Center(child: CircularProgressIndicator(),)),
                                          );
                                      }),
                                ),
                              ],
                            ),
                          ),
                        );

                        /*   return  FutureBuilder<BitmapDescriptor>(
                    future: BitmapDescriptor.fromAssetImage(
                        ImageConfiguration(), 'assets/icons/mapMarker1Icon.png'),
                    builder: (context, snapshotMarker) {
                      if(snapshotMarker.hasData){
                        Map<String, dynamic> dataAsMap = snapshot.data();
                        // MemoryImage mI = MemoryImage(base64Decode(dataAsMap["graphImage"]))
                        Widget graphIMG = Container(height: height*0.22,
                          width: MediaQuery.of(context).size.width,
                          child: Image.memory(base64Decode(dataAsMap["graphImage"])),);
                        return InkWell(onTap: (){
                          HomePageLogics(firestore:widget.customerFirestore ,context: context,locale: widget.locale,customerId:  widget.customerId).testRecordClickedEventQuery(data: dataAsMap,id:snapshot.id, pos: 0 ,);
                          CustomerHomePageLogic().tabChangedStream.dataReload(0);
                        },
                          child: Container(
                            margin: EdgeInsets.only(top: height*0.02),

                            child: Column(
                              children: [

                                //----------------------User profile image and name header------------------
                                Container(
                                  margin: EdgeInsets.only(left: width*0.04),
                                  child: Row(
                                    children: [
                                      //Image(image: AssetImage(homeScreenData[index]["userProfileImage"])),
                                      CircleAvatar(),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(left: width*0.038),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(dataAsMap["name"],maxLines: 1,
                                                style: interBold.copyWith(
                                                    fontSize: width * 0.04),
                                              ),

                                              Container(

                                                margin: EdgeInsets.only(top: height*0.007),

                                                child: Text(DateFormat('hh:mm aa dd MMM yyyy',widget.locale.languageCode)
                                                    .format( true? DateTime.fromMillisecondsSinceEpoch(dataAsMap["time"]):DateTime.fromMillisecondsSinceEpoch(dataAsMap["time"])),
                                                  style: interRegular.copyWith(
                                                      fontSize: width * 0.03,
                                                      color: ThemeManager().getBlackColor
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      // IconButton(
                                      //   onPressed: (){},
                                      //   splashRadius: 1,
                                      //   icon: SvgPicture.asset("assets/svg/menuButtonIcon.svg"),
                                      // ),
                                    ],
                                  ),
                                ),

                                //----------------------Measurements, time and result data------------------
                                Container(
                                  margin: EdgeInsets.only(top: height * 0.01, left: width * 0.02),

                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(left: width * 0.04),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: width * 0.11,
                                              width: width * 0.11,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: ThemeManager().getLightBlueColor,
                                              ),
                                              child: Image(
                                                  image: AssetImage(
                                                      "assets/icons/peakLoadIcon.png")),
                                            ),
                                            Container(
                                                margin:
                                                EdgeInsets.only(top: height * 0.01),
                                                child: Row(
                                                  children: [
                                                    Text(dataAsMap["loadMode"] == "kN"? dataAsMap["max"].toString():dataAsMap["max"].toInt().toString() ,
                                                      style: interSemiBold.copyWith(
                                                          fontSize: width * 0.04),
                                                    ),
                                                    Container(
                                                        margin: EdgeInsets.only(left: width*0.01),
                                                        child: Text(getUnit(dataAsMap),style: interRegular.copyWith(fontSize: width*0.031),))

                                                  ],
                                                )),
                                            Container(
                                              margin:
                                              EdgeInsets.only(top: height * 0.005),
                                              child: Text("Peak Load",
                                                  style: interRegular.copyWith(
                                                      fontSize: width * 0.03,
                                                      color: ThemeManager().getBlackColor)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(right: width * 0.02),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: width * 0.11,
                                              width: width * 0.11,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: ThemeManager().getLightOrangeColor,
                                              ),
                                              child: Image(
                                                  image: AssetImage(
                                                      "assets/icons/targetLoadIcon.png")),
                                            ),
                                            Container(
                                                margin:
                                                EdgeInsets.only(top: height * 0.01),
                                                child: Row(
                                                  children: [
                                                    Text(dataAsMap["loadMode"] == "kN"? dataAsMap["targetLoad"].toString():dataAsMap["targetLoad"].toInt().toString(),
                                                      style: interSemiBold.copyWith(
                                                          fontSize: width * 0.04),
                                                    ),
                                                    Container(
                                                        margin: EdgeInsets.only(left: width*0.01),
                                                        child: Text(getUnit(dataAsMap),style: interRegular.copyWith(fontSize: width*0.031),))

                                                  ],
                                                )),
                                            Container(
                                                margin: EdgeInsets.only(
                                                    top: height * 0.005),
                                                child: Text(
                                                  "Target Load",
                                                  style: interRegular.copyWith(
                                                      fontSize: width * 0.03,
                                                      color: ThemeManager().getBlackColor),
                                                )),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(right: width * 0.04),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: width * 0.11,
                                              width: width * 0.11,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: ThemeManager()
                                                    .getLightBottleGreenColor,
                                              ),
                                              child: Image(
                                                  image: AssetImage(
                                                      "assets/icons/timeIcon.png")),
                                            ),
                                            Container(
                                                margin:
                                                EdgeInsets.only(top: height * 0.01),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      dataAsMap["targetDuration"].toString() ,
                                                      style: interSemiBold.copyWith(
                                                          fontSize: width * 0.04),
                                                    ),
                                                    Container(
                                                        margin: EdgeInsets.only(left: width*0.01),
                                                        child: Text("secs",style: interRegular.copyWith(fontSize: width*0.031),))
                                                  ],
                                                )),
                                            Container(
                                                margin: EdgeInsets.only(
                                                    top: height * 0.005),
                                                child: Text(
                                                  "Time",
                                                  style: interRegular.copyWith(
                                                      fontSize: width * 0.03,
                                                      color: ThemeManager().getBlackColor),
                                                )),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(right: width * 0.07),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: width * 0.11,
                                              width: width * 0.11,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: dataAsMap["startedLoad"] == 0
                                                    ?  Colors.yellow.withOpacity(0.3)
                                                    : (dataAsMap["startedLoad"] >
                                                    0
                                                    ? (dataAsMap["didPassed"]
                                                    ? Colors.green.withOpacity(0.1)
                                                    : Colors.redAccent.withOpacity(0.1))
                                                    :Colors.redAccent.withOpacity(0.1)) ,
                                              ),
                                              child:dataAsMap["startedLoad"] == 0
                                                  ?  Container(

                                                child:Icon(Icons.warning_rounded,color: ThemeManager().getYellowGradientColor,),
                                              )
                                                  : (dataAsMap["startedLoad"] >
                                                  0
                                                  ? (dataAsMap["didPassed"]
                                                  ?  Image(image: AssetImage("assets/icons/passIcon.png"))
                                                  :  Container(

                                                child: Icon(Icons.close_rounded,color: ThemeManager().getRedColor,),
                                              ))
                                                  : Container(

                                                child:Icon(Icons.close_rounded,color: ThemeManager().getRedColor,),
                                              )) ,
                                              // child: Image(image: AssetImage("assets/icons/passIcon.png")),
                                            ),
                                            Container(
                                                margin:
                                                EdgeInsets.only(top: height * 0.01),
                                                child: dataAsMap["startedLoad"] == 0
                                                    ? Text("Not Timed")
                                                    : (dataAsMap["startedLoad"] >
                                                    0
                                                    ? (dataAsMap["didPassed"]
                                                    ? Text(
                                                  "Pass",
                                                  style: interSemiBold.copyWith(
                                                      fontSize: width * 0.04),
                                                )
                                                    : Text("Fail",
                                                    style: interSemiBold.copyWith(
                                                        fontSize: width * 0.04)))
                                                    : Text("Fail",
                                                    style: interSemiBold.copyWith(
                                                        fontSize: width * 0.04)))),
                                            Container(
                                                margin: EdgeInsets.only(
                                                    top: height * 0.005),
                                                child: Text(
                                                  "Result",
                                                  style: interRegular.copyWith(
                                                      fontSize: width * 0.03,
                                                      color: ThemeManager().getBlackColor),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                //----------------------Map image and other image slider-------------------

                                Container(
                                  height: height*0.23,
                                  margin: EdgeInsets.only(top: width*0.04),
                                  child: FutureBuilder<QuerySnapshot>(
                                      future: AppFirestore(firestore: widget.customerFirestore, auth: FirebaseAuth.instance,projectId: '').fetchCustomerUsersAllAttachmentFuture(testID:snapshot.id),
                                      // stream: fetchCustomerUsersAllAttachmentStream(
                                      //     testID: widget.id,
                                      //     firestore: widget.customerFirestore),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                          snapshotattachment) {
                                        List<Widget> widgets = [];
                                        // List<Widget> widgetsFullScreen = [];
                                        List<dynamic> allFwi = [];



                                        if (snapshotattachment.connectionState == ConnectionState.done) {
                                          //String markerLink = "https://firebasestorage.googleapis.com/v0/b/staht-connect-322113.appspot.com/o/pin.png?alt=media&token=1b0784fd-202a-47dd-8fe7-4a18ea5e6422";
                                          String markerLink = "https://developers.google.com/maps/documentation/maps-static/images/star.png";

                                          String mapUri2 = "https://maps.googleapis.com/maps/api/staticmap?zoom=8&size=512x512&maptype=normal&markers=icon:https%3A%2F%2Ffirebasestorage.googleapis.com%2Fv0%2Fb%2Fstaht-connect-322113.appspot.com%2Fo%2FmapMarker1Icon.png%3Falt%3Dmedia%26token%3D29e63d7e-2a40-46ec-ac38-740c4b22435d|52.462375848649536,%20-2.1703763865421832&key=AIzaSyDOrDoiG0aLER7Y8cv2QhNr182Z0H5pMVw";


                                          //     return Text("Image size "+snapshotattachment.data.length.toString());
                                          String mapUri = "https://maps.googleapis.com/maps/api/staticmap?center=" +
                                              dataAsMap["location"]["lat"]
                                                  .toString() +
                                              "," +
                                              dataAsMap["location"]["long"]
                                                  .toString() +
                                              "&zoom=12&size=" +
                                              (1024).toStringAsFixed(0)+
                                              "x480&markers="+
                                              "icon:https%3A%2F%2Ffirebasestorage.googleapis.com%2Fv0%2Fb%2Fstaht-connect-322113.appspot.com%2Fo%2FmapMarker1Icon.png%3Falt%3Dmedia%26token%3D29e63d7e-2a40-46ec-ac38-740c4b22435d|"+
                                              dataAsMap["location"]["lat"]
                                                  .toString() +
                                              "," +
                                              dataAsMap["location"]["long"]
                                                  .toString() +
                                              "&key=AIzaSyDOrDoiG0aLER7Y8cv2QhNr182Z0H5pMVw";
                                          //
                                          // GoogleMap mapWidget  = GoogleMap(myLocationButtonEnabled: false,mapToolbarEnabled: false,
                                          //   initialCameraPosition: CameraPosition(
                                          //     target: LatLng(dataAsMap["location"]["lat"],
                                          //         dataAsMap["location"]["long"]),
                                          //     zoom: 8,
                                          //   ),
                                          //   markers: {
                                          //     Marker(
                                          //       markerId: MarkerId(snapshot.id),
                                          //       position: LatLng(dataAsMap["location"]["lat"],
                                          //           dataAsMap["location"]["long"]),
                                          //       icon: snapshotMarker.data!,
                                          //     ),
                                          //   },
                                          //
                                          //   // zoomControlsEnabled: false,
                                          //   // zoomGesturesEnabled: false,
                                          // );



                                          //Uint8List mapIMage = base64Decode(dataToShow["mapImage"]);

                                           Widget mapWidget = Image.network(mapUri,fit: BoxFit.cover, height: height * 0.21, width: width * 0.88,);
                                          widgets.add(InkWell(onTap: (){
                                            //show this in dialog
                                            print("show map in dialog");
                                            // showDialog(context: context,
                                            //     builder: (BuildContext context){
                                            //       return Dialog(
                                            //         shape: RoundedRectangleBorder(
                                            //           borderRadius: BorderRadius.circular(2),
                                            //         ),
                                            //         elevation: 0,
                                            //         backgroundColor: Colors.transparent,
                                            //         child: Stack(children: [
                                            //           Align(alignment: Alignment.center,child: mapWidget,),
                                            //           Positioned(top: 15,left: 15,child: InkWell(onTap: (){
                                            //             Navigator.pop(context);
                                            //           },
                                            //             child: Card(shape: RoundedRectangleBorder(
                                            //                 borderRadius: BorderRadius.circular(20.0),
                                            //           ),color: ThemeManager().getDarkGreenColor,child: Container(width: 40,height: 40,child: Center(child :Icon(Icons.arrow_back,color: Colors.white,)),),) ,
                                            //           ),),
                                            //
                                            //
                                            //
                                            //         ],),
                                            //       );
                                            //     }
                                            // );
                                          },
                                            child: Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: Container(
                                                  height: height * 0.21,
                                                  width: width * 0.88,
                                                  child: Stack(children: [
                                                    Align(child: mapWidget,),
                                                    Align(child:InkWell(onTap: (){
                                                      print("show map in dialog 12");
                                                      showDialog(context: context,
                                                          builder: (BuildContext context){
                                                            return Dialog(
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(2),
                                                              ),
                                                              elevation: 0,
                                                              backgroundColor: Colors.transparent,
                                                              child:  Stack(children: [
                                                                Align(alignment: Alignment.center,child:  GoogleMap(myLocationButtonEnabled: false,mapToolbarEnabled: false,
                                                                  initialCameraPosition: CameraPosition(
                                                                    target: LatLng(dataAsMap["location"]["lat"],
                                                                        dataAsMap["location"]["long"]),
                                                                    zoom: 8,
                                                                  ),
                                                                  markers: {
                                                                    Marker(
                                                                      markerId: MarkerId(snapshot.id),
                                                                      position: LatLng(dataAsMap["location"]["lat"],
                                                                          dataAsMap["location"]["long"]),
                                                                      icon: snapshotMarker.data!,
                                                                    ),
                                                                  },

                                                                  // zoomControlsEnabled: false,
                                                                  // zoomGesturesEnabled: false,
                                                                ),),
                                                                Positioned(top: 15,left: 15,child: InkWell(onTap: (){
                                                                  Navigator.pop(context);
                                                                },
                                                                  child: Card(elevation: 8,shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(20.0),
                                                                  ),color: ThemeManager().getDarkGreenColor,child: Container(width: 40,height: 40,child: Center(child :Icon(Icons.arrow_back,color: Colors.white,)),),) ,
                                                                ),),



                                                              ],),
                                                            );
                                                          }
                                                      );
                                                    },
                                                      child: Container(  height: height * 0.21,
                                                        width: width * 0.88 ,),
                                                    )),


                                                  ],)),
                                              // child: Image.network(mapUri,fit: BoxFit.cover,)),
                                            ),
                                          ));
                                          widgets.add(Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Container(
                                                height: height * 0.21,
                                                width: width * 0.88,
                                                //  child: Image.memory(base64Decode(dataToShow["graphImage"],),)),
                                                //child: snapshotGraph.data
                                                child: graphIMG
                                            ),
                                          ));
                                          for (int q = 0; q < snapshotattachment.data!.docs.length; q++) {
                                            // for (int q = snapshotattachment.data.docs.length-1; q >= snapshotattachment.data.docs.length; q--) {
                                            // String partId = snapshotattachment.data.docs[q].id;
                                            List allOnlyPhoto = [];
                                            if (snapshotattachment.data!.docs[q].get("type")=="photo") {
                                              allOnlyPhoto.add(snapshotattachment.data!.docs[q].get("photoFile"));
                                              Widget wI = Image.network(snapshotattachment.data!.docs[q].get("photoFile"),fit: BoxFit.cover,);

                                              widgets.add( InkWell(onTap: (){

                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>SafeArea(child: Scaffold(body: Column(children: [

                                                          ApplicationAppbar().getAppbar(title: "Photo"),
                                                          Stack(children: [
                                                            Align(alignment: Alignment.center,child: wI,),
                                                            Positioned(top: 15,left: 15,child: InkWell(onTap: (){
                                                              Navigator.pop(context);
                                                            },
                                                              child: Card(elevation: 8,shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(20.0),
                                                              ),color: ThemeManager().getDarkGreenColor,child: Container(width: 40,height: 40,child: Center(child :Icon(Icons.arrow_back,color: Colors.white,)),),) ,
                                                            ),),



                                                          ],)
                                                        ],),))));

                                              },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: Container(
                                                    // height: height*0.7,
                                                    //width: width*0.9,
                                                      child: wI),
                                                ),
                                              ));





                                              // widgetsFullScreen.add(wI);
                                              //widgetsFullScreen
                                              // allFwi.add({
                                              //   "wid": wI,
                                              //   "time": snapshotattachment
                                              //       .data!.docs[q]
                                              //       .get("time"),
                                              // });
                                              // AttachmentsAddedListener.getInstance()
                                              //     .dataReload(allFwi);

                                            } else {
                                              // Widget video = PlayVideoAutoPlayFromUrl(autoPlay: false,mute: true,name: snapshotattachment.data!.docs[q].get("videoFile"),);
                                              //  Widget video = Center(child: Icon(Icons.play_arrow_outlined),);
                                              //snapshotattachment.data.docs[q].get("type")
                                              //  widgets.add(PlayVideoFromUrl(name: snapshotattachment.data.docs[q].get("type"),));

                                              // widgetsFullScreen.add(video);
                                              //widgetsFullScreen
                                              // allFwi.add({
                                              //   "wid": video,
                                              //   "time": snapshotattachment
                                              //       .data!.docs[q]
                                              //       .get("time"),
                                              // });
                                              // AttachmentsAddedListener.getInstance()
                                              //     .dataReload(allFwi);
                                              widgets.add( InkWell(onTap: (){


                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>Scaffold(body:Center(child: PlayVideoAutoPlayFromUrl(autoPlay: true,mute: false,name: snapshotattachment.data!.docs[q].get("videoFile"),),)) ),);

                                              },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: Container(
                                                    //height: height*0.7,
                                                    // width: width*0.9,
                                                      child: PlayVideoAutoPlayFromUrl(autoPlay: true,mute: true,name: snapshotattachment.data!.docs[q].get("videoFile"),)),
                                                ),
                                              ));
                                            }





                                          }



                                          ListView r = ListView(
                                            scrollDirection: Axis.horizontal,
                                            children: widgets,
                                          );
                                          return Container(
                                            // height: 130,
                                            child: r,
                                          );

                                        } else
                                          return Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Container(
                                                height: height * 0.21,
                                                width: width * 1,
                                                //   child: Image.memory(base64Decode(dataToShow["graphImage"],),)),
                                                child: Center(child: CircularProgressIndicator(),)),
                                          );
                                      }),
                                ),
                              ],
                            ),
                          ),
                        );

                      }else{
                        return CircularProgressIndicator();
                      }
                    });*/
                      },
                    ) ,);


                  }else{
                    return CircularProgressIndicator();
                  }
                }),



            FutureBuilder<BitmapDescriptor>(
                future: BitmapDescriptor.fromAssetImage(
                    ImageConfiguration(), 'assets/icons/mapMarker1Icon.png'),
                builder: (context, snapshotMarker) {
                  if(snapshotMarker.hasData){
                    return  Expanded(
                      child: StreamBuilder(
                        // Initialize FlutterFire:
                          stream: HomePageLogics(firestore: widget.customerFirestore,auth: FirebaseAuth.instance)
                              .fetchCustomerUsersLastSixTestRecordWithFirestore(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshotHistory) {
                            if (snapshotHistory.hasData && snapshotHistory.data!.docs.length > 0) {
                              // return Text("ok");

                             Widget makeMapImage({required double lat, required double long,required String id}){
                                String mapUri = "https://maps.googleapis.com/maps/api/staticmap?center=" +
                                    lat
                                        .toString() +
                                    "," +
                                   long.toString() +
                                    "&zoom=8&size=" +
                                    ( width * 0.88).toStringAsFixed(0)+
                                    "x"+
                                    ( height * 0.21).toStringAsFixed(0)


                                    +"&maptype=normal"+
                                    "&markers=anchor:center|"+
                                    "icon:https%3A%2F%2Ffirebasestorage.googleapis.com%2Fv0%2Fb%2Fstaht-connect-322113.appspot.com%2Fo%2FmapMarker1Icon.png%3Falt%3Dmedia%26token%3D29e63d7e-2a40-46ec-ac38-740c4b22435d|"+
                                   lat
                                        .toString() +
                                    "," +
                                    long
                                        .toString() +
                                    "&key=AIzaSyDOrDoiG0aLER7Y8cv2QhNr182Z0H5pMVw"+"&map_id="+(darkTheme?"90b3e5c6b64b6c5e":"");
                                      Widget mapWidget = Image.network(mapUri,fit: BoxFit.cover, height: height * 0.21, width: width * 0.88,);
                            return    InkWell(onTap: (){
                                  //show this in dialog
                                  print("show map in dialog");
                                  // showDialog(context: context,
                                  //     builder: (BuildContext context){
                                  //       return Dialog(
                                  //         shape: RoundedRectangleBorder(
                                  //           borderRadius: BorderRadius.circular(2),
                                  //         ),
                                  //         elevation: 0,
                                  //         backgroundColor: Colors.transparent,
                                  //         child: Stack(children: [
                                  //           Align(alignment: Alignment.center,child: mapWidget,),
                                  //           Positioned(top: 15,left: 15,child: InkWell(onTap: (){
                                  //             Navigator.pop(context);
                                  //           },
                                  //             child: Card(shape: RoundedRectangleBorder(
                                  //                 borderRadius: BorderRadius.circular(20.0),
                                  //           ),color: ThemeManager().getDarkGreenColor,child: Container(width: 40,height: 40,child: Center(child :Icon(Icons.arrow_back,color: Colors.white,)),),) ,
                                  //           ),),
                                  //
                                  //
                                  //
                                  //         ],),
                                  //       );
                                  //     }
                                  // );
                                },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                        height: height * 0.21,
                                        width: width * 0.88,
                                        child: Stack(children: [
                                          Align(child: mapWidget,),
                                          Align(child:InkWell(onTap: (){
                                            print("show map in dialog 12");
                                            showDialog(context: context,
                                                builder: (BuildContext context){
                                                  return Dialog(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(2),
                                                    ),
                                                    elevation: 0,
                                                    backgroundColor: Colors.transparent,
                                                    child:  Stack(children: [
                                                      Align(alignment: Alignment.center,child:  GoogleMap(myLocationButtonEnabled: false,mapToolbarEnabled: false,
                                                        initialCameraPosition: CameraPosition(
                                                          target: LatLng(lat,
                                                             long),
                                                          zoom: 8,
                                                        ),
                                                        markers: {
                                                          Marker(
                                                            markerId: MarkerId(id),
                                                            position: LatLng(lat,
                                                                long),
                                                            icon: snapshotMarker.data!,
                                                          ),
                                                        },

                                                        // zoomControlsEnabled: false,
                                                        // zoomGesturesEnabled: false,
                                                      ),),
                                                      Positioned(top: 15,left: 15,child: InkWell(onTap: (){
                                                        Navigator.pop(context);
                                                      },
                                                        child: Card(elevation: 8,shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(20.0),
                                                        ),color: ThemeManager().getDarkGreenColor,child: Container(width: 40,height: 40,child: Center(child :Icon(Icons.arrow_back,color: Colors.white,)),),) ,
                                                      ),),



                                                    ],),
                                                  );
                                                }
                                            );
                                          },
                                            child: Container(  height: height * 0.21,
                                              width: width * 0.88 ,),
                                          )),


                                        ],)),
                                    // child: Image.network(mapUri,fit: BoxFit.cover,)),
                                  ),
                                );

                              }


                              List<QueryDocumentSnapshot<Object?>> data =  snapshotHistory.data!.docs;
                              data = data.reversed.toList();


                              return ListView.builder(shrinkWrap: true,
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  Map<String, dynamic> dataAsMap =data[index].data() as Map<String, dynamic>;
                                  Widget graphIMG = Container(height: height*0.22,
                                    width: MediaQuery.of(context).size.width,
                                    //dataAsMap.containsKey("graphImageDark")

                                    child: Image.memory((darkTheme ) ?( dataAsMap.containsKey("graphImageDark"??"")? base64Decode(dataAsMap["graphImageDark"??""]):(base64Decode(dataAsMap.containsKey("graphImage")?dataAsMap["graphImage"]:""))) : base64Decode(dataAsMap.containsKey("graphImage")?dataAsMap["graphImage"]:"")),
                                  );
                                  return InkWell(onTap: (){
                                    setState(() {

                                    });
                                    HomePageLogics(firestore:widget.customerFirestore ,context: context,locale: widget.locale,customerId:  widget.customerId).testRecordClickedEventQuery(data: dataAsMap,id:data[index].id, pos: 0 ,);
                                    CustomerHomePageLogic().tabChangedStream.dataReload(0);
                                  },
                                    child: Container(
                                      margin: EdgeInsets.only(top: height*0.02),

                                      child: Column(
                                        children: [

                                          //----------------------User profile image and name header------------------
                                          Container(
                                            margin: EdgeInsets.only(left: width*0.04),
                                            child: Row(
                                              children: [
                                                //Image(image: AssetImage(homeScreenData[index]["userProfileImage"])),
                                                CircleAvatar(backgroundColor: AppThemeManager().getAvatarPlaceholderColor() ,),
                                                Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.only(left: width*0.038),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(dataAsMap["name"],maxLines: 1,
                                                          style: interBold.copyWith(color: AppThemeManager().getTextColor1(),
                                                              fontSize: width * 0.04),
                                                        ),

                                                        Container(

                                                          margin: EdgeInsets.only(top: height*0.007),

                                                          child: Text(DateFormat('hh:mm aa dd MMM yyyy',widget.locale.languageCode)
                                                              .format( true? DateTime.fromMillisecondsSinceEpoch(dataAsMap["time"]):DateTime.fromMillisecondsSinceEpoch(dataAsMap["time"])),
                                                            style: interRegular.copyWith(
                                                              fontSize: width * 0.03,
                                                              color: AppThemeManager().getTextColor1(),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                // IconButton(
                                                //   onPressed: (){},
                                                //   splashRadius: 1,
                                                //   icon: SvgPicture.asset("assets/svg/menuButtonIcon.svg"),
                                                // ),
                                              ],
                                            ),
                                          ),

                                          //----------------------Measurements, time and result data------------------
                                          Container(
                                            margin: EdgeInsets.only(top: height * 0.01, left: width * 0.02),

                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(left: width * 0.04),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        height: width * 0.11,
                                                        width: width * 0.11,
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: ThemeManager().getLightBlueColor,
                                                        ),
                                                        child: Image(
                                                            image: AssetImage(
                                                                "assets/icons/peakLoadIcon.png")),
                                                      ),
                                                      Container(
                                                          margin:
                                                          EdgeInsets.only(top: height * 0.01),
                                                          child: Row(
                                                            children: [
                                                              Text(dataAsMap["loadMode"] == "kN"? dataAsMap["max"].toString():dataAsMap["max"].toInt().toString() ,
                                                                style: interSemiBold.copyWith(color: AppThemeManager().getTextColor1(),
                                                                    fontSize: width * 0.04),
                                                              ),
                                                              Container(
                                                                  margin: EdgeInsets.only(left: width*0.01),
                                                                  child: Text(getUnit(dataAsMap),style: interRegular.copyWith(color: AppThemeManager().getTextColor1(),fontSize: width*0.031),))

                                                            ],
                                                          )),
                                                      Container(
                                                        margin:
                                                        EdgeInsets.only(top: height * 0.005),
                                                        child: Text("Peak Load",
                                                            style: interRegular.copyWith(
                                                              fontSize: width * 0.03,color: AppThemeManager().getTextColor2(),)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(right: width * 0.02),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        height: width * 0.11,
                                                        width: width * 0.11,
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: ThemeManager().getLightOrangeColor,
                                                        ),
                                                        child: Image(
                                                            image: AssetImage(
                                                                "assets/icons/targetLoadIcon.png")),
                                                      ),
                                                      Container(
                                                          margin:
                                                          EdgeInsets.only(top: height * 0.01),
                                                          child: Row(
                                                            children: [
                                                              Text(dataAsMap["loadMode"] == "kN"? dataAsMap["targetLoad"].toString():dataAsMap["targetLoad"].toInt().toString(),
                                                                style: interSemiBold.copyWith(color: AppThemeManager().getTextColor1(),
                                                                    fontSize: width * 0.04),
                                                              ),
                                                              Container(
                                                                  margin: EdgeInsets.only(left: width*0.01),
                                                                  child: Text(getUnit(dataAsMap),style: interRegular.copyWith(color: AppThemeManager().getTextColor1(),fontSize: width*0.031),))

                                                            ],
                                                          )),
                                                      Container(
                                                          margin: EdgeInsets.only(
                                                              top: height * 0.005),
                                                          child: Text(
                                                            "Target Load",
                                                            style: interRegular.copyWith(
                                                              fontSize: width * 0.03,color: AppThemeManager().getTextColor2(),),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(right: width * 0.04),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        height: width * 0.11,
                                                        width: width * 0.11,
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: ThemeManager()
                                                              .getLightBottleGreenColor,
                                                        ),
                                                        child: Image(
                                                            image: AssetImage(
                                                                "assets/icons/timeIcon.png")),
                                                      ),
                                                      Container(
                                                          margin:
                                                          EdgeInsets.only(top: height * 0.01),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                dataAsMap["targetDuration"].toString() ,
                                                                style: interSemiBold.copyWith(color: AppThemeManager().getTextColor1(),
                                                                    fontSize: width * 0.04),
                                                              ),
                                                              Container(
                                                                  margin: EdgeInsets.only(left: width*0.01),
                                                                  child: Text("secs",style: interRegular.copyWith(color: AppThemeManager().getTextColor1(),fontSize: width*0.031),))
                                                            ],
                                                          )),
                                                      Container(
                                                          margin: EdgeInsets.only(
                                                              top: height * 0.005),
                                                          child: Text(
                                                            "Time",
                                                            style: interRegular.copyWith(
                                                              fontSize: width * 0.03,
                                                              color: AppThemeManager().getTextColor2(),),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(right: width * 0.07),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        height: width * 0.11,
                                                        width: width * 0.11,
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: dataAsMap["startedLoad"] == 0
                                                              ?  Colors.yellow.withOpacity(0.3)
                                                              : (dataAsMap["startedLoad"] >
                                                              0
                                                              ? (dataAsMap["didPassed"]
                                                              ? Colors.green.withOpacity(0.1)
                                                              : Colors.redAccent.withOpacity(0.1))
                                                              :Colors.redAccent.withOpacity(0.1)) ,
                                                        ),
                                                        child:dataAsMap["startedLoad"] == 0
                                                            ?  Container(

                                                          child:Icon(Icons.warning_rounded,color: ThemeManager().getYellowGradientColor,),
                                                        )
                                                            : (dataAsMap["startedLoad"] >
                                                            0
                                                            ? (dataAsMap["didPassed"]
                                                            ?  Image(image: AssetImage("assets/icons/passIcon.png"))
                                                            :  Container(

                                                          child: Icon(Icons.close_rounded,color: ThemeManager().getRedColor,),
                                                        ))
                                                            : Container(

                                                          child:Icon(Icons.close_rounded,color: ThemeManager().getRedColor,),
                                                        )) ,
                                                        // child: Image(image: AssetImage("assets/icons/passIcon.png")),
                                                      ),
                                                      Container(
                                                          margin:
                                                          EdgeInsets.only(top: height * 0.01),
                                                          child: dataAsMap["startedLoad"] == 0
                                                              ? Text("Not Timed", style: interSemiBold.copyWith( color: AppThemeManager().getTextColor1(),
                                                              fontSize: width * 0.04),
                                                          )
                                                              : (dataAsMap["startedLoad"] >
                                                              0
                                                              ? (dataAsMap["didPassed"]
                                                              ? Text(
                                                            "Pass",
                                                            style: interSemiBold.copyWith( color: AppThemeManager().getTextColor1(),
                                                                fontSize: width * 0.04),
                                                          )
                                                              : Text("Fail",
                                                              style: interSemiBold.copyWith( color: AppThemeManager().getTextColor1(),
                                                                  fontSize: width * 0.04)))
                                                              : Text("Fail",
                                                              style: interSemiBold.copyWith( color: AppThemeManager().getTextColor1(),
                                                                  fontSize: width * 0.04)))),
                                                      Container(
                                                          margin: EdgeInsets.only(
                                                              top: height * 0.005),
                                                          child: Text(
                                                            "Result",
                                                            style: interRegular.copyWith(
                                                                fontSize: width * 0.03,
                                                                color: AppThemeManager().getTextColor2()),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          //----------------------Map image and other image slider-------------------
                                          if(false)     Container(
                                            height: height*0.23,
                                            margin: EdgeInsets.only(top: width*0.04),
                                            child: ListView(shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              children: [
                                                makeMapImage(lat:  dataAsMap["location"]["lat"],long:  dataAsMap["location"]["long"],id:data[index].id ),
                                                Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: Container(
                                                      height: height * 0.21,
                                                      width: width * 0.88,
                                                      //  child: Image.memory(base64Decode(dataToShow["graphImage"],),)),
                                                      //child: snapshotGraph.data
                                                      child: graphIMG
                                                  ),
                                                ),
                                              //  ShowAttachmentWithToggle(id: data[index].id,customerFirestore: widget.customerFirestore,localheigh:height * 0.21 ,localwidth:  width * 0.88,),

                                              if(true)  FutureBuilder<QuerySnapshot>(
                                                    future: AppFirestore(firestore: widget.customerFirestore, auth: FirebaseAuth.instance,projectId: '').fetchCustomerUsersAllAttachmentFuture(testID:data[index].id),
                                                    // stream: fetchCustomerUsersAllAttachmentStream(
                                                    //     testID: widget.id,
                                                    //     firestore: widget.customerFirestore),
                                                    builder: (BuildContext context,
                                                        AsyncSnapshot<QuerySnapshot>
                                                        snapshotattachment) {
                                                      List<Widget> widgets = [];
                                                      // List<Widget> widgetsFullScreen = [];
                                                      List<dynamic> allFwi = [];



                                                      if (snapshotattachment.connectionState == ConnectionState.done) {
                                                        //String markerLink = "https://firebasestorage.googleapis.com/v0/b/staht-connect-322113.appspot.com/o/pin.png?alt=media&token=1b0784fd-202a-47dd-8fe7-4a18ea5e6422";
                                                        String markerLink = "https://developers.google.com/maps/documentation/maps-static/images/star.png";

                                                        String mapUri2 = "https://maps.googleapis.com/maps/api/staticmap?zoom=8&size=512x512&maptype=normal&markers=icon:https%3A%2F%2Ffirebasestorage.googleapis.com%2Fv0%2Fb%2Fstaht-connect-322113.appspot.com%2Fo%2FmapMarker1Icon.png%3Falt%3Dmedia%26token%3D29e63d7e-2a40-46ec-ac38-740c4b22435d|52.462375848649536,%20-2.1703763865421832&key=AIzaSyDOrDoiG0aLER7Y8cv2QhNr182Z0H5pMVw";


                                                        //     return Text("Image size "+snapshotattachment.data.length.toString());
                                                        String mapUriStyled = "https://maps.googleapis.com/maps/api/staticmap?size=512x512&zoom=15&center=Brooklyn&style=feature:road.local%7Celement:geometry%7Ccolor:0x00ff00&style=feature:landscape%7Celement:geometry.fill%7Ccolor:0x000000&style=element:labels%7Cinvert_lightness:true&style=feature:road.arterial%7Celement:labels%7Cinvert_lightness:false&key=AIzaSyDOrDoiG0aLER7Y8cv2QhNr182Z0H5pMVw";

                                                        //
                                                        // GoogleMap mapWidget  = GoogleMap(myLocationButtonEnabled: false,mapToolbarEnabled: false,
                                                        //   initialCameraPosition: CameraPosition(
                                                        //     target: LatLng(dataAsMap["location"]["lat"],
                                                        //         dataAsMap["location"]["long"]),
                                                        //     zoom: 8,
                                                        //   ),
                                                        //   markers: {
                                                        //     Marker(
                                                        //       markerId: MarkerId(snapshot.id),
                                                        //       position: LatLng(dataAsMap["location"]["lat"],
                                                        //           dataAsMap["location"]["long"]),
                                                        //       icon: snapshotMarker.data!,
                                                        //     ),
                                                        //   },
                                                        //
                                                        //   // zoomControlsEnabled: false,
                                                        //   // zoomGesturesEnabled: false,
                                                        // );



                                                        //Uint8List mapIMage = base64Decode(dataToShow["mapImage"]);




                                                        for (int q = 0; q < snapshotattachment.data!.docs.length; q++) {
                                                          // for (int q = snapshotattachment.data.docs.length-1; q >= snapshotattachment.data.docs.length; q--) {
                                                          // String partId = snapshotattachment.data.docs[q].id;
                                                          List allOnlyPhoto = [];
                                                          if (snapshotattachment.data!.docs[q].get("type")=="photo") {
                                                            allOnlyPhoto.add(snapshotattachment.data!.docs[q].get("photoFile"));
                                                            Widget wI = Image.network(snapshotattachment.data!.docs[q].get("photoFile"),fit: BoxFit.cover,);

                                                            widgets.add( InkWell(onTap: (){

                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>SafeArea(child: Scaffold(body: Column(children: [

                                                                        ApplicationAppbar().getAppbar(title: "Photo"),
                                                                        Stack(children: [
                                                                          Align(alignment: Alignment.center,child: wI,),
                                                                          Positioned(top: 15,left: 15,child: InkWell(onTap: (){
                                                                            Navigator.pop(context);
                                                                          },
                                                                            child: Card(elevation: 8,shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(20.0),
                                                                            ),color: ThemeManager().getDarkGreenColor,child: Container(width: 40,height: 40,child: Center(child :Icon(Icons.arrow_back,color: Colors.white,)),),) ,
                                                                          ),),



                                                                        ],)
                                                                      ],),))));

                                                            },
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(5.0),
                                                                child: Container(
                                                                  // height: height*0.7,
                                                                  //width: width*0.9,
                                                                    child: wI),
                                                              ),
                                                            ));





                                                            // widgetsFullScreen.add(wI);
                                                            //widgetsFullScreen
                                                            // allFwi.add({
                                                            //   "wid": wI,
                                                            //   "time": snapshotattachment
                                                            //       .data!.docs[q]
                                                            //       .get("time"),
                                                            // });
                                                            // AttachmentsAddedListener.getInstance()
                                                            //     .dataReload(allFwi);

                                                          } else {
                                                            // Widget video = PlayVideoAutoPlayFromUrl(autoPlay: false,mute: true,name: snapshotattachment.data!.docs[q].get("videoFile"),);
                                                            //  Widget video = Center(child: Icon(Icons.play_arrow_outlined),);
                                                            //snapshotattachment.data.docs[q].get("type")
                                                            //  widgets.add(PlayVideoFromUrl(name: snapshotattachment.data.docs[q].get("type"),));

                                                            // widgetsFullScreen.add(video);
                                                            //widgetsFullScreen
                                                            // allFwi.add({
                                                            //   "wid": video,
                                                            //   "time": snapshotattachment
                                                            //       .data!.docs[q]
                                                            //       .get("time"),
                                                            // });
                                                            // AttachmentsAddedListener.getInstance()
                                                            //     .dataReload(allFwi);
                                                            widgets.add( InkWell(onTap: (){


                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>Scaffold(body:Center(child: PlayVideoAutoPlayFromUrl(autoPlay: true,mute: false,name: snapshotattachment.data!.docs[q].get("videoFile"),),)) ),);

                                                            },
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(5.0),
                                                                child: Container(
                                                                  //height: height*0.7,
                                                                  // width: width*0.9,
                                                                    child: PlayVideoAutoPlayFromUrl(autoPlay: true,mute: true,name: snapshotattachment.data!.docs[q].get("videoFile"),)),
                                                              ),
                                                            ));
                                                          }





                                                        }



                                                        ListView r = ListView(
                                                          scrollDirection: Axis.horizontal,
                                                          children: widgets,
                                                        );
                                                        return Container(
                                                          // height: 130,
                                                          child: r,
                                                        );

                                                      } else
                                                        return Padding(
                                                          padding: const EdgeInsets.all(5.0),
                                                          child: Container(
                                                              height: height * 0.21,
                                                              width: width * 1,
                                                              //   child: Image.memory(base64Decode(dataToShow["graphImage"],),)),
                                                              child: Center(child: CircularProgressIndicator(),)),
                                                        );
                                                    }),
                                              ],
                                            ),
                                          ),
                                         if(true) Container(
                                            height: height*0.23,
                                            margin: EdgeInsets.only(top: width*0.04),
                                            child: FutureBuilder<QuerySnapshot>(
                                                future: AppFirestore(firestore: widget.customerFirestore, auth: FirebaseAuth.instance,projectId: '').fetchCustomerUsersAllAttachmentFuture(testID:data[index].id),
                                                // stream: fetchCustomerUsersAllAttachmentStream(
                                                //     testID: widget.id,
                                                //     firestore: widget.customerFirestore),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<QuerySnapshot>
                                                    snapshotattachment) {
                                                  List<Widget> widgets = [];
                                                  // List<Widget> widgetsFullScreen = [];
                                                  List<dynamic> allFwi = [];



                                                  if (snapshotattachment.connectionState == ConnectionState.done) {
                                                    //String markerLink = "https://firebasestorage.googleapis.com/v0/b/staht-connect-322113.appspot.com/o/pin.png?alt=media&token=1b0784fd-202a-47dd-8fe7-4a18ea5e6422";
                                                    String markerLink = "https://developers.google.com/maps/documentation/maps-static/images/star.png";

                                                    String mapUri2 = "https://maps.googleapis.com/maps/api/staticmap?zoom=8&size=512x512&maptype=normal&markers=icon:https%3A%2F%2Ffirebasestorage.googleapis.com%2Fv0%2Fb%2Fstaht-connect-322113.appspot.com%2Fo%2FmapMarker1Icon.png%3Falt%3Dmedia%26token%3D29e63d7e-2a40-46ec-ac38-740c4b22435d|52.462375848649536,%20-2.1703763865421832&key=AIzaSyDOrDoiG0aLER7Y8cv2QhNr182Z0H5pMVw";


                                                    //     return Text("Image size "+snapshotattachment.data.length.toString());
                                                    String mapUriStyled = "https://maps.googleapis.com/maps/api/staticmap?size=512x512&zoom=15&center=Brooklyn&style=feature:road.local%7Celement:geometry%7Ccolor:0x00ff00&style=feature:landscape%7Celement:geometry.fill%7Ccolor:0x000000&style=element:labels%7Cinvert_lightness:true&style=feature:road.arterial%7Celement:labels%7Cinvert_lightness:false&key=AIzaSyDOrDoiG0aLER7Y8cv2QhNr182Z0H5pMVw";
                                                    String mapUri = "https://maps.googleapis.com/maps/api/staticmap?center=" +
                                                        dataAsMap["location"]["lat"]
                                                            .toString() +
                                                        "," +
                                                        dataAsMap["location"]["long"]
                                                            .toString() +
                                                        "&zoom=8&size=" +
                                                        ( width * 0.88).toStringAsFixed(0)+
                                                        "x"+
                                                        ( height * 0.21).toStringAsFixed(0)


                                                        +"&maptype=normal"+
                                                        "&markers=anchor:center|"+
                                                        "icon:https%3A%2F%2Ffirebasestorage.googleapis.com%2Fv0%2Fb%2Fstaht-connect-322113.appspot.com%2Fo%2FmapMarker1Icon.png%3Falt%3Dmedia%26token%3D29e63d7e-2a40-46ec-ac38-740c4b22435d|"+
                                                        dataAsMap["location"]["lat"]
                                                            .toString() +
                                                        "," +
                                                        dataAsMap["location"]["long"]
                                                            .toString() +
                                                        "&key=AIzaSyDOrDoiG0aLER7Y8cv2QhNr182Z0H5pMVw"+"&map_id="+(darkTheme?"90b3e5c6b64b6c5e":"");
                                                    //
                                                    // GoogleMap mapWidget  = GoogleMap(myLocationButtonEnabled: false,mapToolbarEnabled: false,
                                                    //   initialCameraPosition: CameraPosition(
                                                    //     target: LatLng(dataAsMap["location"]["lat"],
                                                    //         dataAsMap["location"]["long"]),
                                                    //     zoom: 8,
                                                    //   ),
                                                    //   markers: {
                                                    //     Marker(
                                                    //       markerId: MarkerId(snapshot.id),
                                                    //       position: LatLng(dataAsMap["location"]["lat"],
                                                    //           dataAsMap["location"]["long"]),
                                                    //       icon: snapshotMarker.data!,
                                                    //     ),
                                                    //   },
                                                    //
                                                    //   // zoomControlsEnabled: false,
                                                    //   // zoomGesturesEnabled: false,
                                                    // );



                                                    //Uint8List mapIMage = base64Decode(dataToShow["mapImage"]);

                                                    Widget mapWidget = Image.network(mapUri,fit: BoxFit.cover, height: height * 0.21, width: width * 0.88,);
                                                    widgets.add(InkWell(onTap: (){
                                                      //show this in dialog
                                                      print("show map in dialog");
                                                      // showDialog(context: context,
                                                      //     builder: (BuildContext context){
                                                      //       return Dialog(
                                                      //         shape: RoundedRectangleBorder(
                                                      //           borderRadius: BorderRadius.circular(2),
                                                      //         ),
                                                      //         elevation: 0,
                                                      //         backgroundColor: Colors.transparent,
                                                      //         child: Stack(children: [
                                                      //           Align(alignment: Alignment.center,child: mapWidget,),
                                                      //           Positioned(top: 15,left: 15,child: InkWell(onTap: (){
                                                      //             Navigator.pop(context);
                                                      //           },
                                                      //             child: Card(shape: RoundedRectangleBorder(
                                                      //                 borderRadius: BorderRadius.circular(20.0),
                                                      //           ),color: ThemeManager().getDarkGreenColor,child: Container(width: 40,height: 40,child: Center(child :Icon(Icons.arrow_back,color: Colors.white,)),),) ,
                                                      //           ),),
                                                      //
                                                      //
                                                      //
                                                      //         ],),
                                                      //       );
                                                      //     }
                                                      // );
                                                    },
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(5.0),
                                                        child: Container(
                                                            height: height * 0.21,
                                                            width: width * 0.88,
                                                            child: Stack(children: [
                                                              Align(child: mapWidget,),
                                                              Align(child:InkWell(onTap: (){
                                                                print("show map in dialog 12");
                                                                showDialog(context: context,
                                                                    builder: (BuildContext context){
                                                                      return Dialog(
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(2),
                                                                        ),
                                                                        elevation: 0,
                                                                        backgroundColor: Colors.transparent,
                                                                        child:  Stack(children: [
                                                                          Align(alignment: Alignment.center,child:  GoogleMap(myLocationButtonEnabled: false,mapToolbarEnabled: false,
                                                                            initialCameraPosition: CameraPosition(
                                                                              target: LatLng(dataAsMap["location"]["lat"],
                                                                                  dataAsMap["location"]["long"]),
                                                                              zoom: 8,
                                                                            ),
                                                                            markers: {
                                                                              Marker(
                                                                                markerId: MarkerId(data[index].id),
                                                                                position: LatLng(dataAsMap["location"]["lat"],
                                                                                    dataAsMap["location"]["long"]),
                                                                                icon: snapshotMarker.data!,
                                                                              ),
                                                                            },

                                                                            // zoomControlsEnabled: false,
                                                                            // zoomGesturesEnabled: false,
                                                                          ),),
                                                                          Positioned(top: 15,left: 15,child: InkWell(onTap: (){
                                                                            Navigator.pop(context);
                                                                          },
                                                                            child: Card(elevation: 8,shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(20.0),
                                                                            ),color: ThemeManager().getDarkGreenColor,child: Container(width: 40,height: 40,child: Center(child :Icon(Icons.arrow_back,color: Colors.white,)),),) ,
                                                                          ),),



                                                                        ],),
                                                                      );
                                                                    }
                                                                );
                                                              },
                                                                child: Container(  height: height * 0.21,
                                                                  width: width * 0.88 ,),
                                                              )),


                                                            ],)),
                                                        // child: Image.network(mapUri,fit: BoxFit.cover,)),
                                                      ),
                                                    ));
                                                    widgets.add(Padding(
                                                      padding: const EdgeInsets.all(5.0),
                                                      child: Container(
                                                          height: height * 0.21,
                                                          width: width * 0.88,
                                                          //  child: Image.memory(base64Decode(dataToShow["graphImage"],),)),
                                                          //child: snapshotGraph.data
                                                          child: graphIMG
                                                      ),
                                                    ));
                                                    for (int q = 0; q < snapshotattachment.data!.docs.length; q++) {
                                                      // for (int q = snapshotattachment.data.docs.length-1; q >= snapshotattachment.data.docs.length; q--) {
                                                      // String partId = snapshotattachment.data.docs[q].id;
                                                      List allOnlyPhoto = [];
                                                      if (snapshotattachment.data!.docs[q].get("type")=="photo") {
                                                        allOnlyPhoto.add(snapshotattachment.data!.docs[q].get("photoFile"));
                                                        Widget wI = Image.network(snapshotattachment.data!.docs[q].get("photoFile"),fit: BoxFit.cover,);

                                                        widgets.add( InkWell(onTap: (){

                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>SafeArea(child: Scaffold(body: Column(children: [

                                                                    ApplicationAppbar().getAppbar(title: "Photo"),
                                                                    Stack(children: [
                                                                      Align(alignment: Alignment.center,child: wI,),
                                                                      Positioned(top: 15,left: 15,child: InkWell(onTap: (){
                                                                        Navigator.pop(context);
                                                                      },
                                                                        child: Card(elevation: 8,shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(20.0),
                                                                        ),color: ThemeManager().getDarkGreenColor,child: Container(width: 40,height: 40,child: Center(child :Icon(Icons.arrow_back,color: Colors.white,)),),) ,
                                                                      ),),



                                                                    ],)
                                                                  ],),))));

                                                        },
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(5.0),
                                                            child: Container(
                                                              // height: height*0.7,
                                                              //width: width*0.9,
                                                                child: wI),
                                                          ),
                                                        ));





                                                        // widgetsFullScreen.add(wI);
                                                        //widgetsFullScreen
                                                        // allFwi.add({
                                                        //   "wid": wI,
                                                        //   "time": snapshotattachment
                                                        //       .data!.docs[q]
                                                        //       .get("time"),
                                                        // });
                                                        // AttachmentsAddedListener.getInstance()
                                                        //     .dataReload(allFwi);

                                                      } else {
                                                        // Widget video = PlayVideoAutoPlayFromUrl(autoPlay: false,mute: true,name: snapshotattachment.data!.docs[q].get("videoFile"),);
                                                        //  Widget video = Center(child: Icon(Icons.play_arrow_outlined),);
                                                        //snapshotattachment.data.docs[q].get("type")
                                                        //  widgets.add(PlayVideoFromUrl(name: snapshotattachment.data.docs[q].get("type"),));

                                                        // widgetsFullScreen.add(video);
                                                        //widgetsFullScreen
                                                        // allFwi.add({
                                                        //   "wid": video,
                                                        //   "time": snapshotattachment
                                                        //       .data!.docs[q]
                                                        //       .get("time"),
                                                        // });
                                                        // AttachmentsAddedListener.getInstance()
                                                        //     .dataReload(allFwi);
                                                        widgets.add( InkWell(onTap: (){


                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>Scaffold(body:Center(child: PlayVideoAutoPlayFromUrl(autoPlay: true,mute: false,name: snapshotattachment.data!.docs[q].get("videoFile"),),)) ),);

                                                        },
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(5.0),
                                                            child: Container(
                                                              //height: height*0.7,
                                                              // width: width*0.9,
                                                                child: PlayVideoAutoPlayFromUrl(autoPlay: true,mute: true,name: snapshotattachment.data!.docs[q].get("videoFile"),)),
                                                          ),
                                                        ));
                                                      }





                                                    }



                                                    ListView r = ListView(
                                                      scrollDirection: Axis.horizontal,
                                                      children: widgets,
                                                    );
                                                    return Container(
                                                      // height: 130,
                                                      child: r,
                                                    );

                                                  } else
                                                    return Padding(
                                                      padding: const EdgeInsets.all(5.0),
                                                      child: Container(
                                                          height: height * 0.21,
                                                          width: width * 1,
                                                          //   child: Image.memory(base64Decode(dataToShow["graphImage"],),)),
                                                          child: Center(child: CircularProgressIndicator(),)),
                                                    );
                                                }),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );



                               HomePageUi(firestore: widget.customerFirestore, customerId: widget.customerId).homePageRecentTests( docsN:data,context: context,locale: widget.locale);






                            } else {
                              return ConstantWidget().notData();
                            }
                          }),
                    );


                  }else{
                    return CircularProgressIndicator();
                  }
                }),





            // Container(height: 60,
            //   child: Expanded(
            //     child:  StreamBuilder(
            //       // Initialize FlutterFire:
            //         stream: HomePageLogics(firestore: widget.customerFirestore,auth: FirebaseAuth.instance)
            //             .fetchCustomerUsersLastSixTestRecordWithFirestore(),
            //         builder: (BuildContext context,
            //             AsyncSnapshot<QuerySnapshot> snapshotHistory) {
            //           if (snapshotHistory.hasData &&
            //               snapshotHistory.data!.docs.length > 0) {
            //             // return Text("ok");
            //             List<QueryDocumentSnapshot<Object?>> data =  snapshotHistory.data!.docs;
            //             // data = data.reversed;
            //             return  Container(height: 50,
            //               child: Center(
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(8.0),
            //                   child: ListView.builder(scrollDirection: Axis.horizontal,
            //
            //                       shrinkWrap: true,
            //                       itemCount: ( data.length/3).ceilToDouble().toInt(),
            //                       itemBuilder: (context, index) {
            //                         return Container(height: 50,width: 50,
            //                           child: InkWell(onTap: (){
            //                             print("page "+ index.toString());
            //
            //                             //selectedPage  = index;
            //                             HomePagePaginationStream.getInstance().dataReload(index);
            //                           },
            //                               //HomePagePaginationStream
            //                               child: StreamBuilder<int>(
            //                                   stream: HomePagePaginationStream.getInstance().outData,
            //                                   builder: (context, snapshot) {
            //                                     show(int val){
            //                                       return  Card( elevation: 5,color: index==val?Theme.of(context).primaryColor:Colors.white,
            //                                           shape: RoundedRectangleBorder(
            //                                             borderRadius: BorderRadius.circular(0.0),
            //                                           ),child: Padding(
            //                                             padding: const EdgeInsets.all(0.0),
            //                                             child: Container(height: 50,width: 50,child: Center(child: Text((index+1).toString(),style: TextStyle(color:  index==val?Colors.white:Theme.of(context).primaryColor,),))),
            //                                           ));
            //                                     }
            //                                     if(snapshot.hasData){
            //                                       return show(snapshot.data!);
            //                                     }else{
            //                                       return show(0);
            //                                     }
            //                                   })
            //
            //                           ),
            //                         );
            //
            //
            //                       }),
            //                 ),
            //               ),
            //             );
            //             return HomePageUi(firestore: widget.customerFirestore, customerId: widget.customerId).homePageRecentTests( docsN: data,context: context,locale: widget.locale);
            //
            //
            //           } else {
            //             return Padding(
            //               padding: const EdgeInsets.all(15.0),
            //               child: Text("No records available"),
            //             );
            //           }
            //         }),
            //   ),
            // ),
          ],
        )
    );
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(

              height: 50,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Image.asset(
                              "assets/staht_logo_green.jpg",
                              height: 40,
                              width: 40,
                            ),
                          ),
//AppLocalizations.of(context).appTitle,
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              "STAHT CONNECT",
                              style: TextStyle(

                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: InkWell(onTap: (){
                  //     //setting
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => SettingsPage()),
                  //     );
                  //   },
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: Icon(Icons.settings),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
            Divider(height: 0.5),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              child: Container(

                height: 60,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () async {
                                //profile photo picker

                                final picker = ImagePicker();
                                final pickedFile = await picker.getImage(
                                    source: ImageSource.gallery,maxHeight: 100,maxWidth: 100);

                                Uint8List file = await pickedFile!.readAsBytes();
                                String base64 = base64Encode(file);
                                //update user photo
                                //updateUserPhoto

                                HomePageLogics(firestore: FirebaseFirestore.instance,auth:  FirebaseAuth
                                    .instance).changeUserPhoto(base64Data: base64);
                               


                              },
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Container(
                                    height: 30,
                                    width: 30,

                                    child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                        future: AppFirestore(auth: widget.auth,firestore: FirebaseFirestore.instance, projectId: '').getCurrentUserInfo(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return prepareUserPhoto(
                                                snapshot.data!.docs.first);
                                          } else {
                                            return Icon(
                                                Icons.account_box_outlined);
                                          }
                                        })),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(6, 3, 3, 3),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.profile.get("email")),
                                  Text(widget.customerName)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(height: 1),
            InkWell(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:  AppLabels(locale: widget.locale).GlobalSearchLabel(),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.search)),
                    ),
                  ],
                ),
              ),
              onTap: () {
                HomePageLogics(auth: widget.auth,locale: widget.locale,firestore: widget.customerFirestore).searchPullTestClicked();

              },
            ),

        
            StreamBuilder(
              // Initialize FlutterFire:
                stream: HomePageLogics(firestore: widget.customerFirestore,auth: FirebaseAuth.instance)
                    .fetchCustomerUsersLastSixTestRecordWithFirestore(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshotHistory) {
                  if (snapshotHistory.hasData &&
                      snapshotHistory.data!.docs.length > 0) {
                    // return Text("ok");
                    List<QueryDocumentSnapshot<Object?>> data =  snapshotHistory.data!.docs;
                    // data = data.reversed;
                  //  return HomePageUi(firestore: widget.customerFirestore, customerId: widget.customerId).homePageRecentTests( docs: data,context: context,locale: widget.locale);


                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text("No records available"),
                    );
                  }
                }),


            Container(
              height: 400,
              width: MediaQuery.of(context).size.width,
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
                      String allMarkers = "";
                      double width = MediaQuery.of(context).size.width;
                      for (int i = 0;
                      i < snapshotHistory.data!.docs.length;
                      i++) {
                        // allMarkers = allMarkers +  "markers=color:red%7Clabel:sS%7C"+snapshotHistory.data[i]["location"]["lat"].toString()+","+snapshotHistory.data[i]["location"]["long"].toString();
                        if (snapshotHistory.data!.docs[i]["location"] !=
                            null &&
                            snapshotHistory.data!.docs[i]["location"]
                            ["lat"] !=
                                null &&
                            snapshotHistory.data!.docs[i]["location"]
                            ["long"] !=
                                null) {
                          allMarkers = allMarkers +
                              "&markers=color:red%7Clabel:sS%7C" +
                              snapshotHistory
                                  .data!.docs[i]["location"]["lat"]
                                  .toString() +
                              "," +
                              snapshotHistory
                                  .data!.docs[i]["location"]["long"]
                                  .toString();
                        }
                      }

                      //   String allMarkers = "markers=color:red%7Clabel:sS%7C"+snapshotHistory.data.first["location"]["lat"].toString()+","+snapshotHistory.data.first["location"]["long"].toString()+"&"+snapshotHistory.data.last["location"]["lat"].toString()+","+snapshotHistory.data.last["location"]["long"].toString();
                      // String url = "https://maps.googleapis.com/maps/api/staticmap?center="+snapshotHistory.data.last["location"]["lat"].toString()+","+snapshotHistory.data.last["location"]["long"].toString()+"&zoom=6&size="+width.ceil().toString()+"x200&"+allMarkers+"&key=AIzaSyBQH9dnXV9oUn0K8MMge3MlbhBgbLKzQ10";
                      // String url = "https://maps.googleapis.com/maps/api/staticmap?center=center=63.259591,-144.667969&zoom=6&size="+width.ceil().toString()+"x200&"+allMarkers+"&key=AIzaSyBQH9dnXV9oUn0K8MMge3MlbhBgbLKzQ10";
                      if (snapshotHistory.data!.docs.last["location"] !=
                          null &&
                          snapshotHistory.data!.docs.last["location"]
                          ["lat"] !=
                              null &&
                          snapshotHistory.data!.docs.last["location"]
                          ["long"] !=
                              null) {
                        String url =
                            "https://maps.googleapis.com/maps/api/staticmap?center=" +
                                snapshotHistory
                                    .data!.docs.last["location"]["lat"]
                                    .toString() +
                                "," +
                                snapshotHistory
                                    .data!.docs.last["location"]["long"]
                                    .toString() +
                                "&zoom=6&size=" +
                                width.ceil().toString() +
                                "x400" +
                                allMarkers +
                                "&key=AIzaSyBQH9dnXV9oUn0K8MMge3MlbhBgbLKzQ10";
                        print(url);
                        return Container(
                            height: 400,
                            width: MediaQuery.of(context).size.width,
                            child: Image.network(url));
                      } else {
                        return Center(child: Text("No records available"));
                      }
                    } else {
                      return Center(child: Text("No records available"));
                    }
                  })
              //child:Center(child: Container(height: 200,width: 200,child: Image.network("https://maps.googleapis.com/maps/api/staticmap?center="+snapshotRecords.data[index]["location"]["lat"].toString()+","+snapshotRecords.data[index]["location"]["long"].toString()+"&zoom=16&size=200x200&markers=color:red%7Clabel:sS%7C51.5529333,0.0550858&key=AIzaSyBQH9dnXV9oUn0K8MMge3MlbhBgbLKzQ10")))
              ,
            ),
          ],
        ),
      ),
    );
  }

  prepareUserPhoto(photo) {
    try {
      return photo["photo"] == null
          ? Icon(Icons.photo)
          : prepareNetworkImage(photo["photo"]);
    } catch (e) {
      print("profile  pic render exception");
      print(e);
      return Icon(Icons.account_box_outlined);
    }
  }

  Widget prepareNetworkImage(param0) {
    return Container(
        height: 50,
        width: 50,
        child: Image.memory(
          base64Decode(param0),
          fit: BoxFit.cover,
        ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
class ShowAttachmentWithToggle extends StatefulWidget {
  FirebaseFirestore customerFirestore;
  String id;
  bool showingImage = false;
  double localheigh;
  double localwidth;
  int number = 1 ;
  ShowAttachmentWithToggle({required this.id,required this.customerFirestore,required this.localheigh,required this.localwidth});

  @override
  _ShowAttachmentWithToggleState createState() => _ShowAttachmentWithToggleState();
}

class _ShowAttachmentWithToggleState extends State<ShowAttachmentWithToggle> {
  @override
  Widget build(BuildContext context) {
    return  widget. showingImage?  Container(height:widget.localheigh,
      width: widget.localwidth*widget.number,
      child: FutureBuilder<QuerySnapshot>(
          future: AppFirestore(firestore: widget.customerFirestore, auth: FirebaseAuth.instance,projectId: '').fetchCustomerUsersAllAttachmentFuture(testID:widget.id),
          // stream: fetchCustomerUsersAllAttachmentStream(
          //     testID: widget.id,
          //     firestore: widget.customerFirestore),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot>
              snapshotattachment) {
            List<Widget> widgets = [];
            // List<Widget> widgetsFullScreen = [];
            List<dynamic> allFwi = [];



            if (snapshotattachment.connectionState == ConnectionState.done) {
              AppToast().show(message: snapshotattachment.data!.docs.length.toString());
              //String markerLink = "https://firebasestorage.googleapis.com/v0/b/staht-connect-322113.appspot.com/o/pin.png?alt=media&token=1b0784fd-202a-47dd-8fe7-4a18ea5e6422";
              String markerLink = "https://developers.google.com/maps/documentation/maps-static/images/star.png";

              String mapUri2 = "https://maps.googleapis.com/maps/api/staticmap?zoom=8&size=512x512&maptype=normal&markers=icon:https%3A%2F%2Ffirebasestorage.googleapis.com%2Fv0%2Fb%2Fstaht-connect-322113.appspot.com%2Fo%2FmapMarker1Icon.png%3Falt%3Dmedia%26token%3D29e63d7e-2a40-46ec-ac38-740c4b22435d|52.462375848649536,%20-2.1703763865421832&key=AIzaSyDOrDoiG0aLER7Y8cv2QhNr182Z0H5pMVw";


              //     return Text("Image size "+snapshotattachment.data.length.toString());
              String mapUriStyled = "https://maps.googleapis.com/maps/api/staticmap?size=512x512&zoom=15&center=Brooklyn&style=feature:road.local%7Celement:geometry%7Ccolor:0x00ff00&style=feature:landscape%7Celement:geometry.fill%7Ccolor:0x000000&style=element:labels%7Cinvert_lightness:true&style=feature:road.arterial%7Celement:labels%7Cinvert_lightness:false&key=AIzaSyDOrDoiG0aLER7Y8cv2QhNr182Z0H5pMVw";

              //
              // GoogleMap mapWidget  = GoogleMap(myLocationButtonEnabled: false,mapToolbarEnabled: false,
              //   initialCameraPosition: CameraPosition(
              //     target: LatLng(dataAsMap["location"]["lat"],
              //         dataAsMap["location"]["long"]),
              //     zoom: 8,
              //   ),
              //   markers: {
              //     Marker(
              //       markerId: MarkerId(snapshot.id),
              //       position: LatLng(dataAsMap["location"]["lat"],
              //           dataAsMap["location"]["long"]),
              //       icon: snapshotMarker.data!,
              //     ),
              //   },
              //
              //   // zoomControlsEnabled: false,
              //   // zoomGesturesEnabled: false,
              // );



              //Uint8List mapIMage = base64Decode(dataToShow["mapImage"]);




              for (int q = 0; q < snapshotattachment.data!.docs.length; q++) {
                // for (int q = snapshotattachment.data.docs.length-1; q >= snapshotattachment.data.docs.length; q--) {
                // String partId = snapshotattachment.data.docs[q].id;
                if(widget.number==1){
                //  setState(() {
                    widget.number = snapshotattachment.data!.docs.length;
                 // });
                }

                List allOnlyPhoto = [];
                if (snapshotattachment.data!.docs[q].get("type")=="photo") {
                  allOnlyPhoto.add(snapshotattachment.data!.docs[q].get("photoFile"));
                  Widget wI = Image.network(snapshotattachment.data!.docs[q].get("photoFile"),fit: BoxFit.cover,);

                  widgets.add( InkWell(onTap: (){

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>SafeArea(child: Scaffold(body: Column(children: [

                              ApplicationAppbar().getAppbar(title: "Photo"),
                              Stack(children: [
                                Align(alignment: Alignment.center,child: wI,),
                                Positioned(top: 15,left: 15,child: InkWell(onTap: (){
                                  Navigator.pop(context);
                                },
                                  child: Card(elevation: 8,shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),color: ThemeManager().getDarkGreenColor,child: Container(width: 40,height: 40,child: Center(child :Icon(Icons.arrow_back,color: Colors.white,)),),) ,
                                ),),



                              ],)
                            ],),))));

                  },
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                          height:widget.localheigh,width: widget.localwidth,
                          child: wI),
                    ),
                  ));





                  // widgetsFullScreen.add(wI);
                  //widgetsFullScreen
                  // allFwi.add({
                  //   "wid": wI,
                  //   "time": snapshotattachment
                  //       .data!.docs[q]
                  //       .get("time"),
                  // });
                  // AttachmentsAddedListener.getInstance()
                  //     .dataReload(allFwi);

                } else {
                  // Widget video = PlayVideoAutoPlayFromUrl(autoPlay: false,mute: true,name: snapshotattachment.data!.docs[q].get("videoFile"),);
                  //  Widget video = Center(child: Icon(Icons.play_arrow_outlined),);
                  //snapshotattachment.data.docs[q].get("type")
                  //  widgets.add(PlayVideoFromUrl(name: snapshotattachment.data.docs[q].get("type"),));

                  // widgetsFullScreen.add(video);
                  //widgetsFullScreen
                  // allFwi.add({
                  //   "wid": video,
                  //   "time": snapshotattachment
                  //       .data!.docs[q]
                  //       .get("time"),
                  // });
                  // AttachmentsAddedListener.getInstance()
                  //     .dataReload(allFwi);
                  widgets.add( InkWell(onTap: (){


                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>Scaffold(body:Center(child: PlayVideoAutoPlayFromUrl(autoPlay: true,mute: false,name: snapshotattachment.data!.docs[q].get("videoFile"),),)) ),);

                  },
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                          height:widget.localheigh,width: widget.localwidth,
                          child: PlayVideoAutoPlayFromUrl(autoPlay: true,mute: true,name: snapshotattachment.data!.docs[q].get("videoFile"),)),
                    ),
                  ));
                }





              }



              ListView r = ListView(
                scrollDirection: Axis.horizontal,
                children: widgets,
              );
              return Container(
                height: widget.localheigh,
                child: r,
              );

            } else
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                    height:widget.localheigh,
                    width: widget.localwidth,
                    //   child: Image.memory(base64Decode(dataToShow["graphImage"],),)),
                    child: Center(child: CircularProgressIndicator(),)),
              );
          }),
    ):Container(

      height:widget.localheigh,
      width: widget.localwidth,
      child: Center(child: InkWell(onTap: (){
        setState(() {
          widget.showingImage = true;
        });
      },
        child: Container(width: 50,height: 50,
          child: Card(elevation: 5,shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),child: Center(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.arrow_forward_sharp),
          ),),),
        ),
      ),),);
  }
}
