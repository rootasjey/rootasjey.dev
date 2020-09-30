import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/pub_post_card.dart';
import 'package:rootasjey/router//route_names.dart';
import 'package:rootasjey/router//router.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/types/post_headline.dart';

class RecentPosts extends StatefulWidget {
  @override
  _RecentPostsState createState() => _RecentPostsState();
}

class _RecentPostsState extends State<RecentPosts> {
  List<PostHeadline> posts = [];

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 100.0,
        vertical: 40.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TextButton.icon(
                onPressed: () =>
                  FluroRouter.router.navigateTo(context, PostsRoute),
                icon: Icon(
                  Icons.list,
                  color: stateColors.foreground,
                ),
                label: Opacity(
                  opacity: 0.6,
                  child: Text(
                    'RECENT POSTS',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: stateColors.foreground,
                    ),
                  ),
                ),
              ),
            ],
          ),

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
                );
              }).toList()
            ),
          ),
        ],
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
      debugPrint(error.toStrring());
    }
  }
}
