import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_improved_scrolling/flutter_improved_scrolling.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:loggy/loggy.dart';
import 'package:rootasjey/components/icons/app_icon.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/globals/utils.dart';
import 'package:rootasjey/screens/home_page/text_home_projects.dart';
import 'package:rootasjey/screens/signin_page/simple_signin_page.dart';
import 'package:rootasjey/utils/custom_scroll_bahavior.dart';
import 'package:url_launcher/url_launcher.dart';

class TextHomePage extends StatefulWidget with UiLoggy {
  const TextHomePage({
    super.key,
    this.onGoToPage,
    this.onGoBack,
  });

  /// Callback to go to a specific page.
  final void Function(String pageName)? onGoToPage;

  /// Callback to go back.
  final void Function()? onGoBack;

  @override
  State<TextHomePage> createState() => _TextHomePageState();
}

class _TextHomePageState extends State<TextHomePage> {
  /// Background color.
  Color _backgroundColor = Colors.blue.shade50;

  final ScrollController _pageScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // _backgroundColor = Constants.colors.primary.withOpacity(0.1);
    _backgroundColor = Constants.colors.getRandomLight();
  }

  @override
  Widget build(BuildContext context) {
    final Size windowSize = MediaQuery.of(context).size;
    final Brightness brightness = Theme.of(context).brightness;
    final bool isDark = brightness == Brightness.dark;
    final Color? foregroundColor =
        Theme.of(context).textTheme.bodyMedium?.color;
    const double width = 500.0;

    final Color? iconColor = foregroundColor?.withOpacity(0.6);
    const double bottomPadding = 64.0;

    return Scaffold(
      // backgroundColor: Colors.blue.shade50,
      backgroundColor: isDark ? const Color(0xFF101010) : _backgroundColor,
      body: ImprovedScrolling(
        enableMMBScrolling: true,
        enableKeyboardScrolling: true,
        scrollController: _pageScrollController,
        child: ScrollConfiguration(
          behavior: const CustomScrollBehaviour(),
          child: CustomScrollView(
            controller: _pageScrollController,
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  width: windowSize.width,
                  height: windowSize.height - bottomPadding,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0.0,
                        left: 0.0,
                        right: 0.0,
                        bottom: 0.0,
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: width,
                                padding: const EdgeInsets.only(
                                  left: 24.0,
                                  right: 24.0,
                                  top: bottomPadding,
                                ),
                                child: Text.rich(
                                  TextSpan(
                                    text: "I'm a Creative Developer\n",
                                    children: [
                                      TextSpan(
                                        text:
                                            "I'm constantly seeking out new ways to solve problems, "
                                            "thinking outside the box, and pushing the boundaries "
                                            "of what is possible in the world of technology. "
                                            "I thrive in collaborative environments, where I can "
                                            "bounce ideas off others and cotribute to building truly "
                                            "remarkable software solutions.",
                                        style: TextStyle(
                                          color:
                                              foregroundColor?.withOpacity(0.6),
                                          fontSize: 14.0,
                                          height: 1.6,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: Utils.calligraphy.body(
                                    textStyle: TextStyle(
                                      fontSize: 24.0,
                                      height: 1.9,
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(24.0),
                                width: width,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    alignment: WrapAlignment.start,
                                    spacing: 12.0,
                                    runSpacing: 12.0,
                                    children: [
                                      IconButton(
                                        onPressed: onTapGitHubIcon,
                                        color: iconColor,
                                        icon: const Icon(
                                          TablerIcons.brand_github,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: onTapLinkedIn,
                                        color: iconColor,
                                        icon: const Icon(
                                          TablerIcons.brand_linkedin,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: onTapResumeButton,
                                        style: TextButton.styleFrom(
                                          shape: const StadiumBorder(),
                                          textStyle: Utils.calligraphy.body(
                                            textStyle: const TextStyle(
                                              fontSize: 14.0,
                                            ),
                                          ),
                                          foregroundColor:
                                              Constants.colors.primary,
                                          backgroundColor: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.1),
                                        ),
                                        child: Text("resume".tr()),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Container(
                              //   width: 600.0,
                              //   padding: const EdgeInsets.only(left: 24.0, top: 12.0),
                              //   child: const Align(
                              //     alignment: Alignment.topLeft,
                              //     child: SizedBox(
                              //       width: 180.0,
                              //       child: WaveDivider(),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 24.0,
                        left: 24.0,
                        child: AppIcon(
                          size: 32.0,
                          onTap: onTapAppIcon,
                        ),
                      ),
                      Positioned(
                        top: 24.0,
                        right: 24.0,
                        child: ElevatedButton(
                          focusNode: FocusNode()
                            ..canRequestFocus = false
                            ..skipTraversal = true,
                          onPressed: onTapOpenForCollaboration,
                          style: ElevatedButton.styleFrom(
                            elevation: 1.0,
                            foregroundColor: Constants.colors.primary,
                            backgroundColor: isDark ? null : _backgroundColor,
                            padding: const EdgeInsets.symmetric(
                              vertical: 4.0,
                              horizontal: 16.0,
                            ),
                          ),
                          child: Text(
                            "Open for work",
                            style: Utils.calligraphy.body(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24.0),
                    clipBehavior: Clip.hardEdge,
                    child: Material(
                      color: Constants.colors.primary.withOpacity(0.1),
                      child: InkWell(
                        focusNode: FocusNode()
                          ..canRequestFocus = false
                          ..skipTraversal = true,
                        onTap: onScrollDown,
                        onLongPress: onToggleBrightness,
                        // radius: 16.0,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(
                            TablerIcons.dots,
                            size: 14.0,
                            color: foregroundColor?.withOpacity(0.3),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              TextHomeProjects(
                backgroundColor: _backgroundColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onShuffleColor() {
    setState(() {
      _backgroundColor = Constants.colors.getRandomLight();
    });
  }

  void onTapResumeButton() async {
    final Locale locale = context.locale;
    String filePath = Constants.resumeEnPath;

    if (locale.toString().contains("fr")) {
      filePath = Constants.resumeFrPath;
    }

    final String url =
        await FirebaseStorage.instance.ref(filePath).getDownloadURL();

    launchUrl(Uri.parse(url));
  }

  void signin() {
    if (Utils.state.user.userAuthenticated) {
      return;
    }

    Utils.graphic.showAdaptiveDialog(
      context,
      isMobileSize: false,
      builder: (BuildContext context) {
        return const SimpleSigninPage();
      },
    );
  }

  void onTapOpenForCollaboration() {
    launchUrl(Uri.parse("mailto:jerem.freelance@codingbox.fr"));
  }

  void onScrollDown() {
    final Size windowSize = MediaQuery.of(context).size;
    _pageScrollController.animateTo(
      windowSize.height,
      // _pageScrollController.position.maxScrollExtent + 100.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
    );
  }

  void onToggleBrightness() {
    AdaptiveTheme.of(context).toggleThemeMode(
      useSystem: true,
    );
  }

  void onTapGitHubIcon() {
    launchUrl(Uri.parse(Constants.githubUrl));
  }

  void onTapLinkedIn() {
    launchUrl(Uri.parse(Constants.linkedinUrl));
  }

  void onTapAppIcon() {
    setState(() {
      _backgroundColor = Constants.colors.getRandomLight();
    });
    // Utils.graphic.showAdaptiveDialog(
    //   context,
    //   builder: (BuildContext context) {
    //     return const SimpleSigninPage();
    //   },
    // );
  }
}
