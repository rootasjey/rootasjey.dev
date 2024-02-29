import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:rootasjey/screens/art/art_page.dart';
import 'package:rootasjey/screens/illustrations_page/illustrations_page.dart';
import 'package:rootasjey/screens/video_montage/video_montages_page.dart';

class ArtLocation extends BeamLocation<BeamState> {
  static const String route = "art";
  static const String routeWildcard = "art/*";
  static const String illustrationsRoute = "$route/illustrations";
  static const String videoMontagesRoute = "$route/video-montages";
  static const String terrariumsRoute = "$route/terrariums";
  static const String singleIllustrationRoute =
      "$illustrationsRoute/:illustrationId";

  @override
  List<Pattern> get pathPatterns => [
        route,
        routeWildcard,
        illustrationsRoute,
        singleIllustrationRoute,
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        child: const ArtPage(),
        key: const ValueKey(route),
        title: "page_title.art".tr(),
        type: BeamPageType.fadeTransition,
      ),

      if (state.pathPatternSegments
          .contains(illustrationsRoute.split("/").last))
        BeamPage(
          child: const IllustrationsPage(),
          key: const ValueKey(illustrationsRoute),
          title: "page_title.illustrations".tr(),
          type: BeamPageType.fadeTransition,
        ),
      if (state.pathPatternSegments
          .contains(videoMontagesRoute.split("/").last))
        BeamPage(
          child: const VideoMontagesPage(),
          key: const ValueKey(videoMontagesRoute),
          title: "page_title.video_montages".tr(),
          type: BeamPageType.fadeTransition,
        ),
      // if (state.pathParameters.containsKey(":illustrationId"))
      //   BeamPage(
      //     child: const ArtPage(),
      //     key: const ValueKey(illustrationsRoute),
      //     title: "page_title.illustrations".tr(),
      //     type: BeamPageType.fadeTransition,
      //   ),
    ];
  }
}
