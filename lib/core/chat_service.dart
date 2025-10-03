import 'dart:convert';
import 'package:fils/core/widgets/constant.dart';
import 'package:http/http.dart' as http;
import '../model/RoomModel.dart';
import '../model/MessageModel.dart';
import 'network/remote/dio_helper.dart';

class ChatService {
  static String baseUrl = url;
  static String? _token;

  static void setToken(String token) {
    _token = adminOrUser=='user'?token:'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTAwMTQsImVtYWlsIjoiYWRtaW4iLCJyb2xlIjoiYWRtaW4iLCJpYXQiOjE3NTkzOTg3NTgsImV4cCI6MTc4OTYzODc1OH0.Yc7kMcFS-C4VB2wjwblDFB4xqr2ez1cfHX2LihgTbZk';
  }

  static Map<String, String> get _headers {
    return {
      'Content-Type': 'application/json',
      if (_token != null) 'Authorization': 'Bearer $_token',
    };
  }

  // إنشاء غرفة جديدة
  static Future<Map<String, dynamic>> createRoom({
    required String name,
    required String description,
    required int cost,
    required int maxUsers,
    required String category,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create-room'),
        headers: _headers,
        body: jsonEncode({
          'name': name,
          'description': description,
          'cost': cost,
          'maxUsers': maxUsers,
          'category': category,
        }),
      );

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 201) {
        return {
          'success': true,
          'data': data,
        };
      } else {
        return {
          'success': false,
          'error': data['error'] ?? 'خطأ في إنشاء الغرفة',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'خطأ في الاتصال: $e',
      };
    }
  }

  // جلب الغرف المتوفرة
  static Future<Map<String, dynamic>> getRooms({
    String? category,
    int page = 1,
  }) async {
    try {
      String url = '$baseUrl/rooms?page=$page';
      if (category != null) {
        url += '&category=$category';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: _headers,
      );

      final data = jsonDecode(response.body);
      print('getRooms response body: ${response.body}');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': RoomResponseModel.fromJson(data),
        };
      } else {
        return {
          'success': false,
          'error': data['error'] ?? 'خطأ في جلب الغرف',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'خطأ في الاتصال: $e',
      };
    }
  }

  // جلب إعدادات الغرف
  static Future<Map<String, dynamic>> getRoomSettings() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/room-settings'),
        headers: _headers,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': {
            'room_creation_cost': data['room_creation_cost'],
            'room_max_users': data['room_max_users'],
          },
        };
      } else {
        return {
          'success': false,
          'error': data['error'] ?? 'خطأ في جلب الإعدادات',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'خطأ في الاتصال: $e',
      };
    }
  }

  // جلب تفاصيل غرفة معينة
  static Future<Map<String, dynamic>> getRoomDetails(int roomId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/room/$roomId'),
        headers: _headers,
      );

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': RoomModel.fromJson(data['room']),
        };
      } else {
        return {
          'success': false,
          'error': data['error'] ?? 'خطأ في جلب تفاصيل الغرفة',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'خطأ في الاتصال: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> getRoomMessages(
    int roomId, {
    int page = 1,
 //   int limit = 30,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/room/$roomId/messages?page=$page'),
        headers: _headers,
      );

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': MessageResponseModel.fromJson(data),
        };
      } else {
        return {
          'success': false,
          'error': data['error'] ?? 'خطأ في جلب الرسائل',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'خطأ في الاتصال: $e',
      };
    }
  }

  // حذف غرفة
  static Future<Map<String, dynamic>> deleteRoom(int roomId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/room/$roomId'),
        headers: _headers,
      );

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': data,
        };
      } else {
        return {
          'success': false,
          'error': data['error'] ?? 'خطأ في حذف الغرفة',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'خطأ في الاتصال: $e',
      };
    }
  }
}
