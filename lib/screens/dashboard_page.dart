import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/avatar_menu.dart';
import 'package:rootasjey/components/side_menu_item.dart';
import 'package:rootasjey/router/app_router.gr.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/utils/constants.dart';
import 'package:rootasjey/utils/fonts.dart';
import 'package:unicons/unicons.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _sideMenuItems = <SideMenuItem>[
    SideMenuItem(
      index: 0,
      iconData: UniconsLine.newspaper,
      label: "posts_my".tr(),
      hoverColor: Colors.green,
    ),
    SideMenuItem(
      index: 1,
      iconData: UniconsLine.apps,
      label: "projects_my".tr(),
      hoverColor: Colors.yellow.shade800,
    ),
    SideMenuItem(
      index: 2,
      iconData: UniconsLine.user,
      label: "profile_my".tr(),
      hoverColor: Colors.green,
    ),
    SideMenuItem(
      index: 3,
      iconData: UniconsLine.setting,
      label: 'Settings',
      hoverColor: Colors.blueGrey,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // tryAddAdminPage();
  }

  @override
  Widget build(context) {
    return AutoTabsScaffold(
      routes: const [
        DashPostsRouter(),
        DashProjectsRouter(),
        DashProfileRouter(),
        DashSettingsRouter(),
      ],
      builder: (context, child, animation) {
        return Material(
          child: Row(
            children: [
              buildSidePanel(context, context.tabsRouter),
              Expanded(child: child),
            ],
          ),
        );
      },
    );
  }

  Widget buildSidePanel(BuildContext context, TabsRouter tabsRouter) {
    final double windowWidth = MediaQuery.of(context).size.width;

    if (windowWidth < Constants.maxMobileWidth) {
      return Container();
    }

    return Container(
      foregroundDecoration: BoxDecoration(
        color: Color.fromRGBO(0, 0, 0, 0.05),
      ),
      width: 300.0,
      child: Stack(
        children: <Widget>[
          CustomScrollView(
            slivers: <Widget>[
              SliverPadding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                  bottom: 50.0,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate.fixed([
                    AvatarMenu(),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                ),
                sliver: SliverList(
                    delegate: SliverChildListDelegate.fixed(
                  _sideMenuItems.map((item) {
                    Color color = stateColors.foreground.withOpacity(0.6);
                    Color textColor = stateColors.foreground.withOpacity(0.6);
                    FontWeight fontWeight = FontWeight.w400;

                    if (tabsRouter.activeIndex == item.index) {
                      color = item.hoverColor;
                      textColor = stateColors.foreground;
                      fontWeight = FontWeight.w600;
                    }

                    return ListTile(
                      leading: Icon(
                        item.iconData,
                        color: color,
                      ),
                      title: Text(
                        item.label,
                        style: FontsUtils.mainStyle(
                          color: textColor,
                          fontWeight: fontWeight,
                        ),
                      ),
                      onTap: () {
                        tabsRouter.setActiveIndex(item.index);
                      },
                    );
                  }).toList(),
                )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void tryAddAdminPage() async {
    // if (!stateUser.canManageQuotes) {
    //   return;
    // }

    // _sideMenuItems.addAll([
    //   SideMenuItem(
    //     destination: AdminDeepRoute(
    //       children: [
    //         AdminTempDeepRoute(
    //           children: [
    //             AdminTempQuotesRoute(),
    //           ],
    //         )
    //       ],
    //     ),
    //     iconData: UniconsLine.clock_two,
    //     label: 'Admin Temp Quotes',
    //     hoverColor: Colors.red,
    //   ),
    //   SideMenuItem(
    //     destination: AdminDeepRoute(children: [QuotidiansRoute()]),
    //     iconData: UniconsLine.sunset,
    //     label: 'Quotidians',
    //     hoverColor: Colors.red,
    //   ),
    // ]);
  }
}
