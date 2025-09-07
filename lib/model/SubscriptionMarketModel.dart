import 'dart:convert';

List<SubscriptionMarketModel> subscriptionMarketModelFromJson(String str) => List<SubscriptionMarketModel>.from(json.decode(str).map((x) => SubscriptionMarketModel.fromJson(x)));

String subscriptionMarketModelToJson(List<SubscriptionMarketModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubscriptionMarketModel {
  int id;
  int userId;
  int userCounterId;
  int originalPoints;
  int pointsAfterCut;
  int price;
  int remainingDays;
  bool isSold;
  DateTime createdAt;
  DateTime updatedAt;
  User user;
  UserCounter userCounter;

  SubscriptionMarketModel({
    required this.id,
    required this.userId,
    required this.userCounterId,
    required this.originalPoints,
    required this.pointsAfterCut,
    required this.price,
    required this.isSold,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.remainingDays,
    required this.userCounter,
  });

  factory SubscriptionMarketModel.fromJson(Map<String, dynamic> json) => SubscriptionMarketModel(
    id: json["id"],
    userId: json["userId"],
    userCounterId: json["userCounterId"],
    originalPoints: json["originalPoints"],
    pointsAfterCut: json["pointsAfterCut"],
    price: json["price"],
    isSold: json["isSold"],
    remainingDays: json["remainingDays"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    user: User.fromJson(json["User"]),
    userCounter: UserCounter.fromJson(json["UserCounter"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "userCounterId": userCounterId,
    "originalPoints": originalPoints,
    "pointsAfterCut": pointsAfterCut,
    "price": price,
    "isSold": isSold,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "User": user.toJson(),
    "UserCounter": userCounter.toJson(),
  };
}

class User {
  int id;
  String name;

  User({
    required this.id,
    required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

class UserCounter {
  int id;
  int userId;
  int counterId;
  int points;
  String type;
  int price;
  DateTime startDate;
  DateTime endDate;
  bool isForSale;
  DateTime createdAt;
  DateTime updatedAt;
  Counter counter;

  UserCounter({
    required this.id,
    required this.userId,
    required this.counterId,
    required this.points,
    required this.type,
    required this.price,
    required this.startDate,
    required this.endDate,
    required this.isForSale,
    required this.createdAt,
    required this.updatedAt,
    required this.counter,
  });

  factory UserCounter.fromJson(Map<String, dynamic> json) => UserCounter(
    id: json["id"],
    userId: json["userId"],
    counterId: json["counterId"],
    points: json["points"],
    type: json["type"],
    price: json["price"],
    startDate: DateTime.parse(json["startDate"]),
    endDate: DateTime.parse(json["endDate"]),
    isForSale: json["isForSale"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    counter: Counter.fromJson(json["Counter"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "counterId": counterId,
    "points": points,
    "type": type,
    "price": price,
    "startDate": startDate.toIso8601String(),
    "endDate": endDate.toIso8601String(),
    "isForSale": isForSale,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "Counter": counter.toJson(),
  };
}

class Counter {
  int id;
  int points;
  String type;
  int price;
  bool isActive;
  DateTime createdAt;
  DateTime updatedAt;

  Counter({
    required this.id,
    required this.points,
    required this.type,
    required this.price,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Counter.fromJson(Map<String, dynamic> json) => Counter(
    id: json["id"],
    points: json["points"],
    type: json["type"],
    price: json["price"],
    isActive: json["isActive"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "points": points,
    "type": type,
    "price": price,
    "isActive": isActive,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}
