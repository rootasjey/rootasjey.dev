import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
    this.onSubmit,
    this.onNameChanged,
    this.onPasswordChanged,
    this.onNavigateToForgotPassword,
    this.onNavigateToCreateAccount,
  });

  /// Input controller for the name/email.
  final TextEditingController nameController;

  /// Input controller for the password.
  final TextEditingController passwordController;

  /// Callback fired when the user validate their information and want to signin.
  final void Function(String name, String password)? onSubmit;

  /// Callback fired when typed name changed.
  final void Function(String name)? onNameChanged;

  /// Callback fired when typed password changed.
  final void Function(String password)? onPasswordChanged;

  /// Callback fired to the forgot password page.
  final void Function()? onNavigateToForgotPassword;

  /// Callback fired to the create account page.
  final void Function()? onNavigateToCreateAccount;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(
        child: SizedBox(
          width: 600.0,
          child: Column(
            children: <Widget>[
              header(context),
              nameInput(context),
              passwordInput(context),
              forgotPassword(),
              validationButton(),
              navigateToCreateAccountButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget nameInput(BuildContext context) {
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
                  "Project's name",
                  style: Utilities.fonts.body(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
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
                            .bodyText2
                            ?.color
                            ?.withOpacity(0.4) ??
                        Colors.white12,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Constants.colors.palette.first,
                    width: 2.0,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget forgotPassword() {
    return FadeInY(
      delay: const Duration(milliseconds: 100),
      beginY: 50.0,
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.pink,
        ),
        onPressed: onNavigateToForgotPassword,
        child: Opacity(
          opacity: 0.6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                "password_forgot".tr(),
                style: Utilities.fonts.body(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget header(BuildContext context) {
    return Column(
      children: [
        // if (Beamer.of(context).beamingHistory.isNotEmpty)
        //   FadeInX(
        //     beginX: 10.0,
        //     delay: const Duration(milliseconds: 200),
        //     child: Padding(
        //       padding: const EdgeInsets.only(
        //         right: 20.0,
        //       ),
        //       child: IconButton(
        //         onPressed: Beamer.of(context).beamBack,
        //         icon: const Icon(Icons.arrow_back),
        //       ),
        //     ),
        //   ),
        FadeInY(
          beginY: Utilities.ui.getBeginY(),
          child: Icon(
            UniconsLine.clapper_board,
            size: 42.0,
            color: Constants.colors.palette.first,
          ),
        ),
        FadeInY(
          beginY: Utilities.ui.getBeginY(),
          delay: Duration(
            milliseconds: Utilities.ui.getNextAnimationDelay(reset: true),
          ),
          child: Text(
            "signin".tr(),
            style: Utilities.fonts.body(
              fontSize: 32.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        FadeInY(
          beginY: Utilities.ui.getBeginY(),
          delay: Duration(milliseconds: Utilities.ui.getNextAnimationDelay()),
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Opacity(
              opacity: 0.4,
              child: Text(
                // "You'll be able to write a post about it later.\n"
                // "Projects help you showcase your work to the world.",
                "signin_existing_account".tr(),
                textAlign: TextAlign.center,
                style: Utilities.fonts.body2(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget navigateToCreateAccountButton() {
    return FadeInY(
      delay: const Duration(milliseconds: 400),
      beginY: 50.0,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: TextButton(
            onPressed: onNavigateToCreateAccount,
            child: Opacity(
              opacity: 0.6,
              child: Text(
                "dont_own_account".tr(),
                style: const TextStyle(
                  decoration: TextDecoration.underline,
                ),
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
                  "Project's summary",
                  style: Utilities.fonts.body(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
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
                hintText: "This is an open "
                    "source project about...",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Constants.colors.palette.elementAt(1),
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context)
                            .textTheme
                            .bodyText2
                            ?.color
                            ?.withOpacity(0.4) ??
                        Colors.white12,
                    width: 2.0,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget validationButton() {
    return FadeInY(
      delay: const Duration(milliseconds: 200),
      beginY: 50.0,
      child: Padding(
        padding: const EdgeInsets.only(top: 80.0),
        child: ElevatedButton(
          onPressed: onSubmit != null
              ? () => onSubmit?.call(
                    nameController.text,
                    passwordController.text,
                  )
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Constants.colors.primary,
            shape: const RoundedRectangleBorder(
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
                  "signin".tr().toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Icon(
                    UniconsLine.arrow_right,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
