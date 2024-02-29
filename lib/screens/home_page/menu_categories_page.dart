import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:rootasjey/components/icons/app_icon.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/globals/utils.dart';
import 'package:rootasjey/screens/art/art_button.dart';
import 'package:wave_divider/wave_divider.dart';

class MenuCategoriesPage extends StatelessWidget {
  const MenuCategoriesPage({
    super.key,
    this.onTapCategory,
  });

  final void Function(String name)? onTapCategory;

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
              // color: _accentColor,
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
                          onPressed: () {},
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
                      onPressed: () {},
                      accentColor: Constants.colors.art,
                      textTitle: "projects".tr().toLowerCase(),
                    ),
                    ArtButton(
                      onPressed: () {},
                      accentColor: Constants.colors.art,
                      textTitle: "illustrations".tr().toLowerCase(),
                    ),
                    ArtButton(
                      onPressed: () {},
                      accentColor: Constants.colors.videoMontage,
                      textTitle: "video_montage.names".tr().toLowerCase(),
                    ),
                  ]
                      .animate(interval: const Duration(milliseconds: 25))
                      .fadeIn(
                        begin: 0.0,
                        duration: const Duration(milliseconds: 150),
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
