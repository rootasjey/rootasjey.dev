import 'package:flutter/material.dart';

/// A convenient way to add a silver padding
/// without repeating the same padding value
/// (in this specific case = padding.top = 30).
class SliverEdgePadding extends StatelessWidget {
  final EdgeInsets padding;

  const SliverEdgePadding({
    super.key,
    this.padding = const EdgeInsets.only(top: 30.0),
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: padding,
      sliver: SliverList(
        delegate: SliverChildListDelegate.fixed([
          Container(),
        ]),
      ),
    );
  }
}
