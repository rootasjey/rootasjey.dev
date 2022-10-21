import 'package:rootasjey/types/cloud_func_error.dart';
import 'package:rootasjey/types/partial_user.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class CreateAccountResp {
  bool success;
  final String message;
  final CloudFuncError? error;
  final PartialUser? user;
  firebase_auth.User? userAuth;

  CreateAccountResp({
    this.success = true,
    this.message = "",
    this.error,
    this.user,
    this.userAuth,
  });

  factory CreateAccountResp.empty() {
    return CreateAccountResp(
      success: false,
      user: PartialUser.empty(),
      error: CloudFuncError.empty(),
    );
  }

  factory CreateAccountResp.fromJSON(Map<dynamic, dynamic> data) {
    return CreateAccountResp(
      success: data["success"] ?? true,
      user: PartialUser.fromJSON(data["user"]),
      error: CloudFuncError.fromJSON(data["error"]),
    );
  }
}
