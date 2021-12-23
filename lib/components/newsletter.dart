import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/actions/users.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/utils/app_logger.dart';
import 'package:rootasjey/utils/fonts.dart';
import 'package:rootasjey/utils/snack.dart';
import 'package:unicons/unicons.dart';

class Newsletter extends StatefulWidget {
  @override
  _NewsletterState createState() => _NewsletterState();
}

bool _isSubscribed = false;

class _NewsletterState extends State<Newsletter> {
  bool isLoading = false;

  String email = '';
  String? errorText;

  final newsreaderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(0, 0, 0, 0.02),
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 40.0,
      ),
      child: body(),
    );
  }

  Widget body() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_isSubscribed) {
      return completedView();
    }

    return idleView();
  }

  Widget idleView() {
    return LayoutBuilder(
      builder: (context, boxContraints) {
        final titleFontSize = boxContraints.maxWidth < 700.0 ? 24.0 : 40.0;

        final subtitleFontSize = boxContraints.maxWidth < 700.0 ? 20.0 : 16.0;

        return Column(
          children: [
            Icon(UniconsLine.envelope, size: 80.0),
            Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
                bottom: 8.0,
              ),
              child: Opacity(
                opacity: 0.8,
                child: Text(
                  "newsletter_title".tr(),
                  textAlign: TextAlign.center,
                  style: FontsUtils.mainStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Opacity(
              opacity: 0.6,
              child: Text(
                "newsletter_rate".tr(),
                textAlign: TextAlign.center,
                style: FontsUtils.mainStyle(
                  fontSize: subtitleFontSize,
                ),
              ),
            ),
            Container(
              width: 500.0,
              padding: const EdgeInsets.only(
                top: 60.0,
                bottom: 40.0,
              ),
              child: TextFormField(
                controller: newsreaderController,
                decoration: InputDecoration(
                  labelText: "your_email".tr(),
                  border: OutlineInputBorder(),
                  errorText: errorText,
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;

                  final isWellFormatted = UsersActions.checkEmailFormat(email);
                  errorText = isWellFormatted ? null : "email_not_valid".tr();

                  setState(() {});
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "email_empty_forbidden".tr();
                  }

                  final isWellFormatted = UsersActions.checkEmailFormat(email);
                  if (!isWellFormatted) {
                    return "email_not_valid".tr();
                  }

                  return null;
                },
              ),
            ),
            ElevatedButton(
              onPressed: subscribe,
              style: ElevatedButton.styleFrom(
                textStyle: FontsUtils.mainStyle(
                  color: stateColors.primary,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 16.0,
                ),
              ),
              child: SizedBox(
                width: 200.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "subscribe".tr().toUpperCase(),
                        style: FontsUtils.mainStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child:
                            Icon(UniconsLine.arrow_right, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget completedView() {
    return Column(
      children: [
        Icon(
          Icons.favorite,
          color: Colors.pink,
          size: 80.0,
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 20.0,
            bottom: 8.0,
          ),
          child: Text(
            "thank_you_exclamation".tr(),
            style: FontsUtils.mainStyle(
              fontSize: 40.0,
            ),
          ),
        ),
        Opacity(
          opacity: 0.6,
          child: Text(
            "thank_you_newsletter".tr(),
            style: FontsUtils.mainStyle(
              fontSize: 20.0,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: TextButton(
            onPressed: () => setState(() => _isSubscribed = false),
            child: Text("email_use_other".tr()),
          ),
        ),
      ],
    );
  }

  void subscribe() async {
    final isWellFormatted = UsersActions.checkEmailFormat(email);

    if (!isWellFormatted) {
      Snack.e(
        context: context,
        message: "email_not_valid".tr(),
      );

      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('newsreaders').doc().set({
        'email': email,
        'categories': {
          'all': true,
        },
        'rng': Random().nextInt(100000),
        'seed': Random().nextInt(100000),
      });

      setState(() {
        isLoading = false;
        _isSubscribed = true;
      });
    } catch (error) {
      appLogger.e(error);
      setState(() => isLoading = false);
    }
  }
}
