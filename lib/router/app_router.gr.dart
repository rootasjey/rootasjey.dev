// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as _i34;

import '../screens/about.dart' as _i5;
import '../screens/about_me.dart' as _i12;
import '../screens/activities.dart' as _i6;
import '../screens/contact.dart' as _i7;
import '../screens/cv_page.dart' as _i8;
import '../screens/dashboard_page.dart' as _i9;
import '../screens/delete_account.dart' as _i26;
import '../screens/edit_post.dart' as _i24;
import '../screens/edit_project.dart' as _i25;
import '../screens/enroll.dart' as _i10;
import '../screens/forgot_password.dart' as _i11;
import '../screens/home.dart' as _i4;
import '../screens/my_posts.dart' as _i20;
import '../screens/my_projects.dart' as _i21;
import '../screens/new_post.dart' as _i22;
import '../screens/new_project.dart' as _i23;
import '../screens/post_page.dart' as _i31;
import '../screens/posts.dart' as _i30;
import '../screens/pricing.dart' as _i13;
import '../screens/project_page.dart' as _i33;
import '../screens/projects.dart' as _i32;
import '../screens/search.dart' as _i14;
import '../screens/settings.dart' as _i15;
import '../screens/signin.dart' as _i16;
import '../screens/signup.dart' as _i17;
import '../screens/tos.dart' as _i18;
import '../screens/undefined_page.dart' as _i19;
import '../screens/update_email.dart' as _i27;
import '../screens/update_password.dart' as _i28;
import '../screens/update_username.dart' as _i29;
import 'auth_guard.dart' as _i2;
import 'no_auth_guard.dart' as _i3;

class AppRouter extends _i1.RootStackRouter {
  AppRouter({@required this.authGuard, @required this.noAuthGuard});

  final _i2.AuthGuard authGuard;

