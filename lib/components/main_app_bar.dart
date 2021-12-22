import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/app_icon.dart';
import 'package:rootasjey/components/avatar/avatar_menu.dart';
import 'package:rootasjey/components/lang_popup_menu_button.dart';
import 'package:rootasjey/components/underlined_button.dart';
import 'package:rootasjey/router/locations/dashboard_location.dart';
import 'package:rootasjey/router/locations/posts_location.dart';
import 'package:rootasjey/router/locations/projects_location.dart';
import 'package:rootasjey/router/locations/search_location.dart';
import 'package:rootasjey/router/locations/settings_location.dart';
import 'package:rootasjey/router/locations/signin_location.dart';
import 'package:rootasjey/router/locations/signup_location.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/state/user.dart';
import 'package:rootasjey/utils/app_storage.dart';
import 'package:rootasjey/utils/brightness.dart';
import 'package:rootasjey/utils/constants.dart';
import 'package:rootasjey/utils/fonts.dart';
import 'package:unicons/unicons.dart';

class MainAppBar extends StatefulWidget {
  final bool renderSliver;
  final List<Widget> trailing;

  const MainAppBar({
    Key key,
    this.renderSliver = true,
    this.trailing = const [],
  }) : super(key: key);

  @override
  _MainAppBarState createState() => _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar> {
  @override
  Widget build(BuildContext context) {
    final isNarrow =
        MediaQuery.of(context).size.width < Constants.maxMobileWidth;

    final padding = EdgeInsets.only(
      left: isNarrow ? 0.0 : 80.0,
    );

    if (widget.renderSliver) {
      return renderSliver(
        isNarrow: isNarrow,
        padding: padding,
      );
    }

    return renderBox(
      isNarrow: isNarrow,
      padding: padding,
    );
  }

  Widget addButton() {
    return PopupMenuButton(
      tooltip: "new".tr(),
      icon: Icon(
        UniconsLine.plus,
        color: stateColors.foreground.withOpacity(0.6),
      ),
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

  Widget authenticatedMenu(bool isSmall) {
    return Container(
      padding: const EdgeInsets.only(
        top: 5.0,
        right: 10.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          addButton(),
          brightnessButton(),
          if (!isSmall) langButton(),
          ...widget.trailing,
          AvatarMenu(
            isSmall: isSmall,
            padding: const EdgeInsets.only(
              left: 12.0,
              right: 20.0,
            ),
          ),
        ],
      ),
    );
  }

  /// Switch from dark to light and vice-versa.
  Widget brightnessButton() {
    IconData iconBrightness = UniconsLine.brightness;
    final autoBrightness = appStorage.getAutoBrightness();

    if (!autoBrightness) {
      final currentBrightness = appStorage.getBrightness();

      iconBrightness = currentBrightness == Brightness.dark
          ? UniconsLine.adjust_half
          : UniconsLine.bright;
    }

    return PopupMenuButton<String>(
      icon: Icon(
        iconBrightness,
        color: stateColors.foreground.withOpacity(0.6),
      ),
      tooltip: "brightness".tr(),
      onSelected: (value) {
        if (value == 'auto') {
          BrightnessUtils.setAutoBrightness(context);
          return;
        }

        final brightness = value == 'dark' ? Brightness.dark : Brightness.light;

        BrightnessUtils.setBrightness(context, brightness);
      },
      itemBuilder: (context) {
        final autoBrightness = appStorage.getAutoBrightness();
        final brightness = autoBrightness ? null : appStorage.getBrightness();

        final primary = stateColors.primary;
        final basic = stateColors.foreground;

        return [
          PopupMenuItem(
            value: 'auto',
            child: ListTile(
              leading: Icon(UniconsLine.brightness),
              title: Text(
                "brightness_auto".tr(),
                style: TextStyle(
                  color: autoBrightness ? primary : basic,
                ),
              ),
              trailing: autoBrightness
                  ? Icon(
                      UniconsLine.check,
                      color: primary,
                    )
                  : null,
            ),
          ),
          PopupMenuItem(
            value: 'dark',
            child: ListTile(
              leading: Icon(UniconsLine.adjust_half),
              title: Text(
                "dark".tr(),
                style: TextStyle(
                  color: brightness == Brightness.dark ? primary : basic,
                ),
              ),
              trailing: brightness == Brightness.dark
                  ? Icon(
                      UniconsLine.check,
                      color: primary,
                    )
                  : null,
            ),
          ),
          PopupMenuItem(
            value: 'light',
            child: ListTile(
              leading: Icon(UniconsLine.bright),
              title: Text(
                "light".tr(),
                style: TextStyle(
                  color: brightness == Brightness.light ? primary : basic,
                ),
              ),
              trailing: brightness == Brightness.light
                  ? Icon(
                      UniconsLine.check,
                      color: primary,
                    )
                  : null,
            ),
          ),
        ];
      },
    );
  }

  Widget desktopSectionsRow() {
    return Wrap(
      spacing: 12.0,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        sectionButton(
          onPressed: () => Beamer.of(context).beamToNamed(
            ProjectsLocation.route,
          ),
          text: "projects".tr().toUpperCase(),
        ),
        sectionButton(
          onPressed: () => Beamer.of(context).beamToNamed(
            PostsLocation.route,
          ),
          text: "posts".tr().toUpperCase(),
        ),
        sectionButton(
          onPressed: () {
            if (stateUser.isUserConnected) {
              Beamer.of(context)
                  .beamToNamed(DashboardLocationContent.settingsRoute);
              return;
            }

            Beamer.of(context).beamToNamed(SettingsLocation.route);
          },
          text: "settings".tr().toUpperCase(),
        ),
        IconButton(
          onPressed: () {
            Beamer.of(context).beamToNamed(SearchLocation.route);
          },
          color: stateColors.foreground.withOpacity(0.8),
          icon: Icon(UniconsLine.search),
        ),
      ],
    );
  }

  Widget guestRow(bool isNarrow) {
    return Container(
      padding: const EdgeInsets.only(
        top: 5.0,
        right: 10.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () => Beamer.of(context).beamToNamed(
              SigninLocation.route,
            ),
            child: Text("signin".tr().toUpperCase()),
            style: ElevatedButton.styleFrom(
              primary: stateColors.primary,
            ),
          ),
          TextButton(
            onPressed: () => Beamer.of(context).beamToNamed(
              SignupLocation.route,
            ),
            child: Text(
              "signup".tr().toUpperCase(),
              style: TextStyle(
                color: stateColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget langButton() {
    return LangPopupMenuButton(
      color: stateColors.getCurrentBackground(context),
      onLangChanged: (newLang) async {
        await context.setLocale(Locale(newLang));

        setState(() {
          stateUser.setLang(newLang);
        });
      },
      lang: stateUser.lang,
    );
  }

  Widget mobileSectionsRow() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 24.0),
          child: sectionsPopupMenu(),
        ),
        IconButton(
          tooltip: "search".tr(),
          onPressed: () {
            Beamer.of(context).beamToNamed(SearchLocation.route);
          },
          color: stateColors.foreground.withOpacity(0.8),
          icon: Icon(UniconsLine.search),
        ),
      ],
    );
  }

  Widget renderBox({
    bool isNarrow = false,
    EdgeInsets padding = EdgeInsets.zero,
  }) {
    return AppBar(
      backgroundColor: stateColors.lightBackground,
      title: Padding(
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            AppIcon(),
            sectionsRow(isNarrow),
            userSpace(isNarrow),
          ],
        ),
      ),
    );
  }

  Widget renderSliver({
    bool isNarrow,
    EdgeInsets padding = EdgeInsets.zero,
  }) {
    return SliverAppBar(
      floating: true,
      snap: true,
      pinned: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            AppIcon(),
            sectionsRow(isNarrow),
            userSpace(isNarrow),
          ],
        ),
      ),
    );
  }

  Widget searchButton() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 8.0,
      ),
      child: Opacity(
        opacity: 0.6,
        child: IconButton(
          tooltip: "search".tr(),
          onPressed: () {
            Beamer.of(context).beamToNamed(SearchLocation.route);
          },
          color: stateColors.foreground,
          icon: Icon(UniconsLine.search),
        ),
      ),
    );
  }

  Widget sectionButton({
    VoidCallback onPressed,
    String text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: UnderlinedButton(
        onTap: onPressed,
        underlineColor:
            Theme.of(context).textTheme.bodyText1.color.withOpacity(0.8),
        child: Opacity(
          opacity: 0.8,
          child: Text(
            text,
            style: FontsUtils.mainStyle(
              color: Theme.of(context).textTheme.bodyText1.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget sectionsPopupMenu() {
    return PopupMenuButton(
      child: Text(
        "sections".toUpperCase(),
        style: FontsUtils.mainStyle(
          color: Colors.black,
          fontSize: 18.0,
        ),
      ),
      itemBuilder: (context) => <PopupMenuItem<String>>[
        PopupMenuItem(
          value: PostsLocation.route,
          child: ListTile(
            leading: Icon(UniconsLine.newspaper),
            title: Text("posts".tr()),
          ),
        ),
        PopupMenuItem(
          value: ProjectsLocation.route,
          child: ListTile(
            leading: Icon(UniconsLine.apps),
            title: Text("projects".tr()),
          ),
        ),
        PopupMenuItem(
          value: SettingsLocation.route,
          child: ListTile(
            leading: Icon(UniconsLine.setting),
            title: Text("settings".tr()),
          ),
        ),
      ],
      onSelected: (String uri) {
        if (uri != SettingsLocation.route) {
          Beamer.of(context).beamToNamed(uri);
          return;
        }

        if (stateUser.isUserConnected) {
          Beamer.of(context)
              .beamToNamed(DashboardLocationContent.settingsRoute);
          return;
        }

        Beamer.of(context).beamToNamed(SettingsLocation.route);
      },
    );
  }

  Widget sectionsRow(bool isNarrow) {
    if (isNarrow) {
      return mobileSectionsRow();
    }

    return desktopSectionsRow();
  }

  Widget userSpace(bool isNarrow) {
    if (stateUser.isUserConnected) {
      return authenticatedMenu(isNarrow);
    }

    return guestRow(isNarrow);
  }
}
