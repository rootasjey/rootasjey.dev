// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i10;
import 'package:flutter/material.dart' as _i38;

import '../screens/about_me_page.dart' as _i9;
import '../screens/about_page.dart' as _i2;
import '../screens/activities_page.dart' as _i3;
import '../screens/contact_page.dart' as _i4;
import '../screens/cv_page.dart' as _i5;
import '../screens/dashboard_page.dart' as _i6;
import '../screens/delete_account_page.dart' as _i32;
import '../screens/draft_posts_page.dart' as _i23;
import '../screens/draft_projects_page.dart' as _i29;
import '../screens/edit_image_page.dart' as _i31;
import '../screens/edit_post_page.dart' as _i20;
import '../screens/edit_project_page.dart' as _i26;
import '../screens/enroll_page.dart' as _i7;
import '../screens/forgot_password_page.dart' as _i8;
import '../screens/home_page.dart' as _i1;
import '../screens/my_posts_page.dart' as _i18;
import '../screens/my_profile_page.dart' as _i30;
import '../screens/my_projects_page.dart' as _i24;
import '../screens/new_post_page.dart' as _i19;
import '../screens/new_project_page.dart' as _i25;
import '../screens/post_page.dart' as _i21;
import '../screens/posts_page.dart' as _i36;
import '../screens/pricing_page.dart' as _i11;
import '../screens/project_page.dart' as _i27;
import '../screens/projects_page.dart' as _i37;
import '../screens/published_posts_page.dart' as _i22;
import '../screens/published_projects_page.dart' as _i28;
import '../screens/search_page.dart' as _i12;
import '../screens/settings_page.dart' as _i13;
import '../screens/signin_page.dart' as _i14;
import '../screens/signup_page.dart' as _i15;
import '../screens/tos_page.dart' as _i16;
import '../screens/undefined_page.dart' as _i17;
import '../screens/update_email_page.dart' as _i33;
import '../screens/update_password_page.dart' as _i34;
import '../screens/update_username_page.dart' as _i35;
import 'auth_guard.dart' as _i39;
import 'no_auth_guard.dart' as _i40;

class AppRouter extends _i10.RootStackRouter {
  AppRouter(
      {_i38.GlobalKey<_i38.NavigatorState> navigatorKey,
      this.authGuard,
      this.noAuthGuard})
      : super(navigatorKey);

  final _i39.AuthGuard authGuard;

  final _i40.NoAuthGuard noAuthGuard;

