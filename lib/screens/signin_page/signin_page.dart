import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:rootasjey/actions/users.dart';
import 'package:rootasjey/components/application_bar.dart';
import 'package:rootasjey/components/bezier_clipper.dart';
import 'package:rootasjey/components/loading_view.dart';
import 'package:rootasjey/globals/app_state.dart';
import 'package:rootasjey/router/locations/forgot_password_location.dart';
import 'package:rootasjey/router/locations/home_location.dart';
import 'package:rootasjey/router/locations/signup_location.dart';
import 'package:rootasjey/globals/state/user_notifier.dart';
import 'package:rootasjey/screens/signin_page/signin_page_body.dart';
import 'package:rootasjey/types/intents/escape_intent.dart';

class SigninPage extends ConsumerStatefulWidget {
  const SigninPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SigninPageState();
}

class _SigninPageState extends ConsumerState<SigninPage> with UiLoggy {
  /// True if we're trying to signin.
  bool _loading = false;

  /// Input controller to follow, validate & submit user name/email value.
  final _nameController = TextEditingController();

  /// Input controller to follow, validate & submit user password value.
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return LoadingView.scaffold(
        message: "signingin".tr(),
      );
    }

    const shortcuts = <SingleActivator, Intent>{
      SingleActivator(LogicalKeyboardKey.escape): EscapeIntent(),
    };

    final actions = <Type, Action<Intent>>{
      EscapeIntent: CallbackAction(
        onInvoke: (Intent intent) => onCancel(),
      ),
    };

    return Shortcuts(
      shortcuts: shortcuts,
      child: Actions(
        actions: actions,
        child: Scaffold(
          body: Stack(
            children: [
              Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                height: 400.0,
                child: Opacity(
                  opacity: 0.8,
                  child: ClipPath(
                    clipper: const BezierClipper(2),
                    child: Container(
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
              CustomScrollView(
                slivers: <Widget>[
                  const ApplicationBar(),
                  SigninPageBody(
                    nameController: _nameController,
                    passwordController: _passwordController,
                    onNavigateToForgotPassword: onNavigatetoForgotPassword,
                    onNavigateToCreateAccount: onNavigateToCreateAccount,
                    onSubmit: (String name, String password) => trySignin(
                      name: name,
                      password: password,
                    ),
                    onCancel: onCancel,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void trySignin({required String name, required String password}) async {
    if (!inputValuesOk(name: name, password: password)) {
      return;
    }

    setState(() => _loading = true);

    try {
      final UserNotifier userNotifier =
          ref.read(AppState.userProvider.notifier);

      final User? userCred = await userNotifier.signIn(
        email: name,
        password: password,
      );

      if (userCred == null) {
        loggy.error("account_doesnt_exist".tr());
        return;
      }

      if (!mounted) return;
      Beamer.of(context).beamToNamed(HomeLocation.route);
    } catch (error) {
      loggy.error("password_error.incorrect".tr());
    } finally {
      setState(() => _loading = false);
    }
  }

  void onNavigatetoForgotPassword() {
    Beamer.of(context).beamToNamed(
      ForgotPasswordLocation.route,
    );
  }

  void onNavigateToCreateAccount() {
    Beamer.of(context).beamToNamed(
      SignupLocation.route,
    );
  }

  bool inputValuesOk({required String name, required String password}) {
    if (!UsersActions.checkEmailFormat(name)) {
      loggy.error("email_not_valid".tr());
      return false;
    }

    if (password.isEmpty) {
      loggy.error("password_empty_forbidden".tr());
      return false;
    }

    return true;
  }

  void onCancel() {
    if (Beamer.of(context).beamingHistory.isNotEmpty) {
      Beamer.of(context).beamBack();
      return;
    }

    Beamer.of(context, root: true).beamToNamed(HomeLocation.route);
  }
}
