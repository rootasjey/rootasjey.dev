import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/router/app_routes.dart';
import 'package:rootasjey/types/globals/globals.dart';
import 'package:rootasjey/utils/fonts.dart';

/// Main app class.
class App extends StatefulWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const App({
    Key? key,
    this.savedThemeMode,
  }) : super(key: key);

  AppState createState() => AppState();
}

/// Main app class state.
class AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        brightness: Brightness.light,
        fontFamily: FontsUtils.fontFamily,
        backgroundColor: Globals.constants.colors.lightBackground,
        scaffoldBackgroundColor: Globals.constants.colors.lightBackground,
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        fontFamily: FontsUtils.fontFamily,
        backgroundColor: Globals.constants.colors.dark,
        scaffoldBackgroundColor: Globals.constants.colors.dark,
      ),
      initial: widget.savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme, darkTheme) {
        return MaterialApp.router(
          title: 'rootasjey',
          theme: theme,
          darkTheme: darkTheme,
          debugShowCheckedModeBanner: false,
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          routerDelegate: appLocationBuilder,
          routeInformationParser: BeamerParser(),
        );
      },
    );
  }
}
