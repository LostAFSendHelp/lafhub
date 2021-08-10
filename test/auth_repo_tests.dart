import 'package:get/get.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lafhub/datasources/local_storage.dart';
import 'package:lafhub/datasources/oauth2_client.dart';
import 'package:lafhub/entities/gh_user_profile.dart';
import 'package:lafhub/lafhub_repositories.dart';
import 'package:lafhub/lafhub_utils.dart';
import 'package:mockito/mockito.dart';
import 'mocks/lafhub_mocks.dart';

void main() {
  final _localStorage = MockLocalStorageExpected();
  final _client = MockOAuth2ClientExpected();
  Get.put<LocalStorageExpected>(_localStorage);
  Get.put<OAuth2ClientExpected>(_client);
  final _repo = AuthRepository();

  group('test AuthRepository getAuth', () {
    test("returns null if no token is found", () async {
      when(_localStorage.getString(key: PrefKeys.ACCESS_TOKEN))
          .thenReturn(null);

      final _result = await _repo.getAuth();
      expect(_result.left(), null);
      expect(_result.right(), null);
    });

    test("returns failure if client returns failure", () async {
      String? _token;

      when(_localStorage.getString(key: PrefKeys.ACCESS_TOKEN))
          .thenAnswer((realInvocation) {
        _token = "super token";
        return _token;
      });

      when(_localStorage.remove(key: PrefKeys.ACCESS_TOKEN))
          .thenAnswer((realInvocation) async => true);

      when(_client.getUserProfile()).thenAnswer(
        (realInvocation) async => Right(value: Failure("super error", null)),
      );

      final _result = await _repo.getAuth();
      expect(_token, "super token");
      expect(_result.left(), null);
      expect(_result.right()?.description, "super error");
    });

    test("returns profile if client returns profile", () async {
      String? _token;

      when(_localStorage.getString(key: PrefKeys.ACCESS_TOKEN))
          .thenAnswer((realInvocation) {
        _token = "super token";
        return _token;
      });

      when(_localStorage.remove(key: PrefKeys.ACCESS_TOKEN))
          .thenAnswer((realInvocation) async => true);

      when(_client.getUserProfile()).thenAnswer(
        (realInvocation) async => Left(
          value: GHUserProfile(
            login: "login",
            avatarUrl: "avatarUrl",
            email: "email",
          ),
        ),
      );

      final _result = await _repo.getAuth();
      expect(_token, "super token");
      expect(_result.left()?.avatarUrl, "avatarUrl");
    });
  });
}
