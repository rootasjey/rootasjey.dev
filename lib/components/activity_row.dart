import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:jiffy/jiffy.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/utils/fonts.dart';
import 'package:unicons/unicons.dart';
import 'package:url_launcher/url_launcher.dart';

class ActivityRow extends StatefulWidget {
  final Event activity;

  ActivityRow({
    @required this.activity,
  });

  @override
  _ActivityRowState createState() => _ActivityRowState();
}

class _ActivityRowState extends State<ActivityRow> {
  @override
  Widget build(BuildContext context) {
    final activity = widget.activity;

    return TextButton.icon(
      onPressed: () {
        launch('https://github.com/${activity.repo.name}');
      },
      style: TextButton.styleFrom(
        primary: stateColors.foreground,
      ),
      icon: Icon(
        getEventIcon(activity.type),
        color: stateColors.primary,
      ),
      label: Row(
        children: [
          Text(
            '${getEventType(activity.type, activity.payload)}: ',
            style: FontsUtils.mainStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: 16.0,
            ),
            child: Opacity(
              opacity: 0.8,
              child: Text(
                '${activity.repo.name}',
                style: FontsUtils.mainStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0,
                ),
              ),
            ),
          ),
          Text(
            Jiffy(activity.createdAt).fromNow(),
            style: FontsUtils.mainStyle(
              color: stateColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  String getEventType(String type, Map<String, dynamic> payload) {
    switch (type) {
      case 'PushEvent':
        return 'Push';
      case 'WatchEvent':
        return 'Watch';
      case 'PullRequestEvent':
        return getPRAction(payload['action']);
      case 'DeleteEvent':
        var verb = 'Delete';

        if (payload != null && payload['ref_type'] != null) {
          verb += ' ${payload['ref_type']}';
        }

        return verb;
      case 'IssuesEvent':
        return getIssueString(type, payload);
      default:
        return type;
    }
  }

  String getIssueString(String type, Map<String, dynamic> payload) {
    String action = payload['action'];
    action = '${action.substring(0, 1).toUpperCase()}${action.substring(1)}';

    return '$action issue';
  }

  String getPRAction(String action) {
    final pr = 'PR';
    switch (action) {
      case 'opened':
        return 'Opened $pr';
      case 'closed':
        return 'Closed $pr';
      case 'reopened':
        return 'Reopened $pr';
      case 'assigned':
        return 'Assigned $pr';
      case 'unassigned':
        return 'Unassigned $pr';
      case 'review_requested':
        return 'Review requested for $pr';
      case 'review_request_removed':
        return 'Review request removed for $pr';
      case 'labeled':
        return 'Labeled $pr';
      case 'unlabeled':
        return 'Unlabeled';
      case 'synchronize':
        return 'Synchronize $pr';
      default:
        return action;
    }
  }

  IconData getEventIcon(String type) {
    switch (type) {
      case 'PushEvent':
        return UniconsLine.upload;
      case 'WatchEvent':
        return UniconsLine.eye;
      case 'PullRequestEvent':
        return UniconsLine.arrows_merge;
      case 'DeleteEvent':
        return UniconsLine.trash;
      default:
        return UniconsLine.brackets_curly;
    }
  }
}
