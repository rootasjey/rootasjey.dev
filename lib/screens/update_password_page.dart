import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rootasjey/components/fade_in_y.dart';
import 'package:rootasjey/globals/app_state.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/utils/snack.dart';
import 'package:rootasjey/utils/storage_utils.dart';
import 'package:supercharged/supercharged.dart';
import 'package:unicons/unicons.dart';

class UpdatePasswordPage extends ConsumerStatefulWidget {
  const UpdatePasswordPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends ConsumerState<UpdatePasswordPage> {
  bool isCompleted = false;
  bool isUpdating = false;

  double beginY = 10.0;

  final newPasswordNode = FocusNode();

  String password = '';
  String newPassword = '';

  @override
  void dispose() {
    newPasswordNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          header(),
          body(),
        ],
      ),
    );
  }

  Widget body() {
    if (isCompleted) {
      return completedView();
    }

    if (isUpdating) {
      return updatingScreen();
    }

    return idleView();
  }

  Widget completedView() {
    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 80.0),
                child: Icon(
                  UniconsLine.check,
                  color: Constants.colors.validation,
                  size: 80.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 0.0),
                child: Text(
                  "password_update_success".tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget currentPasswordInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      width: 400.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            autofocus: true,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              fillColor: Colors.white,
              focusColor: Constants.colors.clairPink,
              labelText: "password_current".tr(),
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
            ),
            onChanged: (value) {
              password = value;
            },
            onFieldSubmitted: (_) => newPasswordNode.requestFocus(),
            obscureText: true,
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
                          "password_update".tr(),
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
                            "password_update_description".tr(),
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

  Widget helpCard() {
    return Container(
      padding: const EdgeInsets.only(
        left: 25.0,
        right: 25.0,
        top: 80.0,
        bottom: 40.0,
      ),
      width: 378.0,
      child: Card(
        color: Constants.colors.clairPink,
        child: ListTile(
          contentPadding: const EdgeInsets.all(16.0),
          leading: const Icon(UniconsLine.question),
          title: Opacity(
            opacity: 0.6,
            child: Text(
              "password_choosing_good".tr(),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          subtitle: Text(
            "password_choosing_good_desc".tr(),
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          onTap: showTipsDialog,
        ),
      ),
    );
  }

  Widget idleView() {
    return SliverList(
      delegate: SliverChildListDelegate([
        Column(
          children: <Widget>[
            FadeInY(
              delay: 0.milliseconds,
              beginY: beginY,
              child: helpCard(),
            ),
            FadeInY(
              delay: 100.milliseconds,
              beginY: beginY,
              child: currentPasswordInput(),
            ),
            FadeInY(
              delay: 200.milliseconds,
              beginY: beginY,
              child: newPasswordInput(),
            ),
            FadeInY(
              delay: 300.milliseconds,
              beginY: beginY,
              child: validationButton(),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 200.0),
            ),
          ],
        ),
      ]),
    );
  }

  Widget newPasswordInput() {
    return Container(
      width: 400.0,
      padding: const EdgeInsets.only(
        top: 20.0,
        bottom: 60.0,
        left: 40.0,
        right: 40.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            focusNode: newPasswordNode,
            decoration: InputDecoration(
              fillColor: Colors.white,
              focusColor: Constants.colors.clairPink,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              labelText: "password_new".tr(),
              border: const OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2.0,
                ),
              ),
            ),
            obscureText: true,
            onChanged: (value) {
              newPassword = value;
            },
            onFieldSubmitted: (value) => updatePassword(),
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

  Widget textTitle() {
    return Text(
      "password_update".tr(),
      style: const TextStyle(
        fontSize: 35.0,
      ),
    );
  }

  Widget updatingScreen() {
    return SliverList(
        delegate: SliverChildListDelegate([
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Text(
                "password_updating".tr(),
                style: const TextStyle(
                  fontSize: 20.0,
                ),
              ),
            )
          ],
        ),
      ),
    ]));
  }

  Widget validationButton() {
    return ElevatedButton(
      onPressed: updatePassword,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black87,
      ),
      child: SizedBox(
        width: 300.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Text(
                "password_update".tr().toUpperCase(),
                style: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Icon(UniconsLine.check),
          ],
        ),
      ),
    );
  }

  void updatePassword() async {
    if (!checkInputsFormat()) {
      return;
    }

    final userAuth = ref.read(AppState.userProvider).authUser;
    if (userAuth == null) {
      return;
    }

    final credentials = EmailAuthProvider.credential(
      email: userAuth.email ?? '',
      password: password,
    );

    setState(() => isUpdating = true);
    try {
      final authResult =
          await userAuth.reauthenticateWithCredential(credentials);

      final authUserResult = authResult.user;

      if (authUserResult == null) {
        throw ErrorDescription("Wrong email or password");
      }

      await authUserResult.updatePassword(newPassword);
      StorageUtils.setPassword(newPassword);

      setState(() {
        isUpdating = false;
        isCompleted = true;
      });
    } catch (error) {
      setState(() => isUpdating = false);

      Snack.error(
        context,
        title: "password".tr(),
        message: "password_update_error".tr(),
      );
    }
  }

  bool checkInputsFormat() {
    if (password.isEmpty) {
      Snack.error(
        context,
        title: "password".tr(),
        message: "password_empty_forbidden".tr(),
      );

      return false;
    }

    if (newPassword.isEmpty) {
      Snack.error(
        context,
        title: "password".tr(),
        message: "password_empty_forbidden".tr(),
      );

      return false;
    }

    return true;
  }

  void showTipsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          backgroundColor: Constants.colors.clairPink,
          title: Text(
            "password_tips".tr(),
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
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("password_tips_1".tr()),
                  const Padding(padding: EdgeInsets.only(top: 15.0)),
                  Text("password_tips_2".tr()),
                  const Padding(padding: EdgeInsets.only(top: 15.0)),
                  Text("password_tips_3".tr()),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
