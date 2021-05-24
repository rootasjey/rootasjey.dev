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
import 'package:unicons/unicons.dart';

class HomeAppBar extends StatefulWidget {
  final bool automaticallyImplyLeading;
  final bool showAppIcon;
  final Function onTapIconHeader;
  final Widget title;
  final String textTitle;
  final List<Widget> trailing;

  HomeAppBar({
    this.automaticallyImplyLeading = false,
    this.onTapIconHeader,
    this.title,
    this.trailing = const [],
    this.showAppIcon = true,
    this.textTitle,
  });

  @override
  _HomeAppBarState createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constrains) {
        final isNarrow = constrains.crossAxisExtent < 700.0;
        final leftPadding = isNarrow ? 0.0 : 80.0;

        return Observer(
          builder: (context) {
            final bool showNavBack = widget.automaticallyImplyLeading &&
                context.router.root.stack.length > 1;

            return SliverAppBar(
              floating: true,
              snap: true,
              pinned: true,
              automaticallyImplyLeading: false,
              title: Padding(
                padding: EdgeInsets.only(
                  left: leftPadding,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Wrap(
                      children: [
                        if (showNavBack)
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: IconButton(
                              color: stateColors.foreground,
                              onPressed: context.router.pop,
                              icon: Icon(UniconsLine.arrow_left),
                            ),
                          ),
                        if (widget.showAppIcon)
                          AppIcon(
                            onTap: widget.onTapIconHeader,
                          ),
                      ],
                    ),
                    getTitleWidget(),
                    userSection(isNarrow),
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
    return ElevatedButton(
      onPressed: () {
        context.router.root.push(
          DashboardPageRoute(
            children: [
              DashPostsRouter(
                children: [
                  NewPostPageRoute(),
                ],
              ),
            ],
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        primary: stateColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30.0),
          ),
        ),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(UniconsLine.plus, color: Colors.white),
          ),
          Text(
            'New Post',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
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
          AvatarMenu(isSmall: isSmall),
          if (!isSmall) addNewPostButton(),
          searchButton(),
          brightnessButton(),
          if (!isSmall) langButton(),
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

  Widget getTitleWidget() {
    Widget title;

    if (widget.textTitle != null) {
      title = Opacity(
        opacity: 0.6,
        child: Text(
          widget.textTitle,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: stateColors.foreground,
          ),
        ),
      );
    }

    if (widget.title != null) {
      title = widget.title;
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 40.0),
        child: title,
      ),
    );
  }

  Widget guestMenu(bool isNarrow) {
    return Container(
      padding: const EdgeInsets.only(
        top: 5.0,
        right: 10.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          userSigninMenu(),
          searchButton(),
          ...widget.trailing,
          brightnessButton(),
          if (!isNarrow) langButton(),
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

  Widget userSection(bool isNarrow) {
    if (stateUser.isUserConnected) {
      return authenticatedMenu(isNarrow);
    }

    return guestMenu(isNarrow);
  }

  Widget userSigninMenu({bool showSearch = false}) {
    return PopupMenuButton(
      icon: Icon(UniconsLine.ellipsis_v, color: stateColors.foreground),
      itemBuilder: (context) => <PopupMenuEntry<PageRouteInfo>>[
        if (showSearch)
          PopupMenuItem(
            value: SearchPageRoute(),
            child: ListTile(
              leading: Icon(UniconsLine.search),
              title: Text("search".tr()),
            ),
          ),
        PopupMenuItem(
          value: SigninPageRoute(),
          child: ListTile(
            leading: Icon(UniconsLine.signout),
            title: Text("signin".tr()),
          ),
        ),
        PopupMenuItem(
          value: SignupPageRoute(),
          child: ListTile(
            leading: Icon(UniconsLine.user_plus),
            title: Text("signup".tr()),
          ),
        ),
      ],
      onSelected: (routeInfo) {
        context.router.push(routeInfo);
      },
    );
  }
}
