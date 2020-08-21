import 'package:flutter/material.dart';
import 'package:rootasjey/components/post_card.dart';

class RecentPosts extends StatefulWidget {
  @override
  _RecentPostsState createState() => _RecentPostsState();
}

class _RecentPostsState extends State<RecentPosts> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 100.0,
        vertical: 80.0,
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
                  child: Icon(Icons.list),
                ),
              ),

              Opacity(
                opacity: 0.6,
                child: Text(
                  'RECENT',
                  // 'Recent activity',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
            ],
          ),

          Padding(padding: const EdgeInsets.only(bottom: 20.0),),

          PostCard(
            title: 'Why I love the movie Gatsby so much',
            summary: 'After re-watching the movie multiple times, I decided to write down what worked on me...',
            date: '1 week ago',
            timeToRead: '10 min read',
          ),
        ],
      ),
    );
  }
}
