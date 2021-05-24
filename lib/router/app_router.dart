import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:rootasjey/router/auth_guard.dart';
import 'package:rootasjey/router/no_auth_guard.dart';
import 'package:rootasjey/screens/about_page.dart';
import 'package:rootasjey/screens/activities_page.dart';
import 'package:rootasjey/screens/contact_page.dart';
import 'package:rootasjey/screens/cv_page.dart';
import 'package:rootasjey/screens/dashboard_page.dart';
import 'package:rootasjey/screens/delete_account_page.dart';
import 'package:rootasjey/screens/draft_posts_page.dart';
import 'package:rootasjey/screens/draft_projects_page.dart';
import 'package:rootasjey/screens/edit_image_page.dart';
import 'package:rootasjey/screens/edit_post_page.dart';
import 'package:rootasjey/screens/edit_project_page.dart';
import 'package:rootasjey/screens/enroll_page.dart';
import 'package:rootasjey/screens/forgot_password_page.dart';
import 'package:rootasjey/screens/home_page.dart';
import 'package:rootasjey/screens/about_me_page.dart';
import 'package:rootasjey/screens/my_posts_page.dart';
import 'package:rootasjey/screens/my_profile_page.dart';
import 'package:rootasjey/screens/my_projects_page.dart';
import 'package:rootasjey/screens/new_post_page.dart';
import 'package:rootasjey/screens/new_project_page.dart';
import 'package:rootasjey/screens/post_page.dart';
import 'package:rootasjey/screens/posts_page.dart';
import 'package:rootasjey/screens/pricing_page.dart';
import 'package:rootasjey/screens/project_page.dart';
import 'package:rootasjey/screens/projects_page.dart';
import 'package:rootasjey/screens/published_posts_page.dart';
import 'package:rootasjey/screens/published_projects_page.dart';
import 'package:rootasjey/screens/search_page.dart';
import 'package:rootasjey/screens/settings_page.dart';
import 'package:rootasjey/screens/tos_page.dart';
import 'package:rootasjey/screens/undefined_page.dart';
import 'package:rootasjey/screens/signin_page.dart';
import 'package:rootasjey/screens/signup_page.dart';
import 'package:rootasjey/screens/update_email_page.dart';
import 'package:rootasjey/screens/update_password_page.dart';
import 'package:rootasjey/screens/update_username_page.dart';

@MaterialAutoRouter(
  routes: [
    CustomRoute(
      path: '/',
      page: HomePage,
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    CustomRoute(
      path: '/about',
      page: AboutPage,
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    CustomRoute(
      path: '/activities',
      page: ActivitiesPage,
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    CustomRoute(
      path: '/contact',
      page: ContactPage,
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    MaterialRoute(path: '/cv', page: CVPage),
    CustomRoute(
      path: '/dashboard',
      page: DashboardPage,
      guards: [AuthGuard],
      transitionsBuilder: TransitionsBuilders.fadeIn,
      children: [
        AutoRoute(
          path: 'posts',
          name: 'DashPostsRouter',
          page: EmptyRouterPage,
          children: [
            AutoRoute(
              path: '',
              page: MyPostsPage,
              children: [
                AutoRoute(path: 'published', page: PublishedPostsPage),
                AutoRoute(path: 'draft', page: DraftPostsPage),
                RedirectRoute(path: '*', redirectTo: 'published'),
              ],
            ),
            AutoRoute(path: 'new', page: NewPostPage),
            AutoRoute(path: 'edit/:postId', page: EditPostPage),
            AutoRoute(
              path: 'preview/:postId',
              name: 'DashPostPage',
              page: PostPage,
            ),
            RedirectRoute(path: '*', redirectTo: ''),
          ],
        ),
        AutoRoute(
          path: 'projects',
          name: 'DashProjectsRouter',
          page: EmptyRouterPage,
          children: [
            AutoRoute(
              path: '',
              page: MyProjectsPage,
              children: [
                AutoRoute(path: 'published', page: PublishedProjectsPage),
                AutoRoute(path: 'draft', page: DraftProjectsPage),
                RedirectRoute(path: '*', redirectTo: 'published'),
              ],
            ),
            AutoRoute(path: 'new', page: NewProjectPage),
            AutoRoute(path: 'edit/:projectId', page: EditProjectPage),
            AutoRoute(
              path: 'preview/:projectId',
              name: 'DashProjectPage',
              page: ProjectPage,
            ),
            RedirectRoute(path: '*', redirectTo: ''),
          ],
        ),
        AutoRoute(
          path: 'profile',
          name: 'DashProfileRouter',
          page: EmptyRouterPage,
          children: [
            AutoRoute(path: '', page: MyProfilePage),
            AutoRoute(path: 'edit/pp', page: EditImagePage),
            RedirectRoute(path: '*', redirectTo: ''),
          ],
        ),
        AutoRoute(
          path: 'settings',
          page: EmptyRouterPage,
          name: 'DashSettingsRouter',
          children: [
            MaterialRoute(
              path: '',
              page: SettingsPage,
              name: 'DashSettingsRoute',
            ),
            AutoRoute(path: 'delete/account', page: DeleteAccountPage),
            CustomRoute(
              path: 'update',
              page: EmptyRouterPage,
              name: 'DashAccountUpdateRouter',
              transitionsBuilder: TransitionsBuilders.fadeIn,
              children: [
                MaterialRoute(path: 'email', page: UpdateEmailPage),
                MaterialRoute(path: 'password', page: UpdatePasswordPage),
                MaterialRoute(path: 'username', page: UpdateUsernamePage),
              ],
            ),
          ],
        ),
        RedirectRoute(path: '', redirectTo: 'posts'),
      ],
    ),
    MaterialRoute(path: '/enroll', page: EnrollPage),
    MaterialRoute(path: '/forgotpassword', page: ForgotPasswordPage),
    CustomRoute(
      path: '/me',
      page: AboutMePage,
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    CustomRoute(
      path: '/posts',
      page: EmptyRouterPage,
      name: 'PostsRouter',
      transitionsBuilder: TransitionsBuilders.fadeIn,
      children: [
        MaterialRoute(path: '', page: PostsPage),
        MaterialRoute(path: ':postId', page: PostPage),
      ],
    ),
    CustomRoute(
      path: '/projects',
      page: EmptyRouterPage,
      name: 'ProjectsRouter',
      transitionsBuilder: TransitionsBuilders.fadeIn,
      children: [
        MaterialRoute(path: '', page: ProjectsPage),
        MaterialRoute(path: ':projectId', page: ProjectPage),
      ],
    ),
    CustomRoute(
      path: '/pricing',
      page: PricingPage,
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    CustomRoute(
      path: '/search',
      page: SearchPage,
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    CustomRoute(
      path: '/settings',
      page: SettingsPage,
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    CustomRoute(
      path: '/signin',
      page: SigninPage,
      guards: [NoAuthGuard],
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    CustomRoute(
      path: '/signup',
      page: SignupPage,
      guards: [NoAuthGuard],
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    MaterialRoute(
      path: '/signout',
      page: EmptyRouterPage,
      name: 'SignOutRoute',
    ),
    AutoRoute(
      path: '/ext',
      page: EmptyRouterPage,
      name: 'ExtRouter',
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
    CustomRoute(
      path: '/tos',
      page: TosPage,
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    CustomRoute(
      path: '*',
      page: UndefinedPage,
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
  ],
)
class $AppRouter {}
