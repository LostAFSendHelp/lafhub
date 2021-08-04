import 'package:lafhub/models/gh_user_profile.dart';
import 'package:lafhub/misc/misc.dart';
import 'package:get/get.dart';

abstract class AuthRepoExpected {
  Future<Either<GHUserProfile, Failure>> getAuth();
}

class AuthRepoMock extends AuthRepoExpected {
  final bool _shouldFail;

  AuthRepoMock({required bool shouldFail}) : _shouldFail = shouldFail;

  @override
  Future<Either<GHUserProfile, Failure>> getAuth() async {
    await 2.delay();
    if (_shouldFail) {
      return Right(value: GetAuthFailure(""));
    } else {
      return Left(
        value: GHUserProfile(
          login: "DumDum login",
          avatarUrl: "DumDum URL",
          email: "DumDum email",
        ),
      );
    }
  }
}

class GetAuthFailure extends Failure {
  static const _prefix = "GET_AUTH_FAILURE";
  GetAuthFailure(String description) : super("$_prefix : $description", null);
}
