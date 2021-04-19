import 'package:flutter/material.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/types/project.dart';

class ProjectCard extends StatefulWidget {
  final VoidCallback onTap;
  final Widget popupMenuButton;
  final Project project;

  ProjectCard({
    this.onTap,
    this.popupMenuButton,
    @required this.project,
  });

  @override
  _ProjectCardState createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  double elevation = 4.0;
  Color borderColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    final project = widget.project;

    return SizedBox(
      width: 300.0,
      height: 300.0,
      child: Card(
        elevation: elevation,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: borderColor,
            width: 2.0,
          ),
        ),
        child: InkWell(
          onTap: widget.onTap,
          onHover: (isHover) {
            setState(() {
              elevation = isHover ? 8.0 : 4.0;

              borderColor = isHover ? stateColors.primary : Colors.transparent;
            });
          },
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Opacity(
                      opacity: 0.8,
                      child: Text(
                        project.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Opacity(
                        opacity: 0.6,
                        child: Text(
                          project.summary,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),

                    // Wrap(
                    //   children: project.platforms.map((platform) {
                    //     return Chip(
                    //       label: Text(
                    //         platform,
                    //       ),
                    //     );
                    //   }).toList(),
                    // ),
                  ],
                ),
              ),
              if (widget.popupMenuButton != null)
                Positioned(
                  right: 20.0,
                  bottom: 20.0,
                  child: widget.popupMenuButton,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
