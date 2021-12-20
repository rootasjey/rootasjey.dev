import 'package:beamer/beamer.dart';
import 'package:flutter/widgets.dart';
import 'package:rootasjey/router/locations/home_location.dart';
import 'package:rootasjey/screens/signup_page.dart';
import 'package:rootasjey/state/user.dart';

class SignupLocation extends BeamLocation<BeamState> {
  /// Main root value for this location.
  static const String route = '/signup';

  @override
  List<String> get pathPatterns => [route];

  /// Redirect to home ('/') if the user is authenticated.
  @override
  List<BeamGuard> get guards => [
        BeamGuard(
          pathPatterns: [route],
          check: (context, location) => !stateUser.isUserConnected,
          beamToNamed: (origin, taraget) => HomeLocation.route,
        ),
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        child: SignupPage(),
        key: ValueKey(route),
        title: "Signup",
        type: BeamPageType.fadeTransition,
      ),
    ];
  }
}
