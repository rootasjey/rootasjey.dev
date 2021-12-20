import 'package:beamer/beamer.dart';
import 'package:flutter/widgets.dart';
import 'package:rootasjey/screens/search_page.dart';

class SearchLocation extends BeamLocation<BeamState> {
  /// Main root value for this location.
  static const String route = '/search';

  @override
  List<String> get pathPatterns => [route];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        child: SearchPage(),
        key: ValueKey(route),
        title: "Search",
        type: BeamPageType.fadeTransition,
      ),
    ];
  }
}
