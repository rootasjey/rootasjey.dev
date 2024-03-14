import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:loggy/loggy.dart';
import 'package:rootasjey/components/buttons/circle_button.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/globals/utils.dart';
import 'package:rootasjey/screens/home_page/brightness_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wave_divider/wave_divider.dart';

class HomePage extends StatefulWidget with UiLoggy {
  const HomePage({
    super.key,
    this.onGoToPage,
  });

  final void Function(String pageName)? onGoToPage;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Background color.
  Color _backgroundColor = Colors.blue.shade50;

  /// Action button radius.
  final double _actionButtonRadius = 16.0;

  /// Action button size.
  final double _actionButtonSize = 18.0;

  /// Color amount to decrease for action button background color.
  final int _colorAmount = 15;

  @override
  void initState() {
    super.initState();
    _backgroundColor = Constants.colors.getRandomLight();
  }

  @override
  Widget build(BuildContext context) {
    final bool useTinyText = Utils.measurements.isMobileSize(context);
    final Brightness brightness = Theme.of(context).brightness;
    final bool isDark = brightness == Brightness.dark;
    final Color? foregroundColor =
        Theme.of(context).textTheme.bodyMedium?.color;

    final Color buttonBackgroundColor = isDark
        ? Colors.white70
        : Color.fromARGB(
            _backgroundColor.alpha,
            _backgroundColor.red - _colorAmount,
            _backgroundColor.green - _colorAmount,
            _backgroundColor.blue - _colorAmount,
          );

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF101010) : _backgroundColor,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: Constants.appName,
                      style: Utils.calligraphy.body(
                        textStyle: TextStyle(
                          fontSize: useTinyText ? 64.0 : 112.0,
                          fontWeight: FontWeight.w800,
                          height: 1.0,
                        ),
                      ),
                    ),
                    const TextSpan(
                      text: "\nI'm a creative developer",
                    )
                  ],
                ),
                style: Utils.calligraphy.body3(
                  textStyle: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600,
                    color: foregroundColor?.withOpacity(1.0),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 42.0),
                child: Center(
                  child: SizedBox(
                    width: 180.0,
                    child: WaveDivider(),
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: 200.0,
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Wrap(
                    alignment: WrapAlignment.spaceAround,
                    spacing: 24.0,
                    runSpacing: 12.0,
                    children: [
                      Utils.graphic.tooltip(
                        tooltipString: "kwotes",
                        child: IconButton(
                          onPressed: () {
                            launchUrl(Uri.parse("https://kwotes.fr"));
                          },
                          icon: const Icon(TablerIcons.quote),
                        ),
                      ),
                      Utils.graphic.tooltip(
                        tooltipString: "illustrations",
                        child: IconButton(
                          onPressed: () {
                            widget.onGoToPage?.call("illustrations-page");
                          },
                          icon: const Icon(TablerIcons.photo),
                        ),
                      ),
                      Utils.graphic.tooltip(
                        tooltipString: "video montages",
                        child: IconButton(
                          onPressed: () {
                            widget.onGoToPage?.call("video-montages-page");
                          },
                          icon: const Icon(TablerIcons.movie),
                        ),
                      ),
                      Utils.graphic.tooltip(
                        tooltipString: "github",
                        child: IconButton(
                          onPressed: () {
                            launchUrl(
                              Uri.parse("https://github.com/rootasjey"),
                            );
                          },
                          icon: const Icon(TablerIcons.brand_github),
                        ),
                      ),
                      Utils.graphic.tooltip(
                        tooltipString: "instagram",
                        child: IconButton(
                          onPressed: () {
                            launchUrl(
                              Uri.parse("https://instagram.com/rootasjey"),
                            );
                          },
                          icon: const Icon(TablerIcons.brand_instagram),
                        ),
                      ),
                      // Utils.graphic.tooltip(
                      //   tooltipString: "linkedin",
                      //   child: IconButton(
                      //     onPressed: () {
                      //       launchUrl(
                      //         Uri.parse(
                      //           "https://www.linkedin.com/in/jérémie-c-7b25194a",
                      //         ),
                      //       );
                      //     },
                      //     icon: const Icon(TablerIcons.brand_linkedin),
                      //   ),
                      // ),
                      Utils.graphic.tooltip(
                        tooltipString: "threads",
                        child: IconButton(
                          onPressed: () {
                            launchUrl(
                              Uri.parse("https://www.threads.net/@rootasjey"),
                            );
                          },
                          icon: const Icon(TablerIcons.brand_threads),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 36.0),
                  child: ElevatedButton(
                    onPressed: onTapHireMeButton,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: isDark
                          ? Colors.black
                          : Constants.colors.getRandomLight(),
                      backgroundColor: isDark ? Colors.white : Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                    child: Text(
                      "Hire me!",
                      style: Utils.calligraphy.body(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 24.0,
            right: 24.0,
            child: Wrap(
              spacing: 12.0,
              direction: Axis.vertical,
              children: [
                BrightnessButton(
                  radius: _actionButtonRadius,
                  buttonSize: _actionButtonSize,
                  backgroundColor: buttonBackgroundColor,
                ),
                if (!isDark)
                  Utils.graphic
                      .tooltip(
                        tooltipString: "shuffle_color".tr(),
                        child: CircleButton(
                          onTap: onShuffleColor,
                          radius: _actionButtonRadius,
                          backgroundColor: buttonBackgroundColor,
                          icon: Icon(
                            TablerIcons.color_swatch,
                            color: Colors.black,
                            size: _actionButtonSize,
                          ),
                        ),
                      )
                      .animate()
                      .fadeIn(
                        duration: const Duration(milliseconds: 225),
                        curve: Curves.fastOutSlowIn,
                      )
                      .scaleXY(
                        begin: 0.4,
                        end: 1.0,
                        curve: Curves.easeInOut,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onShuffleColor() {
    setState(() {
      _backgroundColor = Constants.colors.getRandomLight();
    });
  }

  void onTapHireMeButton() async {
    final String url = await FirebaseStorage.instance
        .ref("/assets/files/jerem_corp_curriculum_A3.pdf")
        .getDownloadURL();

    launchUrl(Uri.parse(url));
  }
}
