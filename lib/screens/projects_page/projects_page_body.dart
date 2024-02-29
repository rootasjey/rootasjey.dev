import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:rootasjey/components/icons/app_icon.dart';
import 'package:rootasjey/globals/utils.dart';
import 'package:rootasjey/types/project/project.dart';

class ProjectsPageBody extends StatelessWidget {
  const ProjectsPageBody({
    super.key,
    required this.projects,
    required this.fab,
    this.canManage = false,
    this.isMobileSize = false,
    this.accentColor = Colors.blue,
    this.onTapProject,
    required this.windowSize,
  });

  /// True if the screen size is mobile.
  final bool isMobileSize;

  /// True if the current authenticated user can manage projects.
  final bool canManage;

  /// Accent color for border and title.
  final Color accentColor;

  /// Callback fired after tapping on a project.
  final void Function(Project project)? onTapProject;

  /// Project list. Main data.
  final List<Project> projects;

  /// Window's size.
  final Size windowSize;

  /// Page floating action button showing creation button if available.
  final Widget fab;

  @override
  Widget build(BuildContext context) {
    // int index = -1;
    final Color? foregroundColor =
        Theme.of(context).textTheme.bodyMedium?.color;

    return Scaffold(
      floatingActionButton: fab,
      body: Container(
        height: windowSize.height,
        decoration: BoxDecoration(
          border: Border.all(
            width: 16.0,
            color: accentColor,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Utils.graphic.tooltip(
                    tooltipString: "home".tr(),
                    child: const AppIcon(
                      size: 24.0,
                      margin: EdgeInsets.only(right: 12.0),
                    ),
                  ),
                  const Icon(TablerIcons.point),
                  Utils.graphic.tooltip(
                    tooltipString: "back".tr(),
                    child: IconButton(
                      onPressed: context.beamBack,
                      icon: const Icon(TablerIcons.arrow_back),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 12.0,
                right: 12.0,
              ),
              child: FractionallySizedBox(
                widthFactor: isMobileSize ? 0.9 : 0.6,
                child: Column(
                  children: [
                    Text(
                      "projects".tr().toUpperCase(),
                      style: Utils.calligraphy.body2(
                        textStyle: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      "projects_subtitle".tr(),
                      style: Utils.calligraphy.body(
                        textStyle: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          color: foregroundColor?.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 42.0),
              child: Wrap(
                spacing: 24.0,
                runSpacing: 24.0,
                direction: Axis.vertical,
                children: projects.map((project) {
                  // index++;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.name,
                        style: Utils.calligraphy.body(
                          textStyle: const TextStyle(
                            height: 1.0,
                            fontSize: 64.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        project.summary,
                        style: Utils.calligraphy.body(
                          textStyle: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: foregroundColor?.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ],
                  );
                  // return SizedBox(
                  //   width: 240.0,
                  //   height: 300.0,
                  //   child: ProjectCard(
                  //     index: index,
                  //     useBottomSheet: false,
                  //     project: project,
                  //     onTap: onTapProject,
                  //     descriptionMaxLines: isMobileSize ? 3 : 5,
                  //   ),
                  // );
                }).toList(),
              ),
              // child: GridView.builder(
              //   gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              //     maxCrossAxisExtent: 220.0,
              //     crossAxisSpacing: 16.0,
              //     // childAspectRatio: 2 / 3,
              //   ),
              //   itemBuilder: (BuildContext context, int index) {
              //     return ProjectCard(
              //       index: index,
              //       useBottomSheet: false,
              //       project: projects[index],
              //       onTap: onTapProject,
              //       descriptionMaxLines: isMobileSize ? 3 : 5,
              //     );
              //   },
              //   itemCount: projects.length,
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
