import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:rootasjey/screens/password/update_password_page.dart';
import 'package:rootasjey/screens/settings/about/terms_of_service_page.dart';
import 'package:rootasjey/screens/settings/about/the_purpose_page.dart';
import 'package:rootasjey/screens/settings/delete_account/delete_account_page.dart';
import 'package:rootasjey/screens/settings/email/update_email_page.dart';
import 'package:rootasjey/screens/settings/settings_page.dart';
import 'package:rootasjey/screens/settings/username/update_username_page.dart';

class SettingsLocation extends BeamLocation<BeamState> {
  /// Main root value for this location.
  static const String route = "/settings";

  static const String tosRoute = "$route/terms-of-service";
  static const String thePurposeRoute = "$route/the-purpose";

  static const String deleteAccountRoute = "$route/delete-account";
  static const String updateEmailRoute = "$route/email";
  static const String updatePasswordRoute = "$route/password";
  static const String updateUsernameRoute = "$route/username";

  @override
  List<String> get pathPatterns => [
        route,
        updateEmailRoute,
        updatePasswordRoute,
        updateUsernameRoute,
        deleteAccountRoute,
        tosRoute,
        thePurposeRoute,
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        child: const SettingsPage(),
        key: const ValueKey(route),
        title: "page_title.settings".tr(),
        type: BeamPageType.fadeTransition,
      ),
      if (state.pathPatternSegments.contains(route.split("/").last) &&
          state.pathPatternSegments.contains(updateEmailRoute.split("/").last))
        BeamPage(
          child: const UpdateEmailPage(),
          key: const ValueKey(updateEmailRoute),
          title: "page_title.update_email".tr(),
          type: BeamPageType.fadeTransition,
        ),
      if (state.pathPatternSegments.contains(route.split("/").last) &&
          state.pathPatternSegments
              .contains(updatePasswordRoute.split("/").last))
        BeamPage(
          child: const UpdatePasswordPage(),
          key: const ValueKey(updatePasswordRoute),
          title: "page_title.update_password".tr(),
          type: BeamPageType.fadeTransition,
        ),
      if (state.pathPatternSegments.contains(route.split("/").last) &&
          state.pathPatternSegments
              .contains(updateUsernameRoute.split("/").last))
        BeamPage(
          child: const UpdateUsernamePage(),
          key: const ValueKey(updateUsernameRoute),
          title: "page_title.update_username".tr(),
          type: BeamPageType.fadeTransition,
        ),
      if (state.pathPatternSegments.contains(route.split("/").last) &&
          state.pathPatternSegments
              .contains(deleteAccountRoute.split("/").last))
        BeamPage(
          child: const DeleteAccountPage(),
          key: const ValueKey(deleteAccountRoute),
          title: "page_title.delete_account".tr(),
          type: BeamPageType.fadeTransition,
        ),
      if (state.pathPatternSegments.contains(route.split("/").last) &&
          state.pathPatternSegments.contains(tosRoute.split("/").last))
        BeamPage(
          child: const TermsOfServicePage(),
          key: const ValueKey(tosRoute),
          title: "page_title.terms_of_service".tr(),
          type: BeamPageType.fadeTransition,
        ),
      if (state.pathPatternSegments.contains(route.split("/").last) &&
          state.pathPatternSegments.contains(thePurposeRoute.split("/").last))
        BeamPage(
          child: const ThePurposePage(),
          key: const ValueKey(thePurposeRoute),
          title: "page_title.the_purpose".tr(),
          type: BeamPageType.fadeTransition,
        ),
    ];
  }
}
