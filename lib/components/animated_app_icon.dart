import 'package:flutter/material.dart';

class AnimatedAppIcon extends StatefulWidget {
  final double size;
  final String textTitle;

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
          width: 200.0,
          child: LinearProgressIndicator(),
        ),
        if (widget.textTitle != null)
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
            ),
            child: Opacity(
              opacity: 0.6,
              child: Text(
                widget.textTitle,
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
