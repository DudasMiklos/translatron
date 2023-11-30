class ErrorPrinter {
  static void printNotFoundText(String message) {
    print(
        '\x1B[31m[ERROR]: "$message \n\nRun "dart run translatron --help" (or "dart run translatron -h") for available translatron commands and options.\x1B[0m');
  }

  static void printException(String message) {
    print(
        '\x1B[31m[ERROR]: "$message \n\nRun "dart run translatron --help" (or "dart run translatron -h") for available translatron commands and options.\x1B[0m');
  }

  static void printTooManyParameters() {
    print(
        '\x1B[31m[ERROR]: Only one command argument is allowed! \n\nRun "dart run translatron --help" (or "dart run translatron -h") for available translatron commands and options.\x1B[0m');
  }

  static void printNeedMoreParameters() {
    print(
        '\x1B[31m[ERROR]: You must give one argument! \n\nRun "dart run translatron --help" (or "dart run translatron -h") for available translatron commands and options.\x1B[0m');
  }
}
