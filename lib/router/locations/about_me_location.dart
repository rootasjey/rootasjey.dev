import 'package:beamer/beamer.dart';
import 'package:flutter/widgets.dart';
import 'package:rootasjey/screens/about_me_page.dart';

class AboutMeLocation extends BeamLocation<BeamState> {
  static const String route = '/me';

  @override
  List<Pattern> get pathPatterns => [route];

  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        child: AboutMePage(),
        key: ValueKey(route),
        title: 'About me',
        type: BeamPageType.fadeTransition,
      ),
    ];
  }
}
