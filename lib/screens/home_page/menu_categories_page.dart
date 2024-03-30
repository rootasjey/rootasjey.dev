import 'package:change_case/change_case.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rootasjey/components/square_header.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/globals/utils.dart';
import 'package:rootasjey/screens/art/art_button.dart';
import 'package:rootasjey/screens/illustrations_page/illustrations_page.dart';
import 'package:rootasjey/screens/projects_page/projects_page.dart';
import 'package:rootasjey/screens/video_montage/video_montages_page.dart';
import 'package:wave_divider/wave_divider.dart';

class MenuCategoriesPage extends StatelessWidget {
  const MenuCategoriesPage({
    super.key,
    this.onTapCategory,
    this.onGoBack,
    this.onGoHome,
  });

  /// Callback to go back to the previous page.
  final void Function()? onGoBack;

  /// Callback to go back to the home page.
  final void Function()? onGoHome;

  /// Callback to go to a specific page.
  final void Function(String name)? onTapCategory;

  @override
  Widget build(BuildContext context) {
    final Color? foregroundColor = Theme.of(context).textTheme.bodyLarge?.color;
    final bool isMobileSize = Utils.graphic.isMobileSize(context);

    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 16.0),
          ),
          child: Column(
            children: [
              SquareHeader(
                margin: const EdgeInsets.only(top: 60.0),
                onGoBack: onGoBack,
                onGoHome: onGoHome,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 12.0,
                  right: 12.0,
                ),
                child: FractionallySizedBox(
                  widthFactor: isMobileSize ? 0.8 : 0.6,
                  child: Column(
                    children: [
                      Text(
                        "creative.name".tr().toUpperCase(),
                        style: Utils.calligraphy.body2(
                          textStyle: const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        "art.subtitle".tr(),
                        textAlign:
                            isMobileSize ? TextAlign.center : TextAlign.start,
                        style: Utils.calligraphy.body(
                          textStyle: TextStyle(
                            fontSize: isMobileSize ? 14.0 : 16.0,
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
                padding: const EdgeInsets.only(bottom: 42.0),
                child: Column(
                  children: [
                    ArtButton(
                      isMobileSize: isMobileSize,
                      onPressed: () => onTapCategory?.call(
                        const ProjectsPage().toString().toKebabCase(),
                      ),
                      accentColor: Constants.colors.art,
                      textTitle: "project.names".tr().toLowerCase(),
                    ),
                    ArtButton(
                      isMobileSize: isMobileSize,
                      onPressed: () => onTapCategory?.call(
                          const IllustrationsPage().toString().toKebabCase()),
                      accentColor: Constants.colors.art,
                      textTitle: "illustration.names".tr().toLowerCase(),
                    ),
                    ArtButton(
                      isMobileSize: isMobileSize,
                      onPressed: () => onTapCategory?.call(
                        const VideoMontagesPage().toString().toKebabCase(),
                      ),
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
