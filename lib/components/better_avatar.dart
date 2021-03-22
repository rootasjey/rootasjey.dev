import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';

class BetterAvatar extends StatefulWidget {
  final VoidCallback onTap;
  final ImageProvider<Object> image;
  final double size;
  final double elevation;

  BetterAvatar({
    @required this.image,
    this.elevation = 4.0,
    this.onTap,
    this.size = 220.0,
  });

  @override
  _BetterAvatarState createState() => _BetterAvatarState();
}

class _BetterAvatarState extends State<BetterAvatar>
    with TickerProviderStateMixin {
  Animation<double> scaleAnimation;
  AnimationController scaleAnimationController;

  double elevation;
  double size;

  @override
  void initState() {
    super.initState();

    scaleAnimationController = AnimationController(
      lowerBound: 0.8,
      upperBound: 1.0,
      duration: 500.milliseconds,
      vsync: this,
    );

    scaleAnimation = CurvedAnimation(
      parent: scaleAnimationController,
      curve: Curves.fastOutSlowIn,
    );

    setState(() {
      size = widget.size;
      elevation = widget.elevation;
    });
  }

  @override
  dispose() {
    scaleAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: Material(
        elevation: elevation,
        clipBehavior: Clip.hardEdge,
        shape: CircleBorder(),
        child: Container(
          width: size,
          height: size,
          child: Ink.image(
            image: widget.image,
            width: size,
            height: size,
            fit: BoxFit.cover,
            child: InkWell(
              onTap: widget.onTap,
              onHover: (isHover) {
                if (isHover) {
                  elevation = widget.elevation * 2;
                  scaleAnimationController.forward();
                  setState(() {});
                  return;
                }

                elevation = widget.elevation;
                scaleAnimationController.reverse();
                setState(() {});
              },
            ),
          ),
        ),
      ),
    );
  }
}
