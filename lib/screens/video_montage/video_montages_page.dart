import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:rootasjey/components/buttons/circle_button.dart';
import 'package:rootasjey/components/icons/app_icon.dart';
import 'package:rootasjey/globals/utils.dart';
import 'package:rootasjey/router/navigation_state_helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wave_divider/wave_divider.dart';

class VideoMontagesPage extends StatefulWidget {
  const VideoMontagesPage({super.key});

  @override
  State<VideoMontagesPage> createState() => _VideoMontagesPageState();
}

class _VideoMontagesPageState extends State<VideoMontagesPage> {
  bool _showVideoCover = true;

  @override
  void initState() {
    super.initState();
    NavigationStateHelper.player.open(
      Media(
        "https://firebasestorage.googleapis.com/v0/b/rootasjey.appspot.com/o/"
        "videos%2Fdispatches-from-elsewhere%2Foccasionally-scared--resolution-1080p.mp4"
        "?alt=media&token=e12bc54d-2c36-4898-a5b1-92af93aadade",
      ),
      play: false,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size windowSize = MediaQuery.of(context).size;
    final bool isMobileSize =
        windowSize.width < Utils.measurements.mobileWidthTreshold;
    final Color? foregroundColor = Theme.of(context).textTheme.bodyLarge?.color;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Utils.graphic.tooltip(
                    tooltipString: "home".tr(),
                    child: const AppIcon(
                      size: 24.0,
                      margin: EdgeInsets.only(right: 12.0),
                    ),
                  ),
                  const Icon(TablerIcons.point),
                  Utils.graphic.tooltip(
                    tooltipString: "back".tr(),
                    child: IconButton(
                      onPressed: context.beamBack,
                      icon: const Icon(TablerIcons.arrow_back),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 12.0,
                right: 12.0,
              ),
              child: FractionallySizedBox(
                widthFactor: isMobileSize ? 0.9 : 0.6,
                child: Column(
                  children: [
                    Text(
                      "video_montage.name".tr().toUpperCase(),
                      style: Utils.calligraphy.body2(
                        textStyle: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      "video_montage.subtitle".tr(),
                      style: Utils.calligraphy.body(
                        textStyle: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          color: foregroundColor?.withOpacity(0.5),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 24.0),
                      child: WaveDivider(),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 36.0,
                horizontal: 42.0,
              ),
              child: Wrap(
                spacing: 32.0,
                runSpacing: 32.0,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.start,
                runAlignment: WrapAlignment.center,
                children: [
                  Stack(
                    children: [
                      Card(
                        elevation: 4.0,
                        clipBehavior: Clip.hardEdge,
                        color: Colors.amber,
                        child: SizedBox(
                          height: 242.0,
                          width: 420.0,
                          child: Video(
                            aspectRatio: 16 / 9,
                            controller: NavigationStateHelper.videoController,
                          ),
                        ),
                      ),
                      if (_showVideoCover)
                        Card(
                          elevation: 4.0,
                          clipBehavior: Clip.hardEdge,
                          child: SizedBox(
                            height: 242.0,
                            width: 420.0,
                            child: Ink.image(
                              fit: BoxFit.cover,
                              image: const NetworkImage(
                                  "https://firebasestorage.googleapis.com/v0/b"
                                  "/rootasjey.appspot.com/o/videos%2Fdispatches-from-elsewhere%2Fthumbnail.jpg?alt=media&token=5335c02f-a503-44ff-87e1-01734102f054"),
                              child: InkWell(
                                onTap: playVideo,
                                child: Center(
                                  child: CircleButton(
                                    onTap: playVideo,
                                    icon: const Icon(
                                      TablerIcons.player_play,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Card(
                    elevation: 0.0,
                    child: Container(
                      height: 242.0,
                      width: 420.0,
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Dispatches From Elsewhere",
                            style: Utils.calligraphy.title(
                              textStyle: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w700,
                                color: foregroundColor,
                                height: 1.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Text.rich(
                              const TextSpan(
                                text: "",
                                children: [
                                  TextSpan(
                                    text:
                                        "This tv series inspired me a lot artistically. "
                                        "Some of the subjects in the show resonated with me, and I wanted to give back something.\n"
                                        "I composed with the scenes that gave me the strongest feelings. I hope you enjoy it!",
                                  ),
                                ],
                              ),
                              style: Utils.calligraphy.body(
                                textStyle: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  color: foregroundColor?.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Wrap(
                              spacing: 12.0,
                              runSpacing: 12.0,
                              children: [
                                CircleButton(
                                  onTap: () {
                                    launchUrl(
                                      Uri.parse(
                                        "https://youtu.be/X-DNSHygTOg?si=P2qh75xtrwmuH9gm",
                                      ),
                                    );
                                  },
                                  radius: 14.0,
                                  tooltip: "View on YouTube",
                                  icon: const Icon(
                                    TablerIcons.brand_youtube,
                                    color: Colors.black,
                                    size: 18.0,
                                  ),
                                ),
                                CircleButton(
                                  onTap: () {
                                    launchUrl(
                                      Uri.parse(
                                        "https://vimeo.com/906780923?share=copy",
                                      ),
                                    );
                                  },
                                  radius: 14.0,
                                  tooltip: "View on Vimeo",
                                  icon: const Icon(
                                    TablerIcons.brand_vimeo,
                                    color: Colors.black,
                                    size: 18.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void playVideo() {
    setState(() => _showVideoCover = false);
    NavigationStateHelper.videoController.player.play();
  }
}
