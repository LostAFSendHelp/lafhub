import 'package:get/get.dart';
import 'package:lafhub/entities/gh_user_profile.dart';
import 'package:lafhub/lafhub_datasources.dart';
import 'package:lafhub/lafhub_utils.dart';

abstract class MyProfileRepoExpected {
  Future<void> logoutUser();
  Future<Either<GHUserProfile, Failure>> getUserProfile();
}

class MyProfileRepository implements MyProfileRepoExpected {
  final _oauth2Client = Get.find<OAuth2ClientExpected>();
  final _localStorage = Get.find<LocalStorageExpected>();

  @override
  Future<void> logoutUser() async {
    _oauth2Client.logoutUser();
    await _localStorage.remove(key: PrefKeys.ACCESS_TOKEN);
  }

  @override
  Future<Either<GHUserProfile, Failure>> getUserProfile() async {
    final _result = await _oauth2Client.getUserProfile();
    Failure? _failure;
    GHUserProfile? _profile;

    _result.fold(
      onLeft: (profile) => _profile = profile,
      onRight: (failure) => _failure = failure,
    );

    if (_profile != null) {
      return Left(value: _profile!);
    } else {
      return Right(value: _failure!);
    }
  }
}
