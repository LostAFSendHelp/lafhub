import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:lafhub/lafhub_repositories.dart';
import 'package:lafhub/lafhub_screens.dart';
import 'package:lafhub/lafhub_datasources.dart';

class LoginScreenController extends GetxController {
  final _repo = Get.find<LoginRepoExpected>();

  OAuth2ClientConfigs get oauth2ClientConfigs => _repo.getOAuth2ClientConfigs();

  void processOAuth2Callback(String callback) async {
    final result = await _repo.processCallback(callback);
    result.fold(
      onLeft: (profile) {
        Get.offAll(
          () => MainNavigationScreen(
            repo: MainNavigationRepository(),
          ),
          transition: Transition.rightToLeft,
        );
      },
      onRight: (failure) {
        Get.defaultDialog<void>(
          title: "Failure",
          content: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Center(child: Text(failure.description)),
                Padding(padding: EdgeInsets.only(top: 20)),
                OutlinedButton(
                  onPressed: () => Get.back(),
                  child: Text("OK"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
