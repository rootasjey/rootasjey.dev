// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as _i2;

import '../screens/about_me_page.dart' as _i13;
import '../screens/about_page.dart' as _i6;
import '../screens/activities_page.dart' as _i7;
import '../screens/contact_page.dart' as _i8;
import '../screens/cv_page.dart' as _i9;
import '../screens/dashboard_page.dart' as _i10;
import '../screens/delete_account_page.dart' as _i35;
import '../screens/draft_posts_page.dart' as _i26;
import '../screens/draft_projects_page.dart' as _i32;
import '../screens/edit_image_page.dart' as _i34;
import '../screens/edit_post_page.dart' as _i23;
import '../screens/edit_project_page.dart' as _i29;
import '../screens/enroll_page.dart' as _i11;
import '../screens/forgot_password_page.dart' as _i12;
import '../screens/home_page.dart' as _i5;
import '../screens/my_posts_page.dart' as _i21;
import '../screens/my_profile_page.dart' as _i33;
import '../screens/my_projects_page.dart' as _i27;
import '../screens/new_post_page.dart' as _i22;
import '../screens/new_project_page.dart' as _i28;
import '../screens/post_page.dart' as _i24;
import '../screens/posts_page.dart' as _i39;
import '../screens/pricing_page.dart' as _i14;
import '../screens/project_page.dart' as _i30;
import '../screens/projects_page.dart' as _i40;
import '../screens/published_posts_page.dart' as _i25;
import '../screens/published_projects_page.dart' as _i31;
import '../screens/search_page.dart' as _i15;
import '../screens/settings_page.dart' as _i16;
import '../screens/signin_page.dart' as _i17;
import '../screens/signup_page.dart' as _i18;
import '../screens/tos_page.dart' as _i19;
import '../screens/undefined_page.dart' as _i20;
import '../screens/update_email_page.dart' as _i36;
import '../screens/update_password_page.dart' as _i37;
import '../screens/update_username_page.dart' as _i38;
import 'auth_guard.dart' as _i3;
import 'no_auth_guard.dart' as _i4;

class AppRouter extends _i1.RootStackRouter {
  AppRouter(
      {_i2.GlobalKey<_i2.NavigatorState> navigatorKey,
      @required this.authGuard,
      @required this.noAuthGuard})
      : super(navigatorKey);

  final _i3.AuthGuard authGuard;

