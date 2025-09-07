import 'dart:convert';

WithdrawalRequestModel withdrawalRequestModelFromJson(String str) => WithdrawalRequestModel.fromJson(json.decode(str));

String withdrawalRequestModelToJson(WithdrawalRequestModel data) => json.encode(data.toJson());

class WithdrawalRequestModel {
  List<Request> requests;

  WithdrawalRequestModel({
    required this.requests,
  });

  factory WithdrawalRequestModel.fromJson(Map<String, dynamic> json) => WithdrawalRequestModel(
    requests: List<Request>.from(json["requests"].map((x) => Request.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "requests": List<dynamic>.from(requests.map((x) => x.toJson())),
  };
}

class Request {
  int id;
  int userId;
  int amount;
  String method;
  String accountNumber;
  DateTime createdAt;
  DateTime updatedAt;
  User user;

  Request({
    required this.id,
    required this.userId,
    required this.amount,
    required this.method,
    required this.accountNumber,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory Request.fromJson(Map<String, dynamic> json) => Request(
    id: json["id"],
    userId: json["userId"],
    amount: json["amount"],
    method: json["method"],
    accountNumber: json["accountNumber"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "amount": amount,
    "method": method,
    "accountNumber": accountNumber,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "user": user.toJson(),
  };
}

class User {
  int id;
  String name;
  String phone;
  String location;
  String role;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.location,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
    location: json["location"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
    "location": location,
    "role": role,
  };
}
