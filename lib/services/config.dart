
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
String defaultProjectID = "staht-connect-322113";


class Config {

  String get defaultAppIdAndroid => "1:1062957635061:android:05149744d12ebeac7d3cbc";
  String get defaultAppIdIOS => "1:1062957635061:ios:a733debb193611297d3cbc";
  String get apiKey => "AIzaSyCV3hA7vU_z68oisONUq0djzojMLaeqWfo";
  String get projectId => "staht-connect-322113";
  Config();


  String get defaultAppId => "1:1062957635061:web:ae189f34def46aa57d3cbc";
  String get webURL => "https://app.staht.com/#";



}
