import 'package:rootasjey/types/urls.dart';
import 'package:rootasjey/utils/date_helper.dart';

class Post {
  final String id;
  final String author;
  final List<String> coauthors;
  final DateTime createdAt;
  final bool featured;
  final String lang;
  final String path;
  final List<String> programmingLanguages;
  final bool published;
  final bool referenced;
  final String summary;
  final List<String> tags;
  final String title;
  final String timeToRead;
  final DateTime updatedAt;
  final Urls urls;

  Post({
    this.id = '',
    this.author = '',
    this.coauthors = const [],
    this.createdAt,
    this.featured = false,
    this.lang = 'en',
    this.path = '',
    this.programmingLanguages,
    this.published = false,
    this.referenced = true,
    this.summary = '',
    this.tags = const [],
    this.timeToRead = '',
    this.title = '',
    this.updatedAt,
    this.urls,
  });

  factory Post.empty() {
    return Post(
      author: '',
      coauthors: const [],
      createdAt: DateTime.now(),
      featured: false,
      lang: 'en',
      path: '',
      programmingLanguages: const [],
      published: false,
      referenced: true,
      summary: '',
      tags: const [],
      timeToRead: '',
      title: '',
      updatedAt: DateTime.now(),
      urls: Urls.empty(),
    );
  }

  factory Post.fromJSON(Map<String, dynamic> data) {
    if (data == null) {
      return Post.empty();
    }

    return Post(
      author: data['author'] ?? '',
      coauthors: parseCoAuthors(data),
      createdAt: DateHelper.fromFirestore(data['createdAt']),
      featured: data['featured'] ?? false,
      id: data['id'] ?? '',
      lang: data['lang'] ?? 'en',
      path: data['path'] ?? '',
      programmingLanguages: parseProgrammingLangs(data),
      published: data['published'] ?? false,
      referenced: data['referenced'] ?? true,
      summary: data['summary'] ?? '',
      tags: parseTags(data),
      timeToRead: data['timeToRead'] ?? '',
      title: data['title'] ?? '',
      updatedAt: DateHelper.fromFirestore(data['updatedAt']),
      urls: Urls.fromJSON(data['urls']),
    );
  }

  static List<String> parseCoAuthors(Map<String, dynamic> data) {
    final coAuthors = <String>[];

    if (data == null || data['coauthors'] == null) {
      return coAuthors;
    }

    final dataAuthors = data['coauthors'] as List<dynamic>;

    dataAuthors.forEach((authorId) {
      coAuthors.add(authorId);
    });

    return coAuthors;
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

    dataTags.forEach((key, value) {
      tags.add(key);
    });

    return tags;
  }
}
