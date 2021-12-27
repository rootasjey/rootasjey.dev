import 'package:flutter/material.dart';
import 'package:rootasjey/utils/fonts.dart';
import 'package:unicons/unicons.dart';

class CompanyWatermark extends StatelessWidget {
  const CompanyWatermark({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        bottom: 8.0,
      ),
      child: Text.rich(TextSpan(
        children: [
          TextSpan(
            text: "rootasjey ${DateTime.now().year}",
            style: FontsUtils.mainStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          WidgetSpan(
            child: Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Opacity(
                opacity: 0.6,
                child: Icon(
                  UniconsLine.copyright,
                  size: 18.0,
                ),
              ),
            ),
          ),
          TextSpan(
            text: "\nby Jeremie Codes, SASU",
          ),
        ],
      )),
    );
  }
}
