import 'dart:convert';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lafhub/lafhub_datasources.dart';
import 'package:lafhub/lafhub_screens.dart';

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(await SharedPreferences.getInstance());

  final assetString = await rootBundle.loadString("assets/app_configs.json");
  final Map<String, dynamic> configsData = jsonDecode(assetString);
  final _client = OAuth2Client.fromJson(data: configsData["oauth2"]);

  Get.put<OAuth2ClientExpected>(_client, permanent: true);
  Get.put<LocalStorageExpected>(LocalStorage(), permanent: true);
}

void main() async {
  await init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: SplashScreen(),
    );
  }
}
