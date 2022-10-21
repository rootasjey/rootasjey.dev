import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:jiffy/jiffy.dart';
import 'package:loggy/loggy.dart';
import 'package:rootasjey/globals/utilities.dart';
import 'package:timelines/timelines.dart';
import 'package:unicons/unicons.dart';
import 'package:url_launcher/url_launcher.dart';

class GitHubActivities extends StatefulWidget {
  const GitHubActivities({super.key});

  @override
  State<GitHubActivities> createState() => _GitHubActivitiesState();
}

class _GitHubActivitiesState extends State<GitHubActivities> with UiLoggy {
  bool _hasMore = true;

  final GitHub _github = GitHub();
  int _pageIndex = 0;
  final int _pageSize = 3;
  final List<Event> _activities = [];

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 200.0, top: 72.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Recent Activities",
              style: Utilities.fonts.body(
                fontSize: 32.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            Opacity(
              opacity: 0.4,
              child: Text(
                "This is what do I build on my free time.",
                style: Utilities.fonts.body1(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(
              width: 500.0,
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
                      final String? eventType =
                          _getEventType(event.type, event.payload);

                      return InkWell(
                        onTap: () {
                          final Repository? repo = event.repo;
                          if (repo == null) {
                            return;
                          }

                          launchUrl(
                            Uri.parse("https://github.com/${repo.name}"),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Opacity(
                                opacity: 0.4,
                                child: Text(
                                  Jiffy(event.createdAt).fromNow(),
                                  style: Utilities.fonts.body1(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Opacity(
                                opacity: 0.8,
                                child: Text(
                                  event.repo?.name ?? "",
                                  style: Utilities.fonts.body2(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              if (eventType != null)
                                Opacity(
                                  opacity: 0.6,
                                  child: Text(
                                    eventType,
                                    style: Utilities.fonts.body4(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w200,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
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
            Wrap(
              spacing: 24.0,
              runSpacing: 12.0,
              children: [
                if (_pageIndex > 1)
                  OutlinedButton(
                    onPressed: reset,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.pink,
                      elevation: 4.0,
                      minimumSize: const Size(20.0, 50.0),
                    ),
                    child: const Icon(UniconsLine.history_alt),
                  ),
                OutlinedButton(
                  onPressed: fetch,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.green,
                    elevation: 4.0,
                    minimumSize: const Size(200.0, 50.0),
                  ),
                  child: const Text("Show more activity"),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    launchUrl(Uri.parse("https://github.com/rootasjey"));
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.green,
                    elevation: 4.0,
                    minimumSize: const Size(200.0, 50.0),
                  ),
                  icon: const Icon(
                    UniconsLine.external_link_alt,
                    size: 18.0,
                  ),
                  label: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("GitHub"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  String? _getEventType(String? type, Map<String, dynamic>? payload) {
    switch (type) {
      case "CreateEvent":
        return "Created a new repo";
      case "PushEvent":
        return "Push";
      case "WatchEvent":
        return "Watch";
      case "PullRequestEvent":
        return _getPRAction(payload!["action"]);
      case "DeleteEvent":
        var verb = "Delete";

        if (payload != null && payload["ref_type"] != null) {
          verb += " ${payload['ref_type']}";
        }

        return verb;
      case "IssuesEvent":
        return _getIssueString(type, payload!);
      default:
        return type;
    }
  }

  String _getIssueString(String? type, Map<String, dynamic> payload) {
    String action = payload['action'];
    action = '${action.substring(0, 1).toUpperCase()}${action.substring(1)}';

    return "$action issue";
  }

  String? _getPRAction(String? action) {
    const pr = "PR";

    switch (action) {
      case "opened":
        return "Opened $pr";
      case "closed":
        return "Closed $pr";
      case "reopened":
        return "Reopened $pr";
      case "assigned":
        return "Assigned $pr";
      case "unassigned":
        return "Unassigned $pr";
      case "review_requested":
        return "Review requested for $pr";
      case "review_request_removed":
        return "Review request removed for $pr";
      case "labeled":
        return "Labeled $pr";
      case "unlabeled":
        return "Unlabeled";
      case "synchronize":
        return "Synchronize $pr";
      default:
        return action;
    }
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

  void reset() {
    _activities.clear();
    _pageIndex = 0;
    _hasMore = true;
    fetch();
  }
}
