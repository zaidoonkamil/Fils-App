class AdminUserCounterModel {
  int id;
  int userId;
  int counterId;
  int points;
  String type;
  int price;
  DateTime startDate;
  DateTime endDate;
  bool isForSale;
  AdminCounterModel? counter;

  AdminUserCounterModel({
    required this.id,
    required this.userId,
    required this.counterId,
    required this.points,
    required this.type,
    required this.price,
    required this.startDate,
    required this.endDate,
    required this.isForSale,
    this.counter,
  });

  factory AdminUserCounterModel.fromJson(Map<String, dynamic> json) {
    return AdminUserCounterModel(
      id: json["id"] ?? 0,
      userId: json["userId"] ?? 0,
      counterId: json["counterId"] ?? 0,
      points: json["points"] ?? 0,
      type: json["type"] ?? "",
      price: json["price"] ?? 0,
      startDate: DateTime.parse(
        json["startDate"] ?? DateTime.now().toIso8601String(),
      ),
      endDate: DateTime.parse(
        json["endDate"] ?? DateTime.now().toIso8601String(),
      ),
      isForSale: json["isForSale"] ?? false,
      counter:
          json["Counter"] != null
              ? AdminCounterModel.fromJson(json["Counter"])
              : null,
    );
  }
}

class AdminCounterModel {
  int id;
  String type;
  int points;
  int price;
  bool isActive;

  AdminCounterModel({
    required this.id,
    required this.type,
    required this.points,
    required this.price,
    required this.isActive,
  });

  factory AdminCounterModel.fromJson(Map<String, dynamic> json) {
    return AdminCounterModel(
      id: json["id"] ?? 0,
      type: json["type"] ?? "",
      points: json["points"] ?? 0,
      price: json["price"] ?? 0,
      isActive: json["isActive"] ?? true,
    );
  }
}

class AdminTransferHistoryModel {
  int id;
  int senderId;
  int receiverId;
  double amount;
  double fee;
  DateTime createdAt;
  AdminUserSimpleModel? sender;
  AdminUserSimpleModel? receiver;

  AdminTransferHistoryModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.amount,
    required this.fee,
    required this.createdAt,
    this.sender,
    this.receiver,
  });

  factory AdminTransferHistoryModel.fromJson(Map<String, dynamic> json) {
    return AdminTransferHistoryModel(
      id: json["id"] ?? 0,
      senderId: json["senderId"] ?? 0,
      receiverId: json["receiverId"] ?? 0,
      amount: (json["amount"] ?? 0).toDouble(),
      fee: (json["fee"] ?? 0).toDouble(),
      createdAt: DateTime.parse(
        json["createdAt"] ?? DateTime.now().toIso8601String(),
      ),
      sender:
          json["sender"] != null
              ? AdminUserSimpleModel.fromJson(json["sender"])
              : null,
      receiver:
          json["receiver"] != null
              ? AdminUserSimpleModel.fromJson(json["receiver"])
              : null,
    );
  }
}

class AdminWithdrawalRequestModel {
  int id;
  int userId;
  double amount;
  String method;
  String accountNumber;
  String status;
  DateTime createdAt;
  AdminUserSimpleModel? user;

  AdminWithdrawalRequestModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.method,
    required this.accountNumber,
    required this.status,
    required this.createdAt,
    this.user,
  });

  factory AdminWithdrawalRequestModel.fromJson(Map<String, dynamic> json) {
    return AdminWithdrawalRequestModel(
      id: json["id"] ?? 0,
      userId: json["userId"] ?? 0,
      amount: (json["amount"] ?? 0).toDouble(),
      method: json["method"] ?? "",
      accountNumber: json["accountNumber"] ?? "",
      status: json["status"] ?? "",
      createdAt: DateTime.parse(
        json["createdAt"] ?? DateTime.now().toIso8601String(),
      ),
      user:
          json["user"] != null
              ? AdminUserSimpleModel.fromJson(json["user"])
              : null,
    );
  }
}

class AdminUserDetailModel {
  int id;
  String name;
  String email;
  String phone;
  String location;
  String role;
  bool isActive;
  bool isVerified;
  int sawa;
  int jewel;
  int card;
  DateTime createdAt;
  DateTime updatedAt;
  List<AdminUserCounterModel> userCounters;
  List<AdminTransferHistoryModel> transferHistory;
  List<AdminWithdrawalRequestModel> withdrawalRequests;

  AdminUserDetailModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.role,
    required this.isActive,
    required this.isVerified,
    required this.sawa,
    required this.jewel,
    required this.card,
    required this.createdAt,
    required this.updatedAt,
    required this.userCounters,
    required this.transferHistory,
    required this.withdrawalRequests,
  });

  factory AdminUserDetailModel.fromJson(Map<String, dynamic> json) {
    return AdminUserDetailModel(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      location: json["location"] ?? "",
      role: json["role"] ?? "",
      isActive: json["isActive"] ?? false,
      isVerified: json["isVerified"] ?? false,
      sawa: json["sawa"] ?? 0,
      jewel: json["Jewel"] ?? 0,
      card: json["card"] ?? 0,
      createdAt: DateTime.parse(
        json["createdAt"] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json["updatedAt"] ?? DateTime.now().toIso8601String(),
      ),
      userCounters:
          (json["userCounters"] as List? ?? [])
              .map((counter) => AdminUserCounterModel.fromJson(counter))
              .toList(),
      transferHistory:
          (json["transferHistory"] as List? ?? [])
              .map((transfer) => AdminTransferHistoryModel.fromJson(transfer))
              .toList(),
      withdrawalRequests:
          (json["withdrawalRequests"] as List? ?? [])
              .map((request) => AdminWithdrawalRequestModel.fromJson(request))
              .toList(),
    );
  }
}

class AdminUserSimpleModel {
  int id;
  String name;
  String email;
  String phone;
  String location;
  String role;

  AdminUserSimpleModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.role,
  });

  factory AdminUserSimpleModel.fromJson(Map<String, dynamic> json) {
    return AdminUserSimpleModel(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      location: json["location"] ?? "",
      role: json["role"] ?? "",
    );
  }
}

class AdminDepositModel {
  int userId;
  double amount;
  String type; // 'sawa', 'jewel', 'card'

  AdminDepositModel({
    required this.userId,
    required this.amount,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {"userId": userId, "amount": amount, "type": type};
  }
}
