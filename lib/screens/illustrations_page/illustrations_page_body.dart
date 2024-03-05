import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:rootasjey/components/icons/app_icon.dart';
import 'package:rootasjey/components/illustration_card.dart';
import 'package:rootasjey/components/upload_panel/upload_panel.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/globals/utils.dart';
import 'package:rootasjey/types/enums/enum_page_state.dart';
import 'package:rootasjey/types/illustration/illustration.dart';
import 'package:super_context_menu/super_context_menu.dart';
import 'package:wave_divider/wave_divider.dart';

class IllustrationsPageBody extends StatelessWidget {
  const IllustrationsPageBody({
    super.key,
    required this.illustrations,
    this.expandLicensePanel = false,
    this.hasNext = false,
    this.accentColor = Colors.blue,
    this.pageState = EnumPageState.idle,
    this.currentPage = 0,
    this.totalPage = 0,
    this.onDeleteIllustration,
    this.onTapIllustration,
    this.onSelectFiles,
    this.onToggleExpandLicensePanel,
    this.onGoToExternalLicense,
    this.onTapAppIcon,
    this.onPreviousPage,
    this.onNextPage,
    this.windowSize = Size.zero,
    this.fab,
  });

  /// True if the license panel should be expanded.
  final bool expandLicensePanel;

  /// True if there're more illustrations to fetch.
  final bool hasNext;

  /// Accent color for border and title.
  final Color accentColor;

  /// Current page of the illustration list.
  final int currentPage;

  /// Total page of the illustration list.
  final int totalPage;

  final EnumPageState pageState;

  /// Callback fired when the user clicks to expand the license panel.
  final void Function()? onToggleExpandLicensePanel;

  /// Callback fired to upload new illustrations.
  final void Function()? onSelectFiles;

  /// Callback fired when an illustration card is tapped.
  final void Function(Illustration illustration)? onTapIllustration;

  /// Navigate to the external license page.
  final void Function()? onGoToExternalLicense;

  /// Callback fired when the user goes back to the previous page.
  final void Function()? onPreviousPage;

  /// Callback fired when the user goes back to the next page.
  final void Function()? onNextPage;

  /// Callback fired when an illustration is deleted.
  final void Function(
    Illustration illustration,
    int index,
  )? onDeleteIllustration;

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
    int index = -1;
    const double badgeWidth = 18.0;
    final Color? foregroundColor =
        Theme.of(context).textTheme.bodyMedium?.color;

    double wrapWidth = (100 * 3) + (12 * 2);
    if (windowSize.height < 600.0) {
      wrapWidth = windowSize.width * 0.9;
    }

    final bool isExtremMinHeight = windowSize.height < 460.0;
    final bool showGrid = pageState == EnumPageState.idle;
    final bool showPaginationButtons =
        (!expandLicensePanel) && pageState == EnumPageState.idle;

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
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 12.0),
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
                  Container(
                    width: 440.0,
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
                        onPressed: onToggleExpandLicensePanel,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            accentColor.withOpacity(0.6),
                          ),
                        ),
                        child: Text(
                          "This work is licensed under CC BY-SA 4.0",
                          style: Utils.calligraphy.body(
                            textStyle: TextStyle(
                              color: foregroundColor?.withOpacity(0.6),
                              fontSize: 14.0,
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
                          width: 440.0,
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              WaveDivider(
                                color: accentColor,
                              ),
                              Container(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: InkWell(
                                  onTap: onToggleExpandLicensePanel,
                                  borderRadius: BorderRadius.circular(24.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24.0),
                                      color: accentColor,
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Icon(
                                        TablerIcons.x,
                                        size: 18.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
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
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w400,
                                        color:
                                            foregroundColor?.withOpacity(0.6),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "Attribution-ShareAlike 4.0 International",
                                style: Utils.calligraphy.body3(
                                  textStyle: const TextStyle(
                                    fontSize: 20.0,
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
                                  style: Utils.calligraphy.body3(
                                    textStyle: TextStyle(
                                      fontSize: 16.0,
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
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            foregroundColor?.withOpacity(0.6),
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
                  if (showGrid)
                    AnimatedSize(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.decelerate,
                      child: Container(
                        width: expandLicensePanel ? 0.0 : wrapWidth,
                        height: expandLicensePanel ? 0.0 : null,
                        padding: const EdgeInsets.only(top: 42.0),
                        child: Wrap(
                          spacing: 12.0,
                          runSpacing: 12.0,
                          alignment: isExtremMinHeight
                              ? WrapAlignment.center
                              : WrapAlignment.start,
                          children: illustrations
                              .map((Illustration illustration) {
                                index++;
                                return ContextMenuWidget(
                                  menuProvider: (MenuRequest request) {
                                    return Menu(
                                      children: [
                                        MenuAction(
                                          title: "delete".tr(),
                                          image:
                                              MenuImage.icon(TablerIcons.trash),
                                          callback: () =>
                                              onDeleteIllustration?.call(
                                            illustration,
                                            index,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                  child: IllustrationCard(
                                    size: isExtremMinHeight ? 60.0 : 100.0,
                                    illustration: illustration,
                                    index: index,
                                    heroTag: illustration.id,
                                    onTap: onTapIllustration != null
                                        ? () => onTapIllustration
                                            ?.call(illustration)
                                        : null,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                );
                              })
                              .toList()
                              .animate(
                                interval: const Duration(milliseconds: 25),
                              )
                              .slideY(
                                begin: 2.0,
                                end: 0.0,
                                curve: Curves.decelerate,
                              )
                              .fadeIn(begin: 0.0),
                        ),
                      ),
                    ),
                  if (showPaginationButtons)
                    Container(
                      width: wrapWidth,
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Row(
                        mainAxisAlignment: isExtremMinHeight
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.start,
                        children: [
                          Utils.graphic.tooltip(
                            tooltipString: "previous page",
                            child: IconButton(
                              onPressed:
                                  currentPage == 0 ? null : onPreviousPage,
                              icon: const Icon(TablerIcons.arrow_left),
                            ),
                          ),
                          Utils.graphic.tooltip(
                            tooltipString: "next page",
                            child: IconButton(
                              onPressed: (hasNext || currentPage < totalPage)
                                  ? onNextPage
                                  : null,
                              color: foregroundColor?.withOpacity(0.8),
                              icon: const Icon(TablerIcons.arrow_right),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
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
}
