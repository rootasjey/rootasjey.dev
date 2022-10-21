import 'package:rootasjey/types/user/user_auth.dart';
import 'package:rootasjey/types/user/user_firestore.dart';

/// This app's user model.
class User {
  User({
    this.authUser,
    this.firestoreUser,
  });

  /// Firebase auth's user.
  final UserAuth? authUser;

  /// Firestor's user.
  final UserFirestore? firestoreUser;
}
