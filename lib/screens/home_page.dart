import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_improved_scrolling/flutter_improved_scrolling.dart';
import 'package:lottie/lottie.dart';
import 'package:rootasjey/components/about_me.dart';
import 'package:rootasjey/components/application_bar.dart';
import 'package:rootasjey/components/buttons/fab_to_top.dart';
import 'package:rootasjey/components/github_activities.dart';
import 'package:rootasjey/components/project_section.dart';
import 'package:rootasjey/globals/constants.dart';
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
  final ScrollController _pageScrollController = ScrollController();
  Icon _fabIcon = const Icon(UniconsLine.arrow_down);

  EnumDirection _enumDirection = EnumDirection.down;

  @override
  void initState() {
    super.initState();
    Constants.colors.palette.shuffle();
  }

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
              const ApplicationBar(),
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    Lottie.asset(
                      "assets/animations/particles.json",
                      height: size.height - 100.0,
                      width: size.width,
                    ),
                    heroWidget(size: size),
                  ],
                ),
              ),
              const ProjectSection(),
              const GitHubActivities(),
              const AboutMe(),
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
    return Container(
      height: size.height - 100.0,
      padding: const EdgeInsets.only(
        left: 200.0,
        bottom: 10.0,
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 600.0,
              child: Text.rich(
                TextSpan(text: "A random personnal ", children: [
                  TextSpan(
                    text: "space ",
                    style: Utilities.fonts.body1(
                      color: Constants.colors.palette.first,
                      fontSize: 72.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const TextSpan(text: "lost in a "),
                  TextSpan(
                    text: "galaxy.",
                    style: Utilities.fonts.body1(
                      color: Constants.colors.palette.elementAt(1),
                      fontSize: 72.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ]),
                style: Utilities.fonts.body1(
                  fontWeight: FontWeight.w700,
                  fontSize: 72.0,
                  height: 1.2,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Opacity(
                opacity: 0.4,
                child: Text(
                  "This space won't outrun time though\n"
                  "So we should enjoy ourselves while we're alive",
                  style: Utilities.fonts.body3(
                    fontSize: 26.0,
                    fontWeight: FontWeight.w400,
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
                    label: "Projects",
                    onPressed: () {
                      Beamer.of(context).beamToNamed("/projects");
                    },
                  ),
                  navigationButton(label: "Posts", onPressed: () {}),
                  navigationButton(label: "Drawings", onPressed: () {}),
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
                    url: "",
                  ),
                  socialNetworkItem(
                    iconData: UniconsLine.github,
                    url: "https://github.com/rootasjey",
                  ),
                  socialNetworkItem(
                    iconData: UniconsLine.twitter,
                    url: "",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
            style: Utilities.fonts.body4(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
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
}
