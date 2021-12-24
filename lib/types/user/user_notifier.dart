import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:rootasjey/types/cloud_func_error.dart';
import 'package:rootasjey/types/user/user.dart';
import 'package:rootasjey/types/update_email_resp.dart';
import 'package:rootasjey/types/user_firestore.dart';
import 'package:rootasjey/utils/app_logger.dart';
import 'package:rootasjey/utils/app_storage.dart';
import 'package:rootasjey/utils/cloud.dart';

class UserNotifier extends StateNotifier<User> {
  UserNotifier(User state) : super(state) {
    signInOnAppStart();
  }

  String getInitialsUsername() {
    if (state.firestoreUser == null) return '';
    if (state.firestoreUser!.name == null) return '';

    final splittedUsernameArray = state.firestoreUser!.name!.split(' ');
    if (splittedUsernameArray.isEmpty) return '';

    String initials = splittedUsernameArray.length > 1
        ? splittedUsernameArray.reduce(
            (prevValue, currValue) => prevValue + currValue.substring(1))
        : splittedUsernameArray.first;

    if (initials.isNotEmpty) {
      initials = initials.substring(0, 1);
    }

    return initials;
  }

  String getPPUrl() {
    if (state.firestoreUser == null) return '';

    final editedURL = state.firestoreUser!.pp?.url?.edited;
    if (editedURL != null) return editedURL;

    final originalURL = state.firestoreUser!.pp?.url?.original;
    if (originalURL != null) return originalURL;

    return '';
  }

  /// Return true if an user is currently authenticated.
  bool get isAuthenticated =>
      state.authUser != null && state.firestoreUser != null;

  void _listenToAuthChanges() {
    final firebaseAuthInstance = firebase_auth.FirebaseAuth.instance;

    firebaseAuthInstance.userChanges().listen(
          _onAuthData,
          onError: _onAuthError,
          onDone: _onAuthDone,
        );
  }

  void _listenToFirestoreChanges() async {
    if (state.authUser == null) {
      return;
    }

    FirebaseFirestore.instance
        .collection('users')
        .doc(state.authUser!.uid)
        .snapshots()
        .listen(
          _onFirestoreData,
          onError: _onFirestoreError,
          onDone: _onFirestoreDone,
        );
  }

  void _onAuthData(firebase_auth.User? userEvent) {
    state = User(
      authUser: userEvent,
      firestoreUser: state.firestoreUser,
    );
  }

  void _onAuthDone() {
    state = User(
      authUser: null,
      firestoreUser: state.firestoreUser,
    );
  }

  void _onAuthError(error) {
    appLogger.e(error);
  }

  void _onFirestoreData(DocumentSnapshot<Map<String, dynamic>> docSnap) {
    final userData = docSnap.data();
    if (userData == null) return;

    userData.putIfAbsent('id', () => docSnap.id);
    final firestoreUser = UserFirestore.fromJSON(userData);

    state = User(
      authUser: state.authUser,
      firestoreUser: firestoreUser,
    );
  }

  void _onFirestoreDone() {
    state = User(
      authUser: state.authUser,
      firestoreUser: null,
    );
  }

  void _onFirestoreError(error) {
    appLogger.e(error);
  }

  Future<firebase_auth.User?> signIn({String? email, String? password}) async {
    try {
      final credentialsMap = appStorage.getCredentials();

      email = email ?? credentialsMap['email'];
      password = password ?? credentialsMap['password'];

      final bool emailNullOrEmpty = email == null || email.isEmpty;
      final bool passwordNullOrEmpty = password == null || password.isEmpty;

      if (emailNullOrEmpty || passwordNullOrEmpty) {
        appLogger.d("user_notifier empty cred");
        return null;
      }

      final firebaseAuthInstance = firebase_auth.FirebaseAuth.instance;
      final authResult = await firebaseAuthInstance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      state = User(authUser: authResult.user);

      _listenToAuthChanges();
      _listenToFirestoreChanges();

      appStorage.setCredentials(
        email: email,
        password: password,
      );

      return authResult.user;
    } catch (error) {
      appStorage.clearUserAuthData();
      return null;
    }
  }

  /// Automatically sign in the user with the last saved credentials.
  Future<void> signInOnAppStart() async {
    try {
      final userCred = await signIn();

      if (userCred == null) {
        signOut();
      }
    } catch (error) {
      appLogger.e(error);
      signOut();
    }
  }

  Future<bool> signOut() async {
    try {
      await appStorage.clearUserAuthData();
      await firebase_auth.FirebaseAuth.instance.signOut();
      return true;
    } catch (error) {
      appLogger.e(error);
      return false;
    }
  }

  Future<UpdateEmailResp> updateEmail(String email, String idToken) async {
    try {
      final response = await Cloud.fun('users-updateEmail').call({
        'newEmail': email,
        'idToken': idToken,
      });

      await signIn(email: email);

      return UpdateEmailResp.fromJSON(response.data);
    } catch (error) {
      return UpdateEmailResp(
        success: false,
        error: CloudFuncError(
          code: '',
          message: error.toString(),
        ),
      );
    }
  }

  Future<UpdateEmailResp> updateUsername(String newUsername) async {
    try {
      final response = await Cloud.fun('users-updateUsername').call({
        'newUsername': newUsername,
      });

      return UpdateEmailResp.fromJSON(response.data);
    } catch (error) {
      return UpdateEmailResp(
        success: false,
        error: CloudFuncError(
          code: '',
          message: error.toString(),
        ),
      );
    }
  }
}
