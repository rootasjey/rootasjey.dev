import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:measured/measured.dart';
import 'package:rootasjey/globals/utils.dart';
import 'package:rootasjey/types/project/project.dart';

class ProjectCard extends StatefulWidget {
  const ProjectCard({
    super.key,
    required this.index,
    required this.project,
    required this.useBottomSheet,
    this.onTap,
    this.compact = false,
    this.descriptionMaxLines,
  });

  /// Display a compact version of the card.
  final bool compact;

  /// If true, a bottom sheet will be displayed on long press event.
  /// Setting this property to true will deactivate popup menu and
  /// hide like button.
  final bool useBottomSheet;

  final int? descriptionMaxLines;

  /// Index position in a list, if available.
  final int index;

  /// Callback fired on tap.
  final void Function(Project project)? onTap;

  /// Project's data for this card.
  final Project project;

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  int _maxLines = 1;

  double _elevation = 6.0;
  final double _initialElevation = 1.0;
  final double _endElevation = 0.0;
  final double _hoverElevation = 3.0;

  @override
  void initState() {
    super.initState();
    _elevation = _initialElevation;
  }

  @override
  Widget build(BuildContext context) {
    // final Color? foregroundColor =
    //     Theme.of(context).textTheme.bodyMedium?.color;

    return Measured(
      outlined: false,
      borders: const [],
      onChanged: (Size size) {
        if (size.width < 240.0) {
          setState(() => _maxLines = 1);
        } else {
          setState(() => _maxLines = 3);
        }
      },
      child: Card(
        elevation: _elevation,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: InkWell(
          onTap: widget.onTap == null
              ? null
              : () => widget.onTap?.call(widget.project),
          onHover: (bool isHit) {
            setState(() {
              _elevation = isHit ? _hoverElevation : _initialElevation;
            });
          },
          onTapDown: (details) {
            setState(() => _elevation = _endElevation);
          },
          onTapUp: (details) {
            setState(() => _elevation = _initialElevation);
          },
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Ink.image(
                    image: NetworkImage(widget.project.getCover()),
                    fit: BoxFit.cover,
                    colorFilter: const ColorFilter.mode(
                      Colors.black26,
                      BlendMode.darken,
                    ),
                    height: 120.0,
                    child: InkWell(
                      onTap: widget.onTap == null
                          ? null
                          : () => widget.onTap?.call(widget.project),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 12.0,
                      right: 12.0,
                      top: 12.0,
                    ),
                    child: Hero(
                      tag: widget.project.id,
                      child: Material(
                        color: Colors.transparent,
                        child: ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 5,
                              sigmaY: 5,
                            ),
                            child: SizedBox(
                              width: 500.0,
                              child: Text(
                                widget.project.name,
                                overflow: TextOverflow.ellipsis,
                                style: Utils.calligraphy.body(
                                  textStyle: TextStyle(
                                    fontSize: widget.compact ? 24.0 : 32.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  summaryWidget(),
                ],
              ),
              // Positioned(
              //   bottom: 6.0,
              //   left: 0.0,
              //   child: Column(
              //     mainAxisSize: MainAxisSize.min,
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Container(
              //         height: 24.0,
              //         width: 300.0,
              //         padding: const EdgeInsets.symmetric(vertical: 12.0),
              //         child: const WaveDivider(),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.symmetric(horizontal: 24.0),
              //         child: Text(
              //           Jiffy.parseFromDateTime(widget.project.createdAt)
              //               .yMMMEd,
              //           style: Utils.calligraphy.body(
              //             textStyle: TextStyle(
              //               fontSize: 14.0,
              //               fontWeight: FontWeight.w400,
              //               color: foregroundColor?.withOpacity(0.6),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget summaryWidget() {
    if (widget.project.summary.isEmpty) {
      return Container();
    }

    final Color? foregroundColor =
        Theme.of(context).textTheme.bodyMedium?.color;

    return Container(
      width: 500.0,
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Text(
        widget.project.summary,
        maxLines: _maxLines,
        overflow: TextOverflow.ellipsis,
        style: Utils.calligraphy.body(
          textStyle: TextStyle(
            fontSize: widget.compact ? 14.0 : 16.0,
            fontWeight: FontWeight.w400,
            color: foregroundColor?.withOpacity(0.6),
          ),
        ),
      ),
    );
  }
}
