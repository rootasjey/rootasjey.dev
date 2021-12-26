import 'package:beamer/beamer.dart';
import 'package:flutter/widgets.dart';
import 'package:rootasjey/screens/project_page.dart';
import 'package:rootasjey/screens/projects_page.dart';

class ProjectsLocation extends BeamLocation<BeamState> {
  static const String route = '/projects';
  static const String singleProjectRoute = '${route}/:id';

  @override
  List<Pattern> get pathPatterns => [
        route,
        singleProjectRoute,
      ];

  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        child: ProjectsPage(),
        key: ValueKey(route),
        title: 'Projects',
        type: BeamPageType.fadeTransition,
      ),
      if (state.pathPatternSegments.contains(':projectId'))
        BeamPage(
          child: ProjectPage(
            projectId: state.pathParameters['projectId'] ?? '',
          ),
          key: ValueKey("$route-${state.pathParameters['projectId']}"),
          title: 'Project',
        ),
    ];
  }
}