  @override
  final Map<String, _i10.PageFactory> pagesMap = {
    HomePageRoute.name: (routeData) {
      return _i10.CustomPage<dynamic>(
          routeData: routeData,
          child: _i1.HomePage(),
          transitionsBuilder: _i10.TransitionsBuilders.fadeIn,
          opaque: true,
          barrierDismissible: false);
    },
    AboutPageRoute.name: (routeData) {
      return _i10.CustomPage<dynamic>(
          routeData: routeData,
          child: _i2.AboutPage(),
          transitionsBuilder: _i10.TransitionsBuilders.fadeIn,
          opaque: true,
          barrierDismissible: false);
    },
    ActivitiesPageRoute.name: (routeData) {
      return _i10.CustomPage<dynamic>(
          routeData: routeData,
          child: _i3.ActivitiesPage(),
          transitionsBuilder: _i10.TransitionsBuilders.fadeIn,
          opaque: true,
          barrierDismissible: false);
    },
    ContactPageRoute.name: (routeData) {
      return _i10.CustomPage<dynamic>(
          routeData: routeData,
          child: _i4.ContactPage(),
          transitionsBuilder: _i10.TransitionsBuilders.fadeIn,
          opaque: true,
          barrierDismissible: false);
    },
    CVPageRoute.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
          routeData: routeData, child: _i5.CVPage());
    },
    DashboardPageRoute.name: (routeData) {
      return _i10.CustomPage<dynamic>(
          routeData: routeData,
          child: _i6.DashboardPage(),
          transitionsBuilder: _i10.TransitionsBuilders.fadeIn,
          opaque: true,
          barrierDismissible: false);
    },
    EnrollPageRoute.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
          routeData: routeData, child: _i7.EnrollPage());
    },
    ForgotPasswordPageRoute.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
          routeData: routeData, child: _i8.ForgotPasswordPage());
    },
    AboutMePageRoute.name: (routeData) {
      return _i10.CustomPage<dynamic>(
          routeData: routeData,
          child: _i9.AboutMePage(),
          transitionsBuilder: _i10.TransitionsBuilders.fadeIn,
          opaque: true,
          barrierDismissible: false);
    },
    PostsRouter.name: (routeData) {
      return _i10.CustomPage<dynamic>(
          routeData: routeData,
          child: const _i10.EmptyRouterPage(),
          transitionsBuilder: _i10.TransitionsBuilders.fadeIn,
          opaque: true,
          barrierDismissible: false);
    },
    ProjectsRouter.name: (routeData) {
      return _i10.CustomPage<dynamic>(
          routeData: routeData,
          child: const _i10.EmptyRouterPage(),
          transitionsBuilder: _i10.TransitionsBuilders.fadeIn,
          opaque: true,
          barrierDismissible: false);
    },
    PricingPageRoute.name: (routeData) {
      return _i10.CustomPage<dynamic>(
          routeData: routeData,
          child: _i11.PricingPage(),
          transitionsBuilder: _i10.TransitionsBuilders.fadeIn,
          opaque: true,
          barrierDismissible: false);
    },
    SearchPageRoute.name: (routeData) {
      return _i10.CustomPage<dynamic>(
          routeData: routeData,
          child: _i12.SearchPage(),
          transitionsBuilder: _i10.TransitionsBuilders.fadeIn,
          opaque: true,
          barrierDismissible: false);
    },
    SettingsPageRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<SettingsPageRouteArgs>(
          orElse: () => SettingsPageRouteArgs(
              showAppBar: pathParams.getBool('showAppBar', true)));
      return _i10.CustomPage<dynamic>(
          routeData: routeData,
          child: _i13.SettingsPage(key: args.key, showAppBar: args.showAppBar),
          transitionsBuilder: _i10.TransitionsBuilders.fadeIn,
          opaque: true,
          barrierDismissible: false);
    },
    SigninPageRoute.name: (routeData) {
      final args = routeData.argsAs<SigninPageRouteArgs>(
          orElse: () => const SigninPageRouteArgs());
      return _i10.CustomPage<dynamic>(
          routeData: routeData,
          child: _i14.SigninPage(
              key: args.key, onSigninResult: args.onSigninResult),
          transitionsBuilder: _i10.TransitionsBuilders.fadeIn,
          opaque: true,
          barrierDismissible: false);
    },
    SignupPageRoute.name: (routeData) {
      final args = routeData.argsAs<SignupPageRouteArgs>(
          orElse: () => const SignupPageRouteArgs());
      return _i10.CustomPage<dynamic>(
          routeData: routeData,
          child: _i15.SignupPage(
              key: args.key, onSignupResult: args.onSignupResult),
          transitionsBuilder: _i10.TransitionsBuilders.fadeIn,
          opaque: true,
          barrierDismissible: false);
    },
    SignOutRoute.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i10.EmptyRouterPage());
    },
    ExtRouter.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i10.EmptyRouterPage());
    },
    TosPageRoute.name: (routeData) {
      return _i10.CustomPage<dynamic>(
          routeData: routeData,
          child: _i16.TosPage(),
          transitionsBuilder: _i10.TransitionsBuilders.fadeIn,
          opaque: true,
          barrierDismissible: false);
    },
    UndefinedPageRoute.name: (routeData) {
      return _i10.CustomPage<dynamic>(
          routeData: routeData,
          child: _i17.UndefinedPage(),
          transitionsBuilder: _i10.TransitionsBuilders.fadeIn,
          opaque: true,
          barrierDismissible: false);
    },
    DashPostsRouter.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i10.EmptyRouterPage());
    },
    DashProjectsRouter.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i10.EmptyRouterPage());
    },
    DashProfileRouter.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i10.EmptyRouterPage());
    },
    DashSettingsRouter.name: (routeData) {
      return _i10.CustomPage<dynamic>(
          routeData: routeData,
          child: const _i10.EmptyRouterPage(),
          transitionsBuilder: _i10.TransitionsBuilders.fadeIn,
          opaque: true,
          barrierDismissible: false);
    },
    MyPostsPageRoute.name: (routeData) {
      return _i10.CustomPage<dynamic>(
          routeData: routeData,
          child: _i18.MyPostsPage(),
          transitionsBuilder: _i10.TransitionsBuilders.fadeIn,
          opaque: true,
          barrierDismissible: false);
    },
    NewPostPageRoute.name: (routeData) {
      return _i10.CustomPage<dynamic>(
          routeData: routeData,
          child: _i19.NewPostPage(),
          transitionsBuilder: _i10.TransitionsBuilders.fadeIn,
          opaque: true,
          barrierDismissible: false);
    },
    EditPostPageRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<EditPostPageRouteArgs>(
          orElse: () =>
              EditPostPageRouteArgs(postId: pathParams.getString('postId')));
      return _i10.CustomPage<dynamic>(
          routeData: routeData,
          child: _i20.EditPostPage(postId: args.postId),
          transitionsBuilder: _i10.TransitionsBuilders.fadeIn,
          opaque: true,
          barrierDismissible: false);
    },
    DashPostPage.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<DashPostPageArgs>(
          orElse: () =>
              DashPostPageArgs(postId: pathParams.getString('postId')));
      return _i10.CustomPage<dynamic>(
          routeData: routeData,
          child: _i21.PostPage(postId: args.postId),
          transitionsBuilder: _i10.TransitionsBuilders.fadeIn,
          opaque: true,
          barrierDismissible: false);
    },
    PublishedPostsPageRoute.name: (routeData) {
      return _i10.CustomPage<dynamic>(
          routeData: routeData,
          child: _i22.PublishedPostsPage(),
          opaque: true,
          barrierDismissible: false);
    },
    DraftPostsPageRoute.name: (routeData) {
      return _i10.CustomPage<dynamic>(
          routeData: routeData,
          child: _i23.DraftPostsPage(),
          opaque: true,
          barrierDismissible: false);
    },
    MyProjectsPageRoute.name: (routeData) {
      return _i10.CustomPage<dynamic>(
          routeData: routeData,
          child: _i24.MyProjectsPage(),
          transitionsBuilder: _i10.TransitionsBuilders.fadeIn,
          opaque: true,
          barrierDismissible: false);
    },
    NewProjectPageRoute.name: (routeData) {
      return _i10.CustomPage<dynamic>(
          routeData: routeData,
          child: _i25.NewProjectPage(),
          transitionsBuilder: _i10.TransitionsBuilders.fadeIn,
          opaque: true,
          barrierDismissible: false);
    },
    EditProjectPageRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<EditProjectPageRouteArgs>(
          orElse: () => EditProjectPageRouteArgs(
              projectId: pathParams.getString('projectId')));
      return _i10.CustomPage<dynamic>(
          routeData: routeData,
          child: _i26.EditProjectPage(projectId: args.projectId),
          transitionsBuilder: _i10.TransitionsBuilders.fadeIn,
          opaque: true,
          barrierDismissible: false);
    },
    DashProjectPage.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<DashProjectPageArgs>(
          orElse: () => DashProjectPageArgs(
              projectId: pathParams.getString('projectId')));
      return _i10.CustomPage<dynamic>(
          routeData: routeData,
          child: _i27.ProjectPage(projectId: args.projectId),
          transitionsBuilder: _i10.TransitionsBuilders.fadeIn,
          opaque: true,
          barrierDismissible: false);
    },
    PublishedProjectsPageRoute.name: (routeData) {
      return _i10.CustomPage<dynamic>(
          routeData: routeData,
          child: _i28.PublishedProjectsPage(),
          opaque: true,
          barrierDismissible: false);
    },
    DraftProjectsPageRoute.name: (routeData) {
      return _i10.CustomPage<dynamic>(
          routeData: routeData,
          child: const _i29.DraftProjectsPage(),
          opaque: true,
          barrierDismissible: false);
    },
    MyProfilePageRoute.name: (routeData) {
      return _i10.CustomPage<dynamic>(
          routeData: routeData,
          child: _i30.MyProfilePage(),
          transitionsBuilder: _i10.TransitionsBuilders.fadeIn,
          opaque: true,
          barrierDismissible: false);
    },
    EditImagePageRoute.name: (routeData) {
      final args = routeData.argsAs<EditImagePageRouteArgs>(
          orElse: () => const EditImagePageRouteArgs());
      return _i10.CustomPage<dynamic>(
          routeData: routeData,
          child: _i31.EditImagePage(key: args.key, image: args.image),
          transitionsBuilder: _i10.TransitionsBuilders.fadeIn,
          opaque: true,
          barrierDismissible: false);
    },
    DashSettingsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<DashSettingsRouteArgs>(
          orElse: () => DashSettingsRouteArgs(
              showAppBar: pathParams.getBool('showAppBar', true)));
      return _i10.CustomPage<dynamic>(
          routeData: routeData,
          child: _i13.SettingsPage(key: args.key, showAppBar: args.showAppBar),
          opaque: true,
          barrierDismissible: false);
    },
    DeleteAccountPageRoute.name: (routeData) {
      return _i10.CustomPage<dynamic>(
          routeData: routeData,
          child: _i32.DeleteAccountPage(),
          transitionsBuilder: _i10.TransitionsBuilders.fadeIn,
          opaque: true,
          barrierDismissible: false);
    },
    DashAccountUpdateRouter.name: (routeData) {
      return _i10.CustomPage<dynamic>(
          routeData: routeData,
          child: const _i10.EmptyRouterPage(),
          transitionsBuilder: _i10.TransitionsBuilders.fadeIn,
          opaque: true,
          barrierDismissible: false);
    },
    UpdateEmailPageRoute.name: (routeData) {
      return _i10.CustomPage<dynamic>(
          routeData: routeData,
          child: _i33.UpdateEmailPage(),
          opaque: true,
          barrierDismissible: false);
    },
    UpdatePasswordPageRoute.name: (routeData) {
      return _i10.CustomPage<dynamic>(
          routeData: routeData,
          child: _i34.UpdatePasswordPage(),
          opaque: true,
          barrierDismissible: false);
    },
    UpdateUsernamePageRoute.name: (routeData) {
      return _i10.CustomPage<dynamic>(
          routeData: routeData,
          child: _i35.UpdateUsernamePage(),
          opaque: true,
          barrierDismissible: false);
    },
    PostsPageRoute.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
          routeData: routeData, child: _i36.PostsPage());
    },
    PostPageRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<PostPageRouteArgs>(
          orElse: () =>
              PostPageRouteArgs(postId: pathParams.getString('postId')));
      return _i10.MaterialPageX<dynamic>(
          routeData: routeData, child: _i21.PostPage(postId: args.postId));
    },
    ProjectsPageRoute.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
          routeData: routeData, child: _i37.ProjectsPage());
    },
    ProjectPageRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ProjectPageRouteArgs>(
          orElse: () => ProjectPageRouteArgs(
              projectId: pathParams.getString('projectId')));
      return _i10.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i27.ProjectPage(projectId: args.projectId));
    },
    GitHubRoute.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i10.EmptyRouterPage());
    }
  };

  @override
  List<_i10.RouteConfig> get routes => [
        _i10.RouteConfig(HomePageRoute.name, path: '/'),
        _i10.RouteConfig(AboutPageRoute.name, path: '/about'),
        _i10.RouteConfig(ActivitiesPageRoute.name, path: '/activities'),
        _i10.RouteConfig(ContactPageRoute.name, path: '/contact'),
        _i10.RouteConfig(CVPageRoute.name, path: '/cv'),
        _i10.RouteConfig(DashboardPageRoute.name, path: '/dashboard', guards: [
          authGuard
        ], children: [
          _i10.RouteConfig(DashPostsRouter.name,
              path: 'posts',
              parent: DashboardPageRoute.name,
              children: [
                _i10.RouteConfig(MyPostsPageRoute.name,
                    path: '',
                    parent: DashPostsRouter.name,
                    children: [
                      _i10.RouteConfig(PublishedPostsPageRoute.name,
                          path: 'published', parent: MyPostsPageRoute.name),
                      _i10.RouteConfig(DraftPostsPageRoute.name,
                          path: 'draft', parent: MyPostsPageRoute.name),
                      _i10.RouteConfig('*#redirect',
                          path: '*',
                          parent: MyPostsPageRoute.name,
                          redirectTo: 'published',
                          fullMatch: true)
                    ]),
                _i10.RouteConfig(NewPostPageRoute.name,
                    path: 'new', parent: DashPostsRouter.name),
                _i10.RouteConfig(EditPostPageRoute.name,
                    path: 'edit/:postId', parent: DashPostsRouter.name),
                _i10.RouteConfig(DashPostPage.name,
                    path: 'preview/:postId', parent: DashPostsRouter.name),
                _i10.RouteConfig('*#redirect',
                    path: '*',
                    parent: DashPostsRouter.name,
                    redirectTo: '',
                    fullMatch: true)
              ]),
          _i10.RouteConfig(DashProjectsRouter.name,
              path: 'projects',
              parent: DashboardPageRoute.name,
              children: [
                _i10.RouteConfig(MyProjectsPageRoute.name,
                    path: '',
                    parent: DashProjectsRouter.name,
                    children: [
                      _i10.RouteConfig(PublishedProjectsPageRoute.name,
                          path: 'published', parent: MyProjectsPageRoute.name),
                      _i10.RouteConfig(DraftProjectsPageRoute.name,
                          path: 'draft', parent: MyProjectsPageRoute.name),
                      _i10.RouteConfig('*#redirect',
                          path: '*',
                          parent: MyProjectsPageRoute.name,
                          redirectTo: 'published',
                          fullMatch: true)
                    ]),
                _i10.RouteConfig(NewProjectPageRoute.name,
                    path: 'new', parent: DashProjectsRouter.name),
                _i10.RouteConfig(EditProjectPageRoute.name,
                    path: 'edit/:projectId', parent: DashProjectsRouter.name),
                _i10.RouteConfig(DashProjectPage.name,
                    path: 'preview/:projectId',
                    parent: DashProjectsRouter.name),
                _i10.RouteConfig('*#redirect',
                    path: '*',
                    parent: DashProjectsRouter.name,
                    redirectTo: '',
                    fullMatch: true)
              ]),
          _i10.RouteConfig(DashProfileRouter.name,
              path: 'profile',
              parent: DashboardPageRoute.name,
              children: [
                _i10.RouteConfig(MyProfilePageRoute.name,
                    path: '', parent: DashProfileRouter.name),
                _i10.RouteConfig(EditImagePageRoute.name,
                    path: 'edit/pp', parent: DashProfileRouter.name),
                _i10.RouteConfig('*#redirect',
                    path: '*',
                    parent: DashProfileRouter.name,
                    redirectTo: '',
                    fullMatch: true)
              ]),
          _i10.RouteConfig(DashSettingsRouter.name,
              path: 'settings',
              parent: DashboardPageRoute.name,
              children: [
                _i10.RouteConfig(DashSettingsRoute.name,
                    path: '', parent: DashSettingsRouter.name),
                _i10.RouteConfig(DeleteAccountPageRoute.name,
                    path: 'delete/account', parent: DashSettingsRouter.name),
                _i10.RouteConfig(DashAccountUpdateRouter.name,
                    path: 'update',
                    parent: DashSettingsRouter.name,
                    children: [
                      _i10.RouteConfig(UpdateEmailPageRoute.name,
                          path: 'email', parent: DashAccountUpdateRouter.name),
                      _i10.RouteConfig(UpdatePasswordPageRoute.name,
                          path: 'password',
                          parent: DashAccountUpdateRouter.name),
                      _i10.RouteConfig(UpdateUsernamePageRoute.name,
                          path: 'username',
                          parent: DashAccountUpdateRouter.name)
                    ])
              ]),
          _i10.RouteConfig('#redirect',
              path: '',
              parent: DashboardPageRoute.name,
              redirectTo: 'posts',
              fullMatch: true)
        ]),
        _i10.RouteConfig(EnrollPageRoute.name, path: '/enroll'),
        _i10.RouteConfig(ForgotPasswordPageRoute.name, path: '/forgotpassword'),
        _i10.RouteConfig(AboutMePageRoute.name, path: '/me'),
        _i10.RouteConfig(PostsRouter.name, path: '/posts', children: [
          _i10.RouteConfig(PostsPageRoute.name,
              path: '', parent: PostsRouter.name),
          _i10.RouteConfig(PostPageRoute.name,
              path: ':postId', parent: PostsRouter.name)
        ]),
        _i10.RouteConfig(ProjectsRouter.name, path: '/projects', children: [
          _i10.RouteConfig(ProjectsPageRoute.name,
              path: '', parent: ProjectsRouter.name),
          _i10.RouteConfig(ProjectPageRoute.name,
              path: ':projectId', parent: ProjectsRouter.name)
        ]),
        _i10.RouteConfig(PricingPageRoute.name, path: '/pricing'),
        _i10.RouteConfig(SearchPageRoute.name, path: '/search'),
        _i10.RouteConfig(SettingsPageRoute.name, path: '/settings'),
        _i10.RouteConfig(SigninPageRoute.name,
            path: '/signin', guards: [noAuthGuard]),
        _i10.RouteConfig(SignupPageRoute.name,
            path: '/signup', guards: [noAuthGuard]),
        _i10.RouteConfig(SignOutRoute.name, path: '/signout'),
        _i10.RouteConfig(ExtRouter.name, path: '/ext', children: [
          _i10.RouteConfig(GitHubRoute.name,
              path: 'github', parent: ExtRouter.name)
        ]),
        _i10.RouteConfig(TosPageRoute.name, path: '/tos'),
        _i10.RouteConfig(UndefinedPageRoute.name, path: '*')
      ];
}

