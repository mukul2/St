import 'package:cloud_firestore/cloud_firestore.dart';

class mData {
  late  String todoId ;
  late String value ;
 // String title;



  mData({
    required this.todoId,
    required this.value,

  });

  mData.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    todoId = documentSnapshot.id;
    value = documentSnapshot.get('value') as String;
    //title = documentSnapshot.data()['title'] as String;
  }
}
