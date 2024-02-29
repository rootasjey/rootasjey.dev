import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:rootasjey/components/icons/app_icon.dart';
import 'package:rootasjey/globals/utils.dart';
import 'package:wave_divider/wave_divider.dart';

class VideoMontagesPage extends StatefulWidget {
  const VideoMontagesPage({super.key});

  @override
  State<VideoMontagesPage> createState() => _VideoMontagesPageState();
}

class _VideoMontagesPageState extends State<VideoMontagesPage> {
  @override
  Widget build(BuildContext context) {
    final bool isMobileSize = Utils.measurements.isMobileSize(context);
    final Color? foregroundColor = Theme.of(context).textTheme.bodyLarge?.color;

    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
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
            ),
            SliverToBoxAdapter(
              child: Padding(
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
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                vertical: 36.0,
                horizontal: 48.0,
              ),
              sliver: SliverList.list(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 6.0,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(
                          Radius.circular(4.0),
                        ),
                      ),
                      child: Text(
                        "Spoiler free",
                        style: Utils.calligraphy.body(
                          textStyle: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            // backgroundColor: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    "Dispatches From Elsewhere",
                    style: Utils.calligraphy.title(
                      textStyle: TextStyle(
                        fontSize: 80.0,
                        fontWeight: FontWeight.w600,
                        color: foregroundColor,
                        height: 1.2,
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
                                "This tv series had a real impact on my life.",
                          ),
                        ],
                      ),
                      style: Utils.calligraphy.body(
                        textStyle: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w400,
                          color: foregroundColor?.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 24.0),
                    child: Card(
                      color: Colors.amber,
                      child: InkWell(
                        child: SizedBox(height: 500.0, width: 600.0),
                      ),
                    ),
                  ),
                ]
                    .animate(interval: 25.ms)
                    .fadeIn(
                      begin: 0.0,
                      duration: 150.ms,
                      curve: Curves.decelerate,
                    )
                    .slideY(begin: 1.0, end: 0.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
