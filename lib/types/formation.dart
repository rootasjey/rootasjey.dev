import 'package:rootasjey/types/exp_date.dart';

class Formation {
  final String degree;
  final String school;
  final ExpDate date;
  final List<String> tasks;
  final String url;

  Formation({
    this.degree = '',
    this.school = '',
    this.date = const ExpDate(),
    this.tasks = const [],
    this.url = '',
  });
}
