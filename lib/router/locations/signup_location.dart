import 'package:beamer/beamer.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rootasjey/globals/app_state.dart';
import 'package:rootasjey/router/locations/home_location.dart';
import 'package:rootasjey/screens/signup_page.dart';

class SignupLocation extends BeamLocation<BeamState> {
  /// Main root value for this location.
  static const String route = "/signup";

  @override
  List<String> get pathPatterns => [route];

  /// Redirect to home ('/') if the user is authenticated.
  @override
  List<BeamGuard> get guards => [
        BeamGuard(
          pathPatterns: [route],
          check: (context, location) {
            final containerProvider = ProviderContainer();
            final user = containerProvider.read(AppState.userProvider.notifier);
            return !user.isAuthenticated;
          },
          beamToNamed: (origin, taraget) => HomeLocation.route,
        ),
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      const BeamPage(
        child: SignupPage(),
        key: ValueKey(route),
        title: "Signup",
        type: BeamPageType.fadeTransition,
      ),
    ];
  }
}
