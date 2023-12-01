import 'package:args/args.dart';
import 'package:translatron/command/helpers/check_helper.dart';
import 'package:translatron/command/helpers/stat_helper.dart';
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
      defaultsTo: false,
    )
    ..addFlag(
      'stat',
      negatable: true,
      abbr: "s",
      defaultsTo: false,
    )
    ..addFlag(
      'check',
      negatable: true,
      abbr: "c",
      defaultsTo: false,
    );

  try {
    ArgResults argResults = parser.parse(arguments);
    if (argResults.arguments.length == 1) {
      if (argResults["unused"]) {
        UnusedHelper.runUnused();
      } else if (argResults["stat"]) {
        StatHelper.runStat();
      } else if (argResults["check"]) {
        CheckHelper.runCheck();
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

// és egy ami chekelni hogy az összes nyelven megvan-e,  --unused --stat --check
// warning to /n

//TODO TOFIX dont count then the varriable end with _language code
