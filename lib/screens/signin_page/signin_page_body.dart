import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rootasjey/components/loading_view.dart';
import 'package:rootasjey/screens/signin_page/forgot_password_button.dart';
import 'package:rootasjey/screens/signin_page/email_input.dart';
import 'package:rootasjey/screens/signin_page/signin_page_footer.dart';
import 'package:rootasjey/screens/signin_page/password_input.dart';
import 'package:rootasjey/types/enums/enum_page_state.dart';

/// Body widget for the Sign in page.
class SigninPageBody extends StatelessWidget {
  const SigninPageBody({
    super.key,
    required this.emailController,
    required this.passwordController,
    this.hidePassword = true,
    this.isDark = false,
    this.isMobileSize = false,
    this.accentColor = Colors.amber,
    this.emailCancelFocusNode,
    this.emailFocusNode,
    this.passwordFocusNode,
    this.pageState = EnumPageState.idle,
    this.onCancel,
    this.onEmailChanged,
    this.onHidePasswordChanged,
    this.onNavigateToCreateAccount,
    this.onNavigateToForgotPassword,
    this.onPasswordChanged,
    this.onTapCancelEmailButtonName,
    this.onSubmit,
  });

  /// Hide password input if true.
  final bool hidePassword;

  /// Whether the page is in dark mode.
  final bool isDark;

  /// Adapt user interface to mobile size if true.
  final bool isMobileSize;

  /// Accent color.
  final Color accentColor;

  /// Current page state.
  final EnumPageState pageState;

  /// Used to focus email input (e.g. after error).
  final FocusNode? emailFocusNode;

  /// Focus node for the cancel button.
  final FocusNode? emailCancelFocusNode;

  /// Used to focus password input (e.g. after error).
  final FocusNode? passwordFocusNode;

  /// Callback fired to go back or exit this page.
  final void Function()? onCancel;

  /// Callback fired when typed email changed.
  final void Function(String name)? onEmailChanged;

  /// Callback called when the user wants to hide/show password.
  final void Function(bool value)? onHidePasswordChanged;

  /// Callback fired to the create account page.
  final void Function()? onNavigateToCreateAccount;

  /// Callback fired to the forgot password page.
  final void Function()? onNavigateToForgotPassword;

  /// Callback fired when typed password changed.
  final void Function(String password)? onPasswordChanged;

  /// Callback fired when the user validate their information and want to signin.
  final void Function(String name, String password)? onSubmit;

  /// Callback fired to unfocus the email input.
  final void Function()? onTapCancelEmailButtonName;

  /// Input controller for the name/email.
  final TextEditingController emailController;

  /// Input controller for the password.
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    if (pageState == EnumPageState.loading) {
      return LoadingView(
        message: "signin.in".tr(),
      );
    }

    return Center(
      child: Container(
        padding: EdgeInsets.only(
          top: isMobileSize ? 0.0 : 40.0,
          left: 24.0,
          right: 24.0,
          bottom: 54.0,
        ),
        width: 600.0,
        child: Column(
          children: <Widget>[
            EmailInput(
              accentColor: accentColor,
              emailFocusNode: emailFocusNode,
              emailController: emailController,
              cancelFocusNode: emailCancelFocusNode,
              onTapCancelButtonName: onTapCancelEmailButtonName,
              onEmailChanged: onEmailChanged,
              margin: const EdgeInsets.only(top: 24.0),
            ),
            PasswordInput(
              accentColor: accentColor,
              passwordFocusNode: passwordFocusNode,
              hidePassword: hidePassword,
              nameController: emailController,
              onHidePasswordChanged: onHidePasswordChanged,
              onPasswordChanged: onPasswordChanged,
              onSubmit: onSubmit,
              passwordController: passwordController,
              margin: const EdgeInsets.only(top: 12.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ForgotPasswordButton(
                  accentColor: accentColor,
                  isMobileSize: isMobileSize,
                  onTap: onNavigateToForgotPassword,
                ),
              ],
            ),
            SigninPageFooter(
              accentColor: accentColor,
              isDark: isDark,
              nameController: emailController,
              onCancel: onCancel,
              onSubmit: onSubmit,
              passwordController: passwordController,
              showBackButton: !isMobileSize,
            ),
          ]
              .animate(interval: const Duration(milliseconds: 50))
              .fadeIn(
                duration: const Duration(milliseconds: 300),
                curve: Curves.decelerate,
              )
              .slideY(begin: 6.0, end: 0.0),
        ),
      ),
    );
  }
}
