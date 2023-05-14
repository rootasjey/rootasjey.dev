import 'package:rootasjey/router/locations/home_location.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

/// A widget that displays application icon.
class AppIcon extends StatelessWidget {
  const AppIcon({
    super.key,
    this.onTap,
    this.margin = EdgeInsets.zero,
    this.size = 40.0,
    this.onLongPress,
  });

  /// The size of the icon.
  final double size;

  /// The margin of the icon.
  final EdgeInsetsGeometry margin;

  /// Called when the icon is tapped.
  final void Function()? onTap;

  /// Called when the icon is long pressed.
  final void Function()? onLongPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: onTap ??
            () =>
                Beamer.of(context, root: true).beamToNamed(HomeLocation.route),
        onLongPress: onLongPress,
        // child: Icon(
        //   UniconsLine.box,
        //   size: size,
        // ),
        child: Image.asset(
          "assets/images/app_icon/128.png",
          width: size,
          height: size,
        ),
      ),
    );
  }
}
