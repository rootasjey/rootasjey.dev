import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/router/route_names.dart';
import 'package:rootasjey/router/router.dart';
import 'package:rootasjey/state/user_state.dart';
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
          padding: const EdgeInsets.only(
            bottom: 30.0,
            left: 15.0
          ),
          child: Opacity(
            opacity: .5,
            child: Text(
              'DEVELOPERS',
              style: titleStyle,
            ),
          ),
        ),

        FlatButton(
          onPressed: null,
          child: Opacity(
            opacity: .5,
            child: Text(
              'Documentation',
              style: linkStyle,
            ),
          )
        ),

        FlatButton(
          onPressed: () async {
            onBeforeNav();
            await launch('https://github.com/rootasjey/rootasjey.dev');
          },
          child: Opacity(
            opacity: .5,
            child: Text(
              'GitHub',
              style: linkStyle,
            ),
          )
        ),
      ],
    );
  }

  Widget languages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            bottom: 30.0,
            left: 15.0
          ),
          child: Opacity(
            opacity: .5,
            child: Text(
              'LANGUAGE',
              style: titleStyle,
            ),
          ),
        ),

        FlatButton(
          onPressed: () async {
            onBeforeNav();
            // Language.setLang(Language.en);
            updateUserAccountLang();
          },
          child: Opacity(
            opacity: .5,
            child: Text(
              'English',
              style: linkStyle,
            ),
          )
        ),

        FlatButton(
          onPressed: () {
            onBeforeNav();
            // Language.setLang(Language.fr);
            updateUserAccountLang();
          },
          child: Opacity(
            opacity: .5,
            child: Text(
              'Français',
              style: linkStyle,
            ),
          )
        ),
      ],
    );
  }

  Widget resourcesLinks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            bottom: 30.0,
            left: 15.0
          ),
          child: Opacity(
            opacity: .5,
            child: Text(
              'RESOURCES',
              style: titleStyle,
            ),
          ),
        ),

        FlatButton(
          onPressed: () {
            onBeforeNav();
            FluroRouter.router.navigateTo(context, AboutRoute);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Opacity(
                opacity: .5,
                child: Text(
                  'About',
                  style: linkStyle,
                ),
              ),
            ],
          )
        ),

        FlatButton(
          onPressed: () {
            onBeforeNav();
            FluroRouter.router.navigateTo(context, ContactRoute);
          },
          child: Opacity(
            opacity: .5,
            child: Text(
              'Contact',
              style: linkStyle,
            ),
          )
        ),

        FlatButton(
          onPressed: () {
            onBeforeNav();
            FluroRouter.router.navigateTo(context, MeRoute);
          },
          child: Opacity(
            opacity: .5,
            child: Text(
              'Who am I?',
              style: linkStyle,
            ),
          )
        ),
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
      FluroRouter.router.navigateTo(context, RootRoute);
    }

    showSnack(
      context: context,
      message: 'Your language has been successfully updated.',
      type: SnackType.success,
    );
  }

  void onBeforeNav() {
    if (widget.closeModalOnNav) {
      Navigator.pop(context);
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
          'lang': userState.lang,
        }
      );

      notifyLangSuccess();

    } catch (error) {
      debugPrint(error.toString());

      showSnack(
        context: context,
        message: 'Sorry, there was an error while updating your language.',
        type: SnackType.error,
      );
    }
  }
}
