import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:jiffy/jiffy.dart';
import 'package:rootasjey/globals/utilities.dart';
import 'package:url_launcher/url_launcher.dart';

class GitHubActivityCard extends StatefulWidget {
  const GitHubActivityCard({
    super.key,
    required this.event,
    this.backgroundColor = Colors.transparent,
    this.margin = EdgeInsets.zero,
  });

  /// Background color of this card.
  final Color backgroundColor;

  /// A GitHub activity (push, fork, watch).
  final Event event;

  /// Space around this card.
  final EdgeInsets margin;

  @override
  State<GitHubActivityCard> createState() => _GitHubActivityCardState();
}

class _GitHubActivityCardState extends State<GitHubActivityCard> {
  @override
  Widget build(BuildContext context) {
    final Event event = widget.event;
    final String? eventType = _getEventType(event.type, event.payload);

    return Padding(
      padding: widget.margin,
      child: Card(
        color: widget.backgroundColor,
        elevation: 0.0,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: InkWell(
          onTap: onTapCard,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Opacity(
                  opacity: 0.4,
                  child: Text(
                    Jiffy(event.createdAt).fromNow(),
                    style: Utilities.fonts.body5(
                      textStyle: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                Opacity(
                  opacity: 0.8,
                  child: Text(
                    event.repo?.name ?? "",
                    style: Utilities.fonts.body2(
                      textStyle: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                if (eventType != null)
                  Opacity(
                    opacity: 0.6,
                    child: Text(
                      eventType,
                      style: Utilities.fonts.code(
                        textStyle: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
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

  void onTapCard() {
    final Repository? repo = widget.event.repo;
    if (repo == null) {
      return;
    }

    launchUrl(
      Uri.parse("https://github.com/${repo.name}"),
    );
  }
}
