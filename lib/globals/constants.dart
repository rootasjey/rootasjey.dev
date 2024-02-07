import "package:rootasjey/globals/constants/colors_constants.dart";
import "package:rootasjey/globals/constants/links_constants.dart";
import "package:rootasjey/globals/constants/storage_keys.dart";

class Constants {
  /// App name.
  static const appName = "rootasjey";

  /// App version.
  static const appVersion = "3.0.0";

  /// Last time terms of service was updated.
  static final DateTime termsOfServiceLastUpdated = DateTime(2020, 12, 12);

  /// Allowed image file extension for illustrations.
  static const List<String> allowedImageExt = [
    "jpg",
    "jpeg",
    "png",
    "webp",
    "tiff",
  ];

  /// Github url.
  static String githubUrl = "https://github.com/rootasjey/rootasjey";

  /// All necessary colors for the app.
  static final colors = ColorsConstants();

  /// App external links.
  static const links = LinksConstants();

  /// Unique keys to store and retrieve data from local storage.
  static const storageKeys = StorageKeys();
}
