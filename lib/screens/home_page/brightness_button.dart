import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:rootasjey/components/buttons/circle_button.dart';
import 'package:rootasjey/globals/utils.dart';
import 'package:super_context_menu/super_context_menu.dart';

class BrightnessButton extends StatefulWidget {
  const BrightnessButton({
    super.key,
    this.margin = EdgeInsets.zero,
    this.backgroundColor,
    this.radius = 20.0,
    this.buttonSize = 24.0,
  });

  /// Button background color.
  final Color? backgroundColor;

  /// Button radius.
  final double radius;

  /// Button size.
  final double buttonSize;

  /// Space around this widget.
  final EdgeInsetsGeometry margin;

  @override
  State<BrightnessButton> createState() => _BrightnessButtonState();
}

class _BrightnessButtonState extends State<BrightnessButton> {
  double _target = 1.0;
  final double _endTarget = 0.8;

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
        preferredDirection: AxisDirection.left,
        tooltipString: getTooltipString(mode),
        child: ContextMenuWidget(
          menuProvider: (request) {
            return Menu(
              children: [
                MenuAction(
                  callback: () {
                    AdaptiveTheme.of(context).setSystem();
                  },
                  title: "System theme",
                ),
              ],
            );
          },
          child: CircleButton(
            radius: widget.radius,
            backgroundColor: widget.backgroundColor ?? Colors.black12,
            onTap: () {
              _target = _target == _endTarget ? 1.0 : _endTarget;
              AdaptiveTheme.of(context).toggleThemeMode(
                useSystem: false,
              );
            },
            icon: Icon(
              iconData,
              color: Colors.black,
              size: widget.buttonSize,
            ),
          )
              .animate(
                target: _target,
              )
              .rotate(
                duration: const Duration(milliseconds: 1000),
                begin: -6.0,
                end: 0.0,
                curve: Curves.easeOut,
              )
              .scaleXY(
                duration: const Duration(milliseconds: 500),
                begin: 0.4,
                end: 1.0,
                curve: Curves.easeInOut,
              ),
        ),
      ),
    );
  }

  getTooltipString(AdaptiveThemeMode mode) {
    switch (mode) {
      case AdaptiveThemeMode.system:
        return "Current theme: System → Next: Light";
      case AdaptiveThemeMode.light:
        return "Current theme: Light → Next: Dark";
      case AdaptiveThemeMode.dark:
        return "Current theme: Dark → Next: Light";
      default:
        return "Current theme: Unknown | Next: Unknown";
    }
  }
}
