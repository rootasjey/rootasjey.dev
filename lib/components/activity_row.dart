import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:jiffy/jiffy.dart';
import 'package:rootasjey/state/colors.dart';
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

    return FlatButton.icon(
      onPressed: () {
        final url = 'https://github.com/${activity.repo.name}';
        launch(url);
      },
      icon: Icon(
        getEventIcon(activity.type),
        color: stateColors.primary,
      ),
      label: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              right: 16.0,
            ),
            child: Text(
              '${getEventType(activity.type)}: ${activity.repo.name}',
            ),
          ),

          Text(
            Jiffy(activity.createdAt).fromNow(),
            style: TextStyle(
              color: stateColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  String getEventType(String type) {
    switch (type) {
      case 'PushEvent':
        return 'Push';
      case 'WatchEvent':
        return 'Watch';
      default:
        return type;
    }
  }

  IconData getEventIcon(String type) {
    switch (type) {
      case 'PushEvent':
        return Icons.publish;
      case 'WatchEvent':
        return Icons.remove_red_eye;
      default:
        return Icons.code;
    }
  }
}
