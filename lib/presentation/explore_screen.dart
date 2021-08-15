import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lafhub/controllers/explore_controller.dart';

class ExploreScreen extends GetView<ExploreController> {
  ExploreScreen({Key? key}) : super(key: key) {
    Get.put(ExploreController());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.only(top: 50, bottom: 20, left: 20, right: 20),
          child: CupertinoSearchTextField(
            controller: controller.searchFieldController,
            placeholder: "Search keyword...",
            onSubmitted: (query) => debugPrint("QUERY: $query"),
          ),
        ),
      ],
    );
  }
}
