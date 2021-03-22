import 'package:rootasjey/router/app_router.gr.dart';
import 'package:rootasjey/state/user.dart';
import 'package:auto_route/auto_route.dart';

class NoAuthGuard extends AutoRouteGuard {
  @override
  Future<bool> canNavigate(
    List<PageRouteInfo> pendingRoutes,
    StackRouter router,
  ) async {
    if (!stateUser.isUserConnected) {
      return true;
    }

    router.root.replace(HomeRoute());
    return false;
  }
}
