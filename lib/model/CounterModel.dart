// To parse this JSON data, do
//
//     final counterModel = counterModelFromJson(jsonString);

import 'dart:convert';

List<CounterModel> counterModelFromJson(String str) => List<CounterModel>.from(json.decode(str).map((x) => CounterModel.fromJson(x)));

String counterModelToJson(List<CounterModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CounterModel {
  int id;
  int points;
  String type;
  int price;
  DateTime createdAt;
  DateTime updatedAt;

  CounterModel({
    required this.id,
    required this.points,
    required this.type,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CounterModel.fromJson(Map<String, dynamic> json) => CounterModel(
    id: json["id"],
    points: json["points"],
    type: json["type"],
    price: json["price"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "points": points,
    "type": type,
    "price": price,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}
