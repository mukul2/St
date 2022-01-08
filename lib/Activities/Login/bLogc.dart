

import 'package:connect/services/auth.dart';
import 'package:connect/streams/buttonStreams.dart';
import 'package:connect/utils/themeManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class LoginBloc {
  FirebaseAuth auth;
  BuildContext context;

  LoginBloc({required this.auth,required this.context});
  Future<bool> loginUser({required String email,required String password})async{
    final String retVal = await Auth(auth:auth).signIn(
      email: email,
      password:password,
    );
    if (retVal == "Success") {
      UserLoggedInStream.getInstance().dataReload(true);
      await Future.delayed(Duration(seconds: 1));
      UserLoggedInStream.getInstance().dataReload(true);
      return true;

      print("tenant printing");
      //MyTanentOne-6qazh
      // FirebaseAuth.instance.currentUser. ="MyTanentOne-6qazh" ;
      print("tenant printing end ");
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Login Failed",style: TextStyle(color: ThemeManager().getWhiteColor,fontWeight: FontWeight.bold),),
        ),
      );
      return false;
    }

  }



}