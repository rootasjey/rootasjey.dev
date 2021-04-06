import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:rootasjey/components/pub_post_card.dart';
import 'package:rootasjey/components/pub_post_line_card.dart';
import 'package:rootasjey/router/app_router.gr.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/types/post_headline.dart';
import 'package:rootasjey/utils/app_logger.dart';
import 'package:rootasjey/utils/fonts.dart';
import 'package:unicons/unicons.dart';

class RecentPosts extends StatefulWidget {
  @override
  _RecentPostsState createState() => _RecentPostsState();
}

class _RecentPostsState extends State<RecentPosts> {
  List<PostHeadline> posts = [];
  double maxWidth;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      if (MediaQuery.of(context).size.width < 700.0) {
        return narrowView();
      }

      return largeView();
    });
  }

  Widget largeView() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 100.0,
        vertical: 40.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleSection(),
          Padding(
            padding: const EdgeInsets.only(
              top: 16.0,
            ),
            child: Wrap(
                spacing: 20.0,
                runSpacing: 20.0,
                children: posts.map((post) {
                  return PubPostCard(
                    postHeadline: post,
                    size: 350.0,
                  );
                }).toList()),
          ),
        ],
      ),
    );
  }

  Widget narrowView() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 40.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleSection(),
          Padding(
            padding: const EdgeInsets.only(
              top: 16.0,
            ),
            child: Wrap(
                spacing: 20.0,
                runSpacing: 20.0,
                children: posts.map((post) {
                  return PubPostLineCard(
                    postHeadline: post,
                  );
                }).toList()),
          ),
        ],
      ),
    );
  }

  Widget titleSection() {
    return Row(
      children: [
        TextButton.icon(
          onPressed: () {
            context.router.push(PostsDeepRoute(children: [PostsRoute()]));
          },
          icon: Icon(
            UniconsLine.newspaper,
            color: stateColors.foreground,
          ),
          label: Opacity(
            opacity: 0.6,
            child: Text(
              "posts_recent".tr().toUpperCase(),
              style: FontsUtils.mainStyle(
                fontSize: 20.0,
                color: stateColors.foreground,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void fetch() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('published', isEqualTo: true)
          .limit(6)
          .get();

      if (snapshot.size == 0) {
        return;
      }

      snapshot.docs.forEach((doc) {
        final data = doc.data();
        data['id'] = doc.id;

        posts.add(PostHeadline.fromJSON(data));
      });

      setState(() {});
    } catch (error) {
      appLogger.e(error);
    }
  }
}
