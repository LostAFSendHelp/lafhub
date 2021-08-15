import 'package:get/get.dart';
import 'package:lafhub/datasources/oauth2_client.dart';
import 'package:lafhub/lafhub_entities.dart';
import 'package:lafhub/lafhub_utils.dart';

abstract class ExploreRepoExpected {
  Future<Either<List<GHRepository>, Failure>> getRepositories({
    required String query,
    required bool append,
  });
}

class ExploreReposity implements ExploreRepoExpected {
  final _oauth2Client = Get.find<OAuth2Client>();
  String? _cursor;

  @override
  Future<Either<List<GHRepository>, Failure>> getRepositories({
    required String query,
    required bool append,
  }) async {
    if (!append) {
      _cursor = null;
    }

    return await _oauth2Client.getRepositories(
      query: query,
      cursor: _cursor,
      cursorCallback: (cursor) => _cursor = cursor,
    );
  }
}
