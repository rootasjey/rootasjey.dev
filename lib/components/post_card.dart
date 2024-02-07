import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:loggy/loggy.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/globals/utilities.dart';
import 'package:rootasjey/types/post.dart';
import 'package:rootasjey/types/user/user_firestore.dart';

class PostCard extends StatefulWidget {
  const PostCard({
    super.key,
    required this.post,
    this.onTap,
    this.popupMenuButton,
    this.margin = EdgeInsets.zero,
    this.showAuthorName = false,
    this.maxWidth = 580.0,
    this.compact = false,
  });

  /// Reduce font size if true.
  final bool compact;

  /// Show author's name of the post if true.
  final bool showAuthorName;

  /// Width of this card.
  final double maxWidth;

  /// Data to populate this card.
  final Post post;

  /// Callback fired when this card is tapped.
  final void Function()? onTap;

  /// Actions to show on this card.
  final PopupMenuButton? popupMenuButton;

  /// Space around this card.
  final EdgeInsets margin;
  @override
  State<StatefulWidget> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> with UiLoggy {
  double _elevation = 0.0;
  final double _endElevation = 6.0;
  final double _startElevation = 0.0;
  String _authorName = "";

  @override
  void initState() {
    super.initState();

    setState(() {
      _elevation = _startElevation;
    });

    if (widget.showAuthorName) {
      fetchAuthorName();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.margin,
      child: Card(
        elevation: _elevation,
        clipBehavior: Clip.hardEdge,
        color: Theme.of(context).colorScheme.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
        child: InkWell(
          onTap: widget.onTap,
          onHover: (bool isHover) {
            setState(() {
              _elevation = isHover ? _endElevation : _startElevation;
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              coverWidget(),
              textWidgets(),
            ],
          ),
        ),
      ),
    );
  }

  Widget coverWidget() {
    final Post post = widget.post;
    final String imageUrl = post.cover.thumbnails.s;

    if (imageUrl.isEmpty) {
      return Container();
    }

    return Card(
      elevation: _elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            width: 130.0,
            height: 130.0,
          ),
          if (widget.popupMenuButton != null)
            Positioned(
              bottom: 12.0,
              right: 12.0,
              child: widget.popupMenuButton!,
            ),
        ],
      ),
    );
  }

  Widget textWidgets() {
    final Post post = widget.post;
    final String postName = post.name.isNotEmpty ? post.name : "no_title".tr();

    final DateTime now = DateTime.now();
    final bool showFullDate = now.difference(post.createdAt).inDays > 4;
    String postMetadata = showFullDate
        ? Jiffy.parseFromDateTime(post.createdAt).yMMMEd
        : Jiffy.parseFromDateTime(post.createdAt).fromNow();

    if (widget.showAuthorName) {
      postMetadata = "$_authorName - $postMetadata";
    }

    return Card(
      elevation: 0.0,
      color: Colors.transparent,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: widget.maxWidth),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                postName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Utilities.fonts.body(
                  textStyle: TextStyle(
                    fontSize: widget.compact ? 18.0 : 32.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (post.summary.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Opacity(
                    opacity: 0.4,
                    child: Text(
                      post.summary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Utilities.fonts.body(
                        textStyle: TextStyle(
                          fontSize: widget.compact ? 14.0 : 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6.0,
                  children: [
                    Opacity(
                      opacity: 0.6,
                      child: Text(
                        postMetadata,
                        style: Utilities.fonts.body(
                          textStyle: TextStyle(
                            fontSize: widget.compact ? 12.0 : 15.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    if (post.tags.isNotEmpty)
                      Text(
                        "•  ${post.tags.first}",
                        style: Utilities.fonts.body(
                          textStyle: TextStyle(
                            fontSize: widget.compact ? 12.0 : 15.0,
                            fontWeight: FontWeight.w600,
                            color: Constants.colors.getFromTag(post.tags.first),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void fetchAuthorName() async {
    final String userId = widget.post.userId;

    if (userId.isEmpty) {
      return;
    }

    try {
      final docSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (!docSnap.exists) {
        return;
      }

      final data = docSnap.data()!;
      data['id'] = docSnap.id;

      final user = UserFirestore.fromMap(data);

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
      loggy.error(error);
    }
  }
}
