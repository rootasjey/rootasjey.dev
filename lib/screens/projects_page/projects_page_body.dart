import 'package:beamer/beamer.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rootasjey/components/buttons/circle_button.dart';
import 'package:rootasjey/components/fade_in_y.dart';
import 'package:rootasjey/components/icons/app_icon.dart';
import 'package:rootasjey/components/project_card.dart';
import 'package:rootasjey/globals/utilities.dart';
import 'package:rootasjey/types/enums/enum_project_item_action.dart';
import 'package:rootasjey/types/intents/next_intent.dart';
import 'package:rootasjey/types/intents/previous_intent.dart';
import 'package:rootasjey/types/project.dart';
import 'package:unicons/unicons.dart';

class ProjectsPageBody extends StatelessWidget {
  const ProjectsPageBody({
    super.key,
    this.onTapProject,
    required this.projects,
    required this.projectPopupMenuItems,
    required this.swipeController,
    required this.windowSize,
    required this.fab,
    this.onPopupMenuItemSelected,
    this.canManage = false,
  });

  /// True if the current authenticated user can manage projects.
  final bool canManage;

  /// Callback fired when a popup menu item is selected.
  final void Function(
    EnumProjectItemAction,
    int,
    Project,
  )? onPopupMenuItemSelected;

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
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 72.0,
                    top: 72.0,
                    bottom: 24.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          FadeInY(
                            beginY: Utilities.ui.getBeginY(),
                            delay: Duration(
                              milliseconds: Utilities.ui
                                  .getNextAnimationDelay(reset: true),
                            ),
                            child: CircleButton(
                              onTap: Beamer.of(context).beamBack,
                              icon: const Icon(UniconsLine.arrow_left),
                              backgroundColor: Colors.amber,
                            ),
                          ),
                          FadeInY(
                            beginY: Utilities.ui.getBeginY(),
                            delay: Duration(
                              milliseconds:
                                  Utilities.ui.getNextAnimationDelay(),
                            ),
                            child: const Opacity(
                              opacity: 0.6,
                              child: AppIcon(
                                margin: EdgeInsets.only(left: 12.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                      FadeInY(
                        beginY: Utilities.ui.getBeginY(),
                        delay: Duration(
                          milliseconds: Utilities.ui.getNextAnimationDelay(),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Text(
                            "Projects".toUpperCase(),
                            style: Utilities.fonts.body2(
                              textStyle: const TextStyle(
                                fontSize: 40.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
                    height: windowSize.height - 300.0,
                    child: Swiper(
                      loop: false,
                      controller: swipeController,
                      pagination: const SwiperPagination(
                        builder: DotSwiperPaginationBuilder(
                          color: Colors.white,
                          activeColor: Colors.amber,
                        ),
                      ),
                      control: const SwiperControl(
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
                          popupMenuEntries: projectPopupMenuItems,
                          onPopupMenuItemSelected: onPopupMenuItemSelected,
                        );
                      },
                      itemCount: projects.length,
                      viewportFraction: 0.5,
                      scale: 0.6,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
