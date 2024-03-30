import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/globals/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class UndefinedPage extends StatefulWidget {
  const UndefinedPage({
    super.key,
    this.errorCode = "404",
  });

  final String errorCode;

  @override
  State<StatefulWidget> createState() => _UndefinedPageState();
}

class _UndefinedPageState extends State<UndefinedPage> {
  @override
  Widget build(BuildContext context) {
    final Color? foregroundColor =
        Theme.of(context).textTheme.bodyMedium?.color;
    String location = "";
    final history = Beamer.of(context).beamingHistory;

    if (history.isNotEmpty) {
      final beamLocation = history.last;
      location = beamLocation.state.routeInformation.uri.path;
    }

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(maxWidth: 500.0, maxHeight: 500.0),
              child: FractionallySizedBox(
                widthFactor: 0.5,
                heightFactor: 0.5,
                child: InkWell(
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.indigo.shade100,
                  onTap: () {
                    launchUrl(
                      Uri.parse(
                        "https://lottiefiles.com/animations"
                        "/404-error-lost-in-space-astronaut-GbWDsssrth",
                      ),
                    );
                  },
                  child: Lottie.asset(
                    "assets/animations/lost_in_space_astronaut.json",
                    // width: 400.0,
                    // height: 400.0,
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: 500.0,
            padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
            child: Column(
              children: [
                Text(
                  "...we got lost, but at least we're together",
                  // "route_error.${widget.errorCode}".tr(),
                  textAlign: TextAlign.center,
                  style: Utils.calligraphy.body(
                    textStyle: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                      color: foregroundColor?.withOpacity(0.8),
                    ),
                  ),
                ),
                // Text(
                //   "https://lottiefiles.com/animations/404-error-lost-in-space-astronaut-GbWDsssrth",
                //   // "route_error.${widget.errorCode}".tr(),
                //   textAlign: TextAlign.center,
                //   style: Utils.calligraphy.body(
                //     textStyle: TextStyle(
                //       fontSize: 18.0,
                //       fontWeight: FontWeight.w400,
                //       color: foregroundColor?.withOpacity(0.8),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Constants.colors.palette.first.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              "attempted to go to path : $location",
              style: Utils.calligraphy.body(
                textStyle: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: foregroundColor?.withOpacity(0.6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
