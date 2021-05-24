import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/main_app_bar.dart';
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
        return MainAppBar(
          renderSliver: false,
        );
      },
      builder: (context, child, animation) {
        return child;
      },
    );
  }
}
