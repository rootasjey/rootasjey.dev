import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/circle_button.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:unicons/unicons.dart';

class SheetHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String tooltip;

  SheetHeader({
    @required this.title,
    this.subtitle,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CircleButton(
          onTap: context.router.pop,
          tooltip: tooltip,
          icon: Icon(
            UniconsLine.times,
            size: 20.0,
            color: stateColors.primary,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Opacity(
                  opacity: 0.6,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
