import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:lafhub/lafhub_entities.dart';
import 'package:lafhub/lafhub_repositories.dart';
import 'package:lafhub/controllers/my_profile_controller.dart';

class MyProfileScreen extends GetView<MyProfileScreenController> {
  final GHUserProfile _profile;

  MyProfileScreen({
    Key? key,
    required GHUserProfile profile,
    required MyProfileRepoExpected repo,
  })  : _profile = profile,
        super(key: key) {
    Get.put(repo);
    Get.put(MyProfileScreenController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Title(
          child: Text("My profile"),
          color: Colors.white,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  _profile.avatarUrl,
                  width: 200,
                  height: 200,
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 30)),
            Text(
              "login: ${_profile.login}",
              textAlign: TextAlign.center,
            ),
            Text(
              "email: ${_profile.email}",
              textAlign: TextAlign.center,
            ),
            Padding(padding: EdgeInsets.only(top: 30)),
            Container(
              padding: EdgeInsets.all(30),
              child: OutlinedButton(
                onPressed: () => controller.logOutUser(),
                child: Text("Stop sucking dick"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
