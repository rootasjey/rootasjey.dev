import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:github/github.dart';
import 'package:loggy/loggy.dart';
import 'package:rootasjey/components/buttons/github_activity_card.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/globals/utilities.dart';
import 'package:timelines/timelines.dart';
import 'package:url_launcher/url_launcher.dart';

class GitHubActivities extends StatefulWidget {
  const GitHubActivities({
    super.key,
    this.size = Size.zero,
  });

  /// Window's size.
  final Size size;

  @override
  State<GitHubActivities> createState() => _GitHubActivitiesState();
}

class _GitHubActivitiesState extends State<GitHubActivities> with UiLoggy {
  /// There's more data to fetch if true.
  bool _hasMore = true;

  /// GitHub client to fetch APIs.
  final GitHub _github = GitHub();

  /// Next page to fetch.
  int _pageIndex = 0;

  /// How many items we want in a single page.
  final int _pageSize = 3;

  /// Main page's data.
  final List<Event> _activities = [];

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.black38,
        padding: getMargin(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "activity_recent".tr(),
              style: Utilities.fonts.body5(
                textStyle: const TextStyle(
                  fontSize: 64.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Opacity(
              opacity: 0.4,
              child: Text(
                "activity_recent_description".tr(),
                style: Utilities.fonts.body(
                  textStyle: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Container(
              width: 500.0,
              padding: const EdgeInsets.only(top: 42.0, bottom: 42.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Timeline.tileBuilder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  theme: TimelineThemeData(
                    nodePosition: 0,
                    connectorTheme: const ConnectorThemeData(
                      thickness: 3.0,
                      color: Color(0xffd3d3d3),
                    ),
                  ),
                  builder: TimelineTileBuilder.connected(
                    contentsAlign: ContentsAlign.basic,
                    itemCount: _activities.length,
                    contentsBuilder: (BuildContext context, int index) {
                      final Event event = _activities.elementAt(index);
                      return GitHubActivityCard(
                        event: event,
                        margin: const EdgeInsets.only(left: 16.0),
                      );
                    },
                    connectorBuilder: (
                      BuildContext context,
                      index,
                      ConnectorType connectorType,
                    ) {
                      return const SolidLineConnector(
                        color: Colors.white54,
                        thickness: 2.0,
                      );
                    },
                    indicatorBuilder: (context, index) {
                      // final Event event = _activities.elementAt(index);
                      // return AnimatedDotIndicator(
                      //   event: event,
                      //   backgroundHoverColor: Colors.green,
                      // );
                      return const DotIndicator(
                        color: Colors.white54,
                        size: 12,
                      );
                    },
                  ),
                ),
              ),
            ),
            footer(),
          ],
        ),
      ),
    );
  }

  Widget moreButton() {
    if (widget.size.width < Utilities.size.mobileWidthTreshold) {
      return Tooltip(
        message: "activity_show_more".tr(),
        child: TextButton(
          onPressed: fetch,
          style: OutlinedButton.styleFrom(
            foregroundColor: Constants.colors.palette.first,
            backgroundColor: Constants.colors.palette.first.withOpacity(0.05),
            minimumSize: const Size(20.0, 50.0),
          ),
          child: const Icon(TablerIcons.dots),
        ),
      );
    }

    return TextButton(
      onPressed: fetch,
      style: OutlinedButton.styleFrom(
        foregroundColor: Constants.colors.palette.first,
        backgroundColor: Constants.colors.palette.first.withOpacity(0.05),
        minimumSize: const Size(200.0, 50.0),
      ),
      child: Text(
        "activity_show_more".tr(),
        style: Utilities.fonts.body(
          textStyle: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget githubButton() {
    if (widget.size.width < Utilities.size.mobileWidthTreshold) {
      return Tooltip(
        message: "GitHub",
        child: TextButton(
          onPressed: goToGitHubProfile,
          style: OutlinedButton.styleFrom(
            foregroundColor: Constants.colors.palette.elementAt(1),
            backgroundColor:
                Constants.colors.palette.elementAt(1).withOpacity(0.05),
            minimumSize: const Size(20.0, 50.0),
          ),
          child: const Icon(TablerIcons.brand_github),
        ),
      );
    }

    return TextButton(
      onPressed: goToGitHubProfile,
      style: OutlinedButton.styleFrom(
        foregroundColor: Constants.colors.palette.elementAt(1),
        backgroundColor:
            Constants.colors.palette.elementAt(1).withOpacity(0.05),
        minimumSize: const Size(200.0, 50.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Text(
          "GitHub",
          style: Utilities.fonts.body(
            textStyle: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget footer() {
    return Wrap(
      spacing: 24.0,
      runSpacing: 12.0,
      children: [
        if (_pageIndex > 1)
          Tooltip(
            message: "activity_reset".tr(),
            child: TextButton(
              onPressed: reset,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.pink,
                minimumSize: const Size(20.0, 50.0),
              ),
              child: const Icon(TablerIcons.history),
            ),
          ),
        moreButton(),
        githubButton(),
      ],
    );
  }

  void fetch() async {
    if (!_hasMore) {
      return;
    }

    try {
      _github.activity
          .listPublicEventsPerformedByUser("rootasjey")
          .skip(_pageIndex)
          .take(_pageSize)
          .toList()
          .then((activities) {
        if (!mounted) {
          return;
        }

        if (activities.length != _pageSize) {
          _hasMore = false;
        }

        _pageIndex++;

        setState(() {
          _activities.addAll(activities);
        });
      });
    } catch (error) {
      loggy.error(error);
    }
  }

  EdgeInsets getMargin() {
    if (widget.size.width < 1000.0) {
      return const EdgeInsets.only(
        left: 36.0,
        top: 64.0,
        bottom: 100.0,
      );
    }

    return const EdgeInsets.only(
      left: 200.0,
      top: 100.0,
      bottom: 100.0,
    );
  }

  void goToGitHubProfile() {
    launchUrl(Uri.parse("https://github.com/rootasjey"));
  }

  void reset() {
    _activities.clear();
    _pageIndex = 0;
    _hasMore = true;
    fetch();
  }
}