  final _i4.NoAuthGuard noAuthGuard;

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    HomePageRoute.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i5.HomePage();
        },
        transitionsBuilder: _i1.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false),
    AboutPageRoute.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i6.AboutPage();
        },
        transitionsBuilder: _i1.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false),
    ActivitiesPageRoute.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i7.ActivitiesPage();
        },
        transitionsBuilder: _i1.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false),
    ContactPageRoute.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i8.ContactPage();
        },
        transitionsBuilder: _i1.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false),
    CVPageRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i9.CVPage();
        }),
    DashboardPageRoute.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i10.DashboardPage();
        },
        transitionsBuilder: _i1.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false),
    EnrollPageRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i11.EnrollPage();
        }),
    ForgotPasswordPageRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i12.ForgotPasswordPage();
        }),
    AboutMePageRoute.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i13.AboutMePage();
        },
        transitionsBuilder: _i1.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false),
    PostsRouter.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i1.EmptyRouterPage();
        },
        transitionsBuilder: _i1.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false),
    ProjectsRouter.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i1.EmptyRouterPage();
        },
        transitionsBuilder: _i1.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false),
    PricingPageRoute.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i14.PricingPage();
        },
        transitionsBuilder: _i1.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false),
    SearchPageRoute.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i15.SearchPage();
        },
        transitionsBuilder: _i1.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false),
    SettingsPageRoute.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (data) {
          final pathParams = data.pathParams;
          final args = data.argsAs<SettingsPageRouteArgs>(
              orElse: () => SettingsPageRouteArgs(
                  showAppBar: pathParams.getBool('showAppBar', true)));
          return _i16.SettingsPage(key: args.key, showAppBar: args.showAppBar);
        },
        transitionsBuilder: _i1.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false),
    SigninPageRoute.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<SigninPageRouteArgs>(
              orElse: () => const SigninPageRouteArgs());
          return _i17.SigninPage(
              key: args.key, onSigninResult: args.onSigninResult);
        },
        transitionsBuilder: _i1.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false),
    SignupPageRoute.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<SignupPageRouteArgs>(
              orElse: () => const SignupPageRouteArgs());
          return _i18.SignupPage(
              key: args.key, onSignupResult: args.onSignupResult);
        },
        transitionsBuilder: _i1.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false),
    SignOutRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i1.EmptyRouterPage();
        }),
    ExtRouter.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i1.EmptyRouterPage();
        }),
    TosPageRoute.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i19.TosPage();
        },
        transitionsBuilder: _i1.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false),
    UndefinedPageRoute.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i20.UndefinedPage();
        },
        transitionsBuilder: _i1.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false),
    DashPostsRouter.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i1.EmptyRouterPage();
        }),
    DashProjectsRouter.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i1.EmptyRouterPage();
        }),
    DashProfileRouter.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i1.EmptyRouterPage();
        }),
    DashSettingsRouter.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i1.EmptyRouterPage();
        },
        transitionsBuilder: _i1.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false),
    MyPostsPageRoute.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i21.MyPostsPage();
        },
        transitionsBuilder: _i1.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false),
    NewPostPageRoute.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i22.NewPostPage();
        },
        transitionsBuilder: _i1.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false),
    EditPostPageRoute.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (data) {
          final pathParams = data.pathParams;
          final args = data.argsAs<EditPostPageRouteArgs>(
              orElse: () => EditPostPageRouteArgs(
                  postId: pathParams.getString('postId')));
          return _i23.EditPostPage(postId: args.postId);
        },
        transitionsBuilder: _i1.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false),
    DashPostPage.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (data) {
          final pathParams = data.pathParams;
          final args = data.argsAs<DashPostPageArgs>(
              orElse: () =>
                  DashPostPageArgs(postId: pathParams.getString('postId')));
          return _i24.PostPage(postId: args.postId);
        },
        transitionsBuilder: _i1.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false),
    PublishedPostsPageRoute.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i25.PublishedPostsPage();
        },
        opaque: true,
        barrierDismissible: false),
    DraftPostsPageRoute.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i26.DraftPostsPage();
        },
        opaque: true,
        barrierDismissible: false),
    MyProjectsPageRoute.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i27.MyProjectsPage();
        },
        transitionsBuilder: _i1.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false),
    NewProjectPageRoute.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i28.NewProjectPage();
        },
        transitionsBuilder: _i1.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false),
    EditProjectPageRoute.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (data) {
          final pathParams = data.pathParams;
          final args = data.argsAs<EditProjectPageRouteArgs>(
              orElse: () => EditProjectPageRouteArgs(
                  projectId: pathParams.getString('projectId')));
          return _i29.EditProjectPage(projectId: args.projectId);
        },
        transitionsBuilder: _i1.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false),
    DashProjectPage.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (data) {
          final pathParams = data.pathParams;
          final args = data.argsAs<DashProjectPageArgs>(
              orElse: () => DashProjectPageArgs(
                  projectId: pathParams.getString('projectId')));
          return _i30.ProjectPage(projectId: args.projectId);
        },
        transitionsBuilder: _i1.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false),
    PublishedProjectsPageRoute.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i31.PublishedProjectsPage();
        },
        opaque: true,
        barrierDismissible: false),
    DraftProjectsPageRoute.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i32.DraftProjectsPage();
        },
        opaque: true,
        barrierDismissible: false),
    MyProfilePageRoute.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i33.MyProfilePage();
        },
        transitionsBuilder: _i1.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false),
    EditImagePageRoute.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<EditImagePageRouteArgs>(
              orElse: () => const EditImagePageRouteArgs());
          return _i34.EditImagePage(key: args.key, image: args.image);
        },
        transitionsBuilder: _i1.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false),
    DashSettingsRoute.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (data) {
          final pathParams = data.pathParams;
          final args = data.argsAs<DashSettingsRouteArgs>(
              orElse: () => DashSettingsRouteArgs(
                  showAppBar: pathParams.getBool('showAppBar', true)));
          return _i16.SettingsPage(key: args.key, showAppBar: args.showAppBar);
        },
        opaque: true,
        barrierDismissible: false),
    DeleteAccountPageRoute.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i35.DeleteAccountPage();
        },
        transitionsBuilder: _i1.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false),
    DashAccountUpdateRouter.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i1.EmptyRouterPage();
        },
        transitionsBuilder: _i1.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false),
    UpdateEmailPageRoute.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i36.UpdateEmailPage();
        },
        opaque: true,
        barrierDismissible: false),
    UpdatePasswordPageRoute.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i37.UpdatePasswordPage();
        },
        opaque: true,
        barrierDismissible: false),
    UpdateUsernamePageRoute.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i38.UpdateUsernamePage();
        },
        opaque: true,
        barrierDismissible: false),
    PostsPageRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i39.PostsPage();
        }),
    PostPageRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final pathParams = data.pathParams;
          final args = data.argsAs<PostPageRouteArgs>(
              orElse: () =>
                  PostPageRouteArgs(postId: pathParams.getString('postId')));
          return _i24.PostPage(postId: args.postId);
        }),
    ProjectsPageRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i40.ProjectsPage();
        }),
    ProjectPageRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final pathParams = data.pathParams;
          final args = data.argsAs<ProjectPageRouteArgs>(
              orElse: () => ProjectPageRouteArgs(
                  projectId: pathParams.getString('projectId')));
          return _i30.ProjectPage(projectId: args.projectId);
        }),
    GitHubRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i1.EmptyRouterPage();
        })
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig(HomePageRoute.name, path: '/'),
        _i1.RouteConfig(AboutPageRoute.name, path: '/about'),
        _i1.RouteConfig(ActivitiesPageRoute.name, path: '/activities'),
        _i1.RouteConfig(ContactPageRoute.name, path: '/contact'),
        _i1.RouteConfig(CVPageRoute.name, path: '/cv'),
        _i1.RouteConfig(DashboardPageRoute.name, path: '/dashboard', guards: [
          authGuard
        ], children: [
          _i1.RouteConfig(DashPostsRouter.name, path: 'posts', children: [
            _i1.RouteConfig(MyPostsPageRoute.name, path: '', children: [
              _i1.RouteConfig(PublishedPostsPageRoute.name, path: 'published'),
              _i1.RouteConfig(DraftPostsPageRoute.name, path: 'draft'),
              _i1.RouteConfig('*#redirect',
                  path: '*', redirectTo: 'published', fullMatch: true)
            ]),
            _i1.RouteConfig(NewPostPageRoute.name, path: 'new'),
            _i1.RouteConfig(EditPostPageRoute.name, path: 'edit/:postId'),
            _i1.RouteConfig(DashPostPage.name, path: 'preview/:postId'),
            _i1.RouteConfig('*#redirect',
                path: '*', redirectTo: '', fullMatch: true)
          ]),
          _i1.RouteConfig(DashProjectsRouter.name, path: 'projects', children: [
            _i1.RouteConfig(MyProjectsPageRoute.name, path: '', children: [
              _i1.RouteConfig(PublishedProjectsPageRoute.name,
                  path: 'published'),
              _i1.RouteConfig(DraftProjectsPageRoute.name, path: 'draft'),
              _i1.RouteConfig('*#redirect',
                  path: '*', redirectTo: 'published', fullMatch: true)
            ]),
            _i1.RouteConfig(NewProjectPageRoute.name, path: 'new'),
            _i1.RouteConfig(EditProjectPageRoute.name, path: 'edit/:projectId'),
            _i1.RouteConfig(DashProjectPage.name, path: 'preview/:projectId'),
            _i1.RouteConfig('*#redirect',
                path: '*', redirectTo: '', fullMatch: true)
          ]),
          _i1.RouteConfig(DashProfileRouter.name, path: 'profile', children: [
            _i1.RouteConfig(MyProfilePageRoute.name, path: ''),
            _i1.RouteConfig(EditImagePageRoute.name, path: 'edit/pp'),
            _i1.RouteConfig('*#redirect',
                path: '*', redirectTo: '', fullMatch: true)
          ]),
          _i1.RouteConfig(DashSettingsRouter.name, path: 'settings', children: [
            _i1.RouteConfig(DashSettingsRoute.name, path: ''),
            _i1.RouteConfig(DeleteAccountPageRoute.name,
                path: 'delete/account'),
            _i1.RouteConfig(DashAccountUpdateRouter.name,
                path: 'update',
                children: [
                  _i1.RouteConfig(UpdateEmailPageRoute.name, path: 'email'),
                  _i1.RouteConfig(UpdatePasswordPageRoute.name,
                      path: 'password'),
                  _i1.RouteConfig(UpdateUsernamePageRoute.name,
                      path: 'username')
                ])
          ]),
          _i1.RouteConfig('#redirect',
              path: '', redirectTo: 'posts', fullMatch: true)
        ]),
        _i1.RouteConfig(EnrollPageRoute.name, path: '/enroll'),
        _i1.RouteConfig(ForgotPasswordPageRoute.name, path: '/forgotpassword'),
        _i1.RouteConfig(AboutMePageRoute.name, path: '/me'),
        _i1.RouteConfig(PostsRouter.name, path: '/posts', children: [
          _i1.RouteConfig(PostsPageRoute.name, path: ''),
          _i1.RouteConfig(PostPageRoute.name, path: ':postId')
        ]),
        _i1.RouteConfig(ProjectsRouter.name, path: '/projects', children: [
          _i1.RouteConfig(ProjectsPageRoute.name, path: ''),
          _i1.RouteConfig(ProjectPageRoute.name, path: ':projectId')
        ]),
        _i1.RouteConfig(PricingPageRoute.name, path: '/pricing'),
        _i1.RouteConfig(SearchPageRoute.name, path: '/search'),
        _i1.RouteConfig(SettingsPageRoute.name, path: '/settings'),
        _i1.RouteConfig(SigninPageRoute.name,
            path: '/signin', guards: [noAuthGuard]),
        _i1.RouteConfig(SignupPageRoute.name,
            path: '/signup', guards: [noAuthGuard]),
        _i1.RouteConfig(SignOutRoute.name, path: '/signout'),
        _i1.RouteConfig(ExtRouter.name,
            path: '/ext',
            children: [_i1.RouteConfig(GitHubRoute.name, path: 'github')]),
        _i1.RouteConfig(TosPageRoute.name, path: '/tos'),
        _i1.RouteConfig(UndefinedPageRoute.name, path: '*')
      ];
}

