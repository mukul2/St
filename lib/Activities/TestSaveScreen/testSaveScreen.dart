
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/Activities/CustomBottomNavigationBar/appBottomNavigationBar.dart';
import 'package:connect/Activities/CustomerUserHome/logics.dart';
import 'package:connect/Activities/TestPerformActivity/logics.dart';
import 'package:connect/Activities/old_test_perform/old_test_perform.dart';
import 'package:connect/Activities/old_test_perform/testStatusEnum.dart';
import 'package:connect/Toast/AppToast.dart';
import 'package:connect/screens/home.dart';
import 'package:connect/screens/testScreen.dart';
import 'package:connect/utils/featureSettings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connect/components/appBarCustom.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/textConst.dart';
import 'package:connect/utils/textStyleConst.dart';
import 'package:connect/utils/themeManager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:screenshot/screenshot.dart';


class TestSaveScreen extends StatefulWidget {
  String status;
  String peek;
  String start;
  String end;
  String id;
  FirebaseFirestore customerFirestore;
  Widget widToScreenSot;


  TestSaveScreen({required this.widToScreenSot,required this.customerFirestore,required this.id,required this.status,required this.peek,required this.start,required this.end});


  @override
  _TestSaveScreenScreenState createState() => _TestSaveScreenScreenState();
}

class _TestSaveScreenScreenState extends State<TestSaveScreen> {
  int selectionIndex = 0;

  bool didUpdated = false ;


  TextEditingController controllerTitle = new TextEditingController(
      text: getACurrentTimeStamp().replaceAll("", ""));
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CaptureScreensotStream.getInstance().outData.listen((event) {
     // takeScreenSot();
    });

