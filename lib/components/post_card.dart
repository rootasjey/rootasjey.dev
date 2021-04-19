import 'package:flutter/material.dart';
import 'package:rootasjey/types/post.dart';

class PostCard extends StatefulWidget {
  final EdgeInsets padding;
  final Post post;
  final Widget popupMenuButton;
  final VoidCallback onTap;

  PostCard({
    this.padding = EdgeInsets.zero,
    @required this.post,
    this.popupMenuButton,
    this.onTap,
  });

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Padding(
      padding: widget.padding,
      child: Card(
        elevation: 2.0,
        child: InkWell(
          onTap: widget.onTap,
          child: Container(
            width: 700.0,
            padding: const EdgeInsets.all(40.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 20.0,
                        ),
                        child: post.title.isEmpty
                            ? Opacity(
                                opacity: 0.6,
                                child: Text(
                                  'No title yet.',
                                  style: TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              )
                            : Text(
                                post.title,
                                style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                      if (post.summary.isNotEmpty)
                        Opacity(
                          opacity: 0.6,
                          child: Text(
                            post.summary,
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      metaData(post),
                    ],
                  ),
                ),
                if (widget.popupMenuButton != null) widget.popupMenuButton,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget metaData(Post post) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8.0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Opacity(
            opacity: 0.6,
            child: Text(
              post.updatedAt.toString().split(' ')[0],
            ),
          ),
          Container(
            width: 20.0,
            height: 20.0,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          Opacity(
            opacity: 0.6,
            child: Text(
              post.timeToRead,
            ),
          ),
        ],
      ),
    );
  }
}
