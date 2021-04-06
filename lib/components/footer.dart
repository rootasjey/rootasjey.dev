import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:rootasjey/router/app_router.gr.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/state/user.dart';
import 'package:rootasjey/utils/fonts.dart';
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
  final titleStyle = FontsUtils.mainStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w400,
  );

  final linkStyle = FontsUtils.mainStyle(
    fontSize: 17.0,
    fontWeight: FontWeight.w300,
  );

  final titlePadding = const EdgeInsets.only(bottom: 30.0);

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      final alignment = MediaQuery.of(context).size.width < 700.0
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
    });
  }

  Widget developers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: titlePadding,
          child: Opacity(
            opacity: 0.5,
            child: Text(
              "developers".tr().toUpperCase(),
              style: titleStyle,
            ),
          ),
        ),
        textLink(label: "documentation".tr()),
        textLink(
          label: "github".tr(),
          onPressed: () async {
            onBeforeNav();
            await launch('https://github.com/rootasjey/rootasjey.dev');
          },
        ),
      ],
    );
  }

  Widget languages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: titlePadding,
          child: Opacity(
            opacity: 0.5,
            child: Text(
              "language".tr().toUpperCase(),
              style: titleStyle,
            ),
          ),
        ),
        textLink(
          label: 'English',
          onPressed: () async {
            onBeforeNav();
            updateUserAccountLang();
          },
        ),
        textLink(
          label: 'Français',
          onPressed: () async {
            onBeforeNav();
            updateUserAccountLang();
          },
        ),
      ],
    );
  }

  Widget resourcesLinks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: titlePadding,
          child: Opacity(
            opacity: 0.5,
            child: Text(
              "resources".tr().toUpperCase(),
              style: titleStyle,
            ),
          ),
        ),
        textLink(
          label: "about".tr(),
          onPressed: () {
            onBeforeNav();
            context.router.push(AboutRoute());
          },
        ),
        textLink(
          label: "contact".tr(),
          onPressed: () {
            onBeforeNav();
            context.router.push(ContactRoute());
          },
        ),
        textLink(
          label: "who_am_i".tr(),
          onPressed: () {
            onBeforeNav();
            context.router.push(AboutMeRoute());
          },
        ),
      ],
    );
  }

  Widget textLink({
    VoidCallback onPressed,
    @required String label,
  }) {
    return TextButton(
      onPressed: onPressed,
      child: Opacity(
        opacity: 0.5,
        child: Text(
          label,
          style: FontsUtils.mainStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      style: TextButton.styleFrom(
        primary: stateColors.foreground,
      ),
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
