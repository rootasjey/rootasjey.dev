import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:rootasjey/router/locations/home_location.dart';
import 'package:rootasjey/screens/undefined_page.dart';

final appBeamerDelegate = BeamerDelegate(
  initialPath: "/home",
  locationBuilder: BeamerLocationBuilder(
    beamLocations: [
      HomeLocation(),
    ],
  ).call,
  notFoundPage: BeamPage(
    key: const ValueKey("not_found_page"),
    child: const UndefinedPage(),
    type: BeamPageType.fadeTransition,
    title: "page_title.404".tr(),
  ),
);
