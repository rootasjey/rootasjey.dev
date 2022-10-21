import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:loggy/loggy.dart';
import 'package:rootasjey/types/post.dart';
import 'package:rootasjey/types/user/user_firestore.dart';

class PostCard extends StatefulWidget {
  const PostCard({
    super.key,
    required this.post,
    this.onTap,
    this.popupMenuButton,
    this.padding = EdgeInsets.zero,
  });

  final Post post;
  final VoidCallback? onTap;
  final PopupMenuButton? popupMenuButton;
  final EdgeInsets padding;
  @override
  State<StatefulWidget> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> with UiLoggy {
  double? _elevation;
  String? _authorName = "";

  @override
  void initState() {
    super.initState();

    setState(() {
      _elevation = 0.0;
    });

    if (widget.post.author.id.isNotEmpty) {
      fetchAuthorName();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      width: 300.0,
      child: InkWell(
        onTap: widget.onTap,
        onHover: (isHover) {
          setState(() {
            _elevation = isHover ? 4.0 : 0.0;
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            background(),
            texts(),
          ],
        ),
      ),
    );
  }

  Widget background() {
    final post = widget.post;

    if (post.image!.thumbnail!.isEmpty) {
      return const Padding(
        padding: EdgeInsets.zero,
      );
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
            post.image!.thumbnail!,
            fit: BoxFit.cover,
            width: 300.0,
            height: 300.0,
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

  Widget texts() {
    final post = widget.post;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 16.0,
            left: 10.0,
          ),
          child: Opacity(
            opacity: 0.6,
            child: Text(
              '$_authorName - ${Jiffy(post.createdAt).fromNow()}',
              style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 10.0,
            left: 8.0,
          ),
          child: Text(
            post.title.isEmpty ? "no_title".tr() : post.title,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            style: const TextStyle(
              height: 1.0,
              fontSize: 26.0,
              fontWeight: FontWeight.w600,
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
            children: post.tags.map((tag) {
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
