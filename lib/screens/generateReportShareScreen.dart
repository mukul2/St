import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/Activities/CustomBottomNavigationBar/appBottomNavigationBar.dart';
import 'package:connect/Activities/CustomerUserHome/logics.dart';
import 'package:connect/Activities/recordReviewActivity.dart';
import 'package:connect/Appabr/appbar_widget.dart';
import 'package:connect/Toast/AppToast.dart';
import 'package:connect/screens/popup/signatureDrawDialog.dart';
import 'package:connect/services/Firestoredatabase.dart';
import 'package:connect/streams/buttonStreams.dart';
import 'package:connect/utils/featureSettings.dart';
import 'package:connect/widgets/graph_with_selecttor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'package:connect/components/appBarCustom.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/textConst.dart';
import 'package:connect/utils/textStyleConst.dart';
import 'package:connect/utils/themeManager.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'dart:ui' as ui;

import '../calculator.dart';
import 'package:image/image.dart' as IMG;
import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;

class ReportItems{
   String title ;
   bool showing ;
   TextEditingController controller ;
  ReportItems({required this.title,required this.showing,required this.controller});
}
class GenerateReportShareScreen extends StatefulWidget {
  List files;
  List folders;
  String customerID;
  FirebaseFirestore firestore;
  GenerateReportShareScreen({required this.files,required this.folders,required this.firestore,required this.customerID});

  @override
  _GenerateReportShareScreenState createState() => _GenerateReportShareScreenState();
}

class _GenerateReportShareScreenState extends State<GenerateReportShareScreen> {
  TextEditingController controller1 = new TextEditingController();
  TextEditingController controller2 = new TextEditingController();
  TextEditingController controller3 = new TextEditingController();
  TextEditingController controller4 = new TextEditingController();



  TextEditingController controller5 = new TextEditingController();
  TextEditingController controller6 = new TextEditingController();
  TextEditingController controller7 = new TextEditingController();
  TextEditingController controller8 = new TextEditingController();

  TextEditingController controller9 = new TextEditingController();
  TextEditingController controller10 = new TextEditingController();
  TextEditingController controller11 = new TextEditingController();

  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();

  bool showHintText = true;
  String signatureString = "";

  List<ReportItems> allReportItems = [];



