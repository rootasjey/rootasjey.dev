// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:rootasjey/app.dart';
import 'package:rootasjey/firebase_options.dart';
import 'package:rootasjey/globals/app_state.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/globals/state/user_notifier.dart';
import 'package:rootasjey/globals/utilities.dart';
import 'package:rootasjey/types/user/user.dart';
import 'package:rootasjey/types/user/user_firestore.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  LicenseRegistry.addLicense(() async* {
    final String license = await rootBundle.loadString("google_fonts/OFL.txt");
    yield LicenseEntryWithLineBreaks(["google_fonts"], license);
  });

  WidgetsFlutterBinding.ensureInitialized();
  Loggy.initLoggy();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await EasyLocalization.ensureInitialized();
  // await GlobalConfiguration().loadFromAsset("app_settings");
  // try {
  //   var document = await TomlDocument.load('config.toml');
  //   var config = document.toMap();
  //   print(config['table']['array'][0]['key']);
  // } catch (e) {
  //   print('ERROR: $e');
  // }

  // Try re-authenticate w/ blocking call.
  // We want to avoid UI flickering from guest -> authenticated
  // if the user was already connected.
  final authUser = await Utilities.getFireAuthUser();
  if (authUser != null) {
    final UserFirestore? firestoreUser =
        await Utilities.getFirestoreUser(authUser.uid);

    AppState.userProvider = StateNotifierProvider<UserNotifier, User>(
      (ref) => UserNotifier(User(
        authUser: authUser,
        firestoreUser: firestoreUser,
      )),
    );
  }

  final AdaptiveThemeMode? savedThemeMode = await AdaptiveTheme.getThemeMode();
  setPathUrlStrategy();

  if (!kIsWeb) {
    if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      await windowManager.ensureInitialized();

      windowManager.waitUntilReadyToShow(
        WindowOptions(
          titleBarStyle: TitleBarStyle.hidden,
        ),
        () async {
          await windowManager.show();
        },
      );
    }

    if (Platform.isAndroid || Platform.isIOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Constants.colors.lightBackground,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarDividerColor: Colors.transparent,
        ),
      );
    }
  }

  Constants.colors.palette.shuffle();
  Constants.colors.backgroundPalette.shuffle();

  return runApp(
    ProviderScope(
      child: EasyLocalization(
        path: "assets/translations",
        supportedLocales: const [Locale("en"), Locale("fr")],
        fallbackLocale: Locale("en"),
        child: App(savedThemeMode: savedThemeMode),
      ),
    ),
  );
}
