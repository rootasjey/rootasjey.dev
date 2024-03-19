import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rootasjey/globals/utils.dart';

/// A sliver component to display when data is not ready yet.
class LoadingView extends StatelessWidget {
  const LoadingView({
    super.key,
    this.message = "loading...",
    this.useSliver = false,
  });

  /// Whether to use a [SliverToBoxAdapter] or not.
  final bool useSliver;

  /// Message value to display as a loading message.
  final String message;

  @override
  Widget build(BuildContext context) {
    final Center center = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Lottie.asset(
              "assets/animations/box.json",
              width: 300.0,
            ),
          ),
          Text(
            message,
            style: Utils.calligraphy.body2(
              textStyle: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (useSliver) {
      return SliverToBoxAdapter(
        child: center,
      );
    }

    return center;
  }

  /// Return a Scaffold widget displaying a loading animation.
  static Widget scaffold({String message = "Loading..."}) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Lottie.asset(
                "assets/animations/box.json",
                width: 300.0,
              ),
            ),
            Text(
              message,
              style: Utils.calligraphy.body2(
                textStyle: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
