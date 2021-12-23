import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/application_bar/brightness_button.dart';
import 'package:rootasjey/components/application_bar/lang_button.dart';
import 'package:rootasjey/router/locations/signin_location.dart';
import 'package:rootasjey/router/locations/signup_location.dart';
import 'package:rootasjey/state/colors.dart';

class UserGuestSection extends StatelessWidget {
  const UserGuestSection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 5.0,
        right: 10.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                BrightnessButton(),
                LangButton(),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => Beamer.of(context).beamToNamed(
              SigninLocation.route,
            ),
            child: Text("signin".tr().toUpperCase()),
            style: ElevatedButton.styleFrom(
              primary: stateColors.primary,
            ),
          ),
          TextButton(
            onPressed: () => Beamer.of(context).beamToNamed(
              SignupLocation.route,
            ),
            child: Text(
              "signup".tr().toUpperCase(),
              style: TextStyle(
                color: stateColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
