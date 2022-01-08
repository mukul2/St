import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
String defaultProjectID = "stath-16a50";

enum ROLES  { ROLE_STATH_ADMIN,ROLE_TENANT_ADMIN,ROLE_CUSTOMER_ADMIN,ROLE_CUSTOMER_USER,ROLE_CALIBRATOR}
class RoleManager {
  String get STAHT_ADMIN_ROLE_ID => "llNVXkt2ovem9ZpigbUX";
  String get TENANT_ADMIN_ROLE_ID => "nro6MpTZ9zAJDruA5Dnq";
  String get CUSTOMER_ADMIN_ROLE_ID => "H38fHkExO359mv895NOV";
  String get CUSTOMER_USER_ROLE_ID => "PK6YqWnM45Vr0NFIfEBu";
  String get CALIBRATOR_ROLE_ID => "Co3eHObxFAeEA6NRR6y2";
  int ROLE_STATH_ADMIN = 0;
  int ROLE_TENANT_ADMIN = 1;
  int ROLE_CUSTOMER_ADMIN = 2;
  int ROLE_CUSTOMER_USER = 3;
  int ROLE_CALIBRATOR = 4;

  final String  rolId;

  RoleManager({required this.rolId});



  int getPermsionLevel()  {
    switch(rolId){
      case "llNVXkt2ovem9ZpigbUX":
        return ROLE_STATH_ADMIN;
        break;
      case "nro6MpTZ9zAJDruA5Dnq":
        return ROLE_TENANT_ADMIN;
        break;
      case "H38fHkExO359mv895NOV":
        return ROLE_CUSTOMER_ADMIN;
        break;
      case "PK6YqWnM45Vr0NFIfEBu":
        return ROLE_CUSTOMER_USER;
        break;
      case "Co3eHObxFAeEA6NRR6y2":
        return ROLE_CALIBRATOR;
        break;
      default:
        return 0;
    }

  }




}
