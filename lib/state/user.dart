import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';
import 'package:rootasjey/router/locations/home_location.dart';
import 'package:rootasjey/types/cloud_func_error.dart';
import 'package:rootasjey/types/update_email_resp.dart';
import 'package:rootasjey/types/user_firestore.dart';
import 'package:rootasjey/utils/app_logger.dart';
import 'package:rootasjey/utils/app_storage.dart';

part 'user.g.dart';

class StateUser = StateUserBase with _$StateUser;

abstract class StateUserBase with Store {
  User _userAuth;

  @observable
  UserFirestore userFirestore;

  @observable
  String avatarUrl = '';

  @observable
  bool canManageData = false;

  @observable
  String email = '';

  @observable
  String lang = 'en';

  @observable
  bool isFirstLaunch = false;

  @observable
  bool isUserConnected = false;

  @observable
  String username = '';

  /// Used to sync fav. status between views,
  /// e.g. re-fetch on nav. back from quote page -> quotes list.
  /// _NOTE: Should be set to false after status sync (usually on quotes list)_.
  bool mustUpdateFav = false;

  /// Last time the favourites has been updated.
  @observable
  DateTime updatedFavAt = DateTime.now();

  User get userAuth {
    return _userAuth;
  }

  /// Use on sign out / user's data has changed.
  void clearAuthCache() {
    _userAuth = null;
  }

  Future<UpdateEmailResp> deleteAccount(String idToken) async {
    try {
      final callable = FirebaseFunctions.instanceFor(
        app: Firebase.app(),
        region: 'europe-west3',
      ).httpsCallable('users-deleteAccount');

      final response = await callable.call({
        'idToken': idToken,
      });

      signOut();

      return UpdateEmailResp.fromJSON(response.data);
    } on FirebaseFunctionsException catch (exception) {
      appLogger.e("[code: ${exception.code}] - ${exception.message}");

      return UpdateEmailResp(
        success: false,
        error: CloudFuncError(
          code: exception.details['code'],
          message: exception.details['message'],
        ),
      );
    } on PlatformException catch (exception) {
      appLogger.e(exception.toString());

      return UpdateEmailResp(
        success: false,
        error: CloudFuncError(
          code: exception.details['code'],
          message: exception.details['message'],
        ),
      );
    } catch (error) {
      appLogger.e(error.toString());

      return UpdateEmailResp(
        success: false,
        error: CloudFuncError(
          code: '',
          message: error.toString(),
        ),
      );
    }
  }

  Future refreshUserRights() async {
    try {
      if (_userAuth == null || _userAuth.uid == null) {
        setAllRightsToFalse();
        return;
      }

      final userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(_userAuth.uid)
          .get();

      final userData = userSnap.data();

      if (!userSnap.exists || userData == null) {
        setAllRightsToFalse();
      }

      userFirestore = UserFirestore.fromJSON(userData);
      setUsername(userData['name']);
    } on FirebaseFunctionsException catch (exception) {
      appLogger.e("[code: ${exception.code}] - ${exception.message}");
      setAllRightsToFalse();
    } catch (error) {
      appLogger.e(error.toString());
      setAllRightsToFalse();
    }
  }

  /// Signin user with credentials if FirebaseAuth is null.
  Future<User> signin({String email, String password}) async {
    try {
      final credentialsMap = appStorage.getCredentials();

      email = email ?? credentialsMap['email'];
      password = password ?? credentialsMap['password'];

      if ((email == null || email.isEmpty) ||
          (password == null || password.isEmpty)) {
        return null;
      }

      final auth = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _userAuth = auth.user;
      setUserConnected();

      appStorage.setCredentials(
        email: email,
        password: password,
      );

      appStorage.setUserName(_userAuth.displayName);
      // PushNotifications.linkAuthUser(_userAuth.uid);
      setEmail(email);

      await refreshUserRights();
      startRealTimeAuthUpdates();
      startRealTimeUserUpdates();

      return _userAuth;
    } catch (error) {
      appStorage.clearUserAuthData();
      return null;
    }
  }

  void startRealTimeAuthUpdates() {
    FirebaseAuth.instance.userChanges().listen((userEvent) {
      _userAuth = userEvent;
      refreshUserRights();
    }, onError: (error) {
      appLogger.e(error);
    }, onDone: () {
      _userAuth = null;
    });
  }

