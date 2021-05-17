import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:rootasjey/components/better_avatar.dart';
import 'package:rootasjey/router/app_router.gr.dart';
import 'package:rootasjey/utils/fonts.dart';
import 'package:unicons/unicons.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePresentation extends StatefulWidget {
  @override
  _HomePresentationState createState() => _HomePresentationState();
}

class _HomePresentationState extends State<HomePresentation> {
  final width = 600.0;
  bool isNarrow = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, boxConstraints) {
      isNarrow = boxConstraints.maxWidth < 600.0;

      return Padding(
        padding: EdgeInsets.all(isNarrow ? 50.0 : 100.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            body(),
          ],
        ),
      );
    });
  }

  Widget body() {
    if (isNarrow) {
      return narrowView();
    }

    return largeView();
  }

  Widget largeView() {
    return Container(
      width: width,
      padding: const EdgeInsets.only(
        top: 100.0,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: 60.0,
            ),
            child: titleIntro(),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 40.0,
                ),
                child: profilePicture(),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 14.0),
                      child: profileSummary(),
                    ),
                    socialNetworks(),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget narrowView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 60.0,
            bottom: 60.0,
          ),
          child: profilePicture(),
        ),
        titleIntro(),
        Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 20),
          child: profileSummary(),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 28.0,
          ),
          child: socialNetworks(),
        ),
      ],
    );
  }

  Widget profilePicture() {
    return Hero(
      tag: 'pp',
      child: BetterAvatar(
        size: 120.0,
        image: AssetImage(
          'assets/images/jeje.jpg',
        ),
        onTap: () {
          context.router.push(AboutMePageRoute());
        },
      ),
    );
  }

  Widget profileSummary() {
    return Opacity(
      opacity: 0.7,
      child: Text(
        "short_bio".tr(),
        style: TextStyle(
          fontSize: 17.0,
        ),
      ),
    );
  }

  Widget socialNetworks() {
    return Wrap(
      children: [
        IconButton(
          tooltip: "GitHub",
          icon: Icon(LineAwesomeIcons.github),
          onPressed: () => launch('https://github.com/rootasjey'),
        ),
        IconButton(
          tooltip: "Twitter",
          icon: Icon(LineAwesomeIcons.twitter),
          onPressed: () => launch('https://twitter.com/rootasjey'),
        ),
        IconButton(
          tooltip: "Instagram",
          icon: Icon(LineAwesomeIcons.instagram),
          onPressed: () => launch('https://instagram.com/rootasjey'),
        ),
        IconButton(
          tooltip: "Medium",
          icon: Icon(LineAwesomeIcons.medium),
          onPressed: () => launch('https://medium.com/@rootasjey'),
        ),
        IconButton(
          tooltip: "Hashnode",
          icon: Icon(LineAwesomeIcons.hashtag),
          onPressed: () => launch('https://hashnode.com/@rootasjey'),
        ),
        IconButton(
          tooltip: "CV",
          icon: Icon(UniconsLine.file_exclamation),
          onPressed: () => context.router.push(CVPageRoute()),
        ),
      ],
    );
  }

  Widget titleIntro() {
    return SizedBox(
      width: width,
      child: Opacity(
        opacity: isNarrow ? 0.8 : 1.0,
        child: Text(
          "welcome_text".tr(),
          style: FontsUtils.mainStyle(
            fontSize: isNarrow ? 40.0 : 50.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
