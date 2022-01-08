import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/Activities/TestViewPage/testReview.dart';
import 'package:connect/utils/appConst.dart';
import 'package:connect/widgets/appwidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'SearchRecords/SearchRecords.dart';

class HomePageLogics{
  FirebaseFirestore? firestore;
  FirebaseAuth? auth;
  BuildContext? context;
  Locale? locale;
  String? customerId;
  HomePageLogics({ this.firestore, this.auth,this.context,this.locale,this.customerId});
  Stream<QuerySnapshot> fetchCustomerUsersLastSixTestRecordWithFirestore(
      )  {
    Stream<QuerySnapshot> getData(
        FirebaseFirestore firestore)  {

      if(shareAbleWithOtherMembers == false)
      return firestore
          .collection("pulltest")
      //.orderBy("time",descending: true)
          .where("uid", isEqualTo: auth!.currentUser!.uid)
      // .limit(6)
          .snapshots();
      else{
        return firestore
            .collection("pulltest")
        //.orderBy("time",descending: true)
          //  .where("uid", isEqualTo: auth!.currentUser!.uid)
        // .limit(6)
            .snapshots();
      }
    }
    try {
      return getData(firestore!);
    } catch (e) {
      return getData(firestore!);
    }
  }

  Query<Map<String,dynamic>> fetchCustomerUsersLastSixTestRecordWithFirestoreQuery(
      )  {
    Query<Map<String,dynamic>> getData(
        FirebaseFirestore firestore)  {

      if(shareAbleWithOtherMembers == false)
        return firestore
            .collection("pulltest")
        .orderBy("time",descending: true)
            .where("uid", isEqualTo: auth!.currentUser!.uid);
        // .limit(6)

      else{
        return firestore
            .collection("pulltest")
            .orderBy("time",descending: true)
        //  .where("uid", isEqualTo: auth!.currentUser!.uid)
        // .limit(6)
        ;
      }
    }
    try {
      return getData(firestore!);
    } catch (e) {
      return getData(firestore!);
    }
  }
  Future<QuerySnapshot> fetchCustomerUsersLastSixTestRecordWithFirestoreFuture(
      )  {
    Future<QuerySnapshot> getData(
        FirebaseFirestore firestore)  {

      if(shareAbleWithOtherMembers == false)
        return firestore
            .collection("pulltest")
        //.orderBy("time",descending: true)
            .where("uid", isEqualTo: auth!.currentUser!.uid)
        // .limit(6)
            .get();
      else{
        return firestore
            .collection("pulltest")
        //.orderBy("time",descending: true)
        //  .where("uid", isEqualTo: auth!.currentUser!.uid)
        // .limit(6)
            .get();
      }
    }
    try {
      return getData(firestore!);
    } catch (e) {
      return getData(firestore!);
    }
  }
  searchPullTestClicked(){
    Navigator.push(
      context!,
      MaterialPageRoute(
          builder: (context) => SearchRecords(
            customerId: auth!.currentUser!.uid,
            customerFirestore: firestore!,locale: locale!,
          )),
    );
  }
 Future<bool> changeUserPhoto({required String base64Data})async{
    try{
      var r1= await  firestore!.collection("users")
          .where("uid",
          isEqualTo: auth!.currentUser==null?"abc":auth!.currentUser!.uid)
          .get();
      await   firestore!
          .collection("users")
          .doc(r1.docs.first.id)
          .update({"photo": base64Data});
      print("photo update done");
      return   true;
    }catch(e){
      print("photo update error");
      print(e);
      return false;
    }

  }
  testRecordClickedEvent({required String id,required int pos,required QueryDocumentSnapshot<Object?> data}){
    //TestReviewScreen
    // Navigator.push(
    //     context!,
    //     MaterialPageRoute(
    //         builder: (context) =>TestReviewScreen()));
    AppWidgets(customerFirestore: firestore!,customerId:customerId! ).showTestRecordBody(id,data,context!,locale!,pos);
  }
  testRecordClickedEventQuery({required String id,required int pos,required Map<String,dynamic> data}){
    //TestReviewScreen
    // Navigator.push(
    //     context!,
    //     MaterialPageRoute(
    //         builder: (context) =>TestReviewScreen()));
    AppWidgets(customerFirestore: firestore!,customerId:customerId! ).showTestRecordBodyByQuery(id,data,context!,locale!,pos);
  }
}