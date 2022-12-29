/// User posts statistics.
class PostStats {
  PostStats({
    this.contributed = 0,
    this.drafts = 0,
    this.published = 0,
  });

  final int contributed;
  final int drafts;
  final int published;

  factory PostStats.empty() {
    return PostStats(
      contributed: 0,
      drafts: 0,
      published: 0,
    );
  }

  factory PostStats.fromJSON(Map<String, dynamic>? data) {
    if (data == null) {
      return PostStats.empty();
    }

    return PostStats(
      contributed: data['contributed'],
      drafts: data['drafts'],
      published: data['published'],
    );
  }
}
