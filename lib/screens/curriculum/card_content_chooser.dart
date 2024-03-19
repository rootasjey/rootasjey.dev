import 'package:flutter/material.dart';
import 'package:rootasjey/screens/curriculum/education_page.dart';
import 'package:rootasjey/screens/curriculum/experiences_page.dart';
import 'package:rootasjey/screens/curriculum/identity_page.dart';
import 'package:rootasjey/types/enums/enum_curriculum_item.dart';
import 'package:rootasjey/types/experience.dart';
import 'package:rootasjey/types/formation.dart';
import 'package:rootasjey/types/skill.dart';

class CardContentChooser extends StatelessWidget {
  const CardContentChooser({
    super.key,
    required this.selectedTab,
    required this.skills,
    required this.experiences,
    required this.cardSize,
    required this.formations,
    this.isMobileSize = false,
    this.onTapAvatar,
    this.onTapCompany,
    this.onTapSchool,
  });

  /// Adapt UI to mobile size if true.
  final bool isMobileSize;

  /// Currently selected tab.
  final EnumCurriculumItem selectedTab;

  /// Called when the user taps on the avatar.
  final void Function()? onTapAvatar;

  /// Called when the user taps on an experience.
  final void Function(Experience experience)? onTapCompany;

  /// Called when the user taps on a school name.
  final void Function(Formation formation)? onTapSchool;

  /// List of experiences to display.
  final List<Experience> experiences;

  /// List of formations to display.
  final List<Formation> formations;

  /// List of skills to display.
  final List<Skill> skills;

  /// Size of the window to adapt widgets.
  final Size cardSize;

  @override
  Widget build(BuildContext context) {
    switch (selectedTab) {
      case EnumCurriculumItem.identity:
        return IdentityPage(
          skills: skills,
          isMobileSize: isMobileSize,
          onTapAvatar: onTapAvatar,
        );

      case EnumCurriculumItem.experiences:
        return ExperiencesPage(
          experiences: experiences,
          isMobileSize: isMobileSize,
          onTapCompany: onTapCompany,
          cardSize: cardSize,
        );

      case EnumCurriculumItem.education:
        return EducationPage(
          formations: formations,
          isMobileSize: isMobileSize,
          onTapSchool: onTapSchool,
          cardSize: cardSize,
        );
      default:
        return IdentityPage(
          skills: skills,
          isMobileSize: isMobileSize,
          onTapAvatar: onTapAvatar,
        );
    }
  }
}
