import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:loggy/loggy.dart';
import 'package:rootasjey/actions/users.dart';
import 'package:rootasjey/types/alias/json_alias.dart';
import 'package:rootasjey/types/cloud_func_error.dart';
import 'package:rootasjey/types/cloud_function_response.dart';
import 'package:rootasjey/types/create_account_resp.dart';
import 'package:rootasjey/types/credentials.dart';
import 'package:rootasjey/types/user/user.dart';
import 'package:rootasjey/types/user/user_firestore.dart';
import 'package:rootasjey/utils/cloud.dart';
import 'package:rootasjey/utils/storage_utils.dart';

class UserNotifier extends StateNotifier<User> with UiLoggy {
  UserNotifier(User state) : super(state) {
    signInOnAppStart();
  }

  Future<CloudFunctionsResponse> deleteAccount(String idToken) async {
    try {
      final HttpsCallable callable = FirebaseFunctions.instanceFor(
        app: Firebase.app(),
        region: "europe-west3",
      ).httpsCallable("users-deleteAccount");

      final HttpsCallableResult response = await callable.call({
        "idToken": idToken,
      });

      signOut();

      return CloudFunctionsResponse.fromJSON(response.data);
    } on FirebaseFunctionsException catch (exception) {
      loggy.error("[code: ${exception.code}] - ${exception.message}");

      return CloudFunctionsResponse(
        success: false,
        error: CloudFuncError(
          code: exception.details["code"],
          message: exception.details["message"],
        ),
      );
    } catch (error) {
      loggy.error(error.toString());

      return CloudFunctionsResponse(
        success: false,
        error: CloudFuncError(
          code: "",
          message: error.toString(),
        ),
      );
    }
  }

  String getInitialsUsername() {
    if (state.firestoreUser == null) return '';
    if (state.firestoreUser?.name == null) return '';

    final splittedUsernameArray = state.firestoreUser!.name.split(' ');
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

  String getPPUrl({String orElse = ''}) {
    if (state.firestoreUser == null) return orElse;

    final editedURL = state.firestoreUser!.profilePicture.url.edited;
    if (editedURL.isNotEmpty) return editedURL;

    final originalURL = state.firestoreUser!.profilePicture.url.original;
    if (originalURL.isNotEmpty) return originalURL;

    return orElse;
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
    loggy.error(error);
  }

  void _onFirestoreData(DocumentSnapshot<Map<String, dynamic>> docSnap) {
    final Json? userData = docSnap.data();
    if (userData == null) return;

    userData.putIfAbsent("id", () => docSnap.id);
    final firestoreUser = UserFirestore.fromMap(userData);

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
    loggy.error(error);
  }

  Future<firebase_auth.User?> signIn({String? email, String? password}) async {
    try {
      final Credentials credentials = await StorageUtils.getCredentials();

      email = email ?? credentials.email;
      password = password ?? credentials.password;

      final bool emailNullOrEmpty = email.isEmpty;
      final bool passwordNullOrEmpty = password.isEmpty;

      if (emailNullOrEmpty || passwordNullOrEmpty) {
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

      StorageUtils.setCredentials(
        email: email,
        password: password,
      );

      return authResult.user;
    } catch (error) {
      StorageUtils.clearCredentials();
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
      loggy.error(error);
      signOut();
    }
  }

  Future<bool> signOut() async {
    try {
      StorageUtils.clearCredentials();
      await firebase_auth.FirebaseAuth.instance.signOut();
      state = User(authUser: null, firestoreUser: null);
      return true;
    } catch (error) {
      loggy.error(error);
      return false;
    }
  }

  Future<CreateAccountResp> signUp({
    required email,
    required username,
    required password,
  }) async {
    final createAccountResponse = await UsersActions.createAccount(
      email: email,
      username: username,
      password: password,
    );

    if (!createAccountResponse.success) {
      return createAccountResponse;
    }

    final userAuth = await signIn(email: email, password: password);
    createAccountResponse.userAuth = userAuth;
    createAccountResponse.success = userAuth != null;

    return createAccountResponse;
  }

  Future<CloudFunctionsResponse> updateEmail(
      String email, String idToken) async {
    try {
      final response = await Cloud.fun("users-updateEmail").call({
        "newEmail": email,
        "idToken": idToken,
      });

      await signIn(email: email);

      return CloudFunctionsResponse.fromJSON(response.data);
    } catch (error) {
      return CloudFunctionsResponse(
        success: false,
        error: CloudFuncError(
          code: "",
          message: error.toString(),
        ),
      );
    }
  }

  Future<CloudFunctionsResponse> updateUsername(String newUsername) async {
    try {
      final response = await Cloud.fun("users-updateUsername").call({
        "newUsername": newUsername,
      });

      return CloudFunctionsResponse.fromJSON(response.data);
    } catch (error) {
      return CloudFunctionsResponse(
        success: false,
        error: CloudFuncError(
          code: "",
          message: error.toString(),
        ),
      );
    }
  }
}
