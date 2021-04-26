import 'package:flutter/material.dart';
import 'package:rootasjey/components/recent_posts.dart';
import 'package:rootasjey/components/footer.dart';
import 'package:rootasjey/components/home_app_bar.dart';
import 'package:rootasjey/components/home_nav_bar.dart';
import 'package:rootasjey/components/home_presentation.dart';
import 'package:rootasjey/components/newsletter.dart';
import 'package:rootasjey/components/recent_activities.dart';
import 'package:supercharged/supercharged.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: <Widget>[
          HomeAppBar(
            onTapIconHeader: () {
              scrollController.animateTo(
                0,
                duration: 250.milliseconds,
                curve: Curves.decelerate,
              );
            },
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              HomePresentation(),
              HomeNavBar(),
              RecentActivities(),
              RecentPosts(),
              Newsletter(),
              Footer(pageScrollController: scrollController),
            ]),
          ),
        ],
      ),
    );
  }
}
