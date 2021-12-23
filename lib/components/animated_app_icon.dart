import 'package:flutter/material.dart';
import 'package:rootasjey/utils/fonts.dart';

class AnimatedAppIcon extends StatefulWidget {
  final double size;
  final String? textTitle;

  AnimatedAppIcon({
    this.size = 60.0,
    this.textTitle,
  });

  @override
  _AnimatedAppIconState createState() => _AnimatedAppIconState();
}

class _AnimatedAppIconState extends State<AnimatedAppIcon> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/app_icon/128.png',
          height: widget.size,
          width: widget.size,
        ),
        SizedBox(
          width: 150.0,
          child: LinearProgressIndicator(),
        ),
        if (widget.textTitle != null)
          Padding(
            padding: const EdgeInsets.only(
              top: 16.0,
            ),
            child: Opacity(
              opacity: 0.6,
              child: Text(
                widget.textTitle!,
                style: FontsUtils.mainStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
