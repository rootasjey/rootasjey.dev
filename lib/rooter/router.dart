import 'package:fluro/fluro.dart';
import 'package:rootasjey/rooter/route_names.dart';
import 'package:rootasjey/rooter/web/route_handlers.dart';

class FluroRouter {
  static Router router = Router();

  static void setupMobileRouter() {}

  static void setupWebRouter() {
    router.define(
      AboutRoute,
      handler: WebRouteHandlers.about,
    );

    router.define(
      ContactRoute,
      handler: WebRouteHandlers.contact,
    );

    router.define(
      DraftsRoute,
      handler: WebRouteHandlers.drafts,
    );

    router.define(
      EditPostRoute,
      handler: WebRouteHandlers.editPost,
    );

    router.define(
      EnrollRoute,
      handler: WebRouteHandlers.enroll,
    );

    router.define(
      MeRoute,
      handler: WebRouteHandlers.me,
    );

    router.define(
      NewPostRoute,
      handler: WebRouteHandlers.newPost,
    );

    router.define(
      PostRoute,
      handler: WebRouteHandlers.post,
    );

    router.define(
      PostsRoute,
      handler: WebRouteHandlers.posts,
    );

    router.define(
      PricingRoute,
      handler: WebRouteHandlers.pricing,
    );

    router.define(
      ProjectsRoute,
      handler: WebRouteHandlers.projects,
    );

    router.define(
      RootRoute,
      handler: WebRouteHandlers.home,
    );

    router.define(
      SearchRoute,
      handler: WebRouteHandlers.search,
    );

    router.define(
      SigninRoute,
      handler: WebRouteHandlers.signin,
    );

    router.define(
      SignupRoute,
      handler: WebRouteHandlers.signup,
    );

    // ?NOTE: Must be the last defined route.
    router.define(
      UndefinedRoute,
      handler: WebRouteHandlers.undefined,
    );
  }
}