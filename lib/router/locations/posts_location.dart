import 'package:beamer/beamer.dart';
import 'package:flutter/widgets.dart';
import 'package:rootasjey/screens/post_page.dart';
import 'package:rootasjey/screens/posts_page.dart';

class PostsLocation extends BeamLocation<BeamState> {
  static const String route = '/posts';
  static const String singleProjectRoute = '${route}/:id';

  @override
  List<Pattern> get pathPatterns => [
        route,
        singleProjectRoute,
      ];

  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        child: PostsPage(),
        key: ValueKey(route),
        title: 'Posts',
        type: BeamPageType.fadeTransition,
      ),
      if (state.pathPatternSegments.contains(':postId'))
        BeamPage(
          child: PostPage(
            postId: state.pathParameters['postId'] ?? '',
          ),
          key: ValueKey("$route-${state.pathParameters['postId']}"),
          title: 'Post',
        ),
    ];
  }
}
