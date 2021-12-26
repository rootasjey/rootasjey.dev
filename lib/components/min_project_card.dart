import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/types/project.dart';
import 'package:rootasjey/types/user_firestore.dart';
import 'package:rootasjey/utils/app_logger.dart';
import 'package:rootasjey/utils/fonts.dart';

/// Minimal post card.
class MinProjectCard extends StatefulWidget {
  final Project project;
  final double? width;
  final EdgeInsets contentPadding;
  final VoidCallback? onTap;
  final PopupMenuButton<dynamic>? popupMenuButton;

  MinProjectCard({
    required this.project,
    this.contentPadding = const EdgeInsets.all(8.0),
    this.width,
    this.onTap,
    this.popupMenuButton,
  });

  @override
  _MinProjectCardState createState() => _MinProjectCardState();
}

class _MinProjectCardState extends State<MinProjectCard> {
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
            child: Stack(
              children: [
                texts(),
                if (widget.popupMenuButton != null)
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    child: widget.popupMenuButton!,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget texts() {
    final postHeadline = widget.project;

    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        top: 12.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Opacity(
            opacity: 0.8,
            child: Text(
              postHeadline.title!,
              style: FontsUtils.mainStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Opacity(
              opacity: 0.6,
              child: Text(
                _authorName!,
                style: FontsUtils.mainStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Opacity(
            opacity: 0.6,
            child: Text(Jiffy(postHeadline.createdAt).fromNow()),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: postHeadline.tags!.take(2).map((tag) {
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

  void fetchAuthorName() async {
    final authorId = widget.project.author.id;

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

      setState(() {
        _authorName = user.name;
      });
    } catch (error) {
      appLogger.e(error);
    }
  }
}
