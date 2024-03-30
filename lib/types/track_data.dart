import 'dart:convert';
import 'package:rootasjey/globals/utils.dart';
import 'package:rootasjey/types/cover.dart';

class TrackData {
  TrackData(
      {required this.id,
      required this.name,
      required this.description,
      required this.url,
      required this.storagePath,
      required this.cover,
      required this.duration,
      required this.createdAt,
      required this.updatedAt,
      required this.size,
      required this.album,
      required this.artist,
      required this.releaseDate});

  /// When the track was created.
  final DateTime createdAt;

  /// When the track was last updated.
  final DateTime updatedAt;

  /// Release date.
  final DateTime releaseDate;

  /// Track id.
  final String id;

  /// Track name.
  final String name;

  /// Album name.
  final String album;

  /// Track artist.
  final String artist;

  /// Track description.
  final String description;

  /// Track url.
  final String url;

  /// Track storage path.
  final String storagePath;

  /// Album cover.
  final Cover cover;

  /// Duration (in seconds).
  final int duration;

  /// Track size.
  final int size;

  TrackData.empty()
      : id = "",
        name = "",
        description = "",
        url = "",
        storagePath = "",
        cover = Cover.empty(),
        duration = 0,
        createdAt = DateTime(1970, 1, 1),
        updatedAt = DateTime(1970, 1, 1),
        size = 0,
        album = "",
        artist = "",
        releaseDate = DateTime(1970, 1, 1);

  factory TrackData.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return TrackData.empty();
    }

    return TrackData(
      id: map['id'] ?? "",
      name: map["name"] ?? "",
      description: map["description"] ?? "",
      url: map["url"] ?? "",
      storagePath: map["storage_path"] ?? "",
      cover: Cover.empty(),
      duration: map["duration"] ?? 0,
      createdAt: Utils.tictac.fromFirestore(map["created_at"]),
      updatedAt: Utils.tictac.fromFirestore(map["updated_at"]),
      size: map['size'] ?? 0,
      album: map["album"] ?? "",
      artist: map["artist"] ?? "",
      releaseDate: Utils.tictac.fromFirestore(map["release_date"]),
    );
  }

  TrackData copyWith({
    String? id,
    String? name,
    String? description,
    String? url,
    String? storagePath,
    Cover? cover,
    int? duration,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? size,
  }) {
    return TrackData(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        url: url ?? this.url,
        storagePath: storagePath ?? this.storagePath,
        cover: cover ?? this.cover,
        duration: duration ?? this.duration,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        size: size ?? this.size,
        album: album,
        artist: artist,
        releaseDate: releaseDate);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'url': url,
      'storagePath': storagePath,
      'cover': cover.toMap(),
      'duration': duration,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'size': size,
      'album': album,
      'artist': artist,
      'releaseDate': releaseDate
    };
  }

  String toJson() => json.encode(toMap());

  factory TrackData.fromJson(String source) =>
      TrackData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return "Track(id: $id, name: $name, description: $description, url: $url, "
        "storagePath: $storagePath, cover: $cover, duration: $duration, "
        "createdAt: $createdAt, updatedAt: $updatedAt, size: $size)";
  }

  @override
  bool operator ==(covariant TrackData other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.description == description &&
        other.url == url &&
        other.storagePath == storagePath &&
        other.cover == cover &&
        other.duration == duration &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.size == size &&
        other.album == album &&
        other.artist == artist &&
        other.releaseDate == releaseDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        url.hashCode ^
        storagePath.hashCode ^
        cover.hashCode ^
        duration.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        size.hashCode ^
        album.hashCode ^
        artist.hashCode ^
        releaseDate.hashCode;
  }
}
