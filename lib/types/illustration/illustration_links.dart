import 'package:rootasjey/types/alias/json_alias.dart';
import 'package:rootasjey/types/illustration/thumbnail_links.dart';

/// Links of a book/illustration including original image, thumbnails.
class IllustrationLinks {
  const IllustrationLinks({
    this.original = "",
    this.storage = "",
    required this.thumbnails,
  });

  final String original;
  final String storage;
  final ThumbnailLinks thumbnails;

  factory IllustrationLinks.empty({
    String original = "",
    ThumbnailLinks? thumbnailLinks,
  }) {
    return IllustrationLinks(
      original: original,
      storage: "",
      thumbnails: thumbnailLinks ?? ThumbnailLinks.empty(),
    );
  }

  factory IllustrationLinks.fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      return IllustrationLinks.empty();
    }

    return IllustrationLinks(
      original: data["original_url"] ?? "",
      storage: data["storage_path"] ?? "",
      thumbnails: ThumbnailLinks.fromMap(data["thumbnails"]),
    );
  }

  Json toMap() {
    return {
      "original_url": original,
      "storage_path": storage,
      "thumbnails": thumbnails.toMap(),
    };
  }
}
