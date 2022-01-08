import 'dart:convert';
import 'dart:typed_data';
import 'package:image/image.dart' as IMG;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/Activities/CustomBottomNavigationBar/appBottomNavigationBar.dart';
import 'package:connect/Activities/CustomerUserHome/logics.dart';
import 'package:connect/Appabr/appbar_widget.dart';
import 'package:connect/screens/popup/commonUpdateDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:connect/components/appBarCustom.dart';
import 'package:connect/components/buttonView.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/textConst.dart';
import 'package:connect/utils/textStyleConst.dart';
import 'package:connect/utils/themeManager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class AccountScreen extends StatefulWidget {

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();

  dynamic accountDetail=[
    {
      "title":"Name",
      "userDetail":"Joe Bloggs",
      "isSignature":"no",
    },
    {
      "title":"Email",
      "userDetail":"joeblogs@gmail.com",
      "isSignature":"no",
    },
    {
      "title":"Password",
      "userDetail":"a***************3",
      "isSignature":"no",
    },
    {
      "title":"Company",
      "userDetail":"Acme Testing Ltd",
      "isSignature":"no",
    },
    {
      "title":"Company Address",
      "userDetail":"123 Any Streeet, Townhall....",
      "isSignature":"no",
    },
    {
      "title":"Company Telephone",
      "userDetail":"0121 817 1234",
      "isSignature":"no",
    },
    {
      "title":"Company Logo",
      "userDetail":"acmelog.png",
      "isSignature":"no",
    },
    {
      "title":"Signature",
      "userDetail":"signature.png",
      "isSignature":"yes",
    }
  ];

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;


    CustomerHomePageLogic().tabChangedStream.dataReload(currentTab);
    return SafeArea(
      child: Scaffold(body: Stack(children: [
        Scaffold(
          backgroundColor: ThemeManager().getWhiteColor,

          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              //--------------------------------Appbar of screen----------------------

              ApplicationAppbar().  getAppbar(title: TextConst.accountText),
              //------------------------------Back Button----------------------------
              Container(
                margin: EdgeInsets.only(left: width * 0.05, right:width * 0.05,top:height*0.03,),

                child: GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back_ios,
                        size: width * 0.039,color:  ThemeManager().getDarkGreenColor,),
                      Text(TextConst.backAccountText,style: interMedium.copyWith(
                          color: ThemeManager().getDarkGreenColor,
                          fontSize: width * 0.042),
                      ),
                    ],
                  ),
                ),
              ),

              //------------------------------Account detail fields-------------------------
              Expanded(
                child: accountData(),
              ),
            ],
          ),
        ),
        Align(alignment: Alignment.bottomCenter,child: Container(height: height*.08,child: AppBottomNavigationar(context: context).getNavigationBar(level: 0))),

      ],),),
    );


    return Scaffold(
      backgroundColor: ThemeManager().getWhiteColor,

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          //--------------------------------Appbar of screen----------------------
          AppBarCustom(
            appbarTitle: TextConst.accountText,),

          //------------------------------Back Button----------------------------
          Container(
            margin: EdgeInsets.only(left: width * 0.05, right:width * 0.05,top:height*0.03,),

            child: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_back_ios,
                    size: width * 0.039,color:  ThemeManager().getDarkGreenColor,),
                  Text(TextConst.backAccountText,style: interMedium.copyWith(
                      color: ThemeManager().getDarkGreenColor,
                      fontSize: width * 0.042),
                  ),
                ],
              ),
            ),
          ),

          //------------------------------Account detail fields-------------------------
          Expanded(
            child: accountData(),
          ),
        ],
      ),
    );
  }

  //------------------------------Account detail fields-------------------------
  Widget accountData(){
    return Column(
      children: [
        FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection("users").where("uid",isEqualTo: FirebaseAuth.instance.currentUser!.uid).get(), // async work
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting: return Text('Loading....');
              default:
                if (snapshot.hasError)
                  return Text('Error: ${snapshot.error}');
                else
                  return  Container(
                    margin: EdgeInsets.only(left: width * 0.05, right:width * 0.05,top:height*0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [

                            //-------------------title-----------------------------
                            Text("Name",
                              style: interBold.copyWith(
                                  color: ThemeManager().getExtraDarkBlueColor,
                                  fontSize: width * 0.040),),

                            //-------------------User Detail---------------------
                            Container(
                              margin: EdgeInsets.only(top:height*0.008),
                              constraints: BoxConstraints(
                                maxWidth: width*0.70,
                              ),
                              child:Text(snapshot.data!.docs.first.get("displayName"),
                                style: interRegular.copyWith(
                                    color: ThemeManager().getLightGrey5Color,
                                    fontSize: width * 0.030),)
                              ,
                            ),

                          ],
                        ),

                        //----------------------Edit icon-------------------------
                        GestureDetector(
                          onTap: (){
                            //CommonUpdateDialog

                            showDialog(context: context,
                                builder: (BuildContext context){
                                  return CommonUpdateDialog(oldVal: snapshot.data!.docs.first.get("displayName"), submittedCallback: (String newVal ) {
                                    FirebaseFirestore.instance.collection("users").where("uid",isEqualTo: FirebaseAuth.instance.currentUser!.uid).get().then((value) {
                                      FirebaseFirestore.instance.collection("users").doc(value.docs.first.id).update({"displayName":newVal});
                                    });

                                  }, title: 'Title',);
                                }
                            );


                          },
                          child: Container(
                            height: height*0.020,
                            width: width*0.040,
                            child: SvgPicture.asset(
                              "assets/svg/accountEditIcon.svg",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
            }
          },
        ),
        Container(
          margin: EdgeInsets.only(top: height*0.009),
          height: height*0.001,
          width: double.infinity,
          color: ThemeManager().getBlackColor.withOpacity(0.19),
        ),

        FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection("users").where("uid",isEqualTo: FirebaseAuth.instance.currentUser!.uid).get(), // async work
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting: return Text('Loading....');
              default:
                if (snapshot.hasError)
                  return Text('Error: ${snapshot.error}');
                else
                  return  Container(
                    margin: EdgeInsets.only(left: width * 0.05, right:width * 0.05,top:height*0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [

                            //-------------------title-----------------------------
                            Text("Email",
                              style: interBold.copyWith(
                                  color: ThemeManager().getExtraDarkBlueColor,
                                  fontSize: width * 0.040),),

                            //-------------------User Detail---------------------
                            Container(
                              margin: EdgeInsets.only(top:height*0.008),
                              constraints: BoxConstraints(
                                maxWidth: width*0.70,
                              ),
                              child:Text(snapshot.data!.docs.first.get("email"),
                                style: interRegular.copyWith(
                                    color: ThemeManager().getLightGrey5Color,
                                    fontSize: width * 0.030),)
                              ,
                            ),

                          ],
                        ),

                        //----------------------Edit icon-------------------------

                      ],
                    ),
                  );
            }
          },
        ),
        Container(
          margin: EdgeInsets.only(top: height*0.009),
          height: height*0.001,
          width: double.infinity,
          color: ThemeManager().getBlackColor.withOpacity(0.19),
        ),

        FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection("customers").doc(parentId).get(), // async work
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting: return Text('Loading....');
              default:
                if (snapshot.hasError)
                  return Text('Error: ${snapshot.error}');
                else
                  return  Container(
                    margin: EdgeInsets.only(left: width * 0.05, right:width * 0.05,top:height*0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [

                            //-------------------title-----------------------------
                            Text("Company",
                              style: interBold.copyWith(
                                  color: ThemeManager().getExtraDarkBlueColor,
                                  fontSize: width * 0.040),),

                            //-------------------User Detail---------------------
                            Container(
                              margin: EdgeInsets.only(top:height*0.008),
                              constraints: BoxConstraints(
                                maxWidth: width*0.70,
                              ),
                              child:Text(snapshot.data!.get("prjectName"),
                                style: interRegular.copyWith(
                                    color: ThemeManager().getLightGrey5Color,
                                    fontSize: width * 0.030),)
                              ,
                            ),

                          ],
                        ),
                        GestureDetector(
                          onTap: (){
                            //CommonUpdateDialog

                            showDialog(context: context,
                                builder: (BuildContext context){
                                  return CommonUpdateDialog(oldVal:snapshot.data!.get("prjectName"), submittedCallback: (String newVal ) {
                                    FirebaseFirestore.instance.collection("customers").doc(snapshot.data!.id).update({"prjectName":newVal});

                                  }, title: 'Company',);
                                }
                            );


                          },
                          child: Container(
                            height: height*0.020,
                            width: width*0.040,
                            child: SvgPicture.asset(
                              "assets/svg/accountEditIcon.svg",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        //----------------------Edit icon-------------------------

                      ],
                    ),
                  );
            }
          },
        ),
        Container(
          margin: EdgeInsets.only(top: height*0.009),
          height: height*0.001,
          width: double.infinity,
          color: ThemeManager().getBlackColor.withOpacity(0.19),
        ),


        FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection("customers").doc(parentId).get(), // async work
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting: return Text('Loading....');
              default:
                if (snapshot.hasError)
                  return Text('Error: ${snapshot.error}');
                else
                  return  Container(
                    margin: EdgeInsets.only(left: width * 0.05, right:width * 0.05,top:height*0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [

                            //-------------------title-----------------------------
                            Text("Company Address",
                              style: interBold.copyWith(
                                  color: ThemeManager().getExtraDarkBlueColor,
                                  fontSize: width * 0.040),),

                            //-------------------User Detail---------------------
                            Container(
                              margin: EdgeInsets.only(top:height*0.008),
                              constraints: BoxConstraints(
                                maxWidth: width*0.70,
                              ),
                              child:Text(snapshot.data!.get("address"),
                                style: interRegular.copyWith(
                                    color: ThemeManager().getLightGrey5Color,
                                    fontSize: width * 0.030),)
                              ,
                            ),

                          ],
                        ),
                        GestureDetector(
                          onTap: (){
                            //CommonUpdateDialog

                            showDialog(context: context,
                                builder: (BuildContext context){
                                  return CommonUpdateDialog(oldVal:snapshot.data!.get("address"), submittedCallback: (String newVal ) {
                                    FirebaseFirestore.instance.collection("customers").doc(snapshot.data!.id).update({"address":newVal});

                                  }, title: 'Address',);
                                }
                            );


                          },
                          child: Container(
                            height: height*0.020,
                            width: width*0.040,
                            child: SvgPicture.asset(
                              "assets/svg/accountEditIcon.svg",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        //----------------------Edit icon-------------------------

                      ],
                    ),
                  );
            }
          },
        ),
        Container(
          margin: EdgeInsets.only(top: height*0.009),
          height: height*0.001,
          width: double.infinity,
          color: ThemeManager().getBlackColor.withOpacity(0.19),
        ),



        FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection("customers").doc(parentId).get(), // async work
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting: return Text('Loading....');
              default:
                if (snapshot.hasError)
                  return Text('Error: ${snapshot.error}');
                else
                  return  Container(
                    margin: EdgeInsets.only(left: width * 0.05, right:width * 0.05,top:height*0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [

                            //-------------------title-----------------------------
                            Text("Company Telephone",
                              style: interBold.copyWith(
                                  color: ThemeManager().getExtraDarkBlueColor,
                                  fontSize: width * 0.040),),

                            //-------------------User Detail---------------------
                            Container(
                              margin: EdgeInsets.only(top:height*0.008),
                              constraints: BoxConstraints(
                                maxWidth: width*0.70,
                              ),
                              child:Text(snapshot.data!.get("telephone"),
                                style: interRegular.copyWith(
                                    color: ThemeManager().getLightGrey5Color,
                                    fontSize: width * 0.030),)
                              ,
                            ),

                          ],
                        ),
                        GestureDetector(
                          onTap: (){
                            //CommonUpdateDialog

                            showDialog(context: context,
                                builder: (BuildContext context){
                                  return CommonUpdateDialog(oldVal:snapshot.data!.get("telephone"), submittedCallback: (String newVal ) {
                                    FirebaseFirestore.instance.collection("customers").doc(snapshot.data!.id).update({"telephone":newVal});

                                  }, title: 'Telephone',);
                                }
                            );


                          },
                          child: Container(
                            height: height*0.020,
                            width: width*0.040,
                            child: SvgPicture.asset(
                              "assets/svg/accountEditIcon.svg",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        //----------------------Edit icon-------------------------

                      ],
                    ),
                  );
            }
          },
        ),
        Container(
          margin: EdgeInsets.only(top: height*0.009),
          height: height*0.001,
          width: double.infinity,
          color: ThemeManager().getBlackColor.withOpacity(0.19),
        ),
        // FutureBuilder<DocumentSnapshot>(
        //   future: FirebaseFirestore.instance.collection("customers").doc(parentId).get(), // async work
        //   builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        //     switch (snapshot.connectionState) {
        //       case ConnectionState.waiting: return Text('Loading....');
        //       default:
        //         if (snapshot.hasError)
        //           return Text('Error: ${snapshot.error}');
        //         else
        //           Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
        //         if(data[""])
        //           return  Container(
        //             margin: EdgeInsets.only(left: width * 0.05, right:width * 0.05,top:height*0.02),
        //             child: Row(
        //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //
        //               children: [
        //                 Column(
        //                   crossAxisAlignment: CrossAxisAlignment.start,
        //
        //                   children: [
        //
        //                     //-------------------title-----------------------------
        //                     Text("Admin Support",
        //                       style: interBold.copyWith(
        //                           color: ThemeManager().getExtraDarkBlueColor,
        //                           fontSize: width * 0.040),),
        //
        //                     //-------------------User Detail---------------------
        //                     Container(
        //                       margin: EdgeInsets.only(top:height*0.008),
        //                       constraints: BoxConstraints(
        //                         maxWidth: width*0.70,
        //                       ),
        //                       child:Text(snapshot.data!.get("telephone"),
        //                         style: interRegular.copyWith(
        //                             color: ThemeManager().getLightGrey5Color,
        //                             fontSize: width * 0.030),)
        //                       ,
        //                     ),
        //
        //                   ],
        //                 ),
        //                 GestureDetector(
        //                   onTap: (){
        //                     //CommonUpdateDialog
        //
        //                     showDialog(context: context,
        //                         builder: (BuildContext context){
        //                           return CommonUpdateDialog(oldVal:snapshot.data!.get("telephone"), submittedCallback: (String newVal ) {
        //                             FirebaseFirestore.instance.collection("customers").doc(snapshot.data!.id).update({"telephone":newVal});
        //
        //                           }, title: 'Telephone',);
        //                         }
        //                     );
        //
        //
        //                   },
        //                   child: Container(
        //                     height: height*0.020,
        //                     width: width*0.040,
        //                     child: SvgPicture.asset(
        //                       "assets/svg/accountEditIcon.svg",
        //                       fit: BoxFit.fill,
        //                     ),
        //                   ),
        //                 ),
        //                 //----------------------Edit icon-------------------------
        //
        //               ],
        //             ),
        //           );
        //     }
        //   },
        // ),
        // Container(
        //   margin: EdgeInsets.only(top: height*0.009),
        //   height: height*0.001,
        //   width: double.infinity,
        //   color: ThemeManager().getBlackColor.withOpacity(0.19),
        // ),


        // FutureBuilder<DocumentSnapshot>(
        //   future: FirebaseFirestore.instance.collection("customers").doc(parentId).get(), // async work
        //   builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        //     switch (snapshot.connectionState) {
        //       case ConnectionState.waiting: return Text('Loading....');
        //       default:
        //         if (snapshot.hasError)
        //           return Text('Error: ${snapshot.error}');
        //         else
        //           return  Container(
        //             margin: EdgeInsets.only(left: width * 0.05, right:width * 0.05,top:height*0.02),
        //             child: Row(
        //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //
        //               children: [
        //                 // Padding(
        //                 //   padding: const EdgeInsets.all(8.0),
        //                 //   child: Container(height: 50,width:50,child: Image.memory(base64Decode(snapshot.data!.get("logo")))),
        //                 // ),
        //                 Column(
        //                   crossAxisAlignment: CrossAxisAlignment.start,
        //
        //                   children: [
        //
        //                     //-------------------title-----------------------------
        //                     Text("Logo",
        //                       style: interBold.copyWith(
        //                           color: ThemeManager().getExtraDarkBlueColor,
        //                           fontSize: width * 0.040),),
        //
        //                     //-------------------User Detail---------------------
        //                     Container(
        //                       margin: EdgeInsets.only(top:height*0.008),
        //                       constraints: BoxConstraints(
        //                         maxWidth: width*0.70,
        //                       ),
        //                       child:Text("Click to Change Photo",
        //                         style: interRegular.copyWith(
        //                             color: ThemeManager().getLightGrey5Color,
        //                             fontSize: width * 0.030),),
        //                     ),
        //
        //                   ],
        //                 ),
        //                 GestureDetector(
        //                   onTap: () async {
        //                     //CommonUpdateDialog
        //
        //                     final ImagePicker _picker = ImagePicker();
        //                     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
        //
        //                     if(image!= null){
        //                       Uint8List i = await image.readAsBytes();
        //
        //                       Uint8List resizedData = i;
        //                       IMG.Image? img = IMG.decodeImage(i);
        //
        //                       IMG.Image resized = IMG.copyResize(img!, width: 200,);
        //                      Uint8List r = Uint8List.fromList(resized.data.toList());
        //
        //                       FirebaseFirestore.instance.collection("customers").doc(snapshot.data!.id).update({"logo":base64Encode(r)});
        //                     }
        //
        //                     // showDialog(context: context,
        //                     //     builder: (BuildContext context){
        //                     //       return CommonUpdateDialog(oldVal:snapshot.data!.get("prjectName"), submittedCallback: (String newVal ) {
        //                     //         FirebaseFirestore.instance.collection("customers").doc(snapshot.data!.id).update({"prjectName":newVal});
        //                     //
        //                     //       }, title: 'Company',);
        //                     //     }
        //                     // );
        //
        //
        //                   },
        //                   child: Container(
        //                     height: height*0.020,
        //                     width: width*0.040,
        //                     child: SvgPicture.asset(
        //                       "assets/svg/accountEditIcon.svg",
        //                       fit: BoxFit.fill,
        //                     ),
        //                   ),
        //                 ),
        //                 //----------------------Edit icon-------------------------
        //
        //               ],
        //             ),
        //           );
        //     }
        //   },
        // ),
        // Container(
        //   margin: EdgeInsets.only(top: height*0.009),
        //   height: height*0.001,
        //   width: double.infinity,
        //   color: ThemeManager().getBlackColor.withOpacity(0.19),
        // ),


      ],
    );
    return ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount:accountDetail.length,
        itemBuilder: (BuildContext context, int index) {



        });
  }

  //------------------------------Account detail edit Popups-------------------------
  editAccountDetailPopup(context, popupTitle, hintText, showSignaturePad) {
    showDialog(
        context: context,
        builder: (context)
        {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              contentPadding: EdgeInsets.only(top: height*0.012),

              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Container(
                    margin: EdgeInsets.only(
                        top: height * 0.01,
                        left: width * 0.04,
                        right: width * 0.04),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      //----------------------Popup header title---------------------
                      children: [
                        Text(
                          popupTitle,
                          style: interSemiBold.copyWith(
                            color: ThemeManager().getBlackColor,
                            fontSize: width * 0.036,
                          ),
                        ),

                        //------------------Close icon------------------------------
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Icon(
                              Icons.clear,
                              size: width * 0.06,
                              color: ThemeManager().getLightGrey4Color,
                            )),
                      ],
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: height * 0.015),
                    height: height * 0.001,
                    color: ThemeManager().getBlackColor.withOpacity(0.19),
                  ),

                  Container(
                    margin: EdgeInsets.only(
                        top: height * 0.025,
                        left: width * 0.045,
                        right: width * 0.045),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        //-------------------Field title-----------------
                        Text(
                          popupTitle,
                          style: interMedium.copyWith(
                            color: ThemeManager().getPopUpTextGreyColor,
                            fontSize: width * 0.036,
                          ),
                        ),

                        showSignaturePad == "yes"

                        //-------------------Signature Pad----------------
                            ? Container(
                                margin: EdgeInsets.only(top: height * 0.015),
                                child: SfSignaturePad(
                                    key: signatureGlobalKey,
                                    backgroundColor: ThemeManager()
                                        .getLightGreenTextFieldColor,
                                    strokeColor: Colors.black,
                                    minimumStrokeWidth: 1.0,
                                    maximumStrokeWidth: 4.0),
                              )

                        //-----------------Text Fields to edit account detail-----------------
                            : Container(
                                margin: EdgeInsets.only(top: height * 0.015),
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: hintText,
                                    hintStyle: interMedium.copyWith(
                                      color: ThemeManager().getLightGrey1Color,
                                      fontSize: width * 0.036,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            width * 0.014)),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: height * 0.0,
                                        horizontal: width * 0.045),
                                    fillColor: ThemeManager()
                                        .getLightGreenTextFieldColor,
                                    filled: true,
                                  ),
                                ),
                              ),
                        showSignaturePad == "yes"

                        //------------------------Save button to save signature---------------
                            ? InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                    margin: EdgeInsets.only(
                                        top: height * 0.04,
                                        bottom: height * 0.02),
                                    child: ButtonView(
                                        buttonLabel: TextConst.saveButtonText)),
                              )

                        //---------------------Save button to save textField data---------------
                            : InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      top: height * 0.04,
                                      bottom: height * 0.02),
                                  height: height * 0.065,
                                  width: width,
                                  decoration: BoxDecoration(
                                      color: ThemeManager().getDarkGreenColor,
                                      borderRadius:
                                          BorderRadius.circular(width * 0.014)),
                                  alignment: Alignment.center,
                                  child: Text(
                                    TextConst.saveButtonText,
                                    style: interSemiBold.copyWith(
                                        fontSize: width * 0.047,
                                        color: ThemeManager().getWhiteColor),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

}

