import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:connect/roles_permissions/role_permision_manager.dart';
import 'package:connect/services/config.dart';
import 'package:connect/services/restApi.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/Activities/CustomerUserHome/HomePager/qr.dart';
import 'package:connect/screens/privacyPolicyScreen.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/textConst.dart';
import 'package:connect/utils/textStyleConst.dart';
import 'package:connect/utils/themeManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:connect/labels/appLabels.dart';
import 'package:connect/localization/language/language_bn.dart';
import 'package:connect/localization/language/language_en.dart';
import 'package:connect/localization/language/languages.dart';
import 'package:connect/models/todo.dart';
import 'package:connect/services/auth.dart';
import 'package:connect/services/database.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../../forgote_password.dart';
import 'bLogc.dart';
Color color = Color.fromARGB(255,29, 131, 72 );
String cloudRestApiBase = "https://us-central1-staht-connect-322113.cloudfunctions.net/";

String validateEmail(String value) {
  String pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value) || value == null)
    return 'Enter a valid email address';
  else
    return ' ';
}
class Login extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;


  String chooseOrgTitle = "Click to Choose an Organization";
  late String selectedOrg;
  late String path;
  late Locale locale;

  Login({
    Key? key,
    required this.auth,
    required this.locale,
    required this.firestore,
  }) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailTextController = new TextEditingController();
  TextEditingController passwordTextController = new TextEditingController();
  TextEditingController resetPasswordTextController =
  new TextEditingController();

  final _formResetPasswordKey = GlobalKey<FormState>();
  final _formLoginKey = GlobalKey<FormState>();

  bool showResetPasswordScreen = true;
  bool _emailDone = false;
  bool _loginEmailDone = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool progress = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("login");
    //testFirestoreDB();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ThemeManager().getWhiteColor,
      body: Stack(children: [
        Positioned(bottom: 50,top: 0,left: 0,right: 0,child: Container(
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            children: [
              //------------------------Intro Image on top of screen------------------
              Image.asset(
                "assets/images/introAppImage.png",
                fit: BoxFit.fill,
                width: double.infinity,
              ),

              Positioned(
                bottom: 0,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    showResetPasswordScreen == true

                    //--------------------Login view----------------------
                        ? Container(
                      width: width,
                      //height: height * 0.63,
                      padding: EdgeInsets.only(top: height * 0.09),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)),
                        color: ThemeManager().getWhiteColor,
                      ),

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                left: width * 0.04, top: height * 0.035),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //-------------------Staht connect text------------
                                Text(
                                  TextConst.stahtConnectText,
                                  style: interBold.copyWith(
                                      color: ThemeManager().getBlackColor,
                                      fontSize: width * 0.045),
                                ),

                                Container(
                                  height: height * 0.26,
                                  margin: EdgeInsets.only(
                                      top: height * 0.03,
                                      right: width * 0.05),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Form(
                                        key: _formLoginKey,
                                        child: Column(
                                          children: [
                                            //-------------------Email text field--------------
                                            Container(
                                              margin: EdgeInsets.only(
                                                  bottom: height * 0.02),
                                              child: TextFormField(
                                                autovalidateMode: AutovalidateMode.always,
                                                //autovalidateMode: AutovalidateMode.onUserInteraction,
                                                //  validator: validateEmail,
                                                obscureText: false,
                                                controller:
                                                emailTextController,
                                                keyboardType: TextInputType
                                                    .emailAddress,
                                                style: interMedium.copyWith(
                                                    fontSize:
                                                    width * 0.045),
                                                cursorColor: ThemeManager()
                                                    .getDarkGreenColor,
                                                decoration:
                                                new InputDecoration(
                                                  fillColor: ThemeManager()
                                                      .getLightGreenTextFieldColor,
                                                  filled: true,
                                                  border: InputBorder.none,
                                                  hintText: "Email Address",
                                                  hintStyle: interMedium.copyWith(
                                                      color: ThemeManager()
                                                          .getLightGrey1Color,
                                                      fontSize:
                                                      width * 0.034),
                                                ),
                                                onTap: () {
                                                  setState(() {
                                                    _loginEmailDone =
                                                        _loginEmailDone;
                                                  });
                                                },
                                                validator: (val) {
                                                  // if (val!.isEmpty) {
                                                  //   return "Please enter email address";
                                                  // } else {
                                                  //   String pattern =
                                                  //       r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                                  //       r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                                  //       r"{0,253}[a-zA-Z0-9])?)*$";
                                                  //   RegExp regex = new RegExp(pattern);
                                                  //   if (!regex.hasMatch(val) || val == null)
                                                  //     return 'Enter a valid email address';
                                                  //   else
                                                  //     return null;
                                                  // }
                                                },
                                              ),
                                            ),

                                            //----------------Password text field-------------
                                            TextFormField(
                                              validator: (val) => val!
                                                  .isEmpty
                                                  ? "Please enter Password"
                                                  : null,
                                              obscureText: true,
                                              controller:
                                              passwordTextController,
                                              autovalidateMode:
                                              AutovalidateMode
                                                  .onUserInteraction,
                                              keyboardType: TextInputType
                                                  .visiblePassword,
                                              style: interMedium.copyWith(
                                                  fontSize: width * 0.045),
                                              cursorColor: ThemeManager()
                                                  .getDarkGreenColor,
                                              decoration:
                                              new InputDecoration(
                                                border: InputBorder.none,
                                                fillColor: ThemeManager()
                                                    .getLightGreenTextFieldColor,
                                                filled: true,
                                                hintText: "Password",
                                                hintStyle: interMedium.copyWith(
                                                    color: ThemeManager()
                                                        .getLightGrey1Color,
                                                    fontSize:
                                                    width * 0.034),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      //--------------Forgot password Reset here text----------------
                                      forgotPasswordThenReset(context),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          //--------------------------------Login Button-------------------------
                          loginButton(context),

                          Container(
                            margin: EdgeInsets.only(bottom: height * 0.025),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //-----------------Privacy Policy text------------------
                                GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PrivacyPolicyScreen(
                                                  selectPolicy: true,
                                                ),
                                          ));
                                    },
                                    child: Text(
                                      TextConst.privacyPolicyText,
                                      style: interMedium.copyWith(
                                          fontSize: width * 0.034,
                                          color:
                                          ThemeManager().getBlackColor),
                                    )),

                                Container(
                                  margin: EdgeInsets.only(
                                      left: width * 0.04,
                                      right: width * 0.04),
                                  child: CircleAvatar(
                                    radius: height * 0.003,
                                    backgroundColor:
                                    ThemeManager().getBlackColor,
                                  ),
                                ),

                                //------------------Terms and Condition text---------------
                                GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PrivacyPolicyScreen(
                                                  selectPolicy: false,
                                                ),
                                          ));
                                    },
                                    child: Text(
                                      TextConst.termsAndConditionsLoginText,
                                      style: interMedium.copyWith(
                                          fontSize: width * 0.034,
                                          color:
                                          ThemeManager().getBlackColor),
                                    )),
                              ],
                            ),
                          )
                        ],
                      ),
                    )

                    //---------------------Reset password View----------------------
                        : Container(
                      padding: EdgeInsets.only(top: height * 0.09),
                      width: width,
                      height: height * 0.597,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)),
                        color: ThemeManager().getWhiteColor,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin: EdgeInsets.only(
                                  left: height * 0.03, top: height * 0.035),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  //-------------------------Reset password text---------------
                                  Text(
                                    TextConst.resetPasswordText,
                                    style: interBold.copyWith(
                                      fontSize: width * 0.045,
                                      color: ThemeManager().getBlackColor,
                                    ),
                                  ),

                                  //----------------------instructions for reset password----------
                                  Container(
                                    //height: height * 0.15,
                                      margin: EdgeInsets.only(
                                          top: height * 0.03,
                                          right: width * 0.05),
                                      color: ThemeManager().getWhiteColor,
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            right: width * 0.03),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                "Please enter your email below to reset your password.",
                                                style: interRegular.copyWith(
                                                    color: ThemeManager()
                                                        .getDarkGreyColor,
                                                    fontSize: width * 0.035,
                                                    height: 1.2)),

                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: height * 0.015,
                                                  bottom: height * 0.03),
                                              child: Text(
                                                  "You will a receive a link in your email to reset the password.",
                                                  style: interRegular.copyWith(
                                                      color: ThemeManager()
                                                          .getDarkGreyColor,
                                                      fontSize:
                                                      width * 0.035,
                                                      height: 1.2)),
                                            ),

                                            //---------------email text-----------
                                            Container(
                                              margin: EdgeInsets.only(
                                                  bottom: height * 0.01),
                                              child: Text(
                                                TextConst.emailText,
                                                style: interMedium.copyWith(
                                                    color: ThemeManager()
                                                        .getPopUpTextGreyColor,
                                                    fontSize:
                                                    width * 0.038),
                                              ),
                                            ),

                                            //-----------------Email textField-------------

                                            Form(
                                              key: _formResetPasswordKey,
                                              child: TextFormField(
                                                obscureText: false,
                                                controller:
                                                resetPasswordTextController,
                                                autovalidateMode:
                                                AutovalidateMode.onUserInteraction,
                                                keyboardType: TextInputType
                                                    .emailAddress,
                                                style: interMedium.copyWith(
                                                    fontSize:
                                                    width * 0.045),
                                                cursorColor: ThemeManager()
                                                    .getDarkGreenColor,
                                                decoration:
                                                new InputDecoration(
                                                  border: InputBorder.none,
                                                  fillColor: ThemeManager()
                                                      .getLightGreenTextFieldColor,
                                                  filled: true,
                                                  // hintText: "Email Address",
                                                  hintStyle: interMedium.copyWith(
                                                      color: ThemeManager()
                                                          .getLightGrey1Color,
                                                      fontSize:
                                                      width * 0.034),
                                                ),
                                                onTap: () {
                                                  setState(() {
                                                    _emailDone = _emailDone;
                                                  });
                                                },
                                                validator: (val) {
                                                  if (val!.isEmpty) {
                                                    return "Please enter email address";
                                                  } else if (_emailDone ==
                                                      false) {
                                                    return "Please enter a valid email address";
                                                  }
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      ))
                                ],
                              )),

                          //-----------------Submit button-------------------------
                          GestureDetector(
                            // onTap: () {
                            //   if (resetPasswordTextController.text.contains(
                            //       RegExp(
                            //           r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$'))) {
                            //     setState(() {
                            //       _emailDone = true;
                            //     });
                            //     if (_formResetPasswordKey.currentState!
                            //         .validate()) {
                            //       Navigator.push(
                            //           context,
                            //           MaterialPageRoute(
                            //               builder: (context) =>
                            //                   LoginScreen()));
                            //     }
                            //   } else {
                            //     setState(() {
                            //       _emailDone = false;
                            //     });
                            //   }
                            // },
                            onTap: () {
                              if (resetPasswordTextController.text.contains(
                                  RegExp(
                                      r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$'))) {
                                setState(() {
                                  _emailDone = true;
                                });
                                if (_formResetPasswordKey.currentState!
                                    .validate()) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Login(firestore: widget.firestore,auth: widget.auth,locale: widget.locale,),
                                      ));
                                }
                              } else {
                                setState(() {
                                  _emailDone = false;
                                });
                              }
                            },
                            child: Container(
                                margin: EdgeInsets.only(
                                    left: width * 0.05,
                                    right: width * 0.05,
                                    bottom: height * 0.05),
                                child: ButtonView(
                                    buttonLabel: TextConst.submitText)),
                          ),
                        ],
                      ),
                    ),

                    //-----------------------------App name image-----------------
                    Positioned(
                      top: height * -0.145,
                      left: width * 0.35,
                      child: Image.asset(
                       // "assets/images/staht_bacon.png",
                        "assets/images/introAppLogo.png",
                        height: height * 0.29,
                        width: width * 0.295,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),),
        Positioned(bottom: 0,left: 0,right: 0,child: InkWell(onTap: () async {
          // showDialog(
          //     context: context,
          //     builder: (context) {
          //       return AlertDialog(
          //         title: Text('QR Scan'),
          //         content: Text('Please wait'),
          //
          //
          //       );
          //     });
          String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
              "#ff6666", "Cancel", false, ScanMode.DEFAULT);
          print("Found qr");
          print(barcodeScanRes);

        DocumentSnapshot qrData = await  FirebaseFirestore.instance.collection("productsQR").doc(barcodeScanRes).get();

         // Navigator.pop(context);


            if(barcodeScanRes.length>5){
              print("matching ..."+qrData.id+"  vs "+barcodeScanRes);
              if(qrData.id == barcodeScanRes){
                print("verified");

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => QRScanActivity(data: qrData,)));

              }else{

                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(barcodeScanRes),
                        content: Text('Code incorrect'),


                      );
                    });
              }
            }else{
             // Navigator.pop(context);

              print("Not found");
            }

        },child: Container(color: ThemeManager().getDarkGreenColor,height: 50,width: MediaQuery.of(context).size.width,child: Center(child: Text("New Account with QR Code",style: TextStyle(color: Colors.white),),),)),)
      ],),
    );
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Builder(builder: (BuildContext context) {
            return Container(
              height: 400,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/staht_logo_green.jpg",height: 150,width: 150,),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(height: 20,width:20,child: Icon(Icons.email,)),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: TextFormField(

                                  key: const ValueKey("username"),
                                  textAlign: TextAlign.left,
                                  decoration: const InputDecoration(hintText: "Username"),
                                  controller: _emailController,
                                ),
                              ),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(height: 20,width:20,child: Icon(Icons.lock)),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: TextFormField(
                                  key: const ValueKey("password"),
                                  textAlign: TextAlign.left,
                                  decoration: const InputDecoration(hintText: "Password",),
                                  controller: _passwordController,
                                ),
                              ),
                            ),
                          ],
                        ),



                        const SizedBox(
                          height: 20,
                        ),
                        RaisedButton(
                          color: color,

                          key: const ValueKey("signIn"),
                          onPressed: () async {


                         bool loginResponse = await   LoginBloc(auth: widget.auth,context: context).loginUser(email: _emailController.text,
                              password: _passwordController.text,);



                          },
                          child:  Container(width: double.infinity,child: Center(child: AppLabels(locale: widget.locale).loginLabel())),

                        ),

                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  void testFirestoreDB() async{
    print(DateTime.now().millisecondsSinceEpoch);
    QuerySnapshot<Map<dynamic,dynamic>> data =  await widget.firestore.collection("test").get();
    print(data.docs.first.data());
    print(DateTime.now().millisecondsSinceEpoch);

    print(DateTime.now().millisecondsSinceEpoch);
    QuerySnapshot<Map<dynamic,dynamic>> data2 =  await widget.firestore.collection("test2").get();
    print(data2.docs.first.data());
    print(DateTime.now().millisecondsSinceEpoch);
    print("====");


    print(DateTime.now().millisecondsSinceEpoch);
    QuerySnapshot<Map<dynamic,dynamic>> data3 =  await widget.firestore.collection("test").get();
    print(data3.docs.first.data());
    print(DateTime.now().millisecondsSinceEpoch);
  }
  //--------------Forgot password Reset here text----------------
  Widget forgotPasswordThenReset(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: height * 0.017,
      ),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: width * 0.008),
            child: Text(
              TextConst.forgotPasswordText,
              style: interSemiBold.copyWith(fontSize: width * 0.034),
            ),
          ),
          GestureDetector(
            onTap: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PasswordForgetActivity(
                      auth: widget.auth,

                    )),
              );




            },
            child: Text(
              TextConst.resetHereText,
              style: interBold.copyWith(
                  color: ThemeManager().getDarkGreenColor,
                  fontSize: width * 0.034),
            ),
          ),
        ],
      ),
    );
  }

  //---------------Login button---------------------
  Widget loginButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {

        if(progress== false){
          if (emailTextController.text.contains(
              RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$'))) {
            setState(() {
              _loginEmailDone = true;
              progress = true;
            });
            if (_formLoginKey.currentState!.validate()) {
              bool loginResponse = await   LoginBloc(auth: widget.auth,context: context).loginUser(email: emailTextController.text,
                password: passwordTextController.text,);
              setState(() {

                progress = false;
              });
              //if(loginResponse)
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => BottomNavigationBarScreen(),
              //     ));
            }
          } else {
            setState(() {
              _loginEmailDone = false;
              progress = false;
            });
          }
        }

      },
      child: Container(
          margin: EdgeInsets.only(
              left: width * 0.05,
              right: width * 0.05,
              bottom: height * 0.05,
              top: height * 0.001),
          child: ButtonView(buttonLabel:progress?"Please wait": TextConst.loginText)),
    );
  }
}
class ButtonView extends StatelessWidget {
  String buttonLabel;
  ButtonView({Key? key,required this.buttonLabel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Container(
        alignment: Alignment.center,
        height: height * 0.058,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height*0.008),
          color: ThemeManager().getDarkGreenColor,
        ),
        child: Text(
          buttonLabel,
          style: interSemiBold.copyWith(
              fontSize: width*0.04, color: ThemeManager().getWhiteColor),
        ));
  }
}

