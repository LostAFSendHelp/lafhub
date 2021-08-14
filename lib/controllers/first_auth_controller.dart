import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:lafhub/lafhub_entities.dart';
import 'package:lafhub/lafhub_repositories.dart';
import 'package:lafhub/lafhub_screens.dart';

class FirstAuthScreenController extends GetxController
    with StateMixin<GHUserProfile> {
  final _repo = Get.find<AuthRepoExpected>();

  void getAuth() async {
    super.onReady();
    debugPrint("Super dumdum $runtimeType onReady()");
    change(null, status: RxStatus.loading());
    final result = await _repo.getAuth();
    result.fold(
      onLeft: (profile) {
        if (profile != null) {
          _offToProfile(profile: profile);
          change(profile, status: RxStatus.success());
        } else {
          change(null, status: RxStatus.empty());
        }
      },
      onRight: (failure) => change(
        null,
        status: RxStatus.error(failure.description),
      ),
    );
  }

  void login() => Get.to(() => LoginScreen(repo: LoginRepository()));

  void _offToProfile({required GHUserProfile profile}) => Get.offAll(
        () => MainNavigationScreen(repo: MainNavigationRepository()),
        transition: Transition.rightToLeft,
      );
}
