import 'package:get/get.dart';
import 'package:lafhub/lafhub_datasources.dart';
import 'package:lafhub/lafhub_utils.dart';
import 'package:lafhub/lafhub_entities.dart';

// interface
abstract class LoginRepoExpected {
  OAuth2ClientConfigs getOAuth2ClientConfigs();
  Future<Either<GHUserProfile, Failure>> processCallback(String callback);
}

// mock
class LoginRepoMock implements LoginRepoExpected {
  final _clientConfigs = OAuth2ClientConfigs(
    authUrl: "chuongdeptrai",
    tokenUrl: "lostafsendhelp",
    callbackUrl: "superdumdum",
  );

  final _profile = GHUserProfile(
    login: "chuongdeptrai",
    avatarUrl: "lostafsendhelp",
    email: "superBIGdumdum",
  );

  var returnError = false;

  @override
  OAuth2ClientConfigs getOAuth2ClientConfigs() {
    return _clientConfigs;
  }

  @override
  Future<Either<GHUserProfile, Failure>> processCallback(
      String callback) async {
    await 1.delay();
    return returnError
        ? Right(value: Failure("Super dumdum error", null))
        : Left(value: _profile);
  }
}

// impl
class LoginRepository implements LoginRepoExpected {
  final OAuth2ClientExpected _oauth2Client = Get.find<OAuth2ClientExpected>();
  final LocalStorageExpected _localStorage = Get.find<LocalStorageExpected>();

  @override
  OAuth2ClientConfigs getOAuth2ClientConfigs() {
    return _oauth2Client.getClientConfigs();
  }

  @override
  Future<Either<GHUserProfile, Failure>> processCallback(
      String callback) async {
    // process callback url for auth token and exchange for access token
    final tokenResult = await _oauth2Client.processCallback(callback);
    String? _token;
    Failure? _failure;

    tokenResult.fold(
      onLeft: (accessToken) => _token = accessToken,
      onRight: (failure) => _failure = failure,
    );

    if (_token == null) {
      return Right(value: _failure!);
    }

    _oauth2Client.setAccessToken(_token!);
    final fetchResult = await _oauth2Client.getUserProfile();
    GHUserProfile? _profile;
    fetchResult.fold(
      onLeft: (profile) => _profile = profile,
      onRight: (failure) => _failure = failure,
    );

    if (_profile != null) {
      _localStorage.setString(_token!, key: PrefKeys.ACCESS_TOKEN);
      return Left(value: _profile!);
    } else {
      return Right(value: _failure!);
    }
  }
}
