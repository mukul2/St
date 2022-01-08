import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum LoginStatus { unknown, loggedIn,  loggedOut ,loginProcessing}

class UserAuthStream {
  static UserAuthStream model= new UserAuthStream() ;
  final StreamController<LoginStatus> _Controller = StreamController<LoginStatus>.broadcast();
  Stream<LoginStatus> get onAuthChanged => _Controller.stream;
  Sink<LoginStatus> get inData => _Controller.sink;

  dataReload() {getData().then((value) => inData.add(value));}

  void dispose() {_Controller.close();}
  static UserAuthStream getInstance() {

    if (model == null) {
      model = new UserAuthStream();
      model.dataReload();
      return model;
    } else {
      return model;
    }
  }
  static UserAuthStream getInstanceNoCheck() {

    if (model == null) {
      model = new UserAuthStream();
      model.dataReload();
      return model;
    } else {
      return model;
    }
  }
  void signOut()async{
    FirebaseAuth.instance.signOut();
    inData.add(LoginStatus.loggedOut);
  }

  void loginFailed()async{
    inData.add(LoginStatus.loggedOut);
  }
  void signIn()async{
    print("Logged in triggered");
    inData.add(LoginStatus.loggedIn);

  }
  void loginProcessing(){
    print("trying to process");
    inData.add(LoginStatus.loginProcessing);

  }


  Future<LoginStatus>  getData() async {



//FirebaseAuth.instance.currentUser==null

    if(FirebaseAuth.instance.currentUser==null){
      print("I really returned "+LoginStatus.loggedOut.toString());
      inData.add(LoginStatus.loggedOut);
      return LoginStatus.loggedOut;

    }else {
      print("I really returned "+LoginStatus.loggedIn.toString());
      inData.add(LoginStatus.loggedIn);
      return LoginStatus.loggedIn;
    }

  }
}