class HomePageRoute extends _i1.PageRouteInfo {
  const HomePageRoute() : super(name, path: '/');

  static const String name = 'HomePageRoute';
}

class AboutPageRoute extends _i1.PageRouteInfo {
  const AboutPageRoute() : super(name, path: '/about');

  static const String name = 'AboutPageRoute';
}

class ActivitiesPageRoute extends _i1.PageRouteInfo {
  const ActivitiesPageRoute() : super(name, path: '/activities');

  static const String name = 'ActivitiesPageRoute';
}

class ContactPageRoute extends _i1.PageRouteInfo {
  const ContactPageRoute() : super(name, path: '/contact');

  static const String name = 'ContactPageRoute';
}

class CVPageRoute extends _i1.PageRouteInfo {
  const CVPageRoute() : super(name, path: '/cv');

  static const String name = 'CVPageRoute';
}

class DashboardPageRoute extends _i1.PageRouteInfo {
  const DashboardPageRoute({List<_i1.PageRouteInfo> children})
      : super(name, path: '/dashboard', initialChildren: children);

  static const String name = 'DashboardPageRoute';
}

class EnrollPageRoute extends _i1.PageRouteInfo {
  const EnrollPageRoute() : super(name, path: '/enroll');

  static const String name = 'EnrollPageRoute';
}

