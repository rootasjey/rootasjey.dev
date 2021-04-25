import 'package:rootasjey/types/posts_stats.dart';
import 'package:rootasjey/types/projects_stats.dart';

/// User's statistics.
class UserStats {
  final PostsStats posts;
  final ProjectsStats projects;

  UserStats({this.posts, this.projects});

  factory UserStats.empty() {
    return UserStats(
      posts: PostsStats.empty(),
      projects: ProjectsStats.empty(),
    );
  }

  factory UserStats.fromJSON(Map<String, dynamic> data) {
    if (data == null) {
      return UserStats.empty();
    }

    return UserStats(
      posts: PostsStats.fromJSON(data['posts']),
      projects: ProjectsStats.fromJSON(data['projects']),
    );
  }
}
