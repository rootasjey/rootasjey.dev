import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/better_avatar.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/globals/utilities.dart';
import 'package:unicons/unicons.dart';

class AboutMe extends StatelessWidget {
  const AboutMe({super.key});

  @override
  Widget build(BuildContext context) {
    const double height = 1.2;
    final TextStyle baseStyle = Utilities.fonts.body2(
      textStyle: const TextStyle(
        fontSize: 42.0,
        fontWeight: FontWeight.w300,
        height: height,
      ),
    );

    final TextStyle boldTexStyle = Utilities.fonts.body2(
      textStyle: const TextStyle(
        fontSize: 42.0,
        fontWeight: FontWeight.w600,
        height: height,
      ),
    );

    return SliverList(
      delegate: SliverChildListDelegate.fixed([
        Container(
          padding: const EdgeInsets.only(
            top: 100.0,
          ),
          child: Column(
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
                          textStyle: TextStyle(
                            fontSize: 42.0,
                            fontWeight: FontWeight.w100,
                            color: Theme.of(context)
                                .textTheme
                                .bodyText2
                                ?.color
                                ?.withOpacity(0.6),
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
                    style: Utilities.fonts.body2(
                      textStyle: const TextStyle(
                        fontSize: 62.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              Opacity(
                opacity: 0.8,
                child: Container(
                  width: 700.0,
                  padding: const EdgeInsets.only(top: 42.0),
                  child: Text.rich(
                    TextSpan(
                      text: "about_me.1".tr(),
                      children: [
                        TextSpan(
                          text: "about_me.2".tr(),
                          style: boldTexStyle.merge(
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
                          style: boldTexStyle.merge(
                            const TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        TextSpan(
                          text: "about_me.5".tr(),
                          style: Utilities.fonts.body2(
                            textStyle: boldTexStyle.merge(
                              const TextStyle(
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ),
                        TextSpan(
                          text: "about_me.6".tr(),
                          style: boldTexStyle,
                        ),
                        TextSpan(
                          text: "about_me.7".tr(),
                        ),
                        TextSpan(
                          text: "about_me.8".tr(),
                          style: boldTexStyle,
                        ),
                        TextSpan(
                          text: "about_me.9".tr(),
                        ),
                        TextSpan(
                          text: "about_me.10".tr(),
                          style: boldTexStyle,
                        ),
                        TextSpan(
                          text: "about_me.11".tr(),
                        ),
                        const WidgetSpan(
                          child: Icon(UniconsLine.heart, color: Colors.pink),
                          alignment: PlaceholderAlignment.middle,
                        ),
                        TextSpan(
                          text: "about_me.12".tr(),
                        ),
                        TextSpan(
                          text: "about_me.13".tr(),
                          style: boldTexStyle,
                        ),
                        TextSpan(
                          text: "about_me.14".tr(),
                        ),
                        TextSpan(
                          text: "about_me.15".tr(),
                          style: boldTexStyle.merge(
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
                    textAlign: TextAlign.justify,
                    style: baseStyle,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 62.0),
                width: 800.0,
                child: const Divider(
                  thickness: 2.0,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10.0),
                width: 700.0,
                child: Opacity(
                  opacity: 0.6,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      "- My whole life I have reacted to things. Rarely acted.",
                      style: Utilities.fonts.body2(
                        textStyle: const TextStyle(
                          fontSize: 42.0,
                          fontWeight: FontWeight.w200,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Opacity(
                opacity: 0.4,
                child: SizedBox(
                  width: 700.0,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      "Isaac – Castlevania (TV series)",
                      style: Utilities.fonts.body2(
                        textStyle: TextStyle(
                          color: Theme.of(context).textTheme.bodyText2?.color,
                          fontSize: 24.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
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
}
