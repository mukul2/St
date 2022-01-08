import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'database.dart';

class Auth {
   FirebaseAuth auth;

  Auth({required this.auth});

  Stream<User?> get user => auth.authStateChanges();
  Future<bool> createAccountBool({required String email, required String password}) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      return true;
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      return false;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }



  Future<String> signIn({required String email,required String password}) async {
    print("1");
    try {
      var u = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      print("2");
      print("inside func");
      //print(u.user.uid);
      return "Success";
    } on FirebaseAuthException catch (e) {
      print("3");
      print(e);
      return "";
    } catch (e) {
      print(e);
      rethrow;
    }
  }





  Future<String> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return "Success";
    } on FirebaseAuthException catch (e) {
      return "";
    } catch (e) {
      rethrow;
    }
  }

}