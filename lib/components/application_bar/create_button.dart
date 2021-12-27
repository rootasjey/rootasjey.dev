import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/router/locations/dashboard_location.dart';
import 'package:rootasjey/types/globals/globals.dart';
import 'package:unicons/unicons.dart';

/// Button to create new posts a-or projects.
class CreateButton extends StatelessWidget {
  const CreateButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = Globals.constants.colors;
    final foregroundColor = colors.getForeground(context).withOpacity(0.6);

    return PopupMenuButton(
      tooltip: "new".tr(),
      icon: Icon(UniconsLine.plus, color: foregroundColor),
      onSelected: (String path) {
        Beamer.of(context).beamToNamed(path);
      },
      itemBuilder: (_) => <PopupMenuEntry<String>>[
        PopupMenuItem(
          value: DashboardLocationContent.newPostsRoute,
          child: ListTile(
            leading: Icon(UniconsLine.newspaper),
            title: Text("post_new".tr()),
          ),
        ),
        PopupMenuItem(
          value: DashboardLocationContent.newProjectsRoute,
          child: ListTile(
            leading: Icon(UniconsLine.apps),
            title: Text("project_new".tr()),
          ),
        ),
      ],
    );
  }
}
