import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:rootasjey/router/app_router.gr.dart';
import 'package:rootasjey/types/post_headline.dart';
import 'package:rootasjey/utils/cloud.dart';

class PubPostCard extends StatefulWidget {
  @required
  final PostHeadline postHeadline;
  final double size;

  PubPostCard({
    this.postHeadline,
    this.size = 400.0,
  });

  @override
  _PubPostCardState createState() => _PubPostCardState();
}

class _PubPostCardState extends State<PubPostCard> {
  double elevation;
  double size;

  String authorName = '';

  @override
  void initState() {
    super.initState();

    setState(() {
      size = widget.size;
      elevation = 8.0;
    });

    fetchAuthorName();
  }

  @override
  Widget build(BuildContext context) {
    final postHeadline = widget.postHeadline;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: size,
          width: size,
          child: Card(
            elevation: elevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            // color: Colors.deepPurple.shade400,
            child: InkWell(
              onTap: navigateToPost,
              onHover: (isHover) {
                setState(() {
                  elevation = isHover ? 4.0 : 8.0;
                });
              },
              child: Stack(children: [
                // background(postHeadline),
                texts(postHeadline),
              ]),
            ),
          ),
        ),
      ],
    );
  }

  Widget background(PostHeadline postHeadline) {
    if (postHeadline.urls.image.isEmpty) {
      return Padding(
        padding: EdgeInsets.zero,
      );
    }

    return Image.network(
      postHeadline.urls.image,
      fit: BoxFit.cover,
      color: Color.fromRGBO(0, 0, 0, 0.5),
      colorBlendMode: BlendMode.darken,
      width: 400.0,
      height: 400.0,
    );
  }

  Widget texts(PostHeadline postHeadline) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
              left: 8.0,
            ),
            child: Text(
              postHeadline.title,
              style: TextStyle(
                // color: Colors.white,
                fontSize: 32.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
              left: 8.0,
            ),
            child: Opacity(
              opacity: 0.6,
              child: Text(
                '$authorName - ${Jiffy(postHeadline.createdAt).fromNow()}',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w300,
                ),
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
              children: postHeadline.tags.map((tag) {
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
            postId: widget.postHeadline.id,
          ),
        ],
      ),
    );
  }

  void fetchAuthorName() async {
    try {
      final resp = await Cloud.fun('posts-fetchAuthorName')
          .call({'authorId': widget.postHeadline.author.id});

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
        authorName = resp.data['authorName'];
      });
    } catch (error) {
      debugPrint(error.toString());
    }
  }
}
