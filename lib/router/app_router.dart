import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:rootasjey/router/auth_guard.dart';
import 'package:rootasjey/router/no_auth_guard.dart';

import 'package:rootasjey/screens/about.dart';
import 'package:rootasjey/screens/contact.dart';
import 'package:rootasjey/screens/dashboard_page.dart';
import 'package:rootasjey/screens/delete_account.dart';
import 'package:rootasjey/screens/forgot_password.dart';
import 'package:rootasjey/screens/home.dart';
import 'package:rootasjey/screens/settings.dart';
import 'package:rootasjey/screens/tos.dart';
import 'package:rootasjey/screens/undefined_page.dart';

import 'package:rootasjey/screens/signin.dart';
import 'package:rootasjey/screens/signup.dart';
import 'package:rootasjey/screens/update_email.dart';
import 'package:rootasjey/screens/update_password.dart';
import 'package:rootasjey/screens/update_username.dart';

@MaterialAutoRouter(
  routes: [
    AutoRoute(path: '/', page: Home),
    MaterialRoute(path: '/about', page: About),
    MaterialRoute(path: '/contact', page: Contact),
    AutoRoute(
      path: '/dashboard',
      page: DashboardPage,
      guards: [AuthGuard],
      children: [
        RedirectRoute(path: '', redirectTo: 'settings'),
        AutoRoute(
          path: 'settings',
          page: EmptyRouterPage,
          name: 'DashboardSettingsDeepRoute',
          children: [
            MaterialRoute(
              path: '',
              page: Settings,
              name: 'DashboardSettingsRoute',
            ),
            AutoRoute(path: 'delete/account', page: DeleteAccount),
            AutoRoute(
              path: 'update',
              page: EmptyRouterPage,
              name: 'AccountUpdateDeepRoute',
              children: [
                MaterialRoute(path: 'email', page: UpdateEmail),
                MaterialRoute(path: 'password', page: UpdatePassword),
                MaterialRoute(path: 'username', page: UpdateUsername),
              ],
            ),
          ],
        ),
      ],
    ),
    MaterialRoute(path: '/forgotpassword', page: ForgotPassword),
    MaterialRoute(path: '/settings', page: Settings),
    // MaterialRoute(path: '/search', page: Search),
    MaterialRoute(path: '/signin', page: Signin, guards: [NoAuthGuard]),
    MaterialRoute(path: '/signup', page: Signup, guards: [NoAuthGuard]),
    MaterialRoute(
      path: '/signout',
      page: EmptyRouterPage,
      name: 'SignOutRoute',
    ),
    AutoRoute(
      path: '/ext',
      page: EmptyRouterPage,
      name: 'ExtDeepRoute',
      children: [
        MaterialRoute(
          path: 'github',
          page: EmptyRouterPage,
          name: 'GitHubRoute',
        ),
        // MaterialRoute(
        //   path: 'android',
        //   page: EmptyRouterPage,
        //   name: 'AndroidAppRoute',
        // ),
        // MaterialRoute(
        //   path: 'ios',
        //   page: EmptyRouterPage,
        //   name: 'IosAppRoute',
        // ),
      ],
    ),
    MaterialRoute(path: '/tos', page: Tos),
    MaterialRoute(path: '*', page: UndefinedPage),
  ],
)
class $AppRouter {}
