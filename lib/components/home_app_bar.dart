import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:rootasjey/actions/users.dart';
import 'package:rootasjey/components/app_icon_header.dart';
import 'package:rootasjey/rooter/route_names.dart';
import 'package:rootasjey/rooter/router.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/state/user_state.dart';
import 'package:rootasjey/utils/app_local_storage.dart';
import 'package:rootasjey/utils/brightness.dart';

class HomeAppBar extends StatefulWidget {
  final bool automaticallyImplyLeading;
  final Function onTapIconHeader;
  final Widget title;
  final VoidCallback onPressedRightButton;

  HomeAppBar({
    this.automaticallyImplyLeading = false,
    this.onTapIconHeader,
    this.title,
    this.onPressedRightButton,
  });

  @override
  _HomeAppBarState createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return SliverLayoutBuilder(
          builder: (context, constrains) {
            final isNarrow = constrains.crossAxisExtent < 700.0;
            final leftPadding = isNarrow
              ? 0.0
              : 80.0;

            return SliverAppBar(
              floating: true,
              snap: true,
              pinned: true,
              backgroundColor: stateColors.appBackground.withOpacity(1.0),
              automaticallyImplyLeading: false,
              title: Padding(
                padding: EdgeInsets.only(
                  left: leftPadding,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    if (widget.automaticallyImplyLeading)
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: IconButton(
                          color: stateColors.foreground,
                          onPressed: () => FluroRouter.router.pop(context),
                          icon: Icon(Icons.arrow_back),
                        ),
                      ),

                    AppIconHeader(
                      padding: const EdgeInsets.only(
                        bottom: 8.0,
                      ),
                      onTap: widget.onTapIconHeader,
                    ),

                    if (widget.title != null)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 40.0),
                          child: widget.title,
                        ),
                      ),

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
    return RaisedButton(
      onPressed: () => FluroRouter.router.navigateTo(context, NewPostRoute),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(30.0),
        ),
      ),
      color: stateColors.primary,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(Icons.add, color: Colors.white),
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

  Widget searchButton() {
    return IconButton(
      onPressed: () {
        FluroRouter.router.navigateTo(
          context,
          SearchRoute,
        );
      },
      color: stateColors.foreground,
      icon: Icon(Icons.search),
    );
  }

  /// Switch from dark to light and vice-versa.
  Widget themeButton() {
    IconData iconBrightness = Icons.brightness_auto;
    final autoBrightness = appLocalStorage.getAutoBrightness();

    if (!autoBrightness) {
      final currentBrightness = appLocalStorage.getBrightness();

      iconBrightness = currentBrightness == Brightness.dark
        ? Icons.brightness_2
        : Icons.brightness_low;
    }

    return PopupMenuButton<String>(
      icon: Icon(iconBrightness, color: stateColors.foreground,),
      tooltip: 'Brightness',
      onSelected: (value) {
        if (value == 'auto') {
          setAutoBrightness(context: context);
          return;
        }

        final brightness = value == 'dark'
          ? Brightness.dark
          : Brightness.light;

        setBrightness(brightness: brightness, context: context);
        DynamicTheme.of(context).setBrightness(brightness);
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'auto',
          child: ListTile(
            leading: Icon(Icons.brightness_auto),
            title: Text('Auto'),
          ),
        ),

        const PopupMenuItem(
          value: 'dark',
          child: ListTile(
            leading: Icon(Icons.brightness_2),
            title: Text('Dark'),
          ),
        ),

        const PopupMenuItem(
          value: 'light',
          child: ListTile(
            leading: Icon(Icons.brightness_5),
            title: Text('Light'),
          ),
        ),
      ],
    );
  }

  Widget userAvatar({bool isNarrow = true}) {
    final arrStr = userState.username.split(' ');
    String initials = '';

    if (arrStr.length > 0) {
      initials = arrStr.length > 1
        ? arrStr.reduce((value, element) => value + element.substring(1))
        : arrStr.first;

      if (initials != null && initials.isNotEmpty) {
        initials = initials.substring(0, 1);
      }
    }

    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
      ),
      child: PopupMenuButton<String>(
        icon: CircleAvatar(
          backgroundColor: stateColors.primary,
          radius: 20.0,
          child: Text(
            initials,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        onSelected: (value) {
          if (value == 'signout') {
            userSignOut(context: context);
            return;
          }

          FluroRouter.router.navigateTo(
            context,
            value,
          );
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          if (isNarrow)
            const PopupMenuItem(
              value: NewPostRoute,
              child: ListTile(
                leading: Icon(Icons.add),
                title: Text(
                  'New Post',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            ),

          if (isNarrow)
            const PopupMenuItem(
              value: SearchRoute,
              child: ListTile(
                leading: Icon(Icons.search),
                title: Text(
                  'Search',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            ),

          const PopupMenuItem(
            value: NewProjectRoute,
            child: ListTile(
              leading: Icon(Icons.add),
              title: Text(
                'New Project',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          ),

          const PopupMenuItem(
            value: MyPostsRoute,
            child: ListTile(
              leading: Icon(Icons.article),
              title: Text(
                'My Posts',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),

          const PopupMenuItem(
            value: MyProjectsRoute,
            child: ListTile(
              leading: Icon(Icons.apps_outlined),
              title: Text(
                'My Projects',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),

          const PopupMenuItem(
            value: AccountRoute,
            child: ListTile(
              leading: Icon(Icons.settings),
              title: Text(
                'Settings',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),

          const PopupMenuItem(
            value: 'signout',
            child: ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text(
                'Sign out',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget userSection(bool isNarrow) {
    return Observer(builder: (context) {
      final children = List<Widget>();

      if (userState.isUserConnected) {
        isNarrow
          ? children.addAll([
              userAvatar(isNarrow: isNarrow),
              themeButton(),
            ])
          : children.addAll([
              userAvatar(isNarrow: isNarrow),
              addNewPostButton(),
              searchButton(),
              themeButton(),
            ]);

      } else {
        isNarrow
          ? children.addAll([
              userSigninMenu(showSearch: true),
              themeButton(),
            ])
          : children.addAll([
              if (widget.onPressedRightButton != null)
                IconButton(
                  color: stateColors.foreground,
                  icon: Icon(Icons.menu),
                  onPressed: widget.onPressedRightButton,
                ),

              userSigninMenu(),
              searchButton(),
              themeButton(),
            ]);
      }

      return Container(
        padding: const EdgeInsets.only(
          top: 5.0,
          right: 10.0,
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          children: children,
        ),
      );
    });
  }

  Widget userSigninMenu({bool showSearch = false}) {
    return PopupMenuButton(
      icon: Icon(Icons.more_vert, color: stateColors.foreground),
      itemBuilder: (context) => <PopupMenuEntry<String>>[
        if (showSearch)
          PopupMenuItem(
            value: SearchRoute,
            child: ListTile(
              leading: Icon(Icons.search),
              title: Text('Search'),
            ),
          ),

        PopupMenuItem(
          value: SigninRoute,
          child: ListTile(
            leading: Icon(Icons.perm_identity),
            title: Text('Sign in'),
          ),
        ),

        PopupMenuItem(
          value: SignupRoute,
          child: ListTile(
            leading: Icon(Icons.open_in_browser),
            title: Text('Sign up'),
          ),
        ),
      ],
      onSelected: (value) {
        FluroRouter.router.navigateTo(
          context,
          value,
        );
      },
    );
  }
}
