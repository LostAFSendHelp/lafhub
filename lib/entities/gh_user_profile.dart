class GHUserProfile {
  final String login;
  final String avatarUrl;
  final String email;

  GHUserProfile({
    required this.login,
    required this.avatarUrl,
    required this.email,
  });

  GHUserProfile.fromJson(Map<String, dynamic> data)
      : login = data["login"],
        avatarUrl = data["avatarUrl"],
        email = data["email"];
}
