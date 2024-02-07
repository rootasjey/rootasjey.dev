import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:rootasjey/components/better_avatar.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/globals/utilities.dart';
import 'package:rootasjey/router/locations/cv_location.dart';

class AboutMe extends StatelessWidget {
  const AboutMe({
    super.key,
    this.size = Size.zero,
  });

  /// Window's size.
  final Size size;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate.fixed([
        Container(
          color: Constants.colors.backgroundPalette.elementAt(1),
          padding: const EdgeInsets.only(
            top: 100.0,
            left: 12.0,
            right: 12.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Container(
                  height: 8.0,
                  width: 8.0,
                  decoration: BoxDecoration(
                    color: Constants.colors.palette.first,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Container(
                  height: 90.0,
                  width: 4.0,
                  decoration: BoxDecoration(
                    color: Constants.colors.palette.first,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
              ),
              BetterAvatar(
                borderSide: BorderSide(
                  color: Constants.colors.palette.first,
                  width: 4.0,
                ),
                image: const AssetImage("assets/images/jeje.jpg"),
                onTap: () {
                  Beamer.of(context).beamToNamed(CVLocation.route);
                },
                colorFilter: const ColorFilter.mode(
                  Colors.grey,
                  BlendMode.saturation,
                ),
                size: 140.0,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 42.0),
                child: Text.rich(
                  TextSpan(
                    text: "Jérémie Corpinot",
                    children: [
                      TextSpan(
                        text: "\nalias",
                        style: Utilities.fonts.body2(
                          textStyle: const TextStyle(
                            fontSize: 42.0,
                            fontWeight: FontWeight.w100,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      TextSpan(
                        text: " rootasjey",
                        style: Utilities.fonts.body2(
                          textStyle: const TextStyle(
                            fontSize: 42.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                    style: Utilities.fonts.body4(
                      textStyle: const TextStyle(
                        fontSize: 62.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  textAlign: getTitleAlign(),
                  style: Utilities.fonts.body(
                    textStyle: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 72.0),
                child: Opacity(
                  opacity: 0.8,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800.0),
                    child: Text.rich(
                      TextSpan(
                        text: "about_me.1".tr(),
                        children: [
                          TextSpan(
                            text: "about_me.2".tr(),
                            style: getBoldStyle().merge(
                              const TextStyle(
                                color: Colors.amber,
                              ),
                            ),
                          ),
                          TextSpan(
                            text: "about_me.3".tr(),
                          ),
                          TextSpan(
                            text: "about_me.4".tr(),
                            style: getBoldStyle().merge(
                              const TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          TextSpan(
                            text: "about_me.5".tr(),
                            style: getBoldStyle().merge(
                              const TextStyle(
                                color: Colors.green,
                              ),
                            ),
                          ),
                          TextSpan(
                            text: "about_me.6".tr(),
                            style: getBoldStyle(),
                          ),
                          TextSpan(
                            text: "about_me.7".tr(),
                          ),
                          TextSpan(
                            text: "about_me.8".tr(),
                            style: getBoldStyle(),
                          ),
                          TextSpan(
                            text: "about_me.9".tr(),
                          ),
                          TextSpan(
                            text: "about_me.10".tr(),
                            style: getBoldStyle(),
                          ),
                          TextSpan(
                            text: "about_me.11".tr(),
                          ),
                          const WidgetSpan(
                            child: Icon(TablerIcons.heart, color: Colors.pink),
                            alignment: PlaceholderAlignment.middle,
                          ),
                          TextSpan(
                            text: "about_me.12".tr(),
                          ),
                          TextSpan(
                            text: "about_me.13".tr(),
                            style: getBoldStyle(),
                          ),
                          TextSpan(
                            text: "about_me.14".tr(),
                          ),
                          TextSpan(
                            text: "about_me.15".tr(),
                            style: getBoldStyle().merge(
                              const TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                          TextSpan(
                            text: "about_me.16".tr(),
                          ),
                        ],
                      ),
                      textAlign: getSummaryAlign(),
                      style: getBaseStyle(),
                    ),
                  ),
                ),
              ),
              quoteDivider(),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700.0),
                  child: Opacity(
                    opacity: 0.6,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        "- My whole life I have reacted to things. Rarely acted.",
                        style: getQuoteNameStyle(),
                      ),
                    ),
                  ),
                ),
              ),
              Opacity(
                opacity: 0.4,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700.0),
                  child: Align(
                    alignment: getQuoteAuthorAlign(),
                    child: Text(
                      "Isaac – Castlevania (TV series)",
                      style: getQuoteAuthorStyle(context),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  /// Return TextAlign for summary text.
  TextAlign getSummaryAlign() {
    return size.width < Utilities.size.mobileWidthTreshold
        ? TextAlign.start
        : TextAlign.start;
  }

  /// Return TextAlign for title.
  TextAlign getTitleAlign() {
    return size.width < Utilities.size.mobileWidthTreshold
        ? TextAlign.center
        : TextAlign.start;
  }

  /// Return TextStyle for default text in summary.
  TextStyle getBaseStyle() {
    if (size.width < Utilities.size.mobileWidthTreshold) {
      return Utilities.fonts.body4(
        textStyle: const TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w300,
          height: 1.2,
          color: Colors.black,
        ),
      );
    }

    return Utilities.fonts.body4(
      textStyle: const TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.w400,
        height: 1.2,
        color: Colors.black87,
      ),
    );
  }

  /// Return TextStyle for bold text in summary.
  TextStyle getBoldStyle() {
    if (size.width < Utilities.size.mobileWidthTreshold) {
      return Utilities.fonts.body4(
        textStyle: const TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w600,
          height: 1.2,
          color: Colors.black,
        ),
      );
    }

    return Utilities.fonts.body4(
      textStyle: const TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: Colors.black,
      ),
    );
  }

  /// Return a TextStyle for quote's name.
  TextStyle getQuoteNameStyle() {
    if (size.width < Utilities.size.mobileWidthTreshold) {
      return Utilities.fonts.body2(
        textStyle: const TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w200,
          fontStyle: FontStyle.italic,
          color: Colors.black,
        ),
      );
    }

    return Utilities.fonts.body2(
      textStyle: const TextStyle(
        fontSize: 42.0,
        fontWeight: FontWeight.w200,
        fontStyle: FontStyle.italic,
        color: Colors.black,
      ),
    );
  }

  TextStyle getQuoteAuthorStyle(BuildContext context) {
    if (size.width < Utilities.size.mobileWidthTreshold) {
      return Utilities.fonts.body2(
        textStyle: const TextStyle(
          color: Colors.black,
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
        ),
      );
    }

    return Utilities.fonts.body2(
      textStyle: const TextStyle(
        color: Colors.black,
        fontSize: 24.0,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Alignment getQuoteAuthorAlign() {
    if (size.width < Utilities.size.mobileWidthTreshold) {
      return Alignment.topLeft;
    }

    return Alignment.topRight;
  }

  Widget quoteDivider() {
    final EdgeInsets padding = size.width < Utilities.size.mobileWidthTreshold
        ? const EdgeInsets.symmetric(vertical: 12.0)
        : const EdgeInsets.symmetric(vertical: 62.0);

    return Container(
      padding: padding,
      width: 800.0,
      child: const Divider(
        thickness: 2.0,
      ),
    );
  }
}
