import 'package:translatron/exception/custom_exception.dart';

class WrongApiResponseException implements CustomException {
  @override
  final String message =
      "Failed to gather data from the server! Please check the provided hostname, versionPath and translationPath and try again later.";
  @override
  final String code = "wrong_api_response_exception";

  @override
  String toCode() {
    return code;
  }

  @override
  String toString() {
    return message;
  }
}
