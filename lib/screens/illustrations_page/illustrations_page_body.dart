import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:rootasjey/components/icons/app_icon.dart';
import 'package:rootasjey/components/illustration_card.dart';
import 'package:rootasjey/components/upload_panel/upload_panel.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/globals/utils.dart';
import 'package:rootasjey/types/illustration/illustration.dart';
import 'package:super_context_menu/super_context_menu.dart';
import 'package:wave_divider/wave_divider.dart';

class IllustrationsPageBody extends StatelessWidget {
  const IllustrationsPageBody({
    super.key,
    required this.illustrations,
    this.expandLicensePanel = false,
    this.accentColor = Colors.blue,
    this.onSelectFiles,
    this.fab,
    this.onDeleteIllustration,
    this.onTapIllustration,
    this.windowSize = Size.zero,
    this.onToggleExpandLicensePanel,
    this.onGoToExternalLicense,
    this.onTapAppIcon,
  });

  final bool expandLicensePanel;

  /// Accent color for border and title.
  final Color accentColor;

  /// Callback fired when the user clicks to expand the license panel.
  final void Function()? onToggleExpandLicensePanel;

  /// Callback fired to upload new illustrations.
  final void Function()? onSelectFiles;

  /// Callback fired when an illustration card is tapped.
  final void Function(Illustration illustration)? onTapIllustration;

  /// Navigate to the external license page.
  final void Function()? onGoToExternalLicense;

  /// Callback fired when an illustration is deleted.
  final void Function(Illustration illustration, int index)?
      onDeleteIllustration;

  /// Callback fired when the user goes back to the home page.
  final void Function()? onTapAppIcon;

  /// Illustration list.
  final List<Illustration> illustrations;

  /// Window's size.
  final Size windowSize;

  /// Floating Action Button to show at the bottom right of this page.
  final Widget? fab;

  @override
  Widget build(BuildContext context) {
    const double badgeWidth = 24.0;
    final Color? foregroundColor =
        Theme.of(context).textTheme.bodyMedium?.color;

    return Scaffold(
      floatingActionButton: fab,
      body: Container(
        height: windowSize.height,
        decoration: BoxDecoration(
          border: Border.all(
            width: 16.0,
            color: accentColor,
          ),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Utils.graphic.tooltip(
                        tooltipString: "home".tr(),
                        child: AppIcon(
                          size: 24.0,
                          margin: const EdgeInsets.only(right: 12.0),
                          onTap: onTapAppIcon,
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
                  child: Column(
                    children: [
                      Text(
                        "illustrations".tr().toUpperCase(),
                        style: Utils.calligraphy.body2(
                          textStyle: const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        "illustrations_subtitle".tr(),
                        style: Utils.calligraphy.body(
                          textStyle: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: foregroundColor?.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    TextButton(
                      onPressed: () => onToggleExpandLicensePanel?.call(),
                      child: Text(
                        "This work is licensed under CC BY-SA 4.0",
                        style: Utils.calligraphy.body(
                          textStyle: TextStyle(
                            color: foregroundColor?.withOpacity(0.6),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.decelerate,
                      child: Container(
                        height: expandLicensePanel ? null : 0.0,
                        width: 600.0,
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WaveDivider(
                              color: Constants.colors.getRandomBackground(),
                            ),
                            Wrap(
                              spacing: 12.0,
                              runSpacing: 12.0,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                SvgPicture.network(
                                  "https://chooser-beta.creativecommons.org/img/cc-logo.f0ab4ebe.svg",
                                  width: badgeWidth,
                                  height: badgeWidth,
                                  color: foregroundColor?.withOpacity(0.8),
                                ),
                                SvgPicture.network(
                                  "https://chooser-beta.creativecommons.org/img/cc-by.21b728bb.svg",
                                  width: badgeWidth,
                                  height: badgeWidth,
                                  color: foregroundColor?.withOpacity(0.8),
                                ),
                                SvgPicture.network(
                                  "https://chooser-beta.creativecommons.org/img/cc-sa.d1572b71.svg",
                                  width: badgeWidth,
                                  height: badgeWidth,
                                  color: foregroundColor?.withOpacity(0.8),
                                ),
                                Text(
                                  "CC BY-SA 4.0",
                                  style: Utils.calligraphy.body(
                                    textStyle: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.w400,
                                      color: foregroundColor?.withOpacity(0.6),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "Attribution-ShareAlike 4.0 International",
                              style: Utils.calligraphy.body4(
                                textStyle: const TextStyle(
                                  fontSize: 42.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Text(
                                "This license requires that reusers give credit "
                                "to the creator. It allows reusers to distribute,"
                                " remix, adapt, and build upon the material in "
                                "any medium or format, even for commercial "
                                "purposes. If others remix, adapt, or build upon "
                                "the material, they must license the modified "
                                "material under identical terms.",
                                style: Utils.calligraphy.body4(
                                  textStyle: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w400,
                                    color: foregroundColor?.withOpacity(0.6),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 24.0),
                              child: TextButton(
                                onPressed: onGoToExternalLicense,
                                style: TextButton.styleFrom(
                                  shape: const BeveledRectangleBorder(),
                                  backgroundColor: Constants.colors
                                      .getRandomBackground()
                                      .withOpacity(0.4),
                                ),
                                child: Text(
                                  "https://creativecommons.org/licenses/by-sa/4.0",
                                  style: Utils.calligraphy.body(
                                    textStyle: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: foregroundColor?.withOpacity(0.6),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(42.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: illustrations.length,
                    itemBuilder: (context, index) {
                      final Illustration illustration = illustrations.elementAt(
                        index,
                      );

                      return ContextMenuWidget(
                        menuProvider: (MenuRequest request) {
                          return Menu(
                            children: [
                              MenuAction(
                                title: "delete".tr(),
                                image: MenuImage.icon(TablerIcons.trash),
                                callback: () => onDeleteIllustration?.call(
                                  illustration,
                                  index,
                                ),
                              ),
                            ],
                          );
                        },
                        child: IllustrationCard(
                          illustration: illustration,
                          index: index,
                          heroTag: illustration.id,
                          onTap: onTapIllustration != null
                              ? () => onTapIllustration?.call(illustration)
                              : null,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      );
                    },
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 140.0,
                      mainAxisSpacing: 24.0,
                      crossAxisSpacing: 24.0,
                    ),
                  ),
                ),
              ],
            ),
            const Positioned(
              bottom: 24.0,
              left: 24.0,
              child: UploadPanel(),
            ),
          ],
        ),
      ),
    );
  }

  SliverGridDelegate getGridDelegate() {
    if (windowSize.width < Utils.measurements.mobileWidthTreshold) {
      return const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12.0,
        crossAxisSpacing: 12.0,
      );
    }

    return const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      mainAxisSpacing: 42.0,
      crossAxisSpacing: 42.0,
    );
  }
}
