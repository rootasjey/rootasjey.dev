// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:loggy/loggy.dart';
import 'package:rootasjey/app.dart';
import 'package:rootasjey/firebase_options.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/router/app_routes.dart';
import 'package:rootasjey/router/navigation_state_helper.dart';
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

  Beamer.setPathUrlStrategy();
  await EasyLocalization.ensureInitialized();
  await dotenv.load(fileName: "var.env");

  final String browserUrl = Uri.base.query.isEmpty
      ? Uri.base.path
      : "${Uri.base.path}?${Uri.base.query}";

  NavigationStateHelper.initialBrowserUrl = browserUrl;

  // Make sure that the initial route is kept correctly.
  if (kIsWeb) {
    appBeamerDelegate.setInitialRoutePath(RouteInformation(
      uri: Uri.parse(browserUrl),
    ));
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
    EasyLocalization(
      path: "assets/translations",
      supportedLocales: const [Locale("en"), Locale("fr")],
      fallbackLocale: Locale("en"),
      child: App(savedThemeMode: savedThemeMode),
    ),
  );
}
