import 'dart:async';
import 'dart:ui';

import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:rootasjey/components/buttons/circle_button.dart';
import 'package:rootasjey/components/icons/app_icon.dart';
import 'package:rootasjey/components/letter_avatar.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/globals/utils.dart';
import 'package:rootasjey/router/locations/home_location.dart';
import 'package:rootasjey/router/locations/settings_location.dart';
import 'package:rootasjey/router/locations/signin_location.dart';
import 'package:rootasjey/types/enums/enum_app_bar_mode.dart';
import 'package:rootasjey/types/user/user_auth.dart';
import 'package:rootasjey/types/user/user_firestore.dart';
import 'package:super_context_menu/super_context_menu.dart';

class ApplicationBar extends StatelessWidget {
  const ApplicationBar({
    super.key,
    this.hideIcon = false,
    this.pinned = true,
    this.bottom,
    this.backgroundColor,
    this.toolbarHeight = 90.0,
    this.padding = const EdgeInsets.only(left: 24.0, top: 16.0, right: 24.0),
    this.isMobileSize = false,
    this.mode = EnumAppBarMode.home,
    this.onTapIcon,
    this.onTapTitle,
    this.elevation,
    this.title,
    this.rightChildren = const [],
  });

  /// Hide the app bar icon if true.
  final bool hideIcon;

  /// Whether the app bar should remain visible at the start of the scroll view.
  final bool pinned;

  /// Adapt the user interface to small screens if true.
  final bool isMobileSize;

  /// The background color of the app bar.
  final Color? backgroundColor;

  /// The elevation of the app bar.
  final double? elevation;

  /// The height of the app bar.
  final double toolbarHeight;

  /// The padding of the app bar.
  final EdgeInsets padding;

  /// This widget appears across the bottom of the app bar.
  final PreferredSizeWidget? bottom;

  /// AppBar appareance according of the displayed page.
  final EnumAppBarMode mode;

  /// Callback fired when app bar icon is tapped.
  final void Function()? onTapIcon;

  /// Callback fired when app bar title is tapped.
  final void Function()? onTapTitle;

  /// App bar title.
  final Widget? title;

  /// App bar right children.
  final List<Widget> rightChildren;

  @override
  Widget build(
    BuildContext context,
  ) {
    final String location = Beamer.of(context)
        .beamingHistory
        .last
        .history
        .last
        .routeInformation
        .uri
        .toString();

    final bool hasHistory = location != HomeLocation.route;
    final Color foregroundColor =
        Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8) ??
            Colors.black;

    final EdgeInsets localPadding = padding.copyWith(
      left: isMobileSize ? 0.0 : padding.left,
    );

    return SliverAppBar(
      floating: true,
      snap: true,
      pinned: pinned,
      elevation: elevation,
      toolbarHeight: toolbarHeight,
      backgroundColor: backgroundColor ??
          Theme.of(context).scaffoldBackgroundColor.withOpacity(0.6),
      automaticallyImplyLeading: false,
      title: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5,
          sigmaY: 5,
        ),
        child: Padding(
          padding: localPadding,
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
                        onTap: () => Utils.passage.back(
                          context,
                          isMobile: isMobileSize,
                        ),
                        child: Icon(
                          TablerIcons.arrow_left,
                          color: foregroundColor,
                        ),
                      ),
                    ),
                  if (!hideIcon)
                    AppIcon(
                      size: 36.0,
                      onTap: onTapIcon,
                    ),
                  appBarTitle(context),
                ],
              ),
              Wrap(
                spacing: 12.0,
                children: rightChildren,
              ),
            ],
          ),
        ),
      ),
      bottom: bottom,
    );
  }

  Widget appBarTitle(BuildContext context) {
    if (title != null) {
      return title ?? Container();
    }

    return Padding(
      padding: const EdgeInsets.only(left: 6.0),
      child: TextButton(
        onPressed: onTapTitle,
        child: Text(
          Constants.appName,
          style: Utils.calligraphy.body(
            textStyle: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w600,
              color: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.color
                  ?.withOpacity(0.8),
            ),
          ),
        ),
      ),
    );
  }

  Widget authButtonBuilder(
    BuildContext context,
    UserAuth? userAuth,
    UserFirestore userFirestore,
    Widget? child,
  ) {
    if (mode == EnumAppBarMode.signin || mode == EnumAppBarMode.home) {
      return Container();
    }

    final Color foregroundColor =
        Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8) ??
            Colors.black;

    if (userAuth != null && userAuth.uid.isNotEmpty) {
      return ContextMenuWidget(
        child: LetterAvatar(
          radius: 14.0,
          tooltip: "dashboard".tr(),
          margin: const EdgeInsets.only(top: 6.0),
          foregroundColor:
              Constants.colors.palette.first.computeLuminance() > 0.4
                  ? Colors.black
                  : Colors.white,
          backgroundColor: Constants.colors.palette.first,
          name: userAuth.displayName ?? "?",
          onTap: () => context.beamToNamed(HomeLocation.route),
        ),
        menuProvider: (MenuRequest request) =>
            contextMenuProvider(request, context),
      );
    }

    return IconButton(
      onPressed: () => context.beamToNamed(SigninLocation.route),
      tooltip: "signin.name".tr(),
      color: foregroundColor,
      icon: const Icon(TablerIcons.user),
    );
  }

  FutureOr<Menu?> contextMenuProvider(
    MenuRequest request,
    BuildContext context,
  ) {
    return Menu(children: [
      MenuAction(
        title: "dashboard".tr(),
        callback: () => context.beamToNamed(HomeLocation.route),
      ),
      MenuSeparator(),
      MenuAction(
        title: "settings.name".tr(),
        image: MenuImage.icon(TablerIcons.settings),
        callback: () => context.beamToNamed(SettingsLocation.route),
      ),
      MenuSeparator(),
      MenuAction(
        title: "signout.name".tr(),
        image: MenuImage.icon(TablerIcons.logout),
        callback: () {
          Utils.state.user.signOut();
          Beamer.of(context, root: true)
              .beamToReplacementNamed(HomeLocation.route);
        },
      ),
    ]);
  }
}
