import 'package:flutter/material.dart';

class SideMenuItem {
  final int index;
  final IconData iconData;
  final String label;
  final Color hoverColor;

  const SideMenuItem({
    @required this.index,
    @required this.iconData,
    @required this.label,
    @required this.hoverColor,
  });
}
