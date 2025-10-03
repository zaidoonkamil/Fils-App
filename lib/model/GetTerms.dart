// To parse this JSON data, do
//
//     final getTerms = getTermsFromJson(jsonString);

import 'dart:convert';

List<GetTerms> getTermsFromJson(String str) => List<GetTerms>.from(json.decode(str).map((x) => GetTerms.fromJson(x)));

String getTermsToJson(List<GetTerms> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetTerms {
  int id;
  String description;
  DateTime createdAt;
  DateTime updatedAt;

  GetTerms({
    required this.id,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GetTerms.fromJson(Map<String, dynamic> json) => GetTerms(
    id: json["id"],
    description: json["description"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "description": description,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}
