import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
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
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';

class UpdateUsername extends StatefulWidget {
  @override
  _UpdateUsernameState createState() => _UpdateUsernameState();
}

class _UpdateUsernameState extends State<UpdateUsername> {
  bool isCheckingAuth = false;
  bool isUpdating = false;
  bool isCheckingName = false;
  bool isCompleted = false;
  bool isNameAvailable = false;

  final beginY = 10.0;
  final passwordNode = FocusNode();
  final usernameController = TextEditingController();
  final _pageScrollController = ScrollController();

  String currentUsername = '';
  String nameErrorMessage = '';
  String newUsername = '';

  Timer nameTimer;

  @override
  void initState() {
    super.initState();
    checkAuth();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _pageScrollController,
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
      showNavBackIcon: true,
      textTitle: "username_update".tr(),
      textSubTitle: "username_update_description".tr(),
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
    return SliverList(
      delegate: SliverChildListDelegate([
        Column(
          children: [
            FadeInY(
              beginY: 10.0,
              child: currentUsernameCard(),
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

  Widget currentUsernameCard() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 80.0,
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
                      child: Text("username_current".tr()),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 35.0),
                      child: Text(
                        currentUsername,
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
                    "username_current".tr(),
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
                          currentUsername,
                          style: FontsUtils.mainStyle(
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
                  "username_updating".tr(),
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

  Widget usernameInput() {
    return Container(
      width: 400.0,
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom: 80.0,
      ),
      child: Column(
        children: <Widget>[
          TextFormField(
            autofocus: true,
            controller: usernameController,
            decoration: InputDecoration(
              icon: Icon(Icons.person_outline),
              labelText: "username_new".tr(),
            ),
            keyboardType: TextInputType.text,
            onChanged: (value) async {
              setState(() {
                newUsername = value;
                isCheckingName = true;
              });

              final isWellFormatted =
                  UsersActions.checkUsernameFormat(newUsername);

              if (!isWellFormatted) {
                setState(() {
                  isCheckingName = false;
                  nameErrorMessage = newUsername.length < 3
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
                isNameAvailable =
                    await UsersActions.checkUsernameAvailability(newUsername);

                if (!isNameAvailable) {
                  setState(() {
                    isCheckingName = false;
                    nameErrorMessage = "username_not_available".tr();
                  });

                  return;
                }

                setState(() {
                  isCheckingName = false;
                  nameErrorMessage = '';
                });
              });
            },
          ),
          if (isCheckingName)
            Container(
              width: 230.0,
              padding: const EdgeInsets.only(left: 40.0),
              child: LinearProgressIndicator(),
            ),
          if (nameErrorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 40.0, top: 5.0),
              child: Text(
                nameErrorMessage,
                style: TextStyle(
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
    return OutlinedButton.icon(
      onPressed: () => updateUsernameProcess(),
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
                "username_update".tr(),
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

  void checkAuth() async {
    setState(() {
      isCheckingAuth = true;
    });

    try {
      final userAuth = stateUser.userAuth;

      setState(() {
        isCheckingAuth = false;
      });

      if (userAuth == null) {
        return;
      }

      final user = await FirebaseFirestore.instance
          .collection('users')
          .doc(userAuth.uid)
          .get();

      final data = user.data();

      setState(() {
        currentUsername = data['name'] ?? '';
      });
    } catch (error) {
      appLogger.e(error);
    }
  }

  bool inputValuesOk() {
    final isWellFormatted = UsersActions.checkUsernameFormat(newUsername);

    if (!isWellFormatted) {
      setState(() {
        isCheckingName = false;
        nameErrorMessage = newUsername.length < 3
            ? "input_minimum_char".tr()
            : "input_valid_format".tr();
      });

      return false;
    }

    return true;
  }

  void updateUsernameProcess() async {
    if (!inputValuesOk()) {
      return;
    }

    setState(() {
      isUpdating = true;
    });

    try {
      isNameAvailable =
          await UsersActions.checkUsernameAvailability(newUsername);

      if (!isNameAvailable) {
        setState(() {
          isCompleted = false;
          isUpdating = false;
        });

        Snack.e(
          context: context,
          message: "username_not_available_args".tr(args: [newUsername]),
        );

        return;
      }

      final userAuth = stateUser.userAuth;

      if (userAuth == null) {
        setState(() {
          isCompleted = false;
          isUpdating = false;
        });

        context.router.navigate(SigninRoute());
        return;
      }

      final usernameUpdateResp = await stateUser.updateUsername(newUsername);

      if (!usernameUpdateResp.success) {
        final exception = usernameUpdateResp.error;

        setState(() {
          isCompleted = false;
          isUpdating = false;
        });

        Snack.e(
          context: context,
          message: "[code: ${exception.code}] - ${exception.message}",
        );

        return;
      }

      setState(() {
        isCompleted = true;
        isUpdating = false;
        currentUsername = newUsername;
        newUsername = '';
      });

      stateUser.setUsername(currentUsername);

      Snack.s(
        context: context,
        message: "username_update_success".tr(),
      );

      // Navigator.of(context).pop();
    } catch (error) {
      debugPrint(error.toString());

      setState(() {
        isCompleted = false;
        isUpdating = false;
      });

      Snack.e(
        context: context,
        message: "username_update_error".tr(),
      );
    }
  }
}
