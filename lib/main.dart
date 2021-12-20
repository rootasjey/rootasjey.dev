import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:rootasjey/router/app_routes.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/state/user.dart';
import 'package:rootasjey/utils/app_logger.dart';
import 'package:rootasjey/utils/app_storage.dart';
import 'package:rootasjey/utils/brightness.dart';
import 'package:rootasjey/utils/fonts.dart';
import 'package:rootasjey/utils/search.dart';
import 'package:supercharged/supercharged.dart';
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

/// Main app class.
class App extends StatefulWidget {
  final AdaptiveThemeMode savedThemeMode;
  final Brightness brightness;

  const App({
    Key key,
    this.savedThemeMode,
    this.brightness,
  }) : super(key: key);

  AppState createState() => AppState();
}

/// Main app class state.
class AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    stateColors.refreshTheme(widget.brightness);
    stateUser.setFirstLaunch(appStorage.isFirstLanch());

    return AdaptiveTheme(
      light: ThemeData(
        brightness: Brightness.light,
        fontFamily: FontsUtils.fontFamily,
        backgroundColor: stateColors.lightBackground,
        scaffoldBackgroundColor: stateColors.lightBackground,
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        fontFamily: FontsUtils.fontFamily,
      ),
      initial: widget.brightness == Brightness.light
          ? AdaptiveThemeMode.light
          : AdaptiveThemeMode.dark,
      builder: (theme, darkTheme) {
        stateColors.themeData = theme;

        return AppWithTheme(
          brightness: widget.brightness,
          theme: theme,
          darkTheme: darkTheme,
        );
      },
    );
  }
}

/// Because we need a [context] with adaptive theme data available in it.
class AppWithTheme extends StatefulWidget {
  final ThemeData theme;
  final ThemeData darkTheme;
  final Brightness brightness;

  const AppWithTheme({
    Key key,
    @required this.brightness,
    @required this.darkTheme,
    @required this.theme,
  }) : super(key: key);

  @override
  _AppWithThemeState createState() => _AppWithThemeState();
}

class _AppWithThemeState extends State<AppWithTheme> {
  @override
  initState() {
    super.initState();
    Future.delayed(250.milliseconds, () {
      if (widget.brightness == Brightness.dark) {
        AdaptiveTheme.of(context).setDark();
        return;
      }

      AdaptiveTheme.of(context).setLight();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'rootasjey',
      theme: widget.theme,
      darkTheme: widget.darkTheme,
      debugShowCheckedModeBanner: false,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      routerDelegate: appLocationBuilder,
      routeInformationParser: BeamerParser(),
    );
  }
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
