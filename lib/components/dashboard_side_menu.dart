import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/side_menu_item.dart';
import 'package:rootasjey/components/underlined_button.dart';
import 'package:rootasjey/router/locations/dashboard_location.dart';
import 'package:rootasjey/router/locations/home_location.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/utils/constants.dart';
import 'package:rootasjey/utils/fonts.dart';
import 'package:supercharged/supercharged.dart';
import 'package:unicons/unicons.dart';

/// User's dashboard side menu.
class DashboardSideMenu extends StatefulWidget {
  const DashboardSideMenu({
    Key key,
    @required this.beamerKey,
  }) : super(key: key);

  final GlobalKey<BeamerState> beamerKey;

  @override
  _DashboardSideMenuState createState() => _DashboardSideMenuState();
}

class _DashboardSideMenuState extends State<DashboardSideMenu> {
  BeamerDelegate _beamerDelegate;

  /// True if the side menu is expanded showing icons and labels.
  /// If false, the side menu shows only icon.
  /// Default to true.
  bool _isExpanded = true;

  final _sidePanelItems = <SideMenuItem>[
    SideMenuItem(
      iconData: UniconsLine.chart_pie,
      label: "statistics".tr(),
      hoverColor: stateColors.activity,
      routePath: DashboardLocationContent.statisticsRoute,
    ),
    SideMenuItem(
      iconData: UniconsLine.picture,
      label: "posts".tr(),
      hoverColor: stateColors.posts,
      routePath: DashboardLocationContent.postsRoute,
    ),
    SideMenuItem(
      iconData: UniconsLine.book_alt,
      label: "projects".tr(),
      hoverColor: stateColors.projects,
      routePath: DashboardLocationContent.projectsRoute,
    ),
    SideMenuItem(
      iconData: UniconsLine.book_alt,
      label: "profile".tr(),
      hoverColor: stateColors.profile,
      routePath: DashboardLocationContent.profileRoute,
    ),
    SideMenuItem(
      iconData: UniconsLine.setting,
      label: "settings".tr(),
      hoverColor: stateColors.settings,
      routePath: DashboardLocationContent.settingsRoute,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _addAdminMenuItems();

    // _isExpanded = appStorage.getDashboardSideMenuExpanded();
    _isExpanded = true;

    // NOTE: Beamer state isn't ready on 1st frame
    // probably because [SidePanelMenu] appears before the Beamer widget.
    // So we use [addPostFrameCallback] to access the state in the next frame.
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (widget.beamerKey.currentState != null) {
        _beamerDelegate = widget.beamerKey.currentState.routerDelegate;
        _beamerDelegate.addListener(_setStateListener);
      }
    });
  }

  @override
  void dispose() {
    _beamerDelegate.removeListener(_setStateListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width < Constants.maxMobileWidth) {
      return Container();
    }

    return Material(
      color: stateColors.lightBackground,
      child: AnimatedContainer(
        duration: 500.milliseconds,
        curve: Curves.easeOutExpo,
        width: _isExpanded ? 300.0 : 70.0,
        child: Stack(
          children: [
            OverflowBox(
              minWidth: 40.0,
              maxWidth: 300.0,
              alignment: Alignment.topLeft,
              child: CustomScrollView(
                slivers: <Widget>[
                  topSidePanel(),
                  bodySidePanel(),
                ],
              ),
            ),
            toggleExpandButton(),
          ],
        ),
      ),
    );
  }

  Widget bodySidePanel() {
    return SliverPadding(
      padding: EdgeInsets.only(
        left: _isExpanded ? 20.0 : 16.0,
        right: 20.0,
      ),
      sliver: SliverList(
          delegate: SliverChildListDelegate.fixed(
        _sidePanelItems.map((sidePanelItem) {
          Color color = stateColors.foreground.withOpacity(0.6);
          Color textColor = stateColors.foreground.withOpacity(0.4);
          FontWeight fontWeight = FontWeight.w600;

          final bool isCurrentItemSelected = context
              .currentBeamLocation.pathPatterns
              .contains(sidePanelItem.routePath);

          if (isCurrentItemSelected) {
            color = sidePanelItem.hoverColor;
            textColor = stateColors.foreground.withOpacity(0.6);
            fontWeight = FontWeight.w700;
          }

          return Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(
                left: _isExpanded ? 24.0 : 0.0,
                top: 32.0,
              ),
              child: UnderlinedButton(
                compact: !_isExpanded,
                tooltip: sidePanelItem.label,
                hoverColor: Colors.transparent,
                leading: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(
                    sidePanelItem.iconData,
                    color: color,
                  ),
                ),
                child: Text(
                  sidePanelItem.label,
                  style: FontsUtils.mainStyle(
                    color: textColor,
                    fontSize: 16.0,
                    fontWeight: fontWeight,
                  ),
                ),
                onTap: () {
                  context.beamToNamed(sidePanelItem.routePath);
                  setState(() {});
                },
              ),
            ),
          );
        }).toList(),
      )),
    );
  }

  Widget toggleExpandButton() {
    return Positioned(
      bottom: 24.0,
      left: _isExpanded ? 32.0 : 16.0,
      child: Opacity(
        opacity: 0.6,
        child: IconButton(
          tooltip: _isExpanded ? "collapse".tr() : "expand".tr(),
          icon: _isExpanded
              ? Icon(UniconsLine.left_arrow_from_left)
              : Icon(UniconsLine.arrow_from_right),
          onPressed: _toggleSideMenu,
        ),
      ),
    );
  }

  Widget topSidePanel() {
    return SliverPadding(
      padding: EdgeInsets.only(
        top: 40.0,
        bottom: 50.0,
        left: _isExpanded ? 0.0 : 16.0,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate.fixed([
          Column(
            crossAxisAlignment: _isExpanded
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              IconButton(
                tooltip: "home".tr(),
                onPressed: () {
                  Beamer.of(context, root: true).beamToNamed(
                    HomeLocation.route,
                  );
                },
                icon: Opacity(
                  opacity: 0.6,
                  child: Icon(UniconsLine.home),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  void _addAdminMenuItems() async {
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

  void _setStateListener() => setState(() {});

  void _toggleSideMenu() {
    setState(() {
      _isExpanded = !_isExpanded;
      // appStorage.setDashboardSideMenuExpanded(_isExpanded);
    });
  }
}
