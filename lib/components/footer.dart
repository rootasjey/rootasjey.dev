import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({
    super.key,
    this.useSliver = true,
  });

  final bool useSliver;

  @override
  Widget build(BuildContext context) {
    const Widget child = Text("Footer");

    if (!useSliver) {
      return child;
    }

    return const SliverToBoxAdapter(
      child: child,
    );
  }
}
