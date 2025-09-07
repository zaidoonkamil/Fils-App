import 'dart:convert';

List<GetIdShope> getIdShopeFromJson(String str) => List<GetIdShope>.from(json.decode(str).map((x) => GetIdShope.fromJson(x)));

String getIdShopeToJson(List<GetIdShope> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetIdShope {
  int id;
  int idForSale;
  int price;
  bool isAvailable;
  DateTime createdAt;
  DateTime updatedAt;

  GetIdShope({
    required this.id,
    required this.idForSale,
    required this.price,
    required this.isAvailable,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GetIdShope.fromJson(Map<String, dynamic> json) => GetIdShope(
    id: json["id"],
    idForSale: json["idForSale"],
    price: json["price"],
    isAvailable: json["isAvailable"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "idForSale": idForSale,
    "price": price,
    "isAvailable": isAvailable,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}
