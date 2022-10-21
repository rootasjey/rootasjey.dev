import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rootasjey/globals/utilities/language_utilities.dart';
import 'package:rootasjey/globals/utilities/ui_utilities.dart';
import 'package:rootasjey/types/credentials.dart';
import 'package:rootasjey/types/user/user_firestore.dart';
import 'package:rootasjey/utils/date_utilities.dart';
import 'package:rootasjey/utils/fonts.dart';
import 'package:rootasjey/utils/navigation_utilities.dart';
import 'package:rootasjey/utils/size_utilities.dart';
import 'package:rootasjey/utils/storage_utils.dart';

class Utilities {
  static const date = DateUtilities();
  static const fonts = FontsUtils();
  static const size = SizeUtils();
  static const navigation = NavigationUtilities();
  static const ui = UIUtilities();
  static const lang = LanguageUtilities();

  static String getStringWithUnit(int usedBytes) {
    if (usedBytes < 1000) {
      return '$usedBytes bytes';
    }

    if (usedBytes < 1000000) {
      return '${usedBytes / 1000} KB';
    }

    if (usedBytes < 1000000000) {
      return '${usedBytes / 1000000} MB';
    }

    if (usedBytes < 1000000000000) {
      return '${usedBytes / 1000000000} GB';
    }

    if (usedBytes < 1000000000000000) {
      return '${usedBytes / 1000000000000} TB';
    }

    return '${usedBytes / 1000000000000000} PB';
  }

  static Future<User?> getFireAuthUser() async {
    final Credentials credentials = await StorageUtils.getCredentials();

    final String email = credentials.email;
    final String password = credentials.password;

    if (email.isEmpty || password.isEmpty) {
      return Future.value(null);
    }

    final firebaseAuthInstance = FirebaseAuth.instance;
    final authResult = await firebaseAuthInstance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return authResult.user;
  }

  static Future<UserFirestore?> getFirestoreUser(String userId) async {
    final docSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    final data = docSnapshot.data();
    if (!docSnapshot.exists || data == null) {
      return null;
    }

    data["id"] = docSnapshot.id;
    return UserFirestore.fromMap(data);
  }
}
