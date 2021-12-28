import 'package:flutter/material.dart';
import 'package:rootasjey/utils/fonts.dart';

class TitleCard extends StatelessWidget {
  const TitleCard({
    Key? key,
    required this.titleValue,
    this.textColor,
  }) : super(key: key);

  final String titleValue;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final textChild = Opacity(
      opacity: 1.0,
      child: Text(
        titleValue,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: FontsUtils.mainStyle(
          color: textColor,
          fontSize: 24.0,
          fontWeight: FontWeight.w700,
        ),
      ),
    );

    if (titleValue.length > 14) {
      return Tooltip(
        message: titleValue,
        child: textChild,
      );
    }

    return textChild;
  }
}
