import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class UIUtilities {
  const UIUtilities();

  /// Color filter to greyed out widget.
  final ColorFilter greyColorFilter = const ColorFilter.matrix(<double>[
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ]);

  /// Starting delay for fade in y animmation.
  static int _delay = 0;

  /// Amount to add to delay for the next widget to animate.
  final int _step = 25;

  /// Show a dialog or a modal bottom sheet according to `isMobileSize` value.
  void showAdaptiveDialog(
    BuildContext context, {
    required Widget Function(BuildContext) builder,
    bool isMobileSize = false,
    Color backgroundColor = Colors.white,
  }) {
    if (isMobileSize) {
      showCupertinoModalBottomSheet(
        context: context,
        expand: false,
        backgroundColor: backgroundColor,
        builder: builder,
      );
      return;
    }

    showDialog(
      context: context,
      builder: builder,
    );
  }

  /// Where to start the fade in Y animation.
  double getBeginY() {
    return 60.0;
  }

  int getNextAnimationDelay({String animationName = "", bool reset = false}) {
    if (reset) {
      _delay = 0;
    }

    final int prevDelay = _delay;
    _delay += _step;
    return prevDelay;
  }
}
