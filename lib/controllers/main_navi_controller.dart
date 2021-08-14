import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:lafhub/lafhub_repositories.dart';
import 'package:lafhub/lafhub_models.dart';

class MainNavigationController extends GetxController {
  final MainNavigationRepoExpected _repo;

  MainNavigationModel? _model;
  MainNavigationModel get model => _model!;

  final _currentIndex = (-1).obs;
  int get currentIndex => _currentIndex.value;

  List<Widget> get pages => model.pageTypes.map((e) => e.page).toList();

  List<BottomNavigationBarItem> get bottomNavItems =>
      model.pageTypes.map((e) => e.bottomNavItem).toList();

  MainNavigationController()
      : _repo = Get.find<MainNavigationRepoExpected>(),
        super() {
    _model = _repo.getNavModel();
    _currentIndex.value = model.initialIndex;
  }

  final _pageController = PageController(initialPage: 0);
  get pageController => _pageController;

  void selectIndex(int index) {
    if (index < 0 || index == currentIndex) {
      return;
    }

    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );

    _currentIndex.value = index;
  }
}