class ForgotPasswordPageRoute extends _i1.PageRouteInfo {
  const ForgotPasswordPageRoute() : super(name, path: '/forgotpassword');

  static const String name = 'ForgotPasswordPageRoute';
}

class AboutMePageRoute extends _i1.PageRouteInfo {
  const AboutMePageRoute() : super(name, path: '/me');

  static const String name = 'AboutMePageRoute';
}

class PostsRouter extends _i1.PageRouteInfo {
  const PostsRouter({List<_i1.PageRouteInfo> children})
      : super(name, path: '/posts', initialChildren: children);

  static const String name = 'PostsRouter';
}

class ProjectsRouter extends _i1.PageRouteInfo {
  const ProjectsRouter({List<_i1.PageRouteInfo> children})
      : super(name, path: '/projects', initialChildren: children);

  static const String name = 'ProjectsRouter';
}

class PricingPageRoute extends _i1.PageRouteInfo {
  const PricingPageRoute() : super(name, path: '/pricing');

  static const String name = 'PricingPageRoute';
}

class SearchPageRoute extends _i1.PageRouteInfo {
  const SearchPageRoute() : super(name, path: '/search');

  static const String name = 'SearchPageRoute';
}

class SettingsPageRoute extends _i1.PageRouteInfo<SettingsPageRouteArgs> {
  SettingsPageRoute({_i2.Key key, bool showAppBar = true})
      : super(name,
            path: '/settings',
            args: SettingsPageRouteArgs(key: key, showAppBar: showAppBar));