  final _i3.NoAuthGuard noAuthGuard;

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    HomeRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i4.Home());
    },
    AboutRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i5.About());
    },
    ActivitiesRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i6.Activities());
    },
    ContactRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i7.Contact());
    },
    CVPageRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i8.CVPage());
    },
    DashboardPageRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i9.DashboardPage());
    },
    EnrollRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i10.Enroll());
    },
    ForgotPasswordRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i11.ForgotPassword());
    },
    AboutMeRoute.name: (entry) {
      return _i1.CustomPage(
          entry: entry,
          child: _i12.AboutMe(),
          transitionsBuilder: _i1.TransitionsBuilders.fadeIn,
          opaque: true,
          barrierDismissible: false);
    },
    PostsDeepRoute.name: (entry) {
      return _i1.MaterialPageX(
          entry: entry, child: const _i1.EmptyRouterPage());
    },
    ProjectsDeepRoute.name: (entry) {
      return _i1.MaterialPageX(
          entry: entry, child: const _i1.EmptyRouterPage());
    },
    PricingRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i13.Pricing());
    },
    SearchRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i14.Search());
    },
    SettingsRoute.name: (entry) {
      var pathParams = entry.routeData.pathParams;
      var args = entry.routeData.argsAs<SettingsRouteArgs>(
          orElse: () => SettingsRouteArgs(
              showAppBar: pathParams.getBool('showAppBar', true)));
      return _i1.MaterialPageX(
          entry: entry,
          child: _i15.Settings(key: args.key, showAppBar: args.showAppBar));
    },
    SigninRoute.name: (entry) {
      var args = entry.routeData
          .argsAs<SigninRouteArgs>(orElse: () => SigninRouteArgs());
      return _i1.MaterialPageX(
          entry: entry,
          child:
              _i16.Signin(key: args.key, onSigninResult: args.onSigninResult));
    },
    SignupRoute.name: (entry) {
      var args = entry.routeData
          .argsAs<SignupRouteArgs>(orElse: () => SignupRouteArgs());
      return _i1.MaterialPageX(
          entry: entry,
          child:
              _i17.Signup(key: args.key, onSignupResult: args.onSignupResult));
    },
    SignOutRoute.name: (entry) {
      return _i1.MaterialPageX(
          entry: entry, child: const _i1.EmptyRouterPage());
    },
    ExtDeepRoute.name: (entry) {
      return _i1.MaterialPageX(
          entry: entry, child: const _i1.EmptyRouterPage());
    },
    TosRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i18.Tos());
    },
    UndefinedPageRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i19.UndefinedPage());
    },
    DeepNewPage.name: (entry) {
      return _i1.MaterialPageX(
          entry: entry, child: const _i1.EmptyRouterPage());
    },
    DeepEditPage.name: (entry) {
      return _i1.MaterialPageX(
          entry: entry, child: const _i1.EmptyRouterPage());
    },
    MyPostsRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i20.MyPosts());
    },
    MyProjectsRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i21.MyProjects());
    },
    DashboardSettingsDeepRoute.name: (entry) {
      return _i1.MaterialPageX(
          entry: entry, child: const _i1.EmptyRouterPage());
    },
    NewPostRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i22.NewPost());
    },
    NewProjectRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i23.NewProject());
    },
    EditPostRoute.name: (entry) {
      var pathParams = entry.routeData.pathParams;
      var args = entry.routeData.argsAs<EditPostRouteArgs>(
          orElse: () =>
              EditPostRouteArgs(postId: pathParams.getString('postId')));
      return _i1.MaterialPageX(
          entry: entry, child: _i24.EditPost(postId: args.postId));
    },
    EditProjectRoute.name: (entry) {
      var pathParams = entry.routeData.pathParams;
      var args = entry.routeData.argsAs<EditProjectRouteArgs>(
          orElse: () => EditProjectRouteArgs(
              projectId: pathParams.getString('projectId')));
      return _i1.MaterialPageX(
          entry: entry, child: _i25.EditProject(projectId: args.projectId));
    },
    DashboardSettingsRoute.name: (entry) {
      var pathParams = entry.routeData.pathParams;
      var args = entry.routeData.argsAs<DashboardSettingsRouteArgs>(
          orElse: () => DashboardSettingsRouteArgs(
              showAppBar: pathParams.getBool('showAppBar', true)));
      return _i1.MaterialPageX(
          entry: entry,
          child: _i15.Settings(key: args.key, showAppBar: args.showAppBar));
    },
    DeleteAccountRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i26.DeleteAccount());
    },
    AccountUpdateDeepRoute.name: (entry) {
      return _i1.MaterialPageX(
          entry: entry, child: const _i1.EmptyRouterPage());
    },
    UpdateEmailRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i27.UpdateEmail());
    },
    UpdatePasswordRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i28.UpdatePassword());
    },
    UpdateUsernameRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i29.UpdateUsername());
    },
    PostsRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i30.Posts());
    },
    PostPageRoute.name: (entry) {
      var pathParams = entry.routeData.pathParams;
      var args = entry.routeData.argsAs<PostPageRouteArgs>(
          orElse: () =>
              PostPageRouteArgs(postId: pathParams.getString('postId')));
      return _i1.MaterialPageX(
          entry: entry, child: _i31.PostPage(postId: args.postId));
    },
    ProjectsRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i32.Projects());
    },
    ProjectPageRoute.name: (entry) {
      var pathParams = entry.routeData.pathParams;
      var args = entry.routeData.argsAs<ProjectPageRouteArgs>(
          orElse: () => ProjectPageRouteArgs(
              projectId: pathParams.getString('projectId')));
      return _i1.MaterialPageX(
          entry: entry, child: _i33.ProjectPage(projectId: args.projectId));
    },
    GitHubRoute.name: (entry) {
      return _i1.MaterialPageX(
          entry: entry, child: const _i1.EmptyRouterPage());
    }
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig(HomeRoute.name, path: '/'),
        _i1.RouteConfig(AboutRoute.name, path: '/about'),
        _i1.RouteConfig(ActivitiesRoute.name, path: '/activities'),
        _i1.RouteConfig(ContactRoute.name, path: '/contact'),
        _i1.RouteConfig(CVPageRoute.name, path: '/cv'),
        _i1.RouteConfig(DashboardPageRoute.name, path: '/dashboard', guards: [
          authGuard
        ], children: [
          _i1.RouteConfig('#redirect',
              path: '', redirectTo: 'settings', fullMatch: true),
          _i1.RouteConfig(DeepNewPage.name, path: 'new', children: [
            _i1.RouteConfig('#redirect',
                path: '', redirectTo: 'post', fullMatch: true),
            _i1.RouteConfig(NewPostRoute.name, path: 'post'),
            _i1.RouteConfig(NewProjectRoute.name, path: 'project')
          ]),
          _i1.RouteConfig(DeepEditPage.name, path: 'edit', children: [
            _i1.RouteConfig('#redirect',
                path: '', redirectTo: 'post', fullMatch: true),
            _i1.RouteConfig(EditPostRoute.name, path: 'post/:postId'),
            _i1.RouteConfig(EditProjectRoute.name, path: 'project/:projectId')
          ]),
          _i1.RouteConfig(MyPostsRoute.name, path: 'posts'),
          _i1.RouteConfig(MyProjectsRoute.name, path: 'projects'),
          _i1.RouteConfig(DashboardSettingsDeepRoute.name,
              path: 'settings',
              children: [
                _i1.RouteConfig(DashboardSettingsRoute.name, path: ''),
                _i1.RouteConfig(DeleteAccountRoute.name,
                    path: 'delete/account'),
                _i1.RouteConfig(AccountUpdateDeepRoute.name,
                    path: 'update',
                    children: [
                      _i1.RouteConfig(UpdateEmailRoute.name, path: 'email'),
                      _i1.RouteConfig(UpdatePasswordRoute.name,
                          path: 'password'),
                      _i1.RouteConfig(UpdateUsernameRoute.name,
                          path: 'username')
                    ])
              ])
        ]),
        _i1.RouteConfig(EnrollRoute.name, path: '/enroll'),
        _i1.RouteConfig(ForgotPasswordRoute.name, path: '/forgotpassword'),
        _i1.RouteConfig(AboutMeRoute.name, path: '/me'),
        _i1.RouteConfig(PostsDeepRoute.name, path: '/posts', children: [
          _i1.RouteConfig(PostsRoute.name, path: ''),
          _i1.RouteConfig(PostPageRoute.name, path: ':postId')
        ]),
        _i1.RouteConfig(ProjectsDeepRoute.name, path: '/projects', children: [
          _i1.RouteConfig(ProjectsRoute.name, path: ''),
          _i1.RouteConfig(ProjectPageRoute.name, path: ':projectId')
        ]),
        _i1.RouteConfig(PricingRoute.name, path: '/pricing'),
        _i1.RouteConfig(SearchRoute.name, path: '/search'),
        _i1.RouteConfig(SettingsRoute.name, path: '/settings'),
        _i1.RouteConfig(SigninRoute.name,
            path: '/signin', guards: [noAuthGuard]),
        _i1.RouteConfig(SignupRoute.name,
            path: '/signup', guards: [noAuthGuard]),
        _i1.RouteConfig(SignOutRoute.name, path: '/signout'),
        _i1.RouteConfig(ExtDeepRoute.name,
            path: '/ext',
            children: [_i1.RouteConfig(GitHubRoute.name, path: 'github')]),
        _i1.RouteConfig(TosRoute.name, path: '/tos'),
        _i1.RouteConfig(UndefinedPageRoute.name, path: '*')
      ];
}

