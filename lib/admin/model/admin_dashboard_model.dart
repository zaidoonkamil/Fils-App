class AdminDashboardStats {
  int totalUsers;
  int totalAgents;
  int activeUsers;
  int totalSawa;
  int totalGems;
  int totalStoreItems;
  int availableStoreItems;
  String activePercentage;
  AdminDashboardExtra extra;

  AdminDashboardStats({
    required this.totalUsers,
    required this.totalAgents,
    required this.activeUsers,
    required this.totalSawa,
    required this.totalGems,
    required this.totalStoreItems,
    required this.availableStoreItems,
    required this.activePercentage,
    required this.extra,
  });

  factory AdminDashboardStats.fromJson(Map<String, dynamic> json) {
    return AdminDashboardStats(
      totalUsers: json["totalUsers"] ?? 0,
      totalAgents: json["totalAgents"] ?? 0,
      activeUsers: json["activeUsers"] ?? 0,
      totalSawa: json["totalSawa"] ?? 0,
      totalGems: json["totalGems"] ?? 0,
      totalStoreItems: json["totalStoreItems"] ?? 0,
      availableStoreItems: json["availableStoreItems"] ?? 0,
      activePercentage: json["activePercentage"] ?? "0.0",
      extra: AdminDashboardExtra.fromJson(json["extra"] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "totalUsers": totalUsers,
      "totalAgents": totalAgents,
      "activeUsers": activeUsers,
      "totalSawa": totalSawa,
      "totalGems": totalGems,
      "totalStoreItems": totalStoreItems,
      "availableStoreItems": availableStoreItems,
      "activePercentage": activePercentage,
      "extra": extra.toJson(),
    };
  }
}

class AdminDashboardExtra {
  int totalAdmins;
  int totalUsersOnly;
  int totalVerifiedUsers;
  int totalUnverifiedUsers;

  AdminDashboardExtra({
    required this.totalAdmins,
    required this.totalUsersOnly,
    required this.totalVerifiedUsers,
    required this.totalUnverifiedUsers,
  });

  factory AdminDashboardExtra.fromJson(Map<String, dynamic> json) {
    return AdminDashboardExtra(
      totalAdmins: json["totalAdmins"] ?? 0,
      totalUsersOnly: json["totalUsersOnly"] ?? 0,
      totalVerifiedUsers: json["totalVerifiedUsers"] ?? 0,
      totalUnverifiedUsers: json["totalUnverifiedUsers"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "totalAdmins": totalAdmins,
      "totalUsersOnly": totalUsersOnly,
      "totalVerifiedUsers": totalVerifiedUsers,
      "totalUnverifiedUsers": totalUnverifiedUsers,
    };
  }
}

class AdminUserStatusModel {
  int id;
  bool isActive;

  AdminUserStatusModel({required this.id, required this.isActive});

  Map<String, dynamic> toJson() {
    return {"isActive": isActive};
  }
}

class AdminUserGemsModel {
  int id;
  int gems;

  AdminUserGemsModel({required this.id, required this.gems});

  Map<String, dynamic> toJson() {
    return {"gems": gems};
  }
}

class AdminResetPasswordModel {
  String email;
  String newPassword;

  AdminResetPasswordModel({required this.email, required this.newPassword});

  Map<String, dynamic> toJson() {
    return {"email": email, "newPassword": newPassword};
  }
}
