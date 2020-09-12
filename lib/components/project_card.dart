import 'package:flutter/material.dart';
import 'package:rootasjey/types/project.dart';

class ProjectCard extends StatefulWidget {
  final VoidCallback onTap;
  final Widget popupMenuButton;
  final Project project;

  ProjectCard({
    this.onTap,
    this.popupMenuButton,
    this.project,
  });

  @override
  _ProjectCardState createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  double elevation = 2.0;

  @override
  Widget build(BuildContext context) {
    final project = widget.project;

    return SizedBox(
      width: 300.0,
      height: 300.0,
      child: Card(
        child: InkWell(
          onTap: widget.onTap,
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
