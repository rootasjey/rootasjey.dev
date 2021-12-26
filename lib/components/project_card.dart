import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/types/project.dart';
import 'package:rootasjey/types/user_firestore.dart';
import 'package:rootasjey/utils/app_logger.dart';
import 'package:rootasjey/utils/fonts.dart';

class ProjectCard extends StatefulWidget {
  final VoidCallback? onTap;
  final Widget? popupMenuButton;
  final Project project;
  final double width;
  final double height;

  ProjectCard({
    this.onTap,
    this.popupMenuButton,
    required this.project,
    this.width = 300.0,
    this.height = 300.0,
  });

  @override
  _ProjectCardState createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  Color textColor = Colors.black;
  double elevation = 2.0;

  String? _authorName = '';

  @override
  void initState() {
    super.initState();
    fetchAuthorName();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Card(
        elevation: elevation,
        color: stateColors.lightBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: InkWell(
          onTap: widget.onTap,
          onHover: (isHover) {
            setState(() {
              elevation = isHover ? 3.0 : 2.0;
              textColor = isHover ? stateColors.secondary : Colors.black;
            });
          },
          child: Stack(
            children: [
              texts(),
              if (widget.popupMenuButton != null)
                Positioned(
                  right: 20.0,
                  bottom: 16.0,
                  child: widget.popupMenuButton!,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget texts() {
    final project = widget.project;

    return Padding(
      padding: const EdgeInsets.only(
        top: 40.0,
        left: 40.0,
        right: 40.0,
        bottom: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title(),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Opacity(
              opacity: 0.6,
              child: Text(
                project.summary!,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: FontsUtils.mainStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Opacity(
              opacity: 0.6,
              child: Text(
                _authorName!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: FontsUtils.mainStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Opacity(
            opacity: 0.6,
            child: Text(
              Jiffy(project.createdAt).fromNow(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget title() {
    final project = widget.project;

    final textChild = Opacity(
      opacity: 1.0,
      child: Text(
        project.title!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: FontsUtils.mainStyle(
          color: textColor,
          fontSize: 24.0,
          fontWeight: FontWeight.w700,
        ),
      ),
    );

    if (project.title!.length > 14) {
      return Tooltip(
        message: project.title,
        child: textChild,
      );
    }

    return textChild;
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
