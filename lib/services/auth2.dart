import 'package:firebase_auth/firebase_auth.dart';

class Auth2 {
  final FirebaseAuth auth;

  Auth2({required this.auth});

  Stream<User?> get user => auth.authStateChanges();

  Future<String> createAccount({required String email, required String password}) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return "Success";
    } on FirebaseAuthException catch (e) {
      return "";
    } catch (e) {
      rethrow;
    }
  }

  Future<String> signIn({required String email, required String password}) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return "Success";
    } on FirebaseAuthException catch (e) {
      return "";
    } catch (e) {
      rethrow;
    }
  }

  Future<String> signOut() async {
    try {
      await auth.signOut();
      return "Success";
    } on FirebaseAuthException catch (e) {
      return "";
    } catch (e) {
      rethrow;
    }
  }
}