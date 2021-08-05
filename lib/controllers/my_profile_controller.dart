import 'package:get/get.dart';
import 'package:lafhub/lafhub_screens.dart';
import 'package:lafhub/lafhub_repositories.dart';

class MyProfileScreenController extends GetxController {
  final _repo = Get.find<MyProfileRepoExpected>();

  void logOutUser() async {
    await _repo.logoutUser();
    Get.offAll(() => SplashScreen());
  }
}
