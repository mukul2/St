import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/utils/textStyleConst.dart';
import 'package:connect/utils/themeManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:connect/services/config.dart';
import 'package:connect/services/restApi.dart';

class PasswordForgetActivity extends StatefulWidget {
  FirebaseAuth   auth;
  PasswordForgetActivity({required this.auth});
  @override
  _PasswordForgetActivityState createState() => _PasswordForgetActivityState();
}

class _PasswordForgetActivityState extends State<PasswordForgetActivity> {
  TextEditingController controller = new TextEditingController();
  // Initially password is obscure
  bool _obscureText = true;

  late String _password;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
  showAlertDialog(BuildContext context) {

    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');

        Navigator.pop(context);
         Navigator.pop(context);
        Navigator.pushNamed(context,"/");
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Password Reset",style: interSemiBold.copyWith(
        fontSize: width*0.04,)),
      content: Text("If this email is active, then a Password Reset email has been sent. Please follow the instructions sent in the email.",style: interSemiBold.copyWith(
          fontSize: width*0.04,),),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  NoAccountshowAlertDialog(BuildContext context) {

    // set up the button
    Widget okButton = FlatButton(
      child: Text("Search  again"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
       // Navigator.pop(context);
        // Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Email Not Found",style: interSemiBold.copyWith(
        fontSize: width*0.04,)),
      content: Text("This email is not recognised.",style: interSemiBold.copyWith(
        fontSize: width*0.04,)),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(body: Stack(
        children: [
          Align(alignment: Alignment.topLeft,child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),color: ThemeManager().getDarkGreenColor,elevation: 8,
              child: Container(width: 50,height: 50,

                child: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,),onPressed: (){
                  Navigator.pop(context);
                },),
              ),
            ),
          ),),
          Align(alignment: Alignment.center,child: Card(elevation: 8,
            child: Container(width: 500,height: 500,

              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [


                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Image.asset("assets/staht_logo_green.jpg",height: 100,),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: TextFormField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: "Email Address",hintStyle: interSemiBold.copyWith(
                          fontSize: width*0.04,),
                          contentPadding: EdgeInsets.all(10),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15, 0,0),
                      child: Container(decoration: BoxDecoration(
                          color: ThemeManager().getDarkGreenColor,
                          borderRadius: BorderRadius.circular(3)
                      ),

                        width: MediaQuery.of(context).size.width,
                        // height: 400,
                        child: InkWell(
                          onTap: () async{
                            //sendEmailVerification
                            FirebaseFirestore.instance.collection("users").where("email",isEqualTo: controller.text ).get().then((value) {
                              if(value!=null && value.size>0 && value.docs.length>0){
                                FirebaseFirestore.instance.collection("resetPasswordOTP").add({"email": controller.text,"uid":value.docs.first.get("uid")}).then((value) {
                                  Api(firestore: FirebaseFirestore.instance).sendEmailVerification(link:Config().webURL+"/resetPassword"+value.id ,email: controller.text ).then((value) {
                                    showAlertDialog(context);
                                  });
                                });

                              }else{
                                NoAccountshowAlertDialog(context);
                              }
                            });




                          },
                          child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Send Verification Email",
                                  style: interSemiBold.copyWith(
                                fontSize: width*0.04,color: Colors.white),
                                ),
                              )),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),)
        ],
      ),),
    );
  }
}