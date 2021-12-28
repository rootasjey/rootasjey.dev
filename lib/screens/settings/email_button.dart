import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/types/globals/globals.dart';
import 'package:rootasjey/utils/fonts.dart';
import 'package:unicons/unicons.dart';

class EmailButton extends StatelessWidget {
  final String email;
  final VoidCallback onPressed;
  const EmailButton({
    Key? key,
    required this.email,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        primary: Theme.of(context).textTheme.bodyText1?.color,
      ),
      onLongPress: () {
        showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                title: Text(
                  "email".tr(),
                  style: FontsUtils.mainStyle(
                    fontSize: 14.0,
                  ),
                ),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 25.0,
                      right: 25.0,
                    ),
                    child: Text(
                      email,
                      style: TextStyle(
                        color: Globals.constants.colors.primary,
                      ),
                    ),
                  ),
                ],
              );
            });
      },
      child: Container(
        width: 250.0,
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 24.0),
                  child: Opacity(
                    opacity: 0.6,
                    child: Icon(UniconsLine.envelope),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Opacity(
                        opacity: 0.3,
                        child: Text(
                          "email".tr().toUpperCase(),
                          style: FontsUtils.mainStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        email,
                        style: FontsUtils.mainStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
