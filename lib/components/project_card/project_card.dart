import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/project_card/card_author_pub.dart';
import 'package:rootasjey/components/project_card/card_header.dart';
import 'package:rootasjey/types/globals/globals.dart';
import 'package:rootasjey/types/user_firestore.dart';
import 'package:rootasjey/utils/app_logger.dart';
import 'package:rootasjey/utils/fonts.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

class ProjectCard extends StatefulWidget {
  ProjectCard({
    this.onTap,
    this.popupMenuButton,
    this.width = 300.0,
    this.height = 300.0,
    required this.titleValue,
    this.backgroundUri,
    this.authorId,
    this.createdAt,
    this.summaryValue,
    this.bottomTitle = false,
  });

  final VoidCallback? onTap;
  final Widget? popupMenuButton;
  final String? backgroundUri;
  final String? authorId;
  final double width;
  final double height;
  final DateTime? createdAt;
  final String titleValue;
  final String? summaryValue;
  final bool bottomTitle;

  @override
  _ProjectCardState createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> with AnimationMixin {
  Color? _textColor;
  double _elevation = 2.0;
  String _authorName = '';

  late Animation<double> _scaleAnimation;
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();

    _scaleController = createController()..duration = 250.milliseconds;
    _scaleAnimation =
        0.6.tweenTo(1.0).animatedBy(_scaleController).curve(Curves.elasticOut);

    fetchAuthorName();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Card(
          elevation: _elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              if (widget.backgroundUri?.isNotEmpty ?? false)
                Positioned.fill(
                  child: Image.network(
                    widget.backgroundUri!,
                    fit: BoxFit.cover,
                  ),
                ),
              InkWell(
                onTap: widget.onTap,
                onHover: (isHover) {
                  setState(() {
                    _elevation = isHover ? 6.0 : 2.0;
                    _textColor =
                        isHover ? Globals.constants.colors.secondary : null;
                    isHover
                        ? _scaleController.forward()
                        : _scaleController.reverse();
                  });
                },
                child: Stack(
                  children: [
                    if (!widget.bottomTitle)
                      CardHeader(
                        titleValue: widget.titleValue,
                        summaryValue: widget.summaryValue,
                        textColor: _textColor,
                      ),
                    if (widget.popupMenuButton != null)
                      Positioned(
                        right: 20.0,
                        bottom: 16.0,
                        child: widget.popupMenuButton!,
                      ),
                    CardAuthorAndPub(
                      date: widget.createdAt,
                      authorName: _authorName,
                    ),
                    if (widget.bottomTitle)
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 12.0,
                            bottom: 8.0,
                          ),
                          child: Opacity(
                            opacity: 0.6,
                            child: Text(
                              widget.titleValue,
                              style: FontsUtils.mainStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
    if (widget.authorId?.isEmpty ?? false) {
      return;
    }

    try {
      final docSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.authorId)
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
