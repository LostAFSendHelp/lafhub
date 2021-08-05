import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:lafhub/lafhub_repositories.dart';
import 'package:lafhub/controllers/login_controller.dart';

class LoginScreen extends GetView<LoginScreenController> {
  LoginScreen({required LoginRepoExpected repo}) : super() {
    Get.put(repo);
    Get.put(LoginScreenController());
  }

  @override
  Widget build(BuildContext context) {
    final _configs = controller.oauth2ClientConfigs;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Title(
          child: Text("Fucking login"),
          color: Colors.white,
        ),
      ),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: controller.oauth2ClientConfigs.authUrl,
        navigationDelegate: (navRequest) {
          if (navRequest.url.contains(_configs.callbackUrl)) {
            CookieManager().clearCookies();
            controller.processOAuth2Callback(navRequest.url);
            return NavigationDecision.prevent;
          } else {
            return NavigationDecision.navigate;
          }
        },
      ),
    );
  }
}