  static const String name = 'SettingsPageRoute';
}

class SettingsPageRouteArgs {
  const SettingsPageRouteArgs({this.key, this.showAppBar = true});

  final _i2.Key key;

  final bool showAppBar;
}

class SigninPageRoute extends _i1.PageRouteInfo<SigninPageRouteArgs> {
  SigninPageRoute({_i2.Key key, void Function(bool) onSigninResult})
      : super(name,
            path: '/signin',
            args:
                SigninPageRouteArgs(key: key, onSigninResult: onSigninResult));

  static const String name = 'SigninPageRoute';
}

class SigninPageRouteArgs {
  const SigninPageRouteArgs({this.key, this.onSigninResult});

  final _i2.Key key;

  final void Function(bool) onSigninResult;
}

class SignupPageRoute extends _i1.PageRouteInfo<SignupPageRouteArgs> {
  SignupPageRoute({_i2.Key key, void Function(bool) onSignupResult})
      : super(name,
            path: '/signup',
            args:
                SignupPageRouteArgs(key: key, onSignupResult: onSignupResult));

  static const String name = 'SignupPageRoute';
}

class SignupPageRouteArgs {
  const SignupPageRouteArgs({this.key, this.onSignupResult});

  final _i2.Key key;

  final void Function(bool) onSignupResult;
}

class SignOutRoute extends _i1.PageRouteInfo {
  const SignOutRoute() : super(name, path: '/signout');

  static const String name = 'SignOutRoute';
}

class ExtRouter extends _i1.PageRouteInfo {
  const ExtRouter({List<_i1.PageRouteInfo> children})
      : super(name, path: '/ext', initialChildren: children);

  static const String name = 'ExtRouter';
}

class TosPageRoute extends _i1.PageRouteInfo {
  const TosPageRoute() : super(name, path: '/tos');

  static const String name = 'TosPageRoute';
}

class UndefinedPageRoute extends _i1.PageRouteInfo {
  const UndefinedPageRoute() : super(name, path: '*');

  static const String name = 'UndefinedPageRoute';
}

class DashPostsRouter extends _i1.PageRouteInfo {
  const DashPostsRouter({List<_i1.PageRouteInfo> children})
      : super(name, path: 'posts', initialChildren: children);

