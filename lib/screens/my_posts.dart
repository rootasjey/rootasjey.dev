import 'package:flutter/material.dart';
import 'package:rootasjey/components/home_app_bar.dart';
import 'package:rootasjey/rooter/router.dart';
import 'package:rootasjey/screens/draft_posts.dart';
import 'package:rootasjey/screens/published_posts.dart';
import 'package:rootasjey/state/colors.dart';

class MyPosts extends StatefulWidget {
  @override
  _MyPostsState createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  int bodyIndex = 0;

  final bodyChildren = [
    DraftPosts(),
    PublishedPosts(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          HomeAppBar(
            title: Opacity(
              opacity: 0.6,
              child: Text(
                'Posts',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: stateColors.foreground,
                ),
              ),
            ),
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
              onPressed: () => FluroRouter.router.pop(context),
              icon: Icon(Icons.arrow_back),
            ),
          ),

          headerSection(
            textTitle: 'Drafts',
            index: 0,
          ),

          headerSection(
            textTitle: 'Published',
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
          opacity: isSelected
            ? 1.0
            : 0.5,
          child: Text(
            textTitle,
            style: TextStyle(
              fontSize: 70.0,
              fontWeight: isSelected
                ? FontWeight.bold
                : FontWeight.w300,
            ),
          ),
        ),
      ),
    );
  }
}