    controllerTitle.selection = TextSelection(baseOffset: 0, extentOffset: controllerTitle.value.text.length);
  }
  @override
  Widget build(BuildContext context) {

    // print(widget.start);
    // print(widget.end);
    // print(widget.peek);
    // height = MediaQuery.of(context).size.height;
    // width = MediaQuery.of(context).size.width;
//  key: scaffoldKey,
   // controllerTitle.selection = TextSelection(baseOffset: 0, extentOffset:selectionIndex );
    //final val = TextSelection.collapsed(offset: controllerTitle.text.length);
    //controllerTitle.selection = val;



    //  if(didUpdated == false){
   //    controllerTitle.selection = TextSelection(baseOffset: 0, extentOffset:selectionIndex );
   //   // selectionIndex =  controllerTitle.text.length;
   //  }


    double screenWidth = MediaQuery.of(context).size.width;
    var bottomNav = Container(color: Colors.white,child: Wrap(
      children: [
        Container(
          //margin: EdgeInsets.only(top: height*0.008),
          height: height*0.001,
          width: double.infinity,
          color: ThemeManager().getBlackColor.withOpacity(.15),
        ),
        Container(height:  (height * 0.075)- height*0.001,
          child: Center(
            child: Row(children:[
              Expanded(child: InkWell(onTap: (){
                Navigator.pop(context);
                Navigator.pop(context);
                CustomerHomePageLogic().tabChangedStream.dataReload(0);
              },
                child: Center(child: Container(
                    padding: EdgeInsets.only(right: screenWidth * 0.06),
                    child: SvgPicture.asset(
                      "assets/svg/homeIcon.svg",
                      color: ThemeManager().getDarkGrey3Color,
                      width: screenWidth * 0.028,
                      height: screenWidth * 0.06,
                    )),),
              )),
              Expanded(child: InkWell(onTap: (){
                Navigator.pop(context);
                Navigator.pop(context);
                CustomerHomePageLogic().tabChangedStream.dataReload(1);
              },
                child: Center(child: Container(
                    padding: EdgeInsets.only(right: screenWidth * 0.06),
                    child: SvgPicture.asset(
                      "assets/svg/strokeIcon.svg",
                      color: ThemeManager().getDarkGreenColor,
                      width: screenWidth * 0.028,
                      height: screenWidth * 0.06,
                    )),),
              )),
              Expanded(child: InkWell(onTap: (){
                Navigator.pop(context);
                Navigator.pop(context);
                CustomerHomePageLogic().tabChangedStream.dataReload(2);
              },
                child: Center(child: Container(
                    padding: EdgeInsets.only(right: screenWidth * 0.06),
                    child: SvgPicture.asset(
                      "assets/svg/chartIcon.svg",
                      color: ThemeManager().getDarkGrey3Color,
                      width: screenWidth * 0.028,
                      height: screenWidth * 0.06,
                    )),),
              )),
              Expanded(child: InkWell(onTap: (){
                Navigator.pop(context);
                Navigator.pop(context);
                CustomerHomePageLogic().tabChangedStream.dataReload(3);
              },
                child: Center(child: Container(
                    padding: EdgeInsets.only(right: screenWidth * 0.06),
                    child: SvgPicture.asset(
                      "assets/svg/vectorIcon.svg",
                      color: ThemeManager().getDarkGrey3Color,
                      width: screenWidth * 0.028,
                      height: screenWidth * 0.06,
                    )),),
              )),
            ],),
          ),
        ),
      ],
    ),);
    CustomerHomePageLogic().tabChangedStream.dataReload(1);
    return new WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(child: Scaffold(

        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //   runTest();
        //   },
        //   child: widget.shouldCollect?Text((widget.testDuration - widget.start).toString()):Icon(Icons.group_work_sharp),
        // ),
        // appBar: AppBar(
        //   title: Text(widget.duration.toString() +
        //       " second | " +
        //       widget.targetLoad.toString() +
        //       " kN"),
        //   actions: <Widget>[
        //
        //
        //
        //     StreamBuilder<bool>(
        //       stream: TestStartStopStream.getInstance().outData,
        //       initialData: false,
        //       builder: (c, snapshot) {
        //         if(snapshot.hasData && snapshot.data == true){
        //           return  Padding(
        //             padding: const EdgeInsets.all(8.0),
        //             child: InkWell(
        //
        //               //  onPressed: onPressed,
        //                 onTap: () async {
        //                   TestStartStopStream.getInstance().dataReload(false);
        //                 },
        //                 child: Icon(Icons.stop)),
        //           );
        //         }else{
        //           return Container(width: 0,height: 0,);
        //         }
        //       },
        //     )
        //   ],
        // ),

        //widget.data2.length > 0 && widget.shouldCollect == false
          body: Stack(
            children: [
              Scaffold(resizeToAvoidBottomInset: true,
                backgroundColor: ThemeManager().getWhiteColor,

                //-------------------------App bar of screen-------------------
                appBar: PreferredSize(
                  preferredSize: Size(0,kToolbarHeight),
                  child: AppBarCustom(appbarTitle: TextConst.testText,),
                ),

                //-------------------------Body of screen------------------
                body: SingleChildScrollView(physics: ClampingScrollPhysics(),

                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0,0, 0,60),
                    child: Container(

                      child: Column(
                        children: [

                          Container(
                            margin: EdgeInsets.only(left: width*0.05,right: width*0.05,top: height*0.025),
                            child: Column(
                              children: [

                                //-----------------Test finished view-----------
                                testFinish(),

                                //-----------------Test result view------------
                                testResultPass(),

                                //----------------Title---------------
                                Container(
                                  margin: EdgeInsets.only(top: height*0.02),
                                  alignment: Alignment.topLeft,
                                  child:Text(
                                      "Title",style: interMedium.copyWith(
                                      color: ThemeManager().getPopUpTextGreyColor,
                                      fontSize: width * 0.042)
                                  ),
                                ),

                                //--------------Title text field-----------
                                Container(
                                  margin: EdgeInsets.only(top: height * 0.015),
                                  child: TextFormField(controller: controllerTitle,onChanged: (val){
                                   setState(() {
                                     didUpdated = true ;
                                   });
                                    widget.customerFirestore
                                        .collection("pulltest")
                                        .doc(widget.id)
                                        .update({"name": val}).then((value) {
                                      print("Title Updated");
                                    });
                                  },
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      // hintText: "25-June 2021 9:46",
                                      hintStyle: interMedium.copyWith(
                                        color: ThemeManager().getLightGrey1Color,
                                        fontSize: width * 0.040,),
                                      focusedBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                          ),
                                          borderRadius: BorderRadius.circular(width * 0.014)),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: width * 0.045),
                                      fillColor: ThemeManager().getLightGreenTextFieldColor,
                                      filled: true,
                                    ),
                                  ),
                                ),

                                //-----------------Notes----------------
                                Container(
                                  margin: EdgeInsets.only(top: height*0.02),
                                  alignment: Alignment.topLeft,
                                  child:Text(
                                      "Notes",style: interMedium.copyWith(
                                      color: ThemeManager().getPopUpTextGreyColor,
                                      fontSize: width * 0.042)
                                  ),
                                ),

                                //-----------------Notes text field---------
                                Container(
                                  margin: EdgeInsets.only(top: height * 0.015),
                                  child: TextField(onSubmitted: (val){
                                    controllerTitle.selection = TextSelection(baseOffset: 0, extentOffset: controllerTitle.text.length);
                                  },onChanged: (val){
                                    widget.customerFirestore
                                        .collection("pulltest")
                                        .doc(widget.id)
                                        .update({"note": val}).then((value) {
                                      print("Note Updated");
                                    });
                                  },
                                    maxLines: 7,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      hintStyle: interMedium.copyWith(
                                        color: ThemeManager().getLightGrey1Color,
                                        fontSize: width * 0.040,),
                                      focusedBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                          ),
                                          borderRadius: BorderRadius.circular(width * 0.014)),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: width * 0.045),
                                      fillColor: ThemeManager().getLightGreenTextFieldColor,
                                      filled: true,
                                    ),
                                  ),
                                ),


                              ],
                            ),
                          ),

                          //--------------------------Test result data value-----------------------
                          testResultData(TextConst.peakLoadText,widget.peek ),
                          testResultData(TextConst.timedSectionStartedText,widget.start),
                          testResultData(TextConst.timedSectionFinishedText,widget.end),
                          Container(
                            margin: EdgeInsets.only(top: height*0.025),
                            color:ThemeManager().getBlackColor.withOpacity(.15),
                            height: height*0.001,
                            width: double.infinity,
                          ),

                          //-------------------------Select Folder button-------------------------------
                          saveButton(),
                        ],
                      ),

                    ),
                  ),
                ),
              ),
              Align(alignment: Alignment.bottomCenter,child: AppBottomNavigationar(context: context).getNavigationBar(level: 0),),
            ],
          ))),
    );



  }

  //-------------------------------------test finish view----------------------
  Widget testFinish(){
    return Container(
        child:Row(
          children: [
            Container(
              decoration: new BoxDecoration(
                color:ThemeManager().getDarkGreenColor,
                boxShadow: [
                  BoxShadow(
                    blurRadius:5,
                    color:ThemeManager().getDarkGreenColor,
                  )
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 15),
              alignment: Alignment.center,
              height: height*0.065,
              width: width*0.85 ,

              child: Text(
                  "Test Finished",style: interMedium.copyWith(
                  color: ThemeManager().getWhiteColor,
                  fontSize: width * 0.040)
              ),
            ),
            ClipPath(
              clipper: MyTriangle(),
              child:   Container(
                decoration: BoxDecoration(
                    color: ThemeManager().getDarkGreenColor
                ),
                width: width*0.05,
                height:height*0.03,
              ),
            ),

          ],
        )
    );
  }

  //--------------------------------test result pass view---------------------
  Widget testResultPass(){
    return   Container(
      margin: EdgeInsets.only(top: height*0.02),
      decoration: new BoxDecoration(
        color:ThemeManager().getLightGreenColor,
      ),
      padding: EdgeInsets.symmetric(horizontal: 15),
      alignment: Alignment.center,
      height: height*0.065,
      width: width*0.9,

      child: Text(
          "Test Result "+(widget.status ),style: interMedium.copyWith(
          color: ThemeManager().getDarkGreenColor,
          fontSize: width * 0.042)
      ),
    );
  }

  //-------------------------Select Folder button-------------------------------
  Widget saveButton(){
    return InkWell(onTap: (){
      CaptureScreensotStream.getInstance().dataReload(true);
      try{
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>AllFileFolderActivitySaveTestUIUX(
            customerFirestore: widget.customerFirestore,
            id: widget.id,
          )),
        );
      }catch(e){
        print(e);
        print("Save Ex");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>AllFileFolderActivitySaveTestUIUX(
            customerFirestore: widget.customerFirestore,
            id: widget.id,
          )),
        );
        // AppToast().show(message: e.toString());
        // Navigator.pop(context);
      }
      // Navigator.of(context).push(new MaterialPageRoute<Null>(
      //     builder: (BuildContext context) {
      //       String width = MediaQuery.of(context).size.width.ceil().toString();
      //
      //       final scaffoldState = GlobalKey<ScaffoldState>();
      //       return AllFileFolderActivitySaveTestUIUX(
      //         customerFirestore: widget.customerFirestore,
      //         id: widget.id,
      //       );
      //     },
      //     fullscreenDialog: true));

      //save test in folder

      // Navigator.popAndPushNamed(context,"/");
      // Navigator.pop(context);
      // Navigator.pop(context);
      //Navigator.pop(context);
    },
      child: Container(
        margin: EdgeInsets.only(top: height*0.02,bottom: height*0.03),
        decoration: new BoxDecoration(
            color:ThemeManager().getDarkGreenColor,
            borderRadius: BorderRadius.circular(10)
        ),
        padding: EdgeInsets.symmetric(horizontal: 15),
        alignment: Alignment.center,
        height: height*0.065,
        width: width*0.9,
        child: Text("Select Folder",style: interMedium.copyWith(
            color: ThemeManager().getWhiteColor,
            fontSize: width * 0.042)
        ),
      ),
    );
  }

  //--------------------------Test result data value-----------------------
  Widget testResultData(dataTitle, dataResult){
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: height*0.018),
          color:ThemeManager().getBlackColor.withOpacity(.15),
          height: height*0.001,
          width: double.infinity,
        ),
        Container(
          margin: EdgeInsets.only(top: height*0.018,left: width*0.06),
          child: Row(
            children: [
              Container(
                alignment: Alignment.topLeft,
                child:Text(
                    dataTitle,style: interMedium.copyWith(
                    color: ThemeManager().getBlackColor,
                    fontSize: width * 0.043)
                ),
              ),
              Container(
                child:Text(
                    dataResult,style: interMedium.copyWith(
                    color: ThemeManager().getDarkGreenColor,
                    fontSize: width * 0.043)
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void takeScreenSot() {
    try{
      ScreenshotController screenshotControllerDark = ScreenshotController();

      screenshotControllerDark.captureFromWidget(
          InheritedTheme.captureAll(
              context, Material(child: Container(color: Colors.white,height: MediaQuery.of(context).size.width*0.5,width: MediaQuery.of(context).size.width,child:widget.widToScreenSot))),
          delay: Duration(seconds: 3)).then((valueDark) {
        AppToast().show(message: "dark graph taken;");
        widget.customerFirestore
            .collection("pulltest")
            .doc(widget.id)
            .update({"graphImageDark": base64Encode(valueDark!)});


      });
    }catch(e){
      AppToast().show(message: e.toString());
    }

  }
}

class MyTriangle extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.addPolygon([
      Offset(0, size.height),
      Offset(0, 0),
      Offset(size.width, size.height/2)
    ], true);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

String getACurrentTimeStamp() {
  String date = "";
  DateTime now = DateTime.now();
  //"auto_generated" +
  date =
      now.day.toString() +
          "-" +
          getMonthName(now.month) +
          "-" +
          now.year.toString() +
          "   " +
          (now.hour <10? "0"+now.hour.toString():now.hour.toString()) +
          " : " +
          (now.minute <10? "0"+now.minute.toString():now.minute.toString());

  return date;
}