import 'package:rootasjey/router/locations/home_location.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({
    super.key,
    this.onTap,
    this.margin = EdgeInsets.zero,
    this.size = 40.0,
    this.onLongPress,
  });

  final double size;
  final EdgeInsetsGeometry margin;
  final void Function()? onTap;
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
        child: Icon(
          UniconsLine.box,
          size: size,
        ),
      ),
    );
  }
}
