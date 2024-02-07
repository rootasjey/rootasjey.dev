import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:loggy/loggy.dart';
import 'package:rootasjey/globals/utils.dart';
import 'package:rootasjey/types/enums/enum_snackbar_type.dart';

/// Graphic utilities (everything associated with visual and UI).
class Graphic with UiLoggy {
  const Graphic();

  /// Return the color based on the content type.
  Color getSnackbarColorType(SnackbarType type) {
    switch (type) {
      case SnackbarType.info:
        return Colors.blue.shade100;

      case SnackbarType.success:
        return Colors.green.shade100;

      case SnackbarType.error:
        return Colors.red.shade100;

      case SnackbarType.warning:
        return Colors.yellow.shade100;

      default:
        return Colors.blue.shade100;
    }
  }

  /// Get the snackbar width according to the passed text.
  double? getSnackWidth(String str) {
    if (str.isEmpty) {
      return null;
    }

    if (str.length < 10) {
      return 260.0;
    }

    if (str.length < 30) {
      return 310.0;
    }

    if (str.length < 50) {
      return 360.0;
    }

    return null;
  }

  /// Get the snackbar width according to the passed text length.
  double? getSnackWidthFromLength(int length) {
    if (length == 0) {
      return null;
    }

    if (length < 10) {
      return 260.0;
    }

    if (length < 30) {
      return 310.0;
    }

    if (length < 40) {
      return 360.0;
    }

    if (length < 50) {
      return 440.0;
    }

    if (length < 60) {
      return 500.0;
    }

    return null;
  }

  /// Return true if the current platform is Android.
  bool isAndroid() {
    if (kIsWeb) {
      return false;
    }

    return Platform.isAndroid;
  }

  /// Return true if the current platform is mobile (e.g. Android or iOS).
  bool isMobile() {
    if (kIsWeb) {
      return false;
    }

    return Platform.isAndroid || Platform.isIOS;
  }

  /// Show a dialog or a modal bottom sheet according to `isMobileSize` value.
  Future showAdaptiveDialog(
    BuildContext context, {
    required Widget Function(BuildContext) builder,
    bool isMobileSize = false,
    Color backgroundColor = Colors.white,
  }) {
    if (isMobileSize) {
      return showModalBottomSheet(
        context: context,
        builder: builder,
        isDismissible: true,
        isScrollControlled: true,
        useSafeArea: true,
        showDragHandle: true,
        clipBehavior: Clip.hardEdge,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height - 100.0,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.0),
            topRight: Radius.circular(12.0),
          ),
        ),
      );
    }

    return showDialog(
      context: context,
      builder: builder,
    );
  }

  /// Show a snackbar.
  void showSnackbar(
    BuildContext context, {
    required String message,
    Color? backgroundColor,
    SnackbarType type = SnackbarType.error,
    SnackBarBehavior? behavior,
    double? width,
  }) {
    final Color? foregroundColor =
        Theme.of(context).textTheme.bodyMedium?.color;
    final Color defaultBackgroundColor =
        Theme.of(context).dialogBackgroundColor;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Utils.calligraphy.body(
            textStyle: TextStyle(
              fontSize: 14.0,
              color: foregroundColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        width: width,
        elevation: 12.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.0),
          side: BorderSide(color: getSnackbarColorType(type), width: 4.0),
        ),
        backgroundColor: backgroundColor ?? defaultBackgroundColor,
        closeIconColor: foregroundColor?.withOpacity(0.6),
        behavior: behavior,
      ),
    );
  }

  /// Show a snackbar with custom text.
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
      showSnackbarWithCustomText(
    BuildContext context, {
    required Widget text,
    bool showCloseIcon = true,
    ShapeBorder? shape,
    SnackBarBehavior? behavior,
    Duration duration = const Duration(seconds: 4),
    double? width,
  }) {
    final Color? foregroundColor =
        Theme.of(context).textTheme.bodyMedium?.color;
    final Color backgroundColor = Theme.of(context).dialogBackgroundColor;

    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        behavior: behavior,
        closeIconColor: foregroundColor?.withOpacity(0.6),
        content: text,
        duration: duration,
        shape: shape,
        showCloseIcon: showCloseIcon,
        width: width,
      ),
    );
  }

  /// Wrap a widget with a tooltip.
  Widget tooltip({
    required Widget child,
    required String tooltipString,
  }) {
    if (tooltipString.isEmpty) {
      return child;
    }

    return JustTheTooltip(
      tailLength: 4.0,
      tailBaseWidth: 12.0,
      waitDuration: const Duration(seconds: 1),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          tooltipString,
          style: Utils.calligraphy.body(
            textStyle: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      child: child,
    );
  }
}
