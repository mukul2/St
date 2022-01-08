import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connect/pages/graph_3.dart';
import 'package:connect/services/restApi.dart';

void showTestresultModal(
    BuildContext context, String wid, FirebaseFirestore firestore) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<DocumentSnapshot>(
              stream: Api(firestore: firestore)
                  .fetchOnerecordWithFirestore(firestore: firestore, id: wid),
              builder: (c, snapshot) {
                if (snapshot.hasData) {
                  return  Container(
                    height: 200,

                    width: MediaQuery.of(context).size.width,
                    child: DefaultPanning2( jsonDecode(snapshot.data!.get("data")),snapshot.data!.get("targetLoad"),snapshot.data!.get("max"),snapshot.data!.get("startedLoad"),snapshot.data!.get("endedLoad")),
                  );
                } else {
                  return Text("No Data");
                }
              }),
        );
      });
}



Widget timeFormate(dynamic time){
  return Text(DateFormat('hh:mm aa MMM dd').format(
      DateTime.fromMillisecondsSinceEpoch(time)),style: TextStyle(color: Colors.grey),);
}
Future<List<QueryDocumentSnapshot>> fetchCustomerUsersAllAttachment(
    {required FirebaseFirestore firestore, required String testID}) async {
  Future<List<QueryDocumentSnapshot>> getData(
      FirebaseFirestore firestore) async {
    QuerySnapshot querySnapshot = await firestore
        .collection("pulltest")
        .doc(testID)
        .collection("attachments")
        .get();

    return querySnapshot.docs;
  }

  try {

    List<QueryDocumentSnapshot> data = await getData(firestore);
    return data;
  } catch (e) {


    List<QueryDocumentSnapshot> data = await getData(firestore);

    return data;
  }
}


