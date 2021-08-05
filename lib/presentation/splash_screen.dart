import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:lafhub/controllers/splash_controller.dart';

class SplashScreen extends GetView<SplashScreenController> {
  @override
  Widget build(BuildContext context) {
    Get.put(SplashScreenController());
    controller.countDownAndNavigate();

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
