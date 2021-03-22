// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as _i18;

import '../screens/about.dart' as _i5;
import '../screens/contact.dart' as _i6;
import '../screens/dashboard_page.dart' as _i7;
import '../screens/delete_account.dart' as _i14;
import '../screens/forgot_password.dart' as _i8;
import '../screens/home.dart' as _i4;
import '../screens/settings.dart' as _i9;
import '../screens/signin.dart' as _i10;
import '../screens/signup.dart' as _i11;
import '../screens/tos.dart' as _i12;
import '../screens/undefined_page.dart' as _i13;
import '../screens/update_email.dart' as _i15;
import '../screens/update_password.dart' as _i16;
import '../screens/update_username.dart' as _i17;
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
    ContactRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i6.Contact());
    },
    DashboardPageRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i7.DashboardPage());
    },
    ForgotPasswordRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i8.ForgotPassword());
    },
    SettingsRoute.name: (entry) {
      var pathParams = entry.routeData.pathParams;
      var args = entry.routeData.argsAs<SettingsRouteArgs>(
          orElse: () => SettingsRouteArgs(
              showAppBar: pathParams.getBool('showAppBar', true)));
      return _i1.MaterialPageX(
          entry: entry,
          child: _i9.Settings(key: args.key, showAppBar: args.showAppBar));
    },
    SigninRoute.name: (entry) {
      var args = entry.routeData
          .argsAs<SigninRouteArgs>(orElse: () => SigninRouteArgs());
      return _i1.MaterialPageX(
          entry: entry,
          child:
              _i10.Signin(key: args.key, onSigninResult: args.onSigninResult));
    },
    SignupRoute.name: (entry) {
      var args = entry.routeData
          .argsAs<SignupRouteArgs>(orElse: () => SignupRouteArgs());
      return _i1.MaterialPageX(
          entry: entry,
          child:
              _i11.Signup(key: args.key, onSignupResult: args.onSignupResult));
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
      return _i1.MaterialPageX(entry: entry, child: _i12.Tos());
    },
    UndefinedPageRoute.name: (entry) {
      var args = entry.routeData.argsAs<UndefinedPageRouteArgs>(
          orElse: () => UndefinedPageRouteArgs());
      return _i1.MaterialPageX(
          entry: entry, child: _i13.UndefinedPage(name: args.name));
    },
    DashboardSettingsDeepRoute.name: (entry) {
      return _i1.MaterialPageX(
          entry: entry, child: const _i1.EmptyRouterPage());
    },
    DashboardSettingsRoute.name: (entry) {
      var pathParams = entry.routeData.pathParams;
      var args = entry.routeData.argsAs<DashboardSettingsRouteArgs>(
          orElse: () => DashboardSettingsRouteArgs(
              showAppBar: pathParams.getBool('showAppBar', true)));
      return _i1.MaterialPageX(
          entry: entry,
          child: _i9.Settings(key: args.key, showAppBar: args.showAppBar));
    },
    DeleteAccountRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i14.DeleteAccount());
    },
    AccountUpdateDeepRoute.name: (entry) {
      return _i1.MaterialPageX(
          entry: entry, child: const _i1.EmptyRouterPage());
    },
    UpdateEmailRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i15.UpdateEmail());
    },
    UpdatePasswordRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i16.UpdatePassword());
    },
    UpdateUsernameRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i17.UpdateUsername());
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
        _i1.RouteConfig(ContactRoute.name, path: '/contact'),
        _i1.RouteConfig(DashboardPageRoute.name, path: '/dashboard', guards: [
          authGuard
        ], children: [
          _i1.RouteConfig('#redirect',
              path: '', redirectTo: 'settings', fullMatch: true),
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
        _i1.RouteConfig(ForgotPasswordRoute.name, path: '/forgotpassword'),
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

class ContactRoute extends _i1.PageRouteInfo {
  const ContactRoute() : super(name, path: '/contact');

  static const String name = 'ContactRoute';
}

class DashboardPageRoute extends _i1.PageRouteInfo {
  const DashboardPageRoute({List<_i1.PageRouteInfo> children})
      : super(name, path: '/dashboard', initialChildren: children);

  static const String name = 'DashboardPageRoute';
}

class ForgotPasswordRoute extends _i1.PageRouteInfo {
  const ForgotPasswordRoute() : super(name, path: '/forgotpassword');

  static const String name = 'ForgotPasswordRoute';
}

class SettingsRoute extends _i1.PageRouteInfo<SettingsRouteArgs> {
  SettingsRoute({_i18.Key key, bool showAppBar = true})
      : super(name,
            path: '/settings',
            args: SettingsRouteArgs(key: key, showAppBar: showAppBar),
            params: {'showAppBar': showAppBar});

  static const String name = 'SettingsRoute';
}

class SettingsRouteArgs {
  const SettingsRouteArgs({this.key, this.showAppBar = true});

  final _i18.Key key;

  final bool showAppBar;
}

class SigninRoute extends _i1.PageRouteInfo<SigninRouteArgs> {
  SigninRoute({_i18.Key key, void Function(bool) onSigninResult})
      : super(name,
            path: '/signin',
            args: SigninRouteArgs(key: key, onSigninResult: onSigninResult));

  static const String name = 'SigninRoute';
}

class SigninRouteArgs {
  const SigninRouteArgs({this.key, this.onSigninResult});

  final _i18.Key key;

  final void Function(bool) onSigninResult;
}

class SignupRoute extends _i1.PageRouteInfo<SignupRouteArgs> {
  SignupRoute({_i18.Key key, void Function(bool) onSignupResult})
      : super(name,
            path: '/signup',
            args: SignupRouteArgs(key: key, onSignupResult: onSignupResult));

  static const String name = 'SignupRoute';
}

class SignupRouteArgs {
  const SignupRouteArgs({this.key, this.onSignupResult});

  final _i18.Key key;

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

class UndefinedPageRoute extends _i1.PageRouteInfo<UndefinedPageRouteArgs> {
  UndefinedPageRoute({String name0})
      : super(name, path: '*', args: UndefinedPageRouteArgs());

  static const String name = 'UndefinedPageRoute';
}

class UndefinedPageRouteArgs {
  const UndefinedPageRouteArgs({this.name});

  final String name;
}

class DashboardSettingsDeepRoute extends _i1.PageRouteInfo {
  const DashboardSettingsDeepRoute({List<_i1.PageRouteInfo> children})
      : super(name, path: 'settings', initialChildren: children);

  static const String name = 'DashboardSettingsDeepRoute';
}

class DashboardSettingsRoute
    extends _i1.PageRouteInfo<DashboardSettingsRouteArgs> {
  DashboardSettingsRoute({_i18.Key key, bool showAppBar = true})
      : super(name,
            path: '',
            args: DashboardSettingsRouteArgs(key: key, showAppBar: showAppBar),
            params: {'showAppBar': showAppBar});

  static const String name = 'DashboardSettingsRoute';
}

class DashboardSettingsRouteArgs {
  const DashboardSettingsRouteArgs({this.key, this.showAppBar = true});

  final _i18.Key key;

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

class GitHubRoute extends _i1.PageRouteInfo {
  const GitHubRoute() : super(name, path: 'github');

  static const String name = 'GitHubRoute';
}
