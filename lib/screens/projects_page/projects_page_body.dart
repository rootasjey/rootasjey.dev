import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/square_header.dart';
import 'package:rootasjey/globals/utils.dart';
import 'package:rootasjey/types/project/project.dart';

class ProjectsPageBody extends StatelessWidget {
  const ProjectsPageBody({
    super.key,
    required this.projects,
    required this.fab,
    required this.windowSize,
    this.canManage = false,
    this.isMobileSize = false,
    this.accentColor = Colors.blue,
    this.onTapProject,
    this.onGoBack,
    this.onGoHome,
  });

  /// True if the screen size is mobile.
  final bool isMobileSize;

  /// True if the current authenticated user can manage projects.
  final bool canManage;

  /// Accent color for border and title.
  final Color accentColor;

  /// Callback fired after tapping on a project.
  final void Function(Project project)? onTapProject;

  /// Callback to go back to the previous page.
  final void Function()? onGoBack;

  /// Callback to go back to the home page.
  final void Function()? onGoHome;

  /// Project list. Main data.
  final List<Project> projects;

  /// Window's size.
  final Size windowSize;

  /// Page floating action button showing creation button if available.
  final Widget fab;

  @override
  Widget build(BuildContext context) {
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
            SquareHeader(
              margin: isMobileSize
                  ? const EdgeInsets.only(top: 24.0)
                  : const EdgeInsets.only(top: 60.0),
              onGoBack: onGoBack,
              onGoHome: onGoHome,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 12.0,
                right: 12.0,
              ),
              child: FractionallySizedBox(
                widthFactor: isMobileSize ? 1.0 : 0.6,
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
                          fontSize: isMobileSize ? 14.0 : 16.0,
                          fontWeight: FontWeight.w400,
                          color: foregroundColor?.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                top: 42.0,
                left: 12.0,
                right: 24.0,
              ),
              child: Wrap(
                spacing: 24.0,
                runSpacing: 24.0,
                direction: Axis.vertical,
                children: projects.map((Project project) {
                  return SizedBox(
                    width: windowSize.width - 48.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.name,
                          style: Utils.calligraphy.body(
                            textStyle: TextStyle(
                              height: 1.0,
                              fontSize: isMobileSize ? 24.0 : 64.0,
                              fontWeight: FontWeight.w200,
                              color: foregroundColor?.withOpacity(0.8),
                            ),
                          ),
                        ),
                        Text(
                          project.summary,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: Utils.calligraphy.body(
                            textStyle: TextStyle(
                              fontSize: isMobileSize ? 14.0 : 16.0,
                              fontWeight: FontWeight.w400,
                              color: foregroundColor?.withOpacity(0.4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
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
