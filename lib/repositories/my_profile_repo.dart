import 'package:get/get.dart';
import 'package:lafhub/lafhub_datasources.dart';
import 'package:lafhub/lafhub_utils.dart';

abstract class MyProfileRepoExpected {
  Future<void> logoutUser();
}

class MyProfileRepository implements MyProfileRepoExpected {
  final _oauth2Client = Get.find<OAuth2ClientExpected>();
  final _localStorage = Get.find<LocalStorageExpected>();

  @override
  Future<void> logoutUser() async {
    _oauth2Client.logOutUser();
    await _localStorage.remove(key: PrefKeys.ACCESS_TOKEN);
  }
}
