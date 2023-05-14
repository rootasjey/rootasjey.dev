import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:rootasjey/screens/post/post_page.dart';
import 'package:rootasjey/screens/posts_page/posts_page.dart';

class PostsLocation extends BeamLocation<BeamState> {
  static const String route = "/posts";
  static const String singlePostRoute = "$route/:postId";

  @override
  List<Pattern> get pathPatterns => [
        route,
        singlePostRoute,
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        child: const PostsPage(),
        key: const ValueKey(route),
        title: "page_title.posts".tr(),
        type: BeamPageType.fadeTransition,
      ),
      if (state.pathPatternSegments.contains(":postId"))
        BeamPage(
          child: PostPage(
            postId: state.pathParameters["postId"] ?? "",
          ),
          key: ValueKey("$route-${state.pathParameters['postId']}"),
          title: getPostTitle(state),
          type: BeamPageType.fadeTransition,
        ),
    ];
  }

  String getPostTitle(BeamState state) {
    final Object? routeState = state.routeState;

    if (routeState == null) {
      return "page_title.post".tr();
    }

    final Map mapState = routeState as Map;
    if (mapState.containsKey("postName")) {
      return "page_title.any".tr(args: [mapState["postName"]]);
    }

    return "page_title.post".tr();
  }
}
