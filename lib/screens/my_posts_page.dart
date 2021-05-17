import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rootasjey/components/simple_app_bar.dart';
import 'package:rootasjey/router/app_router.gr.dart';

class MyPostsPage extends StatefulWidget {
  @override
  _MyPostsPageState createState() => _MyPostsPageState();
}

class _MyPostsPageState extends State<MyPostsPage> {
  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: [
        DraftPostsPageRoute(),
        PublishedPostsPageRoute(),
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
