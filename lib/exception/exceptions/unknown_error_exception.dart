import 'package:translatron/exception/custom_exception.dart';

class UnknownErrorException implements CustomException {
  @override
  final String message = "An unknown error occurred! Please try again later.";
  @override
  final String code = "unkown_error_exception";

  @override
  String toCode() {
    return code;
  }

  @override
  String toString() {
    return message;
  }
}
