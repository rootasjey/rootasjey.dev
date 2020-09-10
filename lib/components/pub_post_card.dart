import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:rootasjey/rooter/route_names.dart';
import 'package:rootasjey/rooter/router.dart';
import 'package:rootasjey/types/post_headline.dart';

class PubPostCard extends StatefulWidget {
  @required final PostHeadline postHeadline;

  PubPostCard({
    this.postHeadline,
  });

  @override
  _PubPostCardState createState() => _PubPostCardState();
}

class _PubPostCardState extends State<PubPostCard> {
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
          height: 400.0,
          width: 400.0,
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
                  elevation = isHover
                    ? 4.0
                    : 2.0;
                });
              },
              child: Stack(
                children: [
                  // background(postHeadline),
                  texts(postHeadline),
                ]
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget background(PostHeadline postHeadline) {
    if (postHeadline.urls.image.isEmpty) {
      return Padding(padding: EdgeInsets.zero,);
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
                fontSize: 36.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
              left: 8.0,
            ),
            child: Text(
              '$authorName - ${Jiffy(postHeadline.createdAt).fromNow()}',
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(
              top: 40.0,
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
    FluroRouter.router.navigateTo(
      context,
      PostRoute.replaceFirst(':postId', widget.postHeadline.id),
    );
  }

  void fetchAuthorName() async {
    try {
      final callable = CloudFunctions(
        app: Firebase.app(),
        region: 'europe-west3',
      ).getHttpsCallable(
        functionName: 'posts-fetchAuthorName',
      );

      final resp = await callable
        .call({ 'authorId': widget.postHeadline.author });

      setState(() {
        authorName = resp.data['authorName'];
      });

    } catch (error) {
      debugPrint(error.toString());
    }
  }
}
