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
  void logoutUser();
  Future<Either<List<GHRepository>, Failure>> getRepositories({
    required String query,
    String? cursor,
    void cursorCallback(String cursor)?,
  });
}

class OAuth2Client implements OAuth2ClientExpected {
  final String _clientID;
  final String _clientSecret;
  final String _authBaseUrl;
  final String _tokenUrl;
  final String _callbackBaseUrl;
  final String _scopes;
  final String _gqlEndpoint;
  GHUserProfile? _profile;

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
    if (_profile != null) {
      return Left(value: _profile!);
    }

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
      _profile = GHUserProfile.fromJson(data);
      return Left(value: _profile!);
    } catch (e) {
      return Right(value: GetUserProfileFailure(description: e.toString()));
    }
  }

  @override
  Future<Either<List<GHRepository>, Failure>> getRepositories({
    required String query,
    String? cursor,
    void cursorCallback(String cursor)?,
  }) async {
    if (_gql == null) {
      return Right(value: NoClientFailure());
    }

    final _cursor = cursor == null ? "null" : "\"$cursor\"";
    final _query = '''
    query { 
      search(first: 10, type: REPOSITORY, query: "$query", after: $_cursor) { 
        edges {
          cursor
          node {
            ... on Repository {
              name
              stargazerCount
              primaryLanguage {
                name
                color
              }
              owner {
                ... on User {
                  login
                  email
                  avatarUrl
                }
              }
            }
          }
        }
      }
    }
    ''';

    try {
      final _result = await _gqlClient.query(
        QueryOptions(
          document: gql(_query),
        ),
      );

      final _edgeData = _result.data!["edges"] as List<dynamic>;

      if (_edgeData.isEmpty) {
        return Left(value: []);
      }

      final _edges =
          _edgeData.map((e) => GHGQLEdge<GHRepository>.fromJson(e)).toList();
      final _list = _edges.map((e) => e.object).toList();
      final _cursor = _edges.last.cursor;
      cursorCallback?.call(_cursor);
      return Left(value: _list);
    } catch (e) {
      return Right(value: GetRepositoriesFailure());
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
  void logoutUser() {
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

class GetRepositoriesFailure extends Failure {
  GetRepositoriesFailure({String? description})
      : super("Failed to get Repositories ${description ?? ""}", null);
}
