import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connect/models/SavedData.dart';
import 'package:connect/models/todo.dart';
import 'package:flutter_blue/flutter_blue.dart';

class Database {
  final FirebaseFirestore firestore;


  Database({required this.firestore});

  Stream<List<TodoModel>> streamTodos({required String uid}) {
    try {
      return firestore
          .collection("todos")
          .doc(uid)
          .collection("todos")
          .where("done", isEqualTo: false)
          .snapshots()
          .map((query) {
        final List<TodoModel> retVal = <TodoModel>[];
        for (final DocumentSnapshot doc in query.docs) {
          retVal.add(TodoModel.fromDocumentSnapshot(documentSnapshot: doc));
        }
        return retVal;
      });
    } catch (e) {
      rethrow;
    }
  }//assets/splash_images/staht_org_id
  Stream<List<String>> streamImage() {
    try {
      return firestore
          .collection("assets")
          .doc("splash_images")
          .collection("staht_org_id")

          .snapshots()
          .map((query) {
        final List<String> retVal = <String>[];
        for (final DocumentSnapshot doc in query.docs) {
          retVal.add(doc.get("data"));
        }
        return retVal;
      });
    } catch (e) {
      rethrow;
    }
  }
  Stream<List<mData>> streamTestRecords({required String uid,required String org}) {
    try {
      return firestore
          .collection("testResult")
           .where('uid',isEqualTo: uid)
           .where('org',isEqualTo: org)//org = "Staht "

           .snapshots()
          .map((query) {
        final List<mData> retVal = <mData>[];
        for (final DocumentSnapshot doc in query.docs) {
          retVal.add(mData.fromDocumentSnapshot(documentSnapshot: doc));
        }
        return retVal;
      });
    } catch (e) {
      rethrow;
    }
  }
  Stream<List<OrgModel>> streamOrgList() {
    try {
      return firestore
          .collection("root")


          .snapshots()
          .map((query) {
        final List<OrgModel> retVal = <OrgModel>[];
        for (final DocumentSnapshot doc in query.docs) {
          retVal.add(OrgModel.fromDocumentSnapshot(documentSnapshot: doc));
        }
        return retVal;
      });
    } catch (e) {
      rethrow;
    }
  }
  Stream<UserTypeDetectorModel> streamOwnUserType({required String uid}) {
    try {
      return firestore
          .collection("users")
          .where('value',isEqualTo: uid)


          .snapshots()
          .map((query) {
        final List<UserTypeDetectorModel> retVal = <UserTypeDetectorModel>[];
        for (final DocumentSnapshot doc in query.docs) {
          retVal.add(UserTypeDetectorModel.fromDocumentSnapshot(documentSnapshot: query));
        }
        print(retVal[0].userType);
        return retVal[0];
      });
    } catch (e) {
      rethrow;
    }
  }
  Stream<List<UserModel>> streamUserList({required String orgID}) {
    try {
      return firestore
          .collection("root")
          .doc(orgID)
          .collection("users")


          .snapshots()
          .map((query) {
        final List<UserModel> retVal = <UserModel>[];
        for (final DocumentSnapshot doc in query.docs) {
          retVal.add(UserModel.fromDocumentSnapshot(documentSnapshot: doc));
        }

        print("users found");
        print(retVal.length.toString());

        return retVal;
      });
    } catch (e) {
      rethrow;
    }
  }
//DocumentSnapshot
  Stream<QuerySnapshot>   streamBTDevices2()  {
   try {
     return firestore
         .collection("staht").snapshots();
   } catch (e) {
     rethrow;
   }
  }



  /*
  String streamBTDevices() {
    try {
     return "Very Good";
    } catch (e) {
      rethrow;
    }
  }

   */

  Future<void> addTodo({required String uid, required String content}) async {
    try {
      firestore.collection("todos").doc(uid).collection("todos").add({
        "content": content,
        "done": false,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addDevices({required String uid, required String content}) async {
    try {
      firestore.collection("todos").doc(uid).collection("todos").add({
        "content": content,
        "done": false,
      });
    } catch (e) {
      rethrow;
    }
  }


  void addData(List<ScanResult> data) async {
    final databaseReference = FirebaseFirestore.instance;

    for (ScanResult result in data) {
      await databaseReference.collection('staht').doc(result.device.id.id).set({
        'title': result.device.name,
        'description': result.toString()
      }).whenComplete(() {
        print("updated now ");
      });
    }

  }

  void addTestData({required String uid,required List<String> data}) async {
    final databaseReference = FirebaseFirestore.instance;

    String timeKey = DateTime.now().toString();

    await databaseReference.collection('testResult').add({
        'value': data.toString(),
      'uid':uid

      });
    // await databaseReference.collection('testResult').doc(timeKey).set({
    //   'value': data.toString()
    //
    // });

    for (String result in data) {

    }

  }


}
