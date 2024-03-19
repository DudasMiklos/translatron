import 'dart:convert';
import 'dart:io';

import 'package:translatron/exception/exception_handler.dart';

class CheckHelper {
  static Future<void> runCheck() async {
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

    Set<String> uniqueKeys = <String>{};
    Map<String, int> keysTooMuchUsedList = {}; // TODO more than 10
    List<String> unusedKeys = [];
    List<String> detectedLanguages = [];
    Map<String, String> notAllowedLineBreakList = {};

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
    print("\x1B[35m[INFO]: Searching for language files\x1B[35m");
    print(
        "\x1B[35m[INFO]: \x1B[1m\x1B[39m$detectedLanguages\x1B[0m\x1B[35m Language files found in project\x1B[35m\n");
    print(
        "\x1B[35m[INFO]: Searching for unique keys across language files\x1B[35m");
    print(
        "\x1B[35m[INFO]: \x1B[1m\x1B[39m${uniqueKeys.length}\x1B[0m\x1B[35m unique keys found in language files\x1B[35m\n");
    print(
        "\x1B[36m[NOTE]: Checking keys usages in project files ...\x1B[36m\n");

    try {
      for (var jsonKey in uniqueKeys) {
        int usageCount = await _getUsageCount(jsonKey);
        if (usageCount > 5) {
          //TODO 10
          keysTooMuchUsedList[jsonKey] = usageCount;
        }
        bool endsWithLanguageCode = detectedLanguages
            .any((lang) => jsonKey.endsWith("_${lang.toLowerCase()}"));
        if (!endsWithLanguageCode) {
          if (usageCount == 0) {
            unusedKeys.add(jsonKey);
          }
        }
      }
    } catch (e) {
      ExceptionHandler.returnException(e);
    }

    print(
        "\x1B[36m[NOTE]: Checking for forbidden '[backslash]n' characters ...\x1B[36m\n");

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
            if (jsonMap[jsonKey]!.contains('\n')) {
              notAllowedLineBreakList[jsonKey] = languageCode;
            }
          }
        }
      }
    } catch (e) {
      ExceptionHandler.returnException(e);
    }

    print(
        "\x1B[36m[NOTE]: Checking for missing key inside lang files (according to each other) ...\x1B[36m\n");

    Map<String, List<String>> unusedMissingKeyMap = {};
    Map<String, List<String>> usedMissingKeyMap = {};
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
            // Check if the key ends with any of the language codes
            bool endsWithLanguageCode = detectedLanguages
                .any((lang) => jsonKey.endsWith("_${lang.toLowerCase()}"));
            if (!endsWithLanguageCode) {
              bool isKeyUsed = await _isKeyUsedInLib(jsonKey);
              if (!isKeyUsed) {
                if (unusedMissingKeyMap.containsKey(jsonKey)) {
                  unusedMissingKeyMap.update(jsonKey, (existingLanguages) {
                    if (!existingLanguages.contains(languageCode)) {
                      existingLanguages.add(languageCode);
                    }
                    return existingLanguages;
                  });
                } else {
                  unusedMissingKeyMap[jsonKey] = [languageCode];
                }
              } else {
                if (usedMissingKeyMap.containsKey(jsonKey)) {
                  usedMissingKeyMap.update(jsonKey, (existingLanguages) {
                    if (!existingLanguages.contains(languageCode)) {
                      existingLanguages.add(languageCode);
                    }
                    return existingLanguages;
                  });
                } else {
                  usedMissingKeyMap[jsonKey] = [languageCode];
                }
              }
            }
          }
        }
      }
    } catch (e) {
      ExceptionHandler.returnException(e);
    }

    unusedKeys.forEach((key) {
      print("\x1B[33m[WARNING]: THE FOLLOWING KEY IS UNUSED : $key");
    });

    keysTooMuchUsedList.forEach((key, value) {
      print(
          "\x1B[31m[ERROR]: THE FOLLOWING KEY IS \x1B[1mUSED TOO OFTEN\x1B[0m\x1B[31m : $key : USAGE [$value]");
    });

    notAllowedLineBreakList.forEach((key, value) {
      print(
          "\x1B[31m[ERROR]: THE FOLLOWING KEY \x1B[1mCONTAINS NOT ALLOWED\x1B[0m\x1B[31m LINE BRAKE : $key : INSIDE [$value]");
    });

    unusedMissingKeyMap.forEach((key, value) {
      if (value.length != detectedLanguages.length) {
        print(
            "\x1B[33m[WARNING]: UNUSED KEY WAS ONLY FOUND IN : $value, KEY IS : $key");
      }
    });

    usedMissingKeyMap.forEach((key, value) {
      if (value.length != detectedLanguages.length) {
        print(
            "\x1B[31m[ERROR]: USED KEY \x1B[1mWAS ONLY\x1B[0m\x1B[31m FOUND IN, \x1B[1mONE OR MORE LANGUAGES ARE MISSING\x1B[0m\x1B[31m: $value, KEY IS : $key");
      }
    });

    print(
        "\x1B[32m[SUCCESS]:🔥 Command excetued succesfully! Bye 👋 \x1B[32m\n");
  }

  static Future<bool> _isKeyUsedInLib(String key) async {
    try {
      await for (var entity in Directory('lib').list(recursive: true)) {
        if (entity is File) {
          if (entity.path.contains('/.')) {
            continue;
          }
          String content = "";
          try {
            content = await entity.readAsString();
          } catch (e) {
            ExceptionHandler.returnException(e);
            continue;
          }
          if (content.contains(key)) {
            return true;
          }
        }
      }
      return false;
    } catch (e) {
      ExceptionHandler.returnException(e);
    }
    return false;
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
    try {
      Map<String, String>? jsonStrings;

      Map<String, dynamic> jsonAsMap = jsonDecode(jsonAsString);

      jsonStrings = jsonAsMap.map((key, value) {
        return MapEntry(key, value.toString());
      });

      return jsonStrings;
    } catch (e) {
      ExceptionHandler.returnException(e);
    }
    return {};
  }
}
