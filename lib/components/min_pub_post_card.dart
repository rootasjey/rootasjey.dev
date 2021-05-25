import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/types/post.dart';
import 'package:rootasjey/utils/cloud.dart';
import 'package:unicons/unicons.dart';

/// Minimal published post card.
class MinPubPostCard extends StatefulWidget {
  final Post post;
  final double width;
  final EdgeInsets contentPadding;
  final VoidCallback onTap;
  final PopupMenuButton<dynamic> popupMenuButton;

  MinPubPostCard({
    @required this.post,
    this.contentPadding = const EdgeInsets.all(8.0),
    this.width,
    this.onTap,
    this.popupMenuButton,
  });

  @override
  _MinPubPostCardState createState() => _MinPubPostCardState();
}

class _MinPubPostCardState extends State<MinPubPostCard> {
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
      width: widget.width,
      child: Card(
        color: stateColors.lightBackground,
        elevation: _elevation,
        child: InkWell(
          onTap: widget.onTap,
          onHover: (isHover) {
            setState(() {
              _elevation = isHover ? 4.0 : 0.0;
            });
          },
          child: Padding(
            padding: widget.contentPadding,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(child: texts()),
                Padding(
                  padding: const EdgeInsets.only(left: 24.0),
                  child: Icon(
                    UniconsLine.arrow_right,
                    color: stateColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget texts() {
    final postHeadline = widget.post;

    return Column(
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
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 8.0,
            left: 10.0,
          ),
          child: Opacity(
            opacity: 0.6,
            child: Text(
              '$_authorName - ${Jiffy(postHeadline.createdAt).fromNow()}',
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
        if (widget.popupMenuButton != null) widget.popupMenuButton,
      ],
    );
  }

  void fetchAuthorName() async {
    if (widget.post.author.id.isEmpty) {
      return;
    }

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
