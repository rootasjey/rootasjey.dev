import 'package:beamer/beamer.dart';
import 'package:flutter/widgets.dart';
import 'package:rootasjey/screens/enroll_page.dart';

class EnrollLocation extends BeamLocation<BeamState> {
  /// Main root value for this location.
  static const String route = '/enroll';

  @override
  List<String> get pathPatterns => [route];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        child: EnrollPage(),
        key: ValueKey(route),
        title: "Enroll",
        type: BeamPageType.fadeTransition,
      ),
    ];
  }
}
