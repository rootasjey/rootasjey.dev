import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:rootasjey/components/activity_row.dart';
import 'package:rootasjey/components/arrow_divider.dart';
import 'package:rootasjey/components/better_avatar.dart';
import 'package:rootasjey/components/underlined_button.dart';
import 'package:rootasjey/router/app_router.gr.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/utils/app_logger.dart';
import 'package:rootasjey/utils/constants.dart';
import 'package:rootasjey/utils/fonts.dart';
import 'package:unicons/unicons.dart';
import 'package:url_launcher/url_launcher.dart';

class LandingGitHub extends StatefulWidget {
  @override
  _LandingGitHubState createState() => _LandingGitHubState();
}

class _LandingGitHubState extends State<LandingGitHub> {
  List<Event> userActivities = [];

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: stateColors.newLightBackground,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          ArrowDivider(),
          Padding(
            padding: const EdgeInsets.only(
              top: 100.0,
              left: 120.0,
              right: 120.0,
            ),
            child: Wrap(
              spacing: 0.0,
              runSpacing: 20.0,
              children: [
                leftSide(),
                rightSide(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget leftSide() {
    return Container(
      width: 400.0,
      padding: const EdgeInsets.only(
        right: 10.0,
        top: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: userActivities.map((activity) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 42.0),
                child: ActivityRow(activity: activity),
              );
            }).toList(),
          ),
          viewMoreButton(),
        ],
      ),
    );
  }

  Widget rightSide() {
    return Container(
      width: 500.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title(),
          description(),
          ppGitHubButton(),
        ],
      ),
    );
  }

  Widget title() {
    return Text(
      "GitHub Activity",
      style: FontsUtils.mainStyle(
        fontSize: 100.0,
        height: 1.2,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget description() {
    return Opacity(
      opacity: 0.8,
      child: Text.rich(
        TextSpan(
          style: FontsUtils.mainStyle(),
          text: "This is my public activity "
              "about programming. I mainly use GitHub "
              "for my projects. Most of my projects are under ",
          children: [
            TextSpan(
              text: "Mozilla Public License 2.0",
              style: FontsUtils.mainStyle(
                color: Colors.pink,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget ppGitHubButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: UnderlinedButton(
        onTap: () {
          launch(Constants.githubProfileUrl);
        },
        leading: BetterAvatar(
          size: 30.0,
          elevation: 0.0,
          image: AssetImage(
            'assets/images/jeje.jpg',
          ),
        ),
        trailing: Icon(
          UniconsLine.arrow_right,
          color: stateColors.primary,
        ),
        textValue: "Follow me there",
      ),
    );
  }

  Widget viewMoreButton() {
    return OutlinedButton(
      onPressed: () {
        context.router.push(ActivitiesPageRoute());
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 200.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "View more".toUpperCase(),
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
      style: OutlinedButton.styleFrom(
        primary: Colors.pink,
      ),
    );
  }

  void fetch() async {
    try {
      final github = GitHub();

      github.activity
          .listPublicEventsPerformedByUser('rootasjey')
          .take(3)
          .toList()
          .then((activities) {
        setState(() {
          userActivities = activities;
        });
      });
    } catch (error) {
      appLogger.e(error);
    }
  }
}
