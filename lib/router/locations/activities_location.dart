import 'package:beamer/beamer.dart';
import 'package:flutter/widgets.dart';
import 'package:rootasjey/screens/activities_page.dart';

class ActivitiesLocation extends BeamLocation<BeamState> {
  static const String route = '/activities';

  @override
  List<Pattern> get pathPatterns => [route];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        child: ActivitiesPage(),
        key: ValueKey(route),
        title: 'activities',
        type: BeamPageType.fadeTransition,
      ),
    ];
  }
}
