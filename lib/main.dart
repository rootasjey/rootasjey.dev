import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:rootasjey/app.dart';
import 'package:rootasjey/state/user.dart';
import 'package:rootasjey/utils/app_logger.dart';
import 'package:rootasjey/utils/app_storage.dart';
import 'package:rootasjey/utils/brightness.dart';
import 'package:rootasjey/utils/search.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await appStorage.initialize();
  await Future.wait([_autoLogin(), _initLang()]);
  await EasyLocalization.ensureInitialized();
  await GlobalConfiguration().loadFromAsset('app_settings');

  AlgoliaHelper.init(
    applicationId: GlobalConfiguration().getValue('algolia_app_id'),
    searchApiKey: GlobalConfiguration().getValue('algolia_search_api_key'),
  );

  final brightness = BrightnessUtils.getCurrent();

  final savedThemeMode = brightness == Brightness.dark
      ? AdaptiveThemeMode.dark
      : AdaptiveThemeMode.light;

  setPathUrlStrategy();

  return runApp(
    EasyLocalization(
      path: 'assets/translations',
      supportedLocales: [Locale('en'), Locale('fr')],
      fallbackLocale: Locale('en'),
      child: App(
        savedThemeMode: savedThemeMode,
        brightness: brightness,
      ),
    ),
  );
}

// Initialization functions.
// ------------------------
Future _autoLogin() async {
  try {
    final userCred = await stateUser.signin();

    if (userCred == null) {
      stateUser.signOut();
    }
  } catch (error) {
    appLogger.e(error);
    stateUser.signOut();
  }
}

Future _initLang() async {
  final savedLang = appStorage.getLang();
  stateUser.setLang(savedLang);
}
