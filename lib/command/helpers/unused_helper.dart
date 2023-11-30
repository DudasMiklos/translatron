import 'dart:convert';
import 'dart:io';

class UnusedHelper {
  static Future<bool> isKeyUsedInLib(String key) async {
    await for (var entity in Directory('lib').list(recursive: true)) {
      if (entity is File) {
        String content = await entity.readAsString();
        if (content.contains(key)) {
          return true;
        }
      }
    }
    return false;
  }

  static Future<void> runUnused() async {
    int fileCountToSearch = 0;

    print(
        "\x1B[36m[NOTE]: Please \x1B[1mNOTE\x1B[0m\x1B[36m this command only runs on the JSON files, it \x1B[1mDOES NOT\x1B[0m\x1B[36m run on the device files!\x1B[36m\n");

    await for (var entity in Directory('lib').list(recursive: true)) {
      if (entity is File) {
        fileCountToSearch++;
      }
    }
    print("\x1B[35m[INFO]: Searching for project files\x1B[35m");
    print(
        "\x1B[35m[INFO]: \x1B[1m\x1B[39m$fileCountToSearch\x1B[0m\x1B[35m Files found in project\x1B[35m\n");

    List<String> detectedLanguages = [];
    await for (var fileEntity in Directory('lang').list(recursive: true)) {
      if (fileEntity is File) {
        String languageCode =
            fileEntity.path.split('/').last.split('.').first.toUpperCase();
        if (!detectedLanguages.contains(languageCode)) {
          detectedLanguages.add(languageCode);
        }
      }
    }

    print("\x1B[35m[INFO]: Searching for language files\x1B[35m");
    print(
        "\x1B[35m[INFO]: \x1B[1m\x1B[39m$detectedLanguages\x1B[0m\x1B[35m Language files found in project\x1B[35m\n");
    print(
        "\x1B[36m[NOTE]: Searching for unused language keys... (this could take 1-2 min, depending on your project and hardware)\x1B[36m\n");
    print("\x1B[32m[SUCCESS]: Searching finished successfully ✅ \x1B[32m\n");

    Map<String, List<String>> unusedStringMap = {};
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
          bool isKeyUsed = await isKeyUsedInLib(jsonKey);
          if (!isKeyUsed) {
            if (unusedStringMap.containsKey(jsonKey)) {
              unusedStringMap.update(jsonKey, (existingLanguages) {
                if (!existingLanguages.contains(languageCode)) {
                  existingLanguages.add(languageCode);
                }
                return existingLanguages;
              });
            } else {
              unusedStringMap[jsonKey] = [languageCode];
            }
          }
        }
      }
    }

    List<MapEntry<String, List<String>>> unusedSortedEntries =
        unusedStringMap.entries.toList();

    unusedSortedEntries
        .sort((a, b) => b.value.length.compareTo(a.value.length));

    Map<String, List<String>> unusedSortedMap =
        Map.fromEntries(unusedSortedEntries);

    int totalUnusedKeyCount = 0;
    unusedSortedMap.forEach((key, value) {
      print("\x1B[33m[WARNING]: UNUSED KEY FOUND IN : $value, KEY IS : $key");
      totalUnusedKeyCount += value.length;
    });
    if (totalUnusedKeyCount == 0) {
      print(
          "\n\x1B[32m[SUCCESS]:🔥 Congratulations your project does not contains any unnecessary translation keys! 🚀 🚀 \x1B[32m");
    } else {
      print(
          "\n\x1B[35m[INFO]: Found a total of \x1B[1m${unusedSortedMap.length}\x1B[0m\x1B[35m unused keys, in \x1B[1m${detectedLanguages.length}\x1B[0m\x1B[35m language files, with a total unused key count of \x1B[1m$totalUnusedKeyCount\x1B[0m\x1B[35m. \x1B[35m");
    }
    print(
        "\n\x1B[32m[SUCCESS]:🔥 Command excetued succesfully! Bye 👋 \x1B[32m\n");
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
