import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rootasjey/components/avatar/adaptive_user_avatar.dart';
import 'package:rootasjey/router/locations/dashboard_location.dart';
import 'package:rootasjey/router/locations/search_location.dart';
import 'package:unicons/unicons.dart';

class AvatarMenu extends ConsumerWidget {
  const AvatarMenu({
    Key? key,
    this.compact = false,
    this.padding = EdgeInsets.zero,
    this.avatarInitials = '',
    this.avatarURL = '',
    required this.onSignOut,
  }) : super(key: key);

  final bool compact;
  final EdgeInsets padding;

  /// If set, this will take priority over [avatarInitials] property.
  final String avatarURL;

  /// Show initials letters if [avatarURL] is empty.
  final String avatarInitials;

  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: padding,
      child: PopupMenuButton<String>(
        icon: Material(
          elevation: 4.0,
          shape: CircleBorder(),
          child: AdaptiveUserAvatar(
            avatarURL: avatarURL,
            initials: avatarInitials,
          ),
        ),
        onSelected: (uri) async {
          if (uri == 'signout') {
            onSignOut();
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
      if (compact) ...[
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
