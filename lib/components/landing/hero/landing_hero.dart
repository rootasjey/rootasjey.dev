import 'package:flutter/material.dart';
import 'package:rootasjey/components/landing/hero/left_side/left_side.dart';
import 'package:rootasjey/components/landing/hero/right_side/right_side.dart';
import 'package:rootasjey/types/globals/globals.dart';

class LandingHero extends StatelessWidget {
  const LandingHero({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: getPadding(context),
      child: Wrap(
        spacing: 40.0,
        runSpacing: 20.0,
        children: [
          LeftSide(),
          RightSide(),
        ],
      ),
    );
  }

  EdgeInsets getPadding(BuildContext context) {
    return Globals.utils.size.isMobileSize(context)
        ? const EdgeInsets.only(
            top: 80.0,
            left: 20.0,
            right: 20.0,
          )
        : const EdgeInsets.only(
            top: 200.0,
            left: 120.0,
            right: 120.0,
          );
  }
}
