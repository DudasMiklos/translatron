import 'package:translatron/translatron/api.dart';
import 'package:translatron/translatron/local_storage.dart';

class Utils {
  ///Stores the version of the translataion
  static late String _translationVersion;

  ///Returns the version of the translataion
  static String get getTranslationVersion {
    return _translationVersion;
  }

  ///Returns a [bool] appending to, is any newer versions available
  static Future<bool> isNewVersionAvailable() async {
    final response = await Api.fetchTranslationVersion();
    _translationVersion = response["data"]["version"].toString();
    int latestVersionNumber = getExtendedVersionNumber(_translationVersion);

    final localVersion = await LocalStorage.loadLanguageVersion();
    int localVersionNumber = getExtendedVersionNumber(localVersion);

    return (localVersionNumber < latestVersionNumber);
  }

  ///Removes the points from version code
  static int getExtendedVersionNumber(String version) {
    List versionCells = version.split('.');
    versionCells = versionCells.map((i) => int.parse(i)).toList();
    return versionCells[0] * 10000 + versionCells[1] * 100 + versionCells[2];
  }
}