/// generated route for [_i1.HomePage]
class HomePageRoute extends _i10.PageRouteInfo<void> {
  const HomePageRoute() : super(name, path: '/');

  static const String name = 'HomePageRoute';
}

/// generated route for [_i2.AboutPage]
class AboutPageRoute extends _i10.PageRouteInfo<void> {
  const AboutPageRoute() : super(name, path: '/about');

  static const String name = 'AboutPageRoute';
}

/// generated route for [_i3.ActivitiesPage]
class ActivitiesPageRoute extends _i10.PageRouteInfo<void> {
  const ActivitiesPageRoute() : super(name, path: '/activities');

  static const String name = 'ActivitiesPageRoute';
}

/// generated route for [_i4.ContactPage]
class ContactPageRoute extends _i10.PageRouteInfo<void> {
  const ContactPageRoute() : super(name, path: '/contact');

  static const String name = 'ContactPageRoute';
}

/// generated route for [_i5.CVPage]
class CVPageRoute extends _i10.PageRouteInfo<void> {
  const CVPageRoute() : super(name, path: '/cv');

  static const String name = 'CVPageRoute';
}

/// generated route for [_i6.DashboardPage]
class DashboardPageRoute extends _i10.PageRouteInfo<void> {
  const DashboardPageRoute({List<_i10.PageRouteInfo> children})
      : super(name, path: '/dashboard', initialChildren: children);

