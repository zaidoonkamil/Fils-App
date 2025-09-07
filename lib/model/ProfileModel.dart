import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  int id;
  String name;
  String email;
  String phone;
  String location;
  bool isVerified;
  String role;
  String note;
  int jewel;
  int totalPoints;
  int totalGems;
  int sawa;
  double dolar;
  DateTime createdAt;
  DateTime updatedAt;
  List<UserCounter> userCounters;

  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.isVerified,
    required this.phone,
    required this.location,
    required this.role,
    required this.jewel,
    required this.sawa,
    required this.totalPoints,
    required this.totalGems,
    required this.dolar,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
    required this.userCounters,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    location: json["location"],
    role: json["role"],
    jewel: json["Jewel"],
    isVerified: json["isVerified"],
    sawa: json["sawa"],
    note: json["note"]??'',
    totalPoints: json["totalPoints"],
    totalGems: json["totalGems"],
    dolar: double.parse(json["dolar"].toString()),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    userCounters: List<UserCounter>.from(json["UserCounters"].map((x) => UserCounter.fromJson(x))),
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
    "UserCounters": List<dynamic>.from(userCounters.map((x) => x.toJson())),
  };
}

class UserCounter {
  int id;
  int userId;
  int counterId;
  int remainingDays;
  int points;
  int price;
  bool isForSale;
  DateTime createdAt;
  DateTime updatedAt;
  Counter counter;
  List<CounterSale> counterSales;

  UserCounter({
    required this.id,
    required this.userId,
    required this.counterId,
    required this.points,
    required this.remainingDays,
    required this.price,
    required this.isForSale,
    required this.createdAt,
    required this.updatedAt,
    required this.counter,
    required this.counterSales,

  });

  factory UserCounter.fromJson(Map<String, dynamic> json) => UserCounter(
    id: json["id"],
    userId: json["userId"],
    counterId: json["counterId"],
    remainingDays: json["remainingDays"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    counterSales: json["CounterSales"] != null
        ? List<CounterSale>.from(json["CounterSales"].map((x) => CounterSale.fromJson(x)))
        : [],
    points: json["points"],
    price: json["price"],
    isForSale: json["isForSale"],
    counter: Counter.fromJson(json["Counter"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "counterId": counterId,
    "remainingDays": remainingDays,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "Counter": counter.toJson(),
  };
}

class CounterSale {
  int id;
  int userId;
  int userCounterId;
  int originalPoints;
  int pointsAfterCut;
  int price;
  bool isSold;
  DateTime createdAt;
  DateTime updatedAt;

  CounterSale({
    required this.id,
    required this.userId,
    required this.userCounterId,
    required this.originalPoints,
    required this.pointsAfterCut,
    required this.price,
    required this.isSold,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CounterSale.fromJson(Map<String, dynamic> json) => CounterSale(
    id: json["id"],
    userId: json["userId"],
    userCounterId: json["userCounterId"],
    originalPoints: json["originalPoints"],
    pointsAfterCut: json["pointsAfterCut"],
    price: json["price"],
    isSold: json["isSold"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
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
  };
}

class Counter {
  int id;
  int points;
  String type;
  int price;
  DateTime createdAt;
  DateTime updatedAt;

  Counter({
    required this.id,
    required this.points,
    required this.type,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Counter.fromJson(Map<String, dynamic> json) => Counter(
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
