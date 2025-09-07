import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fils/core/network/remote/dio_helper.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../model/MessageModel.dart';
import '../model/RoomModel.dart';
import 'dart:async'; // Added for Timer

class SocketService {
  static IO.Socket? _socket;
  static String? _token;
  static int? _currentUserId;
  static String? _currentUserName;
  static int? _currentRoomId;
  
  // Callbacks
  static Function(String)? onConnected;
  static Function(String)? onDisconnected;
  static Function(Map<String, dynamic>)? onJoinedRoom;
  static Function(Map<String, dynamic>)? onUserJoined;
  static Function(Map<String, dynamic>)? onUserLeft;
  static Function(MessageModel)? onNewMessage;
  static Function(List<Map<String, dynamic>>)? onRoomUsers;
  static Function(Map<String, dynamic>)? onUserTyping;
  static Function(Map<String, dynamic>)? onError;

// ... existing code ...
  static void initialize(String token, int userId, String userName) {

    _token = token;
    _currentUserId = userId;
    _currentUserName = userName;

    // استخدام HTTP لأن الخادم يعمل على HTTP
    String socketUrl = 'https://fils.khaleeafashion.com';

    print('Socket URL: $socketUrl');
    print('Token: ${token.substring(0, 10)}...');
    print('User ID: $userId');
    print('User Name: $userName');


    _socket = IO.io(socketUrl, <String, dynamic>{
      'transports': [ 'websocket'],
      'autoConnect': false,
      'forceNew': true,
      'timeout': 20000,
      'auth': {
        'token': token,
      },
      'query': {
        'userId': userId.toString(),
        'userName': userName,
      },
    });

    _setupEventListeners();
  }

// ... existing code ...

    static void _setupEventListeners() {
      if (_socket == null) return;

      // إضافة معالجات إضافية للتشخيص
      _socket!.onConnect((_) {
        print('✅ Socket connected successfully');
        print('Socket ID: ${_socket!.id}');
        onConnected?.call('تم الاتصال بنجاح');
      });

      _socket!.onDisconnect((reason) {
        print('❌ Socket disconnected: $reason');
        onDisconnected?.call('انقطع الاتصال: $reason');
      });

      _socket!.onConnectError((error) {
        print('❌ Connection error: $error');
        onError?.call({'message': 'خطأ في الاتصال: $error'});
      });

      _socket!.onError((error) {
        print('❌ Socket general error: $error');
        onError?.call({'message': 'خطأ عام في الاتصال: $error'});
      });

      // إضافة معالج للأحداث العامة
      _socket!.onAny((event, data) {
        print('📡 Socket event received: $event with data: $data');
      });

      // معالج للمصادقة
      _socket!.on('authenticated', (data) {
        print('✅ Authentication successful: $data');
      });

      _socket!.on('auth_error', (data) {
        print('❌ Authentication failed: $data');
        onError?.call({'message': 'فشل في المصادقة: $data'});
      });

      // باقي الأحداث...
      _socket!.on('joined-room', (data) {
        print('Joined room: $data');
        _currentRoomId = data['roomId'];
        onJoinedRoom?.call(data);
      });

      _socket!.on('user-joined', (data) {
        print('User joined: $data');
        onUserJoined?.call(data);
      });

      _socket!.on('user-left', (data) {
        print('User left: $data');
        onUserLeft?.call(data);
      });

      _socket!.on('new-message', (data) {
        print('New message: $data');
        final message = MessageModel.fromJson(data);
        onNewMessage?.call(message);
      });

      _socket!.on('room-users', (data) {
        print('Room users: $data');
        final users = List<Map<String, dynamic>>.from(data);
        onRoomUsers?.call(users);
      });

      _socket!.on('user-typing', (data) {
        print('User typing: $data');
        onUserTyping?.call(data);
      });

      _socket!.on('error', (data) {
        print('Socket error: $data');
        onError?.call(data);
      });
    }

  static void connect() {
    print('🔄 Attempting to connect to socket...');
    print('Socket state before connect: ${_socket?.connected}');
    
    _socket?.connect();
    
    // إضافة timeout للاتصال
    Timer(Duration(seconds: 10), () {
      print('Socket state after 10 seconds: ${_socket?.connected}');
      if (!isConnected) {
        print('❌ Connection timeout after 10 seconds');
        onError?.call({'message': 'انتهت مهلة الاتصال'});
      } else {
        print('✅ Connection successful within timeout');
      }
    });
  }

  static void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }

  static void joinRoom(int roomId) {
    if (_socket != null && _socket!.connected) {
      _socket!.emit('join-room', roomId);
    }
  }

  static void leaveRoom(int roomId) {
    if (_socket != null && _socket!.connected) {
      _socket!.emit('leave-room', roomId);
      _currentRoomId = null;
    }
  }

  static void sendMessage(String content, {String messageType = 'text'}) {
    if (_socket != null && _socket!.connected && _currentRoomId != null) {
      _socket!.emit('send-message', {
        'roomId': _currentRoomId,
        'content': content,
        'messageType': messageType,
      });
    }
  }

  static void sendTyping(bool isTyping) {
    if (_socket != null && _socket!.connected && _currentRoomId != null) {
      _socket!.emit('typing', {
        'roomId': _currentRoomId,
        'isTyping': isTyping,
      });
    }
  }

  static bool get isConnected => _socket?.connected ?? false;
  static int? get currentRoomId => _currentRoomId;
  static int? get currentUserId => _currentUserId;
  static String? get currentUserName => _currentUserName;
}
