import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connect/components/buttonView.dart';
import 'package:connect/screens/dashboardScreen.dart';
import 'package:connect/screens/privacyPolicyScreen.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/textConst.dart';
import 'package:connect/utils/textStyleConst.dart';
import 'package:connect/utils/themeManager.dart';

class LoginScreenNotUsing extends StatefulWidget {
  const LoginScreenNotUsing({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreenNotUsing> {
  TextEditingController emailTextController = new TextEditingController();
  TextEditingController passwordTextController = new TextEditingController();
  TextEditingController resetPasswordTextController =
      new TextEditingController();

  final _formResetPasswordKey = GlobalKey<FormState>();
  final _formLoginKey = GlobalKey<FormState>();

  bool showResetPasswordScreen = true;
  bool _emailDone = false;
  bool _loginEmailDone = false;

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
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
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
                                                      if (val!.isEmpty) {
                                                        return "Please enter email address";
                                                      } else if (_loginEmailDone ==
                                                          false) {
                                                        return "Please enter a valid email address";
                                                      }
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
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //       builder: (context) => Login(),
                                      //     ));
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
      ),
    );
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
              setState(() {
                if (showResetPasswordScreen == true) {
                  showResetPasswordScreen = false;
                } else {
                  showResetPasswordScreen = false;
                }
              });
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
      onTap: () {
        if (emailTextController.text.contains(
            RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$'))) {
          setState(() {
            _loginEmailDone = true;
          });
          if (_formLoginKey.currentState!.validate()) {

          }
        } else {
          setState(() {
            _loginEmailDone = false;
          });
        }
      },
      child: Container(
          margin: EdgeInsets.only(
              left: width * 0.05,
              right: width * 0.05,
              bottom: height * 0.05,
              top: height * 0.001),
          child: ButtonView(buttonLabel: TextConst.loginText)),
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

// Container(
//   height: height * 0.065,
//   margin: EdgeInsets.only(top: height * 0.012),
//   padding: EdgeInsets.only(left: width * 0.040, bottom: height * 0.014),
//   decoration: BoxDecoration(
//       color: ThemeManager().getLightGreenTextFieldColor,
//       borderRadius: BorderRadius.circular(height * 0.009)),
//   child: Form(
//     key: _formEmailKey,
//     child: TextFormField(
//       validator: (val) => val!.isEmpty || !val.contains(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
//           ? "enter a valid eamil"
//           : null,
//       obscureText: false,
//       controller: emailTextController,
//       keyboardType: TextInputType.emailAddress,
//       style: interMedium.copyWith(fontSize: width * 0.045),
//       cursorColor: ThemeManager().getDarkGreenColor,
//       decoration: new InputDecoration(
//         border: InputBorder.none,
//         hintText: "Email Address",
//         hintStyle: interMedium.copyWith(
//             color: ThemeManager().getLightGreyHintTextColor,
//             fontSize: width * 0.034),
//       ),
//     ),
//   ),
// ),
// Container(
//   height: height * 0.065,
//   margin: EdgeInsets.only(top: height * 0.012),
//   padding: EdgeInsets.only(left: width * 0.040, bottom: height * 0.014),
//   decoration: BoxDecoration(
//       color: ThemeManager().getLightGreenTextFieldColor,
//       borderRadius: BorderRadius.circular(height * 0.009)),
//   child: Form(
//     key: _formPasswordKey,
//     child: TextFormField(
//       validator: (val) => val!.isEmpty
//           ? "enter a PassWord"
//           : null,
//       obscureText: true,
//       controller: passwordTextController,
//       keyboardType: TextInputType.visiblePassword,
//       style: interMedium.copyWith(fontSize: width * 0.045),
//       cursorColor: ThemeManager().getDarkGreenColor,
//       decoration: new InputDecoration(
//         border: InputBorder.none,
//         hintText: "Password",
//         hintStyle: interMedium.copyWith(
//             color: ThemeManager().getLightGreyHintTextColor,
//             fontSize: width * 0.034),
//       ),
//     ),
//   ),
// ),



//------------------------------Text field View-----------------------
// Widget textFieldView(
//     String hintLabel,
//     TextEditingController textFieldController,
//     TextInputType inputType,
//     bool isPassword) {
//   return Container(
//     height: height * 0.065,
//     margin: EdgeInsets.only(top: height * 0.012),
//     padding: EdgeInsets.only(left: width * 0.040, bottom: height * 0.014),
//     decoration: BoxDecoration(
//         color: ThemeManager().getLightGreenTextFieldColor,
//         borderRadius: BorderRadius.circular(height * 0.009)),
//     child: Form(
//       key: _formPasswordKey,
//       child: TextFormField(
//         validator: (val) => val!.isEmpty || !val.contains(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
//             ? "enter a valid eamil"
//             : null,
//         obscureText: isPassword,
//         controller: textFieldController,
//         keyboardType: inputType,
//         style: interMedium.copyWith(fontSize: width * 0.045),
//         cursorColor: ThemeManager().getDarkGreenColor,
//         decoration: new InputDecoration(
//           border: InputBorder.none,
//           hintText: hintLabel,
//           hintStyle: interMedium.copyWith(
//               color: ThemeManager().getLightGreyHintTextColor,
//               fontSize: width * 0.034),
//         ),
//       ),
//     ),
//   );
// }