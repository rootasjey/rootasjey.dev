import "package:rootasjey/globals/constants/colors_constants.dart";
import "package:rootasjey/globals/constants/links_constants.dart";
import "package:rootasjey/globals/constants/storage_keys.dart";

class Constants {
  /// App name.
  static const appName = "rootasjey";

  /// App version.
  static const appVersion = "3.10.0";
  static const buildNumber = "15";

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

  /// LinkedIn url.
  static String linkedinUrl =
      "https://www.linkedin.com/in/j%C3%A9r%C3%A9mie-c-7b25194a/";

  static String resumeEnPath =
      "/assets/files/jc-resume-fullstack-dev-2024-en.pdf";

  static String resumeFrPath =
      "/assets/files/jc-resume-fullstack-dev-2024-fr.pdf";

  /// All necessary colors for the app.
  static final colors = ColorsConstants();

  /// App external links.
  static const links = LinksConstants();

  /// Unique keys to store and retrieve data from local storage.
  static const storageKeys = StorageKeys();
}
