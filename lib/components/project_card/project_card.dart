import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/project_card/card_author_pub.dart';
import 'package:rootasjey/components/project_card/card_header.dart';
import 'package:rootasjey/types/globals/globals.dart';
import 'package:rootasjey/types/project.dart';
import 'package:rootasjey/types/user_firestore.dart';
import 'package:rootasjey/utils/app_logger.dart';

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
  Color? _textColor;
  double _elevation = 2.0;
  String _authorName = '';

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
        elevation: _elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: InkWell(
          onTap: widget.onTap,
          onHover: (isHover) {
            setState(() {
              _elevation = isHover ? 6.0 : 2.0;
              _textColor = isHover ? Globals.constants.colors.secondary : null;
            });
          },
          child: Stack(
            children: [
              CardHeader(
                project: widget.project,
                textColor: _textColor,
              ),
              if (widget.popupMenuButton != null)
                Positioned(
                  right: 20.0,
                  bottom: 16.0,
                  child: widget.popupMenuButton!,
                ),
              CardAuthorAndPub(
                date: widget.project.createdAt,
                authorName: _authorName,
              ),
            ],
          ),
        ),
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
