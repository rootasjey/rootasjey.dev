import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:rootasjey/components/icons/app_icon.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/globals/utils.dart';
import 'package:rootasjey/router/locations/art_location.dart';
import 'package:rootasjey/screens/art/art_button.dart';
import 'package:wave_divider/wave_divider.dart';

class ArtPage extends StatefulWidget {
  const ArtPage({super.key});

  @override
  State<ArtPage> createState() => _ArtPageState();
}

class _ArtPageState extends State<ArtPage> {
  Color _accentColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    _accentColor = Constants.colors.getRandomBackground();
  }

  @override
  Widget build(BuildContext context) {
    final Color? foregroundColor = Theme.of(context).textTheme.bodyLarge?.color;
    final bool isMobileSize = Utils.measurements.isMobileSize(context);

    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 16.0,
              color: _accentColor,
            ),
          ),
          child: CustomScrollView(
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
                          "art.name".tr().toUpperCase(),
                          style: Utils.calligraphy.body2(
                            textStyle: const TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          "art.subtitle".tr(),
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
                padding: const EdgeInsets.only(top: 42.0, bottom: 42.0),
                sliver: SliverList.list(
                  children: [
                    ArtButton(
                      onPressed: () => context.beamToNamed(
                        ArtLocation.illustrationsRoute,
                      ),
                      accentColor: Constants.colors.art,
                      textTitle: "illustrations".tr().toLowerCase(),
                    ),
                    ArtButton(
                      onPressed: () {
                        context.beamToNamed(ArtLocation.videoMontagesRoute);
                      },
                      accentColor: Constants.colors.videoMontage,
                      textTitle: "video_montage.names".tr().toLowerCase(),
                    ),
                    ArtButton(
                      onPressed: () {
                        context.beamToNamed(ArtLocation.terrariumsRoute);
                      },
                      accentColor: Constants.colors.terrarium,
                      textTitle: "terrarium.names".tr().toLowerCase(),
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
      ),
    );
  }
}
