/// User projects statistics.
class ProjectStats {
  ProjectStats({
    this.contributed = 0,
    this.drafts = 0,
    this.published = 0,
  });
  final int contributed;
  final int drafts;
  final int published;

  factory ProjectStats.empty() {
    return ProjectStats(
      contributed: 0,
      drafts: 0,
      published: 0,
    );
  }

  factory ProjectStats.fromJSON(Map<String, dynamic>? data) {
    if (data == null) {
      return ProjectStats.empty();
    }

    return ProjectStats(
      contributed: data['contributed'],
      drafts: data['drafts'],
      published: data['published'],
    );
  }
}
