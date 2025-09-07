// To parse this JSON data, do
//
//     final getUserModel = getUserModelFromJson(jsonString);

import 'dart:convert';

GetUserModel getUserModelFromJson(String str) => GetUserModel.fromJson(json.decode(str));

String getUserModelToJson(GetUserModel data) => json.encode(data.toJson());

class GetUserModel {
  int id;
  String name;
  String email;
  String phone;
  String location;
  String role;
  int jewel;
  int sawa;
  double dolar;
  DateTime createdAt;
  DateTime updatedAt;

  GetUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.role,
    required this.jewel,
    required this.sawa,
    required this.dolar,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GetUserModel.fromJson(Map<String, dynamic> json) => GetUserModel(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    location: json["location"],
    role: json["role"],
    jewel: json["Jewel"],
    sawa: json["sawa"],
    dolar: double.parse(json["dolar"].toString()),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "location": location,
    "role": role,
    "Jewel": jewel,
    "sawa": sawa,
    "dolar": dolar,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}
