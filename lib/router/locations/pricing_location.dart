import 'package:beamer/beamer.dart';
import 'package:flutter/widgets.dart';
import 'package:rootasjey/screens/pricing_page.dart';

class PricingLocation extends BeamLocation<BeamState> {
  /// Main root value for this location.
  static const String route = '/pricing';

  @override
  List<Pattern> get pathPatterns => [route];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        child: PricingPage(),
        key: ValueKey(route),
        title: "Pricing",
        type: BeamPageType.fadeTransition,
      ),
    ];
  }
}
