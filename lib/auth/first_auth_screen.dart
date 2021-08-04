import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:lafhub/auth/auth_repo.dart';
import 'package:lafhub/models/gh_user_profile.dart';

class FirstAuthScreenController extends GetxController
    with StateMixin<GHUserProfile> {
  final _repo = Get.find<AuthRepoExpected>();

  @override
  void onReady() async {
    super.onReady();
    debugPrint("Super dumdum $runtimeType onReady()");
    change(null, status: RxStatus.loading());
    final result = await _repo.getAuth();
    result.fold(
      onLeft: (profile) => change(
        profile,
        status: RxStatus.success(),
      ),
      onRight: (failure) => change(
        null,
        status: RxStatus.error(failure.description),
      ),
    );
  }
}

class FirstAuthScreenScreen extends GetView<FirstAuthScreenController> {
  @override
  Widget build(BuildContext context) {
    Get.put(FirstAuthScreenController());

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(20),
        child: controller.obx(
          (state) => _profileView(state!),
          onEmpty: _loginView(),
          onLoading: _loadingView(null),
          onError: _errorView,
        ),
      ),
    );
  }

  Widget _loginView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Login now or u ded",
          textAlign: TextAlign.center,
        ),
        OutlinedButton(
          onPressed: () => debugPrint("suck my dick"),
          child: Text("Suck dick now"),
        ),
      ],
    );
  }

  Widget _loadingView(String? info) {
    final children = <Widget>[
      Text(
        "Checking for login status before allowing u to suck dick",
        textAlign: TextAlign.center,
      ),
      Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      CircularProgressIndicator(),
    ];

    if (info != null) {
      children.insert(
        1,
        Text(
          "Info: \n[$info]",
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  Widget _errorView(String? message) {
    return Center(
      child: Text(
        "Error happened U dumbshit\n [${message ?? "UNKNOWN"}]",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.red),
      ),
    );
  }

  Widget _profileView(GHUserProfile profile) {
    return Center(
      child: Column(
        children: [
          Text("login: ${profile.login}"),
          Text("avatar URL: ${profile.avatarUrl}"),
          Text("email: ${profile.email}"),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
    );
  }
}
