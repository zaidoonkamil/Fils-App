class AdminAdsModel {
  int id;
  String title;
  String description;
  List<String> images;
  DateTime createdAt;
  DateTime updatedAt;

  AdminAdsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdminAdsModel.fromJson(Map<String, dynamic> json) {
    return AdminAdsModel(
      id: json["id"] ?? 0,
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      images: List<String>.from(json["images"] ?? []),
      createdAt: DateTime.parse(
        json["createdAt"] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json["updatedAt"] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "images": images,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }
}

class AdminCreateAdsModel {
  String title;
  String description;
  List<String> images;

  AdminCreateAdsModel({
    required this.title,
    required this.description,
    required this.images,
  });

  Map<String, dynamic> toJson() {
    return {"name": title, "description": description, "images": images};
  }
}
