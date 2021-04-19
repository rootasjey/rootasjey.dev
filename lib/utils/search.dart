import 'package:algolia/algolia.dart';
import 'package:flutter/foundation.dart';

class AlgoliaHelper {
  static Algolia _algolia;

  static get algolia => _algolia;

  static void init({@required applicationId, @required searchApiKey}) {
    _algolia = Algolia.init(
      applicationId: applicationId,
      apiKey: searchApiKey,
    );
  }
}
