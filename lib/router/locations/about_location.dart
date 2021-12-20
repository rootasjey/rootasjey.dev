import 'package:beamer/beamer.dart';
import 'package:flutter/widgets.dart';
import 'package:rootasjey/screens/about_page.dart';

class AboutLocation extends BeamLocation<BeamState> {
  /// Main root value for this location.
  static const String route = '/about';

  @override
  List<String> get pathPatterns => [route];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        child: AboutPage(),
        key: ValueKey(route),
        title: "About",
        type: BeamPageType.fadeTransition,
      ),
    ];
  }
}
