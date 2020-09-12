import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rootasjey/types/urls.dart';

class Project {
  final String author;
  final DateTime createdAt;
  final String id;
  final List<String> platforms;
  final String summary;
  final String title;
  final DateTime updatedAt;
  final Urls urls;

  Project({
    this.author,
    this.createdAt,
    this.id,
    this.platforms,
    this.summary,
    this.title,
    this.updatedAt,
    this.urls,
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
      author  : data['author'],
      createdAt : (data['createdAt'] as Timestamp).toDate(),
      id        : data['id'],
      platforms : platformEntries,
      summary   : data['summary'],
      title     : data['title'],
      updatedAt : (data['updatedAt'] as Timestamp).toDate(),
      urls      : Urls.fromJSON(data['urls']),
    );
  }
}
