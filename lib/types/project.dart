import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rootasjey/types/urls.dart';

class Project {
  final String title;
  final String summary;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> platforms;
  final Urls urls;
  final String path;

  Project({
    this.createdAt,
    this.platforms,
    this.summary,
    this.title,
    this.updatedAt,
    this.urls,
    this.path,
  });

  factory Project.fromJSON(Map<String, dynamic> data) {
    final platformEntries = List<String>();

    final dataPlatforms = data['platforms'] as Map<String, dynamic>;

    dataPlatforms.forEach((platformName, isAvailable) {
      if (isAvailable) {
        platformEntries.add(platformName);
      }
    });

    return Project(
      title     : data['title'],
      summary   : data['summary'],
      createdAt : (data['createdAt'] as Timestamp).toDate(),
      path      : data['path'],
      platforms : platformEntries,
      updatedAt : (data['updatedAt'] as Timestamp).toDate(),
      urls      : Urls.fromJSON(data['urls']),
    );
  }
}
