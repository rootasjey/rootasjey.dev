import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:rootasjey/globals/utils.dart';

class BrightnessButton extends StatefulWidget {
  const BrightnessButton({
    super.key,
    this.margin = EdgeInsets.zero,
  });

  final EdgeInsetsGeometry margin;

  @override
  State<BrightnessButton> createState() => _BrightnessButtonState();
}

class _BrightnessButtonState extends State<BrightnessButton> {
  @override
  Widget build(BuildContext context) {
    final mode = AdaptiveTheme.of(context).mode;

    IconData iconData = TablerIcons.sun;
    if (mode == AdaptiveThemeMode.dark) {
      iconData = TablerIcons.moon;
    }
    if (mode == AdaptiveThemeMode.system) {
      iconData = TablerIcons.brightness_half;
    }

    return Padding(
      padding: widget.margin,
      child: Utils.graphic.tooltip(
        tooltipString: getTooltipString(mode),
        child: IconButton(
          onPressed: () {
            AdaptiveTheme.of(context).toggleThemeMode();
          },
          icon: Icon(
            iconData,
          ),
        ),
      ),
    );
  }

  getTooltipString(AdaptiveThemeMode mode) {
    switch (mode) {
      case AdaptiveThemeMode.system:
        return "Current theme: System | Next: Light";
      case AdaptiveThemeMode.light:
        return "Current theme: Light | Next: Dark";
      case AdaptiveThemeMode.dark:
        return "Current theme: Dark | Next: System";
      default:
        return "Current theme: Unknown | Next: Unknown";
    }
  }
}
