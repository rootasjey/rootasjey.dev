import 'package:flutter/material.dart';
import 'package:rootasjey/components/project_card/title_card.dart';
import 'package:rootasjey/types/project.dart';
import 'package:rootasjey/utils/fonts.dart';

class CardHeader extends StatelessWidget {
  const CardHeader({
    Key? key,
    required this.project,
    this.textColor,
  }) : super(key: key);

  final Project project;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 40.0,
        left: 40.0,
        right: 40.0,
        bottom: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleCard(
            titleValue: project.title,
            textColor: textColor,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Opacity(
              opacity: 0.6,
              child: Text(
                project.summary,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: FontsUtils.mainStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