class HomeRoute extends _i1.PageRouteInfo {
  const HomeRoute() : super(name, path: '/');

  static const String name = 'HomeRoute';
}

class AboutRoute extends _i1.PageRouteInfo {
  const AboutRoute() : super(name, path: '/about');

  static const String name = 'AboutRoute';
}

class ActivitiesRoute extends _i1.PageRouteInfo {
  const ActivitiesRoute() : super(name, path: '/activities');

  static const String name = 'ActivitiesRoute';
}

class ContactRoute extends _i1.PageRouteInfo {
  const ContactRoute() : super(name, path: '/contact');

  static const String name = 'ContactRoute';
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

class EnrollRoute extends _i1.PageRouteInfo {
  const EnrollRoute() : super(name, path: '/enroll');

  static const String name = 'EnrollRoute';
}

class ForgotPasswordRoute extends _i1.PageRouteInfo {
  const ForgotPasswordRoute() : super(name, path: '/forgotpassword');

  static const String name = 'ForgotPasswordRoute';
}

class AboutMeRoute extends _i1.PageRouteInfo {
  const AboutMeRoute() : super(name, path: '/me');

  static const String name = 'AboutMeRoute';
}

class PostsDeepRoute extends _i1.PageRouteInfo {
  const PostsDeepRoute({List<_i1.PageRouteInfo> children})
      : super(name, path: '/posts', initialChildren: children);

