import 'package:flutter/widgets.dart';

class Skill {
  Skill({
    required this.label,
    this.blend = false,
    this.url = "",
    this.assetPath = "",
    this.iconData,
  });

  final String label;
  final String url;
  final String assetPath;
  final IconData? iconData;
  final bool blend;
}
