import 'dart:convert';
import 'package:oauth2/oauth2.dart' as oa2;
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:lafhub/lafhub_utils.dart';
import 'package:lafhub/lafhub_entities.dart';

class OAuth2ClientConfigs {
  final String authUrl;
  final String tokenUrl;
  final String callbackUrl;

  const OAuth2ClientConfigs({
    required this.authUrl,
    required this.tokenUrl,
    required this.callbackUrl,
  });
}

abstract class OAuth2ClientExpected {
  OAuth2ClientConfigs getClientConfigs();
  Future<Either<String, Failure>> processCallback(String callback);
  Future<Either<GHUserProfile, Failure>> getUserProfile();
  void setAccessToken(String token);
  void logOutUser();
}

class OAuth2ClientMock implements OAuth2ClientExpected {
  var returnFailure = false;

  @override
  OAuth2ClientConfigs getClientConfigs() {
    return OAuth2ClientConfigs(
      authUrl: "authUrl",
      tokenUrl: "tokenUrl",
      callbackUrl: "callbackUrl",
    );
  }

  @override
  Future<Either<GHUserProfile, Failure>> getUserProfile() async {
    if (returnFailure) {
      return Right(value: Failure("description", null));
    } else {
      return Left(
        value: GHUserProfile(
          login: "login",
          avatarUrl: "avatarUrl",
          email: "email",
        ),
      );
    }
  }

  @override
  Future<Either<String, Failure>> processCallback(String callback) async {
    return returnFailure
        ? Left(value: "token")
        : Right(
            value: Failure(
              "fail to parse token",
              null,
            ),
          );
  }

  @override
  void setAccessToken(String token) {}

  @override
  void logOutUser() {}
}

class OAuth2Client implements OAuth2ClientExpected {
  final String _clientID;
  final String _clientSecret;
  final String _authBaseUrl;
  final String _tokenUrl;
  final String _callbackBaseUrl;
  final String _scopes;
  final String _gqlEndpoint;

  Uri? _authUrl;

  oa2.AuthorizationCodeGrant? _grant;
  oa2.AuthorizationCodeGrant get _codeGrant => _grant!;
  GraphQLClient? _gql;
  GraphQLClient get _gqlClient => _gql!;

  OAuth2Client({
    required String clientID,
    required String clientSecret,
    required String authBaseUrl,
    required String tokenUrl,
    required String callbackUrl,
    required String scopes,
    required String gqlEndpoint,
  })  : _clientID = clientID,
        _clientSecret = clientSecret,
        _authBaseUrl = authBaseUrl,
        _tokenUrl = tokenUrl,
        _callbackBaseUrl = callbackUrl,
        _scopes = scopes,
        _gqlEndpoint = gqlEndpoint {
    _grant = _createGrant();
  }

  factory OAuth2Client.fromJson({required Map<String, dynamic> data}) {
    return OAuth2Client(
      clientID: data["client_id"],
      clientSecret: data["client_secret"],
      authBaseUrl: data["auth_base_url"],
      tokenUrl: data["auth_token_url"],
      callbackUrl: data["auth_base_callback"],
      scopes: data["scopes"],
      gqlEndpoint: data["gql_endpoint"],
    );
  }

  oa2.AuthorizationCodeGrant _createGrant() {
    return oa2.AuthorizationCodeGrant(
      _clientID,
      Uri.parse(_authBaseUrl),
      Uri.parse(_tokenUrl),
      secret: _clientSecret,
      basicAuth: false,
      getParameters: (contentType, body) {
        dynamic param;

        switch (contentType?.mimeType) {
          case "application/json":
            param = jsonDecode(body);
            break;
          case "application/x-www-form-urlencoded":
            param = Uri.splitQueryString(body);
            break;
          default:
            param = null;
        }

        if (param is Map<String, dynamic>) {
          return param;
        } else {
          throw FormatException(
              "Error parsing access token data, content type: ${contentType?.mimeType}");
        }
      },
    );
  }

  @override
  OAuth2ClientConfigs getClientConfigs() {
    if (_grant == null) {
      _grant = _createGrant();
    }

    if (_authUrl == null) {
      _authUrl = _codeGrant.getAuthorizationUrl(
        Uri.parse(_callbackBaseUrl),
        scopes: [_scopes],
      );
    }

    return OAuth2ClientConfigs(
      authUrl: _authUrl.toString(),
      tokenUrl: _tokenUrl,
      callbackUrl: _callbackBaseUrl,
    );
  }

  @override
  Future<Either<GHUserProfile, Failure>> getUserProfile() async {
    if (_gql == null) {
      return Right(value: NoClientFailure());
    }

    final _qString = '''
    query {
      viewer {
        login
        avatarUrl
        email
      }
    }
    ''';

    final result = await _gqlClient.query(
      QueryOptions(
        document: gql(_qString),
      ),
    );

    try {
      final Map<String, dynamic> data = result.data!["viewer"];
      return Left(value: GHUserProfile.fromJson(data));
    } catch (e) {
      return Right(value: GetUserProfileFailure(description: e.toString()));
    }
  }

  @override
  Future<Either<String, Failure>> processCallback(String callback) async {
    try {
      final _result = await _codeGrant
          .handleAuthorizationResponse(Uri.parse(callback).queryParameters);
      return Left(value: _result.credentials.accessToken);
    } catch (e) {
      return Right(value: Failure(e.toString(), null));
    }
  }

  @override
  void setAccessToken(String token) {
    if (_gql != null) return;
    final _httpLink = HttpLink(_gqlEndpoint);
    final _authLink = AuthLink(getToken: () => "token $token");
    final _link = _authLink.concat(_httpLink);
    _gql = GraphQLClient(link: _link, cache: GraphQLCache());
  }

  @override
  void logOutUser() {
    _grant = null;
    _gql = null;
    _authUrl = null;
  }
}

class NoClientFailure extends Failure {
  NoClientFailure() : super("No GQL client found", null);
}

class GetUserProfileFailure extends Failure {
  GetUserProfileFailure({String? description})
      : super("Failed to get User profile data ${description ?? ""}", null);
}
