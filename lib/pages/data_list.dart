import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:connect/streams/AuthControllerStream.dart';

class DataListPage extends StatefulWidget {
  /// The page title.
  final String title = 'Sign In & Out';

  @override
  _DataListPageState createState() => _DataListPageState();
}


class _DataListPageState extends State<DataListPage> {
  void _logOut(){
    FirebaseAuth.instance.signOut().then((value){
      UserAuthStream.getInstance().signOut();
      Navigator.pop(context);
      Navigator.pop(context);
    });

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Data List"),),


      floatingActionButton: FloatingActionButton.extended(onPressed:_logOut , label: Text("Sign Out")),

       body: StreamBuilder(
           stream: FirebaseFirestore.instance.collection('staht').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
             if(!snapshot.hasData){
               return Center(
                 child: Text("Loading Data"),
               );
             }

             return ListView(
               children: snapshot.data!.docs.map((document) {
                 return ListTile(
                   title: Text(document['title']),
                   subtitle: Text(document['description']),
                 );
               }).toList(),
             );
           }
       )


      ,);


  }


}