  static const String name = 'PostsDeepRoute';
}

class ProjectsDeepRoute extends _i1.PageRouteInfo {
  const ProjectsDeepRoute({List<_i1.PageRouteInfo> children})
      : super(name, path: '/projects', initialChildren: children);

  static const String name = 'ProjectsDeepRoute';
}

class PricingRoute extends _i1.PageRouteInfo {
  const PricingRoute() : super(name, path: '/pricing');

  static const String name = 'PricingRoute';
}

class SearchRoute extends _i1.PageRouteInfo {
  const SearchRoute() : super(name, path: '/search');

  static const String name = 'SearchRoute';
}

class SettingsRoute extends _i1.PageRouteInfo<SettingsRouteArgs> {
  SettingsRoute({_i34.Key key, bool showAppBar = true})
      : super(name,
            path: '/settings',
            args: SettingsRouteArgs(key: key, showAppBar: showAppBar),
            params: {'showAppBar': showAppBar});

  static const String name = 'SettingsRoute';
}

class SettingsRouteArgs {
  const SettingsRouteArgs({this.key, this.showAppBar = true});

  final _i34.Key key;

  final bool showAppBar;
}

class SigninRoute extends _i1.PageRouteInfo<SigninRouteArgs> {
  SigninRoute({_i34.Key key, void Function(bool) onSigninResult})
      : super(name,
            path: '/signin',
            args: SigninRouteArgs(key: key, onSigninResult: onSigninResult));

  static const String name = 'SigninRoute';
}

class SigninRouteArgs {
  const SigninRouteArgs({this.key, this.onSigninResult});

  final _i34.Key key;

  final void Function(bool) onSigninResult;
}

class SignupRoute extends _i1.PageRouteInfo<SignupRouteArgs> {
  SignupRoute({_i34.Key key, void Function(bool) onSignupResult})
      : super(name,
            path: '/signup',
            args: SignupRouteArgs(key: key, onSignupResult: onSignupResult));

  static const String name = 'SignupRoute';
}

class SignupRouteArgs {
  const SignupRouteArgs({this.key, this.onSignupResult});

  final _i34.Key key;

  final void Function(bool) onSignupResult;
}

class SignOutRoute extends _i1.PageRouteInfo {
  const SignOutRoute() : super(name, path: '/signout');

  static const String name = 'SignOutRoute';
}

class ExtDeepRoute extends _i1.PageRouteInfo {
  const ExtDeepRoute({List<_i1.PageRouteInfo> children})
      : super(name, path: '/ext', initialChildren: children);

  static const String name = 'ExtDeepRoute';
}

class TosRoute extends _i1.PageRouteInfo {
  const TosRoute() : super(name, path: '/tos');

  static const String name = 'TosRoute';
}

class UndefinedPageRoute extends _i1.PageRouteInfo {
  const UndefinedPageRoute() : super(name, path: '*');

  static const String name = 'UndefinedPageRoute';
}

class DeepNewPage extends _i1.PageRouteInfo {
  const DeepNewPage({List<_i1.PageRouteInfo> children})
      : super(name, path: 'new', initialChildren: children);

  static const String name = 'DeepNewPage';
}

class DeepEditPage extends _i1.PageRouteInfo {
  const DeepEditPage({List<_i1.PageRouteInfo> children})
      : super(name, path: 'edit', initialChildren: children);

  static const String name = 'DeepEditPage';
}

class MyPostsRoute extends _i1.PageRouteInfo {
  const MyPostsRoute() : super(name, path: 'posts');

  static const String name = 'MyPostsRoute';
}

class MyProjectsRoute extends _i1.PageRouteInfo {
  const MyProjectsRoute() : super(name, path: 'projects');

