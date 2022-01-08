import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/Activities/Login/loginActivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connect/components/buttonView.dart';
import 'package:connect/screens/loginScreen.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/textConst.dart';
import 'package:connect/utils/textStyleConst.dart';
import 'package:connect/utils/themeManager.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  bool selectPolicy;

  PrivacyPolicyScreen({
    required this.selectPolicy,
  });

  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ThemeManager().getWhiteColor,

      body: Container(
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

              child: Container(
                padding: EdgeInsets.only(top: height * 0.09),
                width: width,
                height: height * 0.597,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(height * 0.05),
                      topRight: Radius.circular(height * 0.05)),
                  color: ThemeManager().getWhiteColor,
                ),

                child: widget.selectPolicy == true

                //---------------------Privacy policy View---------------------
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin: EdgeInsets.only(
                                  left: height * 0.03, top: height * 0.03),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  //------------------privacy policy text----------------
                                  Text(
                                    TextConst.privacyPolicyText,
                                    style: interBold.copyWith(
                                        fontSize: width * 0.045,
                                        color: ThemeManager().getBlackColor),
                                  ),

                                  Container(
                                      height: height * 0.307,
                                      margin: EdgeInsets.only(
                                          top: height * 0.03,
                                          right: width * 0.05),
                                      color: ThemeManager().getWhiteColor,

                                      //---------------Scrollbar----------------------
                                      child: Scrollbar(
                                        thickness: width * 0.012,
                                        radius: Radius.circular(height * 0.2),
                                        isAlwaysShown: true,
                                        child: SingleChildScrollView(
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                right: width * 0.03),

                                            //----------------------Privacy policy instructions-------------
                                            child: Column(
                                              children: [
                                                Text(
                                                    "By using the Staht Connect app, you are agreeing to the Privacy Policy",
                                                    style: interRegular.copyWith(
                                                        color: ThemeManager()
                                                            .getDarkGreyColor,
                                                        fontSize: width * 0.035,
                                                        height: 1.3)),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      top: height * 0.015),
                                                  child: Text(
                                                      "To view the Privacy Policy, please visit www.staht.com/pages/privacy",
                                                      style: interRegular.copyWith(
                                                          color: ThemeManager()
                                                              .getDarkGreyColor,
                                                          fontSize:
                                                              width * 0.035,
                                                          height: 1.3)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ))
                                ],
                              )),

                          //-------------------------Button view---------------------
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (context) => Login(firestore: FirebaseFirestore.instance,auth: FirebaseAuth.instance,locale: Locale("en"),),
                                //     ));
                              },
                              child: Container(
                                  margin: EdgeInsets.only(
                                    left: width * 0.05,
                                    right: width * 0.05,
                                  ),
                                  padding:
                                      EdgeInsets.only(bottom: height * 0.04),

                                  child: Container(
                                      alignment: Alignment.center,
                                      height: height * 0.058,
                                      width: width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(height*0.008),
                                        color: ThemeManager().getDarkGreenColor,
                                      ),
                                      child: Text(
                                        TextConst.yesIUnderStandText,
                                        style: interSemiBold.copyWith(
                                            fontSize: width*0.04, color: ThemeManager().getWhiteColor),
                                      )))),
                        ],
                      )

                  //--------------------------Terms And Conditions View--------------------
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Container(
                              margin: EdgeInsets.only(
                                  left: height * 0.03, top: height * 0.03),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  //------------------Terms and conditions text--------------
                                  Text(
                                    TextConst.termsAndConditionsText,
                                    style: interBold.copyWith(
                                      fontSize: width * 0.045,
                                      color: ThemeManager().getBlackColor,
                                    ),
                                  ),

                                  //--------------------- Terms and conditions instructions------------
                                  Container(
                                      height: height * 0.307,
                                      margin: EdgeInsets.only(
                                          top: height * 0.03,
                                          right: width * 0.05),
                                      color: ThemeManager().getWhiteColor,
                                      child: Scrollbar(
                                        thickness: width * 0.012,
                                        radius: Radius.circular(height * 0.2),
                                        isAlwaysShown: true,
                                        child: SingleChildScrollView(
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                right: width * 0.03),
                                            child: Column(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: height * 0.02),
                                                  child: Text(
                                                      "By using the Staht Conenct app,you are agreeing to the Terms & Conditions of use",
                                                      style: interRegular.copyWith(
                                                          color: ThemeManager()
                                                              .getDarkGreyColor,
                                                          fontSize:
                                                              width * 0.035,
                                                          height: 1.3)),
                                                ),
                                                Text(
                                                    "To view the full Terms and Conditions please visit www.staht.com/pages/terms",
                                                    style: interRegular.copyWith(
                                                        color: ThemeManager()
                                                            .getDarkGreyColor,
                                                        fontSize: width * 0.035,
                                                        height: 1.3)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ))
                                ],
                              )),

                          //------------------------Button view----------------------
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (context) => Login(firestore: FirebaseFirestore.instance,auth: FirebaseAuth.instance,locale: Locale("en"),),
                                //     ));
                              },
                              child: Container(
                                  padding:
                                      EdgeInsets.only(bottom: height * 0.04),
                                  margin: EdgeInsets.only(
                                    left: width * 0.05,
                                    right: width * 0.05,
                                  ),
                                  child:  Container(
                                      alignment: Alignment.center,
                                      height: height * 0.058,
                                      width: width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(height*0.008),
                                        color: ThemeManager().getDarkGreenColor,
                                      ),
                                      child: Text(
                                        TextConst.yesIUnderStandText,
                                        style: interSemiBold.copyWith(
                                            fontSize: width*0.04, color: ThemeManager().getWhiteColor),
                                      )))),
                        ],
                      ),
              ),
            ),

            //------------------------------App name image---------------------
            Positioned(
                top: height * 0.255,
                left: width * 0.35,
                child: Container(
                    height: height * 0.3,
                    width: width * 0.3,
                    child: Image.asset("assets/images/introAppLogo.png")))
          ],
        ),
      ),
    );
  }
}
