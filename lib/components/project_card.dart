import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/globals/utilities.dart';
import 'package:rootasjey/types/enums/enum_project_item_action.dart';
import 'package:rootasjey/types/project/project.dart';
import 'package:unicons/unicons.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    super.key,
    required this.index,
    required this.project,
    required this.useBottomSheet,
    this.onTapCard,
    this.onPopupMenuItemSelected,
    this.popupMenuEntries = const [],
    this.compact = false,
  });

  /// If
  final bool compact;

  /// If true, a bottom sheet will be displayed on long press event.
  /// Setting this property to true will deactivate popup menu and
  /// hide like button.
  final bool useBottomSheet;

  /// Index position in a list, if available.
  final int index;

  /// Callback fired when one of the popup menu item entries is selected.
  final void Function(
    EnumProjectItemAction action,
    int index,
    Project project,
  )? onPopupMenuItemSelected;

  final void Function()? onTapCard;

  /// Menu item list displayed after tapping on the corresponding popup button.
  final List<PopupMenuEntry<EnumProjectItemAction>> popupMenuEntries;
  final Project project;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6.0,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Ink.image(
        image: NetworkImage(project.getCover()),
        fit: BoxFit.cover,
        colorFilter: const ColorFilter.mode(
          Colors.black26,
          BlendMode.darken,
        ),
        child: InkWell(
          onTap: onTapCard,
          child: Stack(
            children: [
              Positioned(
                bottom: 24.0,
                left: compact ? 12.0 : 42.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: project.id,
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
                                project.name,
                                overflow: TextOverflow.ellipsis,
                                style: Utilities.fonts.body(
                                  textStyle: TextStyle(
                                    fontSize: compact ? 24.0 : 32.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    summaryWidget(),
                    ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 5,
                          sigmaY: 5,
                        ),
                        child: Opacity(
                          opacity: 0.4,
                          child: Text(
                            Jiffy(project.createdAt).yMMMEd,
                            style: Utilities.fonts.body(
                              textStyle: const TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              popupMenuButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget popupMenuButton() {
    if (popupMenuEntries.isEmpty || useBottomSheet) {
      return Container();
    }

    return Positioned(
      bottom: 10.0,
      right: 10.0,
      child: PopupMenuButton<EnumProjectItemAction>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        onSelected: (EnumProjectItemAction action) {
          onPopupMenuItemSelected?.call(
            action,
            index,
            project,
          );
        },
        itemBuilder: (BuildContext context) {
          return popupMenuEntries;
        },
        child: CircleAvatar(
          radius: 15.0,
          backgroundColor: Constants.colors.clairPink,
          child: const Padding(
            padding: EdgeInsets.all(4.0),
            child: Icon(
              UniconsLine.ellipsis_h,
              // color: value,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget summaryWidget() {
    if (project.summary.isEmpty) {
      return Container();
    }

    return SizedBox(
      width: 500.0,
      child: Opacity(
        opacity: 0.6,
        child: Text(project.summary,
            style: Utilities.fonts.body(
              textStyle: TextStyle(
                fontSize: compact ? 14.0 : 18.0,
                fontWeight: FontWeight.w500,
              ),
            )),
      ),
    );
  }
}
