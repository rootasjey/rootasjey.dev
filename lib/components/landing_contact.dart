import 'package:flutter/material.dart';
import 'package:rootasjey/components/contact_form.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/utils/fonts.dart';

class LandingContact extends StatefulWidget {
  @override
  _LandingContactState createState() => _LandingContactState();
}

class _LandingContactState extends State<LandingContact> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: stateColors.newLightBackground,
      padding: const EdgeInsets.only(
        top: 200.0,
        left: 120.0,
        right: 120.0,
      ),
      child: contactForm(),
    );
  }

  Widget contactForm() {
    return Column(
      children: [
        title(),
        ContactForm(),
      ],
    );
  }

  Widget title() {
    return Text(
      "Get in touch",
      style: FontsUtils.mainStyle(
        fontSize: 80.0,
        height: 0.9,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}
