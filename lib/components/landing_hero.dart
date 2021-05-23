import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:rootasjey/components/better_avatar.dart';
import 'package:rootasjey/router/app_router.gr.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/utils/constants.dart';
import 'package:rootasjey/utils/fonts.dart';
import 'package:unicons/unicons.dart';
import 'package:url_launcher/url_launcher.dart';

class LandingHero extends StatefulWidget {
  @override
  _LandingHeroState createState() => _LandingHeroState();
}

class _LandingHeroState extends State<LandingHero> {
  bool _isSmallView = false;

  @override
  Widget build(BuildContext context) {
    _isSmallView = false;

    final viewWidth = MediaQuery.of(context).size.width;

    EdgeInsets padding = const EdgeInsets.only(
      top: 200.0,
      left: 120.0,
      right: 120.0,
    );

    if (viewWidth < Constants.maxMobileWidth) {
      _isSmallView = true;

      padding = const EdgeInsets.only(
        top: 80.0,
        left: 20.0,
        right: 20.0,
      );
    }

    return Container(
      color: stateColors.newLightBackground,
      padding: padding,
      child: Wrap(
        spacing: 40.0,
        runSpacing: 20.0,
        children: [
          leftSide(),
          rightSide(),
        ],
      ),
    );
  }

  Widget description() {
    return SizedBox(
      width: 500.0,
      child: Opacity(
        opacity: 0.8,
        child: Text.rich(
          TextSpan(
            style: FontsUtils.mainStyle(),
            text: "The advantage of working with Flutter "
                "& Dart is the ability to develop apps for "
                "Web, iOS, Android, Windows, macOS, Linux, "
                "Backend, and integrated devices. ",
            children: [
              TextSpan(
                text: "That gives a hell lot of options!",
                style: FontsUtils.mainStyle(
                  color: Colors.pink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget desktopViewProjects() {
    return SizedBox(
      width: 320.0,
      height: 600.0,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: projectCard(
              textTitle: "fig.style",
              backgroundUrl: "https://firebasestorage.googleapis.com/v0/b/"
                  "rootasjey.appspot.com/o/images%2Ftemp%2Ffig-xs.jpg"
                  "?alt=media&token=ca59ece7-4fd9-4997-b482-c2976549665f",
            ),
          ),
          Positioned(
            top: 0,
            left: 160.0,
            child: projectCard(
              textTitle: "artbooking",
              height: 300.0,
              backgroundUrl: "https://firebasestorage.googleapis.com/v0/b/"
                  "rootasjey.appspot.com/o/images%2Ftemp%2Fartbooking-xs.png"
                  "?alt=media&token=5f52d86e-7b22-448c-b9c6-c535671eee64",
            ),
          ),
          Positioned(
            top: 160.0,
            left: 0,
            child: projectCard(
              textTitle: "feels",
              height: 300.0,
              backgroundUrl: "https://firebasestorage.googleapis.com/v0/b/"
                  "rootasjey.appspot.com/o/images%2Ftemp%2Fweather.jpg"
                  "?alt=media&token=c2303046-c105-498b-a664-bc1c9d8dcdf8",
            ),
          ),
          Positioned(
            top: 310.0,
            left: 160.0,
            child: projectCard(
              textTitle: "conway",
              backgroundUrl: "https://firebasestorage.googleapis.com/v0/b/"
                  "rootasjey.appspot.com/o/images%2Ftemp%2Fconway.png?"
                  "alt=media&token=3cb34b33-8926-4c77-bdbe-ed3c56859306",
            ),
          ),
        ],
      ),
    );
  }

  Widget leftSide() {
    return SizedBox(
      width: 600.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          topLine(),
          title(),
          description(),
          ppNameSummarySocial(),
        ],
      ),
    );
  }

  Widget mobileViewProjects() {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: Center(
        child: Wrap(
          spacing: 20.0,
          runSpacing: 20.0,
          alignment: WrapAlignment.start,
          children: [
            projectCard(
              textTitle: "fig.style",
              backgroundUrl: "https://firebasestorage.googleapis.com/v0/b/"
                  "rootasjey.appspot.com/o/images%2Ftemp%2Ffig-xs.jpg"
                  "?alt=media&token=ca59ece7-4fd9-4997-b482-c2976549665f",
            ),
            projectCard(
              textTitle: "artbooking",
              backgroundUrl: "https://firebasestorage.googleapis.com/v0/b/"
                  "rootasjey.appspot.com/o/images%2Ftemp%2Fartbooking-xs.png"
                  "?alt=media&token=5f52d86e-7b22-448c-b9c6-c535671eee64",
            ),
            projectCard(
              textTitle: "conway",
              backgroundUrl: "https://firebasestorage.googleapis.com/v0/b/"
                  "rootasjey.appspot.com/o/images%2Ftemp%2Fconway.png?"
                  "alt=media&token=3cb34b33-8926-4c77-bdbe-ed3c56859306",
            ),
          ],
        ),
      ),
    );
  }

  Widget ppNameSummarySocial() {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: Row(
        children: [
          profilePicture(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "rootasjey",
                        style: FontsUtils.mainStyle(
                          color: stateColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      profileSummary(),
                    ],
                  ),
                ),
                socialNetworks(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget profilePicture() {
    return Padding(
      padding: const EdgeInsets.only(
        right: 20.0,
      ),
      child: Hero(
        tag: 'pp',
        child: BetterAvatar(
          size: 70.0,
          elevation: 0.0,
          image: AssetImage(
            'assets/images/jeje.jpg',
          ),
          onTap: () {
            context.router.push(AboutMePageRoute());
          },
        ),
      ),
    );
  }

  Widget profileSummary() {
    return Opacity(
      opacity: 0.6,
      child: Text(
        "short_bio".tr(),
        style: TextStyle(
          fontSize: 14.0,
        ),
      ),
    );
  }

  Widget projectCard({
    String backgroundUrl,
    double width = 150.0,
    double height = 150.0,
    String textTitle,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: Card(
        color: stateColors.newLightBackground,
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                backgroundUrl,
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 12.0,
                  bottom: 8.0,
                ),
                child: Opacity(
                  opacity: 0.6,
                  child: Text(
                    textTitle,
                    style: FontsUtils.mainStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget rightSide() {
    if (_isSmallView) {
      return mobileViewProjects();
    }

    return desktopViewProjects();
  }

  Widget socialNetworks() {
    return Wrap(
      children: [
        IconButton(
          tooltip: "GitHub",
          color: stateColors.foreground.withOpacity(0.6),
          icon: Icon(LineAwesomeIcons.github),
          onPressed: () => launch('https://github.com/rootasjey'),
        ),
        IconButton(
          tooltip: "Twitter",
          color: stateColors.foreground.withOpacity(0.6),
          icon: Icon(LineAwesomeIcons.twitter),
          onPressed: () => launch('https://twitter.com/rootasjey'),
        ),
        IconButton(
          tooltip: "Instagram",
          color: stateColors.foreground.withOpacity(0.6),
          icon: Icon(LineAwesomeIcons.instagram),
          onPressed: () => launch('https://instagram.com/rootasjey'),
        ),
        IconButton(
          tooltip: "Medium",
          color: stateColors.foreground.withOpacity(0.6),
          icon: Icon(LineAwesomeIcons.medium),
          onPressed: () => launch('https://medium.com/@rootasjey'),
        ),
        IconButton(
          tooltip: "Hashnode",
          color: stateColors.foreground.withOpacity(0.6),
          icon: Icon(LineAwesomeIcons.hashtag),
          onPressed: () => launch('https://hashnode.com/@rootasjey'),
        ),
        IconButton(
          tooltip: "CV",
          color: stateColors.foreground.withOpacity(0.6),
          icon: Icon(UniconsLine.file_exclamation),
          onPressed: () => context.router.push(CVPageRoute()),
        ),
      ],
    );
  }

  Widget title() {
    return Text(
      "Flutter Developer",
      style: FontsUtils.mainStyle(
        fontSize: _isSmallView ? 60.0 : 100.0,
        height: 1.2,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget topLine() {
    return Wrap(
      spacing: 12.0,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: 50.0,
          child: Divider(
            thickness: 2.0,
          ),
        ),
        Opacity(
          opacity: 0.6,
          child: Text(
            "Fullstack Web & Mobile",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),
      ],
    );
  }
}
