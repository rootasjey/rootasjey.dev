import 'package:rootasjey/types/experience_date.dart';

class Formation {
  Formation({
    this.degree = "",
    this.school = "",
    this.date = const ExperienceDate(),
    this.tasks = const [],
    this.url = "",
  });
  final String degree;
  final String school;
  final ExperienceDate date;
  final List<String> tasks;
  final String url;
}
