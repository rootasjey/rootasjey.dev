import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/simple_app_bar.dart';
import 'package:rootasjey/router/app_router.gr.dart';

class MyProjectsPage extends StatefulWidget {
  @override
  _MyProjectsPageState createState() => _MyProjectsPageState();
}

class _MyProjectsPageState extends State<MyProjectsPage> {
  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: [
        DraftProjectsPageRoute(),
        PublishedProjectsPageRoute(),
      ],
      appBarBuilder: (context, tabsRouter) {
        return SimpleAppBar(
          textTitle: "posts".tr(),
        );
      },
      builder: (context, child, animation) {
        return child;
      },
    );
  }
}
