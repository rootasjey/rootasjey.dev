import 'package:beamer/beamer.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/router/locations/dashboard_location.dart';
import 'package:rootasjey/utils/fonts.dart';
import 'package:unicons/unicons.dart';

class UpdatePasswordButton extends StatelessWidget {
  const UpdatePasswordButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(10.0),
          width: 90.0,
          height: 90.0,
          child: Card(
            elevation: 4.0,
            child: InkWell(
              onTap: () {
                Beamer.of(context).beamToNamed(
                  DashboardLocationContent.updatePasswordRoute,
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Opacity(
                  opacity: 0.6,
                  child: Icon(UniconsLine.shield),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 80.0,
          child: Opacity(
            opacity: 0.8,
            child: Text(
              "password_update".tr(),
              textAlign: TextAlign.center,
              style: FontsUtils.mainStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
