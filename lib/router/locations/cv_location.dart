import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:rootasjey/screens/cv_page.dart';

class CVLocation extends BeamLocation<BeamState> {
  static const String route = "/cv";

  @override
  List<Pattern> get pathPatterns => [route];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        child: const CVPage(),
        key: const ValueKey(route),
        title: "page_title.cv".tr(),
        type: BeamPageType.fadeTransition,
      ),
    ];
  }
}
