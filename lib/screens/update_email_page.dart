import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:rootasjey/actions/users.dart';
import 'package:rootasjey/components/fade_in_y.dart';
import 'package:rootasjey/components/sliver_edge_padding.dart';
import 'package:rootasjey/globals/app_state.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/types/cloud_func_error.dart';
import 'package:rootasjey/utils/snack.dart';
import 'package:supercharged/supercharged.dart';
import 'package:unicons/unicons.dart';

class UpdateEmailPage extends ConsumerStatefulWidget {
  const UpdateEmailPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpdateEmailPageState();
}

class _UpdateEmailPageState extends ConsumerState<UpdateEmailPage>
    with UiLoggy {
  bool _isCheckingEmail = false;
  bool _isUpdating = false;
  bool _isCompleted = false;

  final _beginY = 10.0;
  final _passwordNode = FocusNode();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _emailInputValue = "";
  String _emailInputErrorMessage = "";
  String _passwordInputValue = "";

  Timer? _emailTimer;

  @override
  void dispose() {
    _passwordNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverEdgePadding(),
          header(),
          body(),
        ],
      ),
    );
  }

  Widget body() {
    if (_isCompleted) {
      return completedView();
    }

    if (_isUpdating) {
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
                  delay: const Duration(milliseconds: 0),
                  beginY: _beginY,
                  child: helperCard(),
                ),
                FadeInY(
                  delay: const Duration(milliseconds: 100),
                  beginY: _beginY,
                  child: emailInput(),
                ),
                FadeInY(
                  delay: const Duration(milliseconds: 200),
                  beginY: _beginY,
                  child: passwordInput(),
                ),
                FadeInY(
                  delay: const Duration(milliseconds: 300),
                  beginY: _beginY,
                  child: validationButton(),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 200.0),
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
              const Padding(
                padding: EdgeInsets.only(top: 30.0),
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
                  style: const TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: Beamer.of(context).beamBack,
                child: Text("back".tr()),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget header() {
    return SliverList(
      delegate: SliverChildListDelegate.fixed([
        Padding(
          padding: const EdgeInsets.only(top: 60.0),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 24.0),
                    child: Opacity(
                      opacity: 0.8,
                      child: IconButton(
                        onPressed: Beamer.of(context).beamBack,
                        icon: const Icon(UniconsLine.arrow_left),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Opacity(
                        opacity: 0.4,
                        child: Text(
                          "settings".tr().toUpperCase(),
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Opacity(
                        opacity: 0.8,
                        child: Text(
                          "email_update".tr(),
                          style: const TextStyle(
                            fontSize: 50.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        width: 400.0,
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Opacity(
                          opacity: 0.5,
                          child: Text(
                            "email_update_description".tr(),
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget helperCard() {
    final String email =
        ref.watch(AppState.userProvider).firestoreUser?.email ?? "";

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 40.0,
      ),
      child: Card(
        color: Constants.colors.clairPink,
        elevation: 2.0,
        child: InkWell(
          onTap: showTipsDialog,
          child: Container(
            width: 330.0,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Icon(
                        UniconsLine.envelope,
                        color: Constants.colors.secondary,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Opacity(
                          opacity: 0.6,
                          child: Text(
                            "email_current".tr(),
                          ),
                        ),
                        Text(
                          email,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget emailInput() {
    return Container(
      width: 390.0,
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            autofocus: true,
            controller: _emailController,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => _passwordNode.requestFocus(),
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              fillColor: Colors.white,
              focusColor: Constants.colors.clairPink,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              labelText: "email_new".tr(),
            ),
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) async {
              _emailInputValue = value;

              setState(() {
                _isCheckingEmail = true;
              });

              final isWellFormatted =
                  UsersActions.checkEmailFormat(_emailInputValue);

              if (!isWellFormatted) {
                setState(() {
                  _isCheckingEmail = false;
                  _emailInputErrorMessage = "email_not_valid".tr();
                });

                return;
              }

              if (_emailTimer != null) {
                _emailTimer!.cancel();
                _emailTimer = null;
              }

              _emailTimer = Timer(1.seconds, () async {
                final isAvailable =
                    await UsersActions.checkEmailAvailability(_emailInputValue);

                if (!isAvailable) {
                  setState(() {
                    _isCheckingEmail = false;
                    _emailInputErrorMessage = "email_not_available".tr();
                  });

                  return;
                }

                setState(() {
                  _isCheckingEmail = false;
                  _emailInputErrorMessage = '';
                });
              });
            },
            validator: (value) {
              if (value!.isEmpty) {
                return "email_empty_forbidden".tr();
              }

              return null;
            },
          ),
          if (_isCheckingEmail) emailProgress(),
          if (_emailInputErrorMessage.isNotEmpty) emailInputError(),
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
      child: Text(_emailInputErrorMessage,
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
      child: const LinearProgressIndicator(),
    );
  }

  Widget passwordInput() {
    return Container(
      width: 390.0,
      padding: const EdgeInsets.only(
        top: 20.0,
        bottom: 60.0,
        left: 30.0,
        right: 30.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            focusNode: _passwordNode,
            controller: _passwordController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              fillColor: Colors.white,
              focusColor: Constants.colors.clairPink,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              labelText: "password_current".tr(),
            ),
            obscureText: true,
            onChanged: (value) {
              _passwordInputValue = value;
            },
            onFieldSubmitted: (value) => updateEmailProcess(),
            validator: (value) {
              if (value!.isEmpty) {
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
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Text(
                  "email_updating".tr(),
                  style: const TextStyle(
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
    return ElevatedButton(
      onPressed: updateEmailProcess,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black87,
      ),
      child: SizedBox(
        width: 320.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Text(
                "email_update".tr().toUpperCase(),
                style: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
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
      _isUpdating = true;
    });

    try {
      final isEmailAvailable =
          await (valuesAvailabilityCheck() as FutureOr<bool>);
      if (!isEmailAvailable) {
        setState(() => _isUpdating = false);

        if (!mounted) {
          return;
        }

        Snack.error(
          context,
          title: "email".tr(),
          message: "email_not_available".tr(),
        );
        // throw Error();
        return;
      }

      final userAuth = ref.read(AppState.userProvider).authUser;
      if (userAuth == null) {
        throw ErrorDescription("You're not authenticated");
      }

      final credentials = EmailAuthProvider.credential(
        email: userAuth.email!,
        password: _passwordInputValue,
      );

      await userAuth.reauthenticateWithCredential(credentials);
      final idToken = await userAuth.getIdToken();
      final userNotifier = ref.read(AppState.userProvider.notifier);

      final response = await userNotifier.updateEmail(
        _emailInputValue,
        idToken,
      );

      if (!response.success) {
        if (!mounted) return;
        final CloudFuncError? exception = response.error;
        setState(() => _isUpdating = false);

        Snack.error(
          context,
          title: "update".tr(),
          message: "[code: ${exception?.code}] - ${exception?.message}",
        );

        return;
      }

      setState(() {
        _isUpdating = false;
        _isCompleted = true;
      });
    } catch (error) {
      loggy.error(error);
      setState(() => _isUpdating = false);

      Snack.error(
        context,
        title: "email".tr(),
        message: "email_update_error".tr(),
      );
    }
  }

  Future<bool?> valuesAvailabilityCheck() async {
    return await UsersActions.checkEmailAvailability(_emailInputValue);
  }

  bool inputValuesOk() {
    if (_emailInputValue.isEmpty) {
      Snack.error(
        context,
        title: "email".tr(),
        message: "email_empty_forbidden".tr(),
      );

      return false;
    }

    if (_passwordInputValue.isEmpty) {
      Snack.error(
        context,
        title: "email".tr(),
        message: "password_empty_forbidden".tr(),
      );

      return false;
    }

    if (!UsersActions.checkEmailFormat(_emailInputValue)) {
      Snack.error(
        context,
        title: "email".tr(),
        message: "email_not_validd".tr(),
      );

      return false;
    }

    return true;
  }

  void showTipsDialog() {
    final String email =
        ref.read(AppState.userProvider).firestoreUser?.email ?? "";

    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          backgroundColor: Constants.colors.clairPink,
          title: Text(
            "email_current".tr(),
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          children: <Widget>[
            Divider(
              color: Constants.colors.secondary,
              thickness: 1.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25.0,
              ),
              child: Opacity(
                opacity: 0.6,
                child: Text(
                  email,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
