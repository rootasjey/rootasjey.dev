import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:rootasjey/actions/users.dart';
import 'package:rootasjey/components/app_icon_header.dart';
import 'package:rootasjey/rooter/route_names.dart';
import 'package:rootasjey/rooter/router.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/state/user_state.dart';

class HomeAppBar extends StatefulWidget {
  final bool automaticallyImplyLeading;
  final Function onTapIconHeader;
  final String title;

  HomeAppBar({
    this.automaticallyImplyLeading = false,
    this.onTapIconHeader,
    this.title = '',
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
                      size: 40.0,
                      padding: EdgeInsets.zero,
                      onTap: widget.onTapIconHeader,
                    ),

                    if (widget.title.isNotEmpty)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 40.0),
                          child: Tooltip(
                            message: widget.title,
                            child: Opacity(
                              opacity: 0.6,
                              child: Text(
                                widget.title,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: stateColors.foreground,
                                ),
                              ),
                            ),
                          ),
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
      onPressed: () {
      },
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
              // fontSize: 12.0,
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
        // tooltip: 'More quick links',
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
              value: AddPostRoute,
              child: ListTile(
                leading: Icon(Icons.add),
                title: Text(
                  'Add quote',
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ),
              )
            ),

          const PopupMenuItem(
            value: SearchRoute,
            child: ListTile(
              leading: Icon(Icons.search),
              title: Text(
                'Search',
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
            )
          ),

          const PopupMenuItem(
            value: DraftsRoute,
            child: ListTile(
              leading: Icon(Icons.edit),
              title: Text(
                'Drafts',
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),

          const PopupMenuItem(
            value: PublishedPostsRoute,
            child: ListTile(
              leading: Icon(Icons.cloud_done),
              title: Text(
                'Published',
                style: TextStyle(
                  fontWeight: FontWeight.bold
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
                  fontWeight: FontWeight.bold
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
                  fontWeight: FontWeight.bold
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
          ? children.add(userAvatar(isNarrow: isNarrow))
          : children.addAll([
              userAvatar(),
              addNewPostButton(),
              searchButton(),
            ]);

      } else {
        isNarrow
          ? children.add(userSigninMenu())
          : children.addAll([
              searchButton(),
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

  Widget userSigninMenu() {
    return PopupMenuButton(
      itemBuilder: (context) => <PopupMenuEntry<String>>[
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
        PopupMenuItem(
          value: SearchRoute,
          child: ListTile(
            leading: Icon(Icons.search),
            title: Text('Search'),
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
