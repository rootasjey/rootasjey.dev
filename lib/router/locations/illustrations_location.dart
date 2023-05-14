import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:rootasjey/screens/illustrations_page/illustrations_page.dart';

class IllustrationsLocation extends BeamLocation<BeamState> {
  static const String route = "illustrations";
  static const String singleIllustrationRoute = "$route/:illustrationId";

  @override
  List<Pattern> get pathPatterns => [
        route,
        singleIllustrationRoute,
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        child: const IllustrationsPage(),
        key: const ValueKey(route),
        title: "page_title.illustrations".tr(),
        type: BeamPageType.fadeTransition,
      ),
    ];
  }
}
