import 'package:rootasjey/types/project/post_stats.dart';
import 'package:rootasjey/types/project_stats.dart';

/// User's statistics.
class UserStats {
  final PostStats? posts;
  final ProjectStats? projects;

  UserStats({this.posts, this.projects});

  factory UserStats.empty() {
    return UserStats(
      posts: PostStats.empty(),
      projects: ProjectStats.empty(),
    );
  }

  factory UserStats.fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      return UserStats.empty();
    }

    return UserStats(
      posts: PostStats.fromJSON(data['posts']),
      projects: ProjectStats.fromJSON(data['projects']),
    );
  }
}
