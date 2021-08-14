import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:lafhub/entities/gh_user_profile.dart';
import 'package:lafhub/lafhub_repositories.dart';
import 'package:lafhub/controllers/my_profile_controller.dart';

class MyProfileScreen extends GetView<MyProfileScreenController> {
  MyProfileScreen({
    Key? key,
    required MyProfileRepoExpected repo,
  }) : super(key: key) {
    Get.put(repo);
    Get.put(MyProfileScreenController());
  }

  @override
  Widget build(BuildContext context) {
    controller.getUserProfile();
    return controller.obx(
      (profile) => _profileView(profile: profile!),
      onError: (error) => _errorView(error: error ?? "UNKNOWN"),
      onLoading: _loadingView(),
    );
  }

  Widget _profileView({required GHUserProfile profile}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.network(
                profile.avatarUrl,
                width: 200,
                height: 200,
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 30)),
          Text(
            "login: ${profile.login}",
            textAlign: TextAlign.center,
          ),
          Text(
            "email: ${profile.email}",
            textAlign: TextAlign.center,
          ),
          Padding(padding: EdgeInsets.only(top: 30)),
          Container(
            padding: EdgeInsets.all(30),
            child: OutlinedButton(
              onPressed: () => controller.logOutUser(),
              child: Text("Stop sucking dick"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _errorView({required String error}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Unexpected error: $error",
            style: TextStyle(color: Colors.red),
          ),
          Padding(padding: EdgeInsets.only(top: 30)),
          OutlinedButton(
            onPressed: () => controller.logOutUser(),
            child: Text("Stop sucking dick"),
          ),
        ],
      ),
    );
  }

  Widget _loadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          Padding(padding: EdgeInsets.only(top: 30)),
          Text("Loading profile..."),
        ],
      ),
    );
  }
}
