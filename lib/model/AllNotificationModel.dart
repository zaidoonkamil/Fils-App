import 'dart:convert';

AllNotificationModel allNotificationModelFromJson(String str) => AllNotificationModel.fromJson(json.decode(str));

String allNotificationModelToJson(AllNotificationModel data) => json.encode(data.toJson());

class AllNotificationModel {
  Pagination pagination;
  List<Log> logs;

  AllNotificationModel({
    required this.pagination,
    required this.logs,
  });

  factory AllNotificationModel.fromJson(Map<String, dynamic> json) => AllNotificationModel(
    pagination: Pagination.fromJson({
      "totalOrders": json["total"],
      "totalPages": json["totalPages"],
      "currentPage": json["page"],
    }),
    logs: List<Log>.from(json["logs"].map((x) => Log.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total": pagination.total,
    "totalPages": pagination.totalPages,
    "page": pagination.page,
    "logs": List<dynamic>.from(logs.map((x) => x.toJson())),
  };
}

class Pagination {
  int total;
  int totalPages;
  int page;

  Pagination({
    required this.total,
    required this.totalPages,
    required this.page,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    total: json["total"] ?? 0,
    totalPages: json["totalPages"] ?? 1,
    page: json["page"] ?? 1,
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "totalPages": totalPages,
    "page": page,
  };
}


class Log {
  int id;
  String title;
  String message;
  String targetType;
  String targetValue;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  Log({
    required this.id,
    required this.title,
    required this.message,
    required this.targetType,
    required this.targetValue,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Log.fromJson(Map<String, dynamic> json) => Log(
    id: json["id"],
    title: json["title"],
    message: json["message"],
    targetType: json["target_type"],
    targetValue: json["target_value"],
    status: json["status"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
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
