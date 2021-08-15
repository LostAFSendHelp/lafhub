import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ExploreController extends GetxController {
  final TextEditingController searchFieldController;
  var _searchValue = "";
  Timer? _timer;

  ExploreController()
      : searchFieldController = TextEditingController(),
        super() {
    searchFieldController.addListener(() {
      _timer?.cancel();
      _timer = Timer(
        Duration(milliseconds: 700),
        () => _debounceSearch(query: searchFieldController.text),
      );
    });
  }

  void _debounceSearch({required String query}) async {
    if (query == _searchValue || query.isEmpty) {
      return;
    }

    _searchValue = query;
    debugPrint("QUERY: $_searchValue");
  }
}