  static const String name = 'DashPostsRouter';
}

class DashProjectsRouter extends _i1.PageRouteInfo {
  const DashProjectsRouter({List<_i1.PageRouteInfo> children})
      : super(name, path: 'projects', initialChildren: children);

  static const String name = 'DashProjectsRouter';
}

class DashProfileRouter extends _i1.PageRouteInfo {
  const DashProfileRouter({List<_i1.PageRouteInfo> children})
      : super(name, path: 'profile', initialChildren: children);

  static const String name = 'DashProfileRouter';
}

class DashSettingsRouter extends _i1.PageRouteInfo {
  const DashSettingsRouter({List<_i1.PageRouteInfo> children})
      : super(name, path: 'settings', initialChildren: children);

  static const String name = 'DashSettingsRouter';
}

class MyPostsPageRoute extends _i1.PageRouteInfo {
  const MyPostsPageRoute({List<_i1.PageRouteInfo> children})
      : super(name, path: '', initialChildren: children);

  static const String name = 'MyPostsPageRoute';
}

class NewPostPageRoute extends _i1.PageRouteInfo {
  const NewPostPageRoute() : super(name, path: 'new');

  static const String name = 'NewPostPageRoute';
}

class EditPostPageRoute extends _i1.PageRouteInfo<EditPostPageRouteArgs> {
  EditPostPageRoute({String postId})
      : super(name,
            path: 'edit/:postId',
            args: EditPostPageRouteArgs(postId: postId),
            rawPathParams: {'postId': postId});

  static const String name = 'EditPostPageRoute';
}

class EditPostPageRouteArgs {
  const EditPostPageRouteArgs({this.postId});

  final String postId;
}

class DashPostPage extends _i1.PageRouteInfo<DashPostPageArgs> {
  DashPostPage({String postId})
      : super(name,
            path: 'preview/:postId',
            args: DashPostPageArgs(postId: postId),
            rawPathParams: {'postId': postId});

  static const String name = 'DashPostPage';
}

class DashPostPageArgs {
  const DashPostPageArgs({this.postId});

  final String postId;
}

class PublishedPostsPageRoute extends _i1.PageRouteInfo {
  const PublishedPostsPageRoute() : super(name, path: 'published');

  static const String name = 'PublishedPostsPageRoute';
}

class DraftPostsPageRoute extends _i1.PageRouteInfo {
  const DraftPostsPageRoute() : super(name, path: 'draft');

  static const String name = 'DraftPostsPageRoute';
}

class MyProjectsPageRoute extends _i1.PageRouteInfo {
  const MyProjectsPageRoute({List<_i1.PageRouteInfo> children})
      : super(name, path: '', initialChildren: children);

  static const String name = 'MyProjectsPageRoute';
}

class NewProjectPageRoute extends _i1.PageRouteInfo {
  const NewProjectPageRoute() : super(name, path: 'new');

  static const String name = 'NewProjectPageRoute';
}

class EditProjectPageRoute extends _i1.PageRouteInfo<EditProjectPageRouteArgs> {
  EditProjectPageRoute({String projectId})
      : super(name,
            path: 'edit/:projectId',
            args: EditProjectPageRouteArgs(projectId: projectId),
            rawPathParams: {'projectId': projectId});

  static const String name = 'EditProjectPageRoute';
}

class EditProjectPageRouteArgs {
  const EditProjectPageRouteArgs({this.projectId});

  final String projectId;
}

class DashProjectPage extends _i1.PageRouteInfo<DashProjectPageArgs> {
  DashProjectPage({String projectId})
      : super(name,
            path: 'preview/:projectId',
            args: DashProjectPageArgs(projectId: projectId),
            rawPathParams: {'projectId': projectId});

  static const String name = 'DashProjectPage';
}

class DashProjectPageArgs {
  const DashProjectPageArgs({this.projectId});

  final String projectId;
}

class PublishedProjectsPageRoute extends _i1.PageRouteInfo {
  const PublishedProjectsPageRoute() : super(name, path: 'published');

