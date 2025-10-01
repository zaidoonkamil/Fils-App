class AdminNotificationLogModel {
  int id;
  String title;
  String message;
  String targetType;
  String targetValue;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  AdminNotificationLogModel({
    required this.id,
    required this.title,
    required this.message,
    required this.targetType,
    required this.targetValue,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdminNotificationLogModel.fromJson(Map<String, dynamic> json) {
    return AdminNotificationLogModel(
      id: json["id"] ?? 0,
      title: json["title"] ?? "",
      message: json["message"] ?? "",
      targetType: json["target_type"] ?? "",
      targetValue: json["target_value"] ?? "",
      status: json["status"] ?? "",
      createdAt: DateTime.parse(
        json["createdAt"] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json["updatedAt"] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "message": message,
      "target_type": targetType,
      "target_value": targetValue,
      "status": status,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }
}

class AdminNotificationResponseModel {
  int total;
  int page;
  int totalPages;
  List<AdminNotificationLogModel> logs;

  AdminNotificationResponseModel({
    required this.total,
    required this.page,
    required this.totalPages,
    required this.logs,
  });

  factory AdminNotificationResponseModel.fromJson(Map<String, dynamic> json) {
    return AdminNotificationResponseModel(
      total: json["total"] ?? 0,
      page: json["page"] ?? 1,
      totalPages: json["totalPages"] ?? 1,
      logs:
          (json["logs"] as List? ?? [])
              .map((log) => AdminNotificationLogModel.fromJson(log))
              .toList(),
    );
  }
}

class AdminSendNotificationModel {
  String title;
  String message;
  String? role;

  AdminSendNotificationModel({
    required this.title,
    required this.message,
    this.role,
  });

  Map<String, dynamic> toJson() {
    final data = {"title": title, "message": message};

    if (role != null) {
      data["role"] = role!;
    }

    return data;
  }
}
