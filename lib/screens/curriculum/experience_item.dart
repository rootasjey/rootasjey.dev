import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/globals/utils.dart';
import 'package:rootasjey/types/experience.dart';

class ExperienceItem extends StatelessWidget {
  const ExperienceItem({
    super.key,
    required this.experience,
    this.margin = EdgeInsets.zero,
    this.onTapCompany,
  });

  /// Space around this widget.
  final EdgeInsets margin;

  /// Experience data.
  final Experience experience;

  /// Called when the user taps on an experience.
  final void Function(Experience experience)? onTapCompany;

  @override
  Widget build(BuildContext context) {
    final Color? foregroundColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Padding(
      padding: margin,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          experience.job,
          style: Utils.calligraphy.body(
            textStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14.0,
              color: Colors.black.withOpacity(0.6),
              backgroundColor: Constants.colors.getRandomBackground(),
            ),
          ),
        ),
        InkWell(
          onTap: () => onTapCompany?.call(experience),
          child: Text(
            "@ ${experience.company}",
            style: Utils.calligraphy.body(
              textStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14.0,
                color: foregroundColor?.withOpacity(0.5),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: Text(
            "${experience.date.start} → ${experience.date.end}",
            style: Utils.calligraphy.body(
              textStyle: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12.0,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Opacity(
            opacity: 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: experience.tasks
                  .map((String task) {
                    return Text(
                      "• $task",
                      style: TextStyle(
                        color: foregroundColor?.withOpacity(0.7),
                      ),
                    );
                  })
                  .toList()
                  .animate(interval: const Duration(milliseconds: 25))
                  .fadeIn(
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.decelerate,
                  )
                  .slideY(
                    begin: 1.0,
                    end: 0.0,
                  ),
            ),
          ),
        ),
      ]),
    );
  }
}
