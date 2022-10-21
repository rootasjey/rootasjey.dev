import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rootasjey/components/buttons/circle_button.dart';
import 'package:rootasjey/components/icons/app_icon.dart';
import 'package:rootasjey/components/popup_menu/popup_menu_icon.dart';
import 'package:rootasjey/components/popup_menu/popup_menu_item_icon.dart';
import 'package:rootasjey/globals/app_state.dart';
import 'package:rootasjey/router/locations/home_location.dart';
import 'package:rootasjey/globals/utilities.dart';
import 'package:rootasjey/router/locations/signin_location.dart';
import 'package:unicons/unicons.dart';

class ApplicationBar extends ConsumerWidget {
  const ApplicationBar({
    Key? key,
    this.pinned = true,
    this.bottom,
  }) : super(key: key);

  /// Whether the app bar should remain visible at the start of the scroll view.
  final bool pinned;

  /// This widget appears across the bottom of the app bar.
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isMobileSize = Utilities.size.isMobileSize(context);

    final userFirestore = ref.watch(AppState.userProvider).firestoreUser;
    final bool isAuthenticated =
        userFirestore != null && userFirestore.rights.manageData;

    final String? location = Beamer.of(context)
        .beamingHistory
        .last
        .history
        .last
        .routeInformation
        .location;

    final bool hasHistory = location != HomeLocation.route;

    return SliverPadding(
      padding:
          isMobileSize ? EdgeInsets.zero : const EdgeInsets.only(top: 30.0),
      sliver: SliverAppBar(
        floating: true,
        snap: true,
        pinned: pinned,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsets.only(
            top: 16.0,
            left: isMobileSize ? 0.0 : 170.0,
          ),
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
                        onTap: () => Utilities.navigation.back(
                          context,
                          isMobile: isMobileSize,
                        ),
                        child: Icon(
                          UniconsLine.arrow_left,
                          color: Theme.of(context).textTheme.bodyText2?.color,
                        ),
                      ),
                    ),
                  AppIcon(
                    size: 32.0,
                    onLongPress: () {
                      Beamer.of(context).beamToNamed(SigninLocation.route);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      "rootasjey",
                      style: Utilities.fonts.body3(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 80.0),
                child: Wrap(
                  spacing: 12.0,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        // GlobalLoggy().loggy.info("resume dark");
                        // AdaptiveTheme.of(context).setDark();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.pink,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "resume".tr(),
                          style: Utilities.fonts.body1(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
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
              ),
            ],
          ),
        ),
        bottom: bottom,
      ),
    );
  }
}
