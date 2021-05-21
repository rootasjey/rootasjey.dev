import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/utils/fonts.dart';
import 'package:unicons/unicons.dart';
import 'package:url_launcher/url_launcher.dart';

class LandingInside extends StatefulWidget {
  @override
  _LandingInsideState createState() => _LandingInsideState();
}

class _LandingInsideState extends State<LandingInside> {
  final maxTextWidth = 400.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: stateColors.newLightBackground,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.only(
        top: 200.0,
        left: 120.0,
        right: 120.0,
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title(),
              descriptionOne(),
              descriptionTwo(),
              callToAction(),
              disclaimer(),
              buttonsRow(),
            ],
          ),
          Expanded(
            child: Icon(
              UniconsLine.box,
              size: 160.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget buttonsRow() {
    return Padding(
      padding: const EdgeInsets.only(top: 42.0),
      child: Wrap(
        spacing: 24.0,
        runSpacing: 24.0,
        children: [
          OutlinedButton(
            onPressed: () {
              launch("https://flutter.dev");
            },
            style: OutlinedButton.styleFrom(
              primary: Colors.pink,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Start with Flutter".toUpperCase(),
                    style: FontsUtils.mainStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(UniconsLine.external_link_alt, size: 18.0),
                  ),
                ],
              ),
            ),
          ),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              primary: Colors.pink,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Continue reading".toUpperCase(),
                    style: FontsUtils.mainStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(UniconsLine.arrow_right),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget descriptionOne() {
    return Container(
      width: maxTextWidth,
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Opacity(
        opacity: 0.8,
        child: Text.rich(
          TextSpan(
            style: FontsUtils.mainStyle(),
            text: "Chances are if you're a developer "
                "like us you may find useful that this website "
                "is built with ",
            children: [
              TextSpan(
                text: "Flutter ",
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launch("https://flutter.dev");
                  },
                style: FontsUtils.mainStyle(
                  color: Colors.pink,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: "and ",
              ),
              TextSpan(
                text: "Firebase.",
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launch("https://firebase.google.com");
                  },
                style: FontsUtils.mainStyle(
                  color: Colors.pink,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget descriptionTwo() {
    return Container(
      width: maxTextWidth,
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Opacity(
        opacity: 0.8,
        child: Text.rich(
          TextSpan(
            style: FontsUtils.mainStyle(),
            text: "This allow us to publish an app "
                "for Web, but also iOS and Android with a single code base. "
                "Flutter even target desktop in beta release for now.",
          ),
        ),
      ),
    );
  }

  Widget callToAction() {
    return Opacity(
      opacity: 0.8,
      child: Text.rich(
        TextSpan(
          text: "You can start with Flutter today.",
          style: FontsUtils.mainStyle(
            color: Colors.pink,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }

  Widget disclaimer() {
    return Opacity(
      opacity: 0.5,
      child: Text.rich(
        TextSpan(
          style: FontsUtils.mainStyle(),
          text: "We're NOT affiliated with Flutter.",
        ),
      ),
    );
  }

  Widget title() {
    return Text(
      "What's \ninside?",
      style: FontsUtils.mainStyle(
        fontSize: 100.0,
        height: 1.0,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}
