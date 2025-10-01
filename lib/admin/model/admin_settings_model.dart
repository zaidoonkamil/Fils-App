class AdminSettingsModel {
  final int id;
  final String key;
  final String value;
  final String? description;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  AdminSettingsModel({
    required this.id,
    required this.key,
    required this.value,
    this.description,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdminSettingsModel.fromJson(Map<String, dynamic> json) {
    return AdminSettingsModel(
      id: json['id'] ?? 0,
      key: json['key'] ?? '',
      value: json['value'] ?? '',
      description: json['description'],
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'key': key,
      'value': value,
      'description': description,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  AdminSettingsModel copyWith({
    int? id,
    String? key,
    String? value,
    String? description,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AdminSettingsModel(
      id: id ?? this.id,
      key: key ?? this.key,
      value: value ?? this.value,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class AdminSettingsResponse {
  final String message;
  final AdminSettingsModel setting;

  AdminSettingsResponse({required this.message, required this.setting});

  factory AdminSettingsResponse.fromJson(Map<String, dynamic> json) {
    return AdminSettingsResponse(
      message: json['message'] ?? '',
      setting: AdminSettingsModel.fromJson(json['setting'] ?? {}),
    );
  }
}
