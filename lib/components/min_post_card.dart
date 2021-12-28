import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:rootasjey/types/globals/globals.dart';
import 'package:rootasjey/types/post.dart';
import 'package:rootasjey/types/user_firestore.dart';
import 'package:rootasjey/utils/app_logger.dart';
import 'package:unicons/unicons.dart';

/// Minimal post card.
class MinPostCard extends StatefulWidget {
  final Post post;
  final double? width;
  final EdgeInsets contentPadding;
  final VoidCallback? onTap;
  final PopupMenuButton<dynamic>? popupMenuButton;

  MinPostCard({
    required this.post,
    this.contentPadding = const EdgeInsets.all(8.0),
    this.width,
    this.onTap,
    this.popupMenuButton,
  });

  @override
  _MinPostCardState createState() => _MinPostCardState();
}

class _MinPostCardState extends State<MinPostCard> {
  double? _elevation;

  String? _authorName = '';

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
                    color: Globals.constants.colors.primary,
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
        if (widget.popupMenuButton != null) widget.popupMenuButton!,
      ],
    );
  }

  void fetchAuthorName() async {
    final authorId = widget.post.author.id;

    if (authorId.isEmpty) {
      return;
    }

    try {
      final docSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(authorId)
          .get();

      if (!docSnap.exists) {
        return;
      }

      final data = docSnap.data()!;
      data['id'] = docSnap.id;

      final user = UserFirestore.fromJSON(data);

      // ?NOTE: Prevent setState if not mounted.
      // This is due to each card having its own fetch & state,
      // and Flutter having not displayed widget to dispose().
      // So, lifecycle states are called in this order:
      // iniState --> dispose --> (fetch) setState
      // which is wrong cause the widget is no longer in the tree.
      if (!mounted) {
        return;
      }

      setState(() => _authorName = user.name);
    } catch (error) {
      appLogger.e(error);
    }
  }
}
