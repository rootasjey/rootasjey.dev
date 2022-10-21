import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:timelines/timelines.dart';
import 'package:unicons/unicons.dart';
import 'package:url_launcher/url_launcher.dart';

class AnimatedDotIndicator extends StatefulWidget {
  const AnimatedDotIndicator({
    super.key,
    required this.event,
    this.backgroundHoverColor = Colors.transparent,
  });

  final Event event;
  final Color backgroundHoverColor;

  @override
  State<AnimatedDotIndicator> createState() => _AnimatedDotIndicatorState();
}

class _AnimatedDotIndicatorState extends State<AnimatedDotIndicator> {
  Color _backgroundColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return DotIndicator(
      border: Border.all(
        color: Colors.white,
        width: 3.0,
      ),
      color: _backgroundColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(24.0),
        onHover: (bool isHover) {
          setState(() {
            _backgroundColor =
                isHover ? widget.backgroundHoverColor : Colors.transparent;
          });
        },
        onTap: () {
          final Repository? repo = widget.event.repo;
          if (repo == null) {
            return;
          }

          launchUrl(Uri.parse("https://github.com/${repo.name}"));
        },
        child: Icon(
          _getEventIcon(widget.event.type),
          color: Colors.white,
          size: 16.0,
        ),
      ),
    );
  }

  IconData _getEventIcon(String? type) {
    switch (type) {
      case "CreateEvent":
        return UniconsLine.drill;
      case "PushEvent":
        return UniconsLine.upload;
      case "WatchEvent":
        return UniconsLine.eye;
      case "PullRequestEvent":
        return UniconsLine.arrows_merge;
      case "DeleteEvent":
        return UniconsLine.trash;
      default:
        return UniconsLine.brackets_curly;
    }
  }
}
