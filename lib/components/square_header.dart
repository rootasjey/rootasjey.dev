import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/globals/utils.dart';
import 'package:timelines/timelines.dart';

class SquareHeader extends StatelessWidget {
  /// A header to display on top of a square screen.
  /// Contains app logo and a back button.
  const SquareHeader({
    super.key,
    this.margin = EdgeInsets.zero,
    this.onGoBack,
    this.onGoHome,
  });

  /// Spacing outside of this widget.
  final EdgeInsets margin;

  /// Called when the user goes back.
  final void Function()? onGoBack;

  /// Called when the user goes back to the home page.
  final void Function()? onGoHome;

  @override
  Widget build(BuildContext context) {
    final Color? foregroundColor =
        Theme.of(context).textTheme.bodyMedium?.color;
    final Color iconColor = foregroundColor?.withOpacity(0.2) ?? Colors.black54;

    return Container(
      padding: margin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Utils.graphic.tooltip(
            tooltipString: "home".tr(),
            child: IconButton(
              onPressed: onGoHome,
              color: iconColor,
              icon: const Icon(TablerIcons.home),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DotIndicator(
              size: 6.0,
              color: Constants.colors.getRandomFromPalette(),
            ),
          ),
          // const DotSeparator(),
          Utils.graphic.tooltip(
            tooltipString: "back".tr(),
            child: IconButton(
              onPressed: onGoBack,
              color: iconColor,
              icon: const Icon(TablerIcons.arrow_back),
            ),
          ),
        ],
      ),
    );
  }
}
