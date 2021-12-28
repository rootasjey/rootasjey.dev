import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:rootasjey/utils/fonts.dart';

class CardAuthorAndPub extends StatelessWidget {
  const CardAuthorAndPub({
    Key? key,
    required this.authorName,
    required this.date,
  }) : super(key: key);

  final String authorName;
  final DateTime? date;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 42.0,
      bottom: 24.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Opacity(
              opacity: 0.6,
              child: Text(
                authorName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: FontsUtils.mainStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          if (date != null)
            Opacity(
              opacity: 0.6,
              child: Text(
                Jiffy(date).fromNow(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }
}
