import 'package:get/get.dart';
import 'package:lafhub/lafhub_datasources.dart';
import 'package:lafhub/lafhub_entities.dart';
import 'package:lafhub/lafhub_utils.dart';

abstract class AuthRepoExpected {
  Future<Either<GHUserProfile?, Failure>> getAuth();
}

enum GetAuthReturnType { success, failure, empty }

class AuthRepoMock extends AuthRepoExpected {
  final GetAuthReturnType _returnType;

  AuthRepoMock({required GetAuthReturnType returnType})
      : _returnType = returnType;

  @override
  Future<Either<GHUserProfile?, Failure>> getAuth() async {
    await 2.delay();
    switch (_returnType) {
      case GetAuthReturnType.success:
        return Left(
          value: GHUserProfile(
            login: "DumDum login",
            avatarUrl: "DumDum URL",
            email: "DumDum email",
          ),
        );
      case GetAuthReturnType.failure:
        return Right(value: GetAuthFailure(""));
      default:
        return Left(value: null);
    }
  }
}

class GetAuthFailure extends Failure {
  static const _prefix = "GET_AUTH_FAILURE";
  GetAuthFailure(String description) : super("$_prefix : $description", null);
}

class AuthRepository implements AuthRepoExpected {
  final _oauth2Client = Get.find<OAuth2ClientExpected>();
  final _localStorage = Get.find<LocalStorageExpected>();

  @override
  Future<Either<GHUserProfile?, Failure>> getAuth() async {
    final _token = _localStorage.getString(key: PrefKeys.ACCESS_TOKEN);

    if (_token == null) {
      return Left(value: null);
    }

    _oauth2Client.setAccessToken(_token);
    final result = await _oauth2Client.getUserProfile();
    GHUserProfile? _profile;
    Failure? _failure;

    result.fold(
      onLeft: (profile) => _profile = profile,
      onRight: (failure) => _failure = failure,
    );

    if (_profile == null) {
      await _localStorage.remove(key: PrefKeys.ACCESS_TOKEN);
      return Right(value: _failure!);
    }

    return Left(value: _profile);
  }
}
