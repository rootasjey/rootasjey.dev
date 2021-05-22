import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:rootasjey/components/app_icon.dart';
import 'package:rootasjey/components/avatar_menu.dart';
import 'package:rootasjey/components/lang_popup_menu_button.dart';
import 'package:rootasjey/router/app_router.gr.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/state/user.dart';
import 'package:rootasjey/utils/app_storage.dart';
import 'package:rootasjey/utils/brightness.dart';
import 'package:rootasjey/utils/fonts.dart';
import 'package:unicons/unicons.dart';

class MainAppBar extends StatefulWidget {
  MainAppBar();

  @override
  _MainAppBarState createState() => _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar> {
  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constrains) {
        final isNarrow = constrains.crossAxisExtent < 700.0;
        final leftPadding = isNarrow ? 0.0 : 80.0;

        return Observer(
          builder: (context) {
            return SliverAppBar(
              floating: true,
              snap: true,
              pinned: true,
              backgroundColor: stateColors.newLightBackground,
              automaticallyImplyLeading: false,
              title: Padding(
                padding: EdgeInsets.only(
                  left: leftPadding,
                ),
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
          },
        );
      },
    );
  }

  Widget addNewPostButton() {
    return PopupMenuButton(
      tooltip: "new".tr(),
      icon: Icon(
        UniconsLine.plus,
        color: stateColors.foreground.withOpacity(0.6),
      ),
      onSelected: (PageRouteInfo pageRouteInfo) {
        context.router.root.push(pageRouteInfo);
      },
      itemBuilder: (_) => <PopupMenuEntry<PageRouteInfo>>[
        PopupMenuItem(
          value: DashboardPageRoute(
            children: [
              DashPostsRouter(
                children: [
                  NewPostPageRoute(),
                ],
              ),
            ],
          ),
          child: ListTile(
            leading: Icon(UniconsLine.newspaper),
            title: Text("post_new".tr()),
          ),
        ),
        PopupMenuItem(
          value: DashboardPageRoute(
            children: [
              DashPostsRouter(
                children: [
                  NewProjectPageRoute(),
                ],
              ),
            ],
          ),
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
          addNewPostButton(),
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

    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: PopupMenuButton<String>(
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

          final brightness =
              value == 'dark' ? Brightness.dark : Brightness.light;

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
      ),
    );
  }

  Widget desktopSectionsRow() {
    return Wrap(
      spacing: 12.0,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        sectionButton(
          onPressed: () {
            context.router.root.push(ProjectsRouter());
          },
          text: "projects".tr().toUpperCase(),
        ),
        sectionButton(
          onPressed: () {
            context.router.root.push(PostsRouter());
          },
          text: "posts".tr().toUpperCase(),
        ),
        sectionButton(
          onPressed: () {
            if (stateUser.isUserConnected) {
              context.router.root.push(
                DashboardPageRoute(
                  children: [DashSettingsRouter()],
                ),
              );
              return;
            }

            context.router.root.push(SettingsPageRoute());
          },
          text: "settings".tr().toUpperCase(),
        ),
        IconButton(
          onPressed: () {
            context.router.root.push(SearchPageRoute());
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
          TextButton(
            onPressed: () {},
            child: Text("Login"),
          ),
          TextButton(
            onPressed: () {},
            child: Text("Register"),
            style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Colors.deepPurple.shade900,
            ),
          ),
        ],
      ),
    );
  }

  Widget langButton() {
    return LangPopupMenuButton(
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
            context.router.root.push(SearchPageRoute());
          },
          color: stateColors.foreground.withOpacity(0.8),
          icon: Icon(UniconsLine.search),
        ),
      ],
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
          onPressed: () {
            context.router.root.push(SearchPageRoute());
          },
          tooltip: "search".tr(),
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
      padding: const EdgeInsets.only(right: 16.0),
      child: Opacity(
        opacity: 0.8,
        child: TextButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: FontsUtils.mainStyle(
              color: stateColors.foreground,
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
      itemBuilder: (context) => <PopupMenuItem<PageRouteInfo>>[
        PopupMenuItem(
          value: PostsRouter(),
          child: ListTile(
            leading: Icon(UniconsLine.newspaper),
            title: Text("posts".tr()),
          ),
        ),
        PopupMenuItem(
          value: ProjectsRouter(),
          child: ListTile(
            leading: Icon(UniconsLine.apps),
            title: Text("projects".tr()),
          ),
        ),
        PopupMenuItem(
          value: SettingsPageRoute(),
          child: ListTile(
            leading: Icon(UniconsLine.setting),
            title: Text("settings".tr()),
          ),
        ),
      ],
      onSelected: (PageRouteInfo pageRouteInfo) {
        if (pageRouteInfo.path != SettingsPageRoute().path) {
          context.router.root.push(pageRouteInfo);
          return;
        }

        if (stateUser.isUserConnected) {
          context.router.root.push(
            DashboardPageRoute(
              children: [DashSettingsRouter()],
            ),
          );

          return;
        }

        context.router.root.push(pageRouteInfo);
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
