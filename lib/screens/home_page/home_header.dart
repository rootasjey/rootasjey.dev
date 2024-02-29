import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:rootasjey/components/icons/app_icon.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/globals/utils.dart';
import 'package:rootasjey/screens/home_page/brightness_button.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    this.isDark = false,
    this.accentColor = Colors.blue,
    this.margin = EdgeInsets.zero,
    this.onShuffleColor,
    this.onTapHireMeButton,
  });

  /// True if the app is in dark mode.
  final bool isDark;

  /// Accent color for border and title.
  final Color accentColor;

  /// Space around this widget.
  final EdgeInsetsGeometry margin;

  /// Callback called when the user clicks on the shuffle color button.
  final void Function()? onShuffleColor;

  /// Callback called when the user clicks on the hire me button.
  final void Function()? onTapHireMeButton;

  @override
  Widget build(BuildContext context) {
    final Color? foregroundColor =
        Theme.of(context).textTheme.bodyMedium?.color;

    return Padding(
      padding: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const AppIcon(size: 32.0),
              const BrightnessButton(
                margin: EdgeInsets.only(left: 8.0),
              ),
              Utils.graphic.tooltip(
                tooltipString: "Shuffle color",
                child: IconButton(
                  onPressed: onShuffleColor,
                  icon: const Icon(
                    TablerIcons.color_swatch,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: ElevatedButton(
                  onPressed: onTapHireMeButton,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: accentColor,
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      side: BorderSide(
                        width: 2.0,
                        color: accentColor,
                      ),
                    ),
                  ),
                  child: const Text("Hire me!"),
                ),
              ),
            ],
          ),
          Text(
            Constants.appName,
            style: Utils.calligraphy.body(
              textStyle: TextStyle(
                fontSize: 112.0,
                fontWeight: FontWeight.w800,
                height: 1.0,
                color: isDark ? accentColor : foregroundColor,
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Welcome to my tiny art universe.",
                style: Utils.calligraphy.body2(
                  textStyle: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600,
                    color: foregroundColor?.withOpacity(0.8),
                  ),
                ),
              ),
              Text(
                " I like to build stuff.",
                style: Utils.calligraphy.body2(
                  textStyle: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600,
                    color: foregroundColor?.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
