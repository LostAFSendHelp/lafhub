import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lafhub/lafhub_repositories.dart';
import 'package:lafhub/lafhub_screens.dart';

enum NavigationPageType { feed, explore, profile }

extension NavTypeUI on NavigationPageType {
  Widget get page {
    switch (this) {
      case NavigationPageType.feed:
        return Center(
          child: Text("Feed"),
        );

      case NavigationPageType.explore:
        return Center(
          child: Text("Explore"),
        );

      case NavigationPageType.profile:
        return Center(
          child: MyProfileScreen(repo: MyProfileRepository()),
        );
    }
  }

  BottomNavigationBarItem get bottomNavItem {
    switch (this) {
      case NavigationPageType.feed:
        return BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: "Feed",
        );
      case NavigationPageType.explore:
        return BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: "Explore",
        );
      case NavigationPageType.profile:
        return BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Profile",
        );
    }
  }
}

class MainNavigationModel {
  final int initialIndex;
  final List<NavigationPageType> pageTypes;

  MainNavigationModel({
    required this.initialIndex,
    required this.pageTypes,
  });
}
