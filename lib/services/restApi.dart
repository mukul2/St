import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/utils/appConst.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:connect/models/CloudSignUpResponse.dart';
import 'package:connect/models/tenantproject.dart';
import 'package:connect/models/todo.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:connect/services/auth.dart';
import 'package:connect/services/config.dart';
class Api {
  final FirebaseFirestore firestore;
  String cloudRestApiBase = "https://us-central1-staht-connect-322113.cloudfunctions.net/";
  Api({required this.firestore});


  Future<void> sendEmailVerification({required String link,required String email}) async {

    var url = cloudRestApiBase + 'sendVerificationEmailOnly';
    final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "OTPcode": link,
        "targetEmail": email
      }),);
    print(response.body);
    return;


  }
  Future<String> createTenant({required String email,required FirebaseAuth auth,required String projectName, required String projectID,required String password}) async {

    bool response=  await Auth(auth: auth).createAccountBool(email:email,password: password );
    if(response){
      String uid  = FirebaseAuth.instance.currentUser!.uid;
      firestore.collection("tenants").doc(uid).set({"email":email,"projectName":projectName,"projectID":projectID});

      var url = 'https://us-central1-staht-d03a3.cloudfunctions.net/createprojectonly';
      final http.Response response = await http.post(Uri.parse(url),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',},
        body: jsonEncode(<String, String> {   "project_id":projectID, "project_title":projectName}),);

      print(response.body);


      firestore.collection("tenants").doc(uid).update({"responseFromGC":response.body});
      CloudSignup cloudSignup = CloudSignup.fromJson(convert.jsonDecode(response.body));
      if(cloudSignup!=null){
        firestore.collection("tenants").doc(uid).update({"isGCPCreated":true});
        firestore.collection("tenants").doc(uid).update({"isFirebaseCreated":false});
        firestore.collection("tenants").doc(uid).update({"isFirestoreCreated":false});
        return uid;
      }else {
        firestore.collection("tenants").doc(uid).update({"isGCPCreated":false});
        firestore.collection("tenants").doc(uid).update({"isFirebaseCreated":false});
        firestore.collection("tenants").doc(uid).update({"isFirestoreCreated":false});

        return "";
      }




    }else{
      return "";
      print("Failed to signup");
    }



  }
  Future<String> addFirebase({ required String uid,required String projectID}) async {




    //  firestore.collection("tenants").doc(uid).set({"email":email,"projectName":projectName,"projectID":projectID});

    try {
      var url = 'https://us-central1-staht-d03a3.cloudfunctions.net/addfirebase';
      final http.Response response = await http.post(Uri.parse(url),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',},
        body: jsonEncode(<String, String> {   "project_id":projectID,}),);

      print(response.body);

      firestore.collection("tenants").doc(uid).update({"responseFromGC":response.body});
      CloudSignup cloudSignup = CloudSignup.fromJson(convert.jsonDecode(response.body));
      if(cloudSignup!=null){
        firestore.collection("tenants").doc(uid).update({"isGCPCreated":true});
        firestore.collection("tenants").doc(uid).update({"isFirebaseCreated":true});
        firestore.collection("tenants").doc(uid).update({"isFirestoreCreated":false});
        return uid;
      }else {
        firestore.collection("tenants").doc(uid).update({"isGCPCreated":false});
        firestore.collection("tenants").doc(uid).update({"isFirebaseCreated":false});
        firestore.collection("tenants").doc(uid).update({"isFirestoreCreated":false});

        return "";
      }

      if (response.statusCode == 200) {

        return json.decode(response.body);
      } else {
        throw Exception('Failed to load album');
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
  Future<String> addfirestore({ String? uid, String? projectID,required String region}) async {

    //  String uid  = FirebaseAuth.instance.currentUser.uid;
    //  firestore.collection("tenants").doc(uid).set({"email":email,"projectName":projectName,"projectID":projectID});
    try {
      var body = jsonEncode(<String, String?>{ "project_id": projectID,"region":region});
      var url = cloudRestApiBase + 'addfirestore';
      final http.Response response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body,);
      print(body);

      print(response.body);
      return response.body;


      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to load album');
      }
    } catch (e) {
      print(e.toString());
      return "";
    }
  }
  // Future<String> addfirestore({  required String uid,required String projectID}) async {
  //
  //
  //
  //   //  String uid  = FirebaseAuth.instance.currentUser.uid;
  //   //  firestore.collection("tenants").doc(uid).set({"email":email,"projectName":projectName,"projectID":projectID});
  //
  //   try {
  //     var url = 'https://us-central1-staht-d03a3.cloudfunctions.net/addfirestore';
  //     final http.Response response = await http.post(Uri.parse(url),
  //       headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',},
  //       body: jsonEncode(<String, String> {   "project_id":projectID,}),);
  //
  //     print(response.body);
  //
  //     firestore.collection("tenants").doc(uid).update({"responseFromGC":response.body});
  //     CloudSignup cloudSignup = CloudSignup.fromJson(convert.jsonDecode(response.body));
  //     if(cloudSignup!=null){
  //       firestore.collection("tenants").doc(uid).update({"isGCPCreated":true});
  //       firestore.collection("tenants").doc(uid).update({"isFirebaseCreated":true});
  //       firestore.collection("tenants").doc(uid).update({"isFirestoreCreated":true});
  //       return uid;
  //     }else {
  //       //  firestore.collection("tenants").doc(uid).update({"isGCPCreated":false});
  //       //  firestore.collection("tenants").doc(uid).update({"isFirebaseCreated":false});
  //       //  firestore.collection("tenants").doc(uid).update({"isFirestoreCreated":false});
  //
  //       return "";
  //     }
  //
  //     if (response.statusCode == 200) {
  //
  //       return json.decode(response.body);
  //     } else {
  //       throw Exception('Failed to load album');
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //     rethrow;
  //   }
  // }




  Future<List<TenantProjects>> listofTenants() async {

    List<TenantProjects> listTenant = [];
    try {
      var url = 'https://us-central1-staht-d03a3.cloudfunctions.net/list';

      // Await the http get response, then decode the json-formatted response.


      final http.Response response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },

      );
      //showThisToast(response.statusCode.toString());
      if (response.statusCode == 200) {
        List all = json.decode(response.body);

        if(all.length>0){

          for (int i = 0; i < all.length; i++) {
            listTenant.add(TenantProjects.fromJson(all[i]));
          }
        }
        return  listTenant;
      } else {
        throw Exception('Failed to load album');
      }
    } catch (e) {
      rethrow;
    }
  }
  Future<String> addfirestoreRules({ required String projectID}) async {



    //  String uid  = FirebaseAuth.instance.currentUser.uid;
    //  firestore.collection("tenants").doc(uid).set({"email":email,"projectName":projectName,"projectID":projectID});

    try {
      var url = cloudRestApiBase+'addrules';
      final http.Response response = await http.post(Uri.parse(url),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',},
        body: jsonEncode(<String, String> {   "project_id":projectID,}),);

      print(response.body);



      if (response.statusCode == 200) {

        return response.body;
      } else {
        throw Exception('Failed to load album');
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<List<QueryDocumentSnapshot>> fetchCustomerUsersAllTestRecord(
      {required String projectId, required String uid}) async {
    Future<List<QueryDocumentSnapshot>> getData(
        FirebaseFirestore firestore) async {
      QuerySnapshot querySnapshot = await firestore
          .collection("pulltest")
          .where("uid", isEqualTo: uid)
          .get();

      return querySnapshot.docs;
    }

    try {
      FirebaseApp app = await Firebase.initializeApp(
          name: projectId,
          options: FirebaseOptions(
            appId: Platform.isAndroid
                ?Config().defaultAppIdAndroid
                : Config().defaultAppIdIOS,
            apiKey: Config().apiKey,
            messagingSenderId: '',
            projectId: projectId,
          ));
      FirebaseFirestore customerFirestore =
      FirebaseFirestore.instanceFor(app: app);
      List<QueryDocumentSnapshot> data = await getData(customerFirestore);
      return data;
    } catch (e) {
      FirebaseFirestore customerFirestore =
      FirebaseFirestore.instanceFor(app: Firebase.app(projectId));

      List<QueryDocumentSnapshot> data = await getData(customerFirestore);

      return data;
    }
  }

  Stream<QuerySnapshot> fetchCustomerUsersAllTestRecordWithFirestore(
      {required FirebaseFirestore firestore, required String uid})  {
    Stream<QuerySnapshot> getData(
        FirebaseFirestore firestore)  {

      if(shareAbleWithOtherMembers == false)
      return firestore
          .collection("pulltest")
          .where("uid", isEqualTo: uid).snapshots();
      else{
        return firestore
            .collection("pulltest")
            .snapshots();
      }
    }

    try {
      return getData(firestore);

    //  List<QueryDocumentSnapshot> data = await getData(firestore);
     // return data;
    } catch (e) {

      return getData(firestore);
     // List<QueryDocumentSnapshot> data = await getData(firestore);

     // return data;
    }
  }


  Stream<DocumentSnapshot> fetchOnerecordWithFirestore(
      {required FirebaseFirestore firestore, required String id})  {
    Stream<DocumentSnapshot> getData(
        FirebaseFirestore firestore)  {
      Stream<DocumentSnapshot> stream =  firestore
          .collection("pulltest")
          .doc(id).snapshots();

      return stream;
    }

    try {

      Stream<DocumentSnapshot> data =  getData(firestore);
      return data;
    } catch (e) {


      Stream<DocumentSnapshot> data =  getData(firestore);

      return data;
    }
  }

}

