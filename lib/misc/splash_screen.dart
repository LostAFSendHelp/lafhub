import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lafhub/auth/first_auth_screen.dart';

class SplashScreenController extends GetxController {
  @override
  void onReady() async {
    debugPrint("Super dumdum $runtimeType onReady()");
    await 2.delay();
    Get.off(() => FirstAuthScreenScreen());
  }
}

class SplashScreen extends GetView<SplashScreenController> {
  @override
  Widget build(BuildContext context) {
    Get.put(SplashScreenController());

    final body = Container(
      margin: EdgeInsets.all(20),
      child: Center(
        child: Text("Super Laf Hub incoming"),
      ),
    );

    return Scaffold(
      body: body,
    );
  }
}

class SuperRetarded extends StatelessWidget {
  const SuperRetarded({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final body = Container(
      margin: EdgeInsets.all(20),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );

    return Scaffold(
      body: body,
    );
  }
}
