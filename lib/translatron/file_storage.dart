import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:translatron/translatron.dart';

class FileStorage {
  ///Method loads the selected [Locale] from Assets, and updates it if there is any newer version via api
  static Future<Map<String, String>?> loadLanguage(Locale locale) async {
    final Directory baseDirectory = await getApplicationDocumentsDirectory();

    //Overwrite the default loading, if in debug overwrite the local assets
    if (Translatron.reLoadAtStart == true) {
      //if it doesnt exists, read the default asset file, save it locally and convert it into map, return the value
      String jsonAsString =
          await rootBundle.loadString("lang/${locale.languageCode}.json");

      File file =
          await File('${baseDirectory.path}/lang/${locale.languageCode}.json')
              .create(recursive: true); //try catch to add
      file.writeAsString(jsonAsString);
      Map<String, String> convertedJson = _convertStringToJson(jsonAsString);
      return convertedJson;
    } else {
      //Checking if lang file exists
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

        //TODO CHECK FOR UPDATE
        //TODO REFRESH IF UPDATE AVAILABLE
        File file =
            await File('${baseDirectory.path}/lang/${locale.languageCode}.json')
                .create(recursive: true); //try catch to add
        file.writeAsString(jsonAsString);
        Map<String, String> convertedJson = _convertStringToJson(jsonAsString);
        return convertedJson;
      }
    }
  }

  ///Method writes a json [String] to the selected [Locale], in the [ApplicationDocumentsDirectory]
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
