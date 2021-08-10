import 'package:get/get.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lafhub/lafhub_repositories.dart';
import 'package:lafhub/lafhub_datasources.dart';
import 'package:lafhub/lafhub_utils.dart';
import 'package:mockito/mockito.dart';
import 'mocks/lafhub_mocks.dart';

main() {
  final _localStorage = MockLocalStorageExpected();
  final _client = MockOAuth2ClientExpected();
  Get.put<LocalStorageExpected>(_localStorage);
  Get.put<OAuth2ClientExpected>(_client);
  final _repo = MyProfileRepository();

  group("test MyProfileRepository logOutUser", () {
    test("clears token and oauth2 client credentials", () async {
      bool _tokenRemoved = false;
      bool _clientLoggedOut = false;

      when(_localStorage.remove(key: PrefKeys.ACCESS_TOKEN))
          .thenAnswer((realInvocation) async => _tokenRemoved = true);

      when(_client.logoutUser())
          .thenAnswer((realInvocation) => _clientLoggedOut = true);

      await _repo.logoutUser();
      expect(_tokenRemoved, true);
      expect(_clientLoggedOut, true);
    });
  });
}
