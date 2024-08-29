import 'dart:io';

import 'package:translatron/exception/custom_exception.dart';
import 'package:translatron/exception/exceptions/custom_file_system_exception.dart';
import 'package:translatron/exception/exceptions/missing_api_params_exception.dart';
import 'package:translatron/exception/exceptions/unknown_error_exception.dart';
import 'package:translatron/exception/exceptions/wrong_api_response_exception.dart';

/// `ExceptionHandler` is a class that handles different types of exceptions.
class ExceptionHandler {
  /// A static list of `CustomException` objects. This list is used to map error codes to their corresponding exceptions.
  static final List<CustomException> exceptions = [
    CustomFileSystemException(),
    MissingApiParamsException(),
    WrongApiResponseException(),
    UnknownErrorException(),
  ];

  /// Converts an error code to its corresponding `Exception`.
  ///
  /// This method iterates over the `exceptions` list and returns the exception that matches the provided error code.
  /// If no match is found, it returns an `UnknownErrorException`.
  ///
  /// @param errorCode The error code to convert to an `Exception`.
  /// @return The `Exception` that corresponds to the provided error code.
  static Exception convertCodeToException(String errorCode) {
    for (int x = 0; x < exceptions.length; x++) {
      if (exceptions[x].toCode() == errorCode) {
        return exceptions[x];
      }
    }

    return UnknownErrorException();
  }

  /// Handles an exception and prints an appropriate error message.
  ///
  /// This method checks the type of the provided exception and prints a corresponding error message.
  /// If the exception is a `FileSystemException`, it prints the message of a `CustomFileSystemException` and the details of the `FileSystemException`.
  /// If the exception is a `CustomException`, it prints the message of the `CustomException`.
  /// If the exception is of any other type, it prints a generic error message.
  ///
  /// @param e The exception to handle.
  static void returnException(Object e) {
    if (e is FileSystemException) {
      print(
          " \x1B[1m\u001B[31m[TRANSLATRON]: \x1B[0m\u001B[31m${CustomFileSystemException().message} ${e.message}, path: ${e.path}\u001B[0m");
      return;
    }
    if (e is CustomException) {
      print(
          " \x1B[1m\u001B[31m[TRANSLATRON]: \x1B[0m\u001B[31m${e.message}\u001B[0m");
      return;
    }
    print(
        " \x1B[1m\u001B[31m[TRANSLATRON]: \x1B[0m\u001B[31mAn unknown error occurred! Please try again later.\u001B[0m");
  }
}
