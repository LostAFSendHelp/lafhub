class GHLanguage {
  final String name;
  final String colorHex;

  GHLanguage({
    required this.name,
    required this.colorHex,
  });

  GHLanguage.fromJson(Map<String, dynamic> data)
      : name = data["name"],
        colorHex = data["color"];
}
