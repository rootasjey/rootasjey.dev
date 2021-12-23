import 'package:algolia/algolia.dart';

class AlgoliaHelper {
  static Algolia? _algolia;

  static get algolia => _algolia;

  static void init({required applicationId, required searchApiKey}) {
    _algolia = Algolia.init(
      applicationId: applicationId,
      apiKey: searchApiKey,
    );
  }
}
