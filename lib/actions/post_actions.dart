import 'package:loggy/loggy.dart';
import 'package:rootasjey/utils/cloud.dart';

/// Network interface for posts's actions.
class PostActions {
  /// Update post's likes count.
  static Future<bool?> like({
    required String postId,
    required bool like,
  }) async {
    try {
      final resp = await Cloud.fun("posts-statsLike").call({
        "postId": postId,
        "like": like,
      });

      return resp.data["success"] as bool?;
    } catch (error) {
      GlobalLoggy().loggy.error(error);
      return false;
    }
  }

  /// Update post's shares count.
  static Future<bool?> share({required String postId}) async {
    try {
      final resp = await Cloud.fun("posts-statsShare").call({
        "postId": postId,
      });

      return resp.data["success"] as bool?;
    } catch (error) {
      GlobalLoggy().loggy.error(error);
      return false;
    }
  }
}
