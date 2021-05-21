import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/utils/fonts.dart';
import 'package:unicons/unicons.dart';

class LandingWorkUs extends StatefulWidget {
  @override
  _LandingWorkUsState createState() => _LandingWorkUsState();
}

class _LandingWorkUsState extends State<LandingWorkUs> {
  List<Event> userActivities = [];

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
          leftSide(),
          rightSide(),
        ],
      ),
    );
  }

  Widget appCard({
    @required String textTitle,
    @required List<Color> colors,
    @required Widget icon,
  }) {
    return SizedBox(
      width: 260.0,
      height: 150.0,
      child: Card(
        elevation: 4.0,
        child: Container(
          padding: const EdgeInsets.all(22.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
            ),
          ),
          clipBehavior: Clip.hardEdge,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 24.0),
                child: Opacity(
                  opacity: 0.8,
                  child: icon,
                ),
              ),
              Expanded(
                child: Opacity(
                  opacity: 0.8,
                  child: Text(
                    textTitle,
                    style: FontsUtils.mainStyle(
                      color: Colors.white,
                      fontSize: 17.0,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget descriptionOne() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 24.0,
        bottom: 24.0,
      ),
      child: Opacity(
        opacity: 0.8,
        child: Text.rich(
          TextSpan(
            style: FontsUtils.mainStyle(),
            text: "We like good work and we're perfectionists. "
                "Thruth is, we are not satisfied with good, "
                "we love ",
            children: [
              TextSpan(
                text: "great.",
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

  Widget descriptionThree() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12.0,
      ),
      child: Opacity(
        opacity: 0.8,
        child: Text.rich(
          TextSpan(
            style: FontsUtils.mainStyle(),
            text: "Last, working with Firebase and Cloud services means that "
                "you'll only pay for what you use, thus reducing significantly "
                "your maintenance ",
            children: [
              TextSpan(
                text: "cost.",
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
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 24.0,
      ),
      child: Opacity(
        opacity: 0.8,
        child: Text.rich(
          TextSpan(
            style: FontsUtils.mainStyle(),
            text: "Also, our tech stack makes it possible to "
                "target multiple platform with a single code base. "
                "So if you're planning to reach a broad audience, "
                "you'll be in good hands.",
          ),
        ),
      ),
    );
  }

  Widget leftSide() {
    return Container(
      width: 500.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title(),
          descriptionOne(),
          descriptionTwo(),
          descriptionThree(),
        ],
      ),
    );
  }

  Widget mobileCard() {
    return appCard(
      icon: Icon(
        UniconsLine.mobile_android,
        color: Colors.white,
        size: 32.0,
      ),
      textTitle: "Starting at 4000€ for two mobile app on iOS and Android",
      colors: [
        Colors.pink,
        Colors.pink.shade700,
      ],
    );
  }

  Widget rightSide() {
    return Expanded(
      child: Wrap(
        direction: Axis.vertical,
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 16.0,
        children: [
          websiteCard(),
          mobileCard(),
          webMobileCard(),
        ],
      ),
    );
  }

  Widget title() {
    return Text(
      "Work with us <3",
      style: FontsUtils.mainStyle(
        fontSize: 100.0,
        height: 0.9,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget webMobileCard() {
    return appCard(
      icon: Icon(
        UniconsLine.apps,
        color: Colors.white,
        size: 32.0,
      ),
      textTitle: "Starting at 5000€ for a website "
          "and two mobile app on iOS and Android",
      colors: [
        stateColors.primary,
        stateColors.primary.withAlpha(255),
      ],
    );
  }

  Widget websiteCard() {
    return appCard(
      textTitle: "Starting at 1000€ for a website",
      icon: Icon(
        UniconsLine.window,
        color: Colors.white,
        size: 32.0,
      ),
      colors: [
        Colors.blue,
        Colors.blue.shade700,
      ],
    );
  }
}
