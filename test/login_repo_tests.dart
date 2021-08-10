import 'package:get/get.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lafhub/entities/gh_user_profile.dart';
import 'package:lafhub/lafhub_utils.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:lafhub/lafhub_repositories.dart';
import 'package:lafhub/lafhub_datasources.dart' as ds;
import 'mocks/lafhub_mocks.dart';

@GenerateMocks([ds.LocalStorageExpected, ds.OAuth2ClientExpected])
void main() {
  final _localStorage = MockLocalStorageExpected();
  final _client = MockOAuth2ClientExpected();
  Get.put<ds.LocalStorageExpected>(_localStorage);
  Get.put<ds.OAuth2ClientExpected>(_client);
  final _repo = LoginRepository();

  group("test getOAuth2ClientConfigs", () {
    test("return whatever client returns", () {
      when(_client.getClientConfigs()).thenReturn(
        ds.OAuth2ClientConfigs(
          authUrl: "auth",
          tokenUrl: "token",
          callbackUrl: "callback",
        ),
      );

      final _configs = _repo.getOAuth2ClientConfigs();
      expect(_configs.authUrl, "auth");
      expect(_configs.tokenUrl, "token");
      expect(_configs.callbackUrl, "callback");
    });
  });

  group("test processCallback", () {
    test("returns failure if client returns failure", () async {
      when(_client.processCallback("callback")).thenAnswer(
        (realInvocation) async =>
            Right(value: Failure("callback failure", null)),
      );

      var _result = await _repo.processCallback("callback");
      expect(_result.right()?.description, "callback failure");

      when(_client.processCallback("callback")).thenAnswer(
        (realInvocation) async => Left(value: "token"),
      );

      when(_client.getUserProfile()).thenAnswer(
        (realInvocation) async => Right(value: Failure("no profile", null)),
      );

      _result = await _repo.processCallback("callback");
      expect(_result.right()?.description, "no profile");
    });

    test("returns user profile when client returns profile", () async {
      String? _token;
      when(_localStorage.setString("token", key: PrefKeys.ACCESS_TOKEN))
          .thenAnswer((realInvocation) async {
        _token = "token";
        return true;
      });

      when(_client.processCallback("callback")).thenAnswer(
        (realInvocation) async => Left(value: "token"),
      );

      when(_client.getUserProfile()).thenAnswer(
        (realInvocation) async => Left(
          value: GHUserProfile(
            login: "login",
            avatarUrl: "avatarUrl",
            email: "email",
          ),
        ),
      );

      final _result = await _repo.processCallback("callback");
      expect(_result.left(), isNotNull);
      expect(_result.left()?.avatarUrl, "avatarUrl");
      await 0.1.delay(); // make sure _token isAlready set here
      expect(_token, "token");
    });
  });
}
