import 'package:rootasjey/router/app_router.gr.dart';
import 'package:rootasjey/state/user.dart';
import 'package:auto_route/auto_route.dart';

class NoAuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    if (!stateUser.isUserConnected) {
      resolver.next(true);
      return;
    }

    router.root.replace(HomeRoute());
  }
}
