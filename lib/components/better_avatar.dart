import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';

class BetterAvatar extends StatefulWidget {
  final VoidCallback onTap;
  final ImageProvider<Object> image;
  final double size;

  BetterAvatar({
    @required this.image,
    this.onTap,
    this.size = 220.0,
  });

  @override
  _BetterAvatarState createState() => _BetterAvatarState();
}

class _BetterAvatarState extends State<BetterAvatar> {
  double elevation = 4.0;
  double size;

  @override
  void initState() {
    super.initState();

    setState(() {
      size = widget.size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      shape: CircleBorder(),
      child: AnimatedContainer(
        duration: 250.milliseconds,
        width: size,
        height: size,
        child: Ink.image(
          image: widget.image,
          width: size,
          height: size,
          child: InkWell(
            onTap: widget.onTap,
            onHover: (isHover) {
              setState(() {
                elevation = isHover
                  ? 8.0
                  : 4.0;

                size = isHover
                  ? widget.size + 5.0
                  : widget.size;
              });
            },
          ),
        ),
      ),
    );
  }
}
