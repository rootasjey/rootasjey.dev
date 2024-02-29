import 'package:flutter/material.dart';

class DotSeparator extends StatelessWidget {
  const DotSeparator({
    super.key,
    this.margin = EdgeInsets.zero,
  });

  /// Space around this widget.
  final EdgeInsetsGeometry margin;

  final double dotWidth = 12.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      // padding: const EdgeInsets.only(top: 90.0),
      child: Wrap(
        spacing: 12.0,
        runSpacing: 12.0,
        children: [
          Colors.green,
          Colors.orange,
          Colors.pink,
        ]
            .map(
              (color) => Container(
                width: dotWidth,
                height: dotWidth,
                foregroundDecoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