  static const String name = 'PublishedProjectsPageRoute';
}

class DraftProjectsPageRoute extends _i1.PageRouteInfo {
  const DraftProjectsPageRoute() : super(name, path: 'draft');

  static const String name = 'DraftProjectsPageRoute';
}

class MyProfilePageRoute extends _i1.PageRouteInfo {
  const MyProfilePageRoute() : super(name, path: '');

  static const String name = 'MyProfilePageRoute';
}

class EditImagePageRoute extends _i1.PageRouteInfo<EditImagePageRouteArgs> {
  EditImagePageRoute({_i2.Key key, _i2.ImageProvider<Object> image})
      : super(name,
            path: 'edit/pp',
            args: EditImagePageRouteArgs(key: key, image: image));

  static const String name = 'EditImagePageRoute';
}

class EditImagePageRouteArgs {
  const EditImagePageRouteArgs({this.key, this.image});

  final _i2.Key key;

  final _i2.ImageProvider<Object> image;
}

class DashSettingsRoute extends _i1.PageRouteInfo<DashSettingsRouteArgs> {
  DashSettingsRoute({_i2.Key key, bool showAppBar = true})
      : super(name,
            path: '',
            args: DashSettingsRouteArgs(key: key, showAppBar: showAppBar));

  static const String name = 'DashSettingsRoute';
}

class DashSettingsRouteArgs {
  const DashSettingsRouteArgs({this.key, this.showAppBar = true});

  final _i2.Key key;

  final bool showAppBar;
}

class DeleteAccountPageRoute extends _i1.PageRouteInfo {
  const DeleteAccountPageRoute() : super(name, path: 'delete/account');

  static const String name = 'DeleteAccountPageRoute';
}

class DashAccountUpdateRouter extends _i1.PageRouteInfo {
  const DashAccountUpdateRouter({List<_i1.PageRouteInfo> children})
      : super(name, path: 'update', initialChildren: children);

  static const String name = 'DashAccountUpdateRouter';
}

class UpdateEmailPageRoute extends _i1.PageRouteInfo {
  const UpdateEmailPageRoute() : super(name, path: 'email');

  static const String name = 'UpdateEmailPageRoute';
}

class UpdatePasswordPageRoute extends _i1.PageRouteInfo {
  const UpdatePasswordPageRoute() : super(name, path: 'password');

  static const String name = 'UpdatePasswordPageRoute';
}

class UpdateUsernamePageRoute extends _i1.PageRouteInfo {
  const UpdateUsernamePageRoute() : super(name, path: 'username');

  static const String name = 'UpdateUsernamePageRoute';
}

class PostsPageRoute extends _i1.PageRouteInfo {
  const PostsPageRoute() : super(name, path: '');

  static const String name = 'PostsPageRoute';
}

class PostPageRoute extends _i1.PageRouteInfo<PostPageRouteArgs> {
  PostPageRoute({String postId})
      : super(name,
            path: ':postId',
            args: PostPageRouteArgs(postId: postId),
            rawPathParams: {'postId': postId});

  static const String name = 'PostPageRoute';
}

class PostPageRouteArgs {
  const PostPageRouteArgs({this.postId});

  final String postId;
}

class ProjectsPageRoute extends _i1.PageRouteInfo {
  const ProjectsPageRoute() : super(name, path: '');

  static const String name = 'ProjectsPageRoute';
}

class ProjectPageRoute extends _i1.PageRouteInfo<ProjectPageRouteArgs> {
  ProjectPageRoute({String projectId})
      : super(name,
            path: ':projectId',
            args: ProjectPageRouteArgs(projectId: projectId),
            rawPathParams: {'projectId': projectId});

  static const String name = 'ProjectPageRoute';
}

class ProjectPageRouteArgs {
  const ProjectPageRouteArgs({this.projectId});

  final String projectId;
}

class GitHubRoute extends _i1.PageRouteInfo {
  const GitHubRoute() : super(name, path: 'github');

  static const String name = 'GitHubRoute';
}
