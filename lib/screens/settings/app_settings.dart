import 'package:flutter/material.dart';
import 'package:rootasjey/components/application_bar/lang_button.dart';
import 'package:rootasjey/screens/settings/theme_switcher.dart';

class AppSettings extends StatelessWidget {
  final Brightness brightness;
  final Function(bool) onChangeThemeAuto;
  final Function(bool) onChangeBrightness;

  const AppSettings({
    Key? key,
    required this.brightness,
    required this.onChangeThemeAuto,
    required this.onChangeBrightness,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          ThemeSwitcher(
            brightness: brightness,
            onChangeThemeAuto: onChangeThemeAuto,
            onChangeBrightness: onChangeBrightness,
          ),
          LangButton(),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 100.0,
            ),
          ),
        ],
      ),
    );
  }
}
