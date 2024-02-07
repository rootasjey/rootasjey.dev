import 'package:flutter/material.dart';

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

  /// Show a dialog or a modal bottom sheet according to `isMobileSize` value.
  void showAdaptiveDialog(
    BuildContext context, {
    required Widget Function(BuildContext) builder,
    bool isMobileSize = false,
    Color backgroundColor = Colors.white,
  }) {
    if (isMobileSize) {
      showBottomSheet(
        context: context,
        enableDrag: true,
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
}
