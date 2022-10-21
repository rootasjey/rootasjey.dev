import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rootasjey/components/buttons/circle_button.dart';
import 'package:rootasjey/components/icons/app_icon.dart';
import 'package:rootasjey/router/locations/home_location.dart';
import 'package:rootasjey/globals/utilities.dart';
import 'package:rootasjey/router/locations/signin_location.dart';
import 'package:unicons/unicons.dart';

class ApplicationBar extends ConsumerWidget {
  const ApplicationBar({
    Key? key,
    this.minimal = false,
    this.pinned = true,
    this.showUserSection = true,
    this.bottom,
    this.right,
  }) : super(key: key);

  /// If true, will only display right section with search, language, & avatar.
  final bool minimal;

  /// Whether the app bar should remain visible at the start of the scroll view.
  final bool pinned;

  /// Display user's menu if authenticated or signin/up button is not.
  /// If this property is false, the place will be empty.
  final bool showUserSection;

  /// This widget appears across the bottom of the app bar.
  final PreferredSizeWidget? bottom;

  final Widget? right;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isMobileSize = Utilities.size.isMobileSize(context);

    // final User userProvider = ref.watch(AppState.userProvider);
    // final UserNotifier userNotifier = ref.read(AppState.userProvider.notifier);

    // final String? avatarUrl = userProvider.firestoreUser?.getProfilePicture();
    // final String initials = userNotifier.getInitialsUsername();

    final String? location = Beamer.of(context)
        .beamingHistory
        .last
        .history
        .last
        .routeInformation
        .location;

    final bool hasHistory = location != HomeLocation.route;
    final Widget rightWidget = right ?? Container();

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
                child: OutlinedButton(
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
                      "resume",
                      style: Utilities.fonts.body1(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              // if (!minimal) mainSection(isMobileSize),
              // if (showUserSection)
              //   userSection(
              //     context,
              //     ref: ref,
              //     isMobileSize: isMobileSize,
              //     minimal: minimal,
              //     isAuthenticated: userNotifier.isAuthenticated,
              //     initials: initials,
              //     avatarUrl: avatarUrl ?? "",
              //   ),
              if (right != null) rightWidget,
            ],
          ),
        ),
        bottom: bottom,
      ),
    );
  }
}
