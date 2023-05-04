import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/buttons/dark_elevated_button.dart';
import 'package:rootasjey/components/fade_in_y.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/globals/utilities.dart';
import 'package:unicons/unicons.dart';

/// Body widget for the Sign in page.
class SigninPageBody extends StatelessWidget {
  const SigninPageBody({
    super.key,
    required this.nameController,
    required this.passwordController,
    this.onCancel,
    this.onNameChanged,
    this.onNavigateToCreateAccount,
    this.onNavigateToForgotPassword,
    this.onPasswordChanged,
    this.onSubmit,
  });

  /// Input controller for the name/email.
  final TextEditingController nameController;

  /// Input controller for the password.
  final TextEditingController passwordController;

  /// Callback fired to go back or exit this page.
  final void Function()? onCancel;

  /// Callback fired when typed name changed.
  final void Function(String name)? onNameChanged;

  /// Callback fired to the create account page.
  final void Function()? onNavigateToCreateAccount;

  /// Callback fired to the forgot password page.
  final void Function()? onNavigateToForgotPassword;

  /// Callback fired when typed password changed.
  final void Function(String password)? onPasswordChanged;

  /// Callback fired when the user validate their information and want to signin.
  final void Function(String name, String password)? onSubmit;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(
        child: Container(
          padding: const EdgeInsets.only(top: 100.0),
          width: 600.0,
          child: Column(
            children: <Widget>[
              header(context),
              usernameInput(context),
              passwordInput(context),
              forgotPassword(context),
              footerButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget usernameInput(BuildContext context) {
    return Column(
      children: [
        FadeInY(
          beginY: Utilities.ui.getBeginY(),
          delay: Duration(milliseconds: Utilities.ui.getNextAnimationDelay()),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 54.0,
              bottom: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "username".tr(),
                  style: Utilities.fonts.body(
                    textStyle: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        FadeInY(
          beginY: Utilities.ui.getBeginY(),
          delay: Duration(milliseconds: Utilities.ui.getNextAnimationDelay()),
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 12.0,
            ),
            child: TextField(
              autofocus: true,
              controller: nameController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: "steven@universe.galaxy",
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Constants.colors.palette.first,
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color
                            ?.withOpacity(0.4) ??
                        Colors.white12,
                    width: 4.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Constants.colors.palette.first,
                    width: 4.0,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget forgotPassword(BuildContext context) {
    return FadeInY(
      beginY: Utilities.ui.getBeginY(),
      delay: Duration(milliseconds: Utilities.ui.getNextAnimationDelay()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).textTheme.bodyMedium?.color,
              backgroundColor: Constants.colors.palette.first.withOpacity(0.1),
            ),
            onPressed: onNavigateToForgotPassword,
            child: Opacity(
              opacity: 0.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "password_forgot".tr(),
                    style: Utilities.fonts.code(
                      textStyle: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget header(BuildContext context) {
    return Column(
      children: [
        FadeInY(
          beginY: Utilities.ui.getBeginY(),
          delay: Duration(
            milliseconds: Utilities.ui.getNextAnimationDelay(reset: true),
          ),
          child: Icon(
            UniconsLine.trees,
            size: 42.0,
            color: Constants.colors.palette.first,
          ),
        ),
        FadeInY(
          beginY: Utilities.ui.getBeginY(),
          delay: Duration(
            milliseconds: Utilities.ui.getNextAnimationDelay(),
          ),
          child: Text(
            "signin".tr(),
            style: Utilities.fonts.body(
              textStyle: const TextStyle(
                fontSize: 42.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        FadeInY(
          beginY: Utilities.ui.getBeginY(),
          delay: Duration(
            milliseconds: Utilities.ui.getNextAnimationDelay(),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Opacity(
              opacity: 0.4,
              child: Text(
                "signin_existing_account".tr(),
                textAlign: TextAlign.center,
                style: Utilities.fonts.body2(
                  textStyle: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
        navigateToCreateAccountButton(),
      ],
    );
  }

  Widget navigateToCreateAccountButton() {
    return FadeInY(
      beginY: Utilities.ui.getBeginY(),
      delay: Duration(
        milliseconds: Utilities.ui.getNextAnimationDelay(),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 6.0),
        child: TextButton(
            onPressed: onNavigateToCreateAccount,
            style: TextButton.styleFrom(
              backgroundColor: Constants.colors.palette.first.withOpacity(0.1),
              foregroundColor: Colors.white,
            ),
            child: Opacity(
              opacity: 0.6,
              child: Text(
                "dont_own_account".tr(),
                style: Utilities.fonts.code(
                    textStyle: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                )),
              ),
            )),
      ),
    );
  }

  Widget passwordInput(BuildContext context) {
    return Column(
      children: [
        FadeInY(
          beginY: Utilities.ui.getBeginY(),
          delay: Duration(milliseconds: Utilities.ui.getNextAnimationDelay()),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 16.0,
              bottom: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "password".tr(),
                  style: Utilities.fonts.body(
                    textStyle: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        FadeInY(
          beginY: Utilities.ui.getBeginY(),
          delay: Duration(milliseconds: Utilities.ui.getNextAnimationDelay()),
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 12.0,
            ),
            child: TextField(
              autofocus: false,
              controller: passwordController,
              obscureText: true,
              textInputAction: TextInputAction.go,
              onSubmitted: (String password) {
                onSubmit?.call(nameController.text, password);
              },
              decoration: InputDecoration(
                hintText: "•••••••••••",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Constants.colors.palette.elementAt(1),
                    width: 4.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color
                            ?.withOpacity(0.4) ??
                        Colors.white12,
                    width: 4.0,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget footerButtons() {
    final Color color = Constants.colors.getRandomFromPalette();

    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FadeInY(
            beginY: Utilities.ui.getBeginY(),
            delay: Duration(milliseconds: Utilities.ui.getNextAnimationDelay()),
            child: DarkElevatedButton.icon(
              iconData: UniconsLine.times,
              labelValue: "cancel".tr(),
              onPressed: () => onCancel?.call(),
              minimumSize: const Size(250.0, 60.0),
            ),
          ),
          FadeInY(
            beginY: Utilities.ui.getBeginY(),
            delay: Duration(milliseconds: Utilities.ui.getNextAnimationDelay()),
            child: DarkElevatedButton.large(
              onPressed: () {
                onSubmit?.call(
                  nameController.text,
                  passwordController.text,
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "signin".tr(),
                      style: Utilities.fonts.body(
                        textStyle: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Icon(
                        UniconsLine.arrow_right,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
