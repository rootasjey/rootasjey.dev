import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/square_header.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/globals/utils.dart';
import 'package:rootasjey/router/navigation_state_helper.dart';
import 'package:rootasjey/screens/video_montage/video_item.dart';
import 'package:rootasjey/types/media_data.dart';
import 'package:wave_divider/wave_divider.dart';

class VideoMontagesPage extends StatefulWidget {
  const VideoMontagesPage({
    super.key,
    this.onGoHome,
    this.onGoBack,
  });

  /// Callback to go back to the previous page.
  final void Function()? onGoBack;

  /// Callback to go back to the home page.
  final void Function()? onGoHome;

  @override
  State<VideoMontagesPage> createState() => _VideoMontagesPageState();
}

class _VideoMontagesPageState extends State<VideoMontagesPage> {
  /// Page background color.
  final Color _backgroundColor = Constants.colors.getRandomBackground();

  final MediaData _mediaData = MediaData(
    url: "https://firebasestorage.googleapis.com/v0/b/rootasjey.appspot.com/o/"
        "videos%2Fdispatches-from-elsewhere%2Foccasionally-scared--resolution-1080p.mp4"
        "?alt=media&token=e12bc54d-2c36-4898-a5b1-92af93aadade",
    name: "Dispatches from Elsewhere",
    // name: "Occasionally Scared",
    description: "This tv series inspired me a lot artistically. "
        "Some of the subjects in the show resonated with me, and I wanted to give back something.\n"
        "I composed with the scenes that gave me the strongest feelings. I hope you enjoy it!",
    type: "video",
    index: 0,
    youtubeUrl: "https://youtu.be/X-DNSHygTOg?si=P2qh75xtrwmuH9gm",
    vimeoUrl: "https://vimeo.com/906780923?share=copy",
    coverImageUrl: "https://firebasestorage.googleapis.com/v0/b"
        "/rootasjey.appspot.com/o/videos%2Fdispatches-from-elsewhere%2Fthumbnail.jpg?alt=media&token=5335c02f-a503-44ff-87e1-01734102f054",
  );

  @override
  void initState() {
    super.initState();
    // NavigationStateHelper.player.open(
    //   Media(
    //     "https://firebasestorage.googleapis.com/v0/b/rootasjey.appspot.com/o/"
    //     "videos%2Fdispatches-from-elsewhere%2Foccasionally-scared--resolution-1080p.mp4"
    //     "?alt=media&token=e12bc54d-2c36-4898-a5b1-92af93aadade",
    //   ),
    //   play: false,
    // );
  }

  @override
  Widget build(BuildContext context) {
    final Color? foregroundColor = Theme.of(context).textTheme.bodyLarge?.color;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Size windowSize = MediaQuery.of(context).size;
    final bool isMobileSize = windowSize.width <= 800.0 ||
        windowSize.height < Utils.graphic.mobileHeightTreshold;

    return SafeArea(
      child: Scaffold(
        backgroundColor: _backgroundColor.withOpacity(0.1),
        body: Column(
          children: [
            SquareHeader(
              margin: isMobileSize
                  ? const EdgeInsets.only(top: 24.0)
                  : const EdgeInsets.only(top: 60.0),
              onGoBack: widget.onGoBack,
              onGoHome: widget.onGoHome,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 12.0,
                right: 12.0,
              ),
              child: FractionallySizedBox(
                widthFactor: isMobileSize ? 1.0 : 0.6,
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
                      textAlign: TextAlign.center,
                      style: Utils.calligraphy.body(
                        textStyle: TextStyle(
                          fontSize: isMobileSize ? 14.0 : 16.0,
                          fontWeight: FontWeight.w400,
                          color: foregroundColor?.withOpacity(0.5),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 24.0, right: 6.0),
                      child: WaveDivider(),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: isMobileSize
                  ? const EdgeInsets.symmetric(horizontal: 6.0)
                  : const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 42.0,
                    ),
              child: VideoItem(
                isDark: isDark,
                isMobileSize: isMobileSize,
                accentColor: _backgroundColor,
                videoController: NavigationStateHelper.videoController,
                margin: const EdgeInsets.all(24.0),
                mediaData: _mediaData,
                windowSize: windowSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
