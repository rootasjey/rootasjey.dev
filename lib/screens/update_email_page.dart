import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/actions/users.dart';
import 'package:rootasjey/components/animated_app_icon.dart';
import 'package:rootasjey/components/fade_in_y.dart';
import 'package:rootasjey/components/page_app_bar.dart';
import 'package:rootasjey/components/sliver_edge_padding.dart';
import 'package:rootasjey/router/app_router.gr.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/state/user.dart';
import 'package:rootasjey/utils/app_logger.dart';
import 'package:rootasjey/utils/constants.dart';
import 'package:rootasjey/utils/fonts.dart';
import 'package:rootasjey/utils/snack.dart';
import 'package:supercharged/supercharged.dart';

class UpdateEmailPage extends StatefulWidget {
  @override
  _UpdateEmailPageState createState() => _UpdateEmailPageState();
}

class _UpdateEmailPageState extends State<UpdateEmailPage> {
  bool isCheckingEmail = false;
  bool isEmailAvailable = false;
  bool isCheckingAuth = false;
  bool isUpdating = false;
  bool isCompleted = false;

  final beginY = 10.0;
  final passwordNode = FocusNode();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String currentEmail = '';
  String email = '';
  String emailErrorMessage = '';
  String password = '';

  Timer emailTimer;

