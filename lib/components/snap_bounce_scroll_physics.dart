import 'dart:math';

import 'package:flutter/widgets.dart';

class SnapBounceScrollPhysics extends BouncingScrollPhysics {
  final double itemWidth;
  const SnapBounceScrollPhysics({
    required this.itemWidth,
    required ScrollPhysics parent,
  }) : super(parent: parent);

  @override
  SnapBounceScrollPhysics applyTo(ScrollPhysics? ancestor) =>
      SnapBounceScrollPhysics(
        parent: buildParent(ancestor) ?? const AlwaysScrollableScrollPhysics(),
        itemWidth: itemWidth,
      );

  double _getItem(ScrollPosition position) => (position.pixels) / itemWidth;

  double _getPixels(ScrollPosition position, double item) => min(
      max(item * itemWidth, position.minScrollExtent),
      position.maxScrollExtent);

  double _getTargetPixels(
      ScrollPosition position, Tolerance tolerance, double velocity) {
    double item = _getItem(position);
    item += velocity / 1000;
    return _getPixels(position, item.roundToDouble());
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    // If we're out of range and not headed back in range, defer to the parent
    // ballistics, which should put us back in range at a page boundary.
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }
    final Tolerance tolerance = toleranceFor(position);
    final double target =
        _getTargetPixels(position as ScrollPosition, tolerance, velocity);
    if (target != position.pixels) {
      return ScrollSpringSimulation(spring, position.pixels, target, velocity,
          tolerance: tolerance);
    }
    return null;
  }

  @override
  bool get allowImplicitScrolling => false;
}
