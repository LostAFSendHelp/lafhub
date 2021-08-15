import 'package:lafhub/entities/gh_language.dart';
import 'package:lafhub/entities/gh_user_profile.dart';

class GHRepository {
  final String name;
  final int stars;
  final GHLanguage language;
  final GHUserProfile profile;

  GHRepository({
    required this.name,
    required this.stars,
    required this.language,
    required this.profile,
  });

  GHRepository.fromJson(Map<String, dynamic> data)
      : name = data["name"],
        stars = data["stargazerCount"],
        language = GHLanguage.fromJson(data["primaryLanguage"]),
        profile = GHUserProfile.fromJson(data["owner"]);
}
