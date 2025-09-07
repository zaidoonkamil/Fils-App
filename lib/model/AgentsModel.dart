import 'dart:convert';

List<AgentsModel> agentsModelFromJson(String str) => List<AgentsModel>.from(json.decode(str).map((x) => AgentsModel.fromJson(x)));

String agentsModelToJson(List<AgentsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AgentsModel {
  int id;
  String name;
  String phone;
  String location;
  int sawa;
  String? note;
  DateTime createdAt;

  AgentsModel({
    required this.id,
    required this.name,
    required this.location,
    required this.phone,
    required this.sawa,
    required this.note,
    required this.createdAt,
  });

  factory AgentsModel.fromJson(Map<String, dynamic> json) => AgentsModel(
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
    location: json["location"],
    sawa: json["sawa"],
    note: json["note"],
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
    "sawa": sawa,
    "note": note,
    "createdAt": createdAt.toIso8601String(),
  };
}
