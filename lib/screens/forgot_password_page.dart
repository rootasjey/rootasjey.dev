import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/actions/users.dart';
import 'package:rootasjey/components/fade_in_x.dart';
import 'package:rootasjey/components/fade_in_y.dart';
import 'package:rootasjey/components/loading_animation.dart';
import 'package:rootasjey/components/application_bar/main_app_bar.dart';
import 'package:rootasjey/router/locations/home_location.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/utils/app_logger.dart';
import 'package:rootasjey/utils/snack.dart';
import 'package:supercharged/supercharged.dart';
import 'package:unicons/unicons.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  String email = '';

  bool isCompleted = false;
  bool isLoading = false;

  final passwordNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          MainAppBar(),
          SliverList(
            delegate: SliverChildListDelegate.fixed([
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 60.0, bottom: 300.0),
                    child: SizedBox(
                      width: 320,
                      child: body(),
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget body() {
    if (isCompleted) {
      return completedContainer();
    }

    if (isLoading) {
      return Padding(
        padding: const EdgeInsets.only(top: 80.0),
        child: LoadingAnimation(
          textTitle: "email_sending".tr(),
        ),
      );
    }

    return idleContainer();
  }

  Widget completedContainer() {
    final width = MediaQuery.of(context).size.width;

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Icon(
            Icons.check_circle,
            size: 80.0,
            color: Colors.green,
          ),
        ),
        Container(
          width: width > 400.0 ? 320.0 : 280.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 10.0),
                child: Text(
                  "email_password_reset_link".tr(),
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
              Opacity(
                opacity: .6,
                child: Text("email_check_spam".tr()),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 55.0,
          ),
          child: TextButton(
            onPressed: () {
              Beamer.of(context).beamToNamed(HomeLocation.route);
            },
            child: Opacity(
              opacity: .6,
              child: Text(
                'Return to home',
              ),
            ),
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
        validationButton(),
      ],
    );
  }

  Widget emailInput() {
    return FadeInY(
      delay: 100.milliseconds,
      beginY: 50.0,
      child: Padding(
        padding: EdgeInsets.only(
          top: 40.0,
          left: 15.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              autofocus: true,
              decoration: InputDecoration(
                icon: Icon(Icons.email),
                labelText: "email".tr(),
              ),
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                email = value;
              },
              onFieldSubmitted: (value) => sendResetLink(),
              validator: (value) {
                if (value!.isEmpty) {
                  return "email_empty_forbidden".tr();
                }

                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (Beamer.of(context).beamingHistory.isNotEmpty)
          FadeInX(
            beginX: 10.0,
            delay: 100.milliseconds,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 20.0,
              ),
              child: IconButton(
                onPressed: Beamer.of(context).beamBack,
                icon: Icon(UniconsLine.arrow_left),
              ),
            ),
          ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FadeInY(
                beginY: 50.0,
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "password_forgot".tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              FadeInY(
                beginY: 50.0,
                child: Opacity(
                  opacity: 0.6,
                  child: Text(
                    "password_forgot_reset_process".tr(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget validationButton() {
    return FadeInY(
      delay: 200.milliseconds,
      beginY: 50.0,
      child: Padding(
        padding: const EdgeInsets.only(top: 80.0),
        child: ElevatedButton(
          onPressed: sendResetLink,
          style: ElevatedButton.styleFrom(
            primary: stateColors.primary,
            textStyle: TextStyle(
              color: Colors.white,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("link_send".tr().toUpperCase()),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Icon(UniconsLine.envelope),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool inputValuesOk() {
    if (email.isEmpty) {
      Snack.e(
        context: context,
        message: "email_empty_no_valid".tr(),
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

    return true;
  }

  void sendResetLink() async {
    if (!inputValuesOk()) {
      return;
    }
    try {
      setState(() {
        isLoading = true;
        isCompleted = false;
      });

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      setState(() {
        isLoading = false;
        isCompleted = true;
      });
    } catch (error) {
      appLogger.e(error);

      setState(() {
        isLoading = false;
      });

      Snack.e(
        context: context,
        message: "email_doesnt_exist".tr(),
      );
    }
  }
}
