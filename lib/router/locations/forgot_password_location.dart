import 'package:beamer/beamer.dart';
import 'package:flutter/widgets.dart';
import 'package:rootasjey/screens/forgot_password_page.dart';

class ForgotPasswordLocation extends BeamLocation<BeamState> {
  /// Main root value for this location.
  static const String route = "/forgotpassword";

  @override
  List<String> get pathPatterns => [route];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      const BeamPage(
        child: ForgotPasswordPage(),
        key: ValueKey(route),
        title: "Forgot Password",
        type: BeamPageType.fadeTransition,
      ),
    ];
  }
}
