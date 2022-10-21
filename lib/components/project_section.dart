import 'package:flutter/material.dart';
import 'package:rootasjey/components/mini_project_card.dart';
import 'package:rootasjey/globals/utilities.dart';
import 'package:unicons/unicons.dart';

class ProjectSection extends StatefulWidget {
  const ProjectSection({super.key});

  @override
  State<ProjectSection> createState() => _ProjectSectionState();
}

class _ProjectSectionState extends State<ProjectSection> {
  String _projectTitle = "";
  Color _backgroundColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 200.0, top: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _projectTitle.isEmpty ? "Featured Projects" : _projectTitle,
              style: Utilities.fonts.body4(
                fontSize: 32.0,
                fontWeight: FontWeight.w600,
                decorationColor: _backgroundColor,
                decorationThickness: _projectTitle.isEmpty ? 0.0 : 12.0,
                decoration: TextDecoration.underline,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Wrap(
                spacing: 12.0,
                runSpacing: 12.0,
                children: [
                  MiniProjectCard(
                    iconData: UniconsLine.pen,
                    label: "Artbooking",
                    onHover: onHover,
                    color: Colors.pink,
                  ),
                  MiniProjectCard(
                    iconData: UniconsLine.comment,
                    label: "fig.style",
                    onHover: onHover,
                    color: Colors.amber,
                  ),
                  MiniProjectCard(
                    iconData: UniconsLine.heart_medical,
                    label: "My Health Partner",
                    onHover: onHover,
                    color: Colors.blue,
                  ),
                  MiniProjectCard(
                    iconData: UniconsLine.image,
                    label: "unsplasharp",
                    onHover: onHover,
                    color: Colors.green,
                  ),
                  MiniProjectCard(
                    iconData: UniconsLine.cloud_wifi,
                    label: "notapokedex",
                    onHover: onHover,
                    color: Colors.yellow.shade800,
                  ),
                  MiniProjectCard(
                    iconData: UniconsLine.cloud_wifi,
                    label: "conway",
                    onHover: onHover,
                    color: Colors.blueGrey,
                  ),
                ],
              ),
            ),
            Opacity(
              opacity: 0.4,
              child: Text(
                "see all projects",
                style: Utilities.fonts.body1(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onHover(String label, Color color, bool isHover) {
    setState(() {
      _projectTitle = isHover ? label : "";
      _backgroundColor = isHover ? color : Colors.transparent;
    });
  }
}
