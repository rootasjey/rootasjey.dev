import 'package:beamer/beamer.dart';
import 'package:rootasjey/router/locations/home_location.dart';

final appBeamerDelegate = BeamerDelegate(
  locationBuilder: BeamerLocationBuilder(
    beamLocations: [
      HomeLocation(),
    ],
  ).call,
);
