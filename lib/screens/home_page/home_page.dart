import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:loggy/loggy.dart';
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

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF101010) : _backgroundColor,
      body: Column(
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
                  Utils.graphic.tooltip(
                    tooltipString: "linkedin",
                    child: IconButton(
                      onPressed: () {
                        launchUrl(
                          Uri.parse(
                            "https://www.linkedin.com/in/jérémie-c-7b25194a",
                          ),
                        );
                      },
                      icon: const Icon(TablerIcons.brand_linkedin),
                    ),
                  ),
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
                  const BrightnessButton(
                    margin: EdgeInsets.only(left: 8.0),
                  ),
                  Utils.graphic.tooltip(
                    tooltipString: "Shuffle color",
                    child: IconButton(
                      onPressed: onShuffleColor,
                      icon: const Icon(
                        TablerIcons.color_swatch,
                      ),
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
                  foregroundColor:
                      isDark ? Colors.black : Constants.colors.getRandomLight(),
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