  static const String name = 'DashboardPageRoute';
}

/// generated route for [_i7.EnrollPage]
class EnrollPageRoute extends _i10.PageRouteInfo<void> {
  const EnrollPageRoute() : super(name, path: '/enroll');

  static const String name = 'EnrollPageRoute';
}

/// generated route for [_i8.ForgotPasswordPage]
class ForgotPasswordPageRoute extends _i10.PageRouteInfo<void> {
  const ForgotPasswordPageRoute() : super(name, path: '/forgotpassword');

  static const String name = 'ForgotPasswordPageRoute';
}

/// generated route for [_i9.AboutMePage]
class AboutMePageRoute extends _i10.PageRouteInfo<void> {
  const AboutMePageRoute() : super(name, path: '/me');

  static const String name = 'AboutMePageRoute';
}

/// generated route for [_i10.EmptyRouterPage]
class PostsRouter extends _i10.PageRouteInfo<void> {
  const PostsRouter({List<_i10.PageRouteInfo> children})
      : super(name, path: '/posts', initialChildren: children);

  static const String name = 'PostsRouter';
}

/// generated route for [_i10.EmptyRouterPage]
class ProjectsRouter extends _i10.PageRouteInfo<void> {
  const ProjectsRouter({List<_i10.PageRouteInfo> children})
      : super(name, path: '/projects', initialChildren: children);