void _pushPage(BuildContext context, Widget page) {
  Navigator.of(context) /*!*/ .push(
    MaterialPageRoute<void>(builder: (_) => page),
  );
}

class QRScanActivity extends StatefulWidget {
  DocumentSnapshot data ;
   QRScanActivity({required this.data});

  @override
  _QRScanActivityState createState() => _QRScanActivityState();
}
Future<void> sendOTPEmailQR({String? targetEmail}) async {

  var url = cloudRestApiBase + 'sendEmailNoVerifyPassword';
  final http.Response response = await http.post(Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String?>{
     // "OTPcode": OTPcode,
      "targetEmail": targetEmail
    }),);
  print(response.body);
  return;


}
Future<void> sendOTPEmail({String? targetEmail,String? OTPcode}) async {

  var url = cloudRestApiBase + 'sendVerificationEmail';
  final http.Response response = await http.post(Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String?>{
      "OTPcode": OTPcode,
      "targetEmail": targetEmail
    }),);
  print(response.body);
  return;


}
Future<bool> createCustomerUserQR({required BuildContext context,String? email, String? password,String? displayname,String? Tenantid}) async {
  savedata(FirebaseAuth _auth,FirebaseFirestore firestore)async{
    try {
      var a=  await _auth.createUserWithEmailAndPassword(
          email: email!.trim(), password: password!.trim());

      sendOTPEmailQR(targetEmail:a.user!.email,
        // OTPcode:"https://app.staht.com/#"+"/verify"+value.id
      );
      //firestore.collection("tenants").add({"uid":a.user.uid,"tenant":parentTenant});
      firestore.collection("users").add({"parentType":"customer","email":a.user!.email,"displayName":displayname,"uid":a.user!.uid,"parentId":Tenantid,"roleId":RoleManager(rolId: '').CUSTOMER_ADMIN_ROLE_ID,}).then((value) {
        print("user saved");
        print(value.id);
        Navigator.of(context).popUntil((route) => route.isFirst);
      });
      // firestore.collection("verify").add({"uid":a.user!.uid,"email":a.user!.email,"verified":false}).then((value) {
      //   firestore.collection("verify").doc(value.id).update({"code":value.id});
      //   sendOTPEmailQR(targetEmail:a.user!.email,
      //      // OTPcode:"https://app.staht.com/#"+"/verify"+value.id
      //   );
      //   //firestore.collection("tenants").add({"uid":a.user.uid,"tenant":parentTenant});
      //   firestore.collection("users").add({"parentType":"customer","email":a.user!.email,"displayName":displayname,"uid":a.user!.uid,"parentId":Tenantid,"roleId":RoleManager(rolId: '').CUSTOMER_ADMIN_ROLE_ID,}).then((value) {
      //     print("user saved");
      //     print(value.id);
      //     Navigator.of(context).popUntil((route) => route.isFirst);
      //   });
      //
      // });


      // await a.user.sendEmailVerification();

      //firestore.collection("tenants").add({"uid":a.user.uid,"tenant":parentTenant});

      return true;
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      return false;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  try{
    // FirebaseApp app =await Firebase.initializeApp(
    //     name:"staht-connect-322113",
    //     options: FirebaseOptions(
    //       appId: Config().defaultAppId,
    //       apiKey:  Config().apiKey,
    //       messagingSenderId: '',
    //       projectId:"staht-connect-322113",
    //     )
    // );
    //  FirebaseAuth firebaseAuth = FirebaseAuth.instanceFor(app: app);
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    await savedata(firebaseAuth,firestore);
    return true;
  }catch(e){
    // FirebaseAuth firebaseAuth= FirebaseAuth.instanceFor(app:  Firebase.app("staht-connect-322113"));
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    await  savedata(firebaseAuth,firestore);
    return true;

  }


}
Future<bool> createCustomerUser({required BuildContext context,String? email, String? password,String? displayname,String? Tenantid}) async {
  savedata(FirebaseAuth _auth,FirebaseFirestore firestore)async{
    try {
      var a=  await _auth.createUserWithEmailAndPassword(
          email: email!.trim(), password: password!.trim());


      firestore.collection("verify").add({"uid":a.user!.uid,"email":a.user!.email,"verified":false}).then((value) {
        firestore.collection("verify").doc(value.id).update({"code":value.id});
        sendOTPEmail(targetEmail:a.user!.email,OTPcode:"https://app.staht.com/#"+"/verify"+value.id);
        //firestore.collection("tenants").add({"uid":a.user.uid,"tenant":parentTenant});
        firestore.collection("users").add({"parentType":"customer","email":a.user!.email,"displayName":displayname,"uid":a.user!.uid,"parentId":Tenantid,"roleId":RoleManager(rolId: '').CUSTOMER_ADMIN_ROLE_ID,}).then((value) {
          print("user saved");
          print(value.id);
          Navigator.of(context).popUntil((route) => route.isFirst);
        });

      });


      // await a.user.sendEmailVerification();

      //firestore.collection("tenants").add({"uid":a.user.uid,"tenant":parentTenant});

      return true;
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      return false;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  try{
    // FirebaseApp app =await Firebase.initializeApp(
    //     name:"staht-connect-322113",
    //     options: FirebaseOptions(
    //       appId: Config().defaultAppId,
    //       apiKey:  Config().apiKey,
    //       messagingSenderId: '',
    //       projectId:"staht-connect-322113",
    //     )
    // );
  //  FirebaseAuth firebaseAuth = FirebaseAuth.instanceFor(app: app);
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    await savedata(firebaseAuth,firestore);
    return true;
  }catch(e){
   // FirebaseAuth firebaseAuth= FirebaseAuth.instanceFor(app:  Firebase.app("staht-connect-322113"));
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    await  savedata(firebaseAuth,firestore);
    return true;

  }


}
class _QRScanActivityState extends State<QRScanActivity> {
  TextEditingController controller1 =  TextEditingController();
  TextEditingController controller2 =  TextEditingController();
  TextEditingController controller3 =  TextEditingController();
  TextEditingController controller4 =  TextEditingController();
  TextEditingController controller5 =  TextEditingController();
  TextEditingController controller9 =  TextEditingController();
  TextEditingController controller6 =  TextEditingController();
  TextEditingController controller7 =  TextEditingController();
  TextEditingController controller8 =  TextEditingController();

 // int checkBoxPosition = 0;
  String projectOrigin = "EU";
  String cloudRestApiBase = "https://us-central1-staht-connect-322113.cloudfunctions.net/";
  String firestoreRegion = "europe-west2";
  String StorageRegion = "gs://staht-connect-322113.appspot.com";
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    Widget appBar =  Container(color: Colors.white,
      child: Wrap(
        children: [
          Container(height:height*0.07 ,
            child: Stack(
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(alignment: Alignment.center,child: Text(
                 "Create Account",maxLines: 1,
                  style: interRegular.copyWith(
                      color: ThemeManager().getBlackColor,
                      fontWeight: FontWeight.w800,
                      fontSize: width * 0.052),
                ),),





                // Container(
                //  margin: EdgeInsets.only(top: height*0.025,right: width*0.05),
                //   child: SvgPicture.asset(
                //     ("assets/svg/notificationIcon.svg"),
                //     fit: BoxFit.cover,
                //   ),
                // ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: height*0.008),
            height: height*0.001,
            width: double.infinity,
            color: ThemeManager().getBlackColor.withOpacity(.15),
          )
        ],
      ),
    );
    return SafeArea(child: Scaffold(body: SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
        appBar,


        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(elevation: 3,shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),color: Colors.white,child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(controller: controller6,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    contentPadding: EdgeInsets.all(12),
                    labelStyle: interBold.copyWith(
                      color: ThemeManager().getBlackColor,
                      //fontSize: width * 0.05
                    ),
                    hintStyle:interBold.copyWith(
                      color: ThemeManager().getLightGrey1Color,
                      //fontSize: width * 0.05
                    ) ,
                    border: InputBorder.none,
                    filled: true,fillColor: ThemeManager().getDarkGreenColor.withOpacity(0.05),

                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(controller: controller5,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    contentPadding: EdgeInsets.all(12),
                    labelStyle: interBold.copyWith(
                      color: ThemeManager().getBlackColor,
                      //fontSize: width * 0.05
                    ),
                    hintStyle:interBold.copyWith(
                      color: ThemeManager().getLightGrey1Color,
                      //fontSize: width * 0.05
                    ) ,
                    border: InputBorder.none,
                    filled: true,fillColor: ThemeManager().getDarkGreenColor.withOpacity(0.05),

                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(controller: controller9,
                  decoration: InputDecoration(
                    labelText: 'Confirm Email Address',
                    contentPadding: EdgeInsets.all(12),
                    labelStyle: interBold.copyWith(
                      color: ThemeManager().getBlackColor,
                      //fontSize: width * 0.05
                    ),
                    hintStyle:interBold.copyWith(
                      color: ThemeManager().getLightGrey1Color,
                      //fontSize: width * 0.05
                    ) ,
                    border: InputBorder.none,
                    filled: true,fillColor: ThemeManager().getDarkGreenColor.withOpacity(0.05),

                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(controller: controller7,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    contentPadding: EdgeInsets.all(12),
                    labelStyle: interBold.copyWith(
                      color: ThemeManager().getBlackColor,
                      //fontSize: width * 0.05
                    ),
                    hintStyle:interBold.copyWith(
                      color: ThemeManager().getLightGrey1Color,
                      //fontSize: width * 0.05
                    ) ,
                    border: InputBorder.none,
                    filled: true,fillColor: ThemeManager().getDarkGreenColor.withOpacity(0.05),

                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(controller: controller8,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    contentPadding: EdgeInsets.all(12),
                    labelStyle: interBold.copyWith(
                      color: ThemeManager().getBlackColor,
                      //fontSize: width * 0.05
                    ),
                    hintStyle:interBold.copyWith(
                      color: ThemeManager().getLightGrey1Color,
                      //fontSize: width * 0.05
                    ) ,
                    border: InputBorder.none,
                    filled: true,fillColor: ThemeManager().getDarkGreenColor.withOpacity(0.05),

                  ),
                ),
              ),
            ],
          ),),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(elevation: 3,shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),color: Colors.white,child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(controller: controller1,
                  decoration: InputDecoration(contentPadding: EdgeInsets.all(12),
                    labelText: 'Company Name',



                    labelStyle: interBold.copyWith(
                      color: ThemeManager().getBlackColor,
                      //fontSize: width * 0.05
                    ),
                    hintStyle:interBold.copyWith(
                      color: ThemeManager().getLightGrey1Color,
                      //fontSize: width * 0.05
                    ) ,
                    border: InputBorder.none,
                    filled: true,fillColor: ThemeManager().getDarkGreenColor .withOpacity(0.05),

                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextFormField(controller: controller2,
              //     decoration: InputDecoration(
              //       labelText: 'Company Email',
              //       contentPadding: EdgeInsets.all(12),
              //       border: InputBorder.none,
              //       labelStyle: interBold.copyWith(
              //         color: ThemeManager().getBlackColor,
              //         //fontSize: width * 0.05
              //       ),
              //       hintStyle:interBold.copyWith(
              //         color: ThemeManager().getLightGrey1Color,
              //         //fontSize: width * 0.05
              //       ) ,
              //       filled: true,fillColor: ThemeManager().getDarkGreenColor.withOpacity(0.05),
              //
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(controller: controller3,
                  decoration: InputDecoration(
                    labelText: 'Company Phone',
                    contentPadding: EdgeInsets.all(12),
                    border: InputBorder.none,
                    labelStyle: interBold.copyWith(
                      color: ThemeManager().getBlackColor,
                      //fontSize: width * 0.05
                    ),
                    hintStyle:interBold.copyWith(
                      color: ThemeManager().getLightGrey1Color,
                      //fontSize: width * 0.05
                    ) ,
                    filled: true,fillColor:ThemeManager().getDarkGreenColor.withOpacity(0.05),

                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(controller: controller4,
                  decoration: InputDecoration(
                    labelText: 'Company Address',
                    contentPadding: EdgeInsets.all(12),
                    border: InputBorder.none,
                    labelStyle: interBold.copyWith(
                      color: ThemeManager().getBlackColor,
                      //fontSize: width * 0.05
                    ),
                    hintStyle:interBold.copyWith(
                      color: ThemeManager().getLightGrey1Color,
                      //fontSize: width * 0.05
                    ) ,
                    filled: true,fillColor: ThemeManager().getDarkGreenColor.withOpacity(0.05),

                  ),
                ),
              ),
            ],
          ),),
        ),





        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(elevation: 3,shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),color: Colors.white,child: Column(
            children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(title: Text("Please choose the region closest to your location",style:interRegular.copyWith(
                          color: ThemeManager().getDarkGreenColor,
                          fontWeight: FontWeight.w800,
                          fontSize: width * 0.042) ,),),
                    ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SelectRegion(data: ["Europe","North America","Asia","Australia"],onSelected: (val){

                  if(val == "Europe"){
                    StorageRegion = "gs://staht-connect-322113.appspot.com";
                    firestoreRegion = "europe-west2";
                    projectOrigin = "EU";
                  }
                  if(val == "North America"){
                    StorageRegion = "gs://staht-connect-322113-us";
                    firestoreRegion = "us-west1";
                    projectOrigin = "US";
                  }
                  if(val == "Asia"){
                    StorageRegion = "gs://staht-connect-322113-asia-mult";
                    firestoreRegion = "asia-southeast1";
                    projectOrigin = "ASIA";
                  }
                  if(val == "Australia"){
                    StorageRegion = "gs://staht-connect-322113-aus-syd";
                    firestoreRegion = "australia-southeast1";
                    projectOrigin = "AUS";
                  }
                  print(StorageRegion);
                  print(firestoreRegion);
                  print(projectOrigin);


                },),
              ),
            ],
          ),



          ),
        ),

        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Card(elevation: 3,shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(0.0),
        //   ),color: Colors.white,child:
        //
        //   Column(
        //     children: [
        //       ListTile(title: Text("Please Choose the region closest to your location",style:interRegular.copyWith(
        //           color: ThemeManager().getDarkGreenColor,
        //           fontWeight: FontWeight.w800,
        //           fontSize: width * 0.042) ,),),
        //
        //
        //
        //
        //       CheckboxListTile(title: Text("Europe",style:interRegular.copyWith(
        //           color: ThemeManager().getBlackColor,
        //           fontWeight: FontWeight.w800,
        //           fontSize: width * 0.042) ,),value: checkBoxPosition==0?true:false, onChanged: (val){
        //         setState(() {
        //           if(val == true) checkBoxPosition = 0;
        //         });
        //       }),
        //       Divider(),
        //       CheckboxListTile(title: Text("North America",style:interRegular.copyWith(
        //           color: ThemeManager().getBlackColor,
        //           fontWeight: FontWeight.w800,
        //           fontSize: width * 0.042) ),value: checkBoxPosition==1?true:false, onChanged: (val){
        //         setState(() {
        //           if(val == true) checkBoxPosition = 1;
        //         });
        //       }),
        //       Divider(),
        //       CheckboxListTile(title: Text("Asia",style:interRegular.copyWith(
        //           color: ThemeManager().getBlackColor,
        //           fontWeight: FontWeight.w800,
        //           fontSize: width * 0.042) ),value: checkBoxPosition==2?true:false, onChanged: (val){
        //         setState(() {
        //           if(val == true) checkBoxPosition = 2;
        //         });
        //       }),
        //       Divider(),
        //       CheckboxListTile(title: Text("Australia",style:interRegular.copyWith(
        //           color: ThemeManager().getBlackColor,
        //           fontWeight: FontWeight.w800,
        //           fontSize: width * 0.042) ),value: checkBoxPosition==3?true:false, onChanged: (val){
        //         setState(() {
        //           if(val == true) checkBoxPosition = 3;
        //         });
        //       }),
        //     ],
        //   ),),
        // ),


        InkWell(onTap: () async {

          String  v1 =  controller1.text;
          String  v2 =  controller2.text;
          String  v3 =  controller3.text;
          String  v4 =  controller4.text;
          String  v5 =  controller5.text;
          String  v6 =  controller6.text;
          String  v7 =  controller7.text;
          String  v8 =  controller8.text;
          String  v9 =  controller9.text;

          bool isEmailOk = false;

          String uri = "https://us-central1-staht-connect-322113.cloudfunctions.net/checkUserExists";


          if(v1.length>0){
            if(true){
              if(v3.length>0){
                if(v4.length>0){
                  if(v5.length>0){
                  if(v9.length>0){
                  if(v5 == v9){
                    showDialog(barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Please wait',style:interRegular.copyWith(
                                color: ThemeManager().getBlackColor,
                                fontWeight: FontWeight.w800,
                                fontSize: width * 0.042) ),
                            content: Container(height: 100,child: Scaffold(backgroundColor: Colors.white,body: Center(child: CircularProgressIndicator(),),)),

                          );
                        });

                    final http.Response response = await http.post(Uri.parse(uri),
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                      },
                      body: jsonEncode(<String, String?>{
                        // "OTPcode": OTPcode,
                        "uid": v5
                      }),);
                    var d = jsonDecode(response.body);

                    isEmailOk = !d["usersExists"];

                    Navigator.pop(context);




                    if(isEmailOk){
                    if(v6.length>0){
                      if(v7.length>5){
                        if(v8.length>5){
                          if(v7 == v8){
                            showDialog(barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Please wait. It may take up to 15 seconds',style:interRegular.copyWith(
                                        color: ThemeManager().getBlackColor,
                                        fontWeight: FontWeight.w800,
                                        fontSize: width * 0.042) ),
                                    content: Container(height: 100,child: Scaffold(backgroundColor: Colors.white,body: Center(child: CircularProgressIndicator(),),)),

                                  );
                                });
                            FirebaseFirestore firestore = FirebaseFirestore.instance ;



                            QuerySnapshot postRef = await firestore.collection('customers').where("isStock",isEqualTo: true).where("projectOrigin",isEqualTo: projectOrigin).get();

                            if(postRef.docs.length>0){
                              firestore.collection('customers').doc(postRef.docs.first.id).update({
                                'isStock' : false,
                              });

                              await  firestore.collection('customers').doc(postRef.docs.first.id).update({
                                'address' : controller4.text,
                                'email' : controller2.text,
                                'prjectName' : controller1.text,
                                'telephone' : controller3.text,
                                //"region":firestoreRegion,"regionBucket":StorageRegion,
                              });

                              String gcpId = postRef.docs.first.get("projectId");
                              await  Api(firestore:firestore).addfirestore(region: firestoreRegion!, uid: "", projectID: gcpId.trim(),);
                              await Future.delayed(Duration(seconds: 10));

                              Api(firestore:firestore).addfirestoreRules(projectID: (gcpId).trim(),);
                              Api(firestore:firestore).addfirestoreRules(projectID: (gcpId).trim(),);
                              Api(firestore:firestore).addfirestoreRules(projectID: (gcpId).trim(),);
                              Api(firestore:firestore).addfirestoreRules(projectID: (gcpId).trim(),);
                              Api(firestore:firestore).addfirestoreRules(projectID: (gcpId).trim(),);
                              Api(firestore:firestore).addfirestoreRules(projectID: (gcpId).trim(),);
                              Api(firestore:firestore).addfirestoreRules(projectID: (gcpId).trim(),);
                              Api(firestore:firestore).addfirestoreRules(projectID: (gcpId).trim(),);
                              Api(firestore:firestore).addfirestoreRules(projectID: (gcpId).trim(),);
                              Api(firestore:firestore).addfirestoreRules(projectID: (gcpId).trim(),);
                              Api(firestore:firestore).addfirestoreRules(projectID: (gcpId).trim(),);
                              Api(firestore:firestore).addfirestoreRules(projectID: (gcpId).trim(),);
                              Api(firestore:firestore).addfirestoreRules(projectID: (gcpId).trim(),);
                              Api(firestore:firestore).addfirestoreRules(projectID: (gcpId).trim(),);

                              createCustomerUserQR(context: context,email: controller5.text,password: v7,displayname: v6,Tenantid:postRef.docs.first.id).then((value) async {
                                await FirebaseAuth.instance.signOut();
                                await FirebaseAuth.instance.signOut();
                                Navigator.of(context).popUntil((route) => route.isFirst);
                                await FirebaseAuth.instance.signOut();
                                Navigator.of(context).popUntil((route) => route.isFirst);
                                await FirebaseAuth.instance.signInWithEmailAndPassword(email:  controller5.text, password: v7);
                                await  firestore.collection('customers').doc(postRef.docs.first.id).update({
                                  "masterUser":FirebaseAuth.instance.currentUser!.uid
                                  //"region":firestoreRegion,"regionBucket":StorageRegion,
                                });
                              });
                            }else{

                            }
                          }else{

                          showErrorDialogMsg(msg:"Both password does not match" );
                          }

                        }else{
                          showErrorDialogMsg(msg:"Password should be at least 6 character/digits" );
                        }
                      }else{
                        showErrorDialogMsg(msg:"Password should be at least 6 character/digits" );
                      }
                    }else{
                      showErrorDialog(field:"Name" );
                    } }else{
                      showErrorDialogMsg(msg:"Email Exists" );
                    }
                  }else{
                    showErrorDialogMsg(msg:"Email does not  match" );
                  } }else{
                    showErrorDialog(field:"User Email" );
                  }
                  }else{
                    showErrorDialog(field:"User Email" );
                  }
                }else{
                  showErrorDialog(field:"Company Address" );
                }
              }else{
                showErrorDialog(field:"Company Phone" );
              }
            }else{
              showErrorDialog(field:"Company Email" );
            }
          }else{
            showErrorDialog(field:"Company Name" );
          }











            // try {
            //   var url = cloudRestApiBase + 'addfirestore';
            //   final http.Response response = await http.post(Uri.parse(url),
            //     headers: <String, String>{
            //       'Content-Type': 'application/json; charset=UTF-8',
            //     },
            //     body: jsonEncode(<String, String?>{ "project_id": postRef.docs.first.get("projectId"),"region":firestoreRegion}),);
            //
            //   print(response.body);
            //
            //
            //
            //   if (response.statusCode == 200) {
            //
            //   } else {
            //     throw Exception('Failed to load album');
            //   }
            // } catch (e) {
            //   print(e.toString());
            //
            // }
           // await Future.delayed(Duration(seconds: 10));
           //  try {
           //    var url = cloudRestApiBase+'addrules';
           //    final http.Response response = await http.post(Uri.parse(url),
           //      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',},
           //      body: jsonEncode(<String, String?> {   "project_id": postRef.docs.first.get("projectId"),}),);
           //
           //    print("add rules response");
           //    print(response.body);
           //
           //
           //    if (response.statusCode == 200) {
           //
           //
           //    } else {
           //
           //      throw Exception('Failed to load album');
           //    }
           //  } catch (e) {
           //
           //
           //  }






        },child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(decoration: BoxDecoration(color: ThemeManager().getDarkGreenColor,borderRadius: BorderRadius.circular(5) ),width: double.infinity,child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(child: Text("Finish Sign Up",style:interRegular.copyWith(
            color: ThemeManager().getWhiteColor,
                fontWeight: FontWeight.w800,
                fontSize: width * 0.042) ,)),
          ),),
        )),
      ],),
    ),));
  }

  void showErrorDialog({required String field}) {

    showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: new Text(field),
          content: new Text(field+" field cannot be empty"),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text("OK"),onPressed: (){
                Navigator.pop(context);
            },
            ),

          ],
        )
    );

  }
  void showErrorDialogMsg({required String msg}) {

    showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: new Text("Error"),
          content: new Text(msg),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text("OK"),onPressed: (){
    Navigator.pop(context);
    },
            ),

          ],
        )
    );

  }
}
class SelectRegion extends StatefulWidget {
  List data;

