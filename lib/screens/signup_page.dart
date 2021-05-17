import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/router/app_router.gr.dart';
import 'package:rootasjey/actions/users.dart';
import 'package:rootasjey/components/fade_in_x.dart';
import 'package:rootasjey/components/fade_in_y.dart';
import 'package:rootasjey/components/home_app_bar.dart';
import 'package:rootasjey/components/loading_animation.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/state/user.dart';
import 'package:rootasjey/utils/app_logger.dart';
import 'package:rootasjey/utils/fonts.dart';
import 'package:rootasjey/utils/snack.dart';
import 'package:supercharged/supercharged.dart';
import 'package:unicons/unicons.dart';

class SignupPage extends StatefulWidget {
  final void Function(bool isAuthenticated) onSignupResult;

  const SignupPage({Key key, this.onSignupResult}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String email = '';
  String password = '';
  String confirmPassword = '';
  String username = '';

  bool isEmailAvailable = true;
  bool isNameAvailable = true;

  String emailErrorMessage = '';
  String nameErrorMessage = '';

  bool isCheckingEmail = false;
  bool isCheckingName = false;

  Timer emailTimer;
  Timer nameTimer;

  bool isCheckingAuth = false;
  bool isCompleted = false;
  bool isSigningUp = false;

  final usernameNode = FocusNode();
  final passwordNode = FocusNode();
  final confirmPasswordNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    usernameNode.dispose();
    passwordNode.dispose();
    confirmPasswordNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          HomeAppBar(
            automaticallyImplyLeading: true,
          ),
          SliverPadding(
            padding: const EdgeInsets.only(
              top: 100.0,
              bottom: 300.0,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate.fixed([
                Column(
                  children: <Widget>[
                    SizedBox(
                      width: 300.0,
                      child: body(),
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget body() {
    if (isSigningUp) {
      return Padding(
        padding: const EdgeInsets.only(top: 80.0),
        child: LoadingAnimation(
          textTitle: "signup_dot".tr(),
        ),
      );
    }

    return idleContainer();
  }

  Widget emailInput() {
    return FadeInY(
      delay: 0.milliseconds,
      beginY: 50.0,
      child: Padding(
        padding: EdgeInsets.only(top: 60.0),
        child: TextFormField(
          autofocus: true,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            icon: Icon(Icons.email),
            labelText: "email".tr(),
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) async {
            email = value;

            setState(() {
              isCheckingEmail = true;
            });

            final isWellFormatted = UsersActions.checkEmailFormat(email);

            if (!isWellFormatted) {
              setState(() {
                isCheckingEmail = false;
                emailErrorMessage = "email_not_valid".tr();
              });

              return;
            }

            if (emailTimer != null) {
              emailTimer.cancel();
              emailTimer = null;
            }

            emailTimer = Timer(1.seconds, () async {
              final isAvailable =
                  await UsersActions.checkEmailAvailability(email);
              if (!isAvailable) {
                setState(() {
                  isCheckingEmail = false;
                  emailErrorMessage = "email_not_available".tr();
                });

                return;
              }

              setState(() {
                isCheckingEmail = false;
                emailErrorMessage = '';
              });
            });
          },
          onFieldSubmitted: (_) => usernameNode.requestFocus(),
          validator: (value) {
            if (value.isEmpty) {
              return "email_empty_forbidden".tr();
            }

            return null;
          },
        ),
      ),
    );
  }

  Widget emailInputError() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8.0,
        left: 40.0,
      ),
      child: Text(
        emailErrorMessage,
        style: TextStyle(
          color: Colors.red.shade300,
        ),
      ),
    );
  }

  Widget header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (context.router.stack.length > 1)
          FadeInX(
            beginX: 10.0,
            delay: 100.milliseconds,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 20.0,
              ),
              child: IconButton(
                onPressed: context.router.pop,
                icon: Icon(UniconsLine.arrow_left),
              ),
            ),
          ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FadeInY(
                beginY: 50.0,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    "signup".tr(),
                    textAlign: TextAlign.center,
                    style: FontsUtils.mainStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              FadeInY(
                delay: 200.milliseconds,
                beginY: 50.0,
                child: Opacity(
                  opacity: 0.6,
                  child: Text("account_create_new".tr()),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget idleContainer() {
    return Column(
      children: <Widget>[
        header(),
        emailInput(),
        if (isCheckingEmail) emailProgress(),
        if (emailErrorMessage.isNotEmpty) emailInputError(),
        nameInput(),
        if (isCheckingName) nameProgress(),
        if (nameErrorMessage.isNotEmpty) nameInputError(),
        passwordInput(),
        confirmPasswordInput(),
        validationButton(),
        alreadyHaveAccountButton(),
      ],
    );
  }

  Widget emailProgress() {
    return Container(
      padding: const EdgeInsets.only(
        left: 40.0,
      ),
      child: LinearProgressIndicator(),
    );
  }

  Widget nameInput() {
    return FadeInY(
      delay: 100.milliseconds,
      beginY: 50.0,
      child: Padding(
        padding: EdgeInsets.only(top: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              focusNode: usernameNode,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.person_outline,
                ),
                labelText: "username".tr(),
              ),
              textInputAction: TextInputAction.next,
              onChanged: (value) async {
                setState(() {
                  username = value;
                  isCheckingName = true;
                });

                final isWellFormatted =
                    UsersActions.checkUsernameFormat(username);

                if (!isWellFormatted) {
                  setState(() {
                    isCheckingName = false;
                    nameErrorMessage = username.length < 3
                        ? "input_minimum_char".tr()
                        : "input_valid_format".tr();
                  });

                  return;
                }

                if (nameTimer != null) {
                  nameTimer.cancel();
                  nameTimer = null;
                }

                nameTimer = Timer(1.seconds, () async {
                  final isAvailable =
                      await UsersActions.checkUsernameAvailability(username);

                  if (!isAvailable) {
                    setState(() {
                      isCheckingName = false;
                      nameErrorMessage = "name_unavailable".tr();
                    });

                    return;
                  }

                  setState(() {
                    isCheckingName = false;
                    nameErrorMessage = '';
                  });
                });
              },
              onFieldSubmitted: (_) => passwordNode.requestFocus(),
              validator: (value) {
                if (value.isEmpty) {
                  return "name_empty_forbidden".tr();
                }

                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget nameInputError() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8.0,
        left: 40.0,
      ),
      child: Text(nameErrorMessage,
          style: TextStyle(
            color: Colors.red.shade300,
          )),
    );
  }

  Widget nameProgress() {
    return Container(
      padding: const EdgeInsets.only(
        left: 40.0,
      ),
      child: LinearProgressIndicator(),
    );
  }

  Widget passwordInput() {
    return FadeInY(
      delay: 200.milliseconds,
      beginY: 50.0,
      child: Padding(
        padding: EdgeInsets.only(top: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              focusNode: passwordNode,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                icon: Icon(Icons.lock_outline),
                labelText: "password".tr(),
              ),
              obscureText: true,
              onChanged: (value) {
                if (value.length == 0) {
                  return;
                }
                password = value;
              },
              onFieldSubmitted: (_) => confirmPasswordNode.requestFocus(),
              validator: (value) {
                if (value.isEmpty) {
                  return "password_empty_forbidden".tr();
                }

                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget confirmPasswordInput() {
    return FadeInY(
      delay: 400.milliseconds,
      beginY: 50.0,
      child: Padding(
        padding: EdgeInsets.only(top: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              focusNode: confirmPasswordNode,
              decoration: InputDecoration(
                icon: Icon(Icons.lock_outline),
                labelText: "password_confirm".tr(),
              ),
              obscureText: true,
              onChanged: (value) {
                if (value.length == 0) {
                  return;
                }
                confirmPassword = value;
              },
              onFieldSubmitted: (value) => signUpProcess(),
              validator: (value) {
                if (value.isEmpty) {
                  return "password_confirm_empty_forbidden".tr();
                }

                if (confirmPassword != password) {
                  return "passwords_dont_match".tr();
                }

                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget validationButton() {
    return FadeInY(
      delay: 500.milliseconds,
      beginY: 50.0,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 60.0),
          child: ElevatedButton(
            onPressed: () => signUpProcess(),
            style: ElevatedButton.styleFrom(
              primary: stateColors.accent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(7.0),
                ),
              ),
            ),
            child: Container(
              width: 250.0,
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "signup".tr(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget alreadyHaveAccountButton() {
    return FadeInY(
      delay: 700.milliseconds,
      beginY: 50.0,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: ElevatedButton(
          onPressed: () => context.router.navigate(SigninPageRoute()),
          child: Opacity(
            opacity: 0.6,
            child: Text(
              "account_already_own".tr(),
              style: TextStyle(
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signUpProcess() async {
    if (!inputValuesOk()) {
      return;
    }

    setState(() => isSigningUp = true);

    if (!await valuesAvailabilityCheck()) {
      setState(() {
        isSigningUp = false;
      });

      Snack.e(
        context: context,
        message: "email_not_available".tr(),
      );

      return;
    }

    // ?NOTE: Triming because of TAB key on Desktop insert blank spaces.
    email = email.trim();
    password = password.trim();

    try {
      final respCreateAcc = await UsersActions.createAccount(
        email: email,
        username: username,
        password: password,
      );

      if (!respCreateAcc.success) {
        final exception = respCreateAcc.error;

        setState(() => isSigningUp = false);

        Snack.e(
          context: context,
          message: "[code: ${exception.code}] - ${exception.message}",
        );

        return;
      }

      final userCred = await stateUser.signin(
        email: email,
        password: password,
      );

      setState(() {
        isSigningUp = false;
        isCompleted = true;
      });

      if (userCred == null) {
        Snack.e(
          context: context,
          message: "account_create_error".tr(),
        );

        return;
      }

      // PushNotifications.linkAuthUser(respCreateAcc.user.id);

      if (widget.onSignupResult != null) {
        widget.onSignupResult(true);
        return;
      }

      context.router.navigate(HomePageRoute());
    } catch (error) {
      appLogger.e(error);

      setState(() => isSigningUp = false);

      Snack.e(
        context: context,
        message: "account_create_error".tr(),
      );
    }
  }

  Future<bool> valuesAvailabilityCheck() async {
    final isEmailOk = await UsersActions.checkEmailAvailability(email);
    final isNameOk = await UsersActions.checkUsernameAvailability(username);
    return isEmailOk && isNameOk;
  }

  bool inputValuesOk() {
    if (password.isEmpty || confirmPassword.isEmpty) {
      Snack.e(
        context: context,
        message: "password_empty_forbidden".tr(),
      );

      return false;
    }

    if (confirmPassword != password) {
      Snack.e(
        context: context,
        message: "passwords_dont_match".tr(),
      );

      return false;
    }

    if (username.isEmpty) {
      Snack.e(
        context: context,
        message: "name_empty_forbidden".tr(),
      );

      return false;
    }

    if (!UsersActions.checkEmailFormat(email)) {
      Snack.e(
        context: context,
        message: "email_not_valid".tr(),
      );

      return false;
    }

    if (!UsersActions.checkUsernameFormat(username)) {
      Snack.e(
        context: context,
        message: username.length < 3
            ? "input_minimum_char".tr()
            : "input_valid_format".tr(),
      );

      return false;
    }

    return true;
  }
}
