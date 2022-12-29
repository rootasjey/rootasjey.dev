import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:rootasjey/types/author.dart';
import 'package:rootasjey/types/cover.dart';
import 'package:rootasjey/types/enums/enum_content_visibility.dart';
import 'package:rootasjey/types/stats.dart';
import 'package:rootasjey/types/social_links.dart';
import 'package:rootasjey/types/thumbnails.dart';
import 'package:rootasjey/utils/date_helper.dart';

class Project {
  const Project({
    required this.createdAt,
    required this.releasedAt,
    required this.updatedAt,
    required this.socialLinks,
    this.projectCreatedAt,
    this.thumbnails = const Thumbnails(),
    this.cover = const Cover(),
    this.wordCount = 0,
    this.characterCount = 0,
    this.id = "",
    this.language = 'en',
    this.platforms = const [],
    this.programmingLanguages = const [],
    this.released = false,
    this.size = 0,
    this.summary = "",
    this.tags = const [],
    this.name = "",
    this.userId = "",
    this.timeToRead = "",
    this.visibility = EnumContentVisibility.private,
    this.storagePath = "",
  });

  /// True if this project has been released somewhere.
  final bool released;

  /// This project's cover to show on large widget component (eg. a post).
  final Cover cover;

  /// The date when this project was updated as an Firestore document.
  final DateTime updatedAt;

  /// The date when this project was created as a Firestore document.
  final DateTime createdAt;

  /// The date when this project was released.
  final DateTime releasedAt;

  /// When the actual project was created (not the Firestore document).
  final DateTime? projectCreatedAt;

  /// Whetheir this project is public or private.
  final EnumContentVisibility visibility;

  /// Amount of characters in this project's post content.
  final int characterCount;

  /// Post's size.
  final int size;

  /// Amount of words in this project's post content.
  final int wordCount;

  /// Where this project can run (eg. Web, Android).
  final List<String> platforms;

  /// Languages this project has been made with (eg. "C#").
  final List<String> programmingLanguages;

  /// This project's tags to categorize (eg. "weather", "quotes").
  final List<String> tags;

  /// This project's unique identifier.
  final String id;

  /// In which human language the project metadata is written with (eg. english).
  final String language;

  /// This project's name.
  final String name;

  /// Short description of this project.
  final String summary;

  /// Firebase storage path.
  /// If this is empty, the post file has not been created yet
  /// (wait for the cloud function to populate this property).
  final String storagePath;

  /// Where we can find this project on the internet (eg. dribbble, instagram).
  final SocialLinks socialLinks;

  /// Estimated time to read this project's post/information.
  /// This is fully arbitrary.
  final String timeToRead;

  /// User's id who created this Firestore document.
  final String userId;

  /// This project's thumbnails to show on small widget component (eg. cards).
  final Thumbnails thumbnails;

