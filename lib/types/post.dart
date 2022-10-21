import 'package:rootasjey/types/author.dart';
import 'package:rootasjey/types/post_image_map.dart';
import 'package:rootasjey/types/stats.dart';
import 'package:rootasjey/types/social_links.dart';
import 'package:rootasjey/utils/date_helper.dart';

class Post {
  final Author author;
  final List<String> coauthors;
  final DateTime? createdAt;
  final bool featured;
  final String id;
  final PostImageMap? image;
  final String lang;
  final String path;
  final List<String>? programmingLanguages;
  final bool published;
  final bool referenced;
  final String summary;
  final Stats? stats;
  final List<String> tags;
  final String title;
  final String timeToRead;
  final DateTime? updatedAt;
  final SocialLinks? urls;

  Post({
    this.author = const Author(id: ''),
    this.coauthors = const [],
    this.createdAt,
    this.featured = false,
    this.id = '',
    this.image,
    this.lang = 'en',
    this.path = '',
    this.programmingLanguages,
    this.published = false,
    this.referenced = true,
    this.stats,
    this.summary = '',
    this.tags = const [],
    this.timeToRead = '',
    this.title = '',
    this.updatedAt,
    this.urls,
  });

  factory Post.empty() {
    return Post(
      author: Author.empty(),
      coauthors: const [],
      createdAt: DateTime.now(),
      featured: false,
      lang: 'en',
      id: '',
      image: PostImageMap.empty(),
      path: '',
      programmingLanguages: const [],
      published: false,
      referenced: true,
      stats: Stats.empty(),
      summary: '',
      tags: const [],
      timeToRead: '',
      title: '',
      updatedAt: DateTime.now(),
      urls: SocialLinks.empty(),
    );
  }

  factory Post.fromJSON(Map<String, dynamic>? data) {
    if (data == null) {
      return Post.empty();
    }

    return Post(
      author: Author.fromJSON(data['author']),
      coauthors: parseCoAuthors(data),
      createdAt: DateHelper.fromFirestore(data['createdAt']),
      featured: data['featured'] ?? false,
      id: data['id'] ?? '',
      image: PostImageMap.fromJSON(data['image']),
      lang: data['lang'] ?? 'en',
      path: data['path'] ?? '',
      programmingLanguages: parseProgrammingLangs(data),
      published: data['published'] ?? false,
      referenced: data['referenced'] ?? true,
      stats: Stats.fromJSON(data['stats']),
      summary: data['summary'] ?? '',
      tags: parseTags(data),
      timeToRead: data['timeToRead'] ?? '',
      title: data['title'] ?? '',
      updatedAt: DateHelper.fromFirestore(data['updatedAt']),
      urls: SocialLinks.fromMap(data["social_links"]),
    );
  }

  static List<String> parseCoAuthors(Map<String, dynamic> data) {
    final coAuthors = <String>[];

    if (data['coauthors'] == null) {
      return coAuthors;
    }

    final dataAuthors = data['coauthors'] as List<dynamic>;

    for (var authorId in dataAuthors) {
      coAuthors.add(authorId);
    }

    return coAuthors;
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

    dataTags.forEach((key, value) {
      tags.add(key);
    });

    return tags;
  }
}
