import 'package:beamer/beamer.dart';
import 'package:rootasjey/router/locations/about_location.dart';
import 'package:rootasjey/router/locations/cv_location.dart';
import 'package:rootasjey/router/locations/forgot_password_location.dart';
import 'package:rootasjey/router/locations/home_location.dart';
import 'package:rootasjey/router/locations/illustrations_location.dart';
import 'package:rootasjey/router/locations/posts_location.dart';
import 'package:rootasjey/router/locations/settings_location.dart';
import 'package:rootasjey/router/locations/projects_location.dart';
import 'package:rootasjey/router/locations/search_location.dart';
import 'package:rootasjey/router/locations/signin_location.dart';
import 'package:rootasjey/router/locations/signup_location.dart';
import 'package:rootasjey/router/locations/tos_location.dart';

final appLocationBuilder = BeamerDelegate(
  locationBuilder: BeamerLocationBuilder(
    beamLocations: [
      HomeLocation(),
      AboutLocation(),
      CVLocation(),
      ForgotPasswordLocation(),
      IllustrationsLocation(),
      PostsLocation(),
      SettingsLocation(),
      ProjectsLocation(),
      SearchLocation(),
      SigninLocation(),
      SignupLocation(),
      TosLocation(),
    ],
  ),
);
