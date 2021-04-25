/// User projects statistics.
class ProjectsStats {
  final int contributed;
  final int drafts;
  final int published;

  ProjectsStats({
    this.contributed = 0,
    this.drafts = 0,
    this.published = 0,
  });

  factory ProjectsStats.empty() {
    return ProjectsStats(
      contributed: 0,
      drafts: 0,
      published: 0,
    );
  }

  factory ProjectsStats.fromJSON(Map<String, dynamic> data) {
    if (data == null) {
      return ProjectsStats.empty();
    }

    return ProjectsStats(
      contributed: data['contributed'],
      drafts: data['drafts'],
      published: data['published'],
    );
  }
}
