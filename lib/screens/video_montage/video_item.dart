import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:rootasjey/components/buttons/circle_button.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/globals/utils.dart';
import 'package:rootasjey/types/media_data.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoItem extends StatefulWidget {
  const VideoItem({
    super.key,
    required this.videoController,
    required this.mediaData,
    this.isDark = false,
    this.isMobileSize = false,
    this.margin = EdgeInsets.zero,
    this.windowSize = Size.zero,
  });

  /// Adapt UI to dark mode if true.
  final bool isDark;

  /// Adapt UI to mobile size if true.
  final bool isMobileSize;

  /// Space around the video item.
  final EdgeInsets margin;

  /// Video controller.
  final VideoController videoController;

  /// Media data.
  final MediaData mediaData;

  /// Window size.
  final Size windowSize;

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  bool _showVideoCover = true;

  double _cardHeight = 242.0;
  double _cardWidth = 420.0;

  @override
  Widget build(BuildContext context) {
    final bool isMobileSize = widget.isMobileSize;
    _cardHeight = isMobileSize ? 220.0 : 242.0;
    _cardWidth = isMobileSize ? 400.0 : 420.0;

    final Size windowSize = widget.windowSize;
    final MediaData mediaData = widget.mediaData;
    final Color? foregroundColor =
        Theme.of(context).textTheme.bodyMedium?.color;

    final double maxWidth =
        isMobileSize ? windowSize.width : windowSize.width * 0.8;

    final double maxHeight =
        isMobileSize ? windowSize.height * 0.7 : windowSize.height * 0.6;

    final double descriptionFontSize = windowSize.width < 900.0 ? 14.0 : 16.0;

    if (windowSize.width < Utils.graphic.mobileWidthTreshold) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth,
          maxHeight: maxHeight,
        ),
        child: FractionallySizedBox(
          widthFactor: isMobileSize ? 1.0 : 0.6,
          heightFactor: 0.8,
          child: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: const TabBar(
                  tabs: [
                    Tab(icon: Icon(TablerIcons.video)),
                    Tab(icon: Icon(TablerIcons.info_circle)),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  _buildVideoCover(),
                  _buildVideoInfo(),
                ],
              ),
            ),
          ),
        ),
      );
    }

    const double cardHeight = 242.0;
    const double cardWidth = 420.0;
    final double descriptionCardWidth = windowSize.width * 0.3;

    return Padding(
      padding: widget.margin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            fit: StackFit.loose,
            children: [
              Card(
                elevation: 4.0,
                clipBehavior: Clip.hardEdge,
                color: Colors.amber,
                child: SizedBox(
                  height: cardHeight,
                  width: cardWidth,
                  child: Video(
                    aspectRatio: 16 / 9,
                    controller: widget.videoController,
                  ),
                ),
              ),
              if (_showVideoCover)
                Card(
                  elevation: 4.0,
                  clipBehavior: Clip.hardEdge,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: BorderSide(
                      color: Constants.colors.getRandomFromPalette(),
                      width: 2.0,
                    ),
                  ),
                  child: SizedBox(
                    height: cardHeight,
                    width: cardWidth,
                    child: Ink.image(
                      fit: BoxFit.cover,
                      image: NetworkImage(mediaData.coverImageUrl),
                      child: InkWell(
                        onTap: onPlayVideo,
                        child: Center(
                          child: CircleButton(
                            onTap: onPlayVideo,
                            icon: const Icon(
                              TablerIcons.player_play,
                              color: Colors.white,
                              size: 24.0,
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
            margin: const EdgeInsets.only(left: 24.0),
            child: Container(
              height: 242.0,
              width: descriptionCardWidth,
              padding: const EdgeInsets.all(24.0),
              child: ListView(
                children: [
                  Text(
                    mediaData.name,
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
                      TextSpan(
                        text: "",
                        children: [
                          TextSpan(
                            text: mediaData.description,
                          ),
                        ],
                      ),
                      style: Utils.calligraphy.body(
                        textStyle: TextStyle(
                          fontSize: descriptionFontSize,
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
                                mediaData.youtubeUrl,
                              ),
                            );
                          },
                          radius: 14.0,
                          tooltip: "View on YouTube",
                          backgroundColor:
                              widget.isDark ? Colors.white12 : Colors.black12,
                          icon: Icon(
                            TablerIcons.brand_youtube,
                            color: widget.isDark ? Colors.white : Colors.black,
                            size: 18.0,
                          ),
                        ),
                        CircleButton(
                          onTap: () {
                            launchUrl(
                              Uri.parse(
                                mediaData.vimeoUrl,
                              ),
                            );
                          },
                          radius: 14.0,
                          tooltip: "View on Vimeo",
                          backgroundColor:
                              widget.isDark ? Colors.white12 : Colors.black12,
                          icon: Icon(
                            TablerIcons.brand_vimeo,
                            color: widget.isDark ? Colors.white : Colors.black,
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
    );
  }

  void onPlayVideo() {
    setState(() {
      _showVideoCover = false;
    });

    widget.videoController.player.play();
  }

  _buildVideoCover() {
    return Center(
      child: Stack(
        children: [
          Card(
            elevation: 4.0,
            clipBehavior: Clip.hardEdge,
            color: Colors.amber,
            child: SizedBox(
              height: _cardHeight,
              width: _cardWidth,
              child: Video(
                aspectRatio: 16 / 9,
                controller: widget.videoController,
              ),
            ),
          ),
          if (_showVideoCover)
            Card(
              elevation: 4.0,
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide(
                  color: Constants.colors.getRandomFromPalette(),
                  width: 2.0,
                ),
              ),
              child: SizedBox(
                height: _cardHeight,
                width: _cardWidth,
                child: Ink.image(
                  fit: BoxFit.cover,
                  image: NetworkImage(widget.mediaData.coverImageUrl),
                  child: InkWell(
                    onTap: onPlayVideo,
                    child: Center(
                      child: CircleButton(
                        onTap: onPlayVideo,
                        icon: const Icon(
                          TablerIcons.player_play,
                          color: Colors.white,
                          size: 24.0,
                        ),
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

  _buildVideoInfo() {
    final Color? foregroundColor =
        Theme.of(context).textTheme.bodyMedium?.color;
    final MediaData mediaData = widget.mediaData;

    return Card(
      elevation: 0.0,
      child: Container(
        height: _cardHeight,
        width: _cardWidth,
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mediaData.name,
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
                TextSpan(
                  text: "",
                  children: [
                    TextSpan(
                      text: mediaData.description,
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
                          mediaData.youtubeUrl,
                        ),
                      );
                    },
                    radius: 14.0,
                    tooltip: "View on YouTube",
                    backgroundColor:
                        widget.isDark ? Colors.white12 : Colors.black12,
                    icon: Icon(
                      TablerIcons.brand_youtube,
                      color: widget.isDark ? Colors.white : Colors.black,
                      size: 18.0,
                    ),
                  ),
                  CircleButton(
                    onTap: () {
                      launchUrl(
                        Uri.parse(
                          mediaData.vimeoUrl,
                        ),
                      );
                    },
                    radius: 14.0,
                    tooltip: "View on Vimeo",
                    backgroundColor:
                        widget.isDark ? Colors.white12 : Colors.black12,
                    icon: Icon(
                      TablerIcons.brand_vimeo,
                      color: widget.isDark ? Colors.white : Colors.black,
                      size: 18.0,
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
}
