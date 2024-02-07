import "package:algoliasearch/algoliasearch.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";

class SearchApi {
  SearchApi();

  final algolia = SearchClient(
    appId: dotenv.get("ALGOLIA_APP_ID"),
    apiKey: dotenv.get("ALGOLIA_SEARCH_API_KEY"),
  );
}
