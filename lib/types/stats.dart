class Stats {
  Stats({
    this.likes = 0,
    this.shares = 0,
  });

  final int? likes;
  final int? shares;

  factory Stats.empty() {
    return Stats(
      likes: 0,
      shares: 0,
    );
  }

  factory Stats.fromJSON(Map<String, dynamic>? data) {
    if (data == null) {
      return Stats.empty();
    }

    return Stats(
      likes: data["likes"],
      shares: data["shares"],
    );
  }
}
