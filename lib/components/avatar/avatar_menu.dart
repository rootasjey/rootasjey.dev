import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/avatar/adaptive_user_avatar.dart';
import 'package:rootasjey/router/locations/dashboard_location.dart';
import 'package:rootasjey/router/locations/search_location.dart';
import 'package:rootasjey/state/user.dart';
import 'package:unicons/unicons.dart';

class AvatarMenu extends StatelessWidget {
  final bool isSmall;
  final EdgeInsets padding;

  const AvatarMenu({
    Key key,
    this.isSmall = false,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: PopupMenuButton<String>(
        icon: Material(
          elevation: 4.0,
          shape: CircleBorder(),
          child: AdaptiveUserAvatar(),
        ),
        onSelected: (uri) {
          if (uri == 'signout') {
            stateUser.signOut(context: context);
            return;
          }

          Beamer.of(context).beamToNamed(uri);
        },
        itemBuilder: itemBuilder,
      ),
    );
  }

  List<PopupMenuEntry<String>> itemBuilder(BuildContext context) {
    return [
      if (isSmall) ...[
        PopupMenuItem(
          value: DashboardLocationContent.newPostsRoute,
          child: ListTile(
            leading: Icon(UniconsLine.plus),
            title: Text(
              "post_new".tr(),
              style: TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        PopupMenuItem(
          value: DashboardLocationContent.newProjectsRoute,
          child: ListTile(
            leading: Icon(UniconsLine.plus),
            title: Text(
              "project_new".tr(),
              style: TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        PopupMenuItem(
          value: SearchLocation.route,
          child: ListTile(
            leading: Icon(UniconsLine.search),
            title: Text(
              "search".tr(),
              style: TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
      PopupMenuItem(
        value: DashboardLocationContent.postsRoute,
        child: ListTile(
          leading: Icon(UniconsLine.newspaper),
          title: Text(
            "posts_my".tr(),
            style: TextStyle(
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      PopupMenuItem(
        value: DashboardLocationContent.projectsRoute,
        child: ListTile(
          leading: Icon(UniconsLine.apps),
          title: Text(
            "projects_my".tr(),
            style: TextStyle(
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      PopupMenuItem(
        value: DashboardLocationContent.profileRoute,
        child: ListTile(
          leading: Icon(UniconsLine.user),
          title: Text(
            "profile_my".tr(),
            style: TextStyle(
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      PopupMenuItem(
        value: 'signout',
        child: ListTile(
          leading: Icon(UniconsLine.sign_left),
          title: Text(
            "signout".tr(),
            style: TextStyle(
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    ];
  }
}
