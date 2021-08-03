import 'package:get/get.dart';
import 'package:flutter/material.dart';

class FirstAuthScreenController extends GetxController with StateMixin<String> {
  @override
  void onReady() async {
    super.onReady();
    debugPrint("Super dumdum $runtimeType onReady()");
    change("Shit", status: RxStatus.loadingMore());
    await 3.delay();
    change("Shit", status: RxStatus.empty());
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
          (state) => _loadingView(),
          onEmpty: _loginView(),
          onLoading: Center(
            child: CircularProgressIndicator(),
          ),
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

  Widget _loadingView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Checking for login status before allowing u to suck dick",
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: EdgeInsets.only(top: 30),
        ),
        CircularProgressIndicator(),
      ],
    );
  }
}
