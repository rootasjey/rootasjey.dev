import 'package:beamer/beamer.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/application_bar/search_button.dart';
import 'package:rootasjey/router/locations/dashboard_location.dart';
import 'package:rootasjey/router/locations/posts_location.dart';
import 'package:rootasjey/router/locations/projects_location.dart';
import 'package:rootasjey/router/locations/settings_location.dart';
import 'package:rootasjey/state/user.dart';
import 'package:rootasjey/types/button_data.dart';
import 'package:rootasjey/utils/fonts.dart';
import 'package:unicons/unicons.dart';

class MainSectionMobile extends StatelessWidget {
  const MainSectionMobile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 24.0),
          child: PopupMenuButton<String>(
            child: Text(
              "sections".toUpperCase(),
              style: FontsUtils.mainStyle(
                color: Colors.black,
                fontSize: 18.0,
              ),
            ),
            onSelected: (String routePath) => onSelected(context, routePath),
            itemBuilder: (BuildContext context) => getData()
                .map(
                  (buttonData) => PopupMenuItem(
                    value: buttonData.routePath,
                    child: ListTile(
                      leading: Icon(buttonData.iconData),
                      title: Text(
                        buttonData.textValue,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        SearchButton(),
      ],
    );
  }

  /// Return buttons' data.
  List<ButtonData> getData() {
    return [
      ButtonData(
        iconData: UniconsLine.newspaper,
        textValue: "projects".tr().toUpperCase(),
        routePath: ProjectsLocation.route,
      ),
      ButtonData(
        iconData: UniconsLine.apps,
        textValue: "posts".tr().toUpperCase(),
        routePath: PostsLocation.route,
      ),
      ButtonData(
        iconData: UniconsLine.setting,
        textValue: "settings".tr().toUpperCase(),
        routePath: SettingsLocation.route,
      ),
    ];
  }

  void onSelected(BuildContext context, String routePath) {
    if (routePath != SettingsLocation.route) {
      Beamer.of(context).beamToNamed(routePath);
      return;
    }

    if (stateUser.isUserConnected) {
      Beamer.of(context).beamToNamed(DashboardLocationContent.settingsRoute);
      return;
    }

    Beamer.of(context).beamToNamed(SettingsLocation.route);
  }
}