  Function(String)onSelected;
  SelectRegion({required this.data,required this.onSelected});

  @override
  _SelectRegionState createState() => _SelectRegionState();
}

class _SelectRegionState extends State<SelectRegion> {
  String selected ="Europe";
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: height * 0.019,
      ),
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(width*0.02)),
        border: Border.all(
          color: ThemeManager().getBlackColor.withOpacity(.05),
        ),
      ),

      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),

        child: ExpansionTile(
          key: UniqueKey(),
          backgroundColor: ThemeManager().getLightGreenTextFieldColor,
          collapsedBackgroundColor: ThemeManager().getLightGreenTextFieldColor,
          //initiallyExpanded: true,
          iconColor: ThemeManager().getLightGrey1Color,
          //trailing: Icon(Icons.keyboard_arrow_down,size: width*0.08),

          //----------------Selected Product text from dropdown-------
          title: Text(selected,
            style: interMedium.copyWith(
                color: ThemeManager().getLightGrey1Color,
                fontSize: width * 0.042),
          ),

          //----------------Available Product List in dropdown------------
          children: <Widget>[
            for (var productItem in widget.data)
              InkWell(
                onTap: () {
                  widget.onSelected(productItem);
                  setState(() {
                    selected =  productItem;

                  });

                },
                child: Container(
                  color: ThemeManager().getWhiteColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: height * 0.02, left: width * 0.03),
                        child: Text( productItem,
                          style: interSemiBold.copyWith(
                              color: ThemeManager().getBlackColor,
                              fontSize: width * 0.042),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: height * 0.02),
                        height: height * 0.001,
                        color: ThemeManager().getBlackColor.withOpacity(0.10),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

