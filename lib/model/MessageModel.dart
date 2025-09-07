import 'package:fils/model/RoomModel.dart';

class MessageModel {
  final int id;
  final int? roomId;
  final int userId;
  final String content;
  final String messageType;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final UserModel? user;

  MessageModel({
    required this.id,
    this.roomId,
    required this.userId,
    required this.content,
    required this.messageType,
    required this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] ?? 0,
      roomId: json['roomId'],
      userId: json['userId'] ?? 0,
      content: json['content'] ?? '',
      messageType: json['messageType'] ?? 'text',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomId': roomId,
      'userId': userId,
      'content': content,
      'messageType': messageType,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'user': user?.toJson(),
    };
  }
}

class RoomResponseModel {
  final List<RoomModel> rooms;
  final int total;
  final int currentPage;
  final int totalPages;

  RoomResponseModel({
    required this.rooms,
    required this.total,
    required this.currentPage,
    required this.totalPages,
  });

  factory RoomResponseModel.fromJson(Map<String, dynamic> json) {
    return RoomResponseModel(
      rooms: (json['rooms'] as List).map((room) => RoomModel.fromJson(room)).toList(),
      total: json['total'],
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
    );
  }
}

class MessageResponseModel {
  final List<MessageModel> messages;
  final int total;
  final int currentPage;
  final int totalPages;

  MessageResponseModel({
    required this.messages,
    required this.total,
    required this.currentPage,
    required this.totalPages,
  });

  factory MessageResponseModel.fromJson(Map<String, dynamic> json) {
    return MessageResponseModel(
      messages: (json['messages'] as List).map((message) => MessageModel.fromJson(message)).toList(),
      total: json['total'],
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
    );
  }
}
