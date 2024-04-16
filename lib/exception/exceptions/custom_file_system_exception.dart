import 'package:translatron/exception/custom_exception.dart';

class CustomFileSystemException implements CustomException {
  @override
  final String message =
      "FileSystemException: Failed to search your files in your project!";
  @override
  final String code = "custom_file_system_exception";

  @override
  String toCode() {
    return code;
  }

  @override
  String toString() {
    return message;
  }
}
