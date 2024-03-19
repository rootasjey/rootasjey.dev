import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/globals/utils.dart';
import 'package:rootasjey/screens/curriculum/experience_item.dart';
import 'package:rootasjey/types/experience.dart';
import 'package:wave_divider/wave_divider.dart';

class ExperiencesPage extends StatelessWidget {
  const ExperiencesPage({
    super.key,
    required this.experiences,
    required this.cardSize,
    this.isMobileSize = false,
    this.onTapCompany,
  });

  /// Adapt UI to mobile size if true.
  final bool isMobileSize;

  /// List of experiences to display.
  final List<Experience> experiences;

  /// Called when the user taps on an experience's company.
  final void Function(Experience experience)? onTapCompany;

  /// Size of the card to adapt children.
  final Size cardSize;

  @override
  Widget build(BuildContext context) {
    final Color? foregroundColor = Theme.of(context).textTheme.bodyLarge?.color;
    const double bottomPadding = 54.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: bottomPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 24.0,
              right: 24.0,
              top: 24.0,
            ),
            child: Text(
              "experience.names".tr(),
              style: Utils.calligraphy.body(
                textStyle: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: foregroundColor?.withOpacity(0.4),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Divider(
              color: foregroundColor?.withOpacity(0.2),
              indent: 24.0,
              endIndent: 24.0,
              height: 0,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 0.0),
            height: cardSize.height - (100.0 + bottomPadding),
            child: ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (context, index) {
                return const WaveDivider(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                );
              },
              itemCount: experiences.length,
              itemBuilder: (BuildContext context, int index) {
                return ExperienceItem(
                  experience: experiences[index],
                  onTapCompany: onTapCompany,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 12.0,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
