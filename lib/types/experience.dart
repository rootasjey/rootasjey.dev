import 'package:rootasjey/types/experience_date.dart';

class Experience {
  Experience({
    this.company = "",
    this.job = "",
    this.tasks = const [],
    this.date = const ExperienceDate(),
    this.url = "",
    this.objective = "",
  });

  final String company;
  final String url;
  final String objective;
  final String job;
  final List<String> tasks;
  final ExperienceDate date;
}
