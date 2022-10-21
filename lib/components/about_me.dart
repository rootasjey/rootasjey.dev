import 'package:flutter/material.dart';
import 'package:rootasjey/components/better_avatar.dart';
import 'package:rootasjey/globals/utilities.dart';
import 'package:unicons/unicons.dart';

class AboutMe extends StatelessWidget {
  const AboutMe({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate.fixed([
        Container(
          padding: const EdgeInsets.only(
            top: 100.0,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Container(
                  height: 90.0,
                  width: 4.0,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade700,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
              ),
              const BetterAvatar(
                image: AssetImage("assets/images/jeje.jpg"),
                size: 140.0,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 42.0),
                child: Text.rich(
                  TextSpan(
                    text: "Jeremie CORPINOT",
                    children: [
                      TextSpan(
                        text: "\nalias",
                        style: Utilities.fonts.body2(
                          fontSize: 42.0,
                          fontWeight: FontWeight.w100,
                          color: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.color
                              ?.withOpacity(0.6),
                        ),
                      ),
                      TextSpan(
                        text: " rootasjey",
                        style: Utilities.fonts.body2(
                          fontSize: 42.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                    style: Utilities.fonts.body2(
                      fontSize: 62.0,
                      fontWeight: FontWeight.w600,
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
                      text:
                          "I'm a fullstack developer building application with ",
                      children: [
                        TextSpan(
                          text: "Flutter.",
                          style: Utilities.fonts.body2(
                            color: Colors.amber,
                            fontSize: 42.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const TextSpan(
                          text: "\nBut I also code project with ",
                        ),
                        TextSpan(
                          text: "React, ",
                          style: Utilities.fonts.body2(
                            color: Colors.blue,
                            fontSize: 42.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: "Vue, ",
                          style: Utilities.fonts.body2(
                            color: Colors.green,
                            fontSize: 42.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: "Next.",
                          style: Utilities.fonts.body2(
                            fontSize: 42.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const TextSpan(
                          text:
                              "\n\nI teach programming in web & python sometimes, when I'm not playing ",
                        ),
                        TextSpan(
                          text: "video games",
                          style: Utilities.fonts.body2(
                            fontSize: 42.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const TextSpan(
                          text: " or ",
                        ),
                        TextSpan(
                          text: "watching movies.",
                          style: Utilities.fonts.body2(
                            fontSize: 42.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const TextSpan(
                          text: "\n\nI ",
                        ),
                        const WidgetSpan(
                          child: Icon(UniconsLine.heart, color: Colors.pink),
                          alignment: PlaceholderAlignment.middle,
                        ),
                        const TextSpan(
                          text:
                              " learning new things, so I spend a lot of time reading ",
                        ),
                        TextSpan(
                          text: "books",
                          style: Utilities.fonts.body2(
                            fontSize: 42.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const TextSpan(
                          text: ", watching ",
                        ),
                        TextSpan(
                          text: "YouTube",
                          style: Utilities.fonts.body2(
                            color: Colors.red,
                            fontSize: 42.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const TextSpan(
                          text: ", or listenning to podcasts.",
                        ),
                      ],
                    ),
                    style: Utilities.fonts.body2(
                      fontSize: 42.0,
                      fontWeight: FontWeight.w200,
                    ),
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
                      "– My whole life I have reacted to things. Rarely acted.",
                      style: Utilities.fonts.body2(
                        fontSize: 42.0,
                        fontWeight: FontWeight.w200,
                        fontStyle: FontStyle.italic,
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
                        color: Theme.of(context).textTheme.bodyText2?.color,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w400,
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
