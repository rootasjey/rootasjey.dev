import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rootasjey/components/app_icon.dart';
import 'package:rootasjey/components/application_bar/main_section_desktop.dart';
import 'package:rootasjey/components/application_bar/main_section_mobile.dart';
import 'package:rootasjey/components/application_bar/user_auth_section.dart';
import 'package:rootasjey/components/application_bar/user_guest_section.dart';
import 'package:rootasjey/router/locations/home_location.dart';
import 'package:rootasjey/types/globals/globals.dart';
import 'package:rootasjey/utils/constants.dart';

class MainAppBar extends ConsumerWidget {
  final List<Widget> trailing;

  const MainAppBar({
    Key? key,
    this.trailing = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageWidth = MediaQuery.of(context).size.width;
    final compact = pageWidth < Constants.maxMobileWidth;

    ref.watch(Globals.state.user);

    final user = ref.read(Globals.state.user.notifier);
    final isAuthenticated = user.isAuthenticated;

    return SliverAppBar(
      floating: true,
      snap: true,
      pinned: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: EdgeInsets.only(
          left: compact ? 0.0 : 80.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            AppIcon(),
            mainSection(compact),
            userSection(
              context,
              ref: ref,
              compact: compact,
              isAuthenticated: isAuthenticated,
            ),
          ],
        ),
      ),
    );
  }

  Widget mainSection(bool compact) {
    if (compact) {
      return MainSectionMobile();
    }

    return MainSectionDesktop();
  }

  Widget userSection(
    BuildContext context, {
    bool compact = false,
    bool isAuthenticated = false,
    required WidgetRef ref,
  }) {
    if (isAuthenticated) {
      final user = ref.read(Globals.state.user.notifier);
      final String avatarURL = user.getPPUrl();
      final String initials = user.getInitialsUsername();

      return UserAuthSection(
        compact: compact,
        avatarInitials: initials,
        avatarURL: avatarURL,
        onSignOut: () => onSignOut(context, ref),
      );
    }

    return UserGuestSection();
  }

  void onSignOut(BuildContext context, WidgetRef ref) async {
    final user = ref.read(Globals.state.user.notifier);
    await user.signOut();
    Beamer.of(context).beamToNamed(HomeLocation.route);
  }
}
