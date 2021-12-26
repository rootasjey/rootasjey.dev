import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/fade_in_y.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/utils/fonts.dart';
import 'package:supercharged_dart/supercharged_dart.dart';

class ThemeSwitcher extends StatelessWidget {
  final bool isThemeAuto;
  final String themeDescription;
  final Function(bool) onChangeThemeAuto;
  final Brightness brightness;
  final Function(bool) onChangeBrightness;

  const ThemeSwitcher({
    Key? key,
    this.isThemeAuto = true,
    this.themeDescription = '',
    required this.brightness,
    required this.onChangeThemeAuto,
    required this.onChangeBrightness,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400.0,
      padding: EdgeInsets.only(
        bottom: 60.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FadeInY(
            delay: 0.milliseconds,
            beginY: 10.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: <Widget>[
                  Text(
                    "theme".tr(),
                    style: FontsUtils.mainStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: stateColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          FadeInY(
            delay: 100.milliseconds,
            beginY: 10.0,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Opacity(
                opacity: 0.6,
                child: Text(
                  themeDescription,
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
          ),
          FadeInY(
            delay: 200.milliseconds,
            beginY: 10.0,
            child: SwitchListTile(
              title: Text("theme_automatic".tr()),
              secondary: const Icon(Icons.autorenew),
              value: isThemeAuto,
              onChanged: onChangeThemeAuto,
            ),
          ),
          if (!isThemeAuto)
            FadeInY(
              delay: 0.milliseconds,
              beginY: 10.0,
              child: SwitchListTile(
                title: Text("light".tr()),
                secondary: const Icon(Icons.lightbulb_outline),
                value: brightness == Brightness.light,
                onChanged: onChangeBrightness,
              ),
            ),
        ],
      ),
    );
  }
}