  bool _hideHintText() {
    setState(() {
      showHintText=false;
    });
    return showHintText;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allReportItems.clear();
    allReportItems.add(ReportItems(title: "Customer Company Address", showing: false,controller: controller5));
    allReportItems.add(ReportItems(title: "Customer Contact Name", showing: false,controller: controller6));
    allReportItems.add(ReportItems(title: "Customer Contact Telephone", showing: false,controller: controller7));
    allReportItems.add(ReportItems(title: "Customer Contact Email", showing: false,controller: controller8));
    allReportItems.add(ReportItems(title: "Site Name", showing: false,controller: controller9));
    allReportItems.add(ReportItems(title: "Site Address", showing: false,controller: controller10));
    allReportItems.add(ReportItems(title: "Test Conclusions", showing: false,controller: controller11));
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;



    CustomerHomePageLogic().tabChangedStream.dataReload(3);
    return SafeArea(
      child: Scaffold(
        backgroundColor: ThemeManager().getWhiteColor,

        //----------------------- App Bar --------------------------


        //---------------------Body of screen-----------------
        body:   Stack(
          children: [
            SingleChildScrollView(

                child: Column(
                  children: [
                    ApplicationAppbar(). getAppbar(title: "Reports"),
                    //---------------------------Add Report Detail -------------------------------
                    addReportDetailForm(),
                    ListView.builder(shrinkWrap: true,
                      itemCount: allReportItems.length,physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                      if(allReportItems[index].showing){
                        return Container(  margin: EdgeInsets.only(
                          left: width * 0.06,
                          right: width * 0.06,
                          //top: height * 0.020,
                        ),
                          child: Column(  crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text( allReportItems[index].title, style: interMedium.copyWith(
                                    color: ThemeManager().getBlackColor,
                                    fontSize: width * 0.036,
                                  ),),  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Text( "* Optional", style: interMedium.copyWith(
                                      color: ThemeManager().getDarkGrey2Color,
                                      fontSize: width * 0.030,
                                    ),),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(top: height * 0.015,bottom: height*0.02),
                                child: TextFormField(validator: (val){
                                  //  if(val!.isEmpty)return "Title cannot be empty";

                                },controller: allReportItems[index].controller,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(suffixIcon:  IconButton(icon: Icon(Icons.close,color: ThemeManager().getRedColor,),onPressed: (){
                                    setState(() {
                                      allReportItems[index].showing = false;

                                    });
                                  },),
                                    border: InputBorder.none,
                                    hintStyle: interMedium.copyWith(
                                      color: ThemeManager().getLightGrey4Color,
                                      fontSize: width * 0.036,),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                        ),
                                        borderRadius: BorderRadius.circular(width * 0.014)),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: height * 0.01, horizontal: width * 0.045),
                                    fillColor: ThemeManager().getLightGreenTextFieldColor,
                                    filled: true,
                                  ),
                                ),
                              ),

                            ],
                          ),
                        );
                      }else{
                        return Container(height: 0,width: 0,);
                      }

                      },
                    ),
                    addReportDetailFormButtons()
                  ],
                )
            ),
            Align(alignment: Alignment.bottomCenter,child: AppBottomNavigationar(context: context).getNavigationBar(level: 0)),
          ],
        )




      ),
    );
  }

  Widget addReportDetailForm()
  {
    final _formKey = GlobalKey<FormState>();
    return Container(
      margin: EdgeInsets.only(
        left: width * 0.06,
        right: width * 0.06,
        top: height * 0.020,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          //------------------Report Title and textField--------------------------
          Row(
            children: [
              Text( TextConst.reportTitleText, style: interMedium.copyWith(
                color: ThemeManager().getBlackColor,
                fontSize: width * 0.036,
              ),),  Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text( "* Mandatory", style: interMedium.copyWith(
                  color: ThemeManager().getDarkGrey2Color,
                  fontSize: width * 0.030,
                ),),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: height * 0.015,bottom: height*0.02),
            child: TextFormField(validator: (val){
              if(val!.isEmpty)return "Title cannot be empty";

            },controller: controller1,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(suffixIcon: Icon(Icons.edit,color: ThemeManager().getDarkGreenColor,),
                border: InputBorder.none,
                hintStyle: interMedium.copyWith(
                  color: ThemeManager().getLightGrey4Color,
                  fontSize: width * 0.036,),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(width * 0.014)),
                contentPadding: EdgeInsets.symmetric(
                    vertical: height * 0.01, horizontal: width * 0.045),
                fillColor: ThemeManager().getLightGreenTextFieldColor,
                filled: true,
              ),
            ),
          ),

          //------------------ Company Information and textField-----------------------
          Row(
            children: [
              Text( "Customer Company Name", style: interMedium.copyWith(
                color: ThemeManager().getBlackColor,
                fontSize: width * 0.036,
              ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text( "* Mandatory", style: interMedium.copyWith(
                  color: ThemeManager().getDarkGrey2Color,
                  fontSize: width * 0.030,
                ),),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: height * 0.015,bottom: height*0.02),
            child: TextFormField(validator: (val){
              if(val!.isEmpty)return "Company name cannot be empty";

            },controller: controller2,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(suffixIcon: Icon(Icons.edit,color: ThemeManager().getDarkGreenColor,),
                border: InputBorder.none,
                hintStyle: interMedium.copyWith(
                  color: ThemeManager().getLightGrey4Color,
                  fontSize: width * 0.036,),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(width * 0.014)),
                contentPadding: EdgeInsets.symmetric(
                    vertical: height * 0.01, horizontal: width * 0.045),
                fillColor: ThemeManager().getLightGreenTextFieldColor,
                filled: true,
              ),
            ),
          ),

          // Row(
          //   children: [
          //     Text( "Customer Company Address", style: interMedium.copyWith(
          //       color: ThemeManager().getBlackColor,
          //       fontSize: width * 0.036,
          //     ),
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.only(left: 15),
          //       child: Text( "Optional", style: interMedium.copyWith(
          //         color: ThemeManager().getDarkGrey2Color,
          //         fontSize: width * 0.030,
          //       ),),
          //     ),
          //
          //   ],
          // ),
          // Container(
          //   margin: EdgeInsets.only(top: height * 0.015,bottom: height*0.02),
          //   child: TextFormField(controller: controller5,
          //     keyboardType: TextInputType.text,
          //     decoration: InputDecoration(suffixIcon: Icon(Icons.edit,color: ThemeManager().getDarkGreenColor,),
          //       border: InputBorder.none,
          //       hintStyle: interMedium.copyWith(
          //         color: ThemeManager().getLightGrey4Color,
          //         fontSize: width * 0.036,),
          //       enabledBorder: OutlineInputBorder(
          //           borderSide: BorderSide(
          //             color: Colors.transparent,
          //           ),
          //           borderRadius: BorderRadius.circular(width * 0.014)),
          //       contentPadding: EdgeInsets.symmetric(
          //           vertical: height * 0.01, horizontal: width * 0.045),
          //       fillColor: ThemeManager().getLightGreenTextFieldColor,
          //       filled: true,
          //     ),
          //   ),
          // ),
          //
          // Row(
          //   children: [
          //     Text( "Customer Contact Name", style: interMedium.copyWith(
          //       color: ThemeManager().getBlackColor,
          //       fontSize: width * 0.036,
          //     ),
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.only(left: 15),
          //       child: Text( "Optional", style: interMedium.copyWith(
          //         color: ThemeManager().getDarkGrey2Color,
          //         fontSize: width * 0.030,
          //       ),),
          //     ),
          //
          //   ],
          // ),
          // Container(
          //   margin: EdgeInsets.only(top: height * 0.015,bottom: height*0.02),
          //   child: TextFormField(controller: controller6,
          //     keyboardType: TextInputType.text,
          //     decoration: InputDecoration(suffixIcon: Icon(Icons.edit,color: ThemeManager().getDarkGreenColor,),
          //       border: InputBorder.none,
          //       hintStyle: interMedium.copyWith(
          //         color: ThemeManager().getLightGrey4Color,
          //         fontSize: width * 0.036,),
          //       enabledBorder: OutlineInputBorder(
          //           borderSide: BorderSide(
          //             color: Colors.transparent,
          //           ),
          //           borderRadius: BorderRadius.circular(width * 0.014)),
          //       contentPadding: EdgeInsets.symmetric(
          //           vertical: height * 0.01, horizontal: width * 0.045),
          //       fillColor: ThemeManager().getLightGreenTextFieldColor,
          //       filled: true,
          //     ),
          //   ),
          // ),
          //
          // Row(
          //   children: [
          //     Text( "Customer Contact Telephone", style: interMedium.copyWith(
          //       color: ThemeManager().getBlackColor,
          //       fontSize: width * 0.036,
          //     ),
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.only(left: 15),
          //       child: Text( "Optional", style: interMedium.copyWith(
          //         color: ThemeManager().getDarkGrey2Color,
          //         fontSize: width * 0.030,
          //       ),),
          //     ),
          //   ],
          // ),
          // Container(
          //   margin: EdgeInsets.only(top: height * 0.015,bottom: height*0.02),
          //   child: TextFormField(controller: controller7,
          //     keyboardType: TextInputType.text,
          //     decoration: InputDecoration(suffixIcon: Icon(Icons.edit,color: ThemeManager().getDarkGreenColor,),
          //       border: InputBorder.none,
          //       hintStyle: interMedium.copyWith(
          //         color: ThemeManager().getLightGrey4Color,
          //         fontSize: width * 0.036,),
          //       enabledBorder: OutlineInputBorder(
          //           borderSide: BorderSide(
          //             color: Colors.transparent,
          //           ),
          //           borderRadius: BorderRadius.circular(width * 0.014)),
          //       contentPadding: EdgeInsets.symmetric(
          //           vertical: height * 0.01, horizontal: width * 0.045),
          //       fillColor: ThemeManager().getLightGreenTextFieldColor,
          //       filled: true,
          //     ),
          //   ),
          // ),
          //
          // Row(
          //   children: [
          //     Text( "Customer Contact Email", style: interMedium.copyWith(
          //       color: ThemeManager().getBlackColor,
          //       fontSize: width * 0.036,
          //     ),
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.only(left: 15),
          //       child: Text( "Optional", style: interMedium.copyWith(
          //         color: ThemeManager().getDarkGrey2Color,
          //         fontSize: width * 0.030,
          //       ),),
          //     ),
          //   ],
          // ),
          // Container(
          //   margin: EdgeInsets.only(top: height * 0.015,bottom: height*0.02),
          //   child: TextFormField(controller: controller8,
          //     keyboardType: TextInputType.text,
          //     decoration: InputDecoration(suffixIcon: Icon(Icons.edit,color: ThemeManager().getDarkGreenColor,),
          //       border: InputBorder.none,
          //       hintStyle: interMedium.copyWith(
          //         color: ThemeManager().getLightGrey4Color,
          //         fontSize: width * 0.036,),
          //       enabledBorder: OutlineInputBorder(
          //           borderSide: BorderSide(
          //             color: Colors.transparent,
          //           ),
          //           borderRadius: BorderRadius.circular(width * 0.014)),
          //       contentPadding: EdgeInsets.symmetric(
          //           vertical: height * 0.01, horizontal: width * 0.045),
          //       fillColor: ThemeManager().getLightGreenTextFieldColor,
          //       filled: true,
          //     ),
          //   ),
          // ),
          //
          //
          // Row(
          //   children: [
          //     Text( "Site Name", style: interMedium.copyWith(
          //       color: ThemeManager().getBlackColor,
          //       fontSize: width * 0.036,
          //     ),
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.only(left: 15),
          //       child: Text( "Optional", style: interMedium.copyWith(
          //         color: ThemeManager().getDarkGrey2Color,
          //         fontSize: width * 0.030,
          //       ),),
          //     ),
          //   ],
          // ),
          // Container(
          //   margin: EdgeInsets.only(top: height * 0.015,bottom: height*0.02),
          //   child: TextFormField(controller: controller9,
          //     keyboardType: TextInputType.text,
          //     decoration: InputDecoration(suffixIcon: Icon(Icons.edit,color: ThemeManager().getDarkGreenColor,),
          //       border: InputBorder.none,
          //       hintStyle: interMedium.copyWith(
          //         color: ThemeManager().getLightGrey4Color,
          //         fontSize: width * 0.036,),
          //       enabledBorder: OutlineInputBorder(
          //           borderSide: BorderSide(
          //             color: Colors.transparent,
          //           ),
          //           borderRadius: BorderRadius.circular(width * 0.014)),
          //       contentPadding: EdgeInsets.symmetric(
          //           vertical: height * 0.01, horizontal: width * 0.045),
          //       fillColor: ThemeManager().getLightGreenTextFieldColor,
          //       filled: true,
          //     ),
          //   ),
          // ),
          //
          // Row(
          //   children: [
          //     Text( "Site Address", style: interMedium.copyWith(
          //       color: ThemeManager().getBlackColor,
          //       fontSize: width * 0.036,
          //     ),
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.only(left: 15),
          //       child: Text( "Optional", style: interMedium.copyWith(
          //         color: ThemeManager().getDarkGrey2Color,
          //         fontSize: width * 0.030,
          //       ),),
          //     ),
          //   ],
          // ),
          // Container(
          //   margin: EdgeInsets.only(top: height * 0.015,bottom: height*0.02),
          //   child: TextFormField(controller: controller10,
          //     keyboardType: TextInputType.text,
          //     decoration: InputDecoration(suffixIcon: Icon(Icons.edit,color: ThemeManager().getDarkGreenColor,),
          //       border: InputBorder.none,
          //       hintStyle: interMedium.copyWith(
          //         color: ThemeManager().getLightGrey4Color,
          //         fontSize: width * 0.036,),
          //       enabledBorder: OutlineInputBorder(
          //           borderSide: BorderSide(
          //             color: Colors.transparent,
          //           ),
          //           borderRadius: BorderRadius.circular(width * 0.014)),
          //       contentPadding: EdgeInsets.symmetric(
          //           vertical: height * 0.01, horizontal: width * 0.045),
          //       fillColor: ThemeManager().getLightGreenTextFieldColor,
          //       filled: true,
          //     ),
          //   ),
          // ),
          //
          //
          // Row(
          //   children: [
          //     Text( "Test Conclusions", style: interMedium.copyWith(
          //       color: ThemeManager().getBlackColor,
          //       fontSize: width * 0.036,
          //     ),
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.only(left: 15),
          //       child: Text( "Optional", style: interMedium.copyWith(
          //         color: ThemeManager().getDarkGrey2Color,
          //         fontSize: width * 0.030,
          //       ),),
          //     ),
          //   ],
          // ),
          // Container(
          //   margin: EdgeInsets.only(top: height * 0.015,bottom: height*0.02),
          //   child: TextFormField(controller: controller11,
          //     keyboardType: TextInputType.text,
          //     decoration: InputDecoration(suffixIcon: Icon(Icons.edit,color: ThemeManager().getDarkGreenColor,),
          //       border: InputBorder.none,
          //       hintStyle: interMedium.copyWith(
          //         color: ThemeManager().getLightGrey4Color,
          //         fontSize: width * 0.036,),
          //       enabledBorder: OutlineInputBorder(
          //           borderSide: BorderSide(
          //             color: Colors.transparent,
          //           ),
          //           borderRadius: BorderRadius.circular(width * 0.014)),
          //       contentPadding: EdgeInsets.symmetric(
          //           vertical: height * 0.01, horizontal: width * 0.045),
          //       fillColor: ThemeManager().getLightGreenTextFieldColor,
          //       filled: true,
          //     ),
          //   ),
          // ),
          //------------------ Tester's Name and textField ------------------


          //------------------ Site Details and textField-----------------------




        ],
      ),
    );
  }
  Widget addReportDetailFormButtons()
  {
    final _formKey = GlobalKey<FormState>();
    return Container(
      margin: EdgeInsets.only(
        left: width * 0.06,
        right: width * 0.06,
        top: height * 0.020,
        bottom: height * 0.020,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: (){
              showDialog(context: context,
                  builder: (BuildContext context){
                return Dialog(
                  child: Wrap(
                    children: [
                      Container(  margin: EdgeInsets.only(
                  left: width * 0.06,
                    right: width * 0.06,
                    top: height * 0.016,
                    bottom: height * 0.004,
                  ),
                        child: Center(
                          child: Text( "Additional Fields", style: interBold.copyWith(
                            color: ThemeManager().getDarkGreenColor,
                            fontSize: width * 0.050,
                          ),),
                        ),
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                      ListView.separated(shrinkWrap: true,
                        separatorBuilder: (context, index) =>allReportItems[index].showing == false? Divider(
                          color: Colors.black,
                        ):Container(height: 0,width: 0,),
                        itemCount: allReportItems.length,physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          if(allReportItems[index].showing == false){
                            return InkWell(onTap: (){
                              setState(() {
                                allReportItems[index].showing = true;

                              });
                              Navigator.pop(context);
                            },
                              child: Container(  margin: EdgeInsets.only(
                                left: width * 0.06,
                                right: width * 0.03,
                                top: height * 0.001,
                                bottom: height * 0.001,
                              ),
                                child:  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text( allReportItems[index].title, style: interMedium.copyWith(
                                      color: ThemeManager().getBlackColor,
                                      fontSize: width * 0.036,
                                    ),),
                                    IconButton(onPressed: (){
                                      setState(() {
                                        allReportItems[index].showing = true;

                                      });
                                      Navigator.pop(context);
                                    },icon: Icon(Icons.add_circle_outlined,color: ThemeManager().getDarkGreenColor,),),
                                  ],
                                ),
                              ),
                            );
                          }else{
                            return Container(height: 0,width: 0,);
                          }

                        },
                      ),
                    ],
                  ),
                );


                  }
              );
            },
            child: Container(decoration: BoxDecoration(color:  ThemeManager().getDarkBlueColor,borderRadius: BorderRadius.circular(5)),
              height: height*0.065,
              width: width,
              alignment: Alignment.center,
              child: Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Add Field",
                    style: interSemiBold.copyWith(
                        fontSize: width * 0.047,
                        color: ThemeManager().getWhiteColor),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text( "* Optional", style: interMedium.copyWith(
                      color: ThemeManager().getWhiteColor,
                      fontSize: width * 0.028,
                    ),),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              showDialog(context: context,
                  builder: (BuildContext context){
                    return DrawSignatureDialog(onFinished: (String d ) {
                      signatureString =  d;
                      Navigator.pop(context);
                      print(d);
                    },);
                  }
              );
            },
            child: Container( margin: EdgeInsets.only(top: height * 0.01,),
              height: height*0.065, decoration: BoxDecoration(color:  ThemeManager().getYellowGradientColor,borderRadius: BorderRadius.circular(5)),

              width: width,
              alignment: Alignment.center,
              child: Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Add Signature",
                    style: interSemiBold.copyWith(
                        fontSize: width * 0.047,
                        color: ThemeManager().getWhiteColor),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text( "* Mandatory", style: interMedium.copyWith(
                      color: ThemeManager().getWhiteColor,
                      fontSize: width * 0.028,
                    ),),
                  ),
                ],
              ),
            ),
          ),
          //------------------ Share Button ------------------------------------
          GestureDetector(
            onTap: () async {
              //go back

              var pdf;
              //pdf = pw.Document();
              pdf = pw.Document(deflate: zlib.encode);
              final font = await rootBundle.load("assets/fonts/Inter-Regular.ttf");
              final fontB = await rootBundle.load("assets/fonts/Inter-SemiBold.ttf");
              final  fontData = await rootBundle.load("assets/opensans.ttf");
              final ttf = pw.Font.ttf(fontData);
              final ttfBold = pw.Font.ttf(fontB);
              // ReportGenerateProgressStream.getInstance()
              int totalItems = widget.files.length;
              // ReportTestCounterStream.getInstance().dataReload(totalItems);
              ReportFolderCounterStream.getInstance().dataReload(widget.folders.length);
              //password check should be done
              //_formKey.currentState!.validate()
              if(controller1.text.isNotEmpty) {
                if (controller2.text.isNotEmpty) {
                  print("genrate report clicked");
                  final df = new DateFormat('mm:ss');
                  final dfDate = new DateFormat('dd MMM yyyy HH:mm');
                  AppToast().show(message: "genrate report clicked");
                  //ReportTestCounterStream.getInstance()

                  if(true){

                    var  imageCustomerLogo ;
                    var customerInfo = await    FirebaseFirestore.instance.collection("customers").doc(widget.customerID).get();
                    var reporterInfo = await    FirebaseFirestore.instance.collection("users").where("uid",isEqualTo:FirebaseAuth.instance.currentUser!.uid).get();
                    bool hasCustomerLogo = false;
                    Map<String, dynamic> customerData = customerInfo.data()! as Map<String, dynamic>;
                    Map<String, dynamic> userInfoMap = reporterInfo.docs.first.data()! as Map<String, dynamic>;
                    if(customerData.containsKey("logo") && customerData["logo"]!=null && customerData["logo"].toString().length>5){

                      imageCustomerLogo = pw.MemoryImage(
                          base64Decode(customerData["logo"])
                      );
                      hasCustomerLogo = true;
                    }

                    try{
                      var signatureImage = pw.MemoryImage(base64Decode(signatureString));
                      double tabHeight = 40.0;
                      double tabWidth = 180.0;

                      if(true){
                        pdf.addPage(pw.Page(
                            pageFormat: PdfPageFormat.a4,
                            build: (pw.Context context) {
                              return pw.Stack(children: [
                                pw.Align(alignment: pw.Alignment.topCenter,child: pw.Column(mainAxisAlignment: pw.MainAxisAlignment.start,crossAxisAlignment: pw.CrossAxisAlignment.end,
                                    children: [

                                      if(hasCustomerLogo)  pw.Padding(padding: pw.EdgeInsets.only(bottom: 10,top: 10),child:pw.Image(imageCustomerLogo,height: 85) ),
                                      pw.Text(customerData["prjectName"],style: pw.TextStyle(fontSize: 18,font: ttf),textAlign: pw.TextAlign.right),
                                      pw.Padding(padding: pw.EdgeInsets.only(top: 10),child:pw.Text(customerData["address"],style: pw.TextStyle(fontSize: 12,color: PdfColors.black,font: ttf),textAlign: pw.TextAlign.right), ),

                                      pw.Text(customerData["email"],style: pw.TextStyle(fontSize: 12,color: PdfColors.black,font: ttf),textAlign: pw.TextAlign.right),

                                      pw.Text(customerData["telephone"],style: pw.TextStyle(fontSize: 12,color: PdfColors.black,font: ttf),textAlign: pw.TextAlign.right),





                                      pw.Padding(padding: pw.EdgeInsets.only(top: 20,bottom: 10),child:pw.Container(decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),child: pw.Column(mainAxisAlignment: pw.MainAxisAlignment.start,crossAxisAlignment: pw.CrossAxisAlignment.start,
                                          children: [
                                            // pw.Divider(color: PdfColors.white),
                                            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start,crossAxisAlignment: pw.CrossAxisAlignment.center,children:[
                                              pw.Container(height: 30,decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),width: tabWidth,child: pw.Center(child: pw.Align(alignment: pw.Alignment.centerLeft,child: pw.Text("    Report Title",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,font: ttf)))),),

                                              pw.Container(height: 30,decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),width:  500-tabWidth,child: pw.Center(child: pw.Align(alignment: pw.Alignment.centerLeft,child: pw.Text("   "+controller1.text,style: pw.TextStyle(font: ttf)))),),
                                            ] ),
                                            // pw.Divider(),


                                            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start,crossAxisAlignment: pw.CrossAxisAlignment.center,children:[
                                              pw.Container(height: 30,decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),width: tabWidth,child: pw.Center(child: pw.Align(alignment: pw.Alignment.centerLeft,child: pw.Text("    Report Date",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,font: ttf)))),),
                                              pw.Container(height: 30,decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),width:  500-tabWidth,child: pw.Center(child:     pw.Align(alignment: pw.Alignment.centerLeft,child: pw.Text("   "+dfDate.format(DateTime.now()),style: pw.TextStyle(font: ttf))) ),),
                                            ] ),
                                            // pw.Divider(),


                                            pw.Container(height: 30,child:pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start,crossAxisAlignment: pw.CrossAxisAlignment.center,children:[
                                              pw.Container(height: 30,decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),width: tabWidth,child: pw.Align(alignment: pw.Alignment.centerLeft,child: pw.Text("   Compiled By",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,font: ttf))),),
                                              pw.Container(height: 30,decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),width:  500-tabWidth,child: pw.Padding(padding: pw.EdgeInsets.all(0),child: pw.Align(alignment: pw.Alignment.centerLeft,child: pw.Text("    "+(userInfoMap.containsKey("displayName")?userInfoMap["displayName"]:"--"),style: pw.TextStyle(font: ttf)))),),
                                            ] ), ),

                                            // pw.Divider(),


                                            //  pw.Container(width: double.infinity,decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),child: ),
                                            // pw.Container(width: double.infinity,decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),child: pw.Padding(padding: pw.EdgeInsets.all(5),child: pw.Text(,style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
                                            //  pw.Container(width: double.infinity,decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),child: pw.Padding(padding: pw.EdgeInsets.all(5),child: pw.Text(,style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
                                            // pw.Container(width: double.infinity,decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),child: pw.Padding(padding: pw.EdgeInsets.all(5),child: pw.Text("Site Address",style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
                                            // pw.Container(width: double.infinity,decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),child: pw.Padding(padding: pw.EdgeInsets.all(5),child: pw.Text("Customer Contact Name",style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
                                            //pw.Container(width: double.infinity,decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),child: pw.Padding(padding: pw.EdgeInsets.all(5),child: pw.Text("Customer Contact Tel",style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
                                            //   pw.Container(width: double.infinity,decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),child: pw.Padding(padding: pw.EdgeInsets.all(5),child: pw.Text("Customer Contact Email",style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
                                            // pw.Container(width: double.infinity,decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),child: pw.Padding(padding: pw.EdgeInsets.all(5),child: pw.Text("Test Conclusion",style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),

                                          ]
                                      ))

                                      ),



                                      pw.Row(
                                          children: [
                                            pw.Text("Signature",style: pw.TextStyle(font: ttf)),
                                            pw.Padding(padding: pw.EdgeInsets.only(right: 10),child: pw.Image(signatureImage,height: 50),),

                                          ]
                                      ),

                                      pw.Padding(padding: pw.EdgeInsets.only(top: 10,bottom: 00),child:pw.Container(decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),child: pw.Column(mainAxisAlignment: pw.MainAxisAlignment.start,crossAxisAlignment: pw.CrossAxisAlignment.start,
                                          children: [
                                            // pw.Divider(color: PdfColors.white),
                                            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start,crossAxisAlignment: pw.CrossAxisAlignment.center,children:[
                                              pw.Container(height: tabHeight,decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),width: tabWidth,child: pw.Align(alignment: pw.Alignment.centerLeft,child: pw.Text("    Customer Company Name",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,font: ttf))),),

                                              pw.Container(height: tabHeight,decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),width: 500-tabWidth,child: pw.Align(alignment: pw.Alignment.centerLeft,child: pw.Text("   "+controller2.text,maxLines: 3,style: pw.TextStyle(font: ttf))),),
                                            ] ),
                                            // pw.Divider(),


                                            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start,crossAxisAlignment: pw.CrossAxisAlignment.center,children:[
                                              pw.Container(height: tabHeight,decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),width: tabWidth,child: pw.Align(alignment: pw.Alignment.centerLeft,child: pw.Text("    Customer Address",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,font: ttf))),),
                                              pw.Container(height: tabHeight,decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),width:  500-tabWidth,child: pw.Align(alignment: pw.Alignment.centerLeft,child: pw.Text("   "+controller5.text,maxLines: 3,style: pw.TextStyle(font: ttf))),),
                                            ] ),
                                            // pw.Divider(),
                                            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start,crossAxisAlignment: pw.CrossAxisAlignment.center,children:[
                                              pw.Container(height: tabHeight,decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),width: tabWidth,child: pw.Align(alignment: pw.Alignment.centerLeft,child: pw.Text("    Site Name",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,font: ttf))),),
                                              pw.Container(height: tabHeight,decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),width:  500-tabWidth,child: pw.Align(alignment: pw.Alignment.centerLeft,child: pw.Text("   "+controller9.text,maxLines: 3,style: pw.TextStyle(font: ttf))),),
                                            ] ),
                                            // pw.Divider(),

                                            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start,crossAxisAlignment: pw.CrossAxisAlignment.center,children:[
                                              pw.Container(height: tabHeight,decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),width: tabWidth,child: pw.Align(alignment: pw.Alignment.centerLeft,child: pw.Text("    Site Address",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,font: ttf))),),
                                              pw.Container(height: tabHeight,decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),width:  500-tabWidth,child: pw.Align(alignment: pw.Alignment.centerLeft,child: pw.Text("   "+controller10.text,maxLines: 3,style: pw.TextStyle(font: ttf))),),
                                            ] ),
                                            // pw.Divider(),

                                            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start,crossAxisAlignment: pw.CrossAxisAlignment.center,children:[
                                              pw.Container(height: tabHeight,decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),width: tabWidth,child: pw.Align(alignment: pw.Alignment.centerLeft,child: pw.Text("    Customer Contact Name",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,font: ttf))),),
                                              pw.Container(height: tabHeight,decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),width:  500-tabWidth,child: pw.Align(alignment: pw.Alignment.centerLeft,child: pw.Text("   "+controller6.text,maxLines: 3,style: pw.TextStyle(font: ttf))),),
                                            ] ),
                                            // pw.Divider(),

                                            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start,crossAxisAlignment: pw.CrossAxisAlignment.center,children:[
                                              pw.Container(height: tabHeight,decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),width: tabWidth,child: pw.Align(alignment: pw.Alignment.centerLeft,child: pw.Text("    Customer Contact Tel",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,font: ttf))),),
                                              pw.Container(height: tabHeight,decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),width:  500-tabWidth,child: pw.Align(alignment: pw.Alignment.centerLeft,child: pw.Text("   "+controller7.text,maxLines: 3,style: pw.TextStyle(font: ttf))),),
                                            ] ),
                                            // pw.Divider(),
                                            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start,crossAxisAlignment: pw.CrossAxisAlignment.center,children:[
                                              pw.Container(height: tabHeight,decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),width: tabWidth,child: pw.Align(alignment: pw.Alignment.centerLeft,child: pw.Text("    Customer Contact Email",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,font: ttf))),),
                                              pw.Container(height: tabHeight,decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),width:  500-tabWidth,child: pw.Align(alignment: pw.Alignment.centerLeft,child: pw.Text("   "+controller8.text,maxLines: 3,style: pw.TextStyle(font: ttf))),),
                                            ] ),
                                            //  pw.Divider(),

                                            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start,crossAxisAlignment: pw.CrossAxisAlignment.center,children:[
                                              pw.Container(height: tabHeight,decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),width: tabWidth,child: pw.Align(alignment: pw.Alignment.centerLeft,child: pw.Text("    Test Conclusion",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,font: ttf))),),
                                              pw.Container(height: tabHeight,decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),width:  500-tabWidth,child: pw.Align(alignment: pw.Alignment.centerLeft,child: pw.Text("   "+controller11.text,maxLines: 3,style: pw.TextStyle(font: ttf))),),
                                            ] ),

                                            //  pw.Container(width: double.infinity,decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),child: ),
                                            // pw.Container(width: double.infinity,decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),child: pw.Padding(padding: pw.EdgeInsets.all(5),child: pw.Text(,style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
                                            //  pw.Container(width: double.infinity,decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),child: pw.Padding(padding: pw.EdgeInsets.all(5),child: pw.Text(,style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
                                            // pw.Container(width: double.infinity,decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),child: pw.Padding(padding: pw.EdgeInsets.all(5),child: pw.Text("Site Address",style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
                                            // pw.Container(width: double.infinity,decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),child: pw.Padding(padding: pw.EdgeInsets.all(5),child: pw.Text("Customer Contact Name",style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
                                            //pw.Container(width: double.infinity,decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),child: pw.Padding(padding: pw.EdgeInsets.all(5),child: pw.Text("Customer Contact Tel",style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
                                            //   pw.Container(width: double.infinity,decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),child: pw.Padding(padding: pw.EdgeInsets.all(5),child: pw.Text("Customer Contact Email",style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
                                            // pw.Container(width: double.infinity,decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),child: pw.Padding(padding: pw.EdgeInsets.all(5),child: pw.Text("Test Conclusion",style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),

                                          ]
                                      ))

                                      ),

                                    ]
                                )),

                                pw.Align(alignment: pw.Alignment.bottomCenter,child: pw.Row(
                                    children: [
                                      pw.Padding(padding: pw.EdgeInsets.only(right: 50),child:pw.Text("Powered by Staht Connect",style: pw.TextStyle(color: PdfColors.grey,font: ttf)), ),
                                    ]
                                )),
                              ]); // Center
                            }));




                      }



                    }catch(e){
                      AppToast().show(message: e.toString());

                    }
                  }










                  showDialog<void>(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Wrap(
                          children: [
                            // StreamBuilder<int>(
                            //     stream: ReportFolderCounterStream.getInstance().outData,
                            //     initialData: 0,
                            //     builder: (context, snapshot) {
                            //       return ListTile(title: Text('Total Folders'), trailing: Text(snapshot.data.toString(),style: TextStyle(color: ThemeManager().getDarkGreenColor,fontWeight: FontWeight.bold),),);
                            //     } ), StreamBuilder<int>(
                            //     stream: ReportTestCounterStream.getInstance().outData,
                            //     initialData: 0,
                            //     builder: (context, snapshot) {
                            //       return ListTile(title: Text('Total Tests'), trailing: Text(snapshot.data.toString(),style: TextStyle(color: ThemeManager().getDarkGreenColor,fontWeight: FontWeight.bold),),);
                            //     } ),
                            StreamBuilder<int>(
                                stream: ReportGenerateProgressStream.getInstance().outData,
                                builder: (context, snapshot) {
                                  return ListTile(title: Text('Generating Report'), subtitle: LinearProgressIndicator(value:snapshot.hasData?( (snapshot.data!)/100 ):0,),);
                                } ),
                            StreamBuilder<int>(
                                stream: ReportTestCounterStream.getInstance().outData,
                                builder: (context, snapshot) {
                                  if(snapshot.hasData)
                                    return ListTile(trailing: Text(snapshot.data.toString()+" seconds") ,title: Text('Time to finish'),);
                                  else
                                    return ListTile(trailing: Text(" Calculating..") ,title: Text('Time to finish'),);

                                } ),

                          ],
                        ),
                      )).whenComplete(() {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    CustomerHomePageLogic().tabChangedStream.dataReload(0);
                  });

                  realwork() async {

                    print(widget.files);
                    if (true) {
                      // Uint8List dataSignature = Uint8List
                      //     .fromList([]);
                      // final ui.Image imageData =
                      //     await signatureGlobalKey
                      //     .currentState!
                      //     .toImage(
                      //     pixelRatio: 3.0);
                      // final ByteData? bytes =
                      //     await imageData.toByteData(
                      //     format: ui
                      //         .ImageByteFormat
                      //         .png);
                      // if (bytes != null) {
                      //   dataSignature = bytes.buffer
                      //       .asUint8List();
                      // }

                      List<dynamic> reports = [];
                      getNextData() async {
                        print(widget.files.last);

                        List<Widget> testImage = [];

                        doNext() async {
                          widget.files.removeLast();

                          if (widget.files.length > 0) {
                            ReportGenerateProgressStream.getInstance().dataReload((100*(( totalItems-widget.files.length)/totalItems)).toInt());
                            ReportTestCounterStream.getInstance().dataReload((((2)*(widget.files.length)+(totalItems*0.4))).toInt());
                            await getNextData();
                          } else {





                            widget.firestore!.collection("reports").add({
                              "report_by": FirebaseAuth.instance.currentUser!.uid,
                              "field_1": controller1.text,
                              "field_2": controller2.text,
                              "field_3": controller3.text,
                              "field_4": controller4.text,
                              "field_5": controller5.text,
                              "field_6": controller6.text,
                              "field_7": controller7.text,
                              "field_8": controller8.text,
                              "field_9": controller9.text,
                              "field_10": controller10.text,
                              "field_11": controller11.text,
                              // "data": reports,
                              "created_at": DateTime.now().millisecondsSinceEpoch,
                              "signature": signatureString
                            }).then((value) async {
                              String rerPID = value.id;
                              String link = shareLinkLive?"https://app.staht.com/#/report"+ rerPID: "https://stahtqivrfsonot.web.app/#/report" + rerPID;
                              if(true){
                                final output = await getTemporaryDirectory();
                                final file = File("${output.path}/report.pdf");
                                //final file = File("example.pdf");
                                // await pdf.save();
                                // Navigator.pop(context);
                                Uint8List ddd = await pdf.save();

                                try{
                                  await file.writeAsBytes(ddd);
                                 // if(generatePDF == true)
                                    //Share.shareFiles([file.path],subject: "Report");
                                  showDialog(context: context,
                                      builder: (BuildContext context){
                                        bool generateLink = true;
                                        bool generatePDF = false;
                                        return  StatefulBuilder(
                                          builder: (context, setState) {
                                            return Dialog(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Wrap(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text("Report Generated",style: interMedium.copyWith(
                                                            color: ThemeManager().getBlackColor,
                                                            fontSize: width * 0.046,
                                                          )),
                                                          IconButton(onPressed: (){ Navigator.of(context).popUntil((route) => route.isFirst);
                                                          CustomerHomePageLogic().tabChangedStream.dataReload(0);}, icon: Icon(Icons.close)),


                                                        ],
                                                      ),

                                                    ),
                                                    ListTile(subtitle: Text(link,style: TextStyle(color: Colors.blue),),trailing: Icon(Icons.insert_link_rounded),onTap: () async {

                                                      await   Share.share(link);
                                                    },title: Text("Share Link"),),
                                                    ListTile(subtitle: Text((ddd.lengthInBytes/(1024)).toInt().toString()+" KB"),trailing: Icon(Icons.picture_as_pdf),onTap: (){
                                                      Share.shareFiles([file.path],subject: "Report");
                                                    },title: Text("Share PDF"),),

                                                    Row(
                                                      children: [
                                                        Expanded(child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: InkWell(onTap: (){
                                                            Navigator.of(context).popUntil((route) => route.isFirst);
                                                            CustomerHomePageLogic().tabChangedStream.dataReload(0);
                                                          },
                                                            child: Container(decoration: BoxDecoration(color: ThemeManager().getDarkGreenColor,borderRadius: BorderRadius.circular(5)),child: Center(child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Text("Done",style: interRegular.copyWith(
                                                                color: ThemeManager().getWhiteColor,
                                                                fontSize: width * 0.036,
                                                              )),
                                                            ),),),
                                                          ),
                                                        ),),


                                                      ],
                                                    ),



                                                  ],
                                                ),
                                              ),
                                            );
                                            return AlertDialog(
                                              title: Text("Report type"),
                                              content: Wrap(
                                                children: [
                                                  CheckboxListTile(title: Text("Generate Link"),value: generateLink, onChanged: (val){
                                                    if(val!=null)
                                                      setState(() {
                                                        generateLink = val;
                                                        generatePDF = !(val);
                                                      });

                                                    // if(generateLink == false && generatePDF == false){
                                                    //   setState(() {
                                                    //     generatePDF = true;
                                                    //   });
                                                    //
                                                    // }

                                                  }),
                                                  CheckboxListTile(subtitle: Text("Share Pdf file"),title: Text("Generate PDF"),value: generatePDF, onChanged: (val){
                                                    if(val!=null)
                                                      setState(() {
                                                        generatePDF = val;
                                                        generateLink = !(val);
                                                      });

                                                    // if(generateLink == false && generatePDF == false){
                                                    //   setState(() {
                                                    //     generateLink = true;
                                                    //   });
                                                    //
                                                    // }

                                                  }),
                                                ],
                                              ),
                                              actions: <Widget>[
                                                RaisedButton(color: Colors.blue,
                                                  onPressed: () => Navigator.pop(context),
                                                  child: Text("Cancel",style: TextStyle(color: Colors.white),),
                                                ),
                                                (generateLink == false && generatePDF == false) ==true ?Container(width: 0,height: 0,): RaisedButton(color: Colors.blue,
                                                  onPressed: () async {


                                                  },
                                                  child: Text("Generate",style: TextStyle(color: Colors.white)),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                  ).whenComplete(() {
                                    Navigator.of(context).popUntil((route) => route.isFirst);
                                    CustomerHomePageLogic().tabChangedStream.dataReload(0);
                                  });
                                  //upload file
                                  AppFirestore(auth: FirebaseAuth.instance,firestore: widget.firestore,projectId: widget.firestore.app.options.projectId).uploadPDF(file: file,reportID: value.id);


                                }catch(e){
                                  AppToast().show(message: e.toString());
                                }
                              }else{
                                AppToast().show(message: "Did not generated pdf");

                              }
                              for (int i = 0; i < reports.length; i++) {

                                // showDialog(
                                //   context: context,
                                //   builder: (BuildContext context) {
                                //     return  StreamBuilder<int>(
                                //         stream: ReportSavedStream.getInstance().outData,
                                //         initialData: 0,
                                //         builder: (context, snapshot) {
                                //           if(snapshot.hasData)
                                //           return Container(child: Text("Going to save "+snapshot.data.toString()+" items"),);
                                //           else{
                                //             return  Container(child: Text("wait"),);
                                //           }
                                //         } );
                                //     return Container(child: Text("Going to save "+reports.length.toString()+" items"),);
                                //   },
                                // );



                                try{
                                  //await Future.delayed(Duration(seconds: 1));
                                  await widget.firestore!.collection("reports").doc(value.id).collection("items").add(reports[i]).then((value) {
                                    // ReportSavedStream.getInstance().dataReload(i);
                                  });
                                }catch(e){

                                  AppToast().show(message: e.toString());
                                  print("report r");
                                  print(e);
                                  try{
                                    // await Future.delayed(Duration(seconds: 1));
                                    await widget.firestore!.collection("reports").doc(value.id).collection("items").add({"attachment":reports[i]["attachment"],"data":reports[i]["data"],"id":reports[i]["id"]});
                                  }catch(e){
                                    AppToast().show(message: e.toString());
                                    print("report r");
                                    print(e);
                                  }
                                }


                              }

                              FirebaseFirestore.instance.collection("customers")
                                  .doc(widget.customerID)
                                  .get()
                                  .then((value2) {
                                FirebaseFirestore.instance
                                    .collection("reports")
                                    .add({
                                  "report_id": value.id,
                                  "password": "123456",
                                  "resource_id": value2.get("projectId")
                                });
                              });
                              // String link = "https://app.staht.com/#/report" + value.id;
                              String linkk = shareLinkLive?"https://app.staht.com/#/report"+ value.id: "https://stahtqivrfsonot.web.app/#/report" + value.id;

                             // Navigator.pop(context);

                              if(true){





                                showAlertDialog(BuildContext context) {
                                  // set up the button
                                  Widget okButton = FlatButton(
                                    child: Text("Close"),
                                    onPressed: () {





                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.of(context).popUntil((route) => route.isFirst);
                                      CustomerHomePageLogic().tabChangedStream.dataReload(0);
                                    },
                                  );
                                  Widget Copy = FlatButton(
                                    child: Text("Copy Link"),
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(text: link));
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.of(context).popUntil((route) => route.isFirst);
                                      CustomerHomePageLogic().tabChangedStream.dataReload(0);
                                      //CustomerHomePageLogic().tabChangedStream.dataReload(3);
                                      Scaffold.of(context).showSnackBar(SnackBar(
                                          content: Text("Copied to clipboard")));
                                    },
                                  );
                                  Widget share = FlatButton(
                                    child: Text("Share Link"),
                                    onPressed: () async {
                                      Navigator.of(context).popUntil((route) => route.isFirst);
                                      CustomerHomePageLogic().tabChangedStream.dataReload(0);

                                      await   Share.share(link);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.of(context).popUntil((route) => route.isFirst);
                                      CustomerHomePageLogic().tabChangedStream.dataReload(0);
                                      // CustomerHomePageLogic().tabChangedStream.dataReload(3);
                                    },
                                  );

                                  // set up the AlertDialog
                                  AlertDialog alert = AlertDialog(
                                    title: Text("Success"),
                                    content: Text(link),
                                    actions: [okButton, Copy, share],
                                  );

                                  // show the dialog
                                  showDialog(barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return alert;
                                    },
                                  ).whenComplete(() {
                                    Navigator.of(context).popUntil((route) => route.isFirst);
                                    CustomerHomePageLogic().tabChangedStream.dataReload(0);
                                  });
                                }


                              //  showAlertDialog(context);
                              }


                            });
                          }

                        }

                        try{
                          var d = await widget.firestore!.collection("pulltest").doc(widget.files.last).get();
                          Map<String, dynamic> data = d.data()! as Map<String, dynamic>;



                          //gridimg

                          //makeImageGrid
                          AppToast().show(message: "Cache Grid Not found.Checking if  cache possible now");

                          try{
                            var attachments = await widget.firestore!.collection("pulltest").doc(d.id).collection("attachments").get();
                            if (attachments.size > 0 && attachments.docs.length > 0) {
                              double picCount = 0;
                              List allPics = [];
                              for (int i = 0; i < attachments.docs.length; i++) {
                                if (attachments.docs[i].get("type") == "photo") {
                                  picCount++;
                                  allPics.add(attachments.docs[i].get("photoFile"));
                                }
                              }
                              if(data.containsKey("gridCount")){
                                if(data["gridCount"]<picCount){
                                  if(picCount>0){
                                    AppToast().show(message: picCount.toString()+" number pic found.Requesting for cache");
                                    String link =  await AppFirestore(firestore:widget.firestore, auth:FirebaseAuth.instance, projectId: widget.firestore.app.options.projectId). makeImageGridAsync(customerFirestore:widget.firestore,photoLInks: allPics,id: d.id,);
                                    AppToast().show(message: "Newly image cache done.");



                                  }

                                }

                              }else{
                                AppToast().show(message: picCount.toString()+" number pic found.Requesting for cache");
                                String link =  await AppFirestore(firestore:widget.firestore, auth:FirebaseAuth.instance, projectId: widget.firestore.app.options.projectId). makeImageGridAsync(customerFirestore:widget.firestore,photoLInks: allPics,id: d.id,);
                                AppToast().show(message: "Newly image cache done.");

                              }

                            }
                          }catch(e){
                            AppToast().show(message: "Exception happened whilte downloading photo");

                          }

                          //gridimg end
                          bool containsGraph = false;
                          String mapUri = "https://maps.googleapis.com/maps/api/staticmap?center=" +
                              data["location"]["lat"]
                                  .toString() +
                              "," +
                              data["location"]["long"]
                                  .toString() +
                              "&zoom=8&size=" +
                              ( 600).toStringAsFixed(0)+
                              "x"+
                              ( 200).toStringAsFixed(0)+"&maptype=normal&markers=anchor:center|"+
                              "icon:https%3A%2F%2Ffirebasestorage.googleapis.com%2Fv0%2Fb%2Fstaht-connect-322113.appspot.com%2Fo%2FmapMarker1Icon.png%3Falt%3Dmedia%26token%3D29e63d7e-2a40-46ec-ac38-740c4b22435d|"+
                              data["location"]["lat"]
                                  .toString() +
                              "," +
                              data["location"]["long"]
                                  .toString() +
                              "&key=AIzaSyDOrDoiG0aLER7Y8cv2QhNr182Z0H5pMVw";

                          // String mapUri = "https://maps.googleapis.com/maps/api/staticmap?center=" +
                          //     data["location"]["lat"]
                          //         .toString() +
                          //     "," +
                          //     data["location"]["long"]
                          //         .toString() +
                          //     "&zoom=16&size=" +
                          //     "600" +
                          //     "x200&markers=" +
                          //     data["location"]["lat"]
                          //         .toString() +
                          //     "," +
                          //     data["location"]["long"]
                          //         .toString() +
                          //     "&key=AIzaSyDOrDoiG0aLER7Y8cv2QhNr182Z0H5pMVw";
                          var res = await http.get(Uri.parse(mapUri));
                          var  imageMap = pw.MemoryImage(
                            res.bodyBytes,
                          );

                          var image;
                          print("H1");
                          try{
                            if(data.containsKey("graphImage")){
                              image = pw.MemoryImage(
                                base64Decode(data["graphImage"]),
                              );
                              containsGraph = true;
                            }
                          }catch(e){
                            print(e);
                            AppToast().show(message: e.toString());
                          }
                          print("H2");


                          if(true){
                            pdf.addPage(pw.Page(
                                pageFormat: PdfPageFormat.a4,
                                build: (pw.Context context) {
                                  return  pw.Stack(
                                      children: [
                                        pw.Align(
                                          alignment: pw.Alignment.topCenter,
                                          child: pw.Column(mainAxisAlignment: pw.MainAxisAlignment.start,crossAxisAlignment: pw.CrossAxisAlignment.start,
                                              children: [
                                                pw.Row(
                                                    children: [
                                                      pw.Padding(padding: pw.EdgeInsets.only(right: 50),child:pw.Text("Test Title",style: pw.TextStyle(color: PdfColors.grey,font: ttf)), ),
                                                      pw.Text(data.containsKey("name") ?data["name"]:"--",style: pw.TextStyle(font: ttf)),
                                                    ]
                                                ),

                                                if(containsGraph)  pw.Center(child: pw.Padding(padding: pw.EdgeInsets.all(10),child:  pw.Image(image,height: 180))),
                                                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start,crossAxisAlignment: pw.CrossAxisAlignment.start,
                                                    children: [
                                                      pw.Expanded(child:  pw.Padding(padding: pw.EdgeInsets.all(10),child:  pw.Column(mainAxisAlignment: pw.MainAxisAlignment.start,crossAxisAlignment: pw.CrossAxisAlignment.stretch,

                                                          children: [
                                                            pw.Padding(padding:pw.EdgeInsets.only(top: 5,bottom: 5,),child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,children: [
                                                              pw.Text("Date & Time",style: pw.TextStyle(font: ttf)),
                                                              pw.Text( dfDate.format(DateTime.fromMillisecondsSinceEpoch(data["time"]+(data.containsKey("zone")?data["zone"]*(60*1000):0))) ,style: pw.TextStyle(color: PdfColors.green,font: ttf)),
                                                            ]),  ),
                                                            pw.Padding(padding:pw.EdgeInsets.only(top: 5,bottom: 5,),child:   pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,children: [
                                                              pw.Text("Target Load",style: pw.TextStyle(font: ttf)),
                                                              pw.Text( data["targetLoad"].toString()+" "+(data.containsKey("loadMode")? data["loadMode"]:""),style: pw.TextStyle(color: PdfColors.green,font: ttf)),
                                                            ]),),
                                                            pw.Padding(padding:pw.EdgeInsets.only(top: 5,bottom: 5,),child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,children: [
                                                              pw.Text("Timed Secton Started",style: pw.TextStyle(font: ttf)),
                                                              pw.Text( df.format(DateTime.fromMillisecondsSinceEpoch(data["startedLoad"])) ,style: pw.TextStyle(color: PdfColors.green,font: ttf)),
                                                            ]),  ),
                                                            pw.Padding(padding:pw.EdgeInsets.only(top: 5,bottom: 5,),child:  pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,children: [
                                                              pw.Text("Timed Secton Length",style: pw.TextStyle(font: ttf)),
                                                              pw.Text(df.format(DateTime.fromMillisecondsSinceEpoch(data["targetDuration"]*1000)) ,style: pw.TextStyle(color: PdfColors.green,font: ttf)),
                                                            ]), ),
                                                            pw.Padding(padding:pw.EdgeInsets.only(top: 5,bottom: 5,),child:pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,children: [
                                                              pw.Text("Test Result",style: pw.TextStyle(font: ttf)),


                                                              data["startedLoad"] == 0
                                                                  ?pw.Text("Test Result Not Timed",style: pw.TextStyle(font: ttf))
                                                                  : (data["startedLoad"] >
                                                                  0
                                                                  ? (data["didPassed"] == true
                                                                  ? pw.Text(
                                                                  "Test Result Pass",style: pw.TextStyle(font: ttf)
                                                              )
                                                                  : pw.Text("Test Result Fail",style: pw.TextStyle(font: ttf)))
                                                                  : pw.Text("Test Result Fail",style: pw.TextStyle(font: ttf)))





                                                            ]), ),









                                                          ]

                                                      )),),
                                                      pw.Expanded(child:  pw.Padding(padding: pw.EdgeInsets.all(10),child:  pw.Column(mainAxisAlignment: pw.MainAxisAlignment.start,crossAxisAlignment: pw.CrossAxisAlignment.stretch,

                                                          children: [

                                                            pw.Padding(padding:pw.EdgeInsets.only(top: 5,bottom: 5,),child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,children: [
                                                              pw.Text("Maximum Load Achieved",style: pw.TextStyle(font: ttf)),
                                                              pw.Text(data["max"].toString()+" "+(data.containsKey("loadMode")? data["loadMode"]:""),style: pw.TextStyle(color: PdfColors.green,font: ttf)),
                                                            ]), ),
                                                            pw.Padding(padding:pw.EdgeInsets.only(top: 5,bottom: 5,),child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,children: [
                                                              pw.Text("Device SN",style: pw.TextStyle(font: ttf)),
                                                              pw.Text(data["index2"].toString(),style: pw.TextStyle(color: PdfColors.green,font: ttf)),
                                                            ]), ),
                                                            pw.Padding(padding:pw.EdgeInsets.only(top: 5,bottom: 5,),child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,children: [
                                                              pw.Text("Timed Secton Finished",style: pw.TextStyle(font: ttf)),
                                                              pw.Text(df.format(DateTime.fromMillisecondsSinceEpoch(data["endedLoad"]))  ,style: pw.TextStyle(color: PdfColors.green,font: ttf)),
                                                            ]), ),
                                                            pw.Padding(padding:pw.EdgeInsets.only(top: 5,bottom: 5,),child:pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,children: [
                                                              pw.Text("Next Calibraton Date",style: pw.TextStyle(font: ttf)),
                                                              pw.Text(data["index6"].toString(),style: pw.TextStyle(color: PdfColors.green,font: ttf)),
                                                            ]),  ),






                                                          ]

                                                      )),),


                                                    ]
                                                ),

                                                pw.Padding(padding:pw.EdgeInsets.only(left: 10,top: 5,bottom: 0,),child:   pw.Text("Notes",style: pw.TextStyle(font: ttf)), ),
                                                pw.Padding(padding:pw.EdgeInsets.only(left: 10,top: 5,bottom: 0,),child:pw.Text(data["note"] ,style: pw.TextStyle(color: PdfColors.green,font: ttf)), ),

                                              ]
                                          ),
                                        ),
                                        pw.Align(
                                          alignment: pw.Alignment.bottomCenter,
                                          child: pw.Wrap(
                                              children: [
                                                pw.Image(imageMap,height: 200),
                                                pw.Padding(padding: pw.EdgeInsets.only(top: 20),child:pw.Row(
                                                    children: [
                                                      pw.Padding(padding: pw.EdgeInsets.only(right: 50),child:pw.Text("Powered by STAHT CONNECT",style: pw.TextStyle(color: PdfColors.grey,font: ttf)), ),
                                                    ]
                                                ), ),


                                              ]
                                          ),
                                        ),
                                      ]
                                  );

                                }));
                            appendPhotoGrid(pw.MemoryImage mI){

                              pdf.addPage(pw.Page(
                                  pageFormat: PdfPageFormat.a4,
                                  build: (pw.Context context) {
                                    return  pw.Stack(
                                        children: [
                                          pw.Image(mI),
                                          pw.Align(
                                            alignment: pw.Alignment.topCenter,
                                            child: pw.Column(mainAxisAlignment: pw.MainAxisAlignment.start,crossAxisAlignment: pw.CrossAxisAlignment.start,
                                                children: [
                                                  pw.Row(
                                                      children: [
                                                        pw.Padding(padding: pw.EdgeInsets.only(right: 50),child:pw.Text("Test Title",style: pw.TextStyle(color: PdfColors.grey,font: ttf)), ),
                                                        pw.Text(data.containsKey("name") ?data["name"]:"--",style: pw.TextStyle(font: ttf)),
                                                      ]
                                                  ),






                                                ]
                                            ),
                                          ),
                                          pw.Align(
                                            alignment: pw.Alignment.bottomCenter,
                                            child: pw.Row(
                                                children: [
                                                  pw.Padding(padding: pw.EdgeInsets.only(right: 50),child:pw.Text("Powered by STAHT CONNECT",style: pw.TextStyle(color: PdfColors.grey,font: ttf)), ),
                                                ]
                                            ),
                                          ),

                                        ]
                                    );

                                  }));
                            }
                            //makeImageGrid
                            if(data.containsKey("allImageGrid")){
                              print("H3");

                              http.Response  rr = await  http.get(Uri.parse(data["allImageGrid"]));
                              Uint8List allImageGrid = rr.bodyBytes;
                              print("H4");
                              pw.MemoryImage mI= pw.MemoryImage(allImageGrid);
                              appendPhotoGrid(mI);

                            }else{
                              //makeImageGrid
                              AppToast().show(message: "Cache Grid Not found.Checking if  cache possible now");

                              try{
                                var attachments = await widget.firestore!.collection("pulltest").doc(widget.files.last).collection("attachments").get();
                                if (attachments.size > 0 && attachments.docs.length > 0) {
                                  double picCount = 0;
                                  List allPics = [];
                                  for (int i = 0; i < attachments.docs.length; i++) {
                                    if (attachments.docs[i].get("type") == "photo") {
                                      picCount++;
                                      allPics.add(attachments.docs[i].get("photoFile"));
                                    }
                                  }
                                  if(picCount>0){
                                    AppToast().show(message: picCount.toString()+" number pic found.Requesting for cache");
                                    String link =  await AppFirestore(firestore:widget.firestore, auth:FirebaseAuth.instance, projectId: widget.firestore.app.options.projectId). makeImageGridAsync(customerFirestore:widget.firestore,photoLInks: allPics,id: widget.files.last,);
                                    AppToast().show(message: "Newly image cache done.");
                                    //AppToast().show(message: "Waiting for 2 seconds");
                                    //await Future.delayed(Duration(seconds: 2));

                                    http.Response  rr = await  http.get(Uri.parse(link));
                                    Uint8List allImageGrid = rr.bodyBytes;
                                    print("H4");
                                    pw.MemoryImage mI= pw.MemoryImage(allImageGrid);
                                    appendPhotoGrid(mI);


                                    // var dReloaded = await widget.firestore!.collection("pulltest").doc(widget.files.last).get();
                                    // Map<String, dynamic> dataReloaded = dReloaded.data() as Map<String, dynamic>;
                                    //
                                    // if(dataReloaded.containsKey("allImageGrid")){
                                    //   AppToast().show(message: " This Time Got the grid");
                                    //   http.Response  rr = await  http.get(Uri.parse(data["allImageGrid"]));
                                    //   Uint8List allImageGrid = rr.bodyBytes;
                                    //   print("H4");
                                    //   pw.MemoryImage mI= pw.MemoryImage(allImageGrid);
                                    //   appendPhotoGrid(mI);
                                    // }else{
                                    //   AppToast().show(message:" Failed again.Ignoring photo section");
                                    // }


                                  }
                                }
                              }catch(e){
                                AppToast().show(message: "Exception happened whilte downloading photo");

                              }
                            }



                          }






                          List attachment = [];
                          //List<Widget> attachmetsPhotos = [];
                          double ScreenShotWidth = 400;
                          double ScreenShotHeight= 800;

                          // if(false){
                          //   Widget reportWidget =true? Column(
                          //     children: [
                          //       Row(
                          //         children: [
                          //           Padding(
                          //             padding: const EdgeInsets.all(8.0),
                          //             child: Text("Title : ",style: TextStyle(fontWeight: FontWeight.bold),),
                          //           ),
                          //           Padding(
                          //             padding: const EdgeInsets.all(8.0),
                          //             child: Text(d.get("name"),style: TextStyle(),),
                          //           ),
                          //
                          //         ],
                          //       ),
                          //       false?Card(elevation: 4,child: Container(height: 300,width: MediaQuery.of(context).size.width,child: Center(child: LineMultiColor(unit: d.get("loadMode"),
                          //         data: d.get("data"),
                          //         max: d.get("max"),
                          //         target: d.get("targetLoad"),
                          //         startedLoad: d.get("startedLoad"),
                          //         duration: d.get("targetDuration"),
                          //         endedLoad: d.get("endedLoad"),
                          //         fullDuration: d.get("duration"), didPassed: true,),),),):Container(width: 0,height: 0,),
                          //       Row(
                          //         children: [
                          //           Expanded(child: Padding(
                          //             padding: const EdgeInsets.all(8.0),
                          //             child: Column(children: [
                          //               dividingLine(),
                          //               targetValueData("Date & Time  ",DateFormat('hh:mm aa dd MMM yyyy').format(DateTime.fromMillisecondsSinceEpoch(d.get("time")))),
                          //
                          //
                          //               dividingLine(),
                          //               targetValueData("Target Value  ", d.get("loadMode") == "kN"? double.parse(d.get("targetLoad").toString()).toStringAsFixed(1) +" "+getUnit(d): double.parse(d.get("targetLoad").toString()).toInt().toString() + " "+getUnit(d) ),
                          //
                          //               dividingLine(),
                          //               targetValueData("Max Value  ", (d.get("loadMode") == "kN"? double.parse(d.get("max").toString()).toStringAsFixed(1)+ " ": double.parse(d.get("max").toString()).toInt().toString()) +" "+getUnit(d) +" at " + Calculators(). durationToString(d.get("maxAt"))),
                          //
                          //               dividingLine(),
                          //               targetValueData("Timed Section Started  ",d.get("startedLoad") > 0 ?   Calculators().durationToString((((d.get("startedLoad"))))) : "Timer not Started",),
                          //
                          //               dividingLine(),
                          //               targetValueData("Timed Section Finished  ",d.get("endedLoad") > 0
                          //                   ?   Calculators().durationToString(((d
                          //                   .get("endedLoad"))))
                          //                   : "Timer not Started"),
                          //
                          //
                          //
                          //             ],),
                          //           )),
                          //           Expanded(child: Padding(
                          //             padding: const EdgeInsets.all(8.0),
                          //             child: Column(children: [
                          //               dividingLine(),
                          //               targetValueData("Timed Section Length  ",Calculators(). durationToString(((d
                          //                   .get("targetDuration") *
                          //                   1000)))),
                          //
                          //               d.get("didPassed")
                          //                   ? Container(width: 0,height: 0,)
                          //                   : Column(children: [
                          //                 dividingLine(),
                          //                 targetValueData("Failed At  ",Calculators(). durationToString((d
                          //                     .get("failedAt")))),
                          //               ],),
                          //
                          //
                          //               dividingLine(),
                          //               targetValueData("Device SN  ",d.get("index2")!=null && d.get("index2").toString().length>0? d.get("index2"):"No data"),
                          //
                          //               dividingLine(),
                          //               targetValueData("Next Calibration Date  ",d.get("index6")!=null&& d.get("index2").toString().length>0? d.get("index6"):"No data"),
                          //
                          //             ],),
                          //           )),
                          //         ],
                          //       ),
                          //     ],
                          //   ):Center(child: Text("Report"),);
                          // }
                          //
                          // if(true){
                          //
                          // }
                          double picSize = 50;
                          // testImage.add(reportWidget);

                          try{
                            var attachments = await widget.firestore!.collection("pulltest").doc(widget.files.last).collection("attachments").get();
                            if (attachments.size > 0 && attachments.docs.length > 0) {

                              double picCount = 0 ;
                              for (int i = 0; i < attachments.docs.length; i++) {
                                if( attachments.docs[i].get("type") == "photo"){
                                  picCount++;
                                }}
                              if(picCount>0 && picCount<17)picSize = 100;
                              if(picCount>16 && picCount<33)picSize = 100;
                              //  if(picCount>0 && picCount<5)picSize = 90;
                              //  if(picCount>0 && picCount<5)picSize = 90;
                              for (int i = 0; i < attachments.docs.length; i++) {
                                if( attachments.docs[i].get("type") == "photo"){
                                  // attachmetsPhotos.add(Container(height:(picSize),width:picSize,
                                  //   child: Padding(padding: EdgeInsets.all(1),child: Center(
                                  //     child: Container(color: Colors.redAccent,height: (picSize)-2,width: picSize-2,
                                  //       child: Image.network(attachments.docs[i]
                                  //           .get(attachments.docs[i].get("type") + "File"),fit: BoxFit.cover,),
                                  //     ),
                                  //   ),),
                                  // ));
                                }
                                attachment.add({
                                  "id": attachments.docs[i].id,
                                  "type": attachments.docs[i].get("type"),
                                  "time": attachments.docs[i].get("time"),
                                  "link": attachments.docs[i]
                                      .get(attachments.docs[i].get("type") + "File")
                                });
                              }
                            }






                            // Widget testWidget = new MaterialApp(debugShowCheckedModeBanner: false,home:Scaffold(backgroundColor: Colors.white,body:  Container(height: (150*4),width: (150*4),child: Wrap(children:attachmetsPhotos ,)),));

                            // showAlertDialog(context);
                            // Widget testWidget = new MaterialApp(debugShowCheckedModeBanner: false,home:Scaffold(body:  Wrap(children:[Text(attachmetsPhotos.length.toString())] ,),));
                            Uint8List i = Uint8List.fromList([]);


                            // showDialog(
                            //   context: context,
                            //   builder: (context) {
                            //     String contentText = "Content of Dialog";
                            //     return StatefulBuilder(
                            //       builder: (context, setState) {
                            //         return Dialog(
                            //           shape: RoundedRectangleBorder(
                            //               borderRadius: BorderRadius.all(Radius.circular(10))),
                            //           child: Wrap(
                            //             children: [
                            //               Screenshot(
                            //                 controller: screenshotController,
                            //                 child:Scaffold(body: Wrap(children:attachmetsPhotos ,),),
                            //               ),
                            //               Padding(
                            //                 padding: const EdgeInsets.all(8.0),
                            //                 child: Center(child: Text("Saving .........",style: TextStyle(fontSize: 18,color: ThemeManager().getDarkGreenColor,fontWeight: FontWeight.bold),)),
                            //               ),
                            //             ],
                            //           ) ,
                            //         );
                            //
                            //       },
                            //     );
                            //   },
                            // );

                            // double height = 0;
                            // if(attachmetsPhotos.length == 0){
                            //   height =1 ;
                            // }
                            // if(attachmetsPhotos.length > 0 && attachmetsPhotos.length < 3){
                            //   height =(picSize) ;
                            // }
                            // if(attachmetsPhotos.length > 2 && attachmetsPhotos.length <5){
                            //   height =( picSize)*2 ;
                            // }
                            // if(attachmetsPhotos.length > 4 && attachmetsPhotos.length <7){
                            //   height =( picSize)*3 ;
                            // }
                            // // if(attachmetsPhotos.length > 12 && attachmetsPhotos.length <17){
                            // //   height =( 102)*4 ;
                            // // }
                            // Widget testWidget = new MaterialApp(debugShowCheckedModeBanner: false,home: Container(
                            //   //height: height,width:ScreenShotWidth,
                            //   child:Wrap(children:attachmetsPhotos.length>2? attachmetsPhotos.sublist(0,2): attachmetsPhotos,),
                            // ));

                            //  testWidget =MaterialApp(home: Scaffold(body: Text("OK"),));

                            // var photoTaken = await  screenshotController
                            //     .captureFromWidget(
                            //     InheritedTheme.captureAll(
                            //         context, Material(color: Colors.white,child: Container(color: Colors.white,
                            //         //height: height,width: ScreenShotWidth,
                            //         child:testWidget))),
                            //     delay: Duration(milliseconds: 1000));
                            // Navigator.pop(context);

                            // showDialog(
                            //   useSafeArea: false,
                            //   context: context,
                            //   builder: (context) => Scaffold(backgroundColor: Colors.transparent,
                            //
                            //     body: Center(
                            //         child: photoTaken != null
                            //             ? Image.memory(photoTaken)
                            //             : Container()),
                            //   ),
                            // );

                            //   i = photoTaken!;
                            // final result = await FlutterImageCompress.compressWithList(
                            //   photoTaken,
                            //   minHeight: height.toInt(),
                            //   minWidth: ScreenShotWidth.toInt(),
                            //   quality: 100,
                            //   rotate: 0,
                            //   format: CompressFormat.jpeg,
                            // );
                            // i = result;




                            //    final content = base64Encode(capturedImage);
                            reports.add({
                              "attachment": attachment,
                              "data": d.data(),
                              "id": d.id,
                              //  "grid":attachment.length>0? base64Encode(i):""
                              //"image" :content,
                            });
                            // Handle captured image




                            doNext();




                            // i =   await  screenshotController
                            //    .captureFromWidget(
                            //    InheritedTheme.captureAll(
                            //        context, Container(height: 600,width: 600,child: Material(child: Wrap(children:attachmetsPhotos ,)))),
                            //    delay: Duration(seconds: 1));


                            print("screensot taken");













                          }catch(e){
                            AppToast().show(message: "Error downaling attachments");
                            AppToast().show(message: e.toString());

                          }

                        }catch(e){
                          AppToast().show(message: "Error on downloading a single test.Going for next");
                          AppToast().show(message: e.toString());
                          print(e);
                          doNext();
                        }

















                      }

                      if (widget.files.length > 0) {
                        await getNextData();
                      }else{
                        AppToast().show(message: "started real work but no data");
                      }
                    } else {

                      final snackBar = SnackBar(
                          content:
                          Text(widget.files.length.toString()));

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  }
                  ReportFolderCounterStream.getInstance().dataReload(widget.folders.length);
                  if (widget.folders.length > 0) {

                    AppToast().show(message: "Folder size " + widget.folders.length.toString());
                    try {
                      void getOne() async {
                        if (widget.folders.length > 0) {
                          // ReportFolderCounterStream.getInstance().dataReload(widget.folders.length);
                          try{
                            QuerySnapshot<Map<String, dynamic>> itemsInOneFolder = await widget.firestore!.collection("folders").doc(widget.folders.last).collection("records").get();
                            if (itemsInOneFolder.size > 0 && itemsInOneFolder.docs.length > 0) {
                              for (int i = 0; i < itemsInOneFolder.docs.length; i++) {
                                print("Test Found "+widget.files.length.toString());



                                widget.files.add(itemsInOneFolder.docs[i].data()["id"]);
                                // ReportTestCounterStream.getInstance().dataReload(widget.files.length);
                                // AppToast().show(message: "item added from folder");
                              }
                            }
                            String tempFolder = widget.folders.last;
                            widget.folders.removeLast();
                            //get new folders

                            QuerySnapshot<Map<String, dynamic>> newFolders = await widget.firestore!.collection("folders").where("parent", isEqualTo: tempFolder).get();

                            if (newFolders.docs.length > 0) {

                              for (int i = 0; i < newFolders.docs.length; i++) {
                                widget.folders.add(newFolders.docs[i].id);
                                AppToast().show(message: "subfolder added from mother folder");
                                ReportFolderCounterStream.getInstance().dataReload(widget.folders.length);
                              }
                            }

                            if (widget.folders.length > 0) {
                              getOne();
                            }else{
                              totalItems = widget.files.length;
                              AppToast().show(message: "Finished reading folders");
                              AppToast().show(message: "item size "+totalItems.toString());
                              realwork();

                            }
                          }catch(e){
                            AppToast().show(message: "Failed to get sub folders");
                            AppToast().show(message: e.toString());
                            widget.folders.removeLast();
                            if (widget.folders.length > 0) {
                              getOne();
                            }else{
                              totalItems = widget.files.length;
                              AppToast().show(message: "Finished reading folders");
                              AppToast().show(message: "item size "+totalItems.toString());
                              realwork();
                            }
                          }


                        } else {
                          totalItems = widget.files.length;

                          //realwork();
                        }
                      }
                      AppToast().show(message: "seeding folder");
                      getOne();

                    } catch (e) {
                      print("my ex");
                      print(e);
                    }
                  } else {
                    // AppToast().show(message: "Folder Empty");
                    print("folder is empty");
                    realwork();
                  }

                } else {
                  final snackBar =
                  SnackBar(content: Text('Company name cannot be empty'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              }else{
                final snackBar = SnackBar(content: Text('Title cannot be empty'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }

              // showDialog(context: context,
              //     builder: (BuildContext context){
              //       bool generateLink = true;
              //       bool generatePDF = false;
              //       return  StatefulBuilder(
              //         builder: (context, setState) {
              //           return Dialog(
              //             child: Padding(
              //               padding: const EdgeInsets.all(8.0),
              //               child: Wrap(
              //                 children: [
              //                   Padding(
              //                     padding: const EdgeInsets.all(8.0),
              //                     child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                       children: [
              //                         Text("Report Type",style: interMedium.copyWith(
              //                           color: ThemeManager().getBlackColor,
              //                           fontSize: width * 0.046,
              //                         )),
              //                         IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.close)),
              //
              //
              //                       ],
              //                     ),
              //
              //                   ),
              //                   CheckboxListTile(title: Text("Share Link"),value: generateLink, onChanged: (val){
              //                     if(val!=null)
              //                       setState(() {
              //                         generateLink = val;
              //                         generatePDF = !(val);
              //                       });
              //
              //                     // if(generateLink == false && generatePDF == false){
              //                     //   setState(() {
              //                     //     generatePDF = true;
              //                     //   });
              //                     //
              //                     // }
              //
              //                   }),
              //                   CheckboxListTile(title: Text("Share PDF"),value: generatePDF, onChanged: (val){
              //                     if(val!=null)
              //                       setState(() {
              //                         generatePDF = val;
              //                         generateLink = !(val);
              //                       });
              //
              //                     // if(generateLink == false && generatePDF == false){
              //                     //   setState(() {
              //                     //     generateLink = true;
              //                     //   });
              //                     //
              //                     // }
              //
              //                   }),
              //
              //                   Row(
              //                     children: [
              //                       Expanded(child: Padding(
              //                         padding: const EdgeInsets.all(8.0),
              //                         child: InkWell(onTap: (){
              //                           Navigator.pop(context);
              //                         },
              //                           child: Container(decoration: BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.circular(5)),child: Center(child: Padding(
              //                             padding: const EdgeInsets.all(8.0),
              //                             child: Text("Cancel",style: interRegular.copyWith(
              //                               color: ThemeManager().getWhiteColor,
              //                               fontSize: width * 0.036,
              //                             )),
              //                           ),),),
              //                         ),
              //                       ),),
              //                       Expanded(child: Padding(
              //                         padding: const EdgeInsets.all(8.0),
              //                         child: InkWell(onTap: () async {
              //                           // Navigator.pop(context);
              //
              //                         },
              //                           child: Container(decoration: BoxDecoration(color: ThemeManager().getDarkGreenColor,borderRadius: BorderRadius.circular(5)),child: Center(child: Padding(
              //                             padding: const EdgeInsets.all(8.0),
              //                             child: Text("Generate",style: interRegular.copyWith(
              //                               color: ThemeManager().getWhiteColor,
              //                               fontSize: width * 0.036,
              //                             )),
              //                           ),),),
              //                         ),
              //                       ),),
              //                     ],
              //                   ),
              //
              //
              //
              //                 ],
              //               ),
              //             ),
              //           );
              //           return AlertDialog(
              //             title: Text("Report type"),
              //             content: Wrap(
              //               children: [
              //                 CheckboxListTile(title: Text("Generate Link"),value: generateLink, onChanged: (val){
              //                   if(val!=null)
              //                   setState(() {
              //                     generateLink = val;
              //                     generatePDF = !(val);
              //                   });
              //
              //                   // if(generateLink == false && generatePDF == false){
              //                   //   setState(() {
              //                   //     generatePDF = true;
              //                   //   });
              //                   //
              //                   // }
              //
              //                 }),
              //                 CheckboxListTile(subtitle: Text("Share Pdf file"),title: Text("Generate PDF"),value: generatePDF, onChanged: (val){
              //                  if(val!=null)
              //                   setState(() {
              //                     generatePDF = val;
              //                     generateLink = !(val);
              //                   });
              //
              //                   // if(generateLink == false && generatePDF == false){
              //                   //   setState(() {
              //                   //     generateLink = true;
              //                   //   });
              //                   //
              //                   // }
              //
              //                 }),
              //               ],
              //             ),
              //             actions: <Widget>[
              //               RaisedButton(color: Colors.blue,
              //                 onPressed: () => Navigator.pop(context),
              //                 child: Text("Cancel",style: TextStyle(color: Colors.white),),
              //               ),
              //               (generateLink == false && generatePDF == false) ==true ?Container(width: 0,height: 0,): RaisedButton(color: Colors.blue,
              //                 onPressed: () async {
              //
              //
              //                 },
              //                 child: Text("Generate",style: TextStyle(color: Colors.white)),
              //               ),
              //             ],
              //           );
              //         },
              //       );
              //     }
              // ).whenComplete(() {
              //   Navigator.of(context).popUntil((route) => route.isFirst);
              //   CustomerHomePageLogic().tabChangedStream.dataReload(0);;
              // });




            },
            child: Container(
              margin: EdgeInsets.only(top: height * 0.01,),
              height: height*0.065,
              width: width,
              decoration: BoxDecoration(
                  color: ThemeManager().getDarkGreenColor,
                  borderRadius: BorderRadius.circular(width*0.014)
              ),
              alignment: Alignment.center,
              child: Text(
                TextConst.shareText,
                style: interSemiBold.copyWith(
                    fontSize: width * 0.047,
                    color: ThemeManager().getWhiteColor),
              ),
            ),
          ),

          //------------------ Cancel Button -----------------------------------
          GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Container(
              margin: EdgeInsets.only(top: height * 0.01,),
              height: height*0.065,
              width: width,
              decoration: BoxDecoration(
                  color: ThemeManager().getDarkGreyColor,
                  borderRadius: BorderRadius.circular(width*0.014)
              ),
              alignment: Alignment.center,
              child: Text(
                TextConst.cancelText,
                style: interSemiBold.copyWith(
                    fontSize: width * 0.047,
                    color: ThemeManager().getWhiteColor),
              ),
            ),
          ),




        ],
      ),
    );
  }
  Widget dividingLine(){
    return  Container(
      // margin: EdgeInsets.only(top: height*0.02),
      color:ThemeManager().getBlackColor.withOpacity(.15),
      height: height*0.001,
      width: double.infinity,
    );
  }

  String getUnit(dynamic dataToShow) {
    try{
      return  dataToShow["loadMode"]!=null?dataToShow["loadMode"]:"kN";
    }catch(e){
      return "kN";

    }

  }
}
Widget targetValueData(String dataname,String value)
{
  return Container(height: 50,
   // margin: EdgeInsets.only(left: width*0.06,right:width*0.06 ),
    child: Stack(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child:Text(
              dataname,style: interMedium.copyWith(
              color: ThemeManager().getBlackColor,
              //fontSize: width * 0.042
          )
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child:Text(
              value,style: interMedium.copyWith(
              color: ThemeManager().getDarkGreenColor,
            //  fontSize: width * 0.042
          )
          ),
        ),
      ],
    ),
  );
}

String resizeImage(Uint8List data) {
  Uint8List resizedData = data;
  IMG.Image? img = IMG.decodeImage(data);

  IMG.Image resized = IMG.copyResize(img!, width: 500,);
 // resizedData = IMG.encodeJpg(resized);
  var d = IMG.encodeJpg(resized);
  resizedData = Uint8List.fromList(d);
  return base64Encode(resizedData);
}