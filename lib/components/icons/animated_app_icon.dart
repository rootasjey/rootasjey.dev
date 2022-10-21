import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimatedAppIcon extends StatelessWidget {
  const AnimatedAppIcon({
    super.key,
    this.size = 100.0,
    this.textTitle = "",
  });

  final double size;
  final String textTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Lottie.asset(
          "assets/images/app_icon/icon_animation.json",
          width: size,
          height: size,
        ),
        if (textTitle.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Opacity(
              opacity: 0.6,
              child: Text(
                textTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