  static const String name = 'MyProjectsRoute';
}

class DashboardSettingsDeepRoute extends _i1.PageRouteInfo {
  const DashboardSettingsDeepRoute({List<_i1.PageRouteInfo> children})
      : super(name, path: 'settings', initialChildren: children);

  static const String name = 'DashboardSettingsDeepRoute';
}

class NewPostRoute extends _i1.PageRouteInfo {
  const NewPostRoute() : super(name, path: 'post');

  static const String name = 'NewPostRoute';
}

class NewProjectRoute extends _i1.PageRouteInfo {
  const NewProjectRoute() : super(name, path: 'project');

  static const String name = 'NewProjectRoute';
}

class EditPostRoute extends _i1.PageRouteInfo<EditPostRouteArgs> {
  EditPostRoute({String postId})
      : super(name,
            path: 'post/:postId',
            args: EditPostRouteArgs(postId: postId),
            params: {'postId': postId});

  static const String name = 'EditPostRoute';
}

class EditPostRouteArgs {
  const EditPostRouteArgs({this.postId});

  final String postId;
}

class EditProjectRoute extends _i1.PageRouteInfo<EditProjectRouteArgs> {
  EditProjectRoute({String projectId})
      : super(name,
            path: 'project/:projectId',
            args: EditProjectRouteArgs(projectId: projectId),
            params: {'projectId': projectId});

  static const String name = 'EditProjectRoute';
}

class EditProjectRouteArgs {
  const EditProjectRouteArgs({this.projectId});

  final String projectId;
}

class DashboardSettingsRoute
    extends _i1.PageRouteInfo<DashboardSettingsRouteArgs> {
  DashboardSettingsRoute({_i34.Key key, bool showAppBar = true})
      : super(name,
            path: '',
            args: DashboardSettingsRouteArgs(key: key, showAppBar: showAppBar),
            params: {'showAppBar': showAppBar});

  static const String name = 'DashboardSettingsRoute';
}

class DashboardSettingsRouteArgs {
  const DashboardSettingsRouteArgs({this.key, this.showAppBar = true});

  final _i34.Key key;

  final bool showAppBar;
}

class DeleteAccountRoute extends _i1.PageRouteInfo {
  const DeleteAccountRoute() : super(name, path: 'delete/account');

  static const String name = 'DeleteAccountRoute';
}

class AccountUpdateDeepRoute extends _i1.PageRouteInfo {
  const AccountUpdateDeepRoute({List<_i1.PageRouteInfo> children})
      : super(name, path: 'update', initialChildren: children);

  static const String name = 'AccountUpdateDeepRoute';
}

class UpdateEmailRoute extends _i1.PageRouteInfo {
  const UpdateEmailRoute() : super(name, path: 'email');

  static const String name = 'UpdateEmailRoute';
}

class UpdatePasswordRoute extends _i1.PageRouteInfo {
  const UpdatePasswordRoute() : super(name, path: 'password');

  static const String name = 'UpdatePasswordRoute';
}

class UpdateUsernameRoute extends _i1.PageRouteInfo {
  const UpdateUsernameRoute() : super(name, path: 'username');

  static const String name = 'UpdateUsernameRoute';
}

class PostsRoute extends _i1.PageRouteInfo {
  const PostsRoute() : super(name, path: '');

  static const String name = 'PostsRoute';
}

class PostPageRoute extends _i1.PageRouteInfo<PostPageRouteArgs> {
  PostPageRoute({String postId})
      : super(name,
            path: ':postId',
            args: PostPageRouteArgs(postId: postId),
            params: {'postId': postId});

  static const String name = 'PostPageRoute';
}

class PostPageRouteArgs {
  const PostPageRouteArgs({this.postId});

  final String postId;
}

class ProjectsRoute extends _i1.PageRouteInfo {
  const ProjectsRoute() : super(name, path: '');

  static const String name = 'ProjectsRoute';
}

class ProjectPageRoute extends _i1.PageRouteInfo<ProjectPageRouteArgs> {
  ProjectPageRoute({String projectId})
      : super(name,
            path: ':projectId',
            args: ProjectPageRouteArgs(projectId: projectId),
            params: {'projectId': projectId});

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
