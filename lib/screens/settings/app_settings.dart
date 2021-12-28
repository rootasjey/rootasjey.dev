import 'package:flutter/material.dart';
import 'package:rootasjey/components/application_bar/brightness_button.dart';
import 'package:rootasjey/components/application_bar/lang_button.dart';

class AppSettings extends StatelessWidget {
  const AppSettings({
    Key? key,
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
          BrightnessButton(),
          LangButton(),
        ],
      ),
    );
  }
}
