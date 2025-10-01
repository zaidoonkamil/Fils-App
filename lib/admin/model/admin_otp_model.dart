import 'admin_user_model.dart';

class AdminOtpGenerateModel {
  String email;

  AdminOtpGenerateModel({required this.email});

  Map<String, dynamic> toJson() {
    return {"email": email};
  }
}

class AdminOtpVerifyModel {
  String email;
  String code;

  AdminOtpVerifyModel({required this.email, required this.code});

  Map<String, dynamic> toJson() {
    return {"email": email, "code": code};
  }
}

class AdminOtpResponse {
  String message;
  AdminUserModel? user;

  AdminOtpResponse({required this.message, this.user});

  factory AdminOtpResponse.fromJson(Map<String, dynamic> json) {
    return AdminOtpResponse(
      message: json["message"],
      user: json["user"] != null ? AdminUserModel.fromJson(json["user"]) : null,
    );
  }
}
