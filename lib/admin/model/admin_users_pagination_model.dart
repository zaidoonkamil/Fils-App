import 'package:fils/admin/model/admin_user_model.dart';

class AdminUsersPaginationModel {
  final int totalUsers;
  final int totalPages;
  final int currentPage;
  final List<AdminUserModel> users;

  AdminUsersPaginationModel({
    required this.totalUsers,
    required this.totalPages,
    required this.currentPage,
    required this.users,
  });

  factory AdminUsersPaginationModel.fromJson(Map<String, dynamic> json) {
    return AdminUsersPaginationModel(
      totalUsers: json['totalUsers'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      currentPage: json['currentPage'] ?? 1,
      users:
          (json['users'] as List)
              .map((userJson) => AdminUserModel.fromJson(userJson))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalUsers': totalUsers,
      'totalPages': totalPages,
      'currentPage': currentPage,
      'users': users.map((user) => user.toJson()).toList(),
    };
  }
}
