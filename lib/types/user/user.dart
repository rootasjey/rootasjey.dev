import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:rootasjey/types/user_firestore.dart';

/// This app's user model.
class User {
  /// Firebase auth's user.
  final firebase_auth.User? authUser;

  /// Firestor's user.
  final UserFirestore? firestoreUser;

  User({this.authUser, this.firestoreUser});
}
