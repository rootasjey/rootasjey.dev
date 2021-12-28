import 'package:rootasjey/types/author.dart';
import 'package:rootasjey/types/stats.dart';
import 'package:rootasjey/types/urls.dart';
import 'package:rootasjey/utils/date_helper.dart';

class Project {
  final Author author;
  final DateTime? createdAt;
  final String id;
  final String lang;
  final List<String> platforms;
  final List<String> programmingLanguages;
  final bool published;
  final Stats? stats;
  final String summary;
  final List<String> tags;
  final String title;
  final DateTime? updatedAt;
  final Urls? urls;

  Project({
    this.author = const Author(id: ''),
    this.createdAt,
    this.id = '',
    this.lang = 'en',
    this.platforms = const [],
    this.programmingLanguages = const [],
    this.published = false,
    this.stats,
    this.summary = '',
    this.tags = const [],
    this.title = '',
    this.updatedAt,
    this.urls,
  });

  factory Project.empty() {
    return Project(
      author: Author.empty(),
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
    return Project(
      author: Author.fromJSON(data['author']),
      createdAt: DateHelper.fromFirestore(data['createdAt']),
      id: data['id'],
      lang: data['lang'],
      platforms: parsePlatforms(data),
      programmingLanguages: parseProgrammingLangs(data),
      published: data['published'],
      stats: Stats.fromJSON(data['stats']),
      summary: data['summary'],
      title: data['title'],
      tags: parseTags(data),
      updatedAt: DateHelper.fromFirestore(data['updatedAt']),
      urls: Urls.fromJSON(data['urls']),
    );
  }

  static List<String> parsePlatforms(Map<String, dynamic> data) {
    final platformEntries = <String>[];

    if (data['platforms'] == null) {
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

    if (data['programmingLanguages'] == null) {
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

    if (data['tags'] == null) {
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
