import 'package:flutter/widgets.dart';

class Skill {
  final String label;
  final String url;
  final String assetPath;
  final IconData iconData;
  final bool blend;

  Skill({
    @required this.label,
    this.blend = false,
    this.url = '',
    this.assetPath = '',
    this.iconData,
  });
}
