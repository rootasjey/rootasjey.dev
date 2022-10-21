class ExperienceDate {
  final String start;
  final String end;

  const ExperienceDate({
    this.start = "",
    this.end = "",
  });

  factory ExperienceDate.empty() {
    return const ExperienceDate();
  }
}
