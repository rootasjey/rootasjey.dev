import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/wide_post_card.dart';
import 'package:rootasjey/types/post_headline.dart';

class FeaturedPosts extends StatefulWidget {
  @override
  _FeaturedPostsState createState() => _FeaturedPostsState();
}

class _FeaturedPostsState extends State<FeaturedPosts> {
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
              Padding(
                padding: const EdgeInsets.only(
                  right: 8.0,
                ),
                child: Opacity(
                  opacity: 0.6,
                  child: Icon(Icons.star_border),
                ),
              ),

              FlatButton(
                onPressed: () {},
                child: Opacity(
                  opacity: 0.6,
                  child: Text(
                    'FEATURED',
                    // 'Recent activity',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
            ],
          ),

          Column(
            children: posts.map((post) {
              return WidePostCard(
                id: post.id,
                imageUrl: post.urls.image,
                title: post.title,
                summary: post.summary,
                metadata: '${post.createdAt.toString().split(' ')[0]} - ${post.timeToRead}',
                tags: post.tags,
              );
            }).toList()
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
        .where('featured', isEqualTo: true)
        .limit(1)
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
