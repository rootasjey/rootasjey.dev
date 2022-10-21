import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/router/app_routes.dart';
import 'package:rootasjey/utils/fonts.dart';

/// Main app class.
class App extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const App({
    Key? key,
    this.savedThemeMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        brightness: Brightness.light,
        fontFamily: FontsUtils.fontFamily,
        backgroundColor: Constants.colors.lightBackground,
        scaffoldBackgroundColor: Constants.colors.lightBackground,
        primaryColor: Constants.colors.primary,
        secondaryHeaderColor: Constants.colors.secondary,
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        fontFamily: FontsUtils.fontFamily,
        backgroundColor: Constants.colors.dark,
        scaffoldBackgroundColor: Constants.colors.dark,
        primaryColor: Constants.colors.primary,
        secondaryHeaderColor: Constants.colors.secondary,
      ),
      initial: savedThemeMode ?? AdaptiveThemeMode.dark,
      builder: (ThemeData theme, ThemeData darkTheme) {
        return MaterialApp.router(
          title: "rootasjey",
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
