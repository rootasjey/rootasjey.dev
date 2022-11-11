import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/mini_project_card.dart';
import 'package:rootasjey/globals/utilities.dart';
import 'package:rootasjey/router/locations/projects_location.dart';
import 'package:unicons/unicons.dart';

class ProjectSection extends StatefulWidget {
  const ProjectSection({
    super.key,
    this.size = Size.zero,
  });

  /// Window's size.
  final Size size;

  @override
  State<ProjectSection> createState() => _ProjectSectionState();
}

class _ProjectSectionState extends State<ProjectSection> {
  String _projectTitle = "";
  Color _backgroundColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    final double fontSize =
        widget.size.width < Utilities.size.mobileWidthTreshold ? 24.0 : 64.0;

    return SliverToBoxAdapter(
      child: Container(
        padding: getMargin(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Opacity(
              opacity: 1.0,
              child: Text(
                _projectTitle.isEmpty
                    ? "projects_featured".tr()
                    : _projectTitle,
                style: Utilities.fonts.body5(
                  textStyle: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                    decorationColor: _backgroundColor,
                    decorationThickness: _projectTitle.isEmpty ? 0.0 : 6.0,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            Container(
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
            TextButton(
              onPressed: onNavigateToAllProjects,
              child: Text(
                "projects_see_all".tr(),
                style: Utilities.fonts.body(
                  textStyle: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  EdgeInsets getMargin() {
    if (widget.size.width < Utilities.size.mobileWidthTreshold) {
      return const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 64.0,
        bottom: 100.0,
      );
    }

    if (widget.size.width < 1000.0) {
      return const EdgeInsets.only(
        left: 36.0,
        right: 36.0,
        top: 64.0,
        bottom: 100.0,
      );
    }

    return const EdgeInsets.only(
      left: 200.0,
      top: 100.0,
      bottom: 100.0,
    );
  }

  void onHover(String label, Color color, bool isHover) {
    setState(() {
      _projectTitle = isHover ? label : "";
      _backgroundColor = isHover ? color : Colors.transparent;
    });
  }

  void onNavigateToAllProjects() {
    Beamer.of(context).beamToNamed(ProjectsLocation.route);
  }
}
