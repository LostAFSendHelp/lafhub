import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:lafhub/controllers/main_navi_controller.dart';
import 'package:lafhub/lafhub_repositories.dart';

class MainNavigationScreen extends GetView<MainNavigationController> {
  MainNavigationScreen({required MainNavigationRepoExpected repo}) : super() {
    Get.put(repo);
    Get.put(MainNavigationController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller.pageController,
        scrollDirection: Axis.horizontal,
        children: controller.pages,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          items: controller.bottomNavItems,
          currentIndex: controller.currentIndex,
          onTap: (index) => controller.selectIndex(index),
        ),
      ),
    );
  }
}
