import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:rootasjey/globals/utilities.dart';
import 'package:unicons/unicons.dart';

class PostFooter extends StatelessWidget {
  const PostFooter({
    super.key,
    required this.content,
    required this.updatedAt,
    required this.wordCount,
    required this.maxWidth,
  });

  final DateTime updatedAt;
  final double maxWidth;
  final int wordCount;
  final String content;

  @override
  Widget build(BuildContext context) {
    String lastUpdatedAt = "";
    final diff = DateTime.now().difference(updatedAt);

    if (diff.inDays < 10) {
      lastUpdatedAt = Jiffy(updatedAt).fromNow();
    } else {
      lastUpdatedAt = Jiffy(updatedAt).yMMMMEEEEd;
    }

    return SliverToBoxAdapter(
      child: Column(
        children: [
          const SizedBox(height: 50.0),
          Material(
            elevation: 4.0,
            color: Colors.black54,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Container(
              padding: const EdgeInsets.all(24.0),
              width: maxWidth,
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: Icon(UniconsLine.lightbulb_alt, color: Colors.amber),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Opacity(
                          opacity: 0.6,
                          child: Text(
                            "word_count".plural(wordCount),
                            style: Utilities.fonts.body(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Opacity(
                          opacity: 0.6,
                          child: Text.rich(
                            TextSpan(children: [
                              TextSpan(
                                text: lastUpdatedAt,
                                style: Utilities.fonts.body(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: " (${"last_updated".tr().toLowerCase()})",
                                style: Utilities.fonts.body(
                                  fontSize: 14.0,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      ?.color
                                      ?.withOpacity(0.6),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ]),
                            style: Utilities.fonts.body(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 300.0),
        ],
      ),
    );
  }
}