  void startRealTimeUserUpdates() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(_userAuth.uid)
        .snapshots()
        .listen((docSnap) {
      setUserData(docSnap);
    }, onError: (error) {
      appLogger.e(error);
    });
  }

  // ACTIONS
  // -------

  @action
  void setAvatarUrl(String url) {
    avatarUrl = url;
  }

  @action
  void setFirstLaunch(bool value) {
    isFirstLaunch = value;
  }

  @action
  void setLang(String newLang) {
    lang = newLang;
  }

  @action
  void setUserConnected() {
    isUserConnected = true;
  }

  @action
  void setUserDisconnected() {
    isUserConnected = false;
  }

  @action
  void setUsername(String name) {
    username = name;
  }

  @action
  void setAllRightsToFalse() {
    canManageData = false;
  }

  @action
  void setEmail(String value) {
    email = value;
  }

  @action
  void setUserData(DocumentSnapshot<Map<String, dynamic>> docSnap) {
    userFirestore = UserFirestore.fromJSON(docSnap.data());
  }

  @action
  Future signOut({
    BuildContext context,
    bool redirectOnComplete = false,
  }) async {
    _userAuth = null;
    await appStorage.clearUserAuthData();
    await FirebaseAuth.instance.signOut();
    setUserDisconnected();

    // PushNotifications.unlinkAuthUser();

    if (redirectOnComplete) {
      if (context == null) {
        appLogger.e("Please specify a context value to the"
            " [userState.signOut] function.");
        return;
      }

      Beamer.of(context).beamToNamed(HomeLocation.route);
    }
  }

  @action
  void updateFavDate() {
    updatedFavAt = DateTime.now();
  }

  Future<UpdateEmailResp> updateEmail(String email, String idToken) async {
    try {
      final callable = FirebaseFunctions.instanceFor(
        app: Firebase.app(),
        region: 'europe-west3',
      ).httpsCallable('users-updateEmail');

      final response = await callable.call({
        'newEmail': email,
        'idToken': idToken,
      });

      appStorage.setEmail(email);
      await stateUser.signin(email: email);

      return UpdateEmailResp.fromJSON(response.data);
    } on FirebaseFunctionsException catch (exception) {
      appLogger.e("[code: ${exception.code}] - ${exception.message}");
      return UpdateEmailResp(
        success: false,
        error: CloudFuncError(
          code: exception.details['code'],
          message: exception.details['message'],
        ),
      );
    } on PlatformException catch (exception) {
      appLogger.e(exception.toString());
      return UpdateEmailResp(
        success: false,
        error: CloudFuncError(
          code: exception.details['code'],
          message: exception.details['message'],
        ),
      );
    } catch (error) {
      appLogger.e(error.toString());

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
      final callable = FirebaseFunctions.instanceFor(
        app: Firebase.app(),
        region: 'europe-west3',
      ).httpsCallable('users-updateUsername');

      final response = await callable.call({
        'newUsername': newUsername,
      });

      appStorage.setUserName(newUsername);

      return UpdateEmailResp.fromJSON(response.data);
    } on FirebaseFunctionsException catch (exception) {
      appLogger.e("[code: ${exception.code}] - ${exception.message}");
      return UpdateEmailResp(
        success: false,
        error: CloudFuncError(
          code: exception.details['code'],
          message: exception.details['message'],
        ),
      );
    } on PlatformException catch (exception) {
      appLogger.e(exception.toString());

      return UpdateEmailResp(
        success: false,
        error: CloudFuncError(
          code: exception.details['code'],
          message: exception.details['message'],
        ),
      );
    } catch (error) {
      appLogger.e(error.toString());

      return UpdateEmailResp(
        success: false,
        error: CloudFuncError(
          code: '',
          message: error.toString(),
        ),
      );
    }
  }

  String getPPUrl() {
    if (userFirestore == null) return '';

    final editedURL = userFirestore.pp?.url?.edited;
    if (editedURL != null) return editedURL;

    final originalURL = userFirestore.pp?.url?.original;
    if (originalURL != null) return originalURL;

    return '';
  }

  String getInitialsUsername() {
    final splittedUsernameArray = stateUser.username.split(' ');
    if (splittedUsernameArray.isEmpty) return '';

    String initials = splittedUsernameArray.length > 1
        ? splittedUsernameArray
            .reduce((value, element) => value + element.substring(1))
        : splittedUsernameArray.first;

    if (initials.isNotEmpty) {
      initials = initials.substring(0, 1);
    }

    return initials;
  }

  /// Automatically sign in the user
  /// according to the last saved credentials.
  Future<void> signInOnAppStart() async {
    try {
      final userCred = await signin();

      if (userCred == null) {
        signOut();
      }
    } catch (error) {
      appLogger.e(error);
      signOut();
    }
  }
}

final stateUser = StateUser();
