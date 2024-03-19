import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:rootasjey/screens/home_page/main_grid.dart';

class HomeLocation extends BeamLocation<BeamState> {
  /// Main root value for this location.
  static const String route = '/';

  @override
  List<Pattern> get pathPatterns => [route];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        child: const MainGrid(),
        key: const ValueKey(route),
        title: "page_title.home".tr(),
        type: BeamPageType.fadeTransition,
      ),
    ];
  }
}
