import 'package:beamer/beamer.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/application_bar/search_button.dart';
import 'package:rootasjey/components/underlined_button.dart';
import 'package:rootasjey/router/locations/dashboard_location.dart';
import 'package:rootasjey/router/locations/posts_location.dart';
import 'package:rootasjey/router/locations/projects_location.dart';
import 'package:rootasjey/router/locations/settings_location.dart';
import 'package:rootasjey/state/user.dart';
import 'package:rootasjey/types/button_data.dart';
import 'package:rootasjey/utils/fonts.dart';

/// AppBar main section displayed for desktops.
class MainSectionDesktop extends StatelessWidget {
  const MainSectionDesktop({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bodyTextColor = Theme.of(context).textTheme.bodyText1.color;
    final underlineColor = bodyTextColor.withOpacity(0.8);

    return Wrap(
      spacing: 12.0,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ...getData().map(
          (buttonData) => UnderlinedButton(
            onTap: () => onTap(context, buttonData.routePath),
            underlineColor: underlineColor,
            child: Opacity(
              opacity: 0.8,
              child: Text(
                buttonData.textValue,
                style: FontsUtils.mainStyle(
                  color: bodyTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
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
        textValue: "projects".tr().toUpperCase(),
        routePath: ProjectsLocation.route,
      ),
      ButtonData(
        textValue: "posts".tr().toUpperCase(),
        routePath: PostsLocation.route,
      ),
      ButtonData(
        textValue: "settings".tr().toUpperCase(),
        routePath: SettingsLocation.route,
      ),
    ];
  }

  void navigateToSettings(BuildContext context) {
    if (stateUser.isUserConnected) {
      Beamer.of(context).beamToNamed(DashboardLocationContent.settingsRoute);
      return;
    }

    Beamer.of(context).beamToNamed(SettingsLocation.route);
  }

  void onTap(BuildContext context, String routePath) {
    if (routePath == SettingsLocation.route) {
      navigateToSettings(context);
      return;
    }

    Beamer.of(context).beamToNamed(routePath);
  }
}
