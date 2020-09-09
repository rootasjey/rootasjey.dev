import 'package:flutter/material.dart';
import 'package:rootasjey/rooter/route_names.dart';
import 'package:rootasjey/rooter/router.dart';
import 'package:rootasjey/types/post.dart';

class PostCard extends StatefulWidget {
  final String date;
  final EdgeInsets padding;
  final Post post;
  final String summary;
  final String timeToRead;
  final String title;
  final Widget popupMenuButton;

  PostCard({
    this.date,
    this.padding = EdgeInsets.zero,
    this.post,
    this.summary,
    this.timeToRead,
    this.title,
    this.popupMenuButton,
  });

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Card(
        elevation: 2.0,
        child: InkWell(
          onTap: () =>
            FluroRouter.router.navigateTo(
              context,
              PostRoute.replaceFirst(':postId', widget.post.id),
            ),
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
                        child: widget.title.isEmpty
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
                            widget.title,
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ),

                      if (widget.summary.isNotEmpty)
                        Opacity(
                          opacity: 0.6,
                          child: Text(
                            widget.summary,
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ),

                      metaData(),
                    ],
                  ),
                ),

                if (widget.popupMenuButton != null)
                  widget.popupMenuButton,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget metaData() {
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
              widget.date,
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
              widget.timeToRead,
            ),
          ),
        ],
      ),
    );
  }
}
