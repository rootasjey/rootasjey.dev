import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/arrow_divider.dart';
import 'package:rootasjey/components/post_card.dart';
import 'package:rootasjey/components/min_post_card.dart';
import 'package:rootasjey/router/locations/posts_location.dart';
import 'package:rootasjey/types/post.dart';
import 'package:rootasjey/utils/app_logger.dart';
import 'package:rootasjey/utils/constants.dart';
import 'package:rootasjey/utils/fonts.dart';
import 'package:unicons/unicons.dart';

class LandingPosts extends StatefulWidget {
  @override
  _LandingPostsState createState() => _LandingPostsState();
}

class _LandingPostsState extends State<LandingPosts> {
  bool _isSmallView = false;
  List<Post> _posts = [];

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    _isSmallView = false;

    final viewWidth = MediaQuery.of(context).size.width;

    EdgeInsets padding = const EdgeInsets.only(
      top: 100.0,
      left: 120.0,
      right: 120.0,
    );

    if (viewWidth < Constants.maxMobileWidth) {
      _isSmallView = true;

      padding = const EdgeInsets.only(
        top: 80.0,
        left: 20.0,
        right: 20.0,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ArrowDivider(),
        Padding(
          padding: padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title(),
              postsWrap(),
              viewMoreButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget postsDesktopView() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 16.0,
      ),
      child: Wrap(
        spacing: 20.0,
        runSpacing: 20.0,
        children: _posts.map((post) {
          return PostCard(
            post: post,
            onTap: () => onGoToPost(post.id),
          );
        }).toList(),
      ),
    );
  }

  Widget postsMobileView() {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Column(
        children: _posts.map((post) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              MinPostCard(
                post: post,
                onTap: () => onGoToPost(post.id),
              ),
              Divider(height: 40.0),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget postsWrap() {
    if (_isSmallView) {
      return postsMobileView();
    }

    return postsDesktopView();
  }

  Widget title() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Text(
        "Latest Posts",
        style: FontsUtils.mainStyle(
          fontSize: _isSmallView ? 60.0 : 100.0,
          height: 1.2,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget viewMoreButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 42.0),
      child: OutlinedButton(
        onPressed: () {
          Beamer.of(context).beamToNamed(PostsLocation.route);
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

        _posts.add(Post.fromJSON(data));
      });

      if (!mounted) {
        return;
      }

      setState(() {});
    } catch (error) {
      appLogger.e(error);
    }
  }

  void onGoToPost(String postId) {
    Beamer.of(context).beamToNamed(
      '${PostsLocation.route}/${postId}',
      data: {'postId': postId},
    );
  }
}