  factory Project.empty() {
    return Project(
      createdAt: DateTime.now(),
      projectCreatedAt: DateTime.now(),
      releasedAt: DateTime.now(),
      id: "",
      language: "",
      platforms: const [],
      programmingLanguages: const [],
      released: false,
      summary: "",
      tags: const [],
      name: "",
      updatedAt: DateTime.now(),
      socialLinks: SocialLinks.empty(),
      userId: "",
      storagePath: "",
    );
  }

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      characterCount: map["character_count"] != null
          ? int.parse(map["character_count"])
          : 0,
      cover: Cover.fromMap(map["cover"]),
      createdAt: DateHelper.fromFirestore(map["created_at"]),
      id: map["id"] ?? "",
      language: map["language"] ?? "",
      name: map["name"] ?? "",
      platforms: parsePlatforms(map["platforms"]),
      programmingLanguages: parseProgrammingLangs(map["programming_languages"]),
      projectCreatedAt: DateHelper.fromFirestore(map["project_created_at"]),
      released: map["released"] ?? false,
      releasedAt: DateHelper.fromFirestore(map["released_at"]),
      size: map["size"] ?? 0,
      socialLinks: SocialLinks.fromMap(map["social_links"]),
      storagePath: map["storage_path"] ?? "",
      summary: map["summary"] ?? "",
      tags: parseTags(map),
      thumbnails: Thumbnails.fromMap(map["thumbnails"]),
      timeToRead: map["time_to_read"] ?? "",
      updatedAt: DateHelper.fromFirestore(map["updated_at"]),
      userId: map["user_id"] ?? "",
      visibility: parseVisibility(map["visibility"]),
      wordCount: map["word_count"] != null ? int.parse(map["word_count"]) : 0,
    );
  }

  static EnumContentVisibility parseVisibility(dynamic rawVisibility) {
    if (rawVisibility == null) {
      return EnumContentVisibility.private;
    }

    switch (rawVisibility) {
      case "private":
        return EnumContentVisibility.private;
      case "public":
        return EnumContentVisibility.public;
      default:
        return EnumContentVisibility.private;
    }
  }

  static List<String> parsePlatforms(Map<String, dynamic>? rawPlatforms) {
    final platformEntries = <String>[];

    if (rawPlatforms == null) {
      return platformEntries;
    }

    rawPlatforms.forEach((platformName, isAvailable) {
      if (isAvailable) {
        platformEntries.add(platformName);
      }
    });

    return platformEntries;
  }

  static List<String> parseProgrammingLangs(Map<String, dynamic>? rawProgLang) {
    final languages = <String>[];

    if (rawProgLang == null) {
      return languages;
    }

    rawProgLang.forEach((platformName, isAvailable) {
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

  Project copyWith({
    Author? author,
    bool? released,
    Cover? cover,
    DateTime? createdAt,
    DateTime? releasedAt,
    DateTime? updatedAt,
    EnumContentVisibility? visibility,
    int? characterCount,
    int? size,
    int? wordCount,
    List<String>? platforms,
    List<String>? programmingLanguages,
    List<String>? tags,
    SocialLinks? socialLinks,
    Stats? stats,
    String? id,
    String? language,
    String? name,
    String? userId,
    String? storagePath,
    String? summary,
    String? timeToRead,
    Thumbnails? thumbnails,
  }) {
    return Project(
      createdAt: createdAt ?? this.createdAt,
      releasedAt: releasedAt ?? this.releasedAt,
      id: id ?? this.id,
      language: language ?? this.language,
      platforms: platforms ?? this.platforms,
      programmingLanguages: programmingLanguages ?? this.programmingLanguages,
      released: released ?? this.released,
      summary: summary ?? this.summary,
      tags: tags ?? this.tags,
      name: name ?? this.name,
      updatedAt: updatedAt ?? this.updatedAt,
      socialLinks: socialLinks ?? this.socialLinks,
      userId: userId ?? this.userId,
      size: size ?? this.size,
      timeToRead: timeToRead ?? this.timeToRead,
      visibility: visibility ?? this.visibility,
      thumbnails: thumbnails ?? this.thumbnails,
      cover: cover ?? this.cover,
      wordCount: wordCount ?? this.wordCount,
      characterCount: characterCount ?? this.characterCount,
      storagePath: storagePath ?? this.storagePath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "cover": cover.toMap(),
      "created_at": createdAt.millisecondsSinceEpoch,
      "released_at": releasedAt.millisecondsSinceEpoch,
      "id": id,
      "language": language,
      "platforms": platforms,
      "programming_languages": programmingLanguages,
      "released": released,
      "summary": summary,
      "tags": listToMapStringBool(),
      "title": name,
      "updated_at": updatedAt.millisecondsSinceEpoch,
      "size": size,
      "social_links": socialLinks.toMap(),
      "time_to_read": timeToRead,
      "visibility": visibility.name,
      "thumbnails": thumbnails.toMap(),
      "storage_path": storagePath,
    };
  }

  Map<String, bool> listToMapStringBool() {
    final Map<String, bool> map = <String, bool>{};

    for (final String tag in tags) {
      map.putIfAbsent(tag, () => true);
    }

    return map;
  }

  String toJson() => json.encode(toMap());

  factory Project.fromJson(String source) =>
      Project.fromMap(json.decode(source));

  @override
  String toString() {
    return "Project(createdAt: $createdAt, id: $id, "
        "lang: $language, platforms: $platforms, "
        "programmingLanguages: $programmingLanguages, released: $released, "
        "summary: $summary, tags: $tags, name: $name, "
        "updatedAt: $updatedAt, socialLinks: $socialLinks, userId: $userId, "
        "size: $size "
        "timeToRead: $timeToRead, visibility: ${visibility.name}, "
        "storagePath: $storagePath)";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Project &&
        other.characterCount == characterCount &&
        other.wordCount == wordCount &&
        other.visibility == visibility &&
        other.timeToRead == timeToRead &&
        other.createdAt == createdAt &&
        other.releasedAt == releasedAt &&
        other.id == id &&
        other.language == language &&
        listEquals(other.platforms, platforms) &&
        listEquals(other.programmingLanguages, programmingLanguages) &&
        other.released == released &&
        other.summary == summary &&
        listEquals(other.tags, tags) &&
        other.name == name &&
        other.updatedAt == updatedAt &&
        other.size == size &&
        other.socialLinks == socialLinks &&
        other.userId == userId &&
        other.thumbnails == thumbnails &&
        other.cover == cover &&
        other.storagePath == storagePath;
  }

  @override
  int get hashCode {
    return characterCount.hashCode ^
        wordCount.hashCode ^
        visibility.hashCode ^
        timeToRead.hashCode ^
        releasedAt.hashCode ^
        createdAt.hashCode ^
        id.hashCode ^
        language.hashCode ^
        platforms.hashCode ^
        programmingLanguages.hashCode ^
        released.hashCode ^
        summary.hashCode ^
        size.hashCode ^
        tags.hashCode ^
        name.hashCode ^
        updatedAt.hashCode ^
        socialLinks.hashCode ^
        userId.hashCode ^
        thumbnails.hashCode ^
        cover.hashCode ^
        storagePath.hashCode;
  }

  String getCover() {
    String url =
        "https://firebasestorage.googleapis.com/v0/b/rootasjey.appspot.com"
        "/o/images%2Ftemp%2Fsampe_1_pelican.jpg?"
        "alt=media&token=0c881459-4a7b-405d-b417-a1aa0fb24e6d";

    if (cover.storagePath.isEmpty) {
      return url;
    }

    return cover.thumbnails.l;
  }
}
