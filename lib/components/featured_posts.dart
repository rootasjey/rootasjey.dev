import 'package:flutter/material.dart';
import 'package:rootasjey/components/wide_post_card.dart';

class FeaturedPosts extends StatefulWidget {
  @override
  _FeaturedPostsState createState() => _FeaturedPostsState();
}

class _FeaturedPostsState extends State<FeaturedPosts> {
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

          WidePostCard(
            imageUrl: 'https://picsum.photos/700/300',
            title: 'How to build a blog with Flutter & Firebase?',
            summary: 'I had trouble building my website because I switched of platform regurlary...',
            metadata: 'August 21, 2020 - 6 min read',
            tags: ['dev', 'flutter', 'firebase'],
          ),
        ],
      ),
    );
  }
}
