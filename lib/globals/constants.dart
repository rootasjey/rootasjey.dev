import "package:rootasjey/globals/constants/colors_constants.dart";
import "package:rootasjey/globals/constants/links_constants.dart";
import "package:rootasjey/globals/constants/storage_keys.dart";

class Constants {
  /// Allowed image file extension for illustrations.
  static const List<String> allowedImageExt = [
    "jpg",
    "jpeg",
    "png",
    "webp",
    "tiff",
  ];

  /// All necessary colors for the app.
  static final colors = ColorsConstants();

  /// App external links.
  static const links = LinksConstants();

  /// Unique keys to store and retrieve data from local storage.
  static const storageKeys = StorageKeys();
}
