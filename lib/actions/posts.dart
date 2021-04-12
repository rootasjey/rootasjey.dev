import 'package:flutter/foundation.dart';
import 'package:rootasjey/utils/app_logger.dart';
import 'package:rootasjey/utils/cloud.dart';

/// Network interface for posts's actions.
class PostsActions {
  /// Update post's likes count.
  static Future<bool> like({
    @required String postId,
    @required bool like,
  }) async {
    try {
      final resp = await Cloud.fun('posts-statsLike').call({
        'postId': postId,
        'like': like,
      });

      return resp.data['success'] as bool;
    } catch (error) {
      appLogger.e(error);
      return false;
    }
  }

  /// Update post's shares count.
  static Future<bool> share({@required String postId}) async {
    try {
      final resp = await Cloud.fun('posts-statsShare').call({
        'postId': postId,
      });

      return resp.data['success'] as bool;
    } catch (error) {
      appLogger.e(error);
      return false;
    }
  }
}
