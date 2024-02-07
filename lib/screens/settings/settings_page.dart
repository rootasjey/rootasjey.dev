import "package:adaptive_theme/adaptive_theme.dart";
import "package:beamer/beamer.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_solidart/flutter_solidart.dart";
import "package:rootasjey/components/basic_shortcuts.dart";
import "package:rootasjey/globals/constants.dart";
import "package:rootasjey/globals/utils.dart";
import "package:rootasjey/router/locations/home_location.dart";
import "package:rootasjey/router/locations/settings_location.dart";
import "package:rootasjey/screens/settings/about_settings.dart";
import "package:rootasjey/screens/settings/account_settings.dart";
import "package:rootasjey/screens/settings/app_language_selection.dart";
import "package:rootasjey/screens/settings/settings_page_header.dart";
import "package:rootasjey/screens/settings/theme_switcher.dart";
import "package:rootasjey/types/enums/enum_account_displayed.dart";
import "package:rootasjey/types/enums/enum_language_selection.dart";
import "package:rootasjey/types/enums/enum_signal_id.dart";
import "package:rootasjey/types/user/user_firestore.dart";
import "package:url_launcher/url_launcher.dart";

/// Settings page.
class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
    this.selfPageShortcutsActive = false,
  });

  /// Whether to activate the shortcut on the settings page.
  /// Set to `true` only if this page is not wrapped in a `Shortcuts`.
  final bool selfPageShortcutsActive;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  /// Animate elements on settings page if true.
  bool _animateElements = true;

  /// An enum representing the account displayed text value on settings page.
  EnumAccountDisplayed _enumAccountDisplayed = EnumAccountDisplayed.name;

  /// List of accent colors.
  /// For styling purpose.
  final List<Color> _accentColors = [];

  final _pageScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    initProps();
  }

  @override
  void dispose() {
    _pageScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobileSize = Utils.measurements.isMobileSize(context);
    final String? currentLanguageCode =
        EasyLocalization.of(context)?.currentLocale?.languageCode;

    final Signal<UserFirestore> signalUserFirestore =
        context.get<Signal<UserFirestore>>(EnumSignalId.userFirestore);

    final Color? foregroundColor =
        Theme.of(context).textTheme.bodyMedium?.color;

    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color dividerColor = isDark ? Colors.white12 : Colors.black12;

    final Widget scaffold = Scaffold(
      body: CustomScrollView(
        controller: _pageScrollController,
        slivers: [
          SettingsPageHeader(
            isMobileSize: isMobileSize,
            onScrollToTop: scrollToTop,
          ),
          ThemeSwitcher(
            accentColor: _accentColors.elementAt(0),
            animateElements: _animateElements,
            dividerColor: dividerColor,
            foregroundColor: foregroundColor,
            isDark: isDark,
            isMobileSize: isMobileSize,
            onTapLightTheme: onTapLightTheme,
            onTapDarkTheme: onTapDarkTheme,
            onTapSystemTheme: onTapSystemTheme,
            onToggleThemeMode: onToggleThemeMode,
          ),
          SignalBuilder(
            signal: signalUserFirestore,
            builder: (
              BuildContext context,
              UserFirestore userFirestore,
              Widget? child,
            ) {
              if (userFirestore.id.isEmpty) {
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              }

              return AccountSettings(
                accentColor: _accentColors.elementAt(1),
                animateElements: _animateElements,
                isDark: isDark,
                dividerColor: dividerColor,
                enumAccountDisplayed: _enumAccountDisplayed,
                foregroundColor: foregroundColor,
                isMobileSize: isMobileSize,
                onTapUpdateEmail: onTapUpdateEmail,
                onTapUpdatePassword: onTapUpdatePassword,
                onTapUpdateUsername: onTapUpdateUsername,
                onTapSignout: onTapSignOut,
                onTapDeleteAccount: onTapDeleteAccount,
                onTapAccountDisplayedValue: onTapAccountDisplayedValue,
                userFirestore: userFirestore,
              );
            },
          ),
          AppLanguageSelection(
            accentColor: _accentColors.elementAt(2),
            animateElements: _animateElements,
            currentLanguageCode: currentLanguageCode,
            dividerColor: dividerColor,
            foregroundColor: foregroundColor,
            isMobileSize: isMobileSize,
            onSelectLanguage: onSelectLanguage,
          ),
          AboutSettings(
            animateElements: _animateElements,
            foregroundColor: foregroundColor,
            isMobileSize: isMobileSize,
            onTapColorPalette: onTapColorPalette,
            onTapTermsOfService: onTapTermsOfService,
            onTapGitHub: onTapGitHub,
            onTapThePurpose: onTapThePurpose,
            onTapCredits: onTapCredits,
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 200.0)),
        ],
      ),
    );

    if (!widget.selfPageShortcutsActive) {
      return scaffold;
    }

    return BasicShortcuts(
      onCancel: Beamer.of(context).beamBack,
      child: scaffold,
    );
  }

  void initProps() async {
    _accentColors
      ..add(Constants.colors.getRandomFromPalette())
      ..add(Constants.colors.getRandomFromPalette())
      ..add(Constants.colors.getRandomFromPalette())
      ..add(Constants.colors.getRandomFromPalette());

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => _animateElements = false);
    });
  }

  /// Apply the new selected language.
  void onSelectLanguage(EnumLanguageSelection locale) {
    Utils.vault.setLanguage(locale);
    EasyLocalization.of(context)?.setLocale(Locale(locale.name));
  }

  /// Circle between name and email to display.
  void onTapAccountDisplayedValue() {
    setState(() {
      _enumAccountDisplayed = _enumAccountDisplayed == EnumAccountDisplayed.name
          ? EnumAccountDisplayed.email
          : EnumAccountDisplayed.name;
    });
  }

  /// Navigate to the credits page.
  void onTapCredits() {
    // Beamer.of(context).beamToNamed(
    //   DashboardContentLocation.creditsRoute,
    // );
  }

  /// Navigate to the delete account page.
  void onTapDeleteAccount() {
    // Beamer.of(context).beamToNamed(
    //   SettingsLocation.deleteAccountRoute,
    // );
  }

  /// Logout the user.
  void onTapSignOut() async {
    final bool success = await Utils.state.user.signOut();
    if (!success) return;
    if (!mounted) return;

    Beamer.of(context, root: true).beamToReplacementNamed(HomeLocation.route);
  }

  /// Navigate to the update email page.
  void onTapUpdateEmail() {
    // Beamer.of(context).beamToNamed(
    //   DashboardContentLocation.updateEmailRoute,
    // );
  }

  /// Navigate to the update password page.
  void onTapUpdatePassword() {
    Beamer.of(context).beamToNamed(
      SettingsLocation.updatePasswordRoute,
    );
  }

  /// Navigate to the update username page.
  void onTapUpdateUsername() {
    Beamer.of(context).beamToNamed(
      SettingsLocation.updateUsernameRoute,
    );
  }

  /// Navigate to the color palette page.
  void onTapColorPalette() {
    // Beamer.of(context).beamToNamed(
    //   DashboardContentLocation.colorPaletteRoute,
    // );
  }

  /// Navigate to the terms of service page.
  void onTapTermsOfService() {
    Beamer.of(context).beamToNamed(
      "terms-of-service/",
    );
  }

  /// Open the project's GitHub page.
  void onTapGitHub() {
    launchUrl(Uri.parse(Constants.githubUrl));
  }

  /// Navigate to the purpose page.
  void onTapThePurpose() {
    Beamer.of(context).beamToNamed(
      "the-purpose/",
    );
  }

  /// Apply light theme.
  void onTapLightTheme() {
    AdaptiveTheme.of(context).setLight();
    Utils.vault.setBrightness(Brightness.light);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Constants.colors.lightBackground,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );
  }

  /// Apply dark theme.
  void onTapDarkTheme() {
    AdaptiveTheme.of(context).setDark();
    Utils.vault.setBrightness(Brightness.dark);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Constants.colors.dark,
        systemNavigationBarColor: Color.alphaBlend(
          Colors.black26,
          Constants.colors.dark,
        ),
        systemNavigationBarDividerColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  /// Apply system theme.
  void onTapSystemTheme() {
    AdaptiveTheme.of(context).setSystem();
    updateUiBrightness();
  }

  /// Circle through light, dark and system theme.
  void onToggleThemeMode() {
    AdaptiveTheme.of(context).toggleThemeMode();
    updateUiBrightness();
  }

  /// Save the current brightness to the vault and
  /// update the system UI overlay style.
  void updateUiBrightness() {
    final Brightness brightness =
        AdaptiveTheme.of(context).brightness ?? Brightness.light;
    Utils.vault.setBrightness(brightness);

    final bool isDark = brightness == Brightness.dark;

    final SystemUiOverlayStyle overlayStyle = isDark
        ? SystemUiOverlayStyle(
            statusBarColor: Constants.colors.dark,
            systemNavigationBarColor: Colors.black26,
            systemNavigationBarDividerColor: Colors.transparent,
          )
        : SystemUiOverlayStyle(
            statusBarColor: Constants.colors.lightBackground,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarDividerColor: Colors.transparent,
          );

    SystemChrome.setSystemUIOverlayStyle(overlayStyle);
  }

  void scrollToTop() {
    _pageScrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }
}
