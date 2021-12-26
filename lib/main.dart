import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:rootasjey/app.dart';
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

  await EasyLocalization.ensureInitialized();
  await GlobalConfiguration().loadFromAsset('app_settings');

  AlgoliaHelper.init(
    applicationId: GlobalConfiguration().getValue('algolia_app_id'),
    searchApiKey: GlobalConfiguration().getValue('algolia_search_api_key'),
  );

  setPathUrlStrategy();

  return runApp(
    ProviderScope(
      child: EasyLocalization(
        path: 'assets/translations',
        supportedLocales: [Locale('en'), Locale('fr')],
        fallbackLocale: Locale('en'),
        child: App(
          savedThemeMode: BrightnessUtils.getSavedThemeMode(),
          brightness: BrightnessUtils.getCurrentBrightness(),
        ),
      ),
    ),
  );
}
