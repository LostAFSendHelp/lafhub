import 'package:get/get.dart';
import 'package:lafhub/lafhub_screens.dart';
import 'package:lafhub/lafhub_repositories.dart';
import 'package:lafhub/lafhub_entities.dart';

class MyProfileScreenController extends GetxController
    with StateMixin<GHUserProfile> {
  final _repo = Get.find<MyProfileRepoExpected>();

  void logOutUser() async {
    await _repo.logoutUser();
    Get.offAll(() => SplashScreen());
  }

  void getUserProfile() async {
    change(null, status: RxStatus.loading());
    final _result = await _repo.getUserProfile();
    _result.fold(
      onLeft: (profile) => change(profile, status: RxStatus.success()),
      onRight: (failure) => change(
        null,
        status: RxStatus.error(failure.description),
      ),
    );
  }
}
