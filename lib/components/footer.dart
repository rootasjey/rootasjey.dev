import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/router/app_router.gr.dart';
import 'package:rootasjey/state/user.dart';
import 'package:rootasjey/utils/snack.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatefulWidget {
  final ScrollController pageScrollController;
  final bool closeModalOnNav;
  final bool autoNavToHome;

  Footer({
    this.autoNavToHome = true,
    this.pageScrollController,
    this.closeModalOnNav = false,
  });

  @override
  _FooterState createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  final titleStyle = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w400,
  );

  final linkStyle = TextStyle(
    fontSize: 17.0,
    fontWeight: FontWeight.w300,
  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, boxConstraints) {
        final alignment = boxConstraints.maxWidth < 700.0
            ? WrapAlignment.spaceBetween
            : WrapAlignment.spaceAround;

        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 60.0,
            vertical: 90.0,
          ),
          foregroundDecoration: BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, 0.1),
          ),
          child: Wrap(
            runSpacing: 80.0,
            alignment: alignment,
            children: <Widget>[
              languages(),
              developers(),
              resourcesLinks(),
            ],
          ),
        );
      },
    );
  }

  Widget developers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 30.0, left: 15.0),
          child: Opacity(
            opacity: 0.5,
            child: Text(
              "developers".tr().toUpperCase(),
              style: titleStyle,
            ),
          ),
        ),
        TextButton(
            onPressed: null,
            child: Opacity(
              opacity: 0.5,
              child: Text(
                "documentation".tr(),
                style: linkStyle,
              ),
            )),
        TextButton(
            onPressed: () async {
              onBeforeNav();
              await launch('https://github.com/rootasjey/rootasjey.dev');
            },
            child: Opacity(
              opacity: 0.5,
              child: Text(
                "GitHub",
                style: linkStyle,
              ),
            )),
      ],
    );
  }

  Widget languages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 30.0, left: 15.0),
          child: Opacity(
            opacity: 0.5,
            child: Text(
              "language".tr().toUpperCase(),
              style: titleStyle,
            ),
          ),
        ),
        TextButton(
            onPressed: () async {
              onBeforeNav();
              updateUserAccountLang();
            },
            child: Opacity(
              opacity: 0.5,
              child: Text(
                'English',
                style: linkStyle,
              ),
            )),
        TextButton(
            onPressed: () {
              onBeforeNav();
              updateUserAccountLang();
            },
            child: Opacity(
              opacity: 0.5,
              child: Text(
                'Français',
                style: linkStyle,
              ),
            )),
      ],
    );
  }

  Widget resourcesLinks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 30.0, left: 15.0),
          child: Opacity(
            opacity: 0.5,
            child: Text(
              "resources".tr().toUpperCase(),
              style: titleStyle,
            ),
          ),
        ),
        TextButton(
            onPressed: () {
              onBeforeNav();
              context.router.push(AboutRoute());
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Opacity(
                  opacity: 0.5,
                  child: Text(
                    "about".tr(),
                    style: linkStyle,
                  ),
                ),
              ],
            )),
        TextButton(
            onPressed: () {
              onBeforeNav();
              context.router.push(ContactRoute());
            },
            child: Opacity(
              opacity: 0.5,
              child: Text(
                "contact".tr(),
                style: linkStyle,
              ),
            )),
        TextButton(
            onPressed: () {
              onBeforeNav();
              context.router.push(AboutMeRoute());
            },
            child: Opacity(
              opacity: 0.5,
              child: Text(
                "who_am_i".tr(),
                style: linkStyle,
              ),
            )),
      ],
    );
  }

  void notifyLangSuccess() {
    if (widget.pageScrollController != null) {
      widget.pageScrollController.animateTo(
        0.0,
        duration: Duration(seconds: 1),
        curve: Curves.easeOut,
      );
    } else if (widget.autoNavToHome) {
      context.router.push(HomeRoute());
    }

    Snack.s(
      context: context,
      message: "language_update_success".tr(),
    );
  }

  void onBeforeNav() {
    if (widget.closeModalOnNav) {
      context.router.pop();
    }
  }

  void updateUserAccountLang() async {
    final userAuth = FirebaseAuth.instance.currentUser;

    if (userAuth == null) {
      notifyLangSuccess();
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userAuth.uid)
          .update({
        'lang': stateUser.lang,
      });

      notifyLangSuccess();
    } catch (error) {
      debugPrint(error.toString());

      Snack.e(
        context: context,
        message: "language_update_error".tr(),
      );
    }
  }
}
