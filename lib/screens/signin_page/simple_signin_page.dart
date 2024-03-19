import 'dart:ui';

import 'package:dismissible_page/dismissible_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';
import 'package:rootasjey/actions/user_actions.dart';
import 'package:rootasjey/components/buttons/dot_close_button.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/globals/utils.dart';
import 'package:rootasjey/router/navigation_state_helper.dart';
import 'package:rootasjey/screens/forgot_password/forgot_password_page.dart';
import 'package:rootasjey/screens/signin_page/signin_page_body.dart';
import 'package:rootasjey/screens/signin_page/signin_page_header.dart';
import 'package:rootasjey/types/enums/enum_page_state.dart';
import 'package:rootasjey/types/user/user_auth.dart';

class SimpleSigninPage extends StatefulWidget {
  const SimpleSigninPage({super.key});

  @override
  State<SimpleSigninPage> createState() => _SimpleSigninPageState();
}

class _SimpleSigninPageState extends State<SimpleSigninPage> with UiLoggy {
  /// Used to hide/show password.
  bool _hidePassword = true;

  Color _accentColor = Colors.amber;

  /// Page's current state (e.g. loading, idle, etc).
  EnumPageState _pageState = EnumPageState.idle;

  /// Input controller to follow, validate & submit user name/email value.
  final TextEditingController _emailController = TextEditingController();

  /// Input controller to follow, validate & submit user password value.
  final TextEditingController _passwordController = TextEditingController();

  /// Used to focus email input (e.g. after error).
  final FocusNode _emailFocusNode = FocusNode();

  /// Focus node for the cancel button.
  final FocusNode _emailCancelFocusNode = FocusNode(
    canRequestFocus: false,
    descendantsAreFocusable: false,
    descendantsAreTraversable: false,
    skipTraversal: true,
  );

  /// Used to focus password input (e.g. after error).
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _accentColor = Constants.colors.getRandomFromPalette();
    _emailFocusNode.addListener(onEmailFocusChange);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailCancelFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobileSize = Utils.graphic.isMobileSize(context);
    final BorderRadius borderRadius = BorderRadius.circular(0.0);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
          child: Container(
            color: Colors.black12,
            child: Center(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(42.0),
                    child: DismissiblePage(
                      onDismissed: () => Navigator.pop(context),
                      backgroundColor: Colors.transparent,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 400.0),
                        child: Material(
                          elevation: 0.0,
                          color: Theme.of(context).cardColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: borderRadius,
                          ),
                          child: ClipRRect(
                            borderRadius: borderRadius,
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    SigninPageHeader(
                                      accentColor: _accentColor,
                                      isMobileSize: isMobileSize,
                                      margin: const EdgeInsets.only(top: 24.0),
                                    ),
                                    SigninPageBody(
                                      accentColor: _accentColor,
                                      emailFocusNode: _emailFocusNode,
                                      emailController: _emailController,
                                      emailCancelFocusNode:
                                          _emailCancelFocusNode,
                                      onTapCancelEmailButtonName:
                                          onTapCancelEmailButtonName,
                                      hidePassword: _hidePassword,
                                      isMobileSize: isMobileSize,
                                      pageState: _pageState,
                                      passwordController: _passwordController,
                                      onEmailChanged: onEmailChanged,
                                      onHidePasswordChanged:
                                          onHidePasswordChanged,
                                      onPasswordChanged: onPasswordChanged,
                                      onNavigateToForgotPassword:
                                          navigateToForgotPasswordPage,
                                      // onNavigateToCreateAccount: navigateToSignupPage,
                                      onCancel: onCancel,
                                      onSubmit: onSubmit,
                                      passwordFocusNode: _passwordFocusNode,
                                    ),
                                  ],
                                ),
                                Positioned(
                                  top: 24.0,
                                  right: 24.0,
                                  child: DotCloseButton(
                                    tooltip: "close".tr(),
                                    onTap: () => Navigator.pop(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Attempt to sign in user.
  void connect({required String name, required String password}) async {
    if (!inputValuesOk(name: name, password: password)) {
      return;
    }

    setState(() => _pageState = EnumPageState.loading);

    try {
      final UserAuth? userCredential = await Utils.state.user.signIn(
        email: name,
        password: password,
      );

      if (userCredential == null) {
        loggy.error("account.error.does_not_exist".tr());
        if (!mounted) return;
        Utils.graphic.showSnackbar(
          context,
          message: "account.error.does_not_exist".tr(),
        );
        return;
      }

      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (error) {
      loggy.error("password.error.incorrect".tr());
      Utils.graphic.showSnackbar(
        context,
        message: "password.error.incorrect".tr(),
      );
    } finally {
      setState(() => _pageState = EnumPageState.idle);
    }
  }

  /// Return true if all inputs (email, password) are in the correct format.
  bool inputValuesOk({required String name, required String password}) {
    if (name.isEmpty) {
      Utils.graphic.showSnackbar(
        context,
        message: "email.error.empty_forbidden".tr(),
      );

      _emailFocusNode.requestFocus();
      return false;
    }

    if (password.isEmpty) {
      Utils.graphic.showSnackbar(
        context,
        message: "password.error.empty_forbidden".tr(),
      );

      _passwordFocusNode.requestFocus();
      return false;
    }

    if (!UserActions.checkEmailFormat(name)) {
      Utils.graphic.showSnackbar(
        context,
        message: "email.error.not_valid".tr(),
      );

      _emailFocusNode.requestFocus();
      return false;
    }

    return true;
  }

  void onEmailChanged(String email) {
    NavigationStateHelper.userEmailInput = email;
  }

  void onHidePasswordChanged(bool value) {
    setState(() => _hidePassword = value);
  }

  void onPasswordChanged(String password) {}

  void navigateToForgotPasswordPage() {
    Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ForgotPasswordPage(),
      ),
    );
  }

  void onCancel() {
    Navigator.of(context).pop();
  }

  void onSubmit(String name, String password) {
    connect(
      name: name,
      password: password,
    );
  }

  void onTapCancelEmailButtonName() {
    _emailFocusNode.unfocus();
  }

  void onEmailFocusChange() {
    setState(() {});
  }
}
