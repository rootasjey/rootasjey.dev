import 'package:flutter/material.dart';
import 'package:rootasjey/components/app_icon.dart';
import 'package:rootasjey/components/application_bar/main_section_desktop.dart';
import 'package:rootasjey/components/application_bar/main_section_mobile.dart';
import 'package:rootasjey/components/application_bar/user_auth_section.dart';
import 'package:rootasjey/components/application_bar/user_guest_section.dart';
import 'package:rootasjey/state/user.dart';
import 'package:rootasjey/utils/constants.dart';

class MainAppBar extends StatefulWidget {
  final List<Widget> trailing;

  const MainAppBar({
    Key? key,
    this.trailing = const [],
  }) : super(key: key);

  @override
  _MainAppBarState createState() => _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar> {
  @override
  Widget build(BuildContext context) {
    final pageWidth = MediaQuery.of(context).size.width;
    final compact = pageWidth < Constants.maxMobileWidth;

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
            userSection(compact),
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

  Widget userSection(bool compact) {
    if (stateUser.isUserConnected) {
      return UserAuthSection(
        compact: compact,
      );
    }

    return UserGuestSection();
  }
}
