import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:rootasjey/router/app_router.gr.dart';
import 'package:rootasjey/types/post.dart';
import 'package:rootasjey/utils/cloud.dart';
import 'package:rootasjey/utils/fonts.dart';

class BetterPostCard extends StatefulWidget {
  final Post post;

  BetterPostCard({
    @required this.post,
  });

  @override
  _BetterPostCardState createState() => _BetterPostCardState();
}

class _BetterPostCardState extends State<BetterPostCard> {
  double _elevation;

  String _authorName = '';

  @override
  void initState() {
    super.initState();

    setState(() {
      _elevation = 0.0;
    });

    fetchAuthorName();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300.0,
      child: InkWell(
        onTap: navigateToPost,
        onHover: (isHover) {
          setState(() {
            _elevation = isHover ? 4.0 : 0.0;
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            background(),
            texts(),
          ],
        ),
      ),
    );
  }

  Widget background() {
    final post = widget.post;

    if (post.image.thumbnail.isEmpty) {
      return Padding(
        padding: EdgeInsets.zero,
      );
    }

    return Card(
      elevation: _elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.network(
        post.image.thumbnail,
        fit: BoxFit.cover,
        width: 300.0,
        height: 300.0,
      ),
    );
  }

  Widget texts() {
    final post = widget.post;

    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 16.0,
              left: 10.0,
            ),
            child: Opacity(
              opacity: 0.6,
              child: Text(
                '$_authorName - ${Jiffy(post.createdAt).fromNow()}',
                style: FontsUtils.mainStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
              left: 8.0,
            ),
            child: Text(
              post.title,
              style: FontsUtils.mainStyle(
                fontSize: 26.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
            ),
            child: Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: post.tags.map((tag) {
                return Opacity(
                  opacity: 0.6,
                  child: Chip(
                    elevation: 2.0,
                    label: Text(
                      tag,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void navigateToPost() {
    context.router.push(
      PostsRouter(
        children: [
          PostPageRoute(
            postId: widget.post.id,
          ),
        ],
      ),
    );
  }

  void fetchAuthorName() async {
    try {
      final resp = await Cloud.fun('posts-fetchAuthorName')
          .call({'authorId': widget.post.author.id});

      // ?NOTE: Prevent setState if not mounted.
      // This is due to each card having its own fetch & state,
      // and Flutter having not displayed widget to dispose().
      // So, lifecycle states are called in this order:
      // iniState --> dispose --> (fetch) setState
      // which is wrong cause the widget is no longer in the tree.
      if (!mounted) {
        return;
      }

      setState(() {
        _authorName = resp.data['authorName'];
      });
    } catch (error) {
      debugPrint(error.toString());
    }
  }
}
