import 'package:flutter/material.dart';
import 'package:rootasjey/screens/home.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/utils/app_local_storage.dart';
import 'package:rootasjey/utils/brightness.dart';
import 'package:supercharged/supercharged.dart';

class MainWeb extends StatefulWidget {
  @override
  _MainWebState createState() => _MainWebState();
}

class _MainWebState extends State<MainWeb> {
  @override
  initState() {
    super.initState();
    loadBrightness();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'rootasjey',
      theme: stateColors.themeData,
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }

  void loadBrightness() {
    final autoBrightness = appLocalStorage.getAutoBrightness();

    if (!autoBrightness) {
      final brightness = appLocalStorage.getBrightness();

      setBrightness(
        brightness: brightness,
        context: context,
        duration: 500.milliseconds,
      );

      return;
    }

    setAutoBrightness(
      context: context,
      duration: 500.milliseconds,
    );
  }
}
