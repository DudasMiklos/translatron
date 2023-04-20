import 'package:translatron/translatron/api.dart';
import 'package:translatron/translatron/local_storage.dart';

class Utils {
  static late String _translationVersion;

  static String get getTranslationVersion {
    return _translationVersion;
  }

  static Future<bool> isNewVersionAvailable() async {
    final response = await Api.fetchTranslationVersion();
    _translationVersion = response["data"]["version"].toString();
    int latestVersionNumber = getExtendedVersionNumber(_translationVersion);

    final localVersion = await LocalStorage.loadLanguageVersion();
    int localVersionNumber = getExtendedVersionNumber(localVersion);

    return (localVersionNumber < latestVersionNumber);
  }

  static int getExtendedVersionNumber(String version) {
    // Note that if you want to support bigger version cells than 99,
    // just increase the returned versionCells multipliers
    List versionCells = version.split('.');
    versionCells = versionCells.map((i) => int.parse(i)).toList();
    return versionCells[0] * 10000 + versionCells[1] * 100 + versionCells[2];
  }
}
