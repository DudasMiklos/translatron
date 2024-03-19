/// `CustomException` is an abstract class that provides a base for custom exceptions.
/// It implements the `Exception` interface.
abstract class CustomException implements Exception {
  /// The message of the exception.
  final String message;

  /// The code of the exception.
  final String code;

  /// Creates a new `CustomException`.
  ///
  /// Both [message] and [code] are optional parameters. If not provided, they default to an empty string.
  CustomException([this.message = "", this.code = ""]);

  /// Returns the code of the exception.
  ///
  /// This method can be used to get the code of the exception, which can be useful for error handling.
  String toCode() {
    return code;
  }
}
