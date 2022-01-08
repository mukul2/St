import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:connect/functions/firebaseInitialize.dart';
import 'package:connect/screens/root.dart';

class InitialCheckups extends StatelessWidget {
  const InitialCheckups({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      //  future: Firebase.initializeApp(),
      future: customInitialize(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text("Error"),
            ),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          //  FirebaseFirestore.instance.collection("9feb").add({"data":"data7"});

          print(Firebase.apps.asMap().toString());
          List<FirebaseApp> apps = Firebase.apps;
          return Root();

        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const Scaffold(
          body: Center(
            child: Text("Loading..."),
          ),
        );
      },
    );
  }
}