  @override
  void dispose() {
    passwordNode.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverEdgePadding(),
          appBar(),
          body(),
        ],
      ),
    );
  }

  Widget appBar() {
    final width = MediaQuery.of(context).size.width;
    double titleLeftPadding = 70.0;

    if (width < Constants.maxMobileWidth) {
      titleLeftPadding = 0.0;
    }

    return PageAppBar(
      textTitle: "email_update".tr(),
      textSubTitle: "email_update_example".tr(),
      titlePadding: EdgeInsets.only(
        left: titleLeftPadding,
      ),
      expandedHeight: 90.0,
    );
  }

  Widget body() {
    if (isCompleted) {
      return completedView();
    }

    if (isUpdating) {
      return updatingView();
    }

    return idleView();
  }

  Widget idleView() {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 60.0),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          SizedBox(
            width: 400.0,
            child: Column(
              children: <Widget>[
                FadeInY(
                  delay: 0.milliseconds,
                  beginY: beginY,
                  child: currentEmailCard(),
                ),
                FadeInY(
                  delay: 100.milliseconds,
                  beginY: beginY,
                  child: emailInput(),
                ),
                FadeInY(
                  delay: 200.milliseconds,
                  beginY: beginY,
                  child: passwordInput(),
                ),
                FadeInY(
                  delay: 300.milliseconds,
                  beginY: beginY,
                  child: validationButton(),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 200.0),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget completedView() {
    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
          width: 400.0,
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Icon(
                  Icons.check,
                  size: 80.0,
                  color: Colors.green,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 40.0),
                child: Text(
                  "email_update_successful".tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: context.router.pop,
                child: Text("back".tr()),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget currentEmailCard() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 40.0,
      ),
      child: Card(
        elevation: 2.0,
        child: InkWell(
          child: Container(
            width: 300.0,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Opacity(
                          opacity: 0.6,
                          child: Icon(
                            Icons.alternate_email,
                            color: stateColors.secondary,
                          )),
                    ),
                    Opacity(
                      opacity: 0.6,
                      child: Text(
                        "emai_current".tr(),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 35.0),
                      child: Text(
                        currentEmail,
                        style: FontsUtils.mainStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  title: Text(
                    "email_current".tr(),
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                  children: <Widget>[
                    Divider(
                      color: stateColors.secondary,
                      thickness: 1.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25.0,
                      ),
                      child: Opacity(
                        opacity: 0.6,
                        child: Text(
                          currentEmail,
                          style: FontsUtils.mainStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget emailInput() {
    return Container(
      width: 350.0,
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            autofocus: true,
            controller: emailController,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => passwordNode.requestFocus(),
            decoration: InputDecoration(
              icon: Icon(Icons.email),
              labelText: "email_new".tr(),
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
            validator: (value) {
              if (value.isEmpty) {
                return "email_empty_forbidden".tr();
              }

              return null;
            },
          ),
          if (isCheckingEmail) emailProgress(),
          if (emailErrorMessage.isNotEmpty) emailInputError(),
        ],
      ),
    );
  }

  Widget emailInputError() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8.0,
        left: 40.0,
      ),
      child: Text(emailErrorMessage,
          style: TextStyle(
            color: Colors.red.shade300,
          )),
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

  Widget passwordInput() {
    return Container(
      width: 350.0,
      padding: EdgeInsets.only(
        top: 20.0,
        bottom: 60.0,
        left: 30.0,
        right: 30.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            focusNode: passwordNode,
            controller: passwordController,
            decoration: InputDecoration(
              icon: Icon(Icons.lock_outline),
              labelText: "password".tr(),
            ),
            obscureText: true,
            onChanged: (value) {
              password = value;
            },
            onFieldSubmitted: (value) => updateEmailProcess(),
            validator: (value) {
              if (value.isEmpty) {
                return "password_empty_forbidden".tr();
              }

              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget updatingView() {
    return SliverList(
      delegate: SliverChildListDelegate([
        SizedBox(
          width: 400.0,
          child: Column(
            children: <Widget>[
              AnimatedAppIcon(),
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Text(
                  "email_updating".tr(),
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }

  Widget validationButton() {
    return OutlinedButton.icon(
      onPressed: () => updateEmailProcess(),
      style: OutlinedButton.styleFrom(
        primary: stateColors.primary,
      ),
      icon: Icon(Icons.check),
      label: SizedBox(
        width: 240.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                "email_update".tr().toUpperCase(),
                style: FontsUtils.mainStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateEmailProcess() async {
    if (!inputValuesOk()) {
      return;
    }

    setState(() {
      isUpdating = true;
    });

    try {
      if (!await valuesAvailabilityCheck()) {
        setState(() => isUpdating = false);

        Snack.e(
          context: context,
          message: "email_not_available".tr(),
        );

        return;
      }

      final userAuth = stateUser.userAuth;

      if (userAuth == null) {
        setState(() => isUpdating = false);
        context.router.navigate(SigninPageRoute());
        return;
      }

      final credentials = EmailAuthProvider.credential(
        email: userAuth.email,
        password: password,
      );

      await userAuth.reauthenticateWithCredential(credentials);
      final idToken = await userAuth.getIdToken();

      final respUpdateEmail = await stateUser.updateEmail(email, idToken);

      if (!respUpdateEmail.success) {
        final exception = respUpdateEmail.error;

        setState(() {
          isUpdating = false;
        });

        Snack.e(
          context: context,
          message: "[code: ${exception.code}] - ${exception.message}",
        );

        return;
      }

      stateUser.clearAuthCache();

      setState(() {
        isUpdating = false;
        isCompleted = true;
      });
    } catch (error) {
      appLogger.e(error);

      setState(() {
        isUpdating = false;
      });

      Snack.e(
        context: context,
        message: "email_update_error".tr(),
      );
    }
  }

  Future<bool> valuesAvailabilityCheck() async {
    return await UsersActions.checkEmailAvailability(email);
  }

  bool inputValuesOk() {
    if (email.isEmpty) {
      Snack.e(
        context: context,
        message: "email_empty_forbidden".tr(),
      );

      return false;
    }

    if (password.isEmpty) {
      Snack.e(
        context: context,
        message: "password_empty_forbidden".tr(),
      );

      return false;
    }

    if (!UsersActions.checkEmailFormat(email)) {
      Snack.e(
        context: context,
        message: "email_not_validd".tr(),
      );

      return false;
    }

    return true;
  }
}