  static const String name = 'ProjectsRouter';
}

/// generated route for [_i11.PricingPage]
class PricingPageRoute extends _i10.PageRouteInfo<void> {
  const PricingPageRoute() : super(name, path: '/pricing');

  static const String name = 'PricingPageRoute';
}

/// generated route for [_i12.SearchPage]
class SearchPageRoute extends _i10.PageRouteInfo<void> {
  const SearchPageRoute() : super(name, path: '/search');

  static const String name = 'SearchPageRoute';
}

/// generated route for [_i13.SettingsPage]
class SettingsPageRoute extends _i10.PageRouteInfo<SettingsPageRouteArgs> {
  SettingsPageRoute({_i38.Key key, bool showAppBar = true})
      : super(name,
            path: '/settings',
            args: SettingsPageRouteArgs(key: key, showAppBar: showAppBar),
            rawPathParams: {'showAppBar': showAppBar});

  static const String name = 'SettingsPageRoute';
}

class SettingsPageRouteArgs {
  const SettingsPageRouteArgs({this.key, this.showAppBar = true});

  final _i38.Key key;

  final bool showAppBar;

  @override
  String toString() {
    return 'SettingsPageRouteArgs{key: $key, showAppBar: $showAppBar}';
  }
}

/// generated route for [_i14.SigninPage]
class SigninPageRoute extends _i10.PageRouteInfo<SigninPageRouteArgs> {
  SigninPageRoute({_i38.Key key, void Function(bool) onSigninResult})
      : super(name,
            path: '/signin',
            args:
                SigninPageRouteArgs(key: key, onSigninResult: onSigninResult));

