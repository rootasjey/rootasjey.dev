import 'package:flutter/material.dart';

class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({
    super.key,
    this.size = 100.0,
    this.style = const TextStyle(
      fontSize: 20.0,
    ),
    this.message = "",
  });

  final TextStyle style;
  final String message;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: style,
          ),
        ),
      ],
    );
  }
}
