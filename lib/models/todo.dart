import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
 late String todoId;
 late String content;
 late bool done;

  TodoModel({
    required this.todoId,
    required this.content,
    required this.done,
  });

  TodoModel.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    todoId = documentSnapshot.id;
    content = documentSnapshot.get('content') as String;
    done = documentSnapshot.get('done') as bool;
  }
}
class DataModel {
  late String title;
  late String description;


  DataModel({
    required  this.title,
    required this.description,

  });

  DataModel.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {

    description = documentSnapshot.get('description') as String;
    title = documentSnapshot.get('title') as String;
  }
}
class UserTypeDetectorModel {
  late String userType;
  late String value;


  UserTypeDetectorModel({
    required this.userType,
    required  this.value,

  });

  UserTypeDetectorModel.fromDocumentSnapshot({required QuerySnapshot documentSnapshot}) {


    userType = documentSnapshot.docs[0].get('userType') as String;
    value = documentSnapshot.docs[0].get('value') as String;
  }
}

class OrgModel {
 late String orgName;
 late String uid;



  OrgModel({
    required this.orgName,
    required  this.uid,


  });

  OrgModel.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {

    uid = documentSnapshot.id;
    orgName = documentSnapshot.get('orgName') as String;

  }
}
class UserModel {
  late String email;
  late String uid;



  UserModel({
    required this.email,
    required this.uid,


  });

  UserModel.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {

    uid = documentSnapshot.id;
    email = documentSnapshot.get('email') as String;

  }
}


