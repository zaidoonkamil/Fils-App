class RoomModel {
  final int id;
  final String name;
  final String description;
  final int creatorId;
  final int cost;
  final int maxUsers;
  final int currentUsers;
  final String category;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserModel? creator;

  RoomModel({
    required this.id,
    required this.name,
    required this.description,
    required this.creatorId,
    required this.cost,
    required this.maxUsers,
    required this.currentUsers,
    required this.category,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.creator,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      creatorId: json['creatorId'],
      cost: json['cost'],
      maxUsers: json['maxUsers'],
      currentUsers: json['currentUsers'],
      category: json['category'],
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      creator: json['creator'] != null ? UserModel.fromJson(json['creator']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'creatorId': creatorId,
      'cost': cost,
      'maxUsers': maxUsers,
      'currentUsers': currentUsers,
      'category': category,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'creator': creator?.toJson(),
    };
  }
}

class UserModel {
  final int id;
  final String name;

  UserModel({
    required this.id,
    required this.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
