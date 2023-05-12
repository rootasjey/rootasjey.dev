import 'package:card_swiper/card_swiper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rootasjey/components/application_bar.dart';
import 'package:rootasjey/components/fade_in_y.dart';
import 'package:rootasjey/components/project_card.dart';
import 'package:rootasjey/globals/utilities.dart';
import 'package:rootasjey/types/enums/enum_project_item_action.dart';
import 'package:rootasjey/types/intents/next_intent.dart';
import 'package:rootasjey/types/intents/previous_intent.dart';
import 'package:rootasjey/types/project/project.dart';
import 'package:unicons/unicons.dart';

class ProjectsPageBody extends StatelessWidget {
  const ProjectsPageBody({
    super.key,
    required this.projects,
    required this.projectPopupMenuItems,
    required this.swipeController,
    required this.windowSize,
    required this.fab,
    this.canManage = false,
    this.onNextProject,
    this.onPopupMenuItemSelected,
    this.onPreviousProject,
    this.onTapProject,
  });

  /// True if the current authenticated user can manage projects.
  final bool canManage;

  /// Callback fired when a popup menu item is selected.
  final void Function(
    EnumProjectItemAction,
    int,
    Project,
  )? onPopupMenuItemSelected;

  /// Callback fired when we want to navigate to the next project.
  final void Function()? onNextProject;

  /// Callback fired when we want to navigate to the previous project.
  final void Function()? onPreviousProject;

  /// Callback fired after tapping on a project.
  final void Function(Project project)? onTapProject;

  /// Project list. Main data.
  final List<Project> projects;

  /// Menu item list to display on project card.
  final List<PopupMenuEntry<EnumProjectItemAction>> projectPopupMenuItems;

  /// Controller to navigate between published projects.
  final SwiperController swipeController;

  /// Window dimension for adaptive/responsive UI.
  final Size windowSize;

  /// Page floating action button showing creation button if available.
  final Widget fab;

  @override
  Widget build(BuildContext context) {
    final bool isMobileSize =
        windowSize.width < Utilities.size.mobileWidthTreshold;

    final double swiperHeight =
        isMobileSize ? windowSize.width - 60.0 : windowSize.height - 300.0;

    return Shortcuts(
      shortcuts: const <SingleActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.arrowLeft): PreviousIntent(),
        SingleActivator(LogicalKeyboardKey.arrowRight): NextIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          PreviousIntent: CallbackAction(
            onInvoke: (Intent intent) => swipeController.previous(),
          ),
          NextIntent: CallbackAction(
            onInvoke: (Intent intent) => swipeController.next(),
          ),
        },
        child: Scaffold(
          floatingActionButton: fab,
          body: CustomScrollView(
            slivers: [
              ApplicationBar(
                padding: EdgeInsets.only(
                  left: isMobileSize ? 0.0 : 90.0,
                  top: 16.0,
                ),
              ),
              SliverToBoxAdapter(
                child: FadeInY(
                  beginY: Utilities.ui.getBeginY(),
                  delay: Duration(
                    milliseconds: Utilities.ui.getNextAnimationDelay(),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 72.0,
                      bottom: 24.0,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "projects".tr().toUpperCase(),
                        style: Utilities.fonts.body2(
                          textStyle: const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: FadeInY(
                  beginY: Utilities.ui.getBeginY(),
                  delay: Duration(
                    milliseconds: Utilities.ui.getNextAnimationDelay(),
                  ),
                  child: SizedBox(
                    height: swiperHeight,
                    child: Swiper(
                      loop: false,
                      controller: swipeController,
                      pagination: const SwiperPagination(
                        builder: DotSwiperPaginationBuilder(
                          color: Colors.white,
                          activeColor: Colors.amber,
                        ),
                      ),
                      control: isMobileSize
                          ? null
                          : const SwiperControl(
                              color: Colors.amber,
                              padding: EdgeInsets.all(24.0),
                            ),
                      itemBuilder: (BuildContext context, int index) {
                        final Project project = projects.elementAt(index);

                        return ProjectCard(
                          index: index,
                          useBottomSheet: false,
                          onTapCard: () => onTapProject?.call(project),
                          project: project,
                          popupMenuEntries:
                              canManage ? projectPopupMenuItems : [],
                          onPopupMenuItemSelected: onPopupMenuItemSelected,
                          compact: isMobileSize,
                        );
                      },
                      itemCount: projects.length,
                      viewportFraction: isMobileSize ? 0.9 : 0.5,
                      scale: 0.6,
                    ),
                  ),
                ),
              ),
              mobileControls(context, isMobileSize),
            ],
          ),
        ),
      ),
    );
  }

  Widget mobileControls(BuildContext context, bool isMobileSize) {
    final Color? iconColor =
        Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6);

    if (!isMobileSize || projects.length < 2) {
      return const SliverToBoxAdapter();
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Wrap(
              spacing: 12.0,
              children: [
                IconButton(
                  onPressed: onPreviousProject,
                  icon: Icon(UniconsLine.arrow_left, color: iconColor),
                ),
                IconButton(
                  onPressed: onNextProject,
                  icon: Icon(UniconsLine.arrow_right, color: iconColor),
                ),
              ],
            ),
            Opacity(
              opacity: 0.4,
              child: Text(
                "project_carrousel_mobile_swipe".tr(),
                textAlign: TextAlign.center,
                style: Utilities.fonts.body(
                  textStyle: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