  static const String name = 'SigninPageRoute';
}

class SigninPageRouteArgs {
  const SigninPageRouteArgs({this.key, this.onSigninResult});

  final _i38.Key key;

  final void Function(bool) onSigninResult;

  @override
  String toString() {
    return 'SigninPageRouteArgs{key: $key, onSigninResult: $onSigninResult}';
  }
}

/// generated route for [_i15.SignupPage]
class SignupPageRoute extends _i10.PageRouteInfo<SignupPageRouteArgs> {
  SignupPageRoute({_i38.Key key, void Function(bool) onSignupResult})
      : super(name,
            path: '/signup',
            args:
                SignupPageRouteArgs(key: key, onSignupResult: onSignupResult));

  static const String name = 'SignupPageRoute';
}

class SignupPageRouteArgs {
  const SignupPageRouteArgs({this.key, this.onSignupResult});

  final _i38.Key key;

  final void Function(bool) onSignupResult;

  @override
  String toString() {
    return 'SignupPageRouteArgs{key: $key, onSignupResult: $onSignupResult}';
  }
}

/// generated route for [_i10.EmptyRouterPage]
class SignOutRoute extends _i10.PageRouteInfo<void> {
  const SignOutRoute() : super(name, path: '/signout');

  static const String name = 'SignOutRoute';
}

