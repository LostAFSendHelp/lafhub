import 'package:get/get.dart';
import 'package:lafhub/lafhub_repositories.dart';
import 'package:lafhub/lafhub_screens.dart';

class SplashScreenController extends GetxController {
  void countDownAndNavigate() async {
    await 2.delay();
    Get.offAll(
      () => FirstAuthScreen(repo: AuthRepository()),
      transition: Transition.rightToLeft,
    );
  }
}
