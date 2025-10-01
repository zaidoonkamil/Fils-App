class AdminStoreModel {
  int id;
  int idForSale;
  int price;
  bool isAvailable;
  DateTime createdAt;
  DateTime updatedAt;

  AdminStoreModel({
    required this.id,
    required this.idForSale,
    required this.price,
    required this.isAvailable,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdminStoreModel.fromJson(Map<String, dynamic> json) {
    return AdminStoreModel(
      id: json["id"],
      idForSale: json["idForSale"],
      price: json["price"],
      isAvailable: json["isAvailable"],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "idForSale": idForSale,
      "price": price,
      "isAvailable": isAvailable,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }
}

class AdminStoreCreateModel {
  int idForSale;
  int price;

  AdminStoreCreateModel({required this.idForSale, required this.price});

  Map<String, dynamic> toJson() {
    return {"idForSale": idForSale, "price": price};
  }
}

class AdminStoreBuyModel {
  int shopId;
  int userId;

  AdminStoreBuyModel({required this.shopId, required this.userId});

  Map<String, dynamic> toJson() {
    return {"shopId": shopId, "userId": userId};
  }
}