/// generated route for [_i10.EmptyRouterPage]
class ExtRouter extends _i10.PageRouteInfo<void> {
  const ExtRouter({List<_i10.PageRouteInfo> children})
      : super(name, path: '/ext', initialChildren: children);

  static const String name = 'ExtRouter';
}

/// generated route for [_i16.TosPage]
class TosPageRoute extends _i10.PageRouteInfo<void> {
  const TosPageRoute() : super(name, path: '/tos');

  static const String name = 'TosPageRoute';
}

/// generated route for [_i17.UndefinedPage]
class UndefinedPageRoute extends _i10.PageRouteInfo<void> {
  const UndefinedPageRoute() : super(name, path: '*');

  static const String name = 'UndefinedPageRoute';
}

/// generated route for [_i10.EmptyRouterPage]
class DashPostsRouter extends _i10.PageRouteInfo<void> {
  const DashPostsRouter({List<_i10.PageRouteInfo> children})
      : super(name, path: 'posts', initialChildren: children);

  static const String name = 'DashPostsRouter';
}

/// generated route for [_i10.EmptyRouterPage]
class DashProjectsRouter extends _i10.PageRouteInfo<void> {
  const DashProjectsRouter({List<_i10.PageRouteInfo> children})
      : super(name, path: 'projects', initialChildren: children);

  static const String name = 'DashProjectsRouter';
}

/// generated route for [_i10.EmptyRouterPage]
class DashProfileRouter extends _i10.PageRouteInfo<void> {
  const DashProfileRouter({List<_i10.PageRouteInfo> children})
      : super(name, path: 'profile', initialChildren: children);

  static const String name = 'DashProfileRouter';
}

/// generated route for [_i10.EmptyRouterPage]
class DashSettingsRouter extends _i10.PageRouteInfo<void> {
  const DashSettingsRouter({List<_i10.PageRouteInfo> children})
      : super(name, path: 'settings', initialChildren: children);

  static const String name = 'DashSettingsRouter';
}

/// generated route for [_i18.MyPostsPage]
class MyPostsPageRoute extends _i10.PageRouteInfo<void> {
  const MyPostsPageRoute({List<_i10.PageRouteInfo> children})
      : super(name, path: '', initialChildren: children);

  static const String name = 'MyPostsPageRoute';
}

/// generated route for [_i19.NewPostPage]
class NewPostPageRoute extends _i10.PageRouteInfo<void> {
  const NewPostPageRoute() : super(name, path: 'new');

  static const String name = 'NewPostPageRoute';
}

/// generated route for [_i20.EditPostPage]
class EditPostPageRoute extends _i10.PageRouteInfo<EditPostPageRouteArgs> {
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

  @override
  String toString() {
    return 'EditPostPageRouteArgs{postId: $postId}';
  }
}

/// generated route for [_i21.PostPage]
class DashPostPage extends _i10.PageRouteInfo<DashPostPageArgs> {
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

  @override
  String toString() {
    return 'DashPostPageArgs{postId: $postId}';
  }
}

/// generated route for [_i22.PublishedPostsPage]
class PublishedPostsPageRoute extends _i10.PageRouteInfo<void> {
  const PublishedPostsPageRoute() : super(name, path: 'published');

  static const String name = 'PublishedPostsPageRoute';
}

/// generated route for [_i23.DraftPostsPage]
class DraftPostsPageRoute extends _i10.PageRouteInfo<void> {
  const DraftPostsPageRoute() : super(name, path: 'draft');

  static const String name = 'DraftPostsPageRoute';
}

/// generated route for [_i24.MyProjectsPage]
class MyProjectsPageRoute extends _i10.PageRouteInfo<void> {
  const MyProjectsPageRoute({List<_i10.PageRouteInfo> children})
      : super(name, path: '', initialChildren: children);

  static const String name = 'MyProjectsPageRoute';
}

/// generated route for [_i25.NewProjectPage]
class NewProjectPageRoute extends _i10.PageRouteInfo<void> {
  const NewProjectPageRoute() : super(name, path: 'new');

  static const String name = 'NewProjectPageRoute';
}

/// generated route for [_i26.EditProjectPage]
class EditProjectPageRoute
    extends _i10.PageRouteInfo<EditProjectPageRouteArgs> {
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

  @override
  String toString() {
    return 'EditProjectPageRouteArgs{projectId: $projectId}';
  }
}

/// generated route for [_i27.ProjectPage]
class DashProjectPage extends _i10.PageRouteInfo<DashProjectPageArgs> {
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

  @override
  String toString() {
    return 'DashProjectPageArgs{projectId: $projectId}';
  }
}

/// generated route for [_i28.PublishedProjectsPage]
class PublishedProjectsPageRoute extends _i10.PageRouteInfo<void> {
  const PublishedProjectsPageRoute() : super(name, path: 'published');

