import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:rootasjey/components/activity_row.dart';
import 'package:rootasjey/components/arrow_divider.dart';
import 'package:rootasjey/components/underlined_button.dart';
import 'package:rootasjey/router/locations/activities_location.dart';
import 'package:rootasjey/types/globals/globals.dart';
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
  bool _isSmallView = false;
  List<Event> _userActivities = [];

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    _isSmallView = false;

    final viewWidth = MediaQuery.of(context).size.width;
    double minHeight = MediaQuery.of(context).size.height;

    List<Widget> wrapChildren = [
      leftSide(),
      rightSide(),
    ];

    EdgeInsets padding = const EdgeInsets.only(
      top: 100.0,
      left: 120.0,
      right: 120.0,
    );

    if (viewWidth < Constants.maxMobileWidth) {
      _isSmallView = true;
      minHeight = 0.0;

      padding = const EdgeInsets.only(
        top: 80.0,
        left: 20.0,
        right: 20.0,
      );

      wrapChildren = [
        rightSide(),
        leftSide(),
      ];
    }

    return Container(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: minHeight),
        child: Column(
          children: [
            ArrowDivider(padding: EdgeInsets.zero),
            Padding(
              padding: padding,
              child: Wrap(
                spacing: 0.0,
                runSpacing: 20.0,
                children: wrapChildren,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget description() {
    return Opacity(
      opacity: 0.8,
      child: Text.rich(
        TextSpan(
          style: FontsUtils.mainStyle(),
          text: "github_description".tr(),
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
            children: _userActivities.map((activity) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 42.0),
                child: ActivityRow(
                  activity: activity,
                ),
              );
            }).toList(),
          ),
          viewMoreButton(),
        ],
      ),
    );
  }

  Widget ppGitHubButton() {
    final Color? textColor = Theme.of(context).textTheme.bodyText1?.color;
    final underlineColor = textColor?.withOpacity(0.6) ?? Colors.black45;

    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: UnderlinedButton(
        onTap: () {
          launch(Constants.githubProfileUrl);
        },
        underlineColor: underlineColor,
        trailing: Icon(
          UniconsLine.arrow_right,
          color: Globals.constants.colors.primary,
        ),
        child: Opacity(
          opacity: 0.6,
          child: Text(
            "follow_me_there".tr(),
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),
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
        fontSize: _isSmallView ? 60.0 : 100.0,
        height: 1.2,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget viewMoreButton() {
    return OutlinedButton(
      onPressed: () {
        Beamer.of(context).beamToNamed(ActivitiesLocation.route);
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
        if (!mounted) {
          return;
        }

        setState(() {
          _userActivities = activities;
        });
      });
    } catch (error) {
      appLogger.e(error);
    }
  }
}
