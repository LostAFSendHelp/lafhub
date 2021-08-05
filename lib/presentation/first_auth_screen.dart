import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:lafhub/lafhub_repositories.dart';
import 'package:lafhub/controllers/first_auth_controller.dart';

class FirstAuthScreen extends GetView<FirstAuthScreenController> {
  FirstAuthScreen({required AuthRepoExpected repo}) : super() {
    Get.put(repo);
    Get.put(FirstAuthScreenController());
  }

  @override
  Widget build(BuildContext context) {
    controller.getAuth();

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(20),
        child: controller.obx(
          (state) => Text("Redirecting..."),
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
          onPressed: () => controller.login(),
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
}