  static const String name = 'PublishedProjectsPageRoute';
}

/// generated route for [_i29.DraftProjectsPage]
class DraftProjectsPageRoute extends _i10.PageRouteInfo<void> {
  const DraftProjectsPageRoute() : super(name, path: 'draft');

  static const String name = 'DraftProjectsPageRoute';
}

/// generated route for [_i30.MyProfilePage]
class MyProfilePageRoute extends _i10.PageRouteInfo<void> {
  const MyProfilePageRoute() : super(name, path: '');

  static const String name = 'MyProfilePageRoute';
}

/// generated route for [_i31.EditImagePage]
class EditImagePageRoute extends _i10.PageRouteInfo<EditImagePageRouteArgs> {
  EditImagePageRoute({_i38.Key key, _i38.ImageProvider<Object> image})
      : super(name,
            path: 'edit/pp',
            args: EditImagePageRouteArgs(key: key, image: image));

  static const String name = 'EditImagePageRoute';
}

class EditImagePageRouteArgs {
  const EditImagePageRouteArgs({this.key, this.image});

  final _i38.Key key;

  final _i38.ImageProvider<Object> image;

  @override
  String toString() {
    return 'EditImagePageRouteArgs{key: $key, image: $image}';
  }
}

/// generated route for [_i13.SettingsPage]
class DashSettingsRoute extends _i10.PageRouteInfo<DashSettingsRouteArgs> {
  DashSettingsRoute({_i38.Key key, bool showAppBar = true})
      : super(name,
            path: '',
            args: DashSettingsRouteArgs(key: key, showAppBar: showAppBar),
            rawPathParams: {'showAppBar': showAppBar});

  static const String name = 'DashSettingsRoute';
}

class DashSettingsRouteArgs {
  const DashSettingsRouteArgs({this.key, this.showAppBar = true});

  final _i38.Key key;

  final bool showAppBar;

  @override
  String toString() {
    return 'DashSettingsRouteArgs{key: $key, showAppBar: $showAppBar}';
  }
}

/// generated route for [_i32.DeleteAccountPage]
class DeleteAccountPageRoute extends _i10.PageRouteInfo<void> {
  const DeleteAccountPageRoute() : super(name, path: 'delete/account');

  static const String name = 'DeleteAccountPageRoute';
}

/// generated route for [_i10.EmptyRouterPage]
class DashAccountUpdateRouter extends _i10.PageRouteInfo<void> {
  const DashAccountUpdateRouter({List<_i10.PageRouteInfo> children})
      : super(name, path: 'update', initialChildren: children);

  static const String name = 'DashAccountUpdateRouter';
}

/// generated route for [_i33.UpdateEmailPage]
class UpdateEmailPageRoute extends _i10.PageRouteInfo<void> {
  const UpdateEmailPageRoute() : super(name, path: 'email');

  static const String name = 'UpdateEmailPageRoute';
}

/// generated route for [_i34.UpdatePasswordPage]
class UpdatePasswordPageRoute extends _i10.PageRouteInfo<void> {
  const UpdatePasswordPageRoute() : super(name, path: 'password');

  static const String name = 'UpdatePasswordPageRoute';
}

/// generated route for [_i35.UpdateUsernamePage]
class UpdateUsernamePageRoute extends _i10.PageRouteInfo<void> {
  const UpdateUsernamePageRoute() : super(name, path: 'username');

  static const String name = 'UpdateUsernamePageRoute';
}

/// generated route for [_i36.PostsPage]
class PostsPageRoute extends _i10.PageRouteInfo<void> {
  const PostsPageRoute() : super(name, path: '');

  static const String name = 'PostsPageRoute';
}

/// generated route for [_i21.PostPage]
class PostPageRoute extends _i10.PageRouteInfo<PostPageRouteArgs> {
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

  @override
  String toString() {
    return 'PostPageRouteArgs{postId: $postId}';
  }
}

/// generated route for [_i37.ProjectsPage]
class ProjectsPageRoute extends _i10.PageRouteInfo<void> {
  const ProjectsPageRoute() : super(name, path: '');

  static const String name = 'ProjectsPageRoute';
}

/// generated route for [_i27.ProjectPage]
class ProjectPageRoute extends _i10.PageRouteInfo<ProjectPageRouteArgs> {
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

  @override
  String toString() {
    return 'ProjectPageRouteArgs{projectId: $projectId}';
  }
}

/// generated route for [_i10.EmptyRouterPage]
class GitHubRoute extends _i10.PageRouteInfo<void> {
  const GitHubRoute() : super(name, path: 'github');

  static const String name = 'GitHubRoute';
}
