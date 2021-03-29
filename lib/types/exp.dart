import 'package:rootasjey/types/exp_date.dart';

class Exp {
  final String company;
  final String url;
  final String job;
  final List<String> tasks;
  final ExpDate date;

  Exp({
    this.company = '',
    this.job = '',
    this.tasks = const [],
    this.date = const ExpDate(),
    this.url = '',
  });
}
