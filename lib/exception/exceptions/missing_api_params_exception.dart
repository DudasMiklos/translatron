import 'package:translatron/exception/custom_exception.dart';

class MissingApiParamsException implements CustomException {
  @override
  final String message =
      "You must enter a valid hostname, versionPath and translationPath in order to use the API!\n Or make \"hasWebserver = false;\"! Please try again later.";
  @override
  final String code = "missing_api_params_exception";

  @override
  String toCode() {
    return code;
  }

  @override
  String toString() {
    return message;
  }
}
