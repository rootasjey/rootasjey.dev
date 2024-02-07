import 'package:cloud_functions/cloud_functions.dart';
import 'package:loggy/loggy.dart';
import 'package:rootasjey/utils/cloud.dart';

class IllustrationActions {
  /// Fix illustration metadata.
  /// Refetch metadata from Firebase from Storage with this Cloud function.
  static Future<void> fix({required String illustrationId}) async {
    try {
      await Cloud.fun("illustrations-fixMetadata").call({
        "illustration_id": illustrationId,
      });
    } on FirebaseFunctionsException catch (exception) {
      GlobalLoggy()
          .loggy
          .error("[code: ${exception.code}] - ${exception.message}");
    } catch (error) {
      GlobalLoggy().loggy.error(error);
    }
  }
}
