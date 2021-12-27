import 'package:flutter/material.dart';
import 'package:rootasjey/components/application_bar/lang_button.dart';
import 'package:rootasjey/screens/settings/theme_switcher.dart';

class AppSettings extends StatelessWidget {
  final Brightness brightness;
  final Function(bool) onChangeThemeAuto;
  final Function(bool) onChangeBrightness;
  final String themeDescription;

  const AppSettings({
    Key? key,
    required this.brightness,
    required this.onChangeThemeAuto,
    required this.onChangeBrightness,
    this.themeDescription = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        top: 20.0,
        right: 20.0,
        bottom: 120.0,
      ),
      child: Column(
        children: <Widget>[
          ThemeSwitcher(
            brightness: brightness,
            themeDescription: themeDescription,
            onChangeThemeAuto: onChangeThemeAuto,
            onChangeBrightness: onChangeBrightness,
          ),
          LangButton(),
        ],
      ),
    );
  }
}
