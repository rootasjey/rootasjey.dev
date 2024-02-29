import 'package:flutter/material.dart';
import 'package:flutter_improved_scrolling/flutter_improved_scrolling.dart';
import 'package:rootasjey/screens/home_page/home_art.dart';
import 'package:rootasjey/screens/home_page/home_header.dart';
import 'package:rootasjey/screens/home_page/home_posts.dart';
import 'package:rootasjey/screens/home_page/home_projects.dart';
import 'package:rootasjey/screens/home_page/home_social_links.dart';
import 'package:rootasjey/utils/custom_scroll_bahavior.dart';

class HomePageBody extends StatelessWidget {
  const HomePageBody({
    super.key,
    required this.pageScrollController,
    this.onScroll,
    this.accentColor = Colors.blue,
    this.backgroundColor,
    this.onShuffleColor,
    this.onTapHireMeButton,
    this.onTapArt,
  });

  /// Accent color for border and title.
  final Color accentColor;

  /// Background color.
  final Color? backgroundColor;

  /// Callback called while scrolling.
  final void Function(double)? onScroll;

  /// Callback called when the user clicks on the shuffle color button.
  final void Function()? onShuffleColor;

  /// Callback called when the user clicks on the art button.
  final void Function()? onTapArt;

  /// Callback called when the user clicks on the hire me button.
  final void Function()? onTapHireMeButton;

  /// Page scroll controller to programmatically scroll the UI.
  final ScrollController pageScrollController;

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    final bool isDark = brightness == Brightness.dark;
    final Size windowSize = MediaQuery.of(context).size;

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(seconds: 1),
        decoration: BoxDecoration(
          color: isDark ? null : backgroundColor,
          border: Border.all(
            width: 16.0,
            color: isDark ? accentColor : Colors.black,
          ),
        ),
        child: ImprovedScrolling(
          enableKeyboardScrolling: true,
          enableMMBScrolling: true,
          onScroll: onScroll,
          scrollController: pageScrollController,
          child: ScrollConfiguration(
            behavior: const CustomScrollBehaviour(),
            child: CustomScrollView(
              controller: pageScrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: windowSize.height - 100.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HomeHeader(
                          accentColor: accentColor,
                          onShuffleColor: onShuffleColor,
                          onTapHireMeButton: onTapHireMeButton,
                          isDark: isDark,
                          margin: const EdgeInsets.only(
                            top: 42.0,
                            left: 42.0,
                            right: 42.0,
                            bottom: 24.0,
                          ),
                        ),
                        const HomeProjects(
                          margin: EdgeInsets.symmetric(
                            horizontal: 42.0,
                            vertical: 12.0,
                          ),
                        ),
                        HomeArt(
                          onTapTitle: onTapArt,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 42.0,
                            vertical: 0.0,
                          ),
                        ),
                        const HomePosts(
                          margin: EdgeInsets.symmetric(
                            horizontal: 42.0,
                            vertical: 0.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                HomeSocialLinks(
                  isDark: isDark,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 42.0,
                    vertical: 42.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
