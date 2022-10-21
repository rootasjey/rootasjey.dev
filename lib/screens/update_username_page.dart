import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:rootasjey/actions/users.dart';
import 'package:rootasjey/components/fade_in_y.dart';
import 'package:rootasjey/components/sliver_edge_padding.dart';
import 'package:rootasjey/globals/app_state.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/router/locations/signin_location.dart';
import 'package:rootasjey/types/cloud_func_error.dart';
import 'package:rootasjey/globals/state/user_notifier.dart';
import 'package:rootasjey/utils/snack.dart';
import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';
import 'package:unicons/unicons.dart';

class UpdateUsernamePage extends ConsumerStatefulWidget {
  const UpdateUsernamePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpdateUsernamePageState();
}

class _UpdateUsernamePageState extends ConsumerState<UpdateUsernamePage>
    with UiLoggy {
  bool _isUpdating = false;
  bool _isCheckingName = false;
  bool _isCompleted = false;
  bool _isNameAvailable = false;

  final _passwordNode = FocusNode();
  final _usernameController = TextEditingController();
  final _pageScrollController = ScrollController();

  String _nameErrorMessage = "";
  String _newUsername = "";
  final String _username = "";

  Timer? _nameTimer;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _pageScrollController,
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
                  Icons.check_circle_outline_outlined,
                  size: 80.0,
                  color: Colors.green,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 40.0),
                child: Text(
                  "username_update_success".tr(),
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
                          "username_update".tr(),
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
                            "username_update_description".tr(),
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
    return Padding(
      padding: const EdgeInsets.only(
        top: 80.0,
        bottom: 40.0,
      ),
      child: Card(
        color: Constants.colors.clairPink,
        elevation: 2.0,
        child: InkWell(
          onTap: showTipsDialog,
          child: Container(
            width: 340.0,
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
                            "username_current".tr(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          _username,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
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

  Widget idleView() {
    return SliverList(
      delegate: SliverChildListDelegate([
        Column(
          children: [
            FadeInY(
              beginY: 10.0,
              child: helperCard(),
            ),
            FadeInY(
              beginY: 10.0,
              delay: 100.milliseconds,
              child: usernameInput(),
            ),
            FadeInY(
              beginY: 10.0,
              delay: 200.milliseconds,
              child: validationButton(),
            ),
          ],
        ),
      ]),
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
                  "username_updating".tr(),
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

  Widget usernameInput() {
    return Container(
      width: 370.0,
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom: 80.0,
      ),
      child: Column(
        children: <Widget>[
          TextFormField(
            autofocus: true,
            controller: _usernameController,
            decoration: InputDecoration(
              fillColor: Colors.white,
              focusColor: Constants.colors.clairPink,
              labelText: "username_new".tr(),
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
            ),
            keyboardType: TextInputType.text,
            onChanged: (value) async {
              setState(() {
                _newUsername = value;
                _isCheckingName = true;
              });

              final isWellFormatted =
                  UsersActions.checkUsernameFormat(_newUsername);

              if (!isWellFormatted) {
                setState(() {
                  _isCheckingName = false;
                  _nameErrorMessage = _newUsername.length < 3
                      ? "input_minimum_char".tr()
                      : "input_valid_format".tr();
                });

                return;
              }

              if (_nameTimer != null) {
                _nameTimer!.cancel();
                _nameTimer = null;
              }

              _nameTimer = Timer(1.seconds, () async {
                _isNameAvailable =
                    await UsersActions.checkUsernameAvailability(_newUsername);

                if (!_isNameAvailable) {
                  setState(() {
                    _isCheckingName = false;
                    _nameErrorMessage = "username_not_available".tr();
                  });

                  return;
                }

                setState(() {
                  _isCheckingName = false;
                  _nameErrorMessage = '';
                });
              });
            },
          ),
          if (_isCheckingName)
            Container(
              width: 230.0,
              padding: const EdgeInsets.only(left: 40.0),
              child: const LinearProgressIndicator(),
            ),
          if (_nameErrorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 40.0, top: 5.0),
              child: Text(
                _nameErrorMessage,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 15.0,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget validationButton() {
    return ElevatedButton(
      onPressed: tryUpdateUsername,
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
                "username_update".tr().toUpperCase(),
                style: const TextStyle(
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

  bool checkInputsFormat() {
    final isWellFormatted = UsersActions.checkUsernameFormat(_newUsername);

    if (!isWellFormatted) {
      setState(() {
        _isCheckingName = false;
        _nameErrorMessage = _newUsername.length < 3
            ? "input_minimum_char".tr()
            : "input_valid_format".tr();
      });

      return false;
    }

    return true;
  }

  void tryUpdateUsername() async {
    if (!checkInputsFormat()) {
      return;
    }

    setState(() {
      _isUpdating = true;
    });

    try {
      final bool isNameAvailable =
          await UsersActions.checkUsernameAvailability(_newUsername);

      if (!isNameAvailable) {
        if (!mounted) return;

        setState(() {
          _isCompleted = false;
          _isUpdating = false;
        });

        Snack.error(
          context,
          title: "username".tr(),
          message: "username_not_available_args".tr(args: [_newUsername]),
        );

        return;
      }

      final userAuth = FirebaseAuth.instance.currentUser;
      if (!mounted) return;

      if (userAuth == null) {
        setState(() {
          _isCompleted = false;
          _isUpdating = false;
        });

        Beamer.of(context).beamToNamed(SigninLocation.route);
        return;
      }

      // final UserNotifier userNotifier = AppState.getUserNotifier();
      final UserNotifier userNotifier =
          ref.read(AppState.userProvider.notifier);

      final usernameUpdateResponse = await userNotifier.updateUsername(
        _newUsername,
      );

      if (!usernameUpdateResponse.success) {
        if (!mounted) return;

        setState(() {
          _isCompleted = false;
          _isUpdating = false;
        });

        final CloudFuncError? exception = usernameUpdateResponse.error;
        if (exception == null) return;

        Snack.error(
          context,
          title: "username".tr(),
          message: "[code: ${exception.code}] - ${exception.message}",
        );

        return;
      }

      if (!mounted) return;

      setState(() {
        _isCompleted = true;
        _isUpdating = false;
        _newUsername = "";
      });

      Snack.success(
        context,
        title: "username".tr(),
        message: "username_update_success".tr(),
      );
    } catch (error) {
      loggy.error(error);
      setState(() {
        _isCompleted = false;
        _isUpdating = false;
      });

      Snack.error(
        context,
        title: "username".tr(),
        message: "username_update_error".tr(),
      );
    }
  }

  void showTipsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          backgroundColor: Constants.colors.clairPink,
          title: Text(
            "username_current".tr(),
            style: const TextStyle(
              fontSize: 15.0,
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
                  _username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25.0,
              ),
              child: Opacity(
                opacity: 0.6,
                child: Text(
                  "username_choose_description".tr(),
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
