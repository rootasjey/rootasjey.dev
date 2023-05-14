import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:rootasjey/screens/project_page.dart';
import 'package:rootasjey/screens/projects_page/projects_page.dart';

class ProjectsLocation extends BeamLocation<BeamState> {
  static const String route = "/projects";
  static const String singleProjectRoute = "$route/:projectId";

  @override
  List<Pattern> get pathPatterns => [
        route,
        singleProjectRoute,
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        child: const ProjectsPage(),
        key: const ValueKey(route),
        title: "page_title.projects".tr(),
        type: BeamPageType.fadeTransition,
      ),
      if (state.pathPatternSegments.contains(":projectId"))
        BeamPage(
          child: ProjectPage(
            projectId: state.pathParameters["projectId"] ?? "",
          ),
          key: ValueKey("$route-${state.pathParameters['projectId']}"),
          title: getProjectTitle(state),
          type: BeamPageType.fadeTransition,
        ),
    ];
  }

  String getProjectTitle(BeamState state) {
    final Object? routeState = state.routeState;

    if (routeState == null) {
      return "page_title.project".tr();
    }

    final Map mapState = routeState as Map;
    if (mapState.containsKey("projectName")) {
      return "page_title.any".tr(args: [mapState["projectName"]]);
    }

    return "page_title.project".tr();
  }
}
