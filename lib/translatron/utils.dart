import 'package:translatron/exception/exception_handler.dart';
import 'package:translatron/exception/exceptions/wrong_api_response_exception.dart';
import 'package:translatron/translatron/api.dart';
import 'package:translatron/translatron/local_storage.dart';

class Utils {
  ///Stores the version of the translation
  static late String _translationVersion;

  ///Returns the version of the translation
  static String get getTranslationVersion {
    return _translationVersion;
  }

  ///Returns a [bool] appending to, is any newer versions available
  ///Throws a [WrongApiResponseException] if there is response status was not 200
  static Future<bool> isNewVersionAvailable() async {
    try {
      final response = await Api.fetchTranslationVersion();
      if (response == null) {
        throw WrongApiResponseException();
      }
      _translationVersion = response["data"]["version"].toString();
      int latestVersionNumber = getExtendedVersionNumber(_translationVersion);

      final localVersion = await LocalStorage.loadLanguageVersion();
      int localVersionNumber = getExtendedVersionNumber(localVersion);

      return (localVersionNumber < latestVersionNumber);
    } catch (e) {
      ExceptionHandler.returnException(e);
      _translationVersion = "0.0.0";
      return false;
    }
  }

  ///Removes the points from version code
  static int getExtendedVersionNumber(String version) {
    List versionCells = version.split('.');
    versionCells = versionCells.map((i) => int.parse(i)).toList();
    return versionCells[0] * 10000 + versionCells[1] * 100 + versionCells[2];
  }
}
