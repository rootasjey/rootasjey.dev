/// User posts statistics.
class PostsStats {
  final int? contributed;
  final int? drafts;
  final int? published;

  PostsStats({
    this.contributed = 0,
    this.drafts = 0,
    this.published = 0,
  });

  factory PostsStats.empty() {
    return PostsStats(
      contributed: 0,
      drafts: 0,
      published: 0,
    );
  }

  factory PostsStats.fromJSON(Map<String, dynamic>? data) {
    if (data == null) {
      return PostsStats.empty();
    }

    return PostsStats(
      contributed: data['contributed'],
      drafts: data['drafts'],
      published: data['published'],
    );
  }
}
