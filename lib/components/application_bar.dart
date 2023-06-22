import 'dart:ui';

import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rootasjey/components/buttons/circle_button.dart';
import 'package:rootasjey/components/icons/app_icon.dart';
import 'package:rootasjey/components/popup_menu/popup_menu_icon.dart';
import 'package:rootasjey/components/popup_menu/popup_menu_item_icon.dart';
import 'package:rootasjey/globals/app_state.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/router/locations/home_location.dart';
import 'package:rootasjey/globals/utilities.dart';
import 'package:rootasjey/router/locations/settings_location.dart';
import 'package:rootasjey/router/locations/signin_location.dart';
import 'package:rootasjey/types/user/user_firestore.dart';
import 'package:unicons/unicons.dart';
import 'package:url_launcher/url_launcher.dart';

class ApplicationBar extends ConsumerWidget {
  const ApplicationBar({
    Key? key,
    this.pinned = true,
    this.bottom,
    this.backgroundColor,
    this.padding = const EdgeInsets.only(left: 24.0, top: 16.0, right: 24.0),
    this.isMobileSize = false,
  }) : super(key: key);

  /// Whether the app bar should remain visible at the start of the scroll view.
  final bool pinned;

  /// True if the screen's width is smaller than 600px.
  /// Back behavior is different if this is true.
  final bool isMobileSize;

  /// The background color of the app bar.
  final Color? backgroundColor;

  /// The padding of the app bar.
  final EdgeInsets padding;

  /// This widget appears across the bottom of the app bar.
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userFirestore = ref.watch(AppState.userProvider).firestoreUser;
    final bool isAuthenticated =
        userFirestore != null && userFirestore.rights.manageData;

    ref.watch(AppState.appSettingsProvider);

    final String? location = Beamer.of(context)
        .beamingHistory
        .last
        .history
        .last
        .routeInformation
        .location;

    final bool hasHistory = location != HomeLocation.route;
    final Color foregroundColor =
        Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8) ??
            Colors.black;

    return SliverAppBar(
      floating: true,
      snap: true,
      pinned: pinned,
      toolbarHeight: 90.0,
      backgroundColor: backgroundColor ?? Colors.transparent,
      automaticallyImplyLeading: false,
      title: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5,
          sigmaY: 5,
        ),
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (hasHistory)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: CircleButton.outlined(
                        borderColor: Colors.transparent,
                        onTap: () => Utilities.navigation.back(
                          context,
                          isMobile: isMobileSize,
                        ),
                        child: Icon(
                          UniconsLine.arrow_left,
                          color: foregroundColor,
                        ),
                      ),
                    ),
                  AppIcon(
                    size: 24.0,
                    onLongPress: () {
                      final UserFirestore? user =
                          ref.read(AppState.userProvider).firestoreUser;

                      if (user == null) {
                        Beamer.of(context).beamToNamed(SigninLocation.route);
                        return;
                      }

                      Beamer.of(context).beamToNamed(SettingsLocation.route);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      "rootasjey",
                      style: Utilities.fonts.body3(
                        textStyle: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Wrap(
                spacing: 12.0,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      final String curriculumUrl = ref
                          .read(AppState.appSettingsProvider)
                          .socialNetworks
                          .curriculum;

                      if (curriculumUrl.isEmpty) {
                        return;
                      }

                      launchUrl(Uri.parse(curriculumUrl));
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Constants.colors.palette.elementAt(1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "resume".tr(),
                        style: Utilities.fonts.body(
                          textStyle: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (isAuthenticated)
                    PopupMenuButton(
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItemIcon(
                            icon: const PopupMenuIcon(UniconsLine.signout),
                            textLabel: "logout".tr(),
                            newValue: "logout",
                            selected: false,
                          ),
                        ];
                      },
                      onSelected: (String value) {
                        if (value == "logout") {
                          ref.read(AppState.userProvider.notifier).signOut();
                          return;
                        }
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      icon: const Icon(UniconsLine.setting),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottom: bottom,
    );
  }
}
