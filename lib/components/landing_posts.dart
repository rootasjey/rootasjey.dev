import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/new_pub_post_card.dart';
import 'package:rootasjey/router/app_router.gr.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/types/post_headline.dart';
import 'package:rootasjey/utils/app_logger.dart';
import 'package:rootasjey/utils/fonts.dart';
import 'package:unicons/unicons.dart';

class LandingPosts extends StatefulWidget {
  @override
  _LandingPostsState createState() => _LandingPostsState();
}

class _LandingPostsState extends State<LandingPosts> {
  List<PostHeadline> posts = [];

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: stateColors.newLightBackground,
      padding: const EdgeInsets.only(
        top: 100.0,
        left: 120.0,
        right: 120.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title(),
          postsWrap(),
          viewMoreButton(),
        ],
      ),
    );
  }

  Widget title() {
    return Text(
      "Latest Posts",
      style: FontsUtils.mainStyle(
        fontSize: 100.0,
        height: 1.2,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget postsWrap() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 16.0,
      ),
      child: Wrap(
        spacing: 20.0,
        runSpacing: 20.0,
        children: posts.map((post) {
          return NewPubPostCard(
            postHeadline: post,
          );
        }).toList(),
      ),
    );
  }

  Widget viewMoreButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 42.0),
      child: OutlinedButton(
        onPressed: () {
          context.router.push(PostsRouter());
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
      ),
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
