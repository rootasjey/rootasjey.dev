import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:rootasjey/screens/settings_page.dart';

class SettingsLocation extends BeamLocation<BeamState> {
  /// Main root value for this location.
  static const String route = "/settings";

  @override
  List<String> get pathPatterns => [route];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        child: const SettingsPage(),
        key: const ValueKey(route),
        title: "page_title.settings".tr(),
        type: BeamPageType.fadeTransition,
      ),
    ];
  }
}
