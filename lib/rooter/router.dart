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