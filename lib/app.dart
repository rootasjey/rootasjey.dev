import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:rootasjey/components/loading_view.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/globals/utils.dart';
import 'package:rootasjey/router/app_routes.dart';
import 'package:rootasjey/router/navigation_state_helper.dart';
import 'package:rootasjey/types/custom_upload_task.dart';
import 'package:rootasjey/types/enums/enum_page_state.dart';
import 'package:rootasjey/types/enums/enum_signal_id.dart';
import 'package:rootasjey/types/user/user_auth.dart';
import 'package:rootasjey/types/user/user_firestore.dart';
import 'package:rootasjey/utils/fonts.dart';

/// Main app class.
class App extends StatefulWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const App({
    super.key,
    this.savedThemeMode,
  });

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  EnumPageState _pageState = EnumPageState.loading;

  @override
  void initState() {
    super.initState();
    initProps();
  }

  @override
  Widget build(BuildContext context) {
    final lightTheme = ThemeData(
      brightness: Brightness.light,
      fontFamily: FontsUtils.fontFamily,
      scaffoldBackgroundColor: Constants.colors.lightBackground,
      primaryColor: Constants.colors.primary,
      secondaryHeaderColor: Constants.colors.secondary,
      colorScheme:
          ColorScheme.light(background: Constants.colors.lightBackground),
    );

    final darkTheme = ThemeData(
      brightness: Brightness.dark,
      fontFamily: FontsUtils.fontFamily,
      scaffoldBackgroundColor: Constants.colors.dark,
      primaryColor: Constants.colors.primary,
      secondaryHeaderColor: Constants.colors.secondary,
      colorScheme: ColorScheme.dark(background: Constants.colors.dark),
    );

    if (_pageState == EnumPageState.loading) {
      return MaterialApp(
        theme: lightTheme,
        darkTheme: darkTheme,
        home: LoadingView.scaffold(),
      );
    }

    return Solid(
      providers: [
        Provider<Signal<UserAuth?>>(
          create: () => Utils.state.user.userAuth,
          id: EnumSignalId.userAuth,
        ),
        Provider<Signal<UserFirestore>>(
          create: () => Utils.state.user.userFirestore,
          id: EnumSignalId.userFirestore,
        ),
        Provider<Computed<bool>?>(
          create: () => Utils.state.illustrations.showUploadWindow,
          id: EnumSignalId.showUploadWindow,
        ),
        Provider<Signal<List<CustomUploadTask>>>(
          create: () => Utils.state.illustrations.uploadTaskList,
          id: EnumSignalId.uploadTaskList,
        ),
        Provider<Signal<int>>(
          create: () => Utils.state.illustrations.uploadBytesTransferred,
          id: EnumSignalId.uploadBytesTransferred,
        ),
      ],
      child: AdaptiveTheme(
        light: lightTheme,
        dark: darkTheme,
        initial: widget.savedThemeMode ?? AdaptiveThemeMode.dark,
        builder: (ThemeData theme, ThemeData darkTheme) {
          return MaterialApp.router(
            title: "rootasjey",
            theme: theme,
            darkTheme: darkTheme,
            debugShowCheckedModeBanner: false,
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: [
              ...context.localizationDelegates,
            ],
            routerDelegate: appBeamerDelegate,
            routeInformationParser: BeamerParser(),
            backButtonDispatcher: BeamerBackButtonDispatcher(
              delegate: appBeamerDelegate,
            ),
          );
        },
      ),
    );
  }

  void initProps() async {
    await Future.wait([
      Utils.state.user.signIn(),
    ]);

    final String browserUrl = NavigationStateHelper.initialBrowserUrl;
    final String languageCode = await Utils.linguistic.initCurrentLanguage(
      browserLanguage: Utils.linguistic.extractLanguageFromUrl(browserUrl),
    );

    if (!mounted) return;
    EasyLocalization.of(context)?.setLocale(Locale(languageCode));
    setState(() => _pageState = EnumPageState.idle);
  }
}
