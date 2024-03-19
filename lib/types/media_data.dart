import 'dart:convert';

class MediaData {
  MediaData({
    required this.url,
    required this.name,
    required this.description,
    required this.type,
    required this.index,
    required this.youtubeUrl,
    required this.vimeoUrl,
    required this.coverImageUrl,
  });

  /// Media exterinal url.
  final String url;

  /// Name of the media.
  final String name;

  /// Description of the media.
  final String description;

  /// Media type.
  final String type;

  /// Media index (e.g. in a list).
  final int index;

  /// Youtube url.
  final String youtubeUrl;

  /// Vimeo url.
  final String vimeoUrl;

  /// Cover image url.
  final String coverImageUrl;

  MediaData copyWith({
    String? url,
    String? name,
    String? description,
    String? type,
    int? index,
    String? youtubeUrl,
    String? vimeoUrl,
    String? coverImageUrl,
  }) {
    return MediaData(
      url: url ?? this.url,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      index: index ?? this.index,
      youtubeUrl: youtubeUrl ?? this.youtubeUrl,
      vimeoUrl: vimeoUrl ?? this.vimeoUrl,
      coverImageUrl: this.coverImageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
      'name': name,
      'description': description,
      'type': type,
      'index': index,
      'youtubeUrl': youtubeUrl,
      'vimeoUrl': vimeoUrl,
    };
  }

  factory MediaData.fromMap(Map<String, dynamic> map) {
    return MediaData(
      url: map['url'] ?? "",
      name: map['name'] ?? "",
      description: map['description'] ?? "",
      type: map['type'] ?? "",
      index: map['index'] ?? 0,
      youtubeUrl: map['youtubeUrl'] ?? "",
      vimeoUrl: map['vimeoUrl'] ?? "",
      coverImageUrl: map['coverImageUrl'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory MediaData.fromJson(String source) =>
      MediaData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MediaData(url: $url, name: $name, description: $description, type: $type, index: $index, youtubeUrl: $youtubeUrl, vimeoUrl: $vimeoUrl)';
  }

  @override
  bool operator ==(covariant MediaData other) {
    if (identical(this, other)) return true;

    return other.url == url &&
        other.name == name &&
        other.description == description &&
        other.type == type &&
        other.index == index &&
        other.youtubeUrl == youtubeUrl &&
        other.vimeoUrl == vimeoUrl;
  }

  @override
  int get hashCode {
    return url.hashCode ^
        name.hashCode ^
        description.hashCode ^
        type.hashCode ^
        index.hashCode ^
        youtubeUrl.hashCode ^
        vimeoUrl.hashCode;
  }
}
