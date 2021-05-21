import 'package:flutter/material.dart';
import 'package:rootasjey/utils/fonts.dart';
import 'package:unicons/unicons.dart';
import 'package:url_launcher/url_launcher.dart';

class LandingQuote extends StatefulWidget {
  @override
  _LandingQuoteState createState() => _LandingQuoteState();
}

class _LandingQuoteState extends State<LandingQuote> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.only(
        top: 200.0,
        left: 120.0,
        right: 120.0,
      ),
      child: Column(
        children: [
          Text(
            "If you don't like using a tool,"
            " build a new one.",
            style: FontsUtils.mainStyle(
              fontSize: 90,
              fontWeight: FontWeight.w700,
            ),
          ),
          author(),
          viewMoreButton(),
        ],
      ),
    );
  }

  Widget author() {
    return Wrap(
      spacing: 12.0,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: 50.0,
          child: Divider(
            thickness: 2.0,
          ),
        ),
        Opacity(
          opacity: 0.6,
          child: Text(
            "rootasjey",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget viewMoreButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 60.0),
      child: OutlinedButton(
        onPressed: () {
          launch("https://fig.style");
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 200.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "More quotes".toUpperCase(),
                  style: FontsUtils.mainStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(UniconsLine.arrow_right),
                ),
              ],
            ),
          ),
        ),
        style: OutlinedButton.styleFrom(
          primary: Colors.pink,
        ),
      ),
    );
  }
}
