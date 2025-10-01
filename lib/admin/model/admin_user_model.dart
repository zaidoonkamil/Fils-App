class AdminUserModel {
  int id;
  String name;
  String email;
  String phone;
  String location;
  String role;
  int jewel;
  int sawa;
  double dolar;
  bool isVerified;
  bool isActive;
  bool isLoggedIn;
  String? note;
  DateTime createdAt;
  DateTime updatedAt;

  AdminUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.role,
    required this.jewel,
    required this.sawa,
    required this.dolar,
    required this.isVerified,
    required this.isActive,
    required this.isLoggedIn,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdminUserModel.fromJson(Map<String, dynamic> json) {
    return AdminUserModel(
      id: json["id"] ?? 0,
      name: json["name"] ?? '',
      email: json["email"] ?? '',
      phone: json["phone"] ?? '',
      location: json["location"] ?? '',
      role: json["role"] ?? 'user',
      jewel: json["Jewel"] ?? 0,
      sawa: json["sawa"] ?? 0,
      dolar: double.parse((json["dolar"] ?? 0).toString()),
      isVerified: json["isVerified"] ?? false,
      isActive: json["isActive"] ?? true,
      isLoggedIn: json["isLoggedIn"] ?? false,
      note: json["note"] ?? '',
      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
          : DateTime.now(),
      updatedAt: json["updatedAt"] != null
          ? DateTime.parse(json["updatedAt"])
          : DateTime.now(),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "location": location,
      "role": role,
      "Jewel": jewel,
      "sawa": sawa,
      "dolar": dolar,
      "isVerified": isVerified,
      "isActive": isActive,
      "isLoggedIn": isLoggedIn,
      "note": note,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }
}

class AdminUserCreateModel {
  String name;
  String email;
  String phone;
  String location;
  String password;
  String role;
  String? note;

  AdminUserCreateModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.password,
    this.role = 'user',
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "phone": phone,
      "location": location,
      "password": password,
      "role": role,
      "note": note,
    };
  }
}

class AdminLoginModel {
  String email;
  String password;

  AdminLoginModel({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {"email": email, "password": password};
  }
}

class AdminLoginResponse {
  String message;
  AdminUserModel user;
  String token;

  AdminLoginResponse({
    required this.message,
    required this.user,
    required this.token,
  });

  factory AdminLoginResponse.fromJson(Map<String, dynamic> json) {
    return AdminLoginResponse(
      message: json["message"],
      user: AdminUserModel.fromJson(json["user"]),
      token: json["token"],
    );
  }
}
