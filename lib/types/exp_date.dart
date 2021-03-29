class ExpDate {
  final String start;
  final String end;

  const ExpDate({
    this.start = '',
    this.end = '',
  });

  factory ExpDate.empty() {
    return ExpDate();
  }
}
