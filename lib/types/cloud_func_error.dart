import 'package:cloud_functions/cloud_functions.dart';

class CloudFuncError {
  CloudFuncError({
    this.message = "",
    this.code = "",
    this.details = "",
  });

  final String code;
  final String details;
  final String message;

  factory CloudFuncError.fromException(FirebaseFunctionsException exception) {
    final dynamic details = exception.details;

    final String code = details != null ? exception.details["code"] : "";
    final String message = details != null ? details["message"] : "";

    return CloudFuncError(
      code: code,
      message: message,
      details: "",
    );
  }

  factory CloudFuncError.empty() {
    return CloudFuncError(
      message: "",
      code: "",
      details: "",
    );
  }

  factory CloudFuncError.fromJSON(Map<dynamic, dynamic>? data) {
    if (data == null) {
      return CloudFuncError.empty();
    }

    return CloudFuncError(
      message: data['message'],
      code: data['code'],
      details: data['details'],
    );
  }

  factory CloudFuncError.fromMessage(String message) {
    return CloudFuncError(
      message: message,
      code: "",
      details: "",
    );
  }
}
