import 'package:args/args.dart';
import 'package:translatron/command/helpers/unused_helper.dart';
import 'package:translatron/command/printers/error_printer.dart';

void main(List<String> arguments) {
  final parser = ArgParser()
    ..addFlag(
      'help',
      negatable: true,
      abbr: "h",
      defaultsTo: false,
    )
    ..addFlag(
      'unused',
      negatable: true,
      abbr: "u",
      defaultsTo: true,
    );

  try {
    ArgResults argResults = parser.parse(arguments);
    if (argResults.arguments.length == 1) {
      if (argResults["unused"]) {
        UnusedHelper.runUnused();
      } else if (argResults["help"]) {
        print("HELP");
      }
    } else {
      if (argResults.arguments.isEmpty) {
        // Prints error if there arent any arguments provided
        ErrorPrinter.printNeedMoreParameters();
        //TODO SHOW HELP
      } else {
        // Prints error if there are to many any arguments provided
        ErrorPrinter.printTooManyParameters();
        //TODO SHOW HELP
      }
    }
  } on FormatException catch (e) {
    // Prints error if no argument is found.
    ErrorPrinter.printNotFoundText(e.message);
    //TODO SHOW HELP
  } catch (e) {
    // Print all other errors.
    ErrorPrinter.printException(e.toString());
  }
}

// Egy funkció ami kiirja hogy van e unused elem , egy ami csinál statisztikát hogy hányszór van használva, és egy ami chekelni hogy az összes nyelven megvan-e,  --unused --statistic --check
