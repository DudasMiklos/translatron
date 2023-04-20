import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class FileStorage {
  static Future<Map<String, String>?> loadLanguage(Locale locale) async {
    final Directory baseDirectory = await getApplicationDocumentsDirectory();

    //Cheking if lang file exists
    bool fileExists =
        await File('${baseDirectory.path}/lang/${locale.languageCode}.json')
            .exists();
    if (fileExists) {
      //If exists, read it and convert it into map, return the value
      File file =
          File('${baseDirectory.path}/lang/${locale.languageCode}.json');
      String jsonAsString = await file.readAsString();
      return _convertStringToJson(jsonAsString);
    } else {
      //if it doesnt exists, read the default asset file, save it locally and convert it into map, return the value
      String jsonAsString =
          await rootBundle.loadString("lang/${locale.languageCode}.json");

      //TODOCHECHK FOR UPDATE
      //TODOREFRESH IF UPDATE AVAILABLE
      File file =
          await File('${baseDirectory.path}/lang/${locale.languageCode}.json')
              .create(recursive: true); //try cach to add
      file.writeAsString(jsonAsString);
      Map<String, String> convertedJson = _convertStringToJson(jsonAsString);
      return convertedJson;
    }
  }

  static Future<void> saveLanguage(Locale locale, String jsonAsString) async {
    final Directory baseDirectory = await getApplicationDocumentsDirectory();

    bool fileExists =
        await File('${baseDirectory.path}/lang/${locale.languageCode}.json')
            .exists();
    if (fileExists) {
      File file =
          File('${baseDirectory.path}/lang/${locale.languageCode}.json');
      file.writeAsString(jsonAsString);
    } else {
      File file =
          await File('${baseDirectory.path}/lang/${locale.languageCode}.json')
              .create(recursive: true); //try cach to add
      file.writeAsString(jsonAsString);
    }
  }

  static Map<String, String> _convertStringToJson(String jsonAsString) {
    Map<String, String>? jsonStrings;

    Map<String, dynamic> jsonAsMap = jsonDecode(jsonAsString);

    jsonStrings = jsonAsMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return jsonStrings;
  }
}
