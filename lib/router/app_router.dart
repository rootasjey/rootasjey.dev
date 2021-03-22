import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:rootasjey/router/auth_guard.dart';
import 'package:rootasjey/router/no_auth_guard.dart';

import 'package:rootasjey/screens/about.dart';
import 'package:rootasjey/screens/activities.dart';
import 'package:rootasjey/screens/contact.dart';
import 'package:rootasjey/screens/dashboard_page.dart';
import 'package:rootasjey/screens/delete_account.dart';
import 'package:rootasjey/screens/edit_post.dart';
import 'package:rootasjey/screens/edit_project.dart';
import 'package:rootasjey/screens/enroll.dart';
import 'package:rootasjey/screens/forgot_password.dart';
import 'package:rootasjey/screens/home.dart';
import 'package:rootasjey/screens/about_me.dart';
import 'package:rootasjey/screens/my_posts.dart';
import 'package:rootasjey/screens/my_projects.dart';
import 'package:rootasjey/screens/new_post.dart';
import 'package:rootasjey/screens/new_project.dart';
import 'package:rootasjey/screens/post_page.dart';
import 'package:rootasjey/screens/posts.dart';
import 'package:rootasjey/screens/pricing.dart';
import 'package:rootasjey/screens/project_page.dart';
import 'package:rootasjey/screens/projects.dart';
import 'package:rootasjey/screens/search.dart';
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
    MaterialRoute(path: '/activities', page: Activities),
    MaterialRoute(path: '/contact', page: Contact),
    AutoRoute(
      path: '/dashboard',
      page: DashboardPage,
      guards: [AuthGuard],
      children: [
        RedirectRoute(path: '', redirectTo: 'settings'),
        AutoRoute(
          path: 'new',
          page: EmptyRouterPage,
          name: 'DeepNewPage',
          children: [
            RedirectRoute(path: '', redirectTo: 'post'),
            MaterialRoute(path: 'post', page: NewPost),
            MaterialRoute(path: 'project', page: NewProject),
          ],
        ),
        AutoRoute(
          path: 'edit',
          page: EmptyRouterPage,
          name: 'DeepEditPage',
          children: [
            RedirectRoute(path: '', redirectTo: 'post'),
            MaterialRoute(path: 'post/:postId', page: EditPost),
            MaterialRoute(path: 'project/:projectId', page: EditProject),
          ],
        ),
        MaterialRoute(path: 'posts', page: MyPosts),
        MaterialRoute(path: 'projects', page: MyProjects),
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
    MaterialRoute(path: '/enroll', page: Enroll),
    MaterialRoute(path: '/forgotpassword', page: ForgotPassword),
    CustomRoute(
      path: '/me',
      page: AboutMe,
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    MaterialRoute(
      path: '/posts',
      page: EmptyRouterPage,
      name: 'PostsDeepRoute',
      children: [
        MaterialRoute(path: '', page: Posts),
        MaterialRoute(path: ':postId', page: PostPage),
      ],
    ),
    MaterialRoute(
      path: '/projects',
      page: EmptyRouterPage,
      name: 'ProjectsDeepRoute',
      children: [
        MaterialRoute(path: '', page: Projects),
        MaterialRoute(path: ':projectId', page: ProjectPage),
      ],
    ),
    MaterialRoute(path: '/pricing', page: Pricing),
    MaterialRoute(path: '/search', page: Search),
    MaterialRoute(path: '/settings', page: Settings),
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
