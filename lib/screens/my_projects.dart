import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/home_app_bar.dart';
import 'package:rootasjey/screens/draft_projects.dart';
import 'package:rootasjey/screens/published_projects.dart';
import 'package:rootasjey/state/scroll.dart';
import 'package:rootasjey/utils/fonts.dart';
import 'package:unicons/unicons.dart';

class MyProjects extends StatefulWidget {
  @override
  _MyProjectsState createState() => _MyProjectsState();
}

class _MyProjectsState extends State<MyProjects> {
  int bodyIndex = 0;

  final bodyChildren = [
    DraftProjects(),
    PublishedProjects(),
  ];

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollNotification) {
          if (scrollNotification.metrics.pixels <
              scrollNotification.metrics.maxScrollExtent) {
            stateDraftProjectsScroll.setHasReachEnd(false);
            return false;
          }

          stateDraftProjectsScroll.setHasReachEnd(true);
          return false;
        },
        child: CustomScrollView(
          slivers: [
            HomeAppBar(
              textTitle: "projects".tr(),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                header(),
              ]),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(
                left: 90.0,
                right: 90.0,
                bottom: 300.0,
              ),
              sliver: bodyChildren[bodyIndex],
            ),
          ],
        ),
      ),
    );
  }

  Widget header() {
    return Padding(
      padding: const EdgeInsets.all(
        90.0,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 0.0),
            child: IconButton(
              onPressed: context.router.pop,
              icon: Icon(UniconsLine.arrow_left),
            ),
          ),
          headerSection(
            textTitle: "drafts".tr(),
            index: 0,
          ),
          headerSection(
            textTitle: "published".tr(),
            index: 1,
          ),
        ],
      ),
    );
  }

  Widget headerSection({
    @required String textTitle,
    @required int index,
  }) {
    final isSelected = index == bodyIndex;

    return InkWell(
      onTap: () => setState(() => bodyIndex = index),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: Opacity(
          opacity: isSelected ? 1.0 : 0.5,
          child: Text(
            textTitle,
            style: FontsUtils.mainStyle(
              fontSize: 40.0,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w300,
            ),
          ),
        ),
      ),
    );
  }
}
