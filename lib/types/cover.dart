import 'dart:convert';

import 'package:rootasjey/types/enums/enum_cover_corner.dart';
import 'package:rootasjey/types/enums/enum_cover_width.dart';
import 'package:rootasjey/types/thumbnails.dart';

class Cover {
  const Cover({
    this.thumbnails = const Thumbnails(),
    this.extension = "",
    this.storagePath = "",
    this.originalUrl = "",
    this.widthType = EnumCoverWidth.full,
    this.cornerType = EnumCoverCorner.rounded,
  });

  final EnumCoverWidth widthType;
  final EnumCoverCorner cornerType;
  final String extension;
  final String originalUrl;
  final String storagePath;
  final Thumbnails thumbnails;

  Cover copyWith({
    String? extension,
    String? originalUrl,
    String? storagePath,
    Thumbnails? thumbnails,
    EnumCoverWidth? widthType,
    EnumCoverCorner? cornerType,
  }) {
    return Cover(
      cornerType: cornerType ?? this.cornerType,
      extension: extension ?? this.extension,
      originalUrl: originalUrl ?? this.originalUrl,
      storagePath: storagePath ?? this.storagePath,
      thumbnails: thumbnails ?? this.thumbnails,
      widthType: widthType ?? this.widthType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "corner_type": cornerType.name,
      "width_type": widthType.name,
      "extension": extension,
      "original_url": originalUrl,
      "storagePath": storagePath,
      "thumbnails": thumbnails.toMap(),
    };
  }

  factory Cover.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return const Cover();
    }
    return Cover(
      cornerType: parseCornerType(map["corner_type"]),
      widthType: parseWidthType(map["width_type"]),
      extension: map["extension"] ?? "",
      originalUrl: map["original_url"] ?? "",
      storagePath: map["storage_path"] ?? "",
      thumbnails: Thumbnails.fromMap(map["thumbnails"]),
    );
  }

  static EnumCoverCorner parseCornerType(String? cornerTypeString) {
    if (cornerTypeString == null) {
      return EnumCoverCorner.squared;
    }

    switch (cornerTypeString) {
      case "squared":
        return EnumCoverCorner.squared;
      case "rounded":
        return EnumCoverCorner.rounded;
      default:
        return EnumCoverCorner.squared;
    }
  }

  static EnumCoverWidth parseWidthType(String? widthTypeString) {
    if (widthTypeString == null) {
      return EnumCoverWidth.full;
    }

    switch (widthTypeString) {
      case "full":
        return EnumCoverWidth.full;
      case "center":
        return EnumCoverWidth.center;
      default:
        return EnumCoverWidth.full;
    }
  }

  String toJson() => json.encode(toMap());

  factory Cover.fromJson(String source) => Cover.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Cover(extension: $extension, original: $originalUrl, storagePath: $storagePath, thumbnails: $thumbnails)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Cover &&
        other.cornerType == cornerType &&
        other.widthType == widthType &&
        other.extension == extension &&
        other.originalUrl == originalUrl &&
        other.storagePath == storagePath &&
        other.thumbnails == thumbnails;
  }

  @override
  int get hashCode {
    return extension.hashCode ^
        originalUrl.hashCode ^
        storagePath.hashCode ^
        thumbnails.hashCode ^
        cornerType.hashCode ^
        widthType.hashCode;
  }
}
