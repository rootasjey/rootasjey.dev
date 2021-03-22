import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:rootasjey/screens/post_page.dart';
import 'package:rootasjey/types/post_headline.dart';
import 'package:rootasjey/utils/cloud.dart';

class PubPostLineCard extends StatefulWidget {
  @required
  final PostHeadline postHeadline;

  PubPostLineCard({
    this.postHeadline,
  });

  @override
  _PubPostLineCardState createState() => _PubPostLineCardState();
}

class _PubPostLineCardState extends State<PubPostLineCard> {
  double elevation = 2.0;
  String authorName = '';

  @override
  void initState() {
    super.initState();
    fetchAuthorName();
  }

  @override
  Widget build(BuildContext context) {
    final postHeadline = widget.postHeadline;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 700.0,
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
                  elevation = isHover ? 4.0 : 2.0;
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
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
              left: 8.0,
            ),
            child: Opacity(
              opacity: 0.8,
              child: Text(
                postHeadline.title,
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.w500,
                ),
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
              top: 10.0,
            ),
            child: Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: postHeadline.tags.map((tag) {
                return Opacity(
                  opacity: 0.6,
                  child: Chip(
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
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return PostPage(
            postId: widget.postHeadline.id,
          );
        },
      ),
    );
  }

  void fetchAuthorName() async {
    try {
      final resp = await Cloud.fun('posts-fetchAuthorName')
          .call({'authorId': widget.postHeadline.author});

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
