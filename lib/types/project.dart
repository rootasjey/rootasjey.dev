import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rootasjey/types/stats.dart';
import 'package:rootasjey/types/urls.dart';

class Project {
  final String author;
  final DateTime createdAt;
  final String id;
  final String lang;
  final List<String> platforms;
  final List<String> programmingLanguages;
  final bool published;
  final Stats stats;
  final String summary;
  final List<String> tags;
  final String title;
  final DateTime updatedAt;
  final Urls urls;

  Project({
    this.author,
    this.createdAt,
    this.id,
    this.lang,
    this.platforms,
    this.programmingLanguages,
    this.published,
    this.stats,
    this.summary,
    this.tags,
    this.title,
    this.updatedAt,
    this.urls,
  });

  factory Project.empty() {
    return Project(
      author: '',
      createdAt: DateTime.now(),
      id: '',
      lang: '',
      platforms: const [],
      programmingLanguages: const [],
      published: false,
      stats: Stats.empty(),
      summary: '',
      tags: const [],
      title: '',
      updatedAt: DateTime.now(),
      urls: Urls.empty(),
    );
  }

  factory Project.fromJSON(Map<String, dynamic> data) {
    if (data == null) {
      return Project.empty();
    }

    return Project(
      author: data['author'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      id: data['id'],
      lang: data['lang'],
      platforms: parsePlatforms(data),
      programmingLanguages: parseProgrammingLangs(data),
      published: data['published'],
      stats: Stats.fromJSON(data['stats']),
      summary: data['summary'],
      title: data['title'],
      tags: parseTags(data),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      urls: Urls.fromJSON(data['urls']),
    );
  }

  static List<String> parsePlatforms(Map<String, dynamic> data) {
    final platformEntries = <String>[];

    if (data == null || data['platforms'] == null) {
      return platformEntries;
    }

    final dataPlatforms = data['platforms'] as Map<String, dynamic>;

    dataPlatforms.forEach((platformName, isAvailable) {
      if (isAvailable) {
        platformEntries.add(platformName);
      }
    });

    return platformEntries;
  }

  static List<String> parseProgrammingLangs(Map<String, dynamic> data) {
    final languages = <String>[];

    if (data == null || data['programmingLanguages'] == null) {
      return languages;
    }

    final dataLanguages = data['programmingLanguages'] as Map<String, dynamic>;

    dataLanguages.forEach((platformName, isAvailable) {
      if (isAvailable) {
        languages.add(platformName);
      }
    });

    return languages;
  }

  static List<String> parseTags(Map<String, dynamic> data) {
    final tags = <String>[];

    if (data == null || data['tags'] == null) {
      return tags;
    }

    final dataTags = data['tags'] as Map<String, dynamic>;

    dataTags.forEach((platformName, isAvailable) {
      if (isAvailable) {
        tags.add(platformName);
      }
    });

    return tags;
  }
}
