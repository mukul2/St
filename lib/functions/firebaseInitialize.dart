import 'package:firebase_core/firebase_core.dart';

Future<FirebaseApp> customInitialize() {
  return Firebase.initializeApp();
}