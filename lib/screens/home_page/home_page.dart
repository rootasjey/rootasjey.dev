import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_improved_scrolling/flutter_improved_scrolling.dart';
import 'package:particles_flutter/particles_flutter.dart';
import 'package:rootasjey/router/locations/illustrations_location.dart';
import 'package:rootasjey/screens/home_page/about_me.dart';
import 'package:rootasjey/components/application_bar.dart';
import 'package:rootasjey/components/bezier_clipper.dart';
import 'package:rootasjey/components/buttons/fab_to_top.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/router/locations/posts_location.dart';
import 'package:rootasjey/router/locations/projects_location.dart';
import 'package:rootasjey/screens/home_page/github_activities.dart';
import 'package:rootasjey/screens/home_page/project_section.dart';
import 'package:rootasjey/types/enums/enum_direction.dart';
import 'package:rootasjey/utils/custom_scroll_bahavior.dart';
import 'package:rootasjey/globals/utilities.dart';
import 'package:unicons/unicons.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// This is used to adapt the FAB UI.
  EnumDirection _enumDirection = EnumDirection.down;

  /// Can be an arrow up or down.
  Icon _fabIcon = const Icon(UniconsLine.arrow_down);

  /// Page scroll controller to programmatically scroll the UI.
  final ScrollController _pageScrollController = ScrollController();

  @override
  void dispose() {
    _pageScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: FabToTop(
        fabIcon: _fabIcon,
        backgroundColor: Constants.colors.palette.first,
        pageScrollController: _pageScrollController,
      ),
      body: ImprovedScrolling(
        enableKeyboardScrolling: true,
        enableMMBScrolling: true,
        onScroll: onScroll,
        scrollController: _pageScrollController,
        child: ScrollConfiguration(
          behavior: const CustomScrollBehaviour(),
          child: CustomScrollView(
            controller: _pageScrollController,
            slivers: [
              ApplicationBar(
                backgroundColor: Colors.black45,
                padding: getAppBarPadding(size),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Stack(
                    children: [
                      CircularParticle(
                        height: size.height - 200.0,
                        width: size.width,
                        isRandSize: true,
                        maxParticleSize: 8.0,
                        speedOfParticles: 0.2,
                        numberOfParticles: 6.0,
                        onTapAnimation: true,
                        isRandomColor: true,
                        randColorList: Constants.colors.palette
                            .map((Color color) => color.withOpacity(1.0))
                            .toList(),
                      ),
                      heroWidget(size: size),
                    ],
                  ),
                ),
              ),
              ProjectSection(size: size),
              GitHubActivities(size: size),
              AboutMe(size: size),
              const SliverPadding(
                padding: EdgeInsets.only(bottom: 200.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget heroWidget({required Size size}) {
    return Stack(
      children: [
        Positioned.fill(
          top: -48.0,
          child: Opacity(
            opacity: 0.8,
            child: ClipPath(
              clipper: const BezierClipper(1),
              child: Container(
                color: Colors.black54,
              ),
            ),
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: size.height - 100.0,
          ),
          child: Padding(
            padding: getHeroPadding(size),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 600.0,
                    child: Text.rich(
                      TextSpan(text: "home_hero_title_parts.0".tr(), children: [
                        WidgetSpan(
                          child: InkWell(
                            onTap: onTapColoredWord,
                            child: Text(
                              "home_hero_title_parts.1".tr(),
                              style: Utilities.fonts.body(
                                textStyle: TextStyle(
                                  color: Constants.colors.palette.first,
                                  fontSize: getHeroFontSize(size),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        TextSpan(text: "home_hero_title_parts.2".tr()),
                        WidgetSpan(
                          child: InkWell(
                            onTap: onTapColoredWord,
                            child: Text(
                              "home_hero_title_parts.3".tr(),
                              style: Utilities.fonts.body(
                                textStyle: TextStyle(
                                  color: Constants.colors.palette.elementAt(1),
                                  fontSize: getHeroFontSize(size),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
                      style: Utilities.fonts.body(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: getHeroFontSize(size),
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Opacity(
                      opacity: 0.4,
                      child: Text(
                        "home_hero_subtitle".tr(),
                        style: Utilities.fonts.body3(
                          textStyle: TextStyle(
                            fontSize: getSubtitleFontSize(size),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Wrap(
                      spacing: 16.0,
                      runSpacing: 12.0,
                      children: [
                        navigationButton(
                          label: "projects".tr(),
                          onPressed: () {
                            Beamer.of(context).beamToNamed(
                              ProjectsLocation.route,
                            );
                          },
                        ),
                        navigationButton(
                          label: "posts".tr(),
                          onPressed: () {
                            Beamer.of(context).beamToNamed(PostsLocation.route);
                          },
                        ),
                        navigationButton(
                          label: "illustrations".tr(),
                          onPressed: () {
                            Beamer.of(context).beamToNamed(
                              IllustrationsLocation.route,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Wrap(
                      spacing: 12.0,
                      runSpacing: 12.0,
                      children: [
                        socialNetworkItem(
                          iconData: UniconsLine.medium_m,
                          url: "https://medium.com/@rootasjey",
                        ),
                        socialNetworkItem(
                          iconData: UniconsLine.github,
                          url: "https://github.com/rootasjey",
                        ),
                        socialNetworkItem(
                          iconData: UniconsLine.twitter,
                          url: "https://twitter.com/rootasjey",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget navigationButton({
    required void Function() onPressed,
    required String label,
  }) {
    return Material(
      elevation: 6.0,
      color: Colors.black45,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: Colors.pink,
          ),
          child: Text(
            "→ $label",
            style: Utilities.fonts.code(
              textStyle: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget socialNetworkItem({
    required IconData iconData,
    required String url,
  }) {
    return IconButton(
      onPressed: () => launchUrl(Uri.parse(url)),
      icon: Icon(iconData),
    );
  }

  EdgeInsets getAppBarPadding(Size size) {
    if (size.width < Utilities.size.mobileWidthTreshold) {
      return const EdgeInsets.only(left: 0.0, top: 24.0);
    }

    if (size.width < 1000.0) {
      return const EdgeInsets.only(left: 36.0, top: 24.0);
    }

    return const EdgeInsets.only(left: 170.0, top: 24.0, right: 80.0);
  }

  double getHeroFontSize(Size size) {
    if (size.width < Utilities.size.mobileWidthTreshold) {
      return 54.0;
    }

    return 72.0;
  }

  double getSubtitleFontSize(Size size) {
    if (size.width < Utilities.size.mobileWidthTreshold) {
      return 18.0;
    }

    return 26.0;
  }

  EdgeInsets getHeroPadding(Size size) {
    if (size.width < Utilities.size.mobileWidthTreshold) {
      return const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 36.0,
        bottom: 10.0,
      );
    }

    if (size.width < 1000.0) {
      return const EdgeInsets.only(
        left: 42.0,
        top: 36.0,
        bottom: 10.0,
      );
    }

    return const EdgeInsets.only(
      left: 200.0,
      top: 0.0,
      bottom: 10.0,
    );
  }

  void onScroll(double offset) {
    if (offset == 0) {
      setState(() {
        _fabIcon = const Icon(UniconsLine.arrow_down);
        _enumDirection = EnumDirection.down;
      });

      return;
    }

    if (_enumDirection == EnumDirection.up) {
      return;
    }

    setState(() {
      _fabIcon = const Icon(UniconsLine.arrow_up);
      _enumDirection = EnumDirection.up;
    });
  }

  void onTapColoredWord() {
    setState(() {
      Constants.colors.palette.shuffle();
    });
  }
}