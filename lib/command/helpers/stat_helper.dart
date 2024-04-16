import 'dart:convert';
import 'dart:io';

import 'package:translatron/exception/exception_handler.dart';

class StatHelper {
  static Future<void> runStat() async {
    int fileCountToSearch = 0;

    print(
        "\x1B[36m[NOTE]: Please \x1B[1mNOTE\x1B[0m\x1B[36m this command only runs on the JSON files, it \x1B[1mDOES NOT\x1B[0m\x1B[36m run on the device files!\x1B[36m\n");
    print("\x1B[35m[INFO]: Searching for project files\x1B[35m");

    try {
      await for (var entity in Directory('lib').list(recursive: true)) {
        if (entity is File) {
          fileCountToSearch++;
        }
      }
    } catch (e) {
      ExceptionHandler.returnException(e);
    }

    print(
        "\x1B[35m[INFO]: \x1B[1m\x1B[39m$fileCountToSearch\x1B[0m\x1B[35m Files found in project\x1B[35m\n");
    print(
        "\x1B[35m[INFO]: Searching for unique keys across language files\x1B[35m");

    Set<String> uniqueKeys = <String>{};
    Map<String, int> keyUsageCount = {};
    List<String> detectedLanguages = [];

    try {
      await for (var fileEntity in Directory('lang').list(recursive: true)) {
        if (fileEntity is File) {
          String languageCode =
              fileEntity.path.split('/').last.split('.').first.toUpperCase();
          if (!detectedLanguages.contains(languageCode)) {
            detectedLanguages.add(languageCode);
          }
          String jsonString = await fileEntity.readAsString();
          Map<String, String> jsonMap = _convertStringToJson(jsonString);

          for (var jsonKey in jsonMap.keys) {
            uniqueKeys.add(jsonKey);
          }
        }
      }
    } catch (e) {
      ExceptionHandler.returnException(e);
    }

    print(
        "\x1B[35m[INFO]: \x1B[1m\x1B[39m${uniqueKeys.length}\x1B[0m\x1B[35m unique keys found in language files\x1B[35m\n");
    print(
        "\x1B[36m[NOTE]: Counting used language keys... (this could take 1-2 min, depending on your project and hardware)\x1B[36m\n");

    try {
      for (var jsonKey in uniqueKeys) {
        int usageCount = await _getUsageCount(jsonKey);
        keyUsageCount[jsonKey] = usageCount;

        if (usageCount == 0) {
          print(
              "\x1B[31m[UNUSED]: USAGE: [$usageCount] KEY: $jsonKey \x1B[30m");
        } else if (usageCount > 0 && usageCount < 5) {
          print("\x1B[32m[GOOD]: USAGE: [$usageCount] KEY: $jsonKey \x1B[32m");
        } else {
          print(
              "\x1B[33m[WARNING]: USAGE: [$usageCount] KEY: $jsonKey \x1B[33m");
        }
      }
    } catch (e) {
      ExceptionHandler.returnException(e);
    }

    print("\n\x1B[32m[SUCCESS]: Counting finished successfully ✅ \x1B[32m\n");

    print(
        "\x1B[32m[SUCCESS]:🔥 Command excetued succesfully! Bye 👋 \x1B[32m\n");
  }

  static Future<int> _getUsageCount(String key) async {
    int count = 0;
    try {
      await for (var entity in Directory('lib').list(recursive: true)) {
        if (entity is File) {
          if (entity.path.contains('/.')) {
            continue;
          }
          String fileContent = await entity.readAsString();
          RegExp regExp = RegExp(RegExp.escape(key));
          Iterable<RegExpMatch> matches = regExp.allMatches(fileContent);
          count += matches.length;
        }
      }
    } catch (e) {
      ExceptionHandler.returnException(e);
    }
    return count;
  }

  ///Method converts [String] to [Map<String, String>] and returns it
  static Map<String, String> _convertStringToJson(String jsonAsString) {
    Map<String, String>? jsonStrings;

    Map<String, dynamic> jsonAsMap = jsonDecode(jsonAsString);

    jsonStrings = jsonAsMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return jsonStrings;
  }
